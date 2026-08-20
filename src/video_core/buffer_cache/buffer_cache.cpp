// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include <algorithm>
#include <memory>
#include <atomic>
#include <cstdlib>
#include "common/alignment.h"
#include "common/debug.h"
#include "common/scope_exit.h"
#include "core/memory.h"
#include "video_core/amdgpu/liverpool.h"
#include "video_core/buffer_cache/buffer_cache.h"
#include "video_core/buffer_cache/memory_tracker.h"
#include "video_core/renderer_vulkan/vk_graphics_pipeline.h"
#include "video_core/renderer_vulkan/vk_instance.h"
#include "video_core/renderer_vulkan/vk_scheduler.h"
#include "video_core/texture_cache/texture_cache.h"

namespace VideoCore {

namespace {
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

BufferCache::~BufferCache() = default;

void BufferCache::InvalidateMemory(VAddr device_addr, u64 size) {
    if (!IsRegionRegistered(device_addr, size)) {
        return;
    }
    memory_tracker->InvalidateRegion(
        device_addr, size, [this, device_addr, size] { ReadMemory(device_addr, size, true); });
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
        }
    });
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
        LogCopyClamp(buffer, device_addr, total_size_bytes, 0);
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
            memcpy(std::bit_cast<void*>(dst), std::bit_cast<void*>(src), num_bytes);
            return;
        }
        // Without a readback there's nothing we can do with this
        // Fallback to creating dst buffer on GPU to at least have this data there
    }
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
    // For read-only buffers use device local stream buffer to reduce renderpass breaks.
    if (!is_written && size <= CACHING_PAGESIZE && !IsRegionGpuModified(device_addr, size)) {
        const u64 offset = stream_buffer.Copy(device_addr, size, instance.UniformMinAlignment());
        return {&stream_buffer, offset};
    }
    if (IsBufferInvalid(buffer_id)) {
        buffer_id = FindBuffer(device_addr, size);
    }
    Buffer& buffer = slot_buffers[buffer_id];
    SynchronizeBuffer(buffer, device_addr, size, is_written, is_texel_buffer);
    if (is_written) {
        gpu_modified_ranges.Add(device_addr, size);
    }
    return {&buffer, buffer.Offset(device_addr)};
}

std::pair<Buffer*, u32> BufferCache::ObtainBufferForImage(VAddr gpu_addr, u32 size) {
    // Check if any buffer contains the full requested range.
    const BufferId buffer_id = page_table[gpu_addr >> CACHING_PAGEBITS].buffer_id;
    if (buffer_id) {
        if (Buffer& buffer = slot_buffers[buffer_id]; buffer.IsInBounds(gpu_addr, size)) {
            SynchronizeBuffer(buffer, gpu_addr, size, false, false);
            return {&buffer, buffer.Offset(gpu_addr)};
        }
    }
    // If some buffer within was GPU modified create a full buffer to avoid losing GPU data.
    if (IsRegionGpuModified(gpu_addr, size)) {
        return ObtainBuffer(gpu_addr, size, false, false);
    }
    // In all other cases, just do a CPU copy to the staging buffer.
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
        lru_cache.Free(buffer.LRUId());
        const u64 offset = bda_pagetable_buffer.Offset(page_begin * sizeof(vk::DeviceAddress));
        bda_pagetable_buffer.Fill(offset, size_pages * sizeof(vk::DeviceAddress), 0);
        buffer_ranges.Subtract(buffer.CpuAddr(), buffer.SizeBytes());
    }
}

bool BufferCache::SynchronizeBuffer(Buffer& buffer, VAddr device_addr, u32 size, bool is_written,
                                    bool is_texel_buffer) {
    boost::container::small_vector<vk::BufferCopy, 4> copies;
    size_t total_size_bytes = 0;
    VAddr buffer_start = buffer.CpuAddr();
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
    vk::Buffer src_buffer = VK_NULL_HANDLE;
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
            copies.emplace_back(total_size_bytes, begin - buffer_start, clamped_size);
            total_size_bytes += clamped_size;
        },
        [&] { src_buffer = UploadCopies(buffer, copies, total_size_bytes); });

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
    if (is_texel_buffer && !is_written) {
        return SynchronizeBufferFromImage(buffer, device_addr, size);
    }
    return false;
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
    const ImageId image_id = texture_cache.FindImageFromRange(device_addr, size);
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
                 "[vram] device {} MB, VMA-owned {} MB in {} allocs, pending deaths {} "
                 "(GC trigger {} MB)",
                 total_used_memory >> 20, vma_bytes >> 20, vma_allocs, pending_deaths.size(),
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
        LOG_WARNING(Render_Vulkan, "[buffergc] census: device {} MB, VMA-owned {} MB in {} allocs",
                    total_used_memory >> 20, vma_bytes >> 20, vma_allocs);
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
    // queued into pending_deaths with a snapshot of every timeline's CurrentTick, and
    // ProcessPendingDeaths (per submit, same thread) only erases once EVERY timeline has
    // passed its snapshot - a tick from the draw scheduler alone says nothing about the
    // present/flip command buffers that may still reference the buffer.
    pending_deaths.push_back({buffer_id, instance.SnapshotTimelines(), death});
    buffer.is_deleted = true;
}

void BufferCache::ProcessPendingDeaths() {
    if (pending_deaths.empty()) {
        return;
    }
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
        slot_buffers.erase(d.buffer_id);
        return true;
    });
}

} // namespace VideoCore
