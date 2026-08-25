// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#include "common/recursive_lock.h"
#include "common/shared_first_mutex.h"
#include "video_core/buffer_cache/buffer_cache.h"
#include "video_core/page_manager.h"
#include "video_core/renderer_vulkan/vk_pipeline_cache.h"
#include "video_core/texture_cache/texture_cache.h"

namespace AmdGpu {
struct Liverpool;
}

namespace Core {
class MemoryManager;
}

namespace Vulkan {

class Scheduler;
class RenderState;
class GraphicsPipeline;
struct GpuWorkPayload;

class Rasterizer {
public:
    explicit Rasterizer(const Instance& instance, Scheduler& scheduler,
                        AmdGpu::Liverpool* liverpool);
    ~Rasterizer();

    [[nodiscard]] Scheduler& GetScheduler() noexcept {
        return scheduler;
    }

    /// True when the open command buffer holds recorded-but-unsubmitted GPU work. An
    /// end-of-pipe fence parsed while this is FALSE orders against nothing and is signed
    /// eagerly by the GT_DEFER_EOP paths (deferral there bought nothing and raced GT7's
    /// boot handshake - the FWRKR null-read). Defined in the .cpp: Instance is only
    /// forward-declared here.
    [[nodiscard]] bool HasPendingGpuWork() const noexcept;

    [[nodiscard]] VideoCore::BufferCache& GetBufferCache() noexcept {
        return buffer_cache;
    }

    [[nodiscard]] VideoCore::TextureCache& GetTextureCache() noexcept {
        return texture_cache;
    }

    void Draw(bool is_indexed, u32 index_offset = 0);
    void DrawIndirect(bool is_indexed, VAddr arg_address, u32 offset, u32 size, u32 max_count,
                      VAddr count_address);

    void DispatchDirect();
    void DispatchIndirect(VAddr address, u32 offset, u32 size);

    void ScopeMarkerBegin(const std::string_view& str, bool from_guest = false);
    void ScopeMarkerEnd(bool from_guest = false);
    void ScopedMarkerInsert(const std::string_view& str, bool from_guest = false);
    void ScopedMarkerInsertColor(const std::string_view& str, const u32 color,
                                 bool from_guest = false);

    void FillBuffer(VAddr address, u32 num_bytes, u32 value, bool is_gds);
    void CopyBuffer(VAddr dst, VAddr src, u32 num_bytes, bool dst_gds, bool src_gds);
    u32 ReadDataFromGds(u32 gsd_offset);
    bool InvalidateMemory(VAddr addr, u64 size);
    bool ReadMemory(VAddr addr, u64 size);
    void ProcessDownloadImages();
    bool IsMapped(VAddr addr, u64 size);
    void MapMemory(VAddr addr, u64 size);
    void UnmapMemory(VAddr addr, u64 size);

    void CpSync();
    u64 Flush();
    void Finish();
    void OnSubmit();

    PipelineCache& GetPipelineCache() {
        return pipeline_cache;
    }

    template <typename Func>
    void ForEachMappedRangeInRange(VAddr addr, u64 size, Func&& func) {
        const auto range = decltype(mapped_ranges)::interval_type::right_open(addr, addr + size);
        Common::RecursiveSharedLock lock{mapped_ranges_mutex};
        for (const auto& mapped_range : (mapped_ranges & range)) {
            func(mapped_range);
        }
    }

private:
    void PrepareRenderState(const GraphicsPipeline* pipeline);
    RenderState BeginRendering(const GraphicsPipeline* pipeline);
    void Resolve();
    void DepthStencilCopy(bool is_depth, bool is_stencil);
    void EliminateFastClear();

    void UpdateDynamicState(const GraphicsPipeline* pipeline, bool is_indexed) const;
    void UpdateViewportScissorState() const;
    void UpdateDepthStencilState() const;
    void UpdatePrimitiveState(bool is_indexed) const;
    void UpdateRasterizationState() const;
    void UpdateColorBlendingState(const GraphicsPipeline* pipeline) const;

    bool FilterDraw();

    /// Fills in which shaders a pipeline is about to run, for the GPU work journal.
    /// WALKS the stages instead of asking for one by name: Pipeline::GetStage dereferences without
    /// a check and a null stage is legal here (see the null-skip in BindResources), so asking a
    /// depth-only pipeline for its fragment stage is a null deref.
    void CollectShaderIdentity(const Pipeline* pipeline, GpuWorkPayload& out) const;

    /// Reads the guest's own indirect arguments - the only way to see how big an indirect dispatch
    /// really is, since the counts never pass through the host otherwise.
    /// Same technique AND same guard as BufferCache::FillBuffer: a guest VA is directly a host
    /// pointer, but that view is only current while the region is not GPU-modified.
    /// Returns false when nothing could be read. `gpu_modified` is set whenever a shader wrote the
    /// arguments, which makes the values STALE - that flag must reach the log.
    bool TryReadIndirectArgs(VAddr addr, u32 num_dwords, u32* out, bool* gpu_modified);

    /// Records the render area as an UPPER BOUND on fragment work, and folds it into the entry's
    /// overall size. A fullscreen pass is 3 vertices and millions of pixels, so without this the
    /// journal is blind to the heaviest thing a draw can do.
    void NoteDrawPixelWork(const RenderState& state, u64 vertex_invocations,
                           GpuWorkPayload& out) const;

    void BindBuffers(const Shader::Info& stage, Shader::Backend::Bindings& binding,
                     Shader::PushData& push_data);
    void BindTextures(const Shader::Info& stage, Shader::Backend::Bindings& binding);
    bool BindResources(const Pipeline* pipeline);

    /// GT_LUT_DUMP (Act 11 step 3): at a READ bind of a 64^3 RGBA16F volume, drain the GPU
    /// and print 8 diagonal texels - the identity seed ran ([lutident] logged for BOTH LUTs)
    /// and the screen did not change, so the open question is WHAT the transform actually
    /// samples: identity (then the shader's use of the LUT is not what we model - back to
    /// RenderDoc) or garbage (then the baker cs_0xf04a69f0 overwrites the seed with output
    /// computed from broken inputs - then stub/fix the baker). Budgeted, env-gated, costs a
    /// scheduler.Finish per dump - a diagnostic, never a shipping path.
    void MaybeDumpLut(VideoCore::Image& image);

    /// GT_IMGARRAY_SYNC (Act 11): the windowed T# tables are GPU-written by producers
    /// recorded EARLIER IN THIS SAME command buffer, so the record-time guest-RAM read in
    /// BindTextures can only ever see zeros (cached buffers are copies; GPU writes never
    /// reach guest RAM on their own). Mode 2: flush + wait + copy the ~2.3 KB table back
    /// into guest RAM so the UNCHANGED slot loop reads real T#s - the proof mode. Mode 1:
    /// async capture + inject on the next occurrence of the same table VA - the playable
    /// mode. Mode 3: mode-2 mechanics on READ windows too. Record-time only, so env flips
    /// are pipeline-cache-safe. Dims are the dispatch's group counts (0 for indirect) -
    /// the window is indexed by WorkgroupId.z, so dim_z bounds how many slots are real.
    void SyncWindowedImageTables(const Shader::Info& stage, u32 dim_x, u32 dim_y, u32 dim_z);

    void ResetBindings() {
        for (auto& image_id : bound_images) {
            texture_cache.GetImage(image_id).binding = {};
        }
        bound_images.clear();
    }

    bool IsComputeMetaClear(const Pipeline* pipeline);
    bool IsComputeImageCopy(const Pipeline* pipeline);
    bool IsComputeImageClear(const Pipeline* pipeline);

private:
    friend class VideoCore::BufferCache;

    const Instance& instance;
    Scheduler& scheduler;
    VideoCore::PageManager page_manager;
    VideoCore::BufferCache buffer_cache;
    VideoCore::TextureCache texture_cache;
    AmdGpu::Liverpool* liverpool;
    Core::MemoryManager* memory;
    boost::icl::interval_set<VAddr> mapped_ranges;
    Common::SharedFirstMutex mapped_ranges_mutex;
    PipelineCache pipeline_cache;

    using RenderTargetInfo = std::pair<VideoCore::ImageId, VideoCore::TextureCache::ImageDesc>;
    std::array<RenderTargetInfo, AmdGpu::NUM_COLOR_BUFFERS> cb_descs;
    std::pair<VideoCore::ImageId, VideoCore::TextureCache::ImageDesc> db_desc;
    boost::container::static_vector<vk::DescriptorImageInfo, Shader::NUM_IMAGES> image_infos;
    boost::container::static_vector<vk::DescriptorBufferInfo, Shader::NUM_BUFFERS> buffer_infos;
    boost::container::static_vector<VideoCore::ImageId, Shader::NUM_IMAGES> bound_images;

    u32 set_write_index{};
    Pipeline::DescriptorWrites set_writes;
    Pipeline::BufferBarriers buffer_barriers;
    Shader::PushData push_data;

    using BufferBindingInfo = std::tuple<VideoCore::BufferId, AmdGpu::Buffer, u64>;
    boost::container::static_vector<BufferBindingInfo, Shader::NUM_BUFFERS> buffer_bindings;
    using ImageBindingInfo = std::pair<VideoCore::ImageId, VideoCore::TextureCache::ImageDesc>;
    boost::container::static_vector<ImageBindingInfo, Shader::NUM_IMAGES> image_bindings;
    bool fault_process_pending{};
    bool attachment_feedback_loop{};
};

} // namespace Vulkan
