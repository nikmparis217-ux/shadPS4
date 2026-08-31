// SPDX-FileCopyrightText: Copyright 2024-2026 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#include <chrono>
#include "common/div_ceil.h"
#include "common/logging/log.h"
#include "core/emulator_settings.h"

#ifdef __unix__
#include "common/adaptive_mutex.h"
#else
#include "common/spin_lock.h"
#endif
#include "common/debug.h"
#include "common/types.h"
#include "video_core/buffer_cache/region_definitions.h"
#include "video_core/page_manager.h"

namespace VideoCore {

#ifdef PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP
using LockType = Common::AdaptiveMutex;
#else
using LockType = Common::SpinLock;
#endif

/**
 * Allows tracking CPU and GPU modification of pages in a contigious 16MB virtual address region.
 * Information is stored in bitsets for spacial locality and fast update of single pages.
 */
class RegionManager {
public:
    explicit RegionManager(PageManager* tracker_, VAddr cpu_addr_)
        : tracker{tracker_}, cpu_addr{cpu_addr_} {
        cpu.Fill();
        gpu.Clear();
        writeable.Fill();
        readable.Fill();
    }
    explicit RegionManager() = default;

    void SetCpuAddress(VAddr new_cpu_addr) {
        cpu_addr = new_cpu_addr;
        // A manager can be handed out for a fresh region; hot-pin state from a previous
        // tenancy would pin the wrong pages of the new one.
        pinned.Clear();
        fault_seen.Clear();
    }

    VAddr GetCpuAddr() const {
        return cpu_addr;
    }

    static constexpr size_t SanitizeAddress(size_t address) {
        return static_cast<size_t>(std::max<s64>(static_cast<s64>(address), 0LL));
    }

    template <Type type>
    RegionBits& GetRegionBits() noexcept {
        if constexpr (type == Type::CPU) {
            return cpu;
        } else if constexpr (type == Type::GPU) {
            return gpu;
        }
    }

    template <Type type>
    const RegionBits& GetRegionBits() const noexcept {
        if constexpr (type == Type::CPU) {
            return cpu;
        } else if constexpr (type == Type::GPU) {
            return gpu;
        }
    }

    /**
     * Change the state of a range of pages
     *
     * @param dirty_addr    Base address to mark or unmark as modified
     * @param size          Size in bytes to mark or unmark as modified
     */
    template <Type type, bool enable>
    void ChangeRegionState(u64 dirty_addr, u64 size) noexcept(type == Type::GPU) {
        RENDERER_TRACE;
        const size_t offset = dirty_addr - cpu_addr;
        const size_t start_page = SanitizeAddress(offset) / TRACKER_BYTES_PER_PAGE;
        const size_t end_page =
            Common::DivCeil(SanitizeAddress(offset + size), TRACKER_BYTES_PER_PAGE);
        if (start_page >= NUM_PAGES_PER_REGION || end_page <= start_page) {
            return;
        }

        RegionBits& bits = GetRegionBits<type>();
        if constexpr (enable) {
            bits.SetRange(start_page, end_page);
        } else {
            bits.UnsetRange(start_page, end_page);
        }
        if constexpr (type == Type::CPU) {
            UpdateProtection<!enable, false>();
        } else if (EmulatorSettings.GetReadbacksMode() == GpuReadbacksMode::Precise) {
            UpdateProtection<enable, true>();
        }
    }

    /**
     * Loop over each page in the given range, turn off those bits and notify the tracker if
     * needed. Call the given function on each turned off range.
     *
     * @param query_cpu_range Base CPU address to loop over
     * @param size            Size in bytes of the CPU range to loop over
     * @param func            Function to call for each turned off region
     */
    template <Type type, bool clear>
    void ForEachModifiedRange(VAddr query_cpu_range, s64 size, auto&& func) {
        RENDERER_TRACE;
        const size_t offset = query_cpu_range - cpu_addr;
        const size_t start_page = SanitizeAddress(offset) / TRACKER_BYTES_PER_PAGE;
        const size_t end_page =
            Common::DivCeil(SanitizeAddress(offset + size), TRACKER_BYTES_PER_PAGE);
        if (start_page >= NUM_PAGES_PER_REGION || end_page <= start_page) {
            return;
        }

        RegionBits& bits = GetRegionBits<type>();
        RegionBits mask(bits, start_page, end_page);

        if constexpr (clear) {
            bits.UnsetRange(start_page, end_page);
            if constexpr (type == Type::CPU) {
                // GT_HOT_PIN: a pinned page stays CPU-dirty forever (it re-uploads on every
                // bind - the harvest above already reported it) and, because cpu and writeable
                // then both stay 1, UpdateProtection below has nothing to re-protect: no
                // syscall, and the guest write that would have faulted next frame does not.
                if (GtHotPin::Enabled()) {
                    RegionBits keep(pinned, start_page, end_page);
                    if (keep.Any()) {
                        bits |= keep;
                        if (GtProtProf::Enabled()) {
                            size_t kept = 0;
                            for (const auto& [s, e] : keep) {
                                kept += e - s;
                            }
                            GtHotPin::kept_pages.fetch_add(kept, std::memory_order_relaxed);
                        }
                    }
                }
                UpdateProtection<true, false>();
            } else if (EmulatorSettings.GetReadbacksMode() != GpuReadbacksMode::Disabled) {
                UpdateProtection<false, true>();
            }
        }

        for (const auto& [start, end] : mask) {
            func(cpu_addr + start * TRACKER_BYTES_PER_PAGE, (end - start) * TRACKER_BYTES_PER_PAGE);
        }
    }

    /**
     * GT_HOT_PIN (run 221): the guest-write-fault flavor of ChangeRegionState<CPU, true>. A
     * page faulting AGAIN while fault_seen still remembers its previous fault is caught in the
     * write -> upload -> re-protect -> fault cycle (runs 218/220: the same 1 MiB arenas faulted
     * thousands of times per window) and gets pinned. GPU-modified pages are never pinned - a
     * pin means "upload this on every bind", and that must never clobber GPU-written data the
     * tracker knows about. Caller must hold the region lock.
     */
    void MarkCpuDirtyFromFault(u64 dirty_addr, u64 size) {
        RENDERER_TRACE;
        const size_t offset = dirty_addr - cpu_addr;
        const size_t start_page = SanitizeAddress(offset) / TRACKER_BYTES_PER_PAGE;
        const size_t end_page =
            Common::DivCeil(SanitizeAddress(offset + size), TRACKER_BYTES_PER_PAGE);
        if (start_page >= NUM_PAGES_PER_REGION || end_page <= start_page) {
            return;
        }
        RegionBits mask;
        mask.SetRange(start_page, end_page);
        if (GtHotPin::Enabled()) {
            RegionBits repeat = mask;
            repeat &= fault_seen;
            repeat &= ~gpu;
            repeat &= ~pinned;
            if (repeat.Any()) {
                pinned |= repeat;
                if (GtProtProf::Enabled()) {
                    size_t added = 0;
                    for (const auto& [s, e] : repeat) {
                        added += e - s;
                    }
                    GtHotPin::pins_added.fetch_add(added, std::memory_order_relaxed);
                }
            }
            fault_seen |= mask;
        }
        cpu |= mask;
        UpdateProtection<false, false>();
    }

    /**
     * GT_HOT_PIN: periodic decay, called on every sweep. fault_seen always resets (so "hot"
     * means two faults within one sweep interval, not two faults ever); the pins themselves
     * drop only when drop_pins is set (every third sweep) - a still-hot page re-earns its pin
     * within milliseconds at the cost of one fault, a cooled page stops re-uploading forever.
     * Caller must hold the region lock.
     */
    void DecayHotPins(bool drop_pins) {
        fault_seen.Clear();
        if (drop_pins) {
            pinned.Clear();
        }
    }

    /**
     * GT_HOT_PIN: does any page of the range hold a pin? The GT_BIND_SKIP gate must not skip
     * a window with pins: pinned pages never fault again, so no producer re-logs them into the
     * gate's dirty mirror, and skipping would leave the GPU reading stale bytes while the CPU
     * keeps writing the unprotected pages. Caller must hold the region lock.
     */
    [[nodiscard]] bool IsRegionPinned(u64 offset, u64 size) noexcept {
        const size_t start_page = SanitizeAddress(offset) / TRACKER_BYTES_PER_PAGE;
        const size_t end_page =
            Common::DivCeil(SanitizeAddress(offset + size), TRACKER_BYTES_PER_PAGE);
        if (start_page >= NUM_PAGES_PER_REGION || end_page <= start_page) {
            return false;
        }
        RegionBits test(pinned, start_page, end_page);
        return test.Any();
    }

    /**
     * GT_FAULT_WIDE (run 211): mark the non-GPU-modified pages of a range CPU-dirty in ONE
     * pass, so one guest write fault can unprotect a whole window with one VirtualProtect
     * instead of one per 4K page (run 210 measured 12-23k faults and 1.8-3.3 s of protect
     * syscalls per 2 s window, most of it under these very region locks). GPU-modified pages
     * are EXCLUDED: GT7's flatbufs carry GPU-written scalars right beside CPU-written data
     * (the cs_018256c0 lesson), and marking those CPU-dirty would upload stale guest bytes
     * over them. The pages this widens were CPU-clean, so their guest bytes equal what the
     * VkBuffer already holds - the extra upload is redundant bandwidth, never wrong data.
     * Caller must hold the region lock.
     */
    void MarkCleanPagesAsCpuModified(u64 dirty_addr, u64 size) {
        RENDERER_TRACE;
        const size_t offset = dirty_addr - cpu_addr;
        const size_t start_page = SanitizeAddress(offset) / TRACKER_BYTES_PER_PAGE;
        const size_t end_page =
            Common::DivCeil(SanitizeAddress(offset + size), TRACKER_BYTES_PER_PAGE);
        if (start_page >= NUM_PAGES_PER_REGION || end_page <= start_page) {
            return;
        }
        RegionBits mask;
        mask.SetRange(start_page, end_page);
        mask &= ~gpu;
        cpu |= mask;
        UpdateProtection<false, false>();
    }

    /**
     * GT_FAULT_WIDE stage 2 (run 213): clear the CPU-dirty bits of pages holding a GPU-written
     * structure the tracker cannot see (BDA-store targets, e.g. cs_018256c0's record buffers),
     * so the next SynchronizeBuffer does NOT upload stale guest bytes over live GPU data. Only
     * meaningful while fault widening is on: without it these pages get dirty only from a REAL
     * guest write fault (the stable pre-widening behavior) and the caller must not clear them.
     * Re-protects through UpdateProtection<track=true> so a later genuine CPU write faults
     * normally. Returns how many pages were actually cleared. Caller must hold the region lock.
     */
    size_t ClearCpuDirtyPages(u64 dirty_addr, u64 size) {
        RENDERER_TRACE;
        const size_t offset = dirty_addr - cpu_addr;
        const size_t start_page = SanitizeAddress(offset) / TRACKER_BYTES_PER_PAGE;
        const size_t end_page =
            Common::DivCeil(SanitizeAddress(offset + size), TRACKER_BYTES_PER_PAGE);
        if (start_page >= NUM_PAGES_PER_REGION || end_page <= start_page) {
            return 0;
        }
        RegionBits mask(cpu, start_page, end_page);
        if (mask.None()) {
            return 0;
        }
        size_t cleared = 0;
        for (const auto& [start, end] : mask) {
            cleared += end - start;
        }
        cpu.UnsetRange(start_page, end_page);
        UpdateProtection<true, false>();
        return cleared;
    }

    /**
     * Returns true when a region has been modified
     *
     * @param offset Offset in bytes from the start of the buffer
     * @param size   Size in bytes of the region to query for modifications
     */
    template <Type type>
    [[nodiscard]] bool IsRegionModified(u64 offset, u64 size) noexcept {
        RENDERER_TRACE;
        const size_t start_page = SanitizeAddress(offset) / TRACKER_BYTES_PER_PAGE;
        const size_t end_page =
            Common::DivCeil(SanitizeAddress(offset + size), TRACKER_BYTES_PER_PAGE);
        if (start_page >= NUM_PAGES_PER_REGION || end_page <= start_page) {
            return false;
        }

        const RegionBits& bits = GetRegionBits<type>();
        RegionBits test(bits, start_page, end_page);
        return test.Any();
    }

    LockType lock;

private:
    /**
     * Notify tracker about changes in the CPU tracking state of a word in the buffer
     *
     * @param word_index   Index to the word to notify to the tracker
     * @param current_bits Current state of the word
     * @param new_bits     New state of the word
     *
     * @tparam track True when the tracker should start tracking the new pages
     */
    template <bool track, bool is_read>
    void UpdateProtection() {
        RENDERER_TRACE;
        RegionBits mask = is_read ? (~gpu ^ readable) : (cpu ^ writeable);
        if (mask.None()) {
            return;
        }
        if constexpr (is_read) {
            readable = ~gpu;
        } else {
            writeable = cpu;
        }
        // GT_FRAME_PROF: time the whole watcher update (IsMapped + range locks + page loop +
        // the Protect syscalls) so [protprof] can split machinery from syscalls - run 210.
        if (GtProtProf::Enabled()) {
            const auto t0 = std::chrono::steady_clock::now();
            tracker->UpdatePageWatchersForRegion<track, is_read>(cpu_addr, mask);
            const u64 ns = static_cast<u64>((std::chrono::steady_clock::now() - t0).count());
            (GtProtProf::in_span_walk ? GtProtProf::watch_span_ns : GtProtProf::watch_other_ns)
                .fetch_add(ns, std::memory_order_relaxed);
            return;
        }
        tracker->UpdatePageWatchersForRegion<track, is_read>(cpu_addr, mask);
    }

    PageManager* tracker;
    VAddr cpu_addr = 0;
    RegionBits cpu;
    RegionBits gpu;
    RegionBits writeable;
    RegionBits readable;
    // GT_HOT_PIN state - see MarkCpuDirtyFromFault / DecayHotPins.
    RegionBits pinned;
    RegionBits fault_seen;
};

} // namespace VideoCore
