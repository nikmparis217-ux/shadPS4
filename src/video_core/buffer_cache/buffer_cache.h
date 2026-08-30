// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#include <functional>
#include <mutex>
#include <boost/container/small_vector.hpp>
#include "common/lru_cache.h"
#include "common/slot_vector.h"
#include "common/types.h"
#include "video_core/buffer_cache/buffer.h"
#include "video_core/buffer_cache/fault_manager.h"
#include "video_core/buffer_cache/range_set.h"
#include "video_core/multi_level_page_table.h"
#include "video_core/renderer_vulkan/vk_instance.h"

namespace AmdGpu {
struct Liverpool;
}

namespace Core {
class MemoryManager;
}

namespace Vulkan {
class GraphicsPipeline;
}

namespace VideoCore {

using BufferId = Common::SlotId;

class TextureCache;
class MemoryTracker;
class PageManager;

class BufferCache {
public:
    static constexpr u32 CACHING_PAGEBITS = 14;
    static constexpr u64 CACHING_PAGESIZE = u64{1} << CACHING_PAGEBITS;
    static constexpr u64 DEVICE_PAGESIZE = 16_KB;
    static constexpr u64 CACHING_NUMPAGES = u64{1} << (40 - CACHING_PAGEBITS);
    static constexpr u64 BDA_PAGETABLE_SIZE = CACHING_NUMPAGES * sizeof(vk::DeviceAddress);

    // Default values for garbage collection
    static constexpr s64 DEFAULT_TRIGGER_GC_MEMORY = 1_GB;
    static constexpr s64 DEFAULT_CRITICAL_GC_MEMORY = 2_GB;
    static constexpr s64 TARGET_GC_THRESHOLD = 8_GB;

    struct PageData {
        BufferId buffer_id{};
    };

    struct Traits {
        using Entry = PageData;
        static constexpr size_t AddressSpaceBits = 40;
        static constexpr size_t FirstLevelBits = 16;
        static constexpr size_t PageBits = CACHING_PAGEBITS;
    };
    using PageTable = MultiLevelPageTable<Traits>;

    struct OverlapResult {
        boost::container::small_vector<BufferId, 16> ids;
        VAddr begin;
        VAddr end;
        bool has_stream_leap = false;
    };

public:
    explicit BufferCache(const Vulkan::Instance& instance, Vulkan::Scheduler& scheduler,
                         AmdGpu::Liverpool* liverpool, TextureCache& texture_cache,
                         PageManager& tracker);
    ~BufferCache();

    /// Returns a pointer to GDS device local buffer.
    [[nodiscard]] const Buffer* GetGdsBuffer() const noexcept {
        return &gds_buffer;
    }

    /// Retrieves the device local DBA page table buffer.
    [[nodiscard]] Buffer* GetBdaPageTableBuffer() noexcept {
        return &bda_pagetable_buffer;
    }

    /// Retrieves the fault buffer.
    [[nodiscard]] Buffer* GetFaultBuffer() noexcept {
        return fault_manager.GetFaultBuffer();
    }

    /// Retrieves the buffer with the specified id.
    [[nodiscard]] Buffer& GetBuffer(BufferId id) {
        return slot_buffers[id];
    }

    /// Retrieves a utility buffer optimized for specified memory usage.
    StreamBuffer& GetUtilityBuffer(MemoryUsage usage) noexcept {
        if (usage == MemoryUsage::Stream) {
            return stream_buffer;
        } else if (usage == MemoryUsage::Download) {
            return download_buffer;
        } else if (usage == MemoryUsage::DeviceLocal) {
            return device_buffer;
        } else {
            return staging_buffer;
        }
    }

    /// Invalidates any buffer in the logical page range.
    void InvalidateMemory(VAddr device_addr, u64 size);

    /// GT_BDA_IMPORT: publish physically-backed guest mappings as the fallback BDA for pages
    /// that do not currently have a cached Vulkan buffer.
    void MapGuestMemory(VAddr device_addr, u64 size);

    /// GT_BDA_IMPORT: remove fallback BDA entries for a guest range being unmapped. Cached
    /// buffers keep precedence and are left untouched.
    void UnmapGuestMemory(VAddr device_addr, u64 size);

    /// GT_FAULT_WIDE (run 211): mark the non-GPU-modified pages of a widened window around a
    /// guest write fault CPU-dirty, so the game's linear sweep over its per-frame buffers pays
    /// ONE fault + ONE VirtualProtect per window instead of one per 4K page. Pages overlapping
    /// a GtNoteWideSuspect range are clipped OUT of the widen (run 212 proved they are
    /// GPU-written through BDA stores the tracker cannot see, and widening over them uploads
    /// stale guest bytes over live GPU data). Feeds the GT_BIND_SKIP mirror like every other
    /// producer. See Rasterizer::InvalidateMemory.
    void WidenCpuDirty(VAddr device_addr, u64 size);

    /// GT_FAULT_WIDE stage 2 (runs 211-213): remember a guest range the GPU writes through
    /// paths the tracker cannot see (BDA stores - e.g. the record buffers of cs_018256c0, the
    /// windowed T# tables), so WidenCpuDirty never widens over it. Run 211 died on exactly that
    /// stale-upload class with no evidence of WHICH range was hit; run 212's [widetbl] named
    /// the record buffers in the act; run 213 clips around them. ~a few calls/frame.
    void GtNoteWideSuspect(VAddr addr, u64 size, const char* tag);

    /// GT_FAULT_WIDE stage 2, the run-213 lesson: the clip alone cannot save the CURRENT
    /// dispatch - a widen that landed on the records BEFORE their address was ever noted has
    /// already marked the pages, and the dispatch's own ObtainBuffer records the poisoned
    /// upload before the note site (the flatbuf branch) even runs. This both notes the range
    /// AND clears any speculative CPU-dirty marks on its pages ([healtbl]), so the upload never
    /// happens. Call it BEFORE the bind loop that obtains the range. Only valid while fault
    /// widening is on: without widening, dirt on those pages comes from REAL guest writes and
    /// must be uploaded.
    void GtHealSuspect(VAddr addr, u64 size, const char* tag);

    /// Flushes any GPU modified buffer in the logical page range back to CPU memory.
    void ReadMemory(VAddr device_addr, u64 size, bool is_write = false);

    /// GT_IMGARRAY_SYNC (Act 11): synchronously copy [addr, addr+size) out of the CACHED
    /// buffer into `out`, IGNORING tracker state - the windowed T# tables are GPU-written
    /// through paths that never mark gpu_modified_ranges (BDA stores), so the gated
    /// ReadMemory path would skip exactly the bytes this exists for. Costs a full pipeline
    /// drain (scheduler.Finish). The caller merges the bytes into guest RAM per slot.
    /// Returns false when no registered buffer fully covers the range - that outcome is
    /// itself the Stage 0 "reg 0" verdict: a store to an unregistered page was dropped.
    bool DownloadTableRegion(VAddr addr, u64 size, std::vector<u8>& out);

    /// The async sibling of DownloadTableRegion: records the copy WITHOUT waiting and
    /// hands the payload to on_ready once the recorded tick completes (DeferOperation).
    /// The callback must never re-enter DeferOperation (it runs under pending_ops_mutex).
    bool CaptureTableRegion(VAddr addr, u64 size, std::function<void(std::vector<u8>&&)>&& on_ready);

    /// Binds host vertex buffers for the current draw.
    void BindVertexBuffers(const Vulkan::GraphicsPipeline& pipeline,
                           boost::container::small_vector<vk::BufferMemoryBarrier2, 16>& barriers);

    /// Bind host index buffer for the current draw.
    void BindIndexBuffer(u32 index_offset,
                         boost::container::small_vector<vk::BufferMemoryBarrier2, 16>& barriers);

    /// Writes a value to GPU buffer. (uses command buffer to temporarily store the data)
    void FillBuffer(VAddr address, u32 num_bytes, u32 value, bool is_gds);

    /// Performs buffer to buffer data copy on the GPU.
    void CopyBuffer(VAddr dst, VAddr src, u32 num_bytes, bool dst_gds, bool src_gds);

    /// Obtains a buffer for the specified region.
    [[nodiscard]] std::pair<Buffer*, u32> ObtainBuffer(VAddr gpu_addr, u32 size, bool is_written,
                                                       bool is_texel_buffer = false,
                                                       BufferId buffer_id = {});

    /// Attempts to obtain a buffer without modifying the cache contents.
    [[nodiscard]] std::pair<Buffer*, u32> ObtainBufferForImage(VAddr gpu_addr, u32 size);

    /// Return true when a region is registered on the cache
    [[nodiscard]] bool IsRegionRegistered(VAddr addr, size_t size);

    /// Return true when a CPU region is modified from the CPU
    [[nodiscard]] bool IsRegionCpuModified(VAddr addr, size_t size);

    /// Return true when a CPU region is modified from the GPU
    [[nodiscard]] bool IsRegionGpuModified(VAddr addr, size_t size);

    /// Return buffer id for the specified region
    BufferId FindBuffer(VAddr device_addr, u32 size);

    /// Processes the fault buffer.
    void ProcessFaultBuffer();

    /// GT7 (19 Aug): true when the address range is real, mapped guest memory. The fault
    /// buffer can carry junk pages when a bindless-lowered shader chases a garbage V#
    /// (its producer may itself still be stubbed) - creating buffers for those crashed
    /// the CPU in ResolveOverlaps (run 78).
    bool IsFaultAddressValid(VAddr addr, u64 size);

    /// Synchronizes all buffers in the specified range.
    void SynchronizeBuffersInRange(VAddr device_addr, u64 size);

    /// Synchronizes all buffers neede for DMA.
    void SynchronizeDmaBuffers();

    /// GT_DMA_DIRTY_LOG (run 198): the per-draw DMA coherence pass used to walk EVERY mapped
    /// range and visit EVERY cached buffer, per draw that uses DMA. That is O(buffers) of pure
    /// no-op tracker scanning once the scene is resident (~3,000 buffers on GT7's Music Rally)
    /// and it grows as the scene loads - measured as the 12->3 FPS decay with the CPU at 11-12
    /// cores while the GPU idles at 21%. Every transition INTO the CPU-dirty state already goes
    /// through this class (InvalidateMemory, ReadMemory's write-back, the GC's guest spill,
    /// CreateBuffer whose fresh tracker regions are born all-dirty), so those sites append to
    /// this log and the DMA pass consumes ONLY what changed since the last one. Returns true
    /// when the incremental path ran; false when disabled or on the first call (the caller's
    /// full walk right after IS the seed). Same uploads, orders of magnitude fewer scans.
    bool ConsumeDmaDirtyLog();

    /// Runs the garbage collector.
    void RunGarbageCollector();

private:
    template <typename Func>
    void ForEachBufferInRange(VAddr device_addr, u64 size, Func&& func) {
        buffer_ranges.ForEachInRange(device_addr, size,
                                     [&](u64 page_start, u64 page_end, BufferId id) {
                                         Buffer& buffer = slot_buffers[id];
                                         func(id, buffer);
                                     });
    }

    inline bool IsBufferInvalid(BufferId buffer_id) const {
        return !buffer_id || slot_buffers[buffer_id].is_deleted;
    }

    template <bool async>
    void DownloadBufferMemory(Buffer& buffer, VAddr device_addr, u64 size);

    /// Shared head of Download/CaptureTableRegion: resolves the covering buffer through the
    /// raw page table and records barrier + copy into the download stream buffer. Returns
    /// the mapped readback pointer, or nullptr when the range is not covered.
    u8* RecordTableRegionCopy(VAddr addr, u64 size);

    [[nodiscard]] OverlapResult ResolveOverlaps(VAddr device_addr, u32 wanted_size);

    void JoinOverlap(BufferId new_buffer_id, BufferId overlap_id, bool accumulate_stream_score);

    BufferId CreateBuffer(VAddr device_addr, u32 wanted_size);

    void Register(BufferId buffer_id);

    void Unregister(BufferId buffer_id);

    template <bool insert>
    void ChangeRegister(BufferId buffer_id);

    bool SynchronizeBuffer(Buffer& buffer, VAddr device_addr, u32 size, bool is_written,
                           bool is_texel_buffer);

    /// The upload core of SynchronizeBuffer (tracker walk + staging + barriers), over one
    /// span. GT_BIND_SKIP calls it once per mirror-reported dirty span so a 256 MiB written
    /// window no longer walks 64 regions to upload 64 KiB; the ungated path calls it once
    /// with the whole window, which is byte-identical to the old body.
    void SynchronizeBufferSpan(Buffer& buffer, VAddr device_addr, u32 size, bool is_written);

    vk::Buffer UploadCopies(Buffer& buffer, std::span<vk::BufferCopy> copies,
                            size_t total_size_bytes);

    bool SynchronizeBufferFromImage(Buffer& buffer, VAddr device_addr, u32 size);

    void WriteDataBuffer(Buffer& buffer, VAddr address, const void* value, u32 num_bytes);

    struct ImportedBackingChunk {
        vk::Buffer buffer{};
        vk::DeviceMemory allocation{};
        vk::DeviceAddress device_addr{};
        PAddr physical_addr{};
        u64 size{};
    };

    bool InitializeBdaBacking();
    void DestroyBdaBacking();
    [[nodiscard]] vk::DeviceAddress ImportedBdaAddress(PAddr physical_addr) const;
    [[nodiscard]] u64 WriteBdaFallbackSegment(VAddr virtual_addr, PAddr physical_addr, u64 size);

    void TouchBuffer(const Buffer& buffer);

    void DeleteBuffer(BufferId buffer_id);

public:
    /// Erase every queued buffer death whose gate has been satisfied by ALL timelines.
    /// Called once per submit from Rasterizer::OnSubmit - the same thread every
    /// DeleteBuffer caller runs on, so no locking. NOT a DeferOperation: those callbacks
    /// run under pending_ops_mutex and re-queueing from inside one deadlocks.
    void ProcessPendingDeaths();

private:
    /// One deferred buffer destruction, gated on EVERY timeline (draw, present, flip).
    /// The old DeferOperation-based erase waited on the DRAW tick alone while present and
    /// flip command buffers could still reference the buffer - the documented reason the
    /// buffer GC had to stay off (Act 2 3c) and the "2616 use-after-free references" of the
    /// validation runs. The gate snapshots CurrentTick of all timelines at DeleteBuffer
    /// time; while the game presents, present/flip tick every frame, so a gate passes
    /// within a frame or two. Deaths only accumulate while presentation idles.
    struct PendingBufferDeath {
        BufferId buffer_id;
        Vulkan::GpuTimelineSet gate;
        Vulkan::GpuBufferDeath death;
    };
    std::vector<PendingBufferDeath> pending_deaths;
    // What the graveyard is HOLDING in bytes, not just how many corpses - run 119's OOM was
    // 16 GB of it and the count alone (4495) could not say so.
    u64 pending_death_bytes = 0;

    const Vulkan::Instance& instance;
    Vulkan::Scheduler& scheduler;
    AmdGpu::Liverpool* liverpool;
    Core::MemoryManager* memory;
    TextureCache& texture_cache;
    FaultManager fault_manager;
    std::unique_ptr<MemoryTracker> memory_tracker;
    StreamBuffer staging_buffer;
    StreamBuffer stream_buffer;
    StreamBuffer download_buffer;
    StreamBuffer device_buffer;
    Buffer gds_buffer;
    Buffer bda_pagetable_buffer;
    std::vector<ImportedBackingChunk> imported_backing_chunks;
    bool bda_import_enabled = false;
    Common::SlotVector<Buffer> slot_buffers;
    u64 total_used_memory = 0;
    // Live census, maintained in ChangeRegister (see the twin counters in TextureCache):
    // total_used_memory is overwritten with GetDeviceMemoryUsage() every GC pass, so the
    // register-time sum is unreadable. Needed to attribute an OOM to buffers vs images.
    u64 live_buffer_bytes = 0;
    u32 live_buffer_count = 0;
    u64 trigger_gc_memory = 0;
    u64 critical_gc_memory = 0;
    u64 gc_tick = 0;
    Common::LeastRecentlyUsedCache<BufferId, u64> lru_cache;
    RangeSet gpu_modified_ranges;
    SplitRangeMap<BufferId> buffer_ranges;
    PageTable page_table;

    /// Appends a range that just became (or may have become) CPU-dirty to the DMA dirty log.
    /// MUST be called AFTER the tracker state change it describes: the consumer swaps the log
    /// and then synchronizes, so an entry must never be visible before its dirt is.
    void LogDmaDirty(VAddr device_addr, u64 size);

    /// GT_DMA_DIRTY_LOG state. Producers run on guest threads (page-fault handler) and the GPU
    /// thread; the consumer runs on the GPU thread. The mutex guards only the RangeSet.
    std::mutex dma_dirty_mutex;
    RangeSet dma_dirty_log;
    bool dma_dirty_seeded = false;

    /// GT_BIND_SKIP state, guarded by the SAME mutex. Unlike dma_dirty_log (swapped whole per
    /// DMA draw), this mirror is persistent and subtractive: producers add 64 KiB-aligned
    /// CPU-dirty transitions, SynchronizeBuffer subtracts the window it is about to walk.
    /// Invariant: always a SUPERSET of the tracker's CPU-dirty pages.
    RangeSet bind_dirty_ranges;
};

} // namespace VideoCore
