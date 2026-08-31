// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include <algorithm>
#include <array>
#include <atomic>
#include <chrono>
#include <cstdlib>
#include <vector>
#include <boost/container/small_vector.hpp>
#include "common/alignment.h"
#include "common/assert.h"
#include "common/debug.h"
#include "common/div_ceil.h"
#include "common/range_lock.h"
#include "common/signal_context.h"
#include "core/memory.h"
#include "core/signals.h"
#include "video_core/page_manager.h"
#include "video_core/renderer_vulkan/vk_rasterizer.h"

#ifndef _WIN64
#include <sys/mman.h>
#include "common/adaptive_mutex.h"
#ifdef ENABLE_USERFAULTFD
#include <thread>
#include <fcntl.h>
#include <linux/userfaultfd.h>
#include <poll.h>
#include <sys/ioctl.h>
#include "common/error.h"
#endif
#else
#include <windows.h>
#include "common/spin_lock.h"
#endif

#ifdef __linux__
#include "common/adaptive_mutex.h"
#else
#include "common/spin_lock.h"
#endif

namespace VideoCore {

constexpr size_t PM_PAGE_SIZE = 4_KB;
constexpr size_t PM_PAGE_BITS = 12;

namespace GtFaultHist {
namespace {
constexpr u32 RangeBits = 20;
constexpr size_t BucketCount = 1 << 15;
constexpr size_t BucketMask = BucketCount - 1;
constexpr size_t MaxProbe = 32;

struct FaultBucket {
    std::atomic<u64> key{0};
    std::atomic<u64> writes{0};
    std::atomic<u64> reads{0};
};

struct FaultSnapshot {
    VAddr addr;
    u64 writes;
    u64 reads;

    u64 Total() const {
        return writes + reads;
    }
};

std::array<FaultBucket, BucketCount> fault_buckets{};
std::atomic<u64> overflow_writes{0};
std::atomic<u64> overflow_reads{0};

size_t HashKey(u64 key) {
    key ^= key >> 33;
    key *= 0xff51afd7ed558ccdULL;
    key ^= key >> 33;
    return static_cast<size_t>(key) & BucketMask;
}
} // namespace

bool Enabled() {
    static const bool enabled = [] {
        const char* value = std::getenv("GT_FAULT_HIST");
        return value && std::atoi(value) != 0;
    }();
    return enabled;
}

void Record(VAddr addr, bool is_write) {
    if (!Enabled()) {
        return;
    }
    // Zero is the empty marker, so store the 1 MiB range index plus one.
    const u64 key = (addr >> RangeBits) + 1;
    size_t index = HashKey(key);
    for (size_t probe = 0; probe < MaxProbe; ++probe, index = (index + 1) & BucketMask) {
        auto& bucket = fault_buckets[index];
        u64 observed = bucket.key.load(std::memory_order_relaxed);
        if (observed == 0) {
            u64 expected = 0;
            if (bucket.key.compare_exchange_strong(expected, key, std::memory_order_relaxed)) {
                observed = key;
            } else {
                observed = expected;
            }
        }
        if (observed == key) {
            (is_write ? bucket.writes : bucket.reads).fetch_add(1, std::memory_order_relaxed);
            return;
        }
    }
    (is_write ? overflow_writes : overflow_reads).fetch_add(1, std::memory_order_relaxed);
}

void Flush() {
    if (!Enabled()) {
        return;
    }
    std::vector<FaultSnapshot> active;
    active.reserve(1024);
    u64 total_writes = 0;
    u64 total_reads = 0;
    for (auto& bucket : fault_buckets) {
        const u64 writes = bucket.writes.exchange(0, std::memory_order_relaxed);
        const u64 reads = bucket.reads.exchange(0, std::memory_order_relaxed);
        if (writes == 0 && reads == 0) {
            continue;
        }
        const u64 key = bucket.key.load(std::memory_order_relaxed);
        if (key == 0) {
            continue;
        }
        total_writes += writes;
        total_reads += reads;
        active.push_back(FaultSnapshot{.addr = (key - 1) << RangeBits,
                                       .writes = writes,
                                       .reads = reads});
    }
    const u64 missed_writes = overflow_writes.exchange(0, std::memory_order_relaxed);
    const u64 missed_reads = overflow_reads.exchange(0, std::memory_order_relaxed);
    std::ranges::sort(active, [](const FaultSnapshot& lhs, const FaultSnapshot& rhs) {
        return lhs.Total() > rhs.Total();
    });
    LOG_INFO(Render_Vulkan,
             "[faulthist] {} faults ({} wr, {} rd) across {} active 1 MiB ranges; overflow {} "
             "wr {} rd",
             total_writes + total_reads, total_writes, total_reads, active.size(), missed_writes,
             missed_reads);
    const size_t shown = std::min<size_t>(10, active.size());
    for (size_t i = 0; i < shown; ++i) {
        const auto& item = active[i];
        LOG_INFO(Render_Vulkan, "[faulthist] top {:02}: {:#x}-{:#x}: {} wr {} rd", i + 1,
                 item.addr, item.addr + (u64{1} << RangeBits), item.writes, item.reads);
    }
}
} // namespace GtFaultHist

/// See GtProtProf in page_manager.h - same env gate as the buffer cache's [obtprof].
static bool GtProtProfEnabled() {
    return GtProtProf::Enabled();
}

struct PageManager::Impl {
    struct PageState {
        u8 num_write_watchers : 7;
        // At the moment only buffer cache can request read watchers.
        // And buffers cannot overlap, thus only 1 can exist per page.
        u8 num_read_watchers : 1;

        Core::MemoryPermission WritePerm() const noexcept {
            return num_write_watchers == 0 ? Core::MemoryPermission::Write
                                           : Core::MemoryPermission::None;
        }

        Core::MemoryPermission ReadPerm() const noexcept {
            return num_read_watchers == 0 ? Core::MemoryPermission::Read
                                          : Core::MemoryPermission::None;
        }

        Core::MemoryPermission Perms() const noexcept {
            return ReadPerm() | WritePerm();
        }

        template <s32 delta, bool is_read>
        u8 AddDelta() {
            if constexpr (is_read) {
                if constexpr (delta == 1) {
                    return ++num_read_watchers;
                } else if (delta == -1) {
                    ASSERT_MSG(num_read_watchers > 0, "Not enough watchers");
                    return --num_read_watchers;
                } else {
                    return num_read_watchers;
                }
            } else {
                if constexpr (delta == 1) {
                    return ++num_write_watchers;
                } else if (delta == -1) {
                    ASSERT_MSG(num_write_watchers > 0, "Not enough watchers");
                    return --num_write_watchers;
                } else {
                    return num_write_watchers;
                }
            }
        }
    };

    static constexpr size_t ADDRESS_BITS = 40;
    static constexpr size_t NUM_ADDRESS_PAGES = 1ULL << (40 - PM_PAGE_BITS);
    static constexpr size_t NUM_ADDRESS_LOCKS = NUM_ADDRESS_PAGES / PAGES_PER_LOCK;
    inline static Vulkan::Rasterizer* rasterizer;
    inline static Impl* self;
#ifdef ENABLE_USERFAULTFD
    Impl(Vulkan::Rasterizer* rasterizer_) {
        rasterizer = rasterizer_;
        uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY);
        ASSERT_MSG(uffd != -1, "{}", Common::GetLastErrorMsg());

        // Request uffdio features from kernel.
        uffdio_api api;
        api.api = UFFD_API;
        api.features = UFFD_FEATURE_THREAD_ID;
        const int ret = ioctl(uffd, UFFDIO_API, &api);
        ASSERT(ret == 0 && api.api == UFFD_API);

        // Create uffd handler thread
        ufd_thread = std::jthread([&](std::stop_token token) { UffdHandler(token); });
    }

    void OnMap(VAddr address, size_t size) {
        uffdio_register reg;
        reg.range.start = address;
        reg.range.len = size;
        reg.mode = UFFDIO_REGISTER_MODE_WP;
        const int ret = ioctl(uffd, UFFDIO_REGISTER, &reg);
        ASSERT_MSG(ret != -1, "Uffdio register failed");
    }

    void OnUnmap(VAddr address, size_t size) {
        uffdio_range range;
        range.start = address;
        range.len = size;
        const int ret = ioctl(uffd, UFFDIO_UNREGISTER, &range);
        ASSERT_MSG(ret != -1, "Uffdio unregister failed");
    }

    void Protect(VAddr address, size_t size, Core::MemoryPermission perms) {
        bool allow_write = True(perms & Core::MemoryPermission::Write);
        uffdio_writeprotect wp;
        wp.range.start = address;
        wp.range.len = size;
        wp.mode = allow_write ? 0 : UFFDIO_WRITEPROTECT_MODE_WP;
        const int ret = ioctl(uffd, UFFDIO_WRITEPROTECT, &wp);
        ASSERT_MSG(ret != -1, "Uffdio writeprotect failed with error: {}",
                   Common::GetLastErrorMsg());
    }

    void UffdHandler(std::stop_token token) {
        while (!token.stop_requested()) {
            pollfd pollfd;
            pollfd.fd = uffd;
            pollfd.events = POLLIN;

            // Block until the descriptor is ready for data reads.
            const int pollres = poll(&pollfd, 1, -1);
            switch (pollres) {
            case -1:
                perror("Poll userfaultfd");
                continue;
                break;
            case 0:
                continue;
            case 1:
                break;
            default:
                UNREACHABLE_MSG("Unexpected number of descriptors {} out of poll", pollres);
            }

            // We don't want an error condition to have occured.
            ASSERT_MSG(!(pollfd.revents & POLLERR), "POLLERR on userfaultfd");

            // We waited until there is data to read, we don't care about anything else.
            if (!(pollfd.revents & POLLIN)) {
                continue;
            }

            // Read message from kernel.
            uffd_msg msg;
            const int readret = read(uffd, &msg, sizeof(msg));
            ASSERT_MSG(readret != -1 || errno == EAGAIN, "Unexpected result of uffd read");
            if (errno == EAGAIN) {
                continue;
            }
            ASSERT_MSG(readret == sizeof(msg), "Unexpected short read, exiting");
            ASSERT(msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WP);

            // Notify rasterizer about the fault.
            const VAddr addr = msg.arg.pagefault.address;
            rasterizer->InvalidateMemory(addr, 1);
        }
    }

    std::jthread ufd_thread;
    int uffd;
#else
    Impl(Vulkan::Rasterizer* rasterizer_) {
        rasterizer = rasterizer_;
        self = this;

        // Should be called first.
        constexpr auto priority = std::numeric_limits<u32>::min();
        Core::Signals::Instance()->RegisterAccessViolationHandler(GuestFaultSignalHandler,
                                                                  priority);
    }

    void OnMap(VAddr address, size_t size) {
        // No-op
    }

    void OnUnmap(VAddr address, size_t size) {
        // No-op
    }

    void Protect(VAddr address, size_t size, Core::MemoryPermission perms) {
        RENDERER_TRACE;
        auto* memory = Core::Memory::Instance();
        auto& impl = memory->GetAddressSpace();
        ASSERT_MSG(perms != Core::MemoryPermission::Write,
                   "Attempted to protect region as write-only which is not a valid permission");
        if (GtProtProfEnabled()) {
            // steady_clock in the fault-handler path (ClaimOrphanedProtection) is fine: QPC is
            // a userland read. Logging from there would not be - the flush lives in the buffer
            // cache's GPU-thread [protprof], these only count.
            const auto t0 = std::chrono::steady_clock::now();
            impl.ProtectGpuTracked(address, size, perms);
            const u64 ns = static_cast<u64>((std::chrono::steady_clock::now() - t0).count());
            if (GtProtProf::in_span_walk) {
                GtProtProf::span_calls.fetch_add(1, std::memory_order_relaxed);
                GtProtProf::span_ns.fetch_add(ns, std::memory_order_relaxed);
            } else {
                GtProtProf::other_calls.fetch_add(1, std::memory_order_relaxed);
                GtProtProf::other_ns.fetch_add(ns, std::memory_order_relaxed);
            }
            return;
        }
        impl.ProtectGpuTracked(address, size, perms);
    }

    static bool GuestFaultSignalHandler(void* context, void* fault_address) {
        const auto addr = reinterpret_cast<VAddr>(fault_address);
        const bool is_write = Common::IsWriteError(context);
        const bool claimed =
            is_write ? rasterizer->InvalidateMemory(addr, 8) : rasterizer->ReadMemory(addr, 8);
        if (claimed) {
            GtFaultHist::Record(addr, is_write);
            if (GtProtProfEnabled()) {
                (is_write ? GtProtProf::faults_write : GtProtProf::faults_read)
                    .fetch_add(1, std::memory_order_relaxed);
            }
            return true;
        }
        // The rasterizer refused the fault because the address is not GPU-mapped - but if WE
        // hold a protection on that page, the fault is still OURS. A tracked region that spans
        // past the GPU-mapped area (the "Tracking memory region ... which is not fully GPU
        // mapped" warning above) write-protects pages the rasterizer will never claim, and the
        // guest then dies ON ITS OWN HEAP: runs 88/90 took an unhandled write AV at the last
        // dword of the newest 2 MB direct-memory block, right at race start, reproducibly.
        // Restore the page and claim the fault - there is no GPU data to keep coherent there,
        // which is exactly why the rasterizer declined.
        return self && self->ClaimOrphanedProtection(addr, is_write);
    }

    bool ClaimOrphanedProtection(VAddr addr, bool is_write) {
        if ((addr >> PM_PAGE_BITS) >= NUM_ADDRESS_PAGES) {
            return false;
        }
        const size_t page = addr >> PM_PAGE_BITS;
        std::scoped_lock lk(locks[page / PAGES_PER_LOCK]);
        const auto perms = cached_pages[page].Perms();
        const bool restricted_by_us = is_write ? !True(perms & Core::MemoryPermission::Write)
                                               : !True(perms & Core::MemoryPermission::Read);
        if (!restricted_by_us) {
            // The tracker grants this access, so the fault is not from our protection -
            // a genuine guest wild access. Let the crash-dump path have it.
            return false;
        }
        // Refuse to claim a fault on memory the guest never mapped: retrying the instruction
        // there would fault forever. IsMappedMemory, NOT IsValidMapping - the latter counts
        // FREE VMAs as valid (the run-94 lesson) and a claim on a free page would be exactly
        // that infinite fault loop. (Unlocked read of the VMA map from a fault handler - the
        // alternative is a certain crash, and the map is only ever grown here.)
        if (!Core::Memory::Instance()->IsMappedMemory(addr, 1)) {
            return false;
        }
        static std::atomic<u32> orphan_logs{0};
        if (orphan_logs.fetch_add(1, std::memory_order_relaxed) < 32) {
            LOG_CRITICAL(Render,
                         "[softclamp] orphaned page protection at {:#x} ({} fault, page perms "
                         "{:#x}) - restoring RW and claiming the fault",
                         addr, is_write ? "write" : "read", static_cast<u32>(perms));
        }
        Protect(Common::AlignDown(addr, PM_PAGE_SIZE), PM_PAGE_SIZE,
                Core::MemoryPermission::ReadWrite);
        // The watcher counts are left alone on purpose: zeroing them would trip the
        // "Not enough watchers" assert when the buffer that registered them unregisters.
        // A later UpdatePageWatchers pass may re-protect this page; the guest then faults
        // once more and we claim it again - forward progress either way.
        return true;
    }
#endif

    template <bool track, bool is_read>
    void UpdatePageWatchers(VAddr addr, u64 size) {
        RENDERER_TRACE;

        size_t page = addr >> PM_PAGE_BITS;
        const u64 page_end = Common::DivCeil(addr + size, PM_PAGE_SIZE);

        // Acquire locks for the range of pages
        const auto lock_start = locks.begin() + (page / PAGES_PER_LOCK);
        const auto lock_end = locks.begin() + Common::DivCeil(page_end, PAGES_PER_LOCK);
        Common::RangeLockGuard lk(lock_start, lock_end);

        auto perms = cached_pages[page].Perms();
        u64 range_begin = 0;
        u64 range_bytes = 0;
        u64 potential_range_bytes = 0;

        const auto release_pending = [&] {
            if (range_bytes > 0) {
                RENDERER_TRACE;
                // Perform pending (un)protect action
                Protect(range_begin << PM_PAGE_BITS, range_bytes, perms);
                range_bytes = 0;
                potential_range_bytes = 0;
            }
        };

        // Iterate requested pages
        const u64 aligned_addr = page << PM_PAGE_BITS;
        const u64 aligned_end = page_end << PM_PAGE_BITS;
        // A torn GPU-driven descriptor got a region REGISTERED at guest address ZERO (run 66:
        // "Tracking memory region 0x0 - 0x400000", then Protect(0x0) died). Worse, once that
        // Protect learned to skip instead of assert, the sweep CONTINUED across the address
        // space and stripped EXECUTE off the guest's own code pages - run 67 collapsed with
        // "wild jump" DEP faults on a dozen threads at once. No legitimate guest data lives
        // below 64 KiB; refuse the whole (un)tracking symmetrically.
        if (aligned_addr < 0x10000) {
            LOG_CRITICAL(Render,
                         "[softclamp] refusing to (un)track region {:#x} - {:#x} (below the "
                         "guest floor - torn descriptor registration)",
                         aligned_addr, aligned_end);
            return;
        }
        if (!rasterizer->IsMapped(aligned_addr, aligned_end - aligned_addr)) {
            // A NOT-fully-mapped region that is also HUGE is a torn descriptor, not content:
            // run 146 registered an image spanning 0x10c5200000 - 0x114d280000 (~2.3 GB), the
            // warning below fired, and the page sweep then died writing a watcher entry
            // (0xc0000005 at address 0x20). Same softclamp answer as the guest-floor case
            // above; small partially-mapped regions keep the old warn-and-continue behavior.
            if (aligned_end - aligned_addr > (u64{1} << 30)) {
                LOG_CRITICAL(Render,
                             "[softclamp] refusing to (un)track region {:#x} - {:#x} ({} MB, "
                             "not fully GPU mapped - torn descriptor registration)",
                             aligned_addr, aligned_end, (aligned_end - aligned_addr) >> 20);
                return;
            }
            LOG_WARNING(Render,
                        "Tracking memory region {:#x} - {:#x} which is not fully GPU mapped.",
                        aligned_addr, aligned_end);
        }

        for (; page != page_end; ++page) {
            PageState& state = cached_pages[page];

            // Apply the change to the page state
            const u8 new_count = state.AddDelta<track ? 1 : -1, is_read>();

            if (auto new_perms = state.Perms(); new_perms != perms) [[unlikely]] {
                // If the protection changed add pending (un)protect action
                release_pending();
                perms = new_perms;
            } else if (range_bytes != 0) {
                // If the protection did not change, extend the potential range
                potential_range_bytes += PM_PAGE_SIZE;
            }

            // Only start a new range if the page must be (un)protected
            if ((new_count == 0 && !track) || (new_count == 1 && track)) {
                if (range_bytes == 0) {
                    // Start a new potential range
                    range_begin = page;
                    potential_range_bytes = PM_PAGE_SIZE;
                }
                // Extend current range up to potential range
                range_bytes = potential_range_bytes;
            }
        }

        // Add pending (un)protect action
        release_pending();
    }

    template <bool track, bool is_read>
    void UpdatePageWatchersForRegion(VAddr base_addr, RegionBits& mask) {
        RENDERER_TRACE;
        auto start_range = mask.FirstRange();
        auto end_range = mask.LastRange();

        if (start_range.second == end_range.second) {
            // if all pages are contiguous, use the regular UpdatePageWatchers
            const VAddr start_addr = base_addr + (start_range.first << PM_PAGE_BITS);
            const u64 size = (start_range.second - start_range.first) << PM_PAGE_BITS;
            return UpdatePageWatchers<track, is_read>(start_addr, size);
        }

        size_t base_page = (base_addr >> PM_PAGE_BITS);
        ASSERT(base_page % PAGES_PER_LOCK == 0);
        std::scoped_lock lk(locks[base_page / PAGES_PER_LOCK]);
        auto perms = cached_pages[base_page + start_range.first].Perms();
        u64 range_begin = 0;
        u64 range_bytes = 0;
        u64 potential_range_bytes = 0;

        const auto release_pending = [&] {
            if (range_bytes > 0) {
                RENDERER_TRACE;
                // Perform pending (un)protect action
                Protect((range_begin << PM_PAGE_BITS), range_bytes, perms);
                range_bytes = 0;
                potential_range_bytes = 0;
            }
        };

        // Iterate pages
        for (size_t page = start_range.first; page < end_range.second; ++page) {
            PageState& state = cached_pages[base_page + page];
            const bool update = mask.Get(page);

            // Apply the change to the page state
            const u8 new_count =
                update ? state.AddDelta<track ? 1 : -1, is_read>() : state.AddDelta<0, is_read>();

            if (auto new_perms = state.Perms(); new_perms != perms) [[unlikely]] {
                // If the protection changed add pending (un)protect action
                release_pending();
                perms = new_perms;
            } else if (range_bytes != 0) {
                // If the protection did not change, extend the potential range
                potential_range_bytes += PM_PAGE_SIZE;
            }

            // If the page is not being updated, skip it
            if (!update) {
                continue;
            }

            // If the page must be (un)protected
            if ((new_count == 0 && !track) || (new_count == 1 && track)) {
                if (range_bytes == 0) {
                    // Start a new potential range
                    range_begin = base_page + page;
                    potential_range_bytes = PM_PAGE_SIZE;
                }
                // Extend current rango up to potential range
                range_bytes = potential_range_bytes;
            }
        }

        // Add pending (un)protect action
        release_pending();
    }

    std::array<PageState, NUM_ADDRESS_PAGES> cached_pages{};
#ifdef PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP
    using LockType = Common::AdaptiveMutex;
#else
    using LockType = Common::SpinLock;
#endif
    std::array<LockType, NUM_ADDRESS_LOCKS> locks{};
};

PageManager::PageManager(Vulkan::Rasterizer* rasterizer_)
    : impl{std::make_unique<Impl>(rasterizer_)} {}

PageManager::~PageManager() = default;

void PageManager::OnGpuMap(VAddr address, size_t size) {
    impl->OnMap(address, size);
}

void PageManager::OnGpuUnmap(VAddr address, size_t size) {
    impl->OnUnmap(address, size);
}

template <bool track>
void PageManager::UpdatePageWatchers(VAddr addr, u64 size) const {
    impl->UpdatePageWatchers<track, false>(addr, size);
}

template <bool track, bool is_read>
void PageManager::UpdatePageWatchersForRegion(VAddr base_addr, RegionBits& mask) const {
    impl->UpdatePageWatchersForRegion<track, is_read>(base_addr, mask);
}

template void PageManager::UpdatePageWatchers<true>(VAddr addr, u64 size) const;
template void PageManager::UpdatePageWatchers<false>(VAddr addr, u64 size) const;
template void PageManager::UpdatePageWatchersForRegion<true, true>(VAddr base_addr,
                                                                   RegionBits& mask) const;
template void PageManager::UpdatePageWatchersForRegion<true, false>(VAddr base_addr,
                                                                    RegionBits& mask) const;
template void PageManager::UpdatePageWatchersForRegion<false, true>(VAddr base_addr,
                                                                    RegionBits& mask) const;
template void PageManager::UpdatePageWatchersForRegion<false, false>(VAddr base_addr,
                                                                     RegionBits& mask) const;

} // namespace VideoCore
