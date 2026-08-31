// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include <algorithm>
#include <array>
#include <memory>
#include <atomic>
#include <chrono>
#include <cstdlib>
#include <cstring>
#include <limits>
#include <mutex>
#include <boost/container/static_vector.hpp>
#include "common/alignment.h"
#include "common/debug.h"
#include "common/scope_exit.h"
#include "core/memory.h"
#include "video_core/amdgpu/liverpool.h"
#include "video_core/buffer_cache/buffer_cache.h"
#include "video_core/buffer_cache/memory_tracker.h"
#include "video_core/gt_va_watch.h"
#include "video_core/renderer_vulkan/vk_graphics_pipeline.h"
#include "video_core/renderer_vulkan/vk_instance.h"
#include "video_core/renderer_vulkan/vk_scheduler.h"
#include "video_core/texture_cache/texture_cache.h"

namespace VideoCore {

namespace {
/// Every oversized download costs a full scheduler.Finish() (a GPU stall) - and buffer-GC
/// eviction routes through DownloadBufferMemory, so an eviction storm of >32 MB buffers would
/// read as an FPS cliff. Counted separately from the [copyclamp] budget (which goes silent
/// after 16 lines) and reported in the periodic [vram] telemetry line.
std::atomic<u32> g_temp_download_count{0};

/// GT_DMA_DIRTY_LOG: default OFF preserves upstream behaviour (the full mapped-range walk on
/// every DMA draw). The launcher opts in.
bool DmaDirtyLogEnabled() {
    static const bool enabled = [] {
        const char* v = std::getenv("GT_DMA_DIRTY_LOG");
        return v && std::atoi(v) != 0;
    }();
    return enabled;
}

/// GT_BDA_IMPORT (unified-memory stage 4): expose physically-backed guest pages directly to
/// BDA shaders only when no normal cached Vulkan buffer owns the page. The launcher opts in;
/// every other title retains the zero-entry fault path byte-for-byte.
bool GtBdaImportEnabled() {
    static const bool enabled = [] {
        const char* v = std::getenv("GT_BDA_IMPORT");
        return v && std::atoi(v) != 0;
    }();
    return enabled;
}

/// GT_DIRECT_IMPORT (run 220): use the already imported coherent guest backing directly for
/// GPU-read-only buffers. This is deliberately narrower than GT_BDA_IMPORT: formatted buffers,
/// cached ranges, GPU-modified ranges, image aliases, fragmented physical mappings and ranges
/// crossing an import chunk all retain the normal copy-and-track path.
bool GtDirectImportEnabled() {
    static const bool enabled = [] {
        const char* v = std::getenv("GT_DIRECT_IMPORT");
        return v && std::atoi(v) != 0;
    }();
    return enabled;
}

/// GT_BIND_SKIP (run 205): [obtprof] convicted the CACHED half of ObtainBuffer - ~30,000
/// SynchronizeBuffer calls per 2 s window costing 230-660 ms, ~13 us each, almost all of them
/// finding NOTHING dirty. The cost is ForEachUploadRange's per-region dance (spin lock, bitset
/// mask copy, UnsetRange, protection XOR) paid on every bind of every draw, and an is_written
/// bind window can span 256 MiB = 64 regions. The fix mirrors the tracker's CPU-dirty state
/// into a persistent RangeSet fed by the SAME four producers as the DMA dirty log, so the gate
/// in SynchronizeBuffer answers "did anything become CPU-dirty here since the last sync?" in
/// O(log n) instead of walking regions. INVARIANT: mirror is a SUPERSET of the tracker's
/// CPU-dirty pages - producers mark the tracker FIRST then add here; the consumer subtracts
/// only the exact window it is about to synchronize (the sync clears full pages, a superset of
/// that window). A stale mirror entry costs one wasted walk; a missing one would ship stale
/// data, which is why this requires GT_DMA_DIRTY_LOG (the producers only log under it).
bool BindSkipEnabled() {
    static const bool enabled = [] {
        const char* v = std::getenv("GT_BIND_SKIP");
        return v && std::atoi(v) != 0;
    }();
    return enabled && DmaDirtyLogEnabled();
}

/// GT_FRAME_PROF companion (run 201): the rasterizer's [fprof] measured the uses_dma block at
/// 460-745 ms per 2 s window while the sampled consumptions read ZERO ranges - impossible for
/// the empty-log path unless the time is spent WAITING on dma_dirty_mutex. Every producer takes
/// that lock, including InvalidateMemory on the page-fault path that each of GT7's ~60 Job#
/// threads runs through, so the consumer can starve behind a stampede. These counters split the
/// block into lock wait / sync work / range volume ON BOTH SIDES; one [dmaprof] line per 2 s
/// window, flushed from the consumer thread. (Run 202 verdict: the lock measured 0.1 ms - the
/// cost was 25,000 byte-exact ranges per window, fixed by 64 KiB coalescing in LogDmaDirty.)
bool DmaProfEnabled() {
    static const bool enabled = [] {
        const char* v = std::getenv("GT_FRAME_PROF");
        return v && std::atoi(v) != 0;
    }();
    return enabled;
}

struct DmaProf {
    std::atomic<u64> log_calls{0};
    std::atomic<u64> log_lock_ns{0};
    std::atomic<u64> consume_calls{0};
    std::atomic<u64> consume_lock_ns{0};
    std::atomic<u64> sync_ns{0};
    std::atomic<u64> ranges{0};
    std::atomic<u64> bytes{0};
};
DmaProf g_dmaprof;

/// Run 204's [fprof] split of BindBuffers convicted ObtainBuffer alone (374-596 ms per 2 s
/// window over ~108k binds; clamp/findbuf/flatcopy measured 1-8 ms). Three costs live inside
/// it: the IsRegionGpuModified tracker walk, the stream-buffer memcpy every read-only bind
/// pays by design, and SynchronizeBuffer on the cached path. One [obtprof] line per 2 s.
struct ObtainProf {
    std::atomic<u64> stream_calls{0};
    std::atomic<u64> stream_bytes{0};
    std::atomic<u64> gpumod_ns{0};
    std::atomic<u64> stream_ns{0};
    std::atomic<u64> cached_calls{0};
    std::atomic<u64> sync_ns{0};
    // GT_BIND_SKIP verdict counters: how many SynchronizeBuffer calls the mirror short-circuited
    // (read-only vs written - the written ones still pay the cheap GPU marking), against how
    // many had to walk. Counted inside the gate so every caller is covered, not only the binds.
    std::atomic<u64> skip_read{0};
    std::atomic<u64> skip_written{0};
    std::atomic<u64> walked{0};
    // Run 206: the gate fired (94% skips) and sync_ms DID NOT MOVE (188-635 ms, same as run
    // 205) - so the ForEachUploadRange walk was never the bill. The cost both paths share is
    // SynchronizeBufferFromImage's page-table walk on every texel bind. These name the
    // remaining components of the sync window so run 207 cannot be argued with: the gate's
    // own mutex+intersect, the written-skip GPU marking, and the texel FromImage calls.
    std::atomic<u64> gate_ns{0};
    std::atomic<u64> markgpu_ns{0};
    std::atomic<u64> texel_calls{0};
    std::atomic<u64> fromimg_ns{0};
    // Run 207 closed the accounting: gate 9-42 ms, markgpu ~2 ms, fromimg ~1 ms (the memo
    // works), yet sync still reads 310-600 ms - ALL of it inside the ~2k walked calls, i.e.
    // ~200 us each. That is the arithmetic of a big is_written window: 256 MiB = 64 regions
    // x 2 passes x ~1.5 us of lock+bitset dance, paid to upload the one 64 KiB span that is
    // actually dirty. The fix walks ONLY the mirror's dirty spans; these time it.
    std::atomic<u64> walk_spans{0};
    std::atomic<u64> walked_ns{0};
    // Run 208: the span walk landed and walked_ns STILL reads 450-880 ms - ~80 us per span,
    // which cannot be region iteration (one region's dance is ~2 us). The bill is the upload
    // MACHINERY per span: staging map+memcpy, an EndRendering that may break the open
    // renderpass, two pipelineBarrier2 and a copyBuffer recording - paid ~700-1500 times per
    // frame. These split machinery from memcpy and count the REAL renderpass breaks so the
    // fix aims at a measured component, not the next guess.
    std::atomic<u64> walked_written{0};
    std::atomic<u64> span_cpu_ns{0};
    std::atomic<u64> span_rec_ns{0};
    std::atomic<u64> span_copies{0};
    std::atomic<u64> span_bytes{0};
    std::atomic<u64> span_empty{0};
    std::atomic<u64> span_rp_breaks{0};
    // Run 209: cpu 150-830 ms, rec 4-12 ms - recording acquitted. Two suspects left inside
    // cpu: the staging memcpy (CopySparseMemory; the stream path prices the same machinery
    // at ~0.5 ms/MB, so ~40-65 ms for this window's 60-130 MB) and the tracker's
    // UpdateProtection (VirtualQueryEx + VirtualProtectEx per Protect on Windows). This
    // carves the memcpy out of cpu; [protprof] (GtProtProf in page_manager.h) prices the
    // syscalls. tracker share = cpu - memcpy - protprof.span; run 210 names the component.
    std::atomic<u64> span_memcpy_ns{0};
    // Run 220: direct coherent backing avoids the upload/protect/fault loop for buffers that
    // are provably GPU-read-only. Count every candidate and why it retained the cached path.
    std::atomic<u64> direct_queries{0};
    std::atomic<u64> direct_hits{0};
    std::atomic<u64> direct_bytes{0};
    std::atomic<u64> direct_query_ns{0};
    std::atomic<u64> direct_cached{0};
    std::atomic<u64> direct_gpu{0};
    std::atomic<u64> direct_image{0};
    std::atomic<u64> direct_backing{0};
};
ObtainProf g_obtprof;

void MaybeFlushObtainProf() {
    static auto window_start = std::chrono::steady_clock::now();
    const auto now = std::chrono::steady_clock::now();
    if (now - window_start < std::chrono::seconds(2)) {
        return;
    }
    window_start = now;
    LOG_INFO(Render_Vulkan,
             "[obtprof] stream: {} calls {} KiB, gpumod {:.1f}ms copy {:.1f}ms | cached: {} "
             "calls, sync {:.1f}ms | skip: {} read {} written, {} walked ({} spans, {:.1f}ms) | "
             "gate {:.1f}ms markgpu {:.1f}ms | texel: {} calls fromimg {:.1f}ms",
             g_obtprof.stream_calls.exchange(0), g_obtprof.stream_bytes.exchange(0) >> 10,
             g_obtprof.gpumod_ns.exchange(0) / 1e6, g_obtprof.stream_ns.exchange(0) / 1e6,
             g_obtprof.cached_calls.exchange(0), g_obtprof.sync_ns.exchange(0) / 1e6,
             g_obtprof.skip_read.exchange(0), g_obtprof.skip_written.exchange(0),
             g_obtprof.walked.exchange(0), g_obtprof.walk_spans.exchange(0),
             g_obtprof.walked_ns.exchange(0) / 1e6, g_obtprof.gate_ns.exchange(0) / 1e6,
             g_obtprof.markgpu_ns.exchange(0) / 1e6, g_obtprof.texel_calls.exchange(0),
             g_obtprof.fromimg_ns.exchange(0) / 1e6);
    LOG_INFO(Render_Vulkan,
             "[spanprof] {} written calls | cpu {:.1f}ms (memcpy {:.1f}ms) rec {:.1f}ms | {} "
             "copies {} KiB, {} empty spans, {} rp-breaks",
             g_obtprof.walked_written.exchange(0), g_obtprof.span_cpu_ns.exchange(0) / 1e6,
             g_obtprof.span_memcpy_ns.exchange(0) / 1e6, g_obtprof.span_rec_ns.exchange(0) / 1e6,
             g_obtprof.span_copies.exchange(0), g_obtprof.span_bytes.exchange(0) >> 10,
             g_obtprof.span_empty.exchange(0), g_obtprof.span_rp_breaks.exchange(0));
    LOG_INFO(Render_Vulkan,
             "[directimport] {} queries: {} hits {} KiB in {:.1f}ms | rejected: {} cached, "
             "{} GPU-modified, {} image-alias, {} backing",
             g_obtprof.direct_queries.exchange(0), g_obtprof.direct_hits.exchange(0),
             g_obtprof.direct_bytes.exchange(0) >> 10, g_obtprof.direct_query_ns.exchange(0) / 1e6,
             g_obtprof.direct_cached.exchange(0), g_obtprof.direct_gpu.exchange(0),
             g_obtprof.direct_image.exchange(0), g_obtprof.direct_backing.exchange(0));
    LOG_INFO(Render_Vulkan,
             "[protprof] span-walk: {} protects {:.1f}ms of watch {:.1f}ms | other: {} protects "
             "{:.1f}ms of watch {:.1f}ms | claimed faults: {} wr {} rd | wide: {} marks {} KiB",
             GtProtProf::span_calls.exchange(0), GtProtProf::span_ns.exchange(0) / 1e6,
             GtProtProf::watch_span_ns.exchange(0) / 1e6, GtProtProf::other_calls.exchange(0),
             GtProtProf::other_ns.exchange(0) / 1e6, GtProtProf::watch_other_ns.exchange(0) / 1e6,
             GtProtProf::faults_write.exchange(0), GtProtProf::faults_read.exchange(0),
             GtProtProf::wide_marks.exchange(0), GtProtProf::wide_bytes.exchange(0) >> 10);
    GtFaultHist::Flush();
}

/// [bufcopy]/[bufsync]/[bufdl] (readback hunt, run 188): the exposure value's biography
/// through the buffer cache, gated on GT_WATCH_VA. [bufcopy] = a PM4 DMA copy touching a
/// watched range (this is how the game moves GPU-computed state into the texture's memory);
/// [bufsync] = a guest->buffer upload overlapping a watched range (THE CLOBBER SUSPECT: a
/// CPU-dirty tracker page re-uploads guest ZEROS over the DMA'd value inside the cached
/// buffer); [bufdl] = a readback landing a watched range in guest RAM, with the bytes.
void GtLogBufEvent(const char* tag, VAddr addr, u64 size, const u8* bytes) {
    if (GtWatchHit(addr, size) == nullptr) {
        return;
    }
    static u32 gt_bufevent_budget = 0;
    if (gt_bufevent_budget++ >= 512) {
        return;
    }
    u32 dw[4]{};
    if (bytes != nullptr) {
        std::memcpy(dw, bytes, std::min<u64>(sizeof(dw), size));
    }
    LOG_WARNING(Render_Vulkan, "[{}] {:#x}+{:#x} dw: {:08x} {:08x} {:08x} {:08x}", tag, addr,
                size, dw[0], dw[1], dw[2], dw[3]);
}

/// A dropped or clamped copy region is a bug somewhere upstream, so it must be visible - but
/// it can happen per range per draw, and run 65 proved that a per-draw CRITICAL is its own I/O
/// tax. Budgeted: loud 16 times, then silent.
void LogCopyClamp(const Buffer& buffer, u64 addr, u64 asked, u64 kept) {
    static u32 logged = 0;
    if (logged >= 16) {
        return;
    }
    ++logged;
    LOG_WARNING(Render_Vulkan,
                "[copyclamp] range {:#x}+{:#x} does not fit buffer {:#x}+{:#x} - {}{}",
                addr, asked, buffer.CpuAddr(), buffer.SizeBytes(),
                kept == 0 ? "dropped" : "kept ", kept == 0 ? std::string{} : fmt::format("{:#x}", kept));
}
} // namespace


static constexpr size_t DataShareBufferSize = 64_KB;
static constexpr size_t StagingBufferSize = 512_MB;
static constexpr size_t DownloadBufferSize = 32_MB;
static constexpr size_t UboStreamBufferSize = 64_MB;
static constexpr size_t DeviceBufferSize = 128_MB;

BufferCache::BufferCache(const Vulkan::Instance& instance_, Vulkan::Scheduler& scheduler_,
                         AmdGpu::Liverpool* liverpool_, TextureCache& texture_cache_,
                         PageManager& tracker)
    : instance{instance_}, scheduler{scheduler_}, liverpool{liverpool_},
      memory{Core::Memory::Instance()}, texture_cache{texture_cache_},
      fault_manager{instance, scheduler, *this, CACHING_PAGEBITS, CACHING_NUMPAGES},
      staging_buffer{instance, scheduler, MemoryUsage::Upload, StagingBufferSize},
      stream_buffer{instance, scheduler, MemoryUsage::Stream, UboStreamBufferSize},
      download_buffer{instance, scheduler, MemoryUsage::Download, DownloadBufferSize},
      device_buffer{instance, scheduler, MemoryUsage::DeviceLocal, DeviceBufferSize},
      gds_buffer{instance, scheduler, MemoryUsage::Stream, 0, AllFlags, DataShareBufferSize},
      bda_pagetable_buffer{instance, scheduler, MemoryUsage::DeviceLocal,
                           0,        AllFlags,  BDA_PAGETABLE_SIZE} {
    Vulkan::SetObjectName(instance.GetDevice(), gds_buffer.Handle(), "GDS Buffer");
    Vulkan::SetObjectName(instance.GetDevice(), bda_pagetable_buffer.Handle(),
                          "BDA Page Table Buffer");
    // GT7 (19 Aug, run 77 WriteInvalid device-lost): the pagetable is DeviceLocal and was
    // never cleared, so any page no registered buffer ever covered holds uninitialized
    // VRAM. Upstream DMA only ever dereferences real SRT pointers, but the bindless
    // lowering can chase a junk V# (its producer may itself still be stubbed) - a junk
    // guest address then reads a GARBAGE non-zero "device address" here and a GPU write
    // through it kills the device. Zero entries = the fault path, which is the designed
    // answer for an unmapped page.
    bda_pagetable_buffer.Fill(0, BDA_PAGETABLE_SIZE, 0);

    memory_tracker = std::make_unique<MemoryTracker>(tracker);

    if (GtBdaImportEnabled() && InitializeBdaBacking()) {
        bda_import_enabled = true;
        MapGuestMemory(0, CACHING_NUMPAGES * CACHING_PAGESIZE);
        if (GtDirectImportEnabled()) {
            LOG_CRITICAL(Render_Vulkan,
                         "[directimport] ACTIVE: coherent imported backing may serve strictly "
                         "read-only, non-image, uncached buffers");
        }
    }

    std::memset(gds_buffer.mapped_data.data(), 0, DataShareBufferSize);

    // Set up garbage collection parameters
    if (!instance.CanReportMemoryUsage()) {
        trigger_gc_memory = DEFAULT_TRIGGER_GC_MEMORY;
        critical_gc_memory = DEFAULT_CRITICAL_GC_MEMORY;
        return;
    }

    const s64 device_local_memory = static_cast<s64>(instance.GetTotalMemoryBudget());
    const s64 min_spacing_expected = device_local_memory - 1_GB;
    const s64 min_spacing_critical = device_local_memory - 512_MB;
    const s64 mem_threshold = std::min<s64>(device_local_memory, TARGET_GC_THRESHOLD);
    const s64 min_vacancy_expected = (6 * mem_threshold) / 10;
    const s64 min_vacancy_critical = (2 * mem_threshold) / 10;
    trigger_gc_memory = static_cast<u64>(
        std::max<u64>(std::min(device_local_memory - min_vacancy_expected, min_spacing_expected),
                      DEFAULT_TRIGGER_GC_MEMORY));
    critical_gc_memory = static_cast<u64>(
        std::max<u64>(std::min(device_local_memory - min_vacancy_critical, min_spacing_critical),
                      DEFAULT_CRITICAL_GC_MEMORY));
}

BufferCache::~BufferCache() {
    DestroyBdaBacking();
}

bool BufferCache::InitializeBdaBacking() {
    if (!instance.IsExternalMemoryHostSupported()) {
        LOG_CRITICAL(Render_Vulkan,
                     "[bdaimport] disabled: VK_EXT_external_memory_host is unavailable");
        return false;
    }

    const auto device = instance.GetDevice();
    const auto& address_space = memory->GetAddressSpace();
    u8* const backing_base = address_space.BackingBase();
    const u64 backing_size = address_space.BackingSizeBytes();
    const u64 host_alignment = instance.MinImportedHostPointerAlignment();
    if (backing_base == nullptr || backing_size == 0 || host_alignment == 0 ||
        reinterpret_cast<uintptr_t>(backing_base) % host_alignment != 0 ||
        backing_size % host_alignment != 0) {
        LOG_CRITICAL(Render_Vulkan,
                     "[bdaimport] disabled: backing {}+{:#x} does not satisfy host alignment "
                     "{:#x}",
                     fmt::ptr(backing_base), backing_size, host_alignment);
        return false;
    }

    // One-GiB imports stay below conservative single-allocation limits while keeping the whole
    // 8.25-GiB backing to only nine Vulkan objects on a stock devkit configuration.
    constexpr u64 ImportChunkSize = 1_GB;
    const vk::BufferUsageFlags usage = AllFlags | vk::BufferUsageFlagBits::eShaderDeviceAddress;
    const auto& memory_properties = instance.GetMemoryProperties();
    imported_backing_chunks.reserve(Common::DivCeil(backing_size, ImportChunkSize));

    for (u64 physical_addr = 0; physical_addr < backing_size;) {
        const u64 chunk_size = std::min(ImportChunkSize, backing_size - physical_addr);
        u8* const host_pointer = backing_base + physical_addr;
        const auto host_props = device.getMemoryHostPointerPropertiesEXT(
            vk::ExternalMemoryHandleTypeFlagBits::eHostAllocationEXT, host_pointer);
        if (host_props.result != vk::Result::eSuccess) {
            LOG_CRITICAL(Render_Vulkan,
                         "[bdaimport] disabled: host-pointer query failed at physical {:#x}: {}",
                         physical_addr, vk::to_string(host_props.result));
            DestroyBdaBacking();
            return false;
        }

        vk::StructureChain<vk::BufferCreateInfo, vk::ExternalMemoryBufferCreateInfo>
            buffer_chain = {
                vk::BufferCreateInfo{
                    .size = chunk_size,
                    .usage = usage,
                },
                vk::ExternalMemoryBufferCreateInfo{
                    .handleTypes = vk::ExternalMemoryHandleTypeFlagBits::eHostAllocationEXT,
                },
            };
        auto buffer_result = device.createBuffer(buffer_chain.get<vk::BufferCreateInfo>());
        if (buffer_result.result != vk::Result::eSuccess) {
            LOG_CRITICAL(Render_Vulkan,
                         "[bdaimport] disabled: buffer creation failed at physical {:#x}: {}",
                         physical_addr, vk::to_string(buffer_result.result));
            DestroyBdaBacking();
            return false;
        }
        const vk::Buffer buffer = buffer_result.value;
        const vk::MemoryRequirements requirements = device.getBufferMemoryRequirements(buffer);
        const u32 type_bits = host_props.value.memoryTypeBits & requirements.memoryTypeBits;
        s32 memory_type = -1;
        for (u32 i = 0; i < memory_properties.memoryTypeCount; ++i) {
            const auto flags = memory_properties.memoryTypes[i].propertyFlags;
            if ((type_bits & (1u << i)) == 0 ||
                !(flags & vk::MemoryPropertyFlagBits::eHostCoherent)) {
                continue;
            }
            // CPU writes reach this allocation through the AddressSpace mapping, not
            // vkMapMemory, so there is no legal non-coherent flush path. Prefer cached coherent
            // host memory when the driver exposes both choices (NVIDIA does).
            if (memory_type < 0 || (flags & vk::MemoryPropertyFlagBits::eHostCached)) {
                memory_type = static_cast<s32>(i);
            }
            if (flags & vk::MemoryPropertyFlagBits::eHostCached) {
                break;
            }
        }
        if (memory_type < 0 || requirements.size > chunk_size) {
            LOG_CRITICAL(Render_Vulkan,
                         "[bdaimport] disabled: incompatible import at physical {:#x} "
                         "(type bits {:#x}, required {:#x}, chunk {:#x})",
                         physical_addr, type_bits, requirements.size, chunk_size);
            device.destroyBuffer(buffer);
            DestroyBdaBacking();
            return false;
        }

        vk::StructureChain<vk::MemoryAllocateInfo, vk::ImportMemoryHostPointerInfoEXT,
                           vk::MemoryAllocateFlagsInfo>
            allocation_chain = {
                vk::MemoryAllocateInfo{
                    .allocationSize = requirements.size,
                    .memoryTypeIndex = static_cast<u32>(memory_type),
                },
                vk::ImportMemoryHostPointerInfoEXT{
                    .handleType = vk::ExternalMemoryHandleTypeFlagBits::eHostAllocationEXT,
                    .pHostPointer = host_pointer,
                },
                vk::MemoryAllocateFlagsInfo{
                    .flags = vk::MemoryAllocateFlagBits::eDeviceAddress,
                },
            };
        auto allocation_result =
            device.allocateMemory(allocation_chain.get<vk::MemoryAllocateInfo>());
        if (allocation_result.result != vk::Result::eSuccess) {
            LOG_CRITICAL(Render_Vulkan,
                         "[bdaimport] disabled: allocation import failed at physical {:#x}: {}",
                         physical_addr, vk::to_string(allocation_result.result));
            device.destroyBuffer(buffer);
            DestroyBdaBacking();
            return false;
        }
        const vk::DeviceMemory allocation = allocation_result.value;
        if (const vk::Result result = device.bindBufferMemory(buffer, allocation, 0);
            result != vk::Result::eSuccess) {
            LOG_CRITICAL(Render_Vulkan,
                         "[bdaimport] disabled: bind failed at physical {:#x}: {}", physical_addr,
                         vk::to_string(result));
            device.freeMemory(allocation);
            device.destroyBuffer(buffer);
            DestroyBdaBacking();
            return false;
        }

        const vk::DeviceAddress device_addr =
            device.getBufferAddress(vk::BufferDeviceAddressInfo{.buffer = buffer});
        if (device_addr == 0) {
            LOG_CRITICAL(Render_Vulkan,
                         "[bdaimport] disabled: imported chunk at physical {:#x} has no BDA",
                         physical_addr);
            device.destroyBuffer(buffer);
            device.freeMemory(allocation);
            DestroyBdaBacking();
            return false;
        }

        imported_backing_chunks.push_back(
            {buffer, allocation, device_addr, physical_addr, chunk_size, {}});
        imported_backing_chunks.back().direct_view =
            std::make_unique<Buffer>(instance, scheduler, buffer, device_addr, chunk_size);
        Vulkan::SetObjectName(device, buffer, "Imported Guest Backing {:#x}:{:#x}", physical_addr,
                              chunk_size);
        LOG_INFO(Render_Vulkan,
                 "[bdaimport] imported physical {:#x}+{:#x} as memory type {} at BDA {:#x}",
                 physical_addr, chunk_size, memory_type, device_addr);
        physical_addr += chunk_size;
    }

    LOG_CRITICAL(Render_Vulkan,
                 "[bdaimport] ACTIVE: {} MiB guest backing imported in {} chunk(s); cached "
                 "buffers retain precedence",
                 backing_size >> 20, imported_backing_chunks.size());
    return true;
}

void BufferCache::DestroyBdaBacking() {
    const auto device = instance.GetDevice();
    for (auto chunk = imported_backing_chunks.rbegin();
         chunk != imported_backing_chunks.rend(); ++chunk) {
        // The view borrows the raw handle, so it must disappear before the owner below.
        chunk->direct_view.reset();
        if (chunk->buffer) {
            device.destroyBuffer(chunk->buffer);
        }
        if (chunk->allocation) {
            device.freeMemory(chunk->allocation);
        }
    }
    imported_backing_chunks.clear();
    bda_import_enabled = false;
}

vk::DeviceAddress BufferCache::ImportedBdaAddress(PAddr physical_addr) const {
    for (const auto& chunk : imported_backing_chunks) {
        if (physical_addr >= chunk.physical_addr &&
            physical_addr < chunk.physical_addr + chunk.size) {
            return chunk.device_addr + physical_addr - chunk.physical_addr;
        }
    }
    return 0;
}

std::pair<Buffer*, u32> BufferCache::TryGetDirectImportedReadBuffer(VAddr virtual_addr, u32 size) {
    if (!bda_import_enabled || !GtDirectImportEnabled() || size == 0 || virtual_addr == 0 ||
        virtual_addr > std::numeric_limits<VAddr>::max() - size) {
        return {};
    }

    using Clock = std::chrono::steady_clock;
    const auto start = Clock::now();
    g_obtprof.direct_queries.fetch_add(1, std::memory_order_relaxed);
    const auto finish = [&] {
        g_obtprof.direct_query_ns.fetch_add(u64((Clock::now() - start).count()),
                                            std::memory_order_relaxed);
    };

    // A cached allocation can contain newer GPU-side bytes than guest RAM. It always wins.
    if (buffer_ranges.Intersects(virtual_addr, size)) {
        g_obtprof.direct_cached.fetch_add(1, std::memory_order_relaxed);
        finish();
        return {};
    }
    if (IsRegionGpuModified(virtual_addr, size) ||
        gpu_modified_ranges.Intersects(virtual_addr, size)) {
        g_obtprof.direct_gpu.fetch_add(1, std::memory_order_relaxed);
        finish();
        return {};
    }

    // Unformatted buffers can still alias an image allocation. Never bypass the texture
    // cache in that case, even when the buffer tracker itself has no registered range.
    bool overlaps_image = false;
    texture_cache.ForEachImageInRegion(virtual_addr, size, [&](ImageId, Image&) {
        overlaps_image = true;
        return true;
    });
    if (overlaps_image) {
        g_obtprof.direct_image.fetch_add(1, std::memory_order_relaxed);
        finish();
        return {};
    }

    const auto segments = memory->GetPhysicalBackingSegments(virtual_addr, size);
    if (segments.size() != 1 || segments[0].virtual_addr != virtual_addr ||
        segments[0].size != size ||
        segments[0].physical_addr > std::numeric_limits<PAddr>::max() - size) {
        g_obtprof.direct_backing.fetch_add(1, std::memory_order_relaxed);
        finish();
        return {};
    }

    const PAddr physical_addr = segments[0].physical_addr;
    const PAddr physical_end = physical_addr + size;
    for (auto& chunk : imported_backing_chunks) {
        if (physical_addr < chunk.physical_addr ||
            physical_end > chunk.physical_addr + chunk.size || !chunk.direct_view) {
            continue;
        }
        const u64 offset = physical_addr - chunk.physical_addr;
        if (offset > std::numeric_limits<u32>::max()) {
            break;
        }
        g_obtprof.direct_hits.fetch_add(1, std::memory_order_relaxed);
        g_obtprof.direct_bytes.fetch_add(size, std::memory_order_relaxed);
        finish();
        return {chunk.direct_view.get(), static_cast<u32>(offset)};
    }

    g_obtprof.direct_backing.fetch_add(1, std::memory_order_relaxed);
    finish();
    return {};
}

u64 BufferCache::WriteBdaFallbackSegment(VAddr virtual_addr, PAddr physical_addr, u64 size) {
    constexpr VAddr GuestBdaLimit = CACHING_NUMPAGES * CACHING_PAGESIZE;
    if (size == 0 || virtual_addr >= GuestBdaLimit ||
        virtual_addr > std::numeric_limits<VAddr>::max() - size) {
        return 0;
    }
    size = std::min<u64>(size, GuestBdaLimit - virtual_addr);

    // PS4 physical mappings are 16-KiB granular. Handle clipped queries too, but only when the
    // virtual and physical offsets agree so a page-base BDA remains exact.
    const u64 page_mask = CACHING_PAGESIZE - 1;
    if (((virtual_addr ^ physical_addr) & page_mask) != 0) {
        LOG_WARNING(Render_Vulkan,
                    "[bdaimport] skipped differently-aligned mapping {:#x}->{:#x}+{:#x}",
                    virtual_addr, physical_addr, size);
        return 0;
    }
    const VAddr aligned_begin = Common::AlignUp(virtual_addr, CACHING_PAGESIZE);
    const u64 head = aligned_begin - virtual_addr;
    if (head >= size) {
        return 0;
    }
    physical_addr += head;
    size = Common::AlignDown(size - head, CACHING_PAGESIZE);
    if (size == 0) {
        return 0;
    }

    const u64 first_page = aligned_begin >> CACHING_PAGEBITS;
    const u64 page_count = size >> CACHING_PAGEBITS;
    std::vector<vk::DeviceAddress> run;
    run.reserve(static_cast<size_t>(std::min<u64>(page_count, 65536)));
    u64 run_first_page = 0;
    u64 written_pages = 0;
    const auto flush = [&] {
        if (run.empty()) {
            return;
        }
        WriteDataBuffer(bda_pagetable_buffer, run_first_page * sizeof(vk::DeviceAddress),
                        run.data(), static_cast<u32>(run.size() * sizeof(vk::DeviceAddress)));
        run.clear();
    };

    for (u64 i = 0; i < page_count; ++i) {
        const u64 page = first_page + i;
        const PageData* const cached = page_table.find(page);
        const vk::DeviceAddress fallback =
            ImportedBdaAddress(physical_addr + (i << CACHING_PAGEBITS));
        if ((cached != nullptr && cached->buffer_id) || fallback == 0) {
            flush();
            continue;
        }
        if (run.empty()) {
            run_first_page = page;
        }
        run.push_back(fallback);
        ++written_pages;
    }
    flush();
    return written_pages;
}

void BufferCache::MapGuestMemory(VAddr device_addr, u64 size) {
    if (!bda_import_enabled || size == 0) {
        return;
    }
    const auto segments = memory->GetPhysicalBackingSegments(device_addr, size);
    if (segments.empty()) {
        return;
    }

    PendingBdaGuestUpdate update{
        .is_map = true,
        .virtual_addr = device_addr,
        .size = size,
    };
    update.segments.reserve(segments.size());
    for (const auto& segment : segments) {
        update.segments.push_back({segment.virtual_addr, segment.physical_addr, segment.size});
    }
    std::scoped_lock lock{pending_bda_guest_updates_mutex};
    pending_bda_guest_updates.push_back(std::move(update));
}

void BufferCache::RestoreBdaFallback(VAddr device_addr, u64 size) {
    if (!bda_import_enabled || size == 0) {
        return;
    }
    const auto segments = memory->GetPhysicalBackingSegments(device_addr, size);
    for (const auto& segment : segments) {
        [[maybe_unused]] const u64 written_pages =
            WriteBdaFallbackSegment(segment.virtual_addr, segment.physical_addr, segment.size);
    }
}

void BufferCache::UnmapGuestMemory(VAddr device_addr, u64 size) {
    if (!bda_import_enabled || size == 0 ||
        device_addr > std::numeric_limits<VAddr>::max() - size) {
        return;
    }

    PendingBdaGuestUpdate update{
        .is_map = false,
        .virtual_addr = device_addr,
        .size = size,
    };
    std::scoped_lock lock{pending_bda_guest_updates_mutex};
    pending_bda_guest_updates.push_back(std::move(update));
}

void BufferCache::ProcessGuestMemoryUpdates() {
    if (!bda_import_enabled) {
        return;
    }

    std::vector<PendingBdaGuestUpdate> updates;
    {
        std::scoped_lock lock{pending_bda_guest_updates_mutex};
        updates.swap(pending_bda_guest_updates);
    }

    static std::atomic<u32> map_log_budget{0};
    for (const auto& update : updates) {
        if (!update.is_map) {
            ApplyBdaGuestUnmap(update.virtual_addr, update.size);
            continue;
        }

        u64 written_pages = 0;
        for (const auto& segment : update.segments) {
            written_pages +=
                WriteBdaFallbackSegment(segment.virtual_addr, segment.physical_addr, segment.size);
        }
        if (written_pages != 0 &&
            map_log_budget.fetch_add(1, std::memory_order_relaxed) < 64) {
            LOG_INFO(Render_Vulkan,
                     "[bdaimport] mapped {:#x}+{:#x}: {} physical segment(s), {} fallback "
                     "page(s) [GPU thread]",
                     update.virtual_addr, update.size, update.segments.size(), written_pages);
        }
    }
}

void BufferCache::ApplyBdaGuestUnmap(VAddr device_addr, u64 size) {
    if (size == 0 || device_addr > std::numeric_limits<VAddr>::max() - size) {
        return;
    }
    constexpr VAddr GuestBdaLimit = CACHING_NUMPAGES * CACHING_PAGESIZE;
    const VAddr begin = Common::AlignDown(device_addr, CACHING_PAGESIZE);
    const VAddr end = std::min<VAddr>(Common::AlignUp(device_addr + size, CACHING_PAGESIZE),
                                     GuestBdaLimit);
    if (begin >= end) {
        return;
    }

    u64 zero_run_begin = 0;
    u64 zero_run_pages = 0;
    const auto flush = [&] {
        if (zero_run_pages == 0) {
            return;
        }
        const u64 offset =
            bda_pagetable_buffer.Offset(zero_run_begin * sizeof(vk::DeviceAddress));
        bda_pagetable_buffer.Fill(
            offset, static_cast<u32>(zero_run_pages * sizeof(vk::DeviceAddress)), 0);
        zero_run_pages = 0;
    };

    for (u64 page = begin >> CACHING_PAGEBITS; page < (end >> CACHING_PAGEBITS); ++page) {
        const PageData* const cached = page_table.find(page);
        if (cached != nullptr && cached->buffer_id) {
            flush();
            continue;
        }
        if (zero_run_pages == 0) {
            zero_run_begin = page;
        }
        ++zero_run_pages;
    }
    flush();
}

void BufferCache::InvalidateMemory(VAddr device_addr, u64 size) {
    if (!IsRegionRegistered(device_addr, size)) {
        return;
    }
    memory_tracker->InvalidateRegion(
        device_addr, size, [this, device_addr, size] { ReadMemory(device_addr, size, true); });
    // AFTER the tracker change (see LogDmaDirty's contract).
    LogDmaDirty(device_addr, size);
}

namespace {
// GT_FAULT_WIDE stage-2 instrument state (see GtNoteWideSuspect). A tiny fixed table: the
// suspects are a handful of stable per-frame ranges, deduplicated by base address.
struct WideSuspect {
    VAddr addr;
    u64 size;
    const char* tag;
};
std::array<WideSuspect, 32> g_wide_suspects{};
size_t g_wide_suspect_count = 0;
std::mutex g_wide_suspect_mutex;
} // namespace

void BufferCache::GtNoteWideSuspect(VAddr addr, u64 size, const char* tag) {
    if (addr < 0x10000 || size == 0) {
        return;
    }
    std::scoped_lock lk{g_wide_suspect_mutex};
    for (size_t i = 0; i < g_wide_suspect_count; ++i) {
        auto& s = g_wide_suspects[i];
        if (s.addr == addr) {
            s.size = std::max(s.size, size);
            s.tag = tag;
            return;
        }
    }
    if (g_wide_suspect_count < g_wide_suspects.size()) {
        g_wide_suspects[g_wide_suspect_count++] = {addr, size, tag};
        return;
    }
    // A full table means new BDA-store targets are going UNPROTECTED from the widen - say so
    // once, loudly, instead of silently reopening the run-211/212 clobber.
    static std::atomic<bool> overflow_logged{false};
    if (!overflow_logged.exchange(true, std::memory_order_relaxed)) {
        LOG_CRITICAL(Render_Vulkan,
                     "[widetbl] suspect table FULL ({} entries) - {} {:#x}+{:#x} dropped, the "
                     "widen clip no longer covers new ranges",
                     g_wide_suspects.size(), tag, addr, size);
    }
}

void BufferCache::GtHealSuspect(VAddr addr, u64 size, const char* tag) {
    GtNoteWideSuspect(addr, size, tag);
    const size_t cleared = memory_tracker->UnmarkRegionAsCpuModified(addr, size);
    if (cleared != 0) {
        // The GT_BIND_SKIP dirty mirror is deliberately NOT healed: it stays a superset, which
        // only costs a skipped skip, never a missed upload.
        static std::atomic<u32> heal_logs{0};
        if (heal_logs.fetch_add(1, std::memory_order_relaxed) < 128) {
            LOG_WARNING(Render_Vulkan,
                        "[healtbl] {} {:#x}+{:#x}: cleared {} speculatively-dirty page(s) before "
                        "the bind could upload stale bytes over the GPU's records",
                        tag, addr, size, cleared);
        }
    }
}

void BufferCache::WidenCpuDirty(VAddr device_addr, u64 size) {
    // Run 212 proved the mechanism this table exists for ([widetbl], 5 distinct ranges): a
    // widened mark swept pages holding a dispatch's GPU-written record buffers - BDA stores
    // never reach the tracker's gpu bits, so MarkCleanRegionAsCpuModified's ~gpu exclusion is
    // blind to them - and the next upload clobbered them with stale guest bytes. Run 211 died
    // as a device hang inside cs_018256c0; run 212 as a guest null-deref (read of 0x8) when the
    // game consumed the poisoned records. So the widening now goes AROUND the suspects: any
    // tracker page overlapping a noted range is left out of the widen and keeps the exact-fault
    // behavior (the REAL fault page is marked by InvalidateMemory's normal path, never here, so
    // a genuine CPU write into a suspect page still uploads - one fault at a time, as before
    // the widening existed). Taking a mutex here (the fault handler) has precedent: LogDmaDirty
    // below takes dma_dirty_mutex on the same path.
    struct Hole {
        VAddr lo, hi; // page-aligned exclusion, [lo, hi)
    };
    boost::container::static_vector<Hole, 32> holes;
    {
        std::scoped_lock lk{g_wide_suspect_mutex};
        for (size_t i = 0; i < g_wide_suspect_count; ++i) {
            const auto& s = g_wide_suspects[i];
            if (device_addr < s.addr + s.size && device_addr + size > s.addr) {
                static std::atomic<u32> widetbl_logs{0};
                if (widetbl_logs.fetch_add(1, std::memory_order_relaxed) < 128) {
                    LOG_WARNING(Render_Vulkan,
                                "[widetbl] widen {:#x}+{:#x} clipped around {} suspect "
                                "{:#x}+{:#x} - stale-upload clobber prevented",
                                device_addr, size, s.tag, s.addr, s.size);
                }
                holes.push_back({Common::AlignDown(s.addr, TRACKER_BYTES_PER_PAGE),
                                 Common::AlignUp(s.addr + s.size, TRACKER_BYTES_PER_PAGE)});
            }
        }
    }
    const auto mark = [&](VAddr lo, VAddr hi) {
        if (lo >= hi) {
            return;
        }
        // No IsRegionRegistered gate on purpose: pages outside any registered buffer are
        // harmless to mark (their manager either does not exist - born all-dirty - or nobody
        // uploads them), and gating on the WHOLE widened window being registered would refuse
        // the common case of a window straddling a buffer edge.
        memory_tracker->MarkCleanRegionAsCpuModified(lo, hi - lo);
        // AFTER the tracker change (LogDmaDirty's contract), so the mirror stays a superset.
        LogDmaDirty(lo, hi - lo);
    };
    if (holes.empty()) {
        mark(device_addr, device_addr + size);
        return;
    }
    std::sort(holes.begin(), holes.end(), [](const Hole& a, const Hole& b) { return a.lo < b.lo; });
    VAddr cursor = device_addr;
    const VAddr end = device_addr + size;
    for (const Hole& h : holes) {
        mark(cursor, std::min(end, h.lo));
        cursor = std::max(cursor, std::min(end, h.hi));
    }
    mark(cursor, end);
}

void BufferCache::ReadMemory(VAddr device_addr, u64 size, bool is_write) {
    liverpool->SendCommand<true>([this, device_addr, size, is_write] {
        Buffer& buffer = slot_buffers[FindBuffer(device_addr, size)];
        // GPU-modified ranges come as many small scattered islands, so the download
        // is widened to a window around the request
        constexpr u64 WindowSize = 512_KB;
        const VAddr buf_start = buffer.CpuAddr();
        const VAddr buf_end = buf_start + buffer.SizeBytes();
        const VAddr window_start =
            std::max<VAddr>(Common::AlignDown(device_addr, WindowSize), buf_start);
        const VAddr window_end = std::min<VAddr>(
            std::max<VAddr>(window_start + WindowSize, device_addr + size), buf_end);
        DownloadBufferMemory<false>(buffer, window_start, window_end - window_start);
        if (is_write) {
            memory_tracker->MarkRegionAsCpuModified(device_addr, size);
            LogDmaDirty(device_addr, size);
        }
    });
}

u8* BufferCache::RecordTableRegionCopy(VAddr addr, u64 size) {
    // Raw page-table resolve, deliberately NOT ObtainBuffer: the read-only <=16K path there
    // aliases the STREAM buffer (a fresh copy of guest RAM - the very zeros being diagnosed),
    // and a SynchronizeBuffer would upload CPU-dirty words OVER the GPU-written slots. If no
    // registered buffer covers the range, the GPU cannot have written it through a tracked
    // binding NOR through BDA (an unregistered page's pagetable entry is 0, so the store took
    // the fault path and the value is gone) - the caller logs that as its own verdict.
    const BufferId buffer_id = page_table[addr >> CACHING_PAGEBITS].buffer_id;
    if (IsBufferInvalid(buffer_id)) {
        return nullptr;
    }
    Buffer& buffer = slot_buffers[buffer_id];
    if (!buffer.IsInBounds(addr, size)) {
        return nullptr;
    }
    auto [download, offset] = download_buffer.Map(size);
    if (download == nullptr) {
        return nullptr; // 32 MB window exhausted mid-frame; the next occurrence retries
    }
    download_buffer.Commit();
    scheduler.EndRendering(); // a transfer inside dynamic rendering is invalid
    const auto cmdbuf = scheduler.CommandBuffer();
    // The producer wrote through shader paths the buffer cache never barriered (BDA writes
    // bypass every buffer-cache barrier); one global barrier makes them visible to the copy.
    const vk::MemoryBarrier2 pre_barrier = {
        .srcStageMask = vk::PipelineStageFlagBits2::eAllCommands,
        .srcAccessMask = vk::AccessFlagBits2::eMemoryWrite,
        .dstStageMask = vk::PipelineStageFlagBits2::eTransfer,
        .dstAccessMask = vk::AccessFlagBits2::eTransferRead,
    };
    cmdbuf.pipelineBarrier2(vk::DependencyInfo{
        .memoryBarrierCount = 1,
        .pMemoryBarriers = &pre_barrier,
    });
    cmdbuf.copyBuffer(buffer.Handle(), download_buffer.Handle(),
                      vk::BufferCopy{
                          .srcOffset = buffer.Offset(addr),
                          .dstOffset = offset,
                          .size = size,
                      });
    return download;
}

bool BufferCache::DownloadTableRegion(VAddr addr, u64 size, std::vector<u8>& out) {
    u8* download = RecordTableRegionCopy(addr, size);
    if (download == nullptr) {
        return false;
    }
    scheduler.Finish(); // submits the producer work recorded earlier in this cmdbuf + waits
    // The caller merges these bytes into guest RAM PER SLOT (run 159 measured the table as
    // mixed-ownership: slot 0 arrives from the game CPU, the rest from the GPU side) - a
    // whole-blob writeback here could clobber a fresh CPU slot with a stale cached copy.
    // No tracker mutation either: marking the range CPU-modified would upload the snapshot
    // back OVER newer GPU data on the next synchronize.
    out.assign(download, download + size);
    return true;
}

bool BufferCache::CaptureTableRegion(VAddr addr, u64 size,
                                     std::function<void(std::vector<u8>&&)>&& on_ready) {
    u8* download = RecordTableRegionCopy(addr, size);
    if (download == nullptr) {
        return false;
    }
    // The payload is read when the recorded tick completes; the stream-buffer region stays
    // reserved until then (Commit ties it to the current tick). Owning captures only - the
    // run-57 lesson (a deferred op reading a dead stack killed the parser thread).
    scheduler.DeferOperation([download, size, cb = std::move(on_ready)]() mutable {
        std::vector<u8> bytes(size);
        std::memcpy(bytes.data(), download, size);
        cb(std::move(bytes));
    });
    return true;
}

template <bool async>
void BufferCache::DownloadBufferMemory(Buffer& buffer, VAddr device_addr, u64 size) {
    // Same clamp as SynchronizeBuffer, on the read side: a window past the buffer's end
    // becomes a vkCmdCopyBuffer srcOffset outside the allocation - a raw device read with
    // no robustness (the ReadInvalid family).
    const VAddr dl_end = buffer.CpuAddr() + buffer.SizeBytes();
    if (device_addr >= dl_end) {
        return;
    }
    size = std::min<u64>(size, dl_end - device_addr);
    boost::container::small_vector<vk::BufferCopy, 1> copies;
    u64 total_size_bytes = 0;
    memory_tracker->ForEachDownloadRange<false>(
        device_addr, size, [&](u64 device_addr_out, u64 range_size) {
            const VAddr buffer_addr = buffer.CpuAddr();
            const auto add_download = [&](VAddr start, VAddr end) {
                // Same overshoot as the upload path, on the SOURCE side this time (it would
                // read past the end of this buffer instead of writing past it). Clamped here
                // for the same reason, before any region reaches the driver.
                const VAddr buffer_limit = buffer_addr + buffer.SizeBytes();
                start = std::max<VAddr>(start, buffer_addr);
                end = std::min<VAddr>(end, buffer_limit);
                if (start >= end) {
                    LogCopyClamp(buffer, start, 0, 0);
                    return;
                }
                const u64 new_offset = start - buffer_addr;
                const u64 new_size = end - start;
                copies.push_back(vk::BufferCopy{
                    .srcOffset = new_offset,
                    .dstOffset = total_size_bytes,
                    .size = new_size,
                });
                // Align up to avoid cache conflicts
                constexpr u64 align = 64ULL;
                constexpr u64 mask = ~(align - 1ULL);
                total_size_bytes += (new_size + align - 1) & mask;
            };
            gpu_modified_ranges.ForEachInRange(device_addr_out, range_size, add_download);
            gpu_modified_ranges.Subtract(device_addr_out, range_size);
        });
    if (total_size_bytes == 0) {
        return;
    }
    // ⚠⚠ THE DEVICE LOSS OF RUNS 111-115 WAS HERE. download_buffer is a FIXED 32 MB window and
    // StreamBuffer::Map returns {nullptr, 0} when asked for more (buffer.cpp:261) - the tracker
    // hands back whole dirty 4 MiB words, so one wide invalidation easily wants dozens. Nothing
    // checked the result: the regions went to vkCmdCopyBuffer anyway with dstOffsets marching
    // 32/36/40/44 MiB into a 32 MiB buffer (GpuAV: VUID-vkCmdCopyBuffer-dstOffset-00114 and
    // size-00116, 20 + 2 findings), and write_data would then have dereferenced nullptr. On this
    // driver the illegal copy became an unmapped WRITE inside the driver own 512-byte copy
    // kernel, which is why the vendor dump read "Write 0x2000x000, engine reset, shader hash
    // N/A" and named no shader of ours at all.
    // A temporary buffer sized for the job is what the UPLOAD path already does for exactly
    // this case (see UploadCopies), so the writeback is kept rather than dropped.
    auto [download, offset] = download_buffer.Map(total_size_bytes);
    std::unique_ptr<Buffer> temp_download;
    if (download == nullptr) {
        temp_download = std::make_unique<Buffer>(instance, scheduler, MemoryUsage::Download, 0,
                                                vk::BufferUsageFlagBits::eTransferDst,
                                                total_size_bytes);
        download = temp_download->mapped_data.data();
        offset = 0;
        g_temp_download_count.fetch_add(1, std::memory_order_relaxed);
        // Its own message: this used to route through LogCopyClamp and printed
        // "range X does not fit buffer X - dropped" for a readback that was neither
        // ill-fitting nor dropped (run 118 read it as a clamp bug). Nothing is lost here -
        // the download happens through a temporary buffer, at the price of a full stall.
        static std::atomic<u32> tempdl_logs{0};
        if (tempdl_logs.fetch_add(1, std::memory_order_relaxed) < 16) {
            LOG_WARNING(Render_Vulkan,
                        "[tempdl] download {:#x}+{:#x} ({} MB) exceeds the {} MB window - "
                        "temporary buffer + synchronous readback",
                        device_addr, total_size_bytes, total_size_bytes >> 20,
                        DownloadBufferSize >> 20);
        }
    }
    for (auto& copy : copies) {
        // Modify copies to have the staging offset in mind
        copy.dstOffset += offset;
    }
    if (!temp_download) {
        download_buffer.Commit();
    }
    scheduler.EndRendering();
    const auto cmdbuf = scheduler.CommandBuffer();
    cmdbuf.copyBuffer(buffer.buffer,
                      temp_download ? temp_download->Handle() : download_buffer.Handle(), copies);
    const auto write_data = [&]() {
        auto* memory = Core::Memory::Instance();
        for (const auto& copy : copies) {
            const VAddr copy_device_addr = buffer.CpuAddr() + copy.srcOffset;
            const u64 dst_offset = copy.dstOffset - offset;
            memory->TryWriteBacking(std::bit_cast<u8*>(copy_device_addr), download + dst_offset,
                                    copy.size);
            GtLogBufEvent("bufdl", copy_device_addr, copy.size, download + dst_offset);
        }
        memory_tracker->UnmarkRegionAsGpuModified(device_addr, size);
    };
    // A temporary download buffer lives on THIS stack, so its readback cannot be deferred:
    // finish and write back here. This path is a rare oversized invalidation, not a hot one.
    if (temp_download) {
        scheduler.Finish();
        write_data();
        return;
    }
    if constexpr (async) {
        // The obvious `DeferOperation(write_data)` is a use-after-free: write_data captures the
        // LOCALS (copies, offset, download, device_addr, size) BY REFERENCE, and a deferred op
        // runs after this frame is gone. Latent forever upstream because the only <true> caller
        // is the GC's clean_up, which upstream never invoked - the first GT_BUFFER_GC pass fired
        // it and the parser thread died reading a dead stack (non-canonical rdi, fault addr -1).
        scheduler.DeferOperation([this, own_copies = std::move(copies), own_offset = offset,
                                  own_download = download, buffer_addr = buffer.CpuAddr(),
                                  device_addr, size]() {
            auto* memory = Core::Memory::Instance();
            for (const auto& copy : own_copies) {
                const VAddr copy_device_addr = buffer_addr + copy.srcOffset;
                const u64 dst_offset = copy.dstOffset - own_offset;
                memory->TryWriteBacking(std::bit_cast<u8*>(copy_device_addr),
                                        own_download + dst_offset, copy.size);
                GtLogBufEvent("bufdl", copy_device_addr, copy.size, own_download + dst_offset);
            }
            memory_tracker->UnmarkRegionAsGpuModified(device_addr, size);
        });
    } else {
        scheduler.Finish();
        write_data();
    }
}

void BufferCache::BindVertexBuffers(
    const Vulkan::GraphicsPipeline& pipeline,
    boost::container::small_vector<vk::BufferMemoryBarrier2, 16>& barriers) {
    const auto& regs = liverpool->regs;
    Vulkan::VertexInputs<vk::VertexInputAttributeDescription2EXT> attributes;
    Vulkan::VertexInputs<vk::VertexInputBindingDescription2EXT> bindings;
    Vulkan::VertexInputs<vk::VertexInputBindingDivisorDescriptionEXT> divisors;
    Vulkan::VertexInputs<AmdGpu::Buffer> guest_buffers;
    pipeline.GetVertexInputs(attributes, bindings, divisors, guest_buffers,
                             regs.vgt_instance_step_rate_0, regs.vgt_instance_step_rate_1);

    if (instance.IsVertexInputDynamicState()) {
        // Update current vertex inputs.
        const auto cmdbuf = scheduler.CommandBuffer();
        cmdbuf.setVertexInputEXT(bindings, attributes);
    }

    if (bindings.empty()) {
        // If there are no bindings, there is nothing further to do.
        return;
    }

    struct BufferRange {
        VAddr base_address;
        VAddr end_address;
        vk::Buffer vk_buffer;
        u64 offset;

        [[nodiscard]] size_t GetSize() const {
            return end_address - base_address;
        }
    };

    // Build list of ranges covering the requested buffers
    Vulkan::VertexInputs<BufferRange> ranges{};
    for (const auto& buffer : guest_buffers) {
        if (buffer.base_address != 0 && buffer.GetSize() > 0) {
            ranges.emplace_back(buffer.base_address, buffer.base_address + buffer.GetSize());
        }
    }

    // Merge connecting ranges together
    Vulkan::VertexInputs<BufferRange> ranges_merged{};
    if (!ranges.empty()) {
        std::ranges::sort(ranges, [](const BufferRange& lhv, const BufferRange& rhv) {
            return lhv.base_address < rhv.base_address;
        });
        ranges_merged.emplace_back(ranges[0]);
        for (auto range : ranges) {
            auto& prev_range = ranges_merged.back();
            if (prev_range.end_address < range.base_address) {
                ranges_merged.emplace_back(range);
            } else {
                prev_range.end_address = std::max(prev_range.end_address, range.end_address);
            }
        }
    }

    // Map buffers for merged ranges
    for (auto& range : ranges_merged) {
        const u64 size = memory->ClampRangeSize(range.base_address, range.GetSize());
        if (size == 0) {
            // GT_SOFT_CLAMP survivor: torn vertex range - leave it unbound for this draw.
            LOG_CRITICAL(Render_Vulkan,
                         "[softclamp] vertex range base {:#x} unmapped - left unbound",
                         range.base_address);
            continue;
        }
        if (size > 1_GB) {
            // GT_SOFT_CLAMP symptom #4 (run 64): torn V# with a valid base and a garbage SIZE -
            // one 2.6 GiB vmaCreateBuffer killed the run with ErrorOutOfDeviceMemory. No real
            // vertex range is this big; leave it unbound for this draw.
            LOG_CRITICAL(Render_Vulkan,
                         "[softclamp] vertex range base {:#x} size {} MB - torn size, left unbound",
                         range.base_address, size >> 20);
            continue;
        }
        const auto [buffer, offset] = ObtainBuffer(range.base_address, size, false);
        range.vk_buffer = buffer->buffer;
        range.offset = offset;
        if (IsRegionGpuModified(range.base_address, size)) {
            if (auto barrier =
                    buffer->GetBarrier(vk::AccessFlagBits2::eVertexAttributeRead,
                                       vk::PipelineStageFlagBits2::eVertexAttributeInput)) {
                barriers.emplace_back(*barrier);
            }
        }
    }

    // Bind vertex buffers
    Vulkan::VertexInputs<vk::Buffer> host_buffers;
    Vulkan::VertexInputs<vk::DeviceSize> host_offsets;
    Vulkan::VertexInputs<vk::DeviceSize> host_sizes;
    Vulkan::VertexInputs<vk::DeviceSize> host_strides;
    for (const auto& buffer : guest_buffers) {
        if (buffer.base_address != 0 && buffer.GetSize() > 0) {
            const auto host_buffer_info =
                std::ranges::find_if(ranges_merged, [&](const BufferRange& range) {
                    return buffer.base_address >= range.base_address &&
                           buffer.base_address < range.end_address;
                });
            ASSERT(host_buffer_info != ranges_merged.cend());
            host_buffers.emplace_back(host_buffer_info->vk_buffer);
            host_offsets.push_back(host_buffer_info->offset + buffer.base_address -
                                   host_buffer_info->base_address);
        } else {
            host_buffers.emplace_back(VK_NULL_HANDLE);
            host_offsets.push_back(0);
        }
        host_sizes.push_back(buffer.GetSize());
        host_strides.push_back(buffer.GetStride());
    }

    const auto cmdbuf = scheduler.CommandBuffer();
    const auto num_buffers = guest_buffers.size();
    if (instance.IsVertexInputDynamicState()) {
        cmdbuf.bindVertexBuffers(0, num_buffers, host_buffers.data(), host_offsets.data());
    } else {
        cmdbuf.bindVertexBuffers2(0, num_buffers, host_buffers.data(), host_offsets.data(),
                                  host_sizes.data(), host_strides.data());
    }
}

void BufferCache::BindIndexBuffer(
    u32 index_offset, boost::container::small_vector<vk::BufferMemoryBarrier2, 16>& barriers) {
    const auto& regs = liverpool->regs;

    // Figure out index type and size.
    const bool is_index16 = regs.index_buffer_type.index_type == AmdGpu::IndexType::Index16;
    const vk::IndexType index_type = is_index16 ? vk::IndexType::eUint16 : vk::IndexType::eUint32;
    const u32 index_size = is_index16 ? sizeof(u16) : sizeof(u32);
    const VAddr index_address =
        regs.index_base_address.Address<VAddr>() + index_offset * index_size;

    // Bind index buffer.
    const u32 index_buffer_size = regs.num_indices * index_size;
    const auto [vk_buffer, offset] = ObtainBuffer(index_address, index_buffer_size, false);
    if (IsRegionGpuModified(index_address, index_buffer_size)) {
        if (auto barrier = vk_buffer->GetBarrier(vk::AccessFlagBits2::eIndexRead,
                                                 vk::PipelineStageFlagBits2::eIndexInput)) {
            barriers.emplace_back(*barrier);
        }
    }
    const auto cmdbuf = scheduler.CommandBuffer();
    cmdbuf.bindIndexBuffer(vk_buffer->Handle(), offset, index_type);
}

void BufferCache::FillBuffer(VAddr address, u32 num_bytes, u32 value, bool is_gds) {
    ASSERT_MSG(address % 4 == 0, "GDS offset must be dword aligned");
    if (!is_gds) {
        texture_cache.ClearMeta(address);
        if (!IsRegionGpuModified(address, num_bytes)) {
            u32* buffer = std::bit_cast<u32*>(address);
            std::fill(buffer, buffer + num_bytes / sizeof(u32), value);
            return;
        }
    }
    Buffer* buffer = [&] {
        if (is_gds) {
            return &gds_buffer;
        }
        const auto [buffer, offset] = ObtainBuffer(address, num_bytes, true);
        return buffer;
    }();
    buffer->Fill(buffer->Offset(address), num_bytes, value);
}

void BufferCache::CopyBuffer(VAddr dst, VAddr src, u32 num_bytes, bool dst_gds, bool src_gds) {
    if (!dst_gds && !IsRegionGpuModified(dst, num_bytes)) {
        if (!src_gds && !IsRegionGpuModified(src, num_bytes) &&
            !texture_cache.FindImageFromRange(src, num_bytes)) {
            // Both buffers were not transferred to GPU yet. Can safely copy in host memory.
            GtLogBufEvent("bufcopy cpu dst", dst, num_bytes, std::bit_cast<const u8*>(src));
            memcpy(std::bit_cast<void*>(dst), std::bit_cast<void*>(src), num_bytes);
            return;
        }
        // Without a readback there's nothing we can do with this
        // Fallback to creating dst buffer on GPU to at least have this data there
    }
    GtLogBufEvent("bufcopy gpu dst", dst, num_bytes, nullptr);
    GtLogBufEvent("bufcopy gpu src", src, num_bytes, nullptr);
    texture_cache.InvalidateMemoryFromGPU(dst, num_bytes);
    auto& src_buffer = [&] -> const Buffer& {
        if (src_gds) {
            return gds_buffer;
        }
        const auto buffer_id = FindBuffer(src, num_bytes);
        auto& buffer = slot_buffers[buffer_id];
        SynchronizeBuffer(buffer, src, num_bytes, false, true);
        return buffer;
    }();
    auto& dst_buffer = [&] -> const Buffer& {
        if (dst_gds) {
            return gds_buffer;
        }
        const auto buffer_id = FindBuffer(dst, num_bytes);
        auto& buffer = slot_buffers[buffer_id];
        SynchronizeBuffer(buffer, dst, num_bytes, true, true);
        gpu_modified_ranges.Add(dst, num_bytes);
        return buffer;
    }();
    const vk::BufferCopy region = {
        .srcOffset = src_buffer.Offset(src),
        .dstOffset = dst_buffer.Offset(dst),
        .size = num_bytes,
    };
    const vk::BufferMemoryBarrier2 buf_barriers_before[2] = {
        {
            .srcStageMask = vk::PipelineStageFlagBits2::eAllCommands,
            .srcAccessMask = vk::AccessFlagBits2::eMemoryRead,
            .dstStageMask = vk::PipelineStageFlagBits2::eAllCommands,
            .dstAccessMask = vk::AccessFlagBits2::eTransferWrite,
            .buffer = dst_buffer.Handle(),
            .offset = dst_buffer.Offset(dst),
            .size = num_bytes,
        },
        {
            .srcStageMask = vk::PipelineStageFlagBits2::eAllCommands,
            .srcAccessMask = vk::AccessFlagBits2::eMemoryWrite,
            .dstStageMask = vk::PipelineStageFlagBits2::eAllCommands,
            .dstAccessMask = vk::AccessFlagBits2::eTransferRead,
            .buffer = src_buffer.Handle(),
            .offset = src_buffer.Offset(src),
            .size = num_bytes,
        },
    };
    scheduler.EndRendering();
    const auto cmdbuf = scheduler.CommandBuffer();
    cmdbuf.pipelineBarrier2(vk::DependencyInfo{
        .dependencyFlags = vk::DependencyFlagBits::eByRegion,
        .bufferMemoryBarrierCount = 2,
        .pBufferMemoryBarriers = buf_barriers_before,
    });
    cmdbuf.copyBuffer(src_buffer.Handle(), dst_buffer.Handle(), region);
    const vk::BufferMemoryBarrier2 buf_barriers_after[2] = {
        {
            .srcStageMask = vk::PipelineStageFlagBits2::eAllCommands,
            .srcAccessMask = vk::AccessFlagBits2::eTransferWrite,
            .dstStageMask = vk::PipelineStageFlagBits2::eAllCommands,
            .dstAccessMask = vk::AccessFlagBits2::eMemoryRead,
            .buffer = dst_buffer.Handle(),
            .offset = dst_buffer.Offset(dst),
            .size = num_bytes,
        },
        {
            .srcStageMask = vk::PipelineStageFlagBits2::eAllCommands,
            .srcAccessMask = vk::AccessFlagBits2::eTransferRead,
            .dstStageMask = vk::PipelineStageFlagBits2::eAllCommands,
            .dstAccessMask = vk::AccessFlagBits2::eMemoryWrite,
            .buffer = src_buffer.Handle(),
            .offset = src_buffer.Offset(src),
            .size = num_bytes,
        },
    };
    cmdbuf.pipelineBarrier2(vk::DependencyInfo{
        .dependencyFlags = vk::DependencyFlagBits::eByRegion,
        .bufferMemoryBarrierCount = 2,
        .pBufferMemoryBarriers = buf_barriers_after,
    });
}

std::pair<Buffer*, u32> BufferCache::ObtainBuffer(VAddr device_addr, u32 size, bool is_written,
                                                  bool is_texel_buffer, BufferId buffer_id) {
    const bool prof = DmaProfEnabled();
    using Clock = std::chrono::steady_clock;
    const auto t0 = prof ? Clock::now() : Clock::time_point{};
    // For read-only buffers use device local stream buffer to reduce renderpass breaks.
    if (!is_written && size <= CACHING_PAGESIZE) {
        const bool gpu_modified = IsRegionGpuModified(device_addr, size);
        const auto t1 = prof ? Clock::now() : Clock::time_point{};
        if (prof) {
            g_obtprof.gpumod_ns.fetch_add(u64((t1 - t0).count()), std::memory_order_relaxed);
        }
        if (!gpu_modified) {
            const u64 offset =
                stream_buffer.Copy(device_addr, size, instance.UniformMinAlignment());
            if (prof) {
                g_obtprof.stream_calls.fetch_add(1, std::memory_order_relaxed);
                g_obtprof.stream_bytes.fetch_add(size, std::memory_order_relaxed);
                g_obtprof.stream_ns.fetch_add(u64((Clock::now() - t1).count()),
                                              std::memory_order_relaxed);
                MaybeFlushObtainProf();
            }
            return {&stream_buffer, offset};
        }
    }
    // A valid caller-supplied ID is an explicit cached-buffer dependency and must retain
    // precedence. Otherwise, let large plain read buffers use coherent imported guest memory.
    if (!is_written && !is_texel_buffer && IsBufferInvalid(buffer_id)) {
        if (auto direct = TryGetDirectImportedReadBuffer(device_addr, size); direct.first) {
            if (prof) {
                MaybeFlushObtainProf();
            }
            return direct;
        }
    }
    if (IsBufferInvalid(buffer_id)) {
        buffer_id = FindBuffer(device_addr, size);
    }
    Buffer& buffer = slot_buffers[buffer_id];
    const auto t2 = prof ? Clock::now() : Clock::time_point{};
    SynchronizeBuffer(buffer, device_addr, size, is_written, is_texel_buffer);
    if (prof) {
        g_obtprof.cached_calls.fetch_add(1, std::memory_order_relaxed);
        g_obtprof.sync_ns.fetch_add(u64((Clock::now() - t2).count()), std::memory_order_relaxed);
        MaybeFlushObtainProf();
    }
    if (is_written) {
        gpu_modified_ranges.Add(device_addr, size);
    }
    return {&buffer, buffer.Offset(device_addr)};
}

std::pair<Buffer*, u32> BufferCache::ObtainBufferForImage(VAddr gpu_addr, u32 size) {
    // [imgsrc] (readback hunt): which of the three sources feeds a watched image's refresh.
    // "cached" can carry GPU data the guest never saw; "staging" is a plain guest-RAM copy -
    // if the exposure image refreshes from staging, the DMA'd value can never reach it.
    const bool gt_watched = GtWatchHit(gpu_addr, size) != nullptr;
    const auto gt_imgsrc = [&](const char* src) {
        static u32 gt_imgsrc_budget = 0;
        if (gt_watched && gt_imgsrc_budget++ < 256) {
            LOG_WARNING(Render_Vulkan, "[imgsrc] {:#x}+{:#x} <- {} (gpumod {:d} cpudirty {:d})",
                        gpu_addr, size, src, IsRegionGpuModified(gpu_addr, size),
                        IsRegionCpuModified(gpu_addr, size));
        }
    };
    // Check if any buffer contains the full requested range.
    const BufferId buffer_id = page_table[gpu_addr >> CACHING_PAGEBITS].buffer_id;
    if (buffer_id) {
        if (Buffer& buffer = slot_buffers[buffer_id]; buffer.IsInBounds(gpu_addr, size)) {
            gt_imgsrc("cached");
            SynchronizeBuffer(buffer, gpu_addr, size, false, false);
            return {&buffer, buffer.Offset(gpu_addr)};
        }
    }
    // If some buffer within was GPU modified create a full buffer to avoid losing GPU data.
    if (IsRegionGpuModified(gpu_addr, size)) {
        gt_imgsrc("gpumod-obtain");
        return ObtainBuffer(gpu_addr, size, false, false);
    }
    // In all other cases, just do a CPU copy to the staging buffer.
    gt_imgsrc("staging");
    const auto [data, offset] = staging_buffer.Map(size, 16);
    memory->CopySparseMemory(gpu_addr, data, size);
    staging_buffer.Commit();
    return {&staging_buffer, offset};
}

bool BufferCache::IsRegionRegistered(VAddr addr, size_t size) {
    // Check if we are missing some edge case here
    return buffer_ranges.Intersects(addr, size);
}

bool BufferCache::IsRegionCpuModified(VAddr addr, size_t size) {
    return memory_tracker->IsRegionCpuModified(addr, size);
}

bool BufferCache::IsRegionGpuModified(VAddr addr, size_t size) {
    return memory_tracker->IsRegionGpuModified(addr, size);
}

BufferId BufferCache::FindBuffer(VAddr device_addr, u32 size) {
    ASSERT(device_addr != 0);
    const u64 page = device_addr >> CACHING_PAGEBITS;
    const BufferId buffer_id = page_table[page].buffer_id;
    if (!buffer_id) {
        return CreateBuffer(device_addr, size);
    }
    const Buffer& buffer = slot_buffers[buffer_id];
    if (buffer.IsInBounds(device_addr, size)) {
        return buffer_id;
    }
    return CreateBuffer(device_addr, size);
}

BufferCache::OverlapResult BufferCache::ResolveOverlaps(VAddr device_addr, u32 wanted_size) {
    // GT7 (19 Aug, runs 78+81): this walked page_table with a wild index and took the
    // process down twice - the address arrived from a junk descriptor some path had not
    // guarded. Refuse anything outside the guest space or small enough to underflow the
    // expand-begin math, and SAY which address so the unguarded caller can be found.
    if (device_addr < CACHING_PAGESIZE + DEVICE_PAGESIZE ||
        device_addr + wanted_size >= (u64{1} << 40)) {
        LOG_CRITICAL(Render_Vulkan,
                     "ResolveOverlaps: refusing suspicious range {:#x}+{:#x} - junk descriptor "
                     "reached the buffer cache unguarded",
                     device_addr, wanted_size);
        return OverlapResult{
            .ids = {},
            .begin = device_addr,
            .end = device_addr + wanted_size,
            .has_stream_leap = false,
        };
    }
    static constexpr int STREAM_LEAP_THRESHOLD = 16;
    boost::container::small_vector<BufferId, 16> overlap_ids;
    VAddr begin = device_addr;
    VAddr end = device_addr + wanted_size;
    int stream_score = 0;
    bool has_stream_leap = false;
    const auto expand_begin = [&](VAddr add_value) {
        static constexpr VAddr min_page = CACHING_PAGESIZE + DEVICE_PAGESIZE;
        // (begin - min_page) UNDERFLOWS for begin < min_page and the guard then never
        // fires - device_addr wraps past 2^64 and page_table reads wild memory.
        if (begin < min_page || add_value > begin - min_page) {
            begin = min_page;
            device_addr = DEVICE_PAGESIZE;
            return;
        }
        begin -= add_value;
        device_addr = begin - CACHING_PAGESIZE;
    };
    const auto expand_end = [&](VAddr add_value) {
        static constexpr VAddr max_page = 1ULL << MemoryTracker::MAX_CPU_PAGE_BITS;
        if (add_value > max_page - end) {
            end = max_page;
            return;
        }
        end += add_value;
    };
    if (begin == 0) {
        return OverlapResult{
            .ids = std::move(overlap_ids),
            .begin = begin,
            .end = end,
            .has_stream_leap = has_stream_leap,
        };
    }
    for (; device_addr >> CACHING_PAGEBITS < Common::DivCeil(end, CACHING_PAGESIZE);
         device_addr += CACHING_PAGESIZE) {
        const BufferId overlap_id = page_table[device_addr >> CACHING_PAGEBITS].buffer_id;
        if (!overlap_id) {
            continue;
        }
        Buffer& overlap = slot_buffers[overlap_id];
        if (overlap.is_picked) {
            continue;
        }
        overlap_ids.push_back(overlap_id);
        overlap.is_picked = true;
        const VAddr overlap_device_addr = overlap.CpuAddr();
        const bool expands_left = overlap_device_addr < begin;
        if (expands_left) {
            begin = overlap_device_addr;
        }
        const VAddr overlap_end = overlap_device_addr + overlap.SizeBytes();
        const bool expands_right = overlap_end > end;
        if (overlap_end > end) {
            end = overlap_end;
        }
        stream_score += overlap.StreamScore();
        if (stream_score > STREAM_LEAP_THRESHOLD && !has_stream_leap) {
            // When this memory region has been joined a bunch of times, we assume it's being used
            // as a stream buffer. Increase the size to skip constantly recreating buffers.
            has_stream_leap = true;
            if (expands_right) {
                expand_end(CACHING_PAGESIZE * 128);
            }
            if (expands_left) {
                expand_begin(CACHING_PAGESIZE * 128);
            }
        }
    }
    return OverlapResult{
        .ids = std::move(overlap_ids),
        .begin = begin,
        .end = end,
        .has_stream_leap = has_stream_leap,
    };
}

void BufferCache::JoinOverlap(BufferId new_buffer_id, BufferId overlap_id,
                              bool accumulate_stream_score) {
    Buffer& new_buffer = slot_buffers[new_buffer_id];
    Buffer& overlap = slot_buffers[overlap_id];
    if (accumulate_stream_score) {
        new_buffer.IncreaseStreamScore(overlap.StreamScore() + 1);
    }
    const size_t dst_base_offset = overlap.CpuAddr() - new_buffer.CpuAddr();
    const vk::BufferCopy copy = {
        .srcOffset = 0,
        .dstOffset = dst_base_offset,
        .size = overlap.SizeBytes(),
    };
    scheduler.EndRendering();
    const auto cmdbuf = scheduler.CommandBuffer();

    boost::container::static_vector<vk::BufferMemoryBarrier2, 2> pre_barriers{};
    if (auto src_barrier = overlap.GetBarrier(vk::AccessFlagBits2::eTransferRead,
                                              vk::PipelineStageFlagBits2::eTransfer)) {
        pre_barriers.push_back(*src_barrier);
    }
    if (auto dst_barrier =
            new_buffer.GetBarrier(vk::AccessFlagBits2::eTransferWrite,
                                  vk::PipelineStageFlagBits2::eTransfer, dst_base_offset)) {
        pre_barriers.push_back(*dst_barrier);
    }
    cmdbuf.pipelineBarrier2(vk::DependencyInfo{
        .dependencyFlags = vk::DependencyFlagBits::eByRegion,
        .bufferMemoryBarrierCount = static_cast<u32>(pre_barriers.size()),
        .pBufferMemoryBarriers = pre_barriers.data(),
    });

    cmdbuf.copyBuffer(overlap.Handle(), new_buffer.Handle(), copy);

    boost::container::static_vector<vk::BufferMemoryBarrier2, 2> post_barriers{};
    if (auto src_barrier =
            overlap.GetBarrier(vk::AccessFlagBits2::eMemoryRead | vk::AccessFlagBits2::eMemoryWrite,
                               vk::PipelineStageFlagBits2::eAllCommands)) {
        post_barriers.push_back(*src_barrier);
    }
    if (auto dst_barrier = new_buffer.GetBarrier(
            vk::AccessFlagBits2::eMemoryRead | vk::AccessFlagBits2::eMemoryWrite,
            vk::PipelineStageFlagBits2::eAllCommands, dst_base_offset)) {
        post_barriers.push_back(*dst_barrier);
    }
    cmdbuf.pipelineBarrier2(vk::DependencyInfo{
        .dependencyFlags = vk::DependencyFlagBits::eByRegion,
        .bufferMemoryBarrierCount = static_cast<u32>(post_barriers.size()),
        .pBufferMemoryBarriers = post_barriers.data(),
    });
    DeleteBuffer(overlap_id);
}

BufferId BufferCache::CreateBuffer(VAddr device_addr, u32 wanted_size) {
    const VAddr device_addr_end = Common::AlignUp(device_addr + wanted_size, CACHING_PAGESIZE);
    device_addr = Common::AlignDown(device_addr, CACHING_PAGESIZE);
    wanted_size = static_cast<u32>(device_addr_end - device_addr);
    // GT7 (19 Aug, run 82): a junk descriptor base (bindless chase) aligned down to 0 got a
    // 256 MB buffer created AND REGISTERED at guest address 0 - poisoning page_table and the
    // BDA pagetable for the whole low 256 MB. Hand back an unregistered 1-page dummy: the
    // caller gets a valid device buffer, nothing is claimed, nothing syncs from wild memory.
    if (device_addr < CACHING_PAGESIZE || device_addr + wanted_size >= (u64{1} << 40)) {
        LOG_CRITICAL(Render_Vulkan,
                     "CreateBuffer: junk range {:#x}+{:#x} - substituting an unregistered "
                     "dummy page",
                     device_addr, wanted_size);
        return slot_buffers.insert(instance, scheduler, MemoryUsage::DeviceLocal,
                                   CACHING_PAGESIZE,
                                   AllFlags | vk::BufferUsageFlagBits::eShaderDeviceAddress,
                                   CACHING_PAGESIZE);
    }
    const OverlapResult overlap = ResolveOverlaps(device_addr, wanted_size);
    const u32 size = static_cast<u32>(overlap.end - overlap.begin);
    const BufferId new_buffer_id =
        slot_buffers.insert(instance, scheduler, MemoryUsage::DeviceLocal, overlap.begin,
                            AllFlags | vk::BufferUsageFlagBits::eShaderDeviceAddress, size);
    auto& new_buffer = slot_buffers[new_buffer_id];
    for (const BufferId overlap_id : overlap.ids) {
        JoinOverlap(new_buffer_id, overlap_id, !overlap.has_stream_leap);
    }
    Register(new_buffer_id);
    // A fresh buffer's tracker regions are born all-CPU-dirty (RegionManager's ctor does
    // cpu.Fill()) with no MarkRegionAsCpuModified call anywhere - the full DMA walk used to
    // pick that initial upload up by visiting every buffer. The dirty log must hear about it
    // too, or a fault-created buffer ships zeros to the next DMA dispatch.
    LogDmaDirty(overlap.begin, size);
    return new_buffer_id;
}

void BufferCache::ProcessFaultBuffer() {
    fault_manager.ProcessFaultBuffer();
}

bool BufferCache::IsFaultAddressValid(VAddr addr, u64 size) {
    return memory->IsValidGpuMapping(addr, size) && memory->IsValidMapping(addr, size);
}

void BufferCache::Register(BufferId buffer_id) {
    ChangeRegister<true>(buffer_id);
}

void BufferCache::Unregister(BufferId buffer_id) {
    ChangeRegister<false>(buffer_id);
}

template <bool insert>
void BufferCache::ChangeRegister(BufferId buffer_id) {
    Buffer& buffer = slot_buffers[buffer_id];
    const auto size = buffer.SizeBytes();
    const VAddr device_addr_begin = buffer.CpuAddr();
    const VAddr device_addr_end = device_addr_begin + size;
    const u64 page_begin = device_addr_begin / CACHING_PAGESIZE;
    const u64 page_end = Common::DivCeil(device_addr_end, CACHING_PAGESIZE);
    const u64 size_pages = page_end - page_begin;
    for (u64 page = page_begin; page != page_end; ++page) {
        if constexpr (insert) {
            page_table[page].buffer_id = buffer_id;
        } else {
            page_table[page].buffer_id = BufferId{};
        }
    }
    if constexpr (insert) {
        total_used_memory += Common::AlignUp(size, CACHING_PAGESIZE);
        live_buffer_bytes += Common::AlignUp(size, CACHING_PAGESIZE);
        ++live_buffer_count;
        buffer.SetLRUId(lru_cache.Insert(buffer_id, gc_tick));
        boost::container::small_vector<vk::DeviceAddress, 128> bda_addrs;
        bda_addrs.reserve(size_pages);
        for (u64 i = 0; i < size_pages; ++i) {
            vk::DeviceAddress addr = buffer.BufferDeviceAddress() + (i << CACHING_PAGEBITS);
            bda_addrs.push_back(addr);
        }
        WriteDataBuffer(bda_pagetable_buffer, page_begin * sizeof(vk::DeviceAddress),
                        bda_addrs.data(), bda_addrs.size() * sizeof(vk::DeviceAddress));
        buffer_ranges.Add(buffer.CpuAddr(), buffer.SizeBytes(), buffer_id);
    } else {
        total_used_memory -= Common::AlignUp(size, CACHING_PAGESIZE);
        live_buffer_bytes -= Common::AlignUp(size, CACHING_PAGESIZE);
        --live_buffer_count;
        lru_cache.Free(buffer.LRUId());
        const u64 offset = bda_pagetable_buffer.Offset(page_begin * sizeof(vk::DeviceAddress));
        bda_pagetable_buffer.Fill(offset, size_pages * sizeof(vk::DeviceAddress), 0);
        // A cached buffer always wins while registered. Once it dies, restore the direct
        // imported-backing address for pages that still have a physical guest mapping.
        RestoreBdaFallback(device_addr_begin, size);
        buffer_ranges.Subtract(buffer.CpuAddr(), buffer.SizeBytes());
    }
}

bool BufferCache::SynchronizeBuffer(Buffer& buffer, VAddr device_addr, u32 size, bool is_written,
                                    bool is_texel_buffer) {
    const VAddr buffer_start = buffer.CpuAddr();
    const VAddr buffer_end = buffer_start + buffer.SizeBytes();
    // Clamp the sync window to the VkBuffer that will receive the copies. A tail-clamped
    // bind (256 MB window) over a smaller cache buffer used to hand ForEachUploadRange a
    // range past the buffer's end, and the tracker's dirty ranges then became vkCmdCopyBuffer
    // regions BEYOND the destination - GpuAV run 103 caught it red-handed, 20x
    // "pRegions[8].dstOffset (33554432) is greater than size of dstBuffer (33554432)" plus a
    // 4 MiB write past the end. Transfer ops have NO robustness; that is a raw device write
    // out of the allocation, the same class as the ReadInvalid 0x300100000 family.
    if (device_addr >= buffer_end) {
        return false;
    }
    if (device_addr + size > buffer_end) {
        static std::atomic<u32> sync_clamp_logs{0};
        if (sync_clamp_logs.fetch_add(1, std::memory_order_relaxed) < 32) {
            LOG_CRITICAL(Render_Vulkan,
                         "[softclamp] SynchronizeBuffer window {:#x}+{:#x} exceeds buffer "
                         "{:#x}+{:#x} - clamped",
                         device_addr, size, buffer_start, buffer.SizeBytes());
        }
        size = static_cast<u32>(buffer_end - device_addr);
    }
    // GT_BIND_SKIP: if no producer logged a CPU-dirty transition inside this (clamped) window
    // since it was last synchronized, the tracker walk below can only find clean pages - skip
    // it. The subtract happens BEFORE the walk (a claim): a producer racing in during the walk
    // re-adds its range after our subtract, so it survives for the next sync. What must NOT be
    // skipped: the GPU marking an is_written bind performs (readbacks, the stream path's
    // IsRegionGpuModified and buffer-GC downloads all read those bits - done cheaply via
    // MarkRegionAsGpuModified, no mask copies), and the image->buffer refresh a texel-buffer
    // bind runs (GPU-side data, not gated by CPU dirtiness).
    if (BindSkipEnabled()) {
        const bool prof = DmaProfEnabled();
        using Clock = std::chrono::steady_clock;
        const auto t0 = prof ? Clock::now() : Clock::time_point{};
        // Run 207: asking only "is ANYTHING dirty in the window?" left a big is_written window
        // walking all of its regions to upload one 64 KiB span - the answer for a 256 MiB
        // window is almost always yes. Collect the actual dirty spans instead (ForEachInRange
        // clamps them to the window) and walk exactly those: by the mirror-superset invariant
        // no tracker-dirty page in the window can lie outside them.
        boost::container::small_vector<std::pair<VAddr, u32>, 4> dirty_spans;
        {
            std::scoped_lock lk{dma_dirty_mutex};
            bind_dirty_ranges.ForEachInRange(device_addr, size, [&](VAddr r0, VAddr r1) {
                dirty_spans.emplace_back(r0, static_cast<u32>(r1 - r0));
            });
            if (!dirty_spans.empty()) {
                bind_dirty_ranges.Subtract(device_addr, size);
            }
        }
        if (prof) {
            g_obtprof.gate_ns.fetch_add(u64((Clock::now() - t0).count()),
                                        std::memory_order_relaxed);
        }
        if (dirty_spans.empty()) {
            if (prof) {
                auto& counter = is_written ? g_obtprof.skip_written : g_obtprof.skip_read;
                counter.fetch_add(1, std::memory_order_relaxed);
            }
        } else {
            const auto t1 = prof ? Clock::now() : Clock::time_point{};
            for (const auto& [span_addr, span_size] : dirty_spans) {
                SynchronizeBufferSpan(buffer, span_addr, span_size, is_written);
            }
            if (prof) {
                g_obtprof.walked.fetch_add(1, std::memory_order_relaxed);
                if (is_written) {
                    g_obtprof.walked_written.fetch_add(1, std::memory_order_relaxed);
                }
                g_obtprof.walk_spans.fetch_add(dirty_spans.size(), std::memory_order_relaxed);
                g_obtprof.walked_ns.fetch_add(u64((Clock::now() - t1).count()),
                                              std::memory_order_relaxed);
            }
        }
        // The GPU write covers the WHOLE window whatever was uploaded - identical to the
        // second ForEachUploadRange pass of the ungated path (which also marks the full
        // query range), done with the cheap SetRange-only method.
        if (is_written) {
            const auto t2 = prof ? Clock::now() : Clock::time_point{};
            memory_tracker->MarkRegionAsGpuModified(device_addr, size);
            if (prof) {
                g_obtprof.markgpu_ns.fetch_add(u64((Clock::now() - t2).count()),
                                               std::memory_order_relaxed);
            }
        }
        if (is_texel_buffer && !is_written) {
            return SynchronizeBufferFromImage(buffer, device_addr, size);
        }
        return false;
    }
    SynchronizeBufferSpan(buffer, device_addr, size, is_written);
    if (is_texel_buffer && !is_written) {
        return SynchronizeBufferFromImage(buffer, device_addr, size);
    }
    return false;
}

void BufferCache::SynchronizeBufferSpan(Buffer& buffer, VAddr device_addr, u32 size,
                                        bool is_written) {
    const bool prof = DmaProfEnabled();
    using ProfClock = std::chrono::steady_clock;
    const auto prof_t0 = prof ? ProfClock::now() : ProfClock::time_point{};
    boost::container::small_vector<vk::BufferCopy, 4> copies;
    size_t total_size_bytes = 0;
    const VAddr buffer_start = buffer.CpuAddr();
    vk::Buffer src_buffer = VK_NULL_HANDLE;
    // Attribute the Protect syscalls issued by UpdateProtection under this walk to the
    // span-walk bucket of [protprof] (see GtProtProf in page_manager.h). thread_local, so
    // the fault handler's unprotects on other threads keep landing in "other".
    GtProtProf::in_span_walk = true;
    memory_tracker->ForEachUploadRange(
        device_addr, size, is_written,
        [&](u64 device_addr_out, u64 range_size) {
            // The tracker reports whole dirty WORDS, so a range can reach past the window we
            // asked for AND past this buffer. GT7 produced regions at 32/36/40/44 MiB into a
            // 32 MiB VkBuffer, marching in 4 MiB steps - GpuAV named it
            // VUID-vkCmdCopyBuffer-dstOffset-00114 (plus size-00116). A copy past the end is
            // undefined behaviour, and on this driver it lands as an unmapped WRITE inside the
            // driver own copy kernel: the vendor dump then reads "Write 0x2000x000, engine
            // reset, shader hash N/A, Compute, 512 B" - a device loss with no shader of ours
            // anywhere in it, which is how it stayed unexplained for three runs.
            const u64 buffer_limit = buffer_start + buffer.SizeBytes();
            const u64 begin = std::max<u64>(device_addr_out, buffer_start);
            const u64 end = std::min<u64>(device_addr_out + range_size, buffer_limit);
            if (begin >= end) {
                LogCopyClamp(buffer, device_addr_out, range_size, 0);
                return;
            }
            const u64 clamped_size = end - begin;
            if (begin != device_addr_out || clamped_size != range_size) {
                LogCopyClamp(buffer, device_addr_out, range_size, clamped_size);
            }
            GtLogBufEvent("bufsync", begin, clamped_size, std::bit_cast<const u8*>(begin));
            copies.emplace_back(total_size_bytes, begin - buffer_start, clamped_size);
            total_size_bytes += clamped_size;
        },
        [&] {
            const auto tm0 = prof ? ProfClock::now() : ProfClock::time_point{};
            src_buffer = UploadCopies(buffer, copies, total_size_bytes);
            if (prof) {
                g_obtprof.span_memcpy_ns.fetch_add(u64((ProfClock::now() - tm0).count()),
                                                   std::memory_order_relaxed);
            }
        });
    GtProtProf::in_span_walk = false;

    const auto prof_t1 = prof ? ProfClock::now() : ProfClock::time_point{};
    if (prof) {
        g_obtprof.span_cpu_ns.fetch_add(u64((prof_t1 - prof_t0).count()),
                                        std::memory_order_relaxed);
        g_obtprof.span_copies.fetch_add(copies.size(), std::memory_order_relaxed);
        g_obtprof.span_bytes.fetch_add(total_size_bytes, std::memory_order_relaxed);
        if (copies.empty()) {
            g_obtprof.span_empty.fetch_add(1, std::memory_order_relaxed);
        } else if (scheduler.IsRendering()) {
            g_obtprof.span_rp_breaks.fetch_add(1, std::memory_order_relaxed);
        }
    }
    if (src_buffer) {
        scheduler.EndRendering();
        const auto cmdbuf = scheduler.CommandBuffer();
        const vk::BufferMemoryBarrier2 pre_barrier = {
            .srcStageMask = vk::PipelineStageFlagBits2::eAllCommands,
            .srcAccessMask = vk::AccessFlagBits2::eMemoryRead | vk::AccessFlagBits2::eMemoryWrite |
                             vk::AccessFlagBits2::eTransferRead |
                             vk::AccessFlagBits2::eTransferWrite,
            .dstStageMask = vk::PipelineStageFlagBits2::eTransfer,
            .dstAccessMask = vk::AccessFlagBits2::eTransferWrite,
            .buffer = buffer.Handle(),
            .offset = 0,
            .size = buffer.SizeBytes(),
        };
        const vk::BufferMemoryBarrier2 post_barrier = {
            .srcStageMask = vk::PipelineStageFlagBits2::eTransfer,
            .srcAccessMask = vk::AccessFlagBits2::eTransferWrite,
            .dstStageMask = vk::PipelineStageFlagBits2::eAllCommands,
            .dstAccessMask = vk::AccessFlagBits2::eMemoryRead | vk::AccessFlagBits2::eMemoryWrite,
            .buffer = buffer.Handle(),
            .offset = 0,
            .size = buffer.SizeBytes(),
        };
        cmdbuf.pipelineBarrier2(vk::DependencyInfo{
            .dependencyFlags = vk::DependencyFlagBits::eByRegion,
            .bufferMemoryBarrierCount = 1,
            .pBufferMemoryBarriers = &pre_barrier,
        });
        cmdbuf.copyBuffer(src_buffer, buffer.buffer, copies);
        cmdbuf.pipelineBarrier2(vk::DependencyInfo{
            .dependencyFlags = vk::DependencyFlagBits::eByRegion,
            .bufferMemoryBarrierCount = 1,
            .pBufferMemoryBarriers = &post_barrier,
        });
        TouchBuffer(buffer);
    }
    if (prof) {
        g_obtprof.span_rec_ns.fetch_add(u64((ProfClock::now() - prof_t1).count()),
                                        std::memory_order_relaxed);
    }
}

vk::Buffer BufferCache::UploadCopies(Buffer& buffer, std::span<vk::BufferCopy> copies,
                                     size_t total_size_bytes) {
    if (copies.empty()) {
        return VK_NULL_HANDLE;
    }
    const auto [staging, offset] = staging_buffer.Map(total_size_bytes);
    if (staging) {
        for (auto& copy : copies) {
            u8* const src_pointer = staging + copy.srcOffset;
            const VAddr device_addr = buffer.CpuAddr() + copy.dstOffset;
            memory->CopySparseMemory(device_addr, src_pointer, copy.size);
            // Apply the staging offset
            copy.srcOffset += offset;
        }
        staging_buffer.Commit();
        return staging_buffer.Handle();
    } else {
        // For large one time transfers use a temporary host buffer.
        auto temp_buffer =
            std::make_unique<Buffer>(instance, scheduler, MemoryUsage::Upload, 0,
                                     vk::BufferUsageFlagBits::eTransferSrc, total_size_bytes);
        const vk::Buffer src_buffer = temp_buffer->Handle();
        u8* const staging = temp_buffer->mapped_data.data();
        for (const auto& copy : copies) {
            u8* const src_pointer = staging + copy.srcOffset;
            const VAddr device_addr = buffer.CpuAddr() + copy.dstOffset;
            memory->CopySparseMemory(device_addr, src_pointer, copy.size);
        }
        scheduler.DeferOperation([buffer = std::move(temp_buffer)]() mutable { buffer.reset(); });
        return src_buffer;
    }
}

bool BufferCache::SynchronizeBufferFromImage(Buffer& buffer, VAddr device_addr, u32 size) {
    // GT_TEXEL_MEMO: the memoized variant skips the per-page walk when the set of registered
    // images has not changed (see FindImageFromRangeMemo). Same verdict either way; the env
    // exists so run 207 can A/B the two.
    static const bool memo_enabled = [] {
        const char* v = std::getenv("GT_TEXEL_MEMO");
        return v && std::atoi(v) != 0;
    }();
    const bool prof = DmaProfEnabled();
    using Clock = std::chrono::steady_clock;
    const auto t0 = prof ? Clock::now() : Clock::time_point{};
    const ImageId image_id = memo_enabled ? texture_cache.FindImageFromRangeMemo(device_addr, size)
                                          : texture_cache.FindImageFromRange(device_addr, size);
    if (prof) {
        g_obtprof.texel_calls.fetch_add(1, std::memory_order_relaxed);
        g_obtprof.fromimg_ns.fetch_add(u64((Clock::now() - t0).count()),
                                       std::memory_order_relaxed);
    }
    if (!image_id) {
        return false;
    }
    Image& image = texture_cache.GetImage(image_id);
    ASSERT_MSG(device_addr == image.info.guest_address,
               "Texel buffer aliases image subresources {:x} : {:x}", device_addr,
               image.info.guest_address);
    const u32 buf_offset = buffer.Offset(image.info.guest_address);
    boost::container::small_vector<vk::BufferImageCopy, 8> buffer_copies;
    u32 copy_size = 0;
    for (u32 mip = 0; mip < image.info.resources.levels; mip++) {
        const auto& mip_info = image.info.mips_layout[mip];
        const u32 width = std::max(image.info.size.width >> mip, 1u);
        const u32 height = std::max(image.info.size.height >> mip, 1u);
        const u32 depth = std::max(image.info.size.depth >> mip, 1u);
        if (buf_offset + mip_info.offset + mip_info.size > buffer.SizeBytes()) {
            break;
        }
        buffer_copies.push_back(vk::BufferImageCopy{
            .bufferOffset = mip_info.offset,
            .bufferRowLength = mip_info.pitch,
            .bufferImageHeight = mip_info.height,
            .imageSubresource{
                .aspectMask = image.aspect_mask & ~vk::ImageAspectFlagBits::eStencil,
                .mipLevel = mip,
                .baseArrayLayer = 0,
                .layerCount = image.info.resources.layers,
            },
            .imageOffset = {0, 0, 0},
            .imageExtent = {width, height, depth},
        });
        copy_size += mip_info.size;
    }
    if (copy_size == 0) {
        return false;
    }
    auto& tile_manager = texture_cache.GetTileManager();
    tile_manager.TileImage(image, buffer_copies, buffer.Handle(), buf_offset, copy_size);
    return true;
}

void BufferCache::SynchronizeBuffersInRange(VAddr device_addr, u64 size) {
    const VAddr device_addr_end = device_addr + size;
    ForEachBufferInRange(device_addr, size, [&](BufferId buffer_id, Buffer& buffer) {
        RENDERER_TRACE;
        VAddr start = std::max(buffer.CpuAddr(), device_addr);
        VAddr end = std::min(buffer.CpuAddr() + buffer.SizeBytes(), device_addr_end);
        u32 size = static_cast<u32>(end - start);
        SynchronizeBuffer(buffer, start, size, false, false);
    });
}

void BufferCache::LogDmaDirty(VAddr device_addr, u64 size) {
    if (!DmaDirtyLogEnabled() || size == 0) {
        return;
    }
    // Run 202 [dmaprof]: ~25,000 ranges per 2 s window totalling ~1 MiB - the guest writes
    // tens of thousands of TINY scattered chunks per second (mean 58 bytes), and each logged
    // range costs one SynchronizeBuffersInRange lookup (~25 us) at consumption: 440-790 ms per
    // window, i.e. the whole 'dma' bill of [fprof] (the lock measured innocent at 0.1 ms).
    // Aligning every entry to 64 KiB pages lets RangeSet coalesce neighbours into a handful of
    // spans. Over-wide spans are SAFE: they are range QUERIES, and ForEachUploadRange only
    // uploads what the tracker holds as CPU-dirty inside them - the pre-fix full walk queried
    // the entire mapped space through the same filter.
    constexpr VAddr kPageMask = 0xFFFF;
    const VAddr aligned = device_addr & ~kPageMask;
    const u64 aligned_size = ((device_addr + size + kPageMask) & ~kPageMask) - aligned;
    if (DmaProfEnabled()) {
        const auto t0 = std::chrono::steady_clock::now();
        u64 lock_ns = 0;
        {
            std::scoped_lock lk{dma_dirty_mutex};
            lock_ns = u64((std::chrono::steady_clock::now() - t0).count());
            dma_dirty_log.Add(aligned, aligned_size);
            if (BindSkipEnabled()) {
                bind_dirty_ranges.Add(aligned, aligned_size);
            }
        }
        g_dmaprof.log_calls.fetch_add(1, std::memory_order_relaxed);
        g_dmaprof.log_lock_ns.fetch_add(lock_ns, std::memory_order_relaxed);
        return;
    }
    std::scoped_lock lk{dma_dirty_mutex};
    dma_dirty_log.Add(aligned, aligned_size);
    if (BindSkipEnabled()) {
        bind_dirty_ranges.Add(aligned, aligned_size);
    }
}

bool BufferCache::ConsumeDmaDirtyLog() {
    if (!DmaDirtyLogEnabled()) {
        return false;
    }
    const auto t0 = std::chrono::steady_clock::now();
    RangeSet local;
    {
        std::scoped_lock lk{dma_dirty_mutex};
        if (!dma_dirty_seeded) {
            // The caller's full walk right after this return IS the seed. Entries logged
            // before it are covered by that walk; entries logged DURING it survive here and
            // are re-synchronized on the next consumption, which is a harmless no-op.
            dma_dirty_seeded = true;
            dma_dirty_log.Clear();
            LOG_WARNING(Render_Vulkan,
                        "[dmasync] incremental DMA dirty log armed - this draw seeds with the "
                        "one full mapped-range walk, every later DMA draw consumes only what "
                        "became CPU-dirty since the previous one");
            return false;
        }
        std::swap(local.m_ranges_set, dma_dirty_log.m_ranges_set);
    }
    const auto t_lock = std::chrono::steady_clock::now();
    u32 ranges = 0;
    u64 bytes = 0;
    local.ForEach([&](VAddr start, VAddr end) {
        ++ranges;
        bytes += end - start;
        SynchronizeBuffersInRange(start, end - start);
    });
    const auto t_sync = std::chrono::steady_clock::now();
    if (DmaProfEnabled()) {
        g_dmaprof.consume_calls.fetch_add(1, std::memory_order_relaxed);
        g_dmaprof.consume_lock_ns.fetch_add(u64((t_lock - t0).count()),
                                            std::memory_order_relaxed);
        g_dmaprof.sync_ns.fetch_add(u64((t_sync - t_lock).count()), std::memory_order_relaxed);
        g_dmaprof.ranges.fetch_add(ranges, std::memory_order_relaxed);
        g_dmaprof.bytes.fetch_add(bytes, std::memory_order_relaxed);
        // Flushed here because this is the one thread that consumes; producers only add.
        static auto window_start = t_sync;
        if (t_sync - window_start >= std::chrono::seconds(2)) {
            window_start = t_sync;
            LOG_INFO(Render_Vulkan,
                     "[dmaprof] consume: {} calls, lock {:.1f}ms sync {:.1f}ms, {} ranges {} "
                     "KiB | producers: {} calls, lock {:.1f}ms",
                     g_dmaprof.consume_calls.exchange(0),
                     g_dmaprof.consume_lock_ns.exchange(0) / 1e6,
                     g_dmaprof.sync_ns.exchange(0) / 1e6, g_dmaprof.ranges.exchange(0),
                     g_dmaprof.bytes.exchange(0) >> 10, g_dmaprof.log_calls.exchange(0),
                     g_dmaprof.log_lock_ns.exchange(0) / 1e6);
        }
    }
    static std::atomic<u32> dmasync_logs{0};
    const u32 n = dmasync_logs.fetch_add(1, std::memory_order_relaxed);
    if ((ranges != 0 && n < 16) || (n & 4095u) == 0) {
        LOG_INFO(Render_Vulkan, "[dmasync] consumed {} dirty range(s), {} KiB (call {})", ranges,
                 bytes >> 10, n);
    }
    return true;
}

void BufferCache::WriteDataBuffer(Buffer& buffer, VAddr address, const void* value, u32 num_bytes) {
    vk::BufferCopy copy = {
        .srcOffset = 0,
        .dstOffset = buffer.Offset(address),
        .size = num_bytes,
    };
    vk::Buffer src_buffer = staging_buffer.Handle();
    if (num_bytes < StagingBufferSize) {
        const auto [staging, offset] = staging_buffer.Map(num_bytes);
        std::memcpy(staging, value, num_bytes);
        copy.srcOffset = offset;
        staging_buffer.Commit();
    } else {
        // For large one time transfers use a temporary host buffer.
        // RenderDoc can lag quite a bit if the stream buffer is too large.
        Buffer temp_buffer{
            instance, scheduler, MemoryUsage::Upload, 0, vk::BufferUsageFlagBits::eTransferSrc,
            num_bytes};
        src_buffer = temp_buffer.Handle();
        u8* const staging = temp_buffer.mapped_data.data();
        std::memcpy(staging, value, num_bytes);
        scheduler.DeferOperation([buffer = std::move(temp_buffer)]() mutable {});
    }
    scheduler.EndRendering();
    const auto cmdbuf = scheduler.CommandBuffer();
    const vk::BufferMemoryBarrier2 pre_barrier = {
        .srcStageMask = vk::PipelineStageFlagBits2::eAllCommands,
        .srcAccessMask = vk::AccessFlagBits2::eMemoryRead,
        .dstStageMask = vk::PipelineStageFlagBits2::eTransfer,
        .dstAccessMask = vk::AccessFlagBits2::eTransferWrite,
        .buffer = buffer.Handle(),
        .offset = buffer.Offset(address),
        .size = num_bytes,
    };
    const vk::BufferMemoryBarrier2 post_barrier = {
        .srcStageMask = vk::PipelineStageFlagBits2::eTransfer,
        .srcAccessMask = vk::AccessFlagBits2::eTransferWrite,
        .dstStageMask = vk::PipelineStageFlagBits2::eAllCommands,
        .dstAccessMask = vk::AccessFlagBits2::eMemoryRead | vk::AccessFlagBits2::eMemoryWrite,
        .buffer = buffer.Handle(),
        .offset = buffer.Offset(address),
        .size = num_bytes,
    };
    cmdbuf.pipelineBarrier2(vk::DependencyInfo{
        .dependencyFlags = vk::DependencyFlagBits::eByRegion,
        .bufferMemoryBarrierCount = 1,
        .pBufferMemoryBarriers = &pre_barrier,
    });
    cmdbuf.copyBuffer(src_buffer, buffer.Handle(), copy);
    cmdbuf.pipelineBarrier2(vk::DependencyInfo{
        .dependencyFlags = vk::DependencyFlagBits::eByRegion,
        .bufferMemoryBarrierCount = 1,
        .pBufferMemoryBarriers = &post_barrier,
    });
}

void BufferCache::RunGarbageCollector() {
    SCOPE_EXIT {
        ++gc_tick;
    };
    if (instance.CanReportMemoryUsage()) {
        total_used_memory = instance.GetDeviceMemoryUsage();
    }
    // The number the "every next step drops fps massively" report needs: a periodic VRAM
    // line (roughly every 10 s of guest frames), so the next slowdown correlates with a
    // MEASUREMENT instead of an impression. Past the card's physical VRAM the driver pages
    // to system RAM and that is what a progressive massive drop looks like.
    if ((gc_tick % 600) == 0) {
        u64 vma_bytes = 0;
        u32 vma_allocs = 0;
        instance.GetVmaStatistics(vma_bytes, vma_allocs);
        LOG_INFO(Render_Vulkan,
                 "[vram] device {} MB, VMA-owned {} MB in {} allocs (buffers {} / {} MB, "
                 "images {} / {} MB), pending deaths {} / {} MB, temp_downloads {} (GC "
                 "trigger {} MB)",
                 total_used_memory >> 20, vma_bytes >> 20, vma_allocs, live_buffer_count,
                 live_buffer_bytes >> 20, texture_cache.LiveImageCount(),
                 texture_cache.LiveImageBytes() >> 20, pending_deaths.size(),
                 pending_death_bytes >> 20, g_temp_download_count.load(std::memory_order_relaxed),
                 trigger_gc_memory >> 20);
    }
    if (total_used_memory < trigger_gc_memory) {
        return;
    }
    // Upstream defines clean_up and never calls it - the buffer GC has never deleted a single
    // buffer, so a streaming-heavy title fills VRAM with stale buffers until vmaCreateBuffer
    // (WITHIN_BUDGET_BIT) refuses: that is the ErrorOutOfDeviceMemory at ~650 compiles in GT7.
    // Wired up behind GT_BUFFER_GC=1 because upstream may have parked it on purpose (note the
    // commented-out InvalidateMemory in clean_up).
    // ON BY DEFAULT since the all-timelines death gate exists (ProcessPendingDeaths):
    // the cross-scheduler use-after-free that forced it off (runs 60-63) is closed, and
    // the user's "every next step drops fps massively" is exactly what a never-freeing
    // VRAM footprint does past the card's 12 GB. GT_BUFFER_GC=0 opts back out.
    static const bool gc_enabled = [] {
        const char* v = std::getenv("GT_BUFFER_GC");
        return !(v && v[0] == '0');
    }();
    if (!gc_enabled) {
        return;
    }
    const bool aggressive = total_used_memory >= critical_gc_memory;
    // Runs 60/61 died as DEVICE LOST with usage at 9-11 GB of a 12 GB card: 64 deletions of
    // 80-tick-old buffers per guest frame cannot outrun GT7's streaming, and the driver dies of
    // memory pressure before our own allocation would fail. When over CRITICAL, delete YOUNG
    // buffers too (they re-upload on demand - that costs a hitch, a dead device costs the run).
    const u64 ticks_to_destroy = std::min<u64>(aggressive ? 8 : 160, gc_tick);
    // Run 62: 256 deletions freed 119 MB while usage sat at 9.7 GB - the cap was the bottleneck,
    // and the device died of pressure anyway. Aggressive mode is now bounded by the LRU itself.
    int max_deletions = aggressive ? 4096 : 32;
    const int allowed_deletions = max_deletions;
    u64 freed_bytes = 0;
    const auto clean_up = [&](BufferId buffer_id) {
        if (max_deletions == 0) {
            return;
        }
        --max_deletions;
        Buffer& buffer = slot_buffers[buffer_id];
        freed_bytes += buffer.SizeBytes();
        // InvalidateMemory(buffer.CpuAddr(), buffer.SizeBytes());
        DownloadBufferMemory<true>(buffer, buffer.CpuAddr(), buffer.SizeBytes());
        memory_tracker->MarkRegionAsCpuModified(buffer.CpuAddr(), buffer.SizeBytes());
        LogDmaDirty(buffer.CpuAddr(), buffer.SizeBytes());
        DeleteBuffer(buffer_id);
    };
    lru_cache.ForEachItemBelow(gc_tick - ticks_to_destroy, clean_up);
    const int deleted = allowed_deletions - max_deletions;
    if (deleted > 0) {
        LOG_WARNING(Render_Vulkan,
                    "[buffergc] freed {} stale buffer(s) / {} MB ({}): used {} MB, trigger {} MB",
                    deleted, freed_bytes >> 20, aggressive ? "aggressive" : "normal",
                    total_used_memory >> 20, trigger_gc_memory >> 20);
    }
    if (aggressive) {
        // The census the pressure deaths need: how much of the device figure is OURS (VMA) -
        // the rest is the driver's. Says whether more cache GC can even help.
        u64 vma_bytes = 0;
        u32 vma_allocs = 0;
        instance.GetVmaStatistics(vma_bytes, vma_allocs);
        // Run 118: this census read "device 22282 MB in 10715 allocs" and could not say WHOSE
        // they were - the buffer GC freed ~0 while something allocated thousands of ~1.3 MB
        // blocks. The two live sub-censuses split it: buffers (ours, this cache) vs images
        // (texture cache) vs the remainder (driver-internal + pipelines).
        LOG_WARNING(Render_Vulkan,
                    "[buffergc] census: device {} MB, VMA-owned {} MB in {} allocs; buffers {} / "
                    "{} MB, images {} / {} MB, pending deaths {} / {} MB",
                    total_used_memory >> 20, vma_bytes >> 20, vma_allocs, live_buffer_count,
                    live_buffer_bytes >> 20, texture_cache.LiveImageCount(),
                    texture_cache.LiveImageBytes() >> 20, pending_deaths.size(),
                    pending_death_bytes >> 20);
    }
}

void BufferCache::TouchBuffer(const Buffer& buffer) {
    lru_cache.Touch(buffer.LRUId(), gc_tick);
}

void BufferCache::DeleteBuffer(BufferId buffer_id) {
    Buffer& buffer = slot_buffers[buffer_id];
    Unregister(buffer_id);
    // Snapshot what the tick gate is being asked to protect, so the graveyard printed on a lost
    // device can say whether the gate was satisfied AND on whose timeline it was measured - there
    // are three Schedulers and each has its own MasterSemaphore, so a tick from one says nothing
    // about the progress of another.
    Vulkan::GpuBufferDeath death{};
    death.handle = std::bit_cast<u64>(static_cast<VkBuffer>(buffer.Handle()));
    death.guest_addr = buffer.CpuAddr();
    death.size = static_cast<u32>(buffer.SizeBytes());
    death.timeline = reinterpret_cast<u64>(scheduler.GetMasterSemaphore());
    death.defer_tick = scheduler.CurrentTick();
    // THE GATE, at last on ALL THREE timelines (the Act 2 3c prerequisite): the erase is
    // queued into pending_deaths with a snapshot of every timeline, and ProcessPendingDeaths
    // (per submit, same thread) only erases once EVERY timeline has passed its snapshot.
    // Our own (draw) scheduler is gated at its RECORDING tick - its open cmdbuf accumulates
    // buffer references between submits; present/flip are gated at their SUBMITTED tick
    // (see SnapshotTimelines' header for the run-120 flip starvation and the proof).
    pending_deaths.push_back(
        {buffer_id, instance.SnapshotTimelines(scheduler.GetMasterSemaphore()), death});
    pending_death_bytes += buffer.SizeBytes();
    buffer.is_deleted = true;
}

void BufferCache::ProcessPendingDeaths() {
    if (pending_deaths.empty()) {
        return;
    }
    // ⚠⚠ THE RUN-119 OOM LIVED HERE: IsFree() compares against a CACHED gpu_tick that only
    // that Scheduler's own activity refreshes. This runs on the draw thread, so the
    // present/flip entries of every gate were read from values that could be seconds stale -
    // 4495 corpses (16 of the 22 GB VMA held at the death) were waiting for progress the GPU
    // had long made. One counter query per timeline per drain pass (Refresh is a forward-only
    // CAS and vkGetSemaphoreCounterValue needs no external sync - safe cross-thread); never
    // per corpse, or a 4000-deep graveyard costs 12000 queries per submit.
    instance.RefreshTimelines();
    // Once any timeline is lost, ticks are not lifetime guarantees and AllTimelinesPast
    // deliberately refuses forever - erase unconditionally, the device is gone anyway and
    // RecordBufferDeath marks these deaths as untrustworthy on its own.
    const bool lost = instance.AnyTimelineLost();
    std::erase_if(pending_deaths, [&](PendingBufferDeath& d) {
        if (!lost && !instance.AllTimelinesPast(d.gate)) {
            return false;
        }
        // Recorded HERE, when the erase actually happens: the interesting number is
        // KnownGpuTick at this moment, not at the moment the deletion was queued.
        d.death.known_gpu = scheduler.GetMasterSemaphore()->KnownGpuTick();
        instance.RecordBufferDeath(d.death);
        pending_death_bytes -= d.death.size;
        slot_buffers.erase(d.buffer_id);
        return true;
    });
    // If the refresh is not enough - a scheduler that genuinely never SUBMITS cannot be
    // helped by reading its counter, because the gate stores its RECORDING tick - the next
    // failure must name the culprit instead of presenting another anonymous 22 GB. Budgeted
    // to roughly one line per ~10 s of passes.
    if (pending_death_bytes > 1_GB && !pending_deaths.empty()) {
        static u32 grave_logs = 0;
        if ((grave_logs++ & 1023) == 0) {
            u64 gate = 0, known = 0, current = 0;
            const u32 idx = instance.FirstUnmetTimeline(pending_deaths.front().gate, gate, known,
                                                        current);
            LOG_CRITICAL(Render_Vulkan,
                         "[graveyard] {} corpses / {} MB waiting; oldest is held by timeline {} "
                         "(0=draw 1=present 2=flip): gate {} known {} current {}",
                         pending_deaths.size(), pending_death_bytes >> 20, idx, gate, known,
                         current);
        }
    }
}

} // namespace VideoCore
