// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include <map>
#include <mutex>
#include <fmt/format.h>
#include "common/alignment.h"
#include "common/assert.h"
#include "common/logging/log.h"
#include "video_core/buffer_cache/bda_registry.h"
#include "video_core/buffer_cache/buffer.h"
#include "video_core/renderer_vulkan/liverpool_to_vk.h"
#include "video_core/renderer_vulkan/vk_instance.h"
#include "video_core/renderer_vulkan/vk_platform.h"
#include "video_core/renderer_vulkan/vk_scheduler.h"

#include <vk_mem_alloc.h>

namespace VideoCore {

// See bda_registry.h. Keyed by device address; a std::map so a faulting address resolves
// with one upper_bound. Contention is create/destroy only - never per bind, never per draw.
namespace {
struct BdaRangeInfo {
    u64 size;
    VAddr guest_addr;
};
std::mutex bda_registry_mutex;
std::map<u64, BdaRangeInfo> bda_registry;
} // namespace

void RegisterBdaRange(u64 bda_addr, u64 size, VAddr guest_addr) {
    std::scoped_lock lk{bda_registry_mutex};
    bda_registry[bda_addr] = BdaRangeInfo{size, guest_addr};
}

void UnregisterBdaRange(u64 bda_addr) {
    std::scoped_lock lk{bda_registry_mutex};
    bda_registry.erase(bda_addr);
}

std::string DescribeBdaAddressForFault(u64 device_addr) {
    std::scoped_lock lk{bda_registry_mutex};
    if (bda_registry.empty()) {
        return "    (no buffers with a device address are registered)";
    }
    // First range starting at or after the fault; the candidate that could CONTAIN the
    // fault is the one before it.
    auto after = bda_registry.upper_bound(device_addr);
    std::string out;
    const auto describe = [&](std::map<u64, BdaRangeInfo>::const_iterator it, const char* tag) {
        const u64 bda = it->first;
        const auto& info = it->second;
        const bool contains = device_addr >= bda && device_addr < bda + info.size;
        out += fmt::format("    {} buffer: bda [{:#x}, {:#x}) size {:#x} guest {:#x}{}\n", tag,
                           bda, bda + info.size, info.size, info.guest_addr,
                           contains ? fmt::format(" - CONTAINS the fault at bda+{:#x}",
                                                  device_addr - bda)
                                    : fmt::format(" - fault is {:#x} bytes {} it",
                                                  device_addr >= bda ? device_addr - (bda + info.size)
                                                                     : bda - device_addr,
                                                  device_addr >= bda ? "past" : "before"));
    };
    if (after != bda_registry.begin()) {
        auto prev = std::prev(after);
        describe(prev, "nearest-below");
        if (prev != bda_registry.begin()) {
            describe(std::prev(prev), "next-below");
        }
    }
    if (after != bda_registry.end()) {
        describe(after, "nearest-above");
    }
    if (out.empty()) {
        out = "    (registry has no neighbours for this address)";
    } else if (out.back() == '\n') {
        out.pop_back();
    }
    return out;
}

std::string_view BufferTypeName(MemoryUsage type) {
    switch (type) {
    case MemoryUsage::Upload:
        return "Upload";
    case MemoryUsage::Download:
        return "Download";
    case MemoryUsage::Stream:
        return "Stream";
    case MemoryUsage::DeviceLocal:
        return "DeviceLocal";
    default:
        return "Invalid";
    }
}

[[nodiscard]] VkMemoryPropertyFlags MemoryUsagePreferredVmaFlags(MemoryUsage usage) {
    return usage != MemoryUsage::DeviceLocal ? VK_MEMORY_PROPERTY_HOST_COHERENT_BIT
                                             : VkMemoryPropertyFlagBits{};
}

[[nodiscard]] VmaAllocationCreateFlags MemoryUsageVmaFlags(MemoryUsage usage) {
    switch (usage) {
    case MemoryUsage::Upload:
    case MemoryUsage::Stream:
        return VMA_ALLOCATION_CREATE_MAPPED_BIT |
               VMA_ALLOCATION_CREATE_HOST_ACCESS_SEQUENTIAL_WRITE_BIT;
    case MemoryUsage::Download:
        return VMA_ALLOCATION_CREATE_MAPPED_BIT | VMA_ALLOCATION_CREATE_HOST_ACCESS_RANDOM_BIT;
    case MemoryUsage::DeviceLocal:
        return {};
    }
    return {};
}

[[nodiscard]] VmaMemoryUsage MemoryUsageVma(MemoryUsage usage) {
    switch (usage) {
    case MemoryUsage::DeviceLocal:
    case MemoryUsage::Stream:
        return VMA_MEMORY_USAGE_AUTO_PREFER_DEVICE;
    case MemoryUsage::Upload:
    case MemoryUsage::Download:
        return VMA_MEMORY_USAGE_AUTO_PREFER_HOST;
    }
    return VMA_MEMORY_USAGE_AUTO_PREFER_DEVICE;
}

UniqueBuffer::UniqueBuffer(vk::Device device_, VmaAllocator allocator_)
    : device{device_}, allocator{allocator_} {}

UniqueBuffer::~UniqueBuffer() {
    if (buffer) {
        // The registry entry must die with the OWNER of the VkBuffer (this covers the
        // cache's deferred deletions too); the registration itself happens in Buffer's
        // constructor, which is the first place both the BDA and the guest range exist.
        if (bda_addr != 0) {
            UnregisterBdaRange(bda_addr);
        }
        vmaDestroyBuffer(allocator, buffer, allocation);
    }
}

void UniqueBuffer::Create(const vk::BufferCreateInfo& buffer_ci, MemoryUsage usage,
                          VmaAllocationInfo* out_alloc_info) {
    const bool with_bda = bool(buffer_ci.usage & vk::BufferUsageFlagBits::eShaderDeviceAddress);
    const VmaAllocationCreateFlags bda_flag =
        with_bda ? VMA_ALLOCATION_CREATE_DEDICATED_MEMORY_BIT : 0;
    const VmaAllocationCreateInfo alloc_ci = {
        .flags = VMA_ALLOCATION_CREATE_WITHIN_BUDGET_BIT | bda_flag | MemoryUsageVmaFlags(usage),
        .usage = MemoryUsageVma(usage),
        .requiredFlags = 0,
        .preferredFlags = MemoryUsagePreferredVmaFlags(usage),
        .pool = VK_NULL_HANDLE,
        .pUserData = nullptr,
    };

    const VkBufferCreateInfo buffer_ci_unsafe = static_cast<VkBufferCreateInfo>(buffer_ci);
    VkBuffer unsafe_buffer{};
    VkResult result = vmaCreateBuffer(allocator, &buffer_ci_unsafe, &alloc_ci, &unsafe_buffer,
                                      &allocation, out_alloc_info);
    // The SIZE is the discriminator the OOM death needs: a few-MB request means the caches
    // outgrew VRAM (GC pacing - it only runs per guest frame, and GT7's streaming allocates
    // thousands of buffers between frames), a multi-GB request means a torn GPU-driven V#'s
    // garbage size slipped past the base-address guards. Run 55 died here at 650 compiles
    // with no size in the log, and the two stories want opposite fixes.
    if (result != VK_SUCCESS) {
        // The census AT the death, not the one from the last GC pass seconds earlier. Run 118
        // died on a 1 MB request with VMA at 22 GB in 10.7k allocs, and the periodic lines
        // alone could not attribute it - pair this with the [vram]/[buffergc] sub-censuses.
        VmaTotalStatistics stats{};
        vmaCalculateStatistics(allocator, &stats);
        LOG_CRITICAL(Render_Vulkan,
                     "OOM census: VMA-owned {} MB in {} allocation(s) / {} block(s), request "
                     "was {} bytes ({})",
                     stats.total.statistics.allocationBytes >> 20,
                     stats.total.statistics.allocationCount, stats.total.statistics.blockCount,
                     buffer_ci.size, vk::to_string(vk::Result{result}));
    }
    ASSERT_MSG(result == VK_SUCCESS, "Failed allocating buffer of {} bytes with error {}",
               buffer_ci.size, vk::to_string(vk::Result{result}));
    buffer = vk::Buffer{unsafe_buffer};

    if (with_bda) {
        vk::BufferDeviceAddressInfo bda_info{
            .buffer = buffer,
        };
        auto bda_result = device.getBufferAddress(bda_info);
        ASSERT_MSG(bda_result != 0, "Failed to get buffer device address");
        bda_addr = bda_result;
    }
}

Buffer::Buffer(const Vulkan::Instance& instance_, Vulkan::Scheduler& scheduler_, MemoryUsage usage_,
               VAddr cpu_addr_, vk::BufferUsageFlags flags, u64 size_bytes_)
    : cpu_addr{cpu_addr_}, size_bytes{size_bytes_}, instance{&instance_}, scheduler{&scheduler_},
      usage{usage_}, buffer{instance->GetDevice(), instance->GetAllocator()} {
    // Create buffer object.
    const vk::BufferCreateInfo buffer_ci = {
        .size = size_bytes,
        .usage = flags,
    };
    VmaAllocationInfo alloc_info{};
    buffer.Create(buffer_ci, usage, &alloc_info);

    const auto device = instance->GetDevice();
    Vulkan::SetObjectName(device, Handle(), "Buffer {:#x}:{:#x}", cpu_addr, size_bytes);

    if (buffer.bda_addr != 0) {
        RegisterBdaRange(buffer.bda_addr, size_bytes, cpu_addr);
    }

    // Map it if it is host visible.
    VkMemoryPropertyFlags property_flags{};
    vmaGetAllocationMemoryProperties(instance->GetAllocator(), buffer.allocation, &property_flags);
    if (alloc_info.pMappedData) {
        mapped_data = std::span<u8>{std::bit_cast<u8*>(alloc_info.pMappedData), size_bytes};
    }
    is_coherent = property_flags & VK_MEMORY_PROPERTY_HOST_COHERENT_BIT;
}

void Buffer::Fill(u64 offset, u32 num_bytes, u32 value) {
    scheduler->EndRendering();
    ASSERT_MSG(offset % 4 == 0 && num_bytes % 4 == 0,
               "FillBuffer size must be a multiple of 4 bytes");
    const auto cmdbuf = scheduler->CommandBuffer();
    const vk::BufferMemoryBarrier2 pre_barrier = {
        .srcStageMask = vk::PipelineStageFlagBits2::eAllCommands,
        .srcAccessMask = vk::AccessFlagBits2::eMemoryRead,
        .dstStageMask = vk::PipelineStageFlagBits2::eTransfer,
        .dstAccessMask = vk::AccessFlagBits2::eTransferWrite,
        .buffer = buffer,
        .offset = offset,
        .size = num_bytes,
    };
    const vk::BufferMemoryBarrier2 post_barrier = {
        .srcStageMask = vk::PipelineStageFlagBits2::eTransfer,
        .srcAccessMask = vk::AccessFlagBits2::eTransferWrite,
        .dstStageMask = vk::PipelineStageFlagBits2::eAllCommands,
        .dstAccessMask = vk::AccessFlagBits2::eMemoryRead | vk::AccessFlagBits2::eMemoryWrite,
        .buffer = buffer,
        .offset = offset,
        .size = num_bytes,
    };
    cmdbuf.pipelineBarrier2(vk::DependencyInfo{
        .dependencyFlags = vk::DependencyFlagBits::eByRegion,
        .bufferMemoryBarrierCount = 1,
        .pBufferMemoryBarriers = &pre_barrier,
    });
    cmdbuf.fillBuffer(buffer, offset, num_bytes, value);
    cmdbuf.pipelineBarrier2(vk::DependencyInfo{
        .dependencyFlags = vk::DependencyFlagBits::eByRegion,
        .bufferMemoryBarrierCount = 1,
        .pBufferMemoryBarriers = &post_barrier,
    });
}

constexpr u64 WATCHES_INITIAL_RESERVE = 0x4000;
constexpr u64 WATCHES_RESERVE_CHUNK = 0x1000;

StreamBuffer::StreamBuffer(const Vulkan::Instance& instance, Vulkan::Scheduler& scheduler,
                           MemoryUsage usage, u64 size_bytes)
    : Buffer{instance, scheduler, usage, 0, AllFlags, size_bytes} {
    ReserveWatches(current_watches, WATCHES_INITIAL_RESERVE);
    ReserveWatches(previous_watches, WATCHES_INITIAL_RESERVE);
    const auto device = instance.GetDevice();
    Vulkan::SetObjectName(device, Handle(), "StreamBuffer({}):{:#x}", BufferTypeName(usage),
                          size_bytes);
}

std::pair<u8*, u64> StreamBuffer::Map(u64 size, u64 alignment, bool allow_wait) {
    if (!is_coherent && usage == MemoryUsage::Stream) {
        size = Common::AlignUp(size, instance->NonCoherentAtomSize());
    }

    if (size > this->size_bytes) {
        return {nullptr, 0};
    }

    mapped_size = size;

    if (alignment > 0) {
        offset = Common::AlignUp(offset, alignment);
    }

    if (offset + size > this->size_bytes) {
        // The buffer would overflow, save the amount of used watches and reset the state.
        invalidation_mark = current_watch_cursor;
        current_watch_cursor = 0;
        offset = 0;

        // Swap watches and reset waiting cursors.
        std::swap(previous_watches, current_watches);
        wait_cursor = 0;
        wait_bound = 0;
    }

    const u64 mapped_upper_bound = offset + size;
    if (!WaitPendingOperations(mapped_upper_bound, allow_wait)) {
        return {nullptr, 0};
    }

    return {mapped_data.data() + offset, offset};
}

void StreamBuffer::Commit() {
    if (!is_coherent) {
        if (usage == MemoryUsage::Download) {
            vmaInvalidateAllocation(instance->GetAllocator(), buffer.allocation, offset,
                                    mapped_size);
        } else {
            vmaFlushAllocation(instance->GetAllocator(), buffer.allocation, offset, mapped_size);
        }
    }

    offset += mapped_size;
    if (current_watch_cursor != 0 &&
        current_watches[current_watch_cursor].tick == scheduler->CurrentTick()) {
        current_watches[current_watch_cursor].upper_bound = offset;
        return;
    }

    if (current_watch_cursor + 1 >= current_watches.size()) {
        // Ensure that there are enough watches.
        ReserveWatches(current_watches, WATCHES_RESERVE_CHUNK);
    }

    auto& watch = current_watches[current_watch_cursor++];
    watch.upper_bound = offset;
    watch.tick = scheduler->CurrentTick();
}

void StreamBuffer::ReserveWatches(std::vector<Watch>& watches, std::size_t grow_size) {
    watches.resize(watches.size() + grow_size);
}

bool StreamBuffer::WaitPendingOperations(u64 requested_upper_bound, bool allow_wait) {
    if (!invalidation_mark) {
        return true;
    }
    while (requested_upper_bound > wait_bound && wait_cursor < *invalidation_mark) {
        auto& watch = previous_watches[wait_cursor];
        if (!scheduler->IsFree(watch.tick) && !allow_wait) {
            return false;
        }
        scheduler->Wait(watch.tick);
        wait_bound = watch.upper_bound;
        ++wait_cursor;
    }
    return true;
}

} // namespace VideoCore
