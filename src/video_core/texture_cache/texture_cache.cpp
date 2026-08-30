// SPDX-FileCopyrightText: Copyright 2024-2026 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include <algorithm>
#include <bit>
#include <cstdlib>
#include <cstring>
#include <unordered_set>
#include <xxhash.h>

#include "common/assert.h"
#include "common/debug.h"
#include "common/div_ceil.h"
#include "common/scope_exit.h"
#include "core/emulator_settings.h"
#include "core/memory.h"
#include "video_core/buffer_cache/buffer_cache.h"
#include "video_core/gt_va_watch.h"
#include "video_core/page_manager.h"
#include "video_core/renderer_vulkan/vk_instance.h"
#include "video_core/renderer_vulkan/vk_scheduler.h"
#include "video_core/texture_cache/host_compatibility.h"
#include "video_core/texture_cache/texture_cache.h"
#include "video_core/texture_cache/tile_manager.h"

namespace VideoCore {

static constexpr u64 PageShift = 12;
static constexpr u64 NumFramesBeforeRemoval = 32;

TextureCache::TextureCache(const Vulkan::Instance& instance_, Vulkan::Scheduler& scheduler_,
                           AmdGpu::Liverpool* liverpool_, BufferCache& buffer_cache_,
                           PageManager& tracker_)
    : instance{instance_}, scheduler{scheduler_}, liverpool{liverpool_},
      buffer_cache{buffer_cache_}, tracker{tracker_}, blit_helper{instance, scheduler},
      tile_manager{instance, scheduler, buffer_cache.GetUtilityBuffer(MemoryUsage::Stream)},
      readback_linear_images{EmulatorSettings.IsReadbackLinearImagesEnabled()} {

    u32 max_samplers = instance.GetMaxSamplerAllocationCount();
    trigger_gc_samplers = max_samplers * 3 / 4;
    pressure_gc_samplers = max_samplers * 7 / 8;
    critical_gc_samplers = max_samplers * 15 / 16;

    // Set up garbage collection parameters.
    if (!instance.CanReportMemoryUsage()) {
        trigger_gc_memory = 0;
        pressure_gc_memory = DEFAULT_PRESSURE_GC_MEMORY;
        critical_gc_memory = DEFAULT_CRITICAL_GC_MEMORY;
        return;
    }

    const s64 device_local_memory = static_cast<s64>(instance.GetTotalMemoryBudget());
    const s64 min_spacing_expected = device_local_memory - 1_GB;
    const s64 min_spacing_critical = device_local_memory - 512_MB;
    const s64 mem_threshold = std::min<s64>(device_local_memory, TARGET_GC_THRESHOLD);
    const s64 min_vacancy_expected = (6 * mem_threshold) / 10;
    const s64 min_vacancy_critical = (2 * mem_threshold) / 10;
    pressure_gc_memory = static_cast<u64>(
        std::max<u64>(std::min(device_local_memory - min_vacancy_expected, min_spacing_expected),
                      DEFAULT_PRESSURE_GC_MEMORY));
    critical_gc_memory = static_cast<u64>(
        std::max<u64>(std::min(device_local_memory - min_vacancy_critical, min_spacing_critical),
                      DEFAULT_CRITICAL_GC_MEMORY));
    trigger_gc_memory = static_cast<u64>((device_local_memory - mem_threshold) / 2);
}

TextureCache::~TextureCache() = default;

void TextureCache::ProcessDownloadImages() {
    std::unique_lock lk{download_images_mutex};
    for (const ImageId image_id : download_images) {
        DownloadImageMemory(image_id, true);
    }
    download_images.clear();
}

// [dlimg] (readback hunt, run 186): run 185 turned GPU readbacks ON and the auto-exposure
// state STILL uploaded as zeros - so either no image download ever runs, or it runs and the
// bytes are zero, or TryWriteBacking drops it (it returns false on a VMA without physical
// backing and the download silently evaporates). One log per download says which.
static u32 gt_dlimg_seen = 0;

static void GtLogImageDownload(const ImageInfo& info, const void* data, u32 download_size,
                               bool wrote_backing) {
    ++gt_dlimg_seen;
    if (gt_dlimg_seen > 256 && (gt_dlimg_seen & 63u) != 0) {
        return;
    }
    u32 dw[8]{};
    std::memcpy(dw, data, std::min<u32>(sizeof(dw), download_size));
    LOG_WARNING(Render_Vulkan,
                "[dlimg] #{} download {:#x}+{:#x} ({}x{}x{} {} tiled {:d}) wb {:d} dw: {:08x} "
                "{:08x} {:08x} {:08x} {:08x} {:08x} {:08x} {:08x}",
                gt_dlimg_seen, info.guest_address, download_size, info.size.width,
                info.size.height, info.size.depth, vk::to_string(info.pixel_format),
                info.props.is_tiled ? 1 : 0, wrote_backing ? 1 : 0, dw[0], dw[1], dw[2], dw[3],
                dw[4], dw[5], dw[6], dw[7]);
}

// [dlskip] (readback hunt): a GPU-written image the linear-image readback CANNOT service -
// tiled and wider than 8 texels. If the exposure measurement chain lands here, the game's CPU
// reads eternal zeros no matter what readbacks_mode says. Once per guest address, 64 max.
static void GtLogDownloadReject(const char* where, const ImageInfo& info) {
    static std::unordered_set<VAddr> gt_dlskip_seen;
    if (gt_dlskip_seen.size() >= 64 || !gt_dlskip_seen.insert(info.guest_address).second) {
        return;
    }
    LOG_WARNING(Render_Vulkan, "[dlskip] {} image not downloadable: {:#x}+{:#x} {}x{}x{} {} tiled {:d}",
                where, info.guest_address, info.guest_size, info.size.width, info.size.height,
                info.size.depth, vk::to_string(info.pixel_format), info.props.is_tiled ? 1 : 0);
}

void TextureCache::DownloadImageMemory(ImageId image_id, bool sync) {
    Image& image = slot_images[image_id];
    if (False(image.flags & ImageFlagBits::GpuModified)) {
        return;
    }
    auto& download_buffer = buffer_cache.GetUtilityBuffer(MemoryUsage::Download);
    const u32 download_size = image.info.pitch * image.info.size.height * image.info.size.depth *
                              image.info.resources.layers * (image.info.num_bits / 8);
    ASSERT(download_size <= image.info.guest_size);
    const auto [download, offset] = download_buffer.Map(download_size);
    download_buffer.Commit();
    const vk::BufferImageCopy image_download = {
        .bufferOffset = offset,
        .bufferRowLength = image.info.pitch,
        .bufferImageHeight = image.info.size.height,
        .imageSubresource =
            {
                .aspectMask = image.info.props.is_depth ? vk::ImageAspectFlagBits::eDepth
                                                        : vk::ImageAspectFlagBits::eColor,
                .mipLevel = 0,
                .baseArrayLayer = 0,
                .layerCount = image.info.resources.layers,
            },
        .imageOffset = {0, 0, 0},
        .imageExtent = {image.info.size.width, image.info.size.height, image.info.size.depth},
    };
    scheduler.EndRendering();
    const auto cmdbuf = scheduler.CommandBuffer();
    image.Transit(vk::ImageLayout::eTransferSrcOptimal, vk::AccessFlagBits2::eTransferRead, {});
    cmdbuf.copyImageToBuffer(image.GetImage(), vk::ImageLayout::eTransferSrcOptimal,
                             download_buffer.Handle(), image_download);

    if (sync) {
        scheduler.Finish();
        const bool wb = Core::Memory::Instance()->TryWriteBacking(
            std::bit_cast<u8*>(image.info.guest_address), download, download_size);
        GtLogImageDownload(image.info, download, download_size, wb);
    } else {
        scheduler.DeferPriorityOperation(
            [info = image.info, download, download_size] {
                const bool wb = Core::Memory::Instance()->TryWriteBacking(
                    std::bit_cast<u8*>(info.guest_address), download, download_size);
                GtLogImageDownload(info, download, download_size, wb);
            });
    }
}

void TextureCache::MarkAsMaybeDirty(ImageId image_id, Image& image) {
    if (image.hash == 0) {
        // Initialize hash
        const u8* addr = std::bit_cast<u8*>(image.info.guest_address);
        image.hash = XXH3_64bits(addr, image.info.guest_size);
    }
    image.flags |= ImageFlagBits::MaybeCpuDirty;
    UntrackImage(image_id);
}

void TextureCache::InvalidateMemory(VAddr addr, size_t size) {
    std::scoped_lock lock{mutex};
    const auto pages_start = PageManager::GetPageAddr(addr);
    const auto pages_end = PageManager::GetNextPageAddr(addr + size - 1);
    ForEachImageInRegion(pages_start, pages_end - pages_start, [&](ImageId image_id, Image& image) {
        const auto image_begin = image.info.guest_address;
        const auto image_end = image.info.guest_address + image.info.guest_size;
        if (image.Overlaps(addr, size)) {
            // Modified region overlaps image, so the image was definitely accessed by this fault.
            // Untrack the image, so that the range is unprotected and the guest can write freely.
            image.flags |= ImageFlagBits::CpuDirty;
            UntrackImage(image_id);
        } else if (pages_end < image_end) {
            // This page access may or may not modify the image.
            // We should not mark it as dirty now. If it really was modified
            // it will receive more invalidations on its other pages.
            // Remove tracking from this page only.
            UntrackImageHead(image_id);
        } else if (image_begin < pages_start) {
            // This page access does not modify the image but the page should be untracked.
            // We should not mark this image as dirty now. If it really was modified
            // it will receive more invalidations on its other pages.
            UntrackImageTail(image_id);
        } else {
            // Image begins and ends on this page so it can not receive any more invalidations.
            // We will check it's hash later to see if it really was modified.
            MarkAsMaybeDirty(image_id, image);
        }
    });
}

void TextureCache::InvalidateMemoryFromGPU(VAddr address, size_t max_size) {
    std::scoped_lock lock{mutex};
    ForEachImageInRegion(address, max_size, [&](ImageId image_id, Image& image) {
        // Only consider images that match base address.
        // TODO: Maybe also consider subresources
        if (image.info.guest_address != address) {
            return;
        }
        // Ensure image is reuploaded when accessed again.
        image.flags |= ImageFlagBits::GpuDirty;
    });
}

void TextureCache::UnmapMemory(VAddr cpu_addr, size_t size) {
    std::scoped_lock lk{mutex};

    ImageIds deleted_images;
    ForEachImageInRegion(cpu_addr, size, [&](ImageId id, Image&) { deleted_images.push_back(id); });
    for (const ImageId id : deleted_images) {
        // TODO: Download image data back to host.
        FreeImage(id);
    }
}

ImageId TextureCache::ResolveDepthOverlap(const ImageInfo& requested_info, BindingType binding,
                                          ImageId cache_image_id) {
    auto& cache_image = slot_images[cache_image_id];

    if (!cache_image.info.props.is_depth && !requested_info.props.is_depth) {
        return {};
    }

    const bool stencil_match =
        requested_info.props.has_stencil == cache_image.info.props.has_stencil;
    const bool bpp_match = requested_info.num_bits == cache_image.info.num_bits;

    // If an image in the cache has less slices we need to expand it
    bool recreate = cache_image.info.resources < requested_info.resources;

    switch (binding) {
    case BindingType::Texture:
        // The guest requires a depth sampled texture, but cache can offer only Rxf. Need to
        // recreate the image.
        recreate |= requested_info.props.is_depth && !cache_image.info.props.is_depth;
        break;
    case BindingType::Storage:
        // If the guest is going to use previously created depth as storage, the image needs to be
        // recreated. (TODO: Probably a case with linear rgba8 aliasing is legit)
        recreate |= cache_image.info.props.is_depth;
        break;
    case BindingType::RenderTarget:
        // Render target can have only Rxf format. If the cache contains only Dx[S8] we need to
        // re-create the image.
        ASSERT(!requested_info.props.is_depth);
        recreate |= cache_image.info.props.is_depth;
        break;
    case BindingType::DepthTarget:
        // The guest has requested previously allocated texture to be bound as a depth target.
        // In this case we need to convert Rx float to a Dx[S8] as requested
        recreate |= !cache_image.info.props.is_depth;

        // The guest is trying to bind a depth target and cache has it. Need to be sure that aspects
        // and bpp match
        recreate |= cache_image.info.props.is_depth && !(stencil_match && bpp_match);
        break;
    default:
        break;
    }

    if (recreate) {
        auto new_info = requested_info;
        new_info.resources = std::max(requested_info.resources, cache_image.info.resources);
        const auto new_image_id =
            slot_images.insert(instance, scheduler, blit_helper, slot_image_views, new_info);
        RegisterImage(new_image_id);

        // Inherit image usage
        auto& new_image = slot_images[new_image_id];
        new_image.usage = cache_image.usage;
        new_image.flags &= ~ImageFlagBits::Dirty;
        // When creating a depth buffer through overlap resolution don't clear it on first use.
        new_image.info.meta_info.htile_clear_mask = 0;

        if (cache_image.info.num_samples == 1 && new_info.num_samples == 1) {
            // Perform depth<->color copy using the intermediate copy buffer.
            if (instance.IsMaintenance8Supported()) {
                new_image.CopyImage(cache_image);
            } else {
                const auto& copy_buffer = buffer_cache.GetUtilityBuffer(MemoryUsage::DeviceLocal);
                new_image.CopyImageWithBuffer(cache_image, copy_buffer.Handle(), 0);
            }
        } else if (cache_image.info.num_samples == 1 && new_info.props.is_depth &&
                   new_info.num_samples > 1) {
            // Perform a rendering pass to transfer the channels of source as samples in dest.
            cache_image.Transit(vk::ImageLayout::eShaderReadOnlyOptimal,
                                vk::AccessFlagBits2::eShaderRead, {});
            new_image.Transit(vk::ImageLayout::eDepthAttachmentOptimal,
                              vk::AccessFlagBits2::eDepthStencilAttachmentWrite, {});
            blit_helper.ReinterpretColorAsMsDepth(
                new_info.size.width, new_info.size.height, new_info.num_samples,
                cache_image.info.pixel_format, new_info.pixel_format, cache_image.GetImage(),
                new_image.GetImage());
        } else {
            LOG_WARNING(Render_Vulkan, "Unimplemented depth overlap copy");
        }

        // Free the cache image.
        FreeImage(cache_image_id);
        return new_image_id;
    }

    // Will be handled by view
    return cache_image_id;
}

std::tuple<ImageId, int, int> TextureCache::ResolveOverlap(const ImageInfo& image_info,
                                                           BindingType binding,
                                                           ImageId cache_image_id,
                                                           ImageId merged_image_id) {
    auto& cache_image = slot_images[cache_image_id];
    const bool safe_to_delete =
        scheduler.CurrentTick() - cache_image.tick_accessed_last > NumFramesBeforeRemoval;

    // Equal address
    if (image_info.guest_address == cache_image.info.guest_address) {
        const u32 lhs_block_size = image_info.num_bits * image_info.num_samples;
        const u32 rhs_block_size = cache_image.info.num_bits * cache_image.info.num_samples;
        if (image_info.BlockDim() != cache_image.info.BlockDim() ||
            lhs_block_size != rhs_block_size) {
            // Very likely this kind of overlap is caused by allocation from a pool.
            if (safe_to_delete) {
                FreeImage(cache_image_id);
            }
            return {merged_image_id, -1, -1};
        }

        if (const auto depth_image_id = ResolveDepthOverlap(image_info, binding, cache_image_id)) {
            return {depth_image_id, -1, -1};
        }

        // Compressed view of uncompressed image with same block size.
        if (image_info.props.is_block && !cache_image.info.props.is_block) {
            return {ExpandImage(image_info, cache_image_id), -1, -1};
        }

        if (image_info.guest_size == cache_image.info.guest_size &&
            (image_info.type == AmdGpu::ImageType::Color3D ||
             cache_image.info.type == AmdGpu::ImageType::Color3D)) {
            return {ExpandImage(image_info, cache_image_id), -1, -1};
        }

        // Size and resources are less than or equal, use image view.
        if (image_info.pixel_format != cache_image.info.pixel_format ||
            image_info.guest_size <= cache_image.info.guest_size) {
            auto result_id = merged_image_id ? merged_image_id : cache_image_id;
            const auto& result_image = slot_images[result_id];
            const bool is_compatible =
                IsVulkanFormatCompatible(result_image.info.pixel_format, image_info.pixel_format);
            return {is_compatible ? result_id : ImageId{}, -1, -1};
        }

        // Size and resources are greater, expand the image.
        if (image_info.type == cache_image.info.type &&
            image_info.resources > cache_image.info.resources) {
            return {ExpandImage(image_info, cache_image_id), -1, -1};
        }

        // Size is greater but resources are not, because the tiling mode is different.
        // Likely the address is reused for a image with a different tiling mode.
        if (image_info.tile_mode != cache_image.info.tile_mode) {
            if (safe_to_delete) {
                FreeImage(cache_image_id);
            }
            return {merged_image_id, -1, -1};
        }

        // Enhanced debug logging for unreachable case
        // Calculate expected size based on format and dimensions
        u64 expected_size =
            (static_cast<u64>(image_info.size.width) * static_cast<u64>(image_info.size.height) *
             static_cast<u64>(image_info.size.depth) * static_cast<u64>(image_info.num_bits) / 8);
        LOG_ERROR(Render_Vulkan,
                  "Unresolvable image overlap with equal memory address:\n"
                  "=== OLD IMAGE (cached) ===\n"
                  "  Address:        {:#x}\n"
                  "  Size:           {:#x} bytes\n"
                  "  Format:         {}\n"
                  "  Type:           {}\n"
                  "  Width:          {}\n"
                  "  Height:         {}\n"
                  "  Depth:          {}\n"
                  "  Pitch:          {}\n"
                  "  Mip levels:     {}\n"
                  "  Array layers:   {}\n"
                  "  Samples:        {}\n"
                  "  Tile mode:      {:#x}\n"
                  "  Block size:     {} bits\n"
                  "  Is block-comp:  {}\n"
                  "  Guest size:     {:#x}\n"
                  "  Last accessed:  tick {}\n"
                  "  Safe to delete: {}\n"
                  "\n"
                  "=== NEW IMAGE (requested) ===\n"
                  "  Address:        {:#x}\n"
                  "  Size:           {:#x} bytes\n"
                  "  Format:         {}\n"
                  "  Type:           {}\n"
                  "  Width:          {}\n"
                  "  Height:         {}\n"
                  "  Depth:          {}\n"
                  "  Pitch:          {}\n"
                  "  Mip levels:     {}\n"
                  "  Array layers:   {}\n"
                  "  Samples:        {}\n"
                  "  Tile mode:      {:#x}\n"
                  "  Block size:     {} bits\n"
                  "  Is block-comp:  {}\n"
                  "  Guest size:     {:#x}\n"
                  "\n"
                  "=== COMPARISON ===\n"
                  "  Same format:           {}\n"
                  "  Same type:             {}\n"
                  "  Same tile mode:        {}\n"
                  "  Same block size:       {}\n"
                  "  Same BlockDim:         {}\n"
                  "  Same pitch:            {}\n"
                  "  Old resources <= new:  {} (old: {}, new: {})\n"
                  "  Old size <= new size:  {}\n"
                  "  Expected size (calc):  {} bytes\n"
                  "  Size ratio (new/expected): {:.2f}x\n"
                  "  Size ratio (new/old):  {:.2f}x\n"
                  "  Old vs expected diff:  {} bytes ({:+.2f}%)\n"
                  "  New vs expected diff:  {} bytes ({:+.2f}%)\n"
                  "  Merged image ID:       {}\n"
                  "  Binding type:          {}\n"
                  "  Current tick:          {}\n"
                  "  Age (ticks since last access): {}",

                  // Old image details
                  cache_image.info.guest_address, cache_image.info.guest_size,
                  vk::to_string(cache_image.info.pixel_format),
                  static_cast<int>(cache_image.info.type), cache_image.info.size.width,
                  cache_image.info.size.height, cache_image.info.size.depth, cache_image.info.pitch,
                  cache_image.info.resources.levels, cache_image.info.resources.layers,
                  cache_image.info.num_samples, static_cast<u32>(cache_image.info.tile_mode),
                  cache_image.info.num_bits, +cache_image.info.props.is_block,
                  cache_image.info.guest_size, cache_image.tick_accessed_last, safe_to_delete,

                  // New image details
                  image_info.guest_address, image_info.guest_size,
                  vk::to_string(image_info.pixel_format), static_cast<int>(image_info.type),
                  image_info.size.width, image_info.size.height, image_info.size.depth,
                  image_info.pitch, image_info.resources.levels, image_info.resources.layers,
                  image_info.num_samples, static_cast<u32>(image_info.tile_mode),
                  image_info.num_bits, image_info.props.is_block, image_info.guest_size,

                  // Comparison
                  (image_info.pixel_format == cache_image.info.pixel_format),
                  (image_info.type == cache_image.info.type),
                  (image_info.tile_mode == cache_image.info.tile_mode),
                  (image_info.num_bits == cache_image.info.num_bits),
                  (image_info.BlockDim() == cache_image.info.BlockDim()),
                  (image_info.pitch == cache_image.info.pitch),
                  (cache_image.info.resources <= image_info.resources),
                  cache_image.info.resources.levels, image_info.resources.levels,
                  (cache_image.info.guest_size <= image_info.guest_size), expected_size,

                  // Size ratios
                  static_cast<double>(image_info.guest_size) / expected_size,
                  static_cast<double>(image_info.guest_size) / cache_image.info.guest_size,

                  // Difference between actual and expected sizes with percentages
                  static_cast<s64>(cache_image.info.guest_size) - static_cast<s64>(expected_size),
                  (static_cast<double>(cache_image.info.guest_size) / expected_size - 1.0) * 100.0,

                  static_cast<s64>(image_info.guest_size) - static_cast<s64>(expected_size),
                  (static_cast<double>(image_info.guest_size) / expected_size - 1.0) * 100.0,

                  merged_image_id.index, static_cast<int>(binding), scheduler.CurrentTick(),
                  scheduler.CurrentTick() - cache_image.tick_accessed_last);

        UNREACHABLE_MSG("Encountered unresolvable image overlap with equal memory address.");
    }

    // Right overlap, the image requested is a possible subresource of the image from cache.
    if (image_info.guest_address > cache_image.info.guest_address) {
        if (auto mip = image_info.MipOf(cache_image.info); mip >= 0) {
            if (auto slice = image_info.SliceOf(cache_image.info, mip); slice >= 0) {
                return {cache_image_id, mip, slice};
            }
        }

        // Image isn't a subresource but a chance overlap.
        if (safe_to_delete) {
            FreeImage(cache_image_id);
        }

        return {{}, -1, -1};
    } else {
        // Left overlap, the image from cache is a possible subresource of the image requested
        if (auto mip = cache_image.info.MipOf(image_info); mip >= 0) {
            if (auto slice = cache_image.info.SliceOf(image_info, mip); slice >= 0) {
                // We have a larger image created and a separate one, representing a subres of it
                // bound as render target. In this case we need to rebind render target.
                if (cache_image.binding.is_target) {
                    cache_image.binding.needs_rebind = 1u;
                    if (merged_image_id) {
                        GetImage(merged_image_id).binding.is_target = 1u;
                    }

                    FreeImage(cache_image_id);
                    return {merged_image_id, -1, -1};
                }

                // We need to have a larger, already allocated image to copy this one into
                if (merged_image_id) {
                    auto& merged_image = slot_images[merged_image_id];
                    merged_image.CopyMip(cache_image, mip, slice);
                    FreeImage(cache_image_id);
                }
            }
        }
    }

    return {merged_image_id, -1, -1};
}

ImageId TextureCache::ExpandImage(const ImageInfo& info, ImageId image_id) {
    const auto new_image_id =
        slot_images.insert(instance, scheduler, blit_helper, slot_image_views, info);
    RegisterImage(new_image_id);

    auto& src_image = slot_images[image_id];
    auto& new_image = slot_images[new_image_id];

    RefreshImage(new_image);
    new_image.CopyImage(src_image);

    if (src_image.binding.is_bound || src_image.binding.is_target) {
        src_image.binding.needs_rebind = 1u;
    }

    FreeImage(image_id);

    TrackImage(new_image_id);
    new_image.flags &= ~ImageFlagBits::Dirty;
    return new_image_id;
}

void TextureCache::SynchronizeVerticalAlias(ImageId destination_id,
                                            const ImageIds& overlapping_images) {
    static const bool enabled = [] {
        const char* value = std::getenv("GT_VERTICAL_ALIAS");
        return value && value[0] == '1';
    }();
    if (!enabled) {
        return;
    }

    Image& destination = slot_images[destination_id];
    const ImageInfo& dst = destination.info;
    if (dst.props.is_depth || dst.props.is_block || dst.resources.levels != 1 ||
        dst.resources.layers != 1 || dst.size.depth != 1) {
        return;
    }

    ImageId source_id{};
    u64 newest_serial = destination.gpu_write_serial;
    for (const ImageId candidate_id : overlapping_images) {
        if (candidate_id == destination_id || !slot_images.is_allocated(candidate_id)) {
            continue;
        }
        Image& candidate = slot_images[candidate_id];
        const ImageInfo& src = candidate.info;
        const bool compatible =
            src.guest_address == dst.guest_address && src.pixel_format == dst.pixel_format &&
            src.type == dst.type && src.tile_mode == dst.tile_mode &&
            src.array_mode == dst.array_mode && src.num_bits == dst.num_bits &&
            src.num_samples == dst.num_samples && src.pitch == dst.pitch &&
            src.size.width == dst.size.width && src.size.depth == 1 &&
            src.resources.levels == 1 && src.resources.layers == 1 && !src.props.is_depth &&
            !src.props.is_block && src.size.height > dst.size.height &&
            src.size.height % dst.size.height == 0;
        if (!compatible || candidate.gpu_write_serial <= newest_serial ||
            candidate.binding.is_target || candidate.binding.force_general) {
            continue;
        }
        source_id = candidate_id;
        newest_serial = candidate.gpu_write_serial;
    }

    if (!source_id) {
        return;
    }

    Image& source = slot_images[source_id];
    destination.CopyRect(source, vk::Extent3D{dst.size.width, dst.size.height, 1});
    destination.gpu_write_serial = newest_serial;

    static u32 log_budget = 0;
    if (log_budget++ < 128) {
        LOG_WARNING(Render_Vulkan,
                    "[imgalias] copied same-base top field {:#x}: {}x{} -> {}x{} pitch {} "
                    "format {} serial {}",
                    dst.guest_address, source.info.size.width, source.info.size.height,
                    dst.size.width, dst.size.height, dst.pitch, vk::to_string(dst.pixel_format),
                    newest_serial);
    }
}

ImageId TextureCache::FindImage(ImageDesc& desc, bool exact_fmt) {
    const auto& info = desc.info;
    ASSERT(info.guest_address != 0);

    std::scoped_lock lock{mutex};
    ImageIds image_ids;
    ForEachImageInRegion(info.guest_address, info.guest_size,
                         [&](ImageId image_id, Image& image) { image_ids.push_back(image_id); });

    ImageId image_id{};

    // Check for a perfect match first
    for (const auto& cache_id : image_ids) {
        auto& cache_image = slot_images[cache_id];
        if (cache_image.info.guest_address != info.guest_address) {
            continue;
        }
        if (cache_image.info.guest_size != info.guest_size) {
            continue;
        }
        if (cache_image.info.size != info.size) {
            continue;
        }
        if (!IsVulkanFormatCompatible(cache_image.info.pixel_format, info.pixel_format) ||
            (cache_image.info.type != info.type && info.size != Extent3D{1, 1, 1})) {
            continue;
        }
        if (exact_fmt && info.pixel_format != cache_image.info.pixel_format) {
            continue;
        }
        image_id = cache_id;
    }

    // Try to resolve overlaps (if any)
    int view_mip{-1};
    int view_slice{-1};
    if (!image_id) {
        for (const auto& cache_id : image_ids) {
            view_mip = -1;
            view_slice = -1;

            const auto& merged_info = image_id ? slot_images[image_id].info : info;
            auto [overlap_image_id, overlap_view_mip, overlap_view_slice] =
                ResolveOverlap(merged_info, desc.type, cache_id, image_id);
            if (overlap_image_id) {
                image_id = overlap_image_id;
                view_mip = overlap_view_mip;
                view_slice = overlap_view_slice;
            }
        }
    }

    if (image_id) {
        Image& image_resolved = slot_images[image_id];
        if (exact_fmt && info.pixel_format != image_resolved.info.pixel_format) {
            // Cannot reuse this image as we need the exact requested format.
            image_id = {};
        } else if (image_resolved.info.resources < info.resources) {
            // The image was clearly picked up wrong.
            FreeImage(image_id);
            image_id = {};
            LOG_WARNING(Render_Vulkan, "Image overlap resolve failed");
        }
    }
    // Create and register a new image
    if (!image_id) {
        image_id = slot_images.insert(instance, scheduler, blit_helper, slot_image_views, info);
        RegisterImage(image_id);
    }

    Image& image = slot_images[image_id];
    image.tick_accessed_last = scheduler.CurrentTick();
    TouchImage(image);

    // A PS4 allocation may be rendered as one vertically packed image and sampled through a
    // smaller same-base T#. Vulkan cannot express a view with a different image height, so both
    // host images must exist. Keep the sampled representation coherent with the newest GPU
    // render instead of letting UpdateImage upload stale guest RAM into the smaller alias.
    if (desc.type == BindingType::Texture) {
        SynchronizeVerticalAlias(image_id, image_ids);
    }

    // If the image requested is a subresource of the image from cache record its location.
    if (view_mip > 0) {
        desc.view_info.range.base.level = view_mip;
    }
    if (view_slice > 0) {
        desc.view_info.range.base.layer = view_slice;
    }

    return image_id;
}

ImageId TextureCache::FindImageFromRange(VAddr address, size_t size, bool ensure_valid) {
    ImageIds image_ids;
    ForEachImageInRegion(address, size, [&](ImageId image_id, Image& image) {
        if (image.info.guest_address != address) {
            return;
        }
        if (ensure_valid && !image.SafeToDownload()) {
            return;
        }
        image_ids.push_back(image_id);
    });
    if (image_ids.size() == 1) {
        // Sometimes image size might not exactly match with requested buffer size
        // If we only found 1 candidate image use it without too many questions.
        return image_ids.back();
    }
    if (!image_ids.empty()) {
        for (s32 i = 0; i < image_ids.size(); ++i) {
            Image& image = slot_images[image_ids[i]];
            if (image.info.guest_size == size) {
                return image_ids[i];
            }
        }
        LOG_WARNING(Render_Vulkan,
                    "Failed to find exact image match for copy addr={:#x}, size={:#x}", address,
                    size);
    }
    return {};
}

ImageView& TextureCache::FindTexture(ImageId image_id, const ImageDesc& desc) {
    Image& image = slot_images[image_id];
    if (desc.type == BindingType::Storage) {
        image.flags |= ImageFlagBits::GpuModified;
        if (readback_linear_images && (!image.info.props.is_tiled || image.info.size.width <= 8) &&
            image.info.guest_address != 0) {
            std::unique_lock lk{download_images_mutex};
            download_images.emplace(image_id);
        } else if (readback_linear_images) {
            GtLogDownloadReject("storage", image.info);
        }
    }
    UpdateImage(image_id);
    return image.FindView(desc.view_info);
}

ImageView& TextureCache::FindRenderTarget(ImageId image_id, const ImageDesc& desc) {
    Image& image = slot_images[image_id];
    image.flags |= ImageFlagBits::GpuModified;
    if (readback_linear_images && (!image.info.props.is_tiled || image.info.size.width <= 8)) {
        std::unique_lock lk{download_images_mutex};
        download_images.emplace(image_id);
    } else if (readback_linear_images) {
        GtLogDownloadReject("rt", image.info);
    }
    image.usage.render_target = 1u;
    UpdateImage(image_id);

    // Register meta data for this color buffer
    if (desc.info.meta_info.cmask_addr) {
        surface_metas.emplace(desc.info.meta_info.cmask_addr,
                              MetaDataInfo{.type = MetaDataInfo::Type::CMask});
        image.info.meta_info.cmask_addr = desc.info.meta_info.cmask_addr;
    }

    if (desc.info.meta_info.fmask_addr) {
        surface_metas.emplace(desc.info.meta_info.fmask_addr,
                              MetaDataInfo{.type = MetaDataInfo::Type::FMask});
        image.info.meta_info.fmask_addr = desc.info.meta_info.fmask_addr;
    }

    return image.FindView(desc.view_info, false);
}

ImageView& TextureCache::FindDepthTarget(ImageId image_id, const ImageDesc& desc) {
    Image& image = slot_images[image_id];
    image.flags |= ImageFlagBits::GpuModified;
    image.usage.depth_target = 1u;
    UpdateImage(image_id);

    // Register meta data for this depth buffer
    if (desc.info.meta_info.htile_addr) {
        surface_metas.emplace(desc.info.meta_info.htile_addr,
                              MetaDataInfo{.type = MetaDataInfo::Type::HTile,
                                           .clear_mask = image.info.meta_info.htile_clear_mask});
        image.info.meta_info.htile_addr = desc.info.meta_info.htile_addr;
    }

    // If there is a stencil attachment, link depth and stencil.
    if (desc.info.stencil_addr != 0) {
        ImageId stencil_id{};
        ForEachImageInRegion(desc.info.stencil_addr, desc.info.stencil_size,
                             [&](ImageId image_id, Image& image) {
                                 if (image.info.guest_address == desc.info.stencil_addr) {
                                     stencil_id = image_id;
                                 }
                             });
        if (!stencil_id) {
            ImageInfo info{};
            info.guest_address = desc.info.stencil_addr;
            info.guest_size = desc.info.stencil_size;
            info.size = desc.info.size;
            stencil_id =
                slot_images.insert(instance, scheduler, blit_helper, slot_image_views, info);
            RegisterImage(stencil_id);
        }
        Image& stencil_image = slot_images[stencil_id];
        TouchImage(stencil_image);
        stencil_image.AssociateDepth(image_id, image.image_uid);
    }

    return image.FindView(desc.view_info, false);
}

void TextureCache::RefreshImage(Image& image) {
    if (False(image.flags & ImageFlagBits::Dirty) || image.info.num_samples > 1) {
        return;
    }

    // A pure GpuDirty notification promises that newer bytes exist in the buffer cache. If the
    // image has already been written by a recorded draw/dispatch but no tracked GPU buffer covers
    // its guest range, ObtainBufferForImage has nothing newer to propagate: it falls back to an
    // upload from guest RAM. GT7 repeatedly reaches this state for rendered post-process images,
    // whose guest backing is still zeroed, and the fallback erases the valid host image. Preserve
    // the completed GPU image only for this orphan notification. CPU dirt and tracked GPU-buffer
    // writes still follow the normal upload path below.
    static const bool gpuwrite_noclobber = [] {
        const char* value = std::getenv("GT_GPUWRITE_NOCLOBBER");
        return value && value[0] == '1';
    }();
    const bool gpu_only_dirty =
        True(image.flags & ImageFlagBits::GpuDirty) &&
        False(image.flags & (ImageFlagBits::CpuDirty | ImageFlagBits::MaybeCpuDirty));
    if (gpuwrite_noclobber && image.gpu_write_serial != 0 && gpu_only_dirty &&
        !buffer_cache.IsRegionGpuModified(image.info.guest_address, image.info.guest_size)) {
        static std::unordered_map<u64, u32> coherent_log_budget;
        u32& seen = coherent_log_budget[image.info.guest_address];
        if (++seen <= 4 || (seen & 255u) == 0) {
            LOG_WARNING(Render_Vulkan,
                        "[imgcoherent] preserved completed GPU image {:#x}+{:#x} "
                        "({}x{}x{} {}) after orphan GpuDirty, serial {} #{}",
                        image.info.guest_address, image.info.guest_size, image.info.size.width,
                        image.info.size.height, image.info.size.depth,
                        vk::to_string(image.info.pixel_format), image.gpu_write_serial, seen);
        }
        image.flags &= ~ImageFlagBits::GpuDirty;
        return;
    }

    // ⚠⚠ GT_RT_NOCLOBBER (run 190): THE CLOBBER DOOR IS ALSO OPEN ON THE SCENE ITSELF.
    //
    // The GpuDirty clobber this project already closed for the 64^3 grading LUT (c66b0d04) was
    // closed for THAT SHAPE ONLY - every other image keeps the upstream rule, which is "a dirty
    // image is re-uploaded from guest memory, no questions asked". Measured on GT7 (run 189,
    // the [imgsrc]/[aewatch] instruments):
    //
    //   [lut3d]   rt: 1920x2160x1 layers 1 at 0x100a0b0000+0x2200000 bound as color target
    //   [aewatch] upload 0x100a0b0000+0x2200000 (1920x2160x1 R16G16B16A16Sfloat) GPU-dirty
    //   [imgsrc]  0x100a0b0000+0x2200000 <- staging (gpumod 0 cpudirty 1)
    //
    // That is a two-field 1920x2160 atlas sampled through 1920x1080 same-base T#s. Its measured
    // sample count is 1, so the num_samples guard above does not protect it - and
    // "<- staging" is ObtainBufferForImage's last resort: CopySparseMemory of the WHOLE 34 MB of
    // guest RAM, with no dirty-range filtering, straight over everything the GPU just rendered.
    // gpumod is 0 because rendering INTO an image never marks the BUFFER cache's GPU ranges, so
    // the render target can never take the cached path; cpudirty is 1 because one CPU write
    // anywhere inside a 34 MB span marks the whole image.
    //
    // Mode 1 MEASURES it and changes nothing (how often, which images, and - decisively - what
    // the guest bytes actually are: zeros would black the scene, garbage half-floats near 65504
    // are a white wash). Mode 2 BLOCKS it: an image the GPU has rendered into keeps its rendered
    // content, and the dirt is consumed rather than obeyed. Default 0 = upstream behaviour.
    static const int rt_noclobber = [] {
        const char* v = std::getenv("GT_RT_NOCLOBBER");
        return v ? std::atoi(v) : 0;
    }();
    if (rt_noclobber != 0 && (image.usage.render_target || image.usage.depth_target) &&
        True(image.flags & ImageFlagBits::GpuModified)) {
        static std::unordered_map<u64, u32> rtclobber_budget;
        u32& seen = rtclobber_budget[image.info.guest_address];
        if (++seen <= 4 || (seen & 255u) == 0) {
            u32 g[6]{};
            std::memcpy(g, std::bit_cast<const void*>(image.info.guest_address),
                        std::min<u64>(sizeof(g), image.info.guest_size));
            LOG_WARNING(Render_Vulkan,
                        "[rtclobber] {} {:#x}+{:#x} ({}x{}x{} {} rt {:d} depth {:d}) {} #{} "
                        "guest dw: {:08x} {:08x} {:08x} {:08x} {:08x} {:08x}",
                        rt_noclobber >= 2 ? "BLOCKED" : "would clobber", image.info.guest_address,
                        image.info.guest_size, image.info.size.width, image.info.size.height,
                        image.info.size.depth, vk::to_string(image.info.pixel_format),
                        u32(image.usage.render_target), u32(image.usage.depth_target),
                        True(image.flags & ImageFlagBits::GpuDirty) ? "GPU-dirty" : "CPU-dirty",
                        seen, g[0], g[1], g[2], g[3], g[4], g[5]);
        }
        if (rt_noclobber >= 2) {
            // Consume the dirt - Image::Upload is what normally clears it, and it is not running.
            image.flags &= ~ImageFlagBits::Dirty;
            return;
        }
    }

    // GT7 (Act 11): GT_LUT_IDENT=1 seeds every 64x64x64 RGBA16F volume with an IDENTITY
    // grading LUT instead of uploading guest RAM. Measured (RenderDoc run 158 + three captures
    // of one PAUSED frame): the output transform fs_0xae20a0bc lerps every pixel toward
    // LUT[coord] with a per-frame weight, and the LUT is uninitialized-VRAM garbage (R=1
    // everywhere) because whatever should bake it never writes - that is the white-washed
    // screen, the pulsing of a paused frame (identical texture inputs, output min 0.005 ->
    // 0.054 -> 0.42 across three captures of the same scene = the weight animates), and the
    // solid-red track map (same shader signature, same LUT). An identity LUT makes the blend a
    // no-op whatever the weight does. One-shot per image, and never while GpuDirty (real
    // GPU-written bytes in the buffer cache must win); a later CPU write re-dirties the pages
    // and the normal path below uploads the real data - identity cannot overwrite content.
    static const bool lut_ident = [] {
        const char* v = std::getenv("GT_LUT_IDENT");
        return v && v[0] == '1';
    }();
    if (lut_ident && image.info.props.is_volume && image.info.size.width == 64 &&
        image.info.size.height == 64 && image.info.size.depth == 64 &&
        image.info.pixel_format == vk::Format::eR16G16B16A16Sfloat) {
        // ⚠ A FRESH image starts with flags = Dirty, and Dirty INCLUDES GpuDirty (image.h) -
        // that bit alone does NOT mean the buffer cache holds real GPU content. Genuine GPU
        // propagation (InvalidateMemoryFromGPU) sets GpuDirty ALONE; creation and CPU writes
        // set the Cpu bits too. Run 161 shipped with a bare GpuDirty guard and the seed never
        // fired once - silently. Hence the gpu_only test AND the skip logging below.
        const bool gpu_only =
            True(image.flags & ImageFlagBits::GpuDirty) &&
            False(image.flags & (ImageFlagBits::CpuDirty | ImageFlagBits::MaybeCpuDirty));
        if (image.lut_ident_seeded || gpu_only) {
            if (!image.lut_ident_seeded) {
                LOG_WARNING(Render_Vulkan,
                            "[lutident] NOT seeding {:#x}: GPU content pending in the buffer "
                            "cache - the normal path propagates it",
                            image.info.guest_address);
            }
        } else {
            image.lut_ident_seeded = true;
            const u32 num_mips = image.info.resources.levels;
            // All mips (a T# may declare a chain): sum of (64>>m)^3 texels, 8 bytes each.
            u64 lut_bytes = 0;
            for (u32 m = 0; m < num_mips; ++m) {
                const u64 d = std::max<u32>(64u >> m, 1u);
                lut_bytes += d * d * d * 4 * sizeof(u16);
            }
            // Image::Upload's source barrier spans [offset, offset + guest_size) - map at
            // least that much so a padded (tiled) guest_size cannot push the barrier past
            // the end of the upload buffer.
            const u64 map_bytes = std::max<u64>(lut_bytes, image.info.guest_size);
            scheduler.EndRendering();
            auto& upload_buffer = buffer_cache.GetUtilityBuffer(MemoryUsage::Upload);
            const auto [staging, offset] = upload_buffer.Map(map_bytes, 16);
            // f32 -> f16 with a truncated mantissa - exact enough for the axis values.
            const auto to_half = [](f32 value) -> u16 {
                const u32 f = std::bit_cast<u32>(value);
                const s32 exp = s32((f >> 23) & 0xff) - 127 + 15;
                if (exp <= 0) {
                    return 0;
                }
                return u16(((f >> 16) & 0x8000) | (u32(exp) << 10) | ((f & 0x7fffff) >> 13));
            };
            constexpr u16 one_half = 0x3C00;
            boost::container::small_vector<vk::BufferImageCopy, 8> identity_copies;
            u16* px = reinterpret_cast<u16*>(staging);
            u64 mip_offset = 0;
            for (u32 m = 0; m < num_mips; ++m) {
                const u32 dim = std::max<u32>(64u >> m, 1u);
                u16 axis[64];
                for (u32 i = 0; i < dim; ++i) {
                    axis[i] = dim > 1 ? to_half(f32(i) / f32(dim - 1)) : to_half(0.5f);
                }
                for (u32 z = 0; z < dim; ++z) {
                    for (u32 y = 0; y < dim; ++y) {
                        for (u32 x = 0; x < dim; ++x) {
                            *px++ = axis[x];
                            *px++ = axis[y];
                            *px++ = axis[z];
                            *px++ = one_half;
                        }
                    }
                }
                identity_copies.push_back({
                    .bufferOffset = offset + mip_offset,
                    .bufferRowLength = 0,
                    .bufferImageHeight = 0,
                    .imageSubresource{
                        .aspectMask = vk::ImageAspectFlagBits::eColor,
                        .mipLevel = m,
                        .baseArrayLayer = 0,
                        .layerCount = 1,
                    },
                    .imageOffset = {0, 0, 0},
                    .imageExtent = {dim, dim, dim},
                });
                mip_offset += u64(dim) * dim * dim * 4 * sizeof(u16);
            }
            upload_buffer.Commit();
            image.Upload(identity_copies, upload_buffer.Handle(), offset);
            // The seed is GPU-side content standing in for a bake: mark it GpuModified and
            // record the CURRENT guest bytes as the baseline, so a later CPU page
            // invalidation with unchanged guest bytes skips the re-upload instead of
            // clobbering the identity with uninitialized RAM (the exact mechanism that was
            // eating the real bake - see the hash-baseline note in the upload loop below).
            image.flags |= ImageFlagBits::GpuModified;
            const u8* guest_bytes = std::bit_cast<u8*>(image.info.guest_address);
            for (u32 m = 0; m < num_mips; ++m) {
                const auto& [mip_size, mip_pitch, mip_height, mip_offset] =
                    image.info.mips_layout[m];
                image.mip_hashes[m] = XXH3_64bits(guest_bytes + mip_offset, mip_size);
            }
            image.hash_baseline_done = true;
            LOG_WARNING(Render_Vulkan,
                        "[lutident] seeded identity 64^3 RGBA16F LUT at {:#x} ({} mip(s), "
                        "guest_size {:#x})",
                        image.info.guest_address, num_mips, image.info.guest_size);
            return;
        }
    }

    RENDERER_TRACE;
    TRACE_HINT(fmt::format("{:x}:{:x}", image.info.guest_address, image.info.guest_size));

    if (True(image.flags & ImageFlagBits::MaybeCpuDirty) &&
        False(image.flags & ImageFlagBits::CpuDirty)) {
        // The image size should be less than page size to be considered MaybeCpuDirty
        // So this calculation should be very uncommon and reasonably fast
        // For now we'll just check up to 64 first pixels
        const auto addr = std::bit_cast<u8*>(image.info.guest_address);
        const u32 w = std::min(image.info.size.width, u32(8));
        const u32 h = std::min(image.info.size.height, u32(8));

        const u32 s_w = image.info.props.is_block ? Common::DivCeil(w, 4u) : w;
        const u32 s_h = image.info.props.is_block ? Common::DivCeil(h, 4u) : h;
        const u32 size = s_w * s_h * (image.info.num_bits / 8);
        const u64 hash = XXH3_64bits(addr, size);
        if (image.hash == hash) {
            image.flags &= ~ImageFlagBits::MaybeCpuDirty;
            return;
        }
        image.hash = hash;
    }

    const u32 num_layers = image.info.resources.layers;
    const u32 num_mips = image.info.resources.levels;
    const bool is_gpu_modified = True(image.flags & ImageFlagBits::GpuModified);
    const bool is_gpu_dirty = True(image.flags & ImageFlagBits::GpuDirty);

    // ⚠⚠ THE COST OF THE BASELINE LIVES IN THE HASH, NOT THE RECORD. The first version of
    // the reupload-clobber fix hashed on EVERY GpuDirty refresh - and GT7's init
    // invalidates GPU targets in a storm, so the GPU thread spent its life inside XXH3
    // (live thread snapshots, runs 168-173: rip = XXH3_accumulate_512_avx2 <- RefreshImage,
    // stable across seconds), the game polled for completions that never came, and boot
    // never finished. The GT_HASH_BASELINE A/B was blind to it: it gated only the RECORD.
    // So the baseline is established ONCE per image - the first upload, exactly where the
    // clobber fix needs it and the only moment the old code had none; after that, GpuDirty
    // refreshes pay upstream's zero cost. A later real guest change is still caught by the
    // !is_gpu_dirty compare (which uploads and re-records - upstream's own semantics).
    const bool hash_baseline_had = image.hash_baseline_done;
    if (is_gpu_modified) {
        image.hash_baseline_done = true;
    }

    // GT7 [aewatch]: historical guest-upload probe for any GT_WATCH_VA range. Capture 4 later
    // proved the final transform bypasses the 64^3 LUT and that the large HDR corruption is
    // already produced by the foliage draw fs_92126594, so this remains diagnostics only.
    if (image.info.guest_size >= 32 && GtWatchHit(image.info.guest_address, image.info.guest_size)) {
        // Budget PER RANGE - the pyramid range floods a shared budget and starves the two
        // exposure addresses (run 189: 512 lines, none of them late-run exposure samples).
        static std::unordered_map<u64, u32> aewatch_budget;
        if (aewatch_budget[image.info.guest_address & ~0xFFFFULL]++ < 256) {
            const u32* g = std::bit_cast<const u32*>(image.info.guest_address);
            LOG_WARNING(Render_Vulkan,
                        "[aewatch] upload {:#x}+{:#x} ({}x{}x{} {}) {} dw: {:08x} {:08x} {:08x} "
                        "{:08x} {:08x} {:08x} {:08x} {:08x}",
                        image.info.guest_address, image.info.guest_size, image.info.size.width,
                        image.info.size.height, image.info.size.depth,
                        vk::to_string(image.info.pixel_format),
                        is_gpu_dirty ? "GPU-dirty" : "CPU-dirty", g[0], g[1], g[2], g[3], g[4],
                        g[5], g[6], g[7]);
        }
    }

    boost::container::small_vector<vk::BufferImageCopy, 14> image_copies;
    for (u32 m = 0; m < num_mips; m++) {
        const u32 width = std::max(image.info.size.width >> m, 1u);
        const u32 height = std::max(image.info.size.height >> m, 1u);
        const u32 depth =
            image.info.props.is_volume ? std::max(image.info.size.depth >> m, 1u) : 1u;
        const auto [mip_size, mip_pitch, mip_height, mip_offset] = image.info.mips_layout[m];

        // Protect GPU modified resources from accidental CPU reuploads.
        // ⚠ The hash must be RECORDED on every guest upload, including the is_gpu_dirty one -
        // a fresh image's very first refresh runs with GpuDirty set (creation flags = Dirty,
        // which includes it), so the old code never recorded a baseline. The first CPU page
        // invalidation after a GPU bake then compared against 0, read "guest changed", and
        // re-uploaded UNINITIALIZED guest RAM over the baked content. Measured on GT7's 64^3
        // grading LUT (Act 11): baked curve present right after the bake, the old garbage
        // again minutes later, re-baked and re-clobbered in a loop - the pulsing white wash
        // and the solid-red track map. With the baseline recorded, an UNCHANGED guest range
        // skips the re-upload and the GPU bake survives; a real CPU write still lands.
        if (is_gpu_modified) {
            // GT_HASH_BASELINE=0 restores the upstream rule (record only when !is_gpu_dirty),
            // so the fix can be A/B-ed at runtime with a warm pipeline cache. Runs 166/167
            // stalled at GT7's init phase and this commit is the only binary delta against
            // the last boot that reached the menu - the flag separates "the fix did it"
            // from "the init phase was already flaky" without another rebuild.
            static const bool record_on_gpu_dirty = [] {
                const char* v = std::getenv("GT_HASH_BASELINE");
                return !(v && v[0] == '0');
            }();
            // ⚠⚠ SECOND LESSON (run 174, same live-snapshot instrument): "once per image"
            // is NOT a bound when images churn. GT7's init streams thousands of textures,
            // every detiled one is GpuModified, and each fresh Image object paid its
            // "first" hash - the GPU thread went right back to living inside XXH3 and the
            // game sat at its INITIALIZING screen for 10+ minutes. The wash fix only ever
            // needed the 64^3 grading LUTs, so the GpuDirty baseline is now recorded for
            // EXACTLY that shape (the seed's own predicate) and nothing else; every other
            // image keeps pure upstream semantics on GpuDirty refreshes - the behavior
            // every pre-fix boot survived on.
            const bool lut_shaped = image.info.props.is_volume &&
                                    image.info.size.width == 64 &&
                                    image.info.size.height == 64 &&
                                    image.info.size.depth == 64 &&
                                    image.info.pixel_format == vk::Format::eR16G16B16A16Sfloat;
            constexpr u64 baseline_cap_bytes = 64_MB;
            // ⚠⚠ THE GPU-DIRTY REUPLOAD IS THE OTHER CLOBBER DOOR (run 181 + the imgsync
            // run, both measured in RenderDoc): the grading LUT is baked ONCE at load time
            // by an image write ([lut3d] WRITE bind), and its guest pages sit in the busy
            // 0x101e3xxxxx heap right above the ACB rings - so buffer-cache GPU writes to
            // NEIGHBORING data keep re-flagging the LUT pages GpuDirty, and the refresh then
            // "propagated" a stale guest copy (uninitialized VRAM) over the baked content.
            // No [hashbase] line ever fired for these clobbers - the skip/record pair below
            // only covered !is_gpu_dirty. So the LUT shape ALWAYS hashes: on a GpuDirty
            // refresh with UNCHANGED guest bytes the propagation is collateral and is
            // skipped; genuinely new guest bytes still land. Everything non-LUT keeps the
            // churn-fix semantics (never hash on GpuDirty) - that jail was the init stall.
            const bool skip_hash =
                (is_gpu_dirty && !lut_shaped) || mip_size > baseline_cap_bytes;
            const u8* addr = std::bit_cast<u8*>(image.info.guest_address);
            const u64 hash = skip_hash ? 0 : XXH3_64bits(addr + mip_offset, mip_size);
            if (!skip_hash && (!is_gpu_dirty || (lut_shaped && hash_baseline_had)) &&
                image.mip_hashes[m] == hash) {
                // Focused verification for the GT7 grading-LUT clobber fix. This is the
                // exact branch that used to be unreachable after the first GPU bake because
                // the initial GpuDirty upload never established a guest-memory baseline.
                if (image.info.props.is_volume && image.info.size.width == 64 &&
                    image.info.size.height == 64 && image.info.size.depth == 64 &&
                    image.info.pixel_format == vk::Format::eR16G16B16A16Sfloat) {
                    static u32 unchanged_lut_budget = 0;
                    if (unchanged_lut_budget++ < 16) {
                        LOG_WARNING(Render_Vulkan,
                                    "[hashbase] skipped unchanged {} reupload of 64^3 LUT "
                                    "at {:#x}, mip {} (guest hash {:#x})",
                                    is_gpu_dirty ? "GPU-dirty" : "CPU", image.info.guest_address,
                                    m, hash);
                    }
                }
                continue;
            }
            if (!skip_hash && (!is_gpu_dirty || record_on_gpu_dirty)) {
                if (record_on_gpu_dirty && is_gpu_dirty && image.info.props.is_volume &&
                    image.info.size.width == 64 && image.info.size.height == 64 &&
                    image.info.size.depth == 64 &&
                    image.info.pixel_format == vk::Format::eR16G16B16A16Sfloat) {
                    static u32 initial_lut_budget = 0;
                    if (initial_lut_budget++ < 8) {
                        LOG_WARNING(Render_Vulkan,
                                    "[hashbase] recorded initial guest baseline for 64^3 LUT "
                                    "at {:#x}, mip {} (guest hash {:#x})",
                                    image.info.guest_address, m, hash);
                    }
                }
                image.mip_hashes[m] = hash;
            }
        }

        const u32 extent_width = mip_pitch ? std::min(mip_pitch, width) : width;
        const u32 extent_height = mip_height ? std::min(mip_height, height) : height;
        image_copies.push_back({
            .bufferOffset = mip_offset,
            .bufferRowLength = mip_pitch,
            .bufferImageHeight = mip_height,
            .imageSubresource{
                .aspectMask = image.aspect_mask & ~vk::ImageAspectFlagBits::eStencil,
                .mipLevel = m,
                .baseArrayLayer = 0,
                .layerCount = num_layers,
            },
            .imageOffset = {0, 0, 0},
            .imageExtent = {extent_width, extent_height, depth},
        });
    }

    if (image_copies.empty()) {
        image.flags &= ~ImageFlagBits::Dirty;
        return;
    }

    scheduler.EndRendering();

    const auto [in_buffer, in_offset] =
        buffer_cache.ObtainBufferForImage(image.info.guest_address, image.info.guest_size);
    if (auto barrier = in_buffer->GetBarrier(vk::AccessFlagBits2::eTransferRead,
                                             vk::PipelineStageFlagBits2::eTransfer)) {
        scheduler.CommandBuffer().pipelineBarrier2(vk::DependencyInfo{
            .dependencyFlags = vk::DependencyFlagBits::eByRegion,
            .bufferMemoryBarrierCount = 1,
            .pBufferMemoryBarriers = &barrier.value(),
        });
    }

    const auto [buffer, offset] =
        tile_manager.DetileImage(in_buffer->Handle(), in_offset, image.info);
    for (auto& copy : image_copies) {
        copy.bufferOffset += offset;
    }

    image.Upload(image_copies, buffer, offset);
}

vk::Sampler TextureCache::GetSampler(const AmdGpu::Sampler& sampler,
                                     AmdGpu::BorderColorBuffer border_color_base) {
    const u64 hash = XXH3_64bits(&sampler, sizeof(sampler));

    std::scoped_lock lock{samplers_mutex};
    const auto [it, new_sampler] = samplers.try_emplace(hash, instance, sampler, border_color_base);
    if (new_sampler) {
        samplers.at(hash).lru_id = sampler_lru_cache.Insert(hash, gc_tick);
    } else {
        sampler_lru_cache.Touch(it->second.lru_id, gc_tick);
    }

    return it->second.Handle();
}

void TextureCache::RegisterImage(ImageId image_id) {
    Image& image = slot_images[image_id];
    ASSERT_MSG(False(image.flags & ImageFlagBits::Registered),
               "Trying to register an already registered image");
    image.flags |= ImageFlagBits::Registered;
    total_used_memory += Common::AlignUp(image.info.guest_size, 1024);
    live_image_bytes += Common::AlignUp(image.info.guest_size, 1024);
    ++live_image_count;
    image.lru_id = lru_cache.Insert(image_id, gc_tick);
    ForEachPage(image.info.guest_address, image.info.guest_size,
                [this, image_id](u64 page) { page_table[page].push_back(image_id); });
}

void TextureCache::UnregisterImage(ImageId image_id) {
    Image& image = slot_images[image_id];
    ASSERT_MSG(True(image.flags & ImageFlagBits::Registered),
               "Trying to unregister an already unregistered image");
    image.flags &= ~ImageFlagBits::Registered;
    lru_cache.Free(image.lru_id);
    total_used_memory -= Common::AlignUp(image.info.guest_size, 1024);
    live_image_bytes -= Common::AlignUp(image.info.guest_size, 1024);
    --live_image_count;
    ForEachPage(image.info.guest_address, image.info.guest_size, [this, image_id](u64 page) {
        const auto page_it = page_table.find(page);
        if (page_it == nullptr) {
            UNREACHABLE_MSG("Unregistering unregistered page=0x{:x}", page << PageShift);
            return;
        }
        auto& image_ids = *page_it;
        const auto vector_it = std::ranges::find(image_ids, image_id);
        if (vector_it == image_ids.end()) {
            ASSERT_MSG(false, "Unregistering unregistered image in page=0x{:x}", page << PageShift);
            return;
        }
        image_ids.erase(vector_it);
    });
}

void TextureCache::TrackImage(ImageId image_id) {
    auto& image = slot_images[image_id];
    if (!(image.flags & ImageFlagBits::Registered)) {
        return;
    }
    const auto image_begin = image.info.guest_address;
    const auto image_end = image.info.guest_address + image.info.guest_size;
    if (image_begin == image.track_addr && image_end == image.track_addr_end) {
        return;
    }

    if (!image.IsTracked()) {
        // Re-track the whole image
        image.track_addr = image_begin;
        image.track_addr_end = image_end;
        tracker.UpdatePageWatchers<1>(image_begin, image.info.guest_size);
    } else {
        if (image_begin < image.track_addr) {
            TrackImageHead(image_id);
        }
        if (image.track_addr_end < image_end) {
            TrackImageTail(image_id);
        }
    }
}

void TextureCache::TrackImageHead(ImageId image_id) {
    auto& image = slot_images[image_id];
    if (!(image.flags & ImageFlagBits::Registered)) {
        return;
    }
    const auto image_begin = image.info.guest_address;
    if (image_begin == image.track_addr) {
        return;
    }
    ASSERT(image.track_addr != 0 && image_begin < image.track_addr);
    const auto size = image.track_addr - image_begin;
    image.track_addr = image_begin;
    tracker.UpdatePageWatchers<1>(image_begin, size);
}

void TextureCache::TrackImageTail(ImageId image_id) {
    auto& image = slot_images[image_id];
    if (!(image.flags & ImageFlagBits::Registered)) {
        return;
    }
    const auto image_end = image.info.guest_address + image.info.guest_size;
    if (image_end == image.track_addr_end) {
        return;
    }
    ASSERT(image.track_addr_end != 0 && image.track_addr_end < image_end);
    const auto addr = image.track_addr_end;
    const auto size = image_end - image.track_addr_end;
    image.track_addr_end = image_end;
    tracker.UpdatePageWatchers<1>(addr, size);
}

void TextureCache::UntrackImage(ImageId image_id) {
    auto& image = slot_images[image_id];
    if (!image.IsTracked()) {
        return;
    }
    const auto addr = image.track_addr;
    const auto size = image.track_addr_end - image.track_addr;
    image.track_addr = 0;
    image.track_addr_end = 0;
    if (size != 0) {
        tracker.UpdatePageWatchers<false>(addr, size);
    }
}

void TextureCache::UntrackImageHead(ImageId image_id) {
    auto& image = slot_images[image_id];
    const auto image_begin = image.info.guest_address;
    if (!image.IsTracked() || image_begin < image.track_addr) {
        return;
    }
    const auto addr = tracker.GetNextPageAddr(image_begin);
    const auto size = addr - image_begin;
    image.track_addr = addr;
    if (image.track_addr == image.track_addr_end) {
        // This image spans only 2 pages and both are modified,
        // but the image itself was not directly affected.
        // Cehck its hash later.
        MarkAsMaybeDirty(image_id, image);
    }
    tracker.UpdatePageWatchers<false>(image_begin, size);
}

void TextureCache::UntrackImageTail(ImageId image_id) {
    auto& image = slot_images[image_id];
    const auto image_end = image.info.guest_address + image.info.guest_size;
    if (!image.IsTracked() || image.track_addr_end < image_end) {
        return;
    }
    ASSERT(image.track_addr_end != 0);
    const auto addr = tracker.GetPageAddr(image_end);
    const auto size = image_end - addr;
    image.track_addr_end = addr;
    if (image.track_addr == image.track_addr_end) {
        // This image spans only 2 pages and both are modified,
        // but the image itself was not directly affected.
        // Cehck its hash later.
        MarkAsMaybeDirty(image_id, image);
    }
    tracker.UpdatePageWatchers<false>(addr, size);
}

void TextureCache::GarbageCollectImages() {
    if (instance.CanReportMemoryUsage()) {
        total_used_memory = instance.GetDeviceMemoryUsage();
    }
    if (total_used_memory < trigger_gc_memory) {
        return;
    }
    std::scoped_lock lock{mutex};
    bool pressured = false;
    bool aggresive = false;
    u64 ticks_to_destroy = 0;
    size_t num_deletions = 0;

    // The buffer GC's memory-pressure lesson applies here too (runs 60/61: DEVICE LOST at
    // 9-11 GB of a 12 GB card): under GT_BUFFER_GC's pressure mode the aggressive pass frees
    // MORE and YOUNGER images, because the driver dies of oversubscription before any of our
    // own allocations would fail.
    // Follows the buffer GC's NEW default-on semantics (unset = on, '0' = off) - the old
    // presence check would have INVERTED once GT_BUFFER_GC stopped being set explicitly.
    static const bool pressure_mode = [] {
        const char* v = std::getenv("GT_BUFFER_GC");
        return !(v && v[0] == '0');
    }();
    const auto configure = [&](bool allow_aggressive) {
        pressured = total_used_memory >= pressure_gc_memory;
        aggresive = allow_aggressive && total_used_memory >= critical_gc_memory;
        ticks_to_destroy = aggresive ? (pressure_mode ? 16 : 160) : pressured ? 80 : 16;
        ticks_to_destroy = std::min(ticks_to_destroy, gc_tick);
        num_deletions = aggresive ? (pressure_mode ? 1024 : 40) : pressured ? 20 : 10;
    };
    // Instrumented for run 118's OOM (device 22 GB, VMA 22 GB in 10.7k allocs, buffer GC
    // freeing ~0): this GC was completely silent, so the log could not say whether images
    // were the growth or the bystander. Two things the counters must expose: (1) a
    // GpuModified TILED image is skipped FOREVER (no non-linear download path) - a large
    // skipped_tiled figure under pressure IS a leak signature; (2) a skip still consumes
    // one unit of num_deletions, so a run of skips at the old end of the LRU can eat the
    // whole budget and free nothing.
    u32 freed_count = 0;
    u64 freed_bytes = 0;
    u32 skipped_tiled_dl = 0;
    u32 skipped_dl_unpressured = 0;
    const auto clean_up = [&](ImageId image_id) {
        if (num_deletions == 0) {
            return true;
        }
        --num_deletions;
        auto& image = slot_images[image_id];
        const bool download = image.SafeToDownload();
        const bool tiled = image.info.IsTiled();
        if (tiled && download) {
            // This is a workaround for now. We can't handle non-linear image downloads.
            ++skipped_tiled_dl;
            return false;
        }
        if (download && !pressured) {
            ++skipped_dl_unpressured;
            return false;
        }
        if (download) {
            DownloadImageMemory(image_id);
        }
        const u64 image_bytes = Common::AlignUp(image.info.guest_size, 1024);
        FreeImage(image_id);
        ++freed_count;
        freed_bytes += image_bytes;
        if (total_used_memory < critical_gc_memory) {
            if (aggresive) {
                num_deletions >>= 2;
                aggresive = false;
                return false;
            }
            if (pressured && total_used_memory < pressure_gc_memory) {
                num_deletions >>= 1;
                pressured = false;
            }
        }
        return false;
    };

    // Try to remove anything old enough and not high priority.
    configure(false);
    lru_cache.ForEachItemBelow(gc_tick - ticks_to_destroy, clean_up);

    if (total_used_memory >= critical_gc_memory) {
        // If we are still over the critical limit, run an aggressive GC
        configure(true);
        lru_cache.ForEachItemBelow(gc_tick - ticks_to_destroy, clean_up);
    }

    // Budgeted like [buffergc]: loud whenever something was freed, and a heartbeat every
    // 128th over-trigger pass so total silence cannot hide a GC that frees nothing.
    static u32 texgc_quiet = 0;
    if (freed_count > 0 || (++texgc_quiet & 127) == 0) {
        LOG_WARNING(Render_Vulkan,
                    "[texgc] freed {} image(s) / {} MB, skipped {} tiled+gpu (unfreeable), {} "
                    "gpu-unpressured; live {} images / {} MB, device {} MB",
                    freed_count, freed_bytes >> 20, skipped_tiled_dl, skipped_dl_unpressured,
                    live_image_count, live_image_bytes >> 20, total_used_memory >> 20);
    }
}

void TextureCache::GarbageCollectSamplers() {
    total_used_samplers = samplers.size();
    if (total_used_samplers < trigger_gc_samplers) {
        return;
    }
    std::scoped_lock lock{samplers_mutex};
    bool pressured = false;
    bool aggresive = false;
    u64 ticks_to_destroy = 0;
    size_t num_deletions = 0;

    const auto configure = [&](bool allow_aggressive) {
        pressured = total_used_samplers >= pressure_gc_samplers;
        aggresive = allow_aggressive && total_used_samplers >= critical_gc_samplers;
        ticks_to_destroy = aggresive ? 160 : pressured ? 80 : 16;
        ticks_to_destroy = std::min(ticks_to_destroy, gc_tick);
        num_deletions = aggresive ? 40 : pressured ? 20 : 10;
    };
    const auto clean_up = [&](u64 hash) {
        if (num_deletions == 0) {
            return true;
        }
        --num_deletions;
        const size_t lru_id = samplers.at(hash).lru_id;
        samplers.erase(hash);
        sampler_lru_cache.Free(lru_id);
        return false;
    };

    // Try to remove anything old enough and not high priority.
    configure(false);
    sampler_lru_cache.ForEachItemBelow(gc_tick - ticks_to_destroy, clean_up);

    if (total_used_samplers >= critical_gc_samplers) {
        // If we are still over the critical limit, run an aggressive GC
        configure(true);
        sampler_lru_cache.ForEachItemBelow(gc_tick - ticks_to_destroy, clean_up);
    }
}

void TextureCache::RunGarbageCollector() {
    SCOPE_EXIT {
        ++gc_tick;
    };
    // GT_TEX_GC=0: A/B switch for the deterministic "ReadInvalid 0x300100000 in no live
    // buffer" device fault (runs 95/96/100). It predates the buffer GC (which was off in
    // 95/96), it is a read of GPU memory NOTHING in the buffer registry owns, and the
    // texture cache is the one upstream system that has ALWAYS deleted resources - gated,
    // like the buffer path used to be, on the DRAW tick alone while present/flip command
    // buffers may still reference the image. If a run with this off loses the fault, image
    // deletion needs the same all-timelines gate the buffers just got.
    static const bool tex_gc_enabled = [] {
        const char* v = std::getenv("GT_TEX_GC");
        return !(v && v[0] == '0');
    }();
    if (!tex_gc_enabled) {
        return;
    }

    GarbageCollectImages();
    GarbageCollectSamplers();
}

void TextureCache::TouchImage(const Image& image) {
    lru_cache.Touch(image.lru_id, gc_tick);
}

void TextureCache::DeleteImage(ImageId image_id) {
    Image& image = slot_images[image_id];
    ASSERT_MSG(!image.IsTracked(), "Image was not untracked");
    ASSERT_MSG(False(image.flags & ImageFlagBits::Registered), "Image was not unregistered");

    // Remove any registered meta areas.
    const auto& meta_info = image.info.meta_info;
    if (meta_info.cmask_addr) {
        surface_metas.erase(meta_info.cmask_addr);
    }
    if (meta_info.fmask_addr) {
        surface_metas.erase(meta_info.fmask_addr);
    }
    if (meta_info.htile_addr) {
        surface_metas.erase(meta_info.htile_addr);
    }

    {
        std::unique_lock lk{download_images_mutex};
        if (download_images.contains(image_id)) {
            download_images.erase(image_id);
        }
    }

    // Reclaim image and any image views it references.
    scheduler.DeferOperation([this, image_id] {
        Image& image = slot_images[image_id];
        for (auto& backing : image.backing_images) {
            for (const ImageViewId image_view_id : backing.image_view_ids) {
                slot_image_views.erase(image_view_id);
            }
        }
        slot_images.erase(image_id);
    });
}

} // namespace VideoCore
