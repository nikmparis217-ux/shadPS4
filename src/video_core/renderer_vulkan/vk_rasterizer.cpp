// SPDX-FileCopyrightText: Copyright 2024-2026 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include <algorithm>
#include <bit>
#include <cstring>
#include <iterator>
#include <unordered_map>

#include "common/debug.h"
#include "core/debug_state.h"
#include "core/emulator_settings.h"
#include "core/memory.h"
#include "shader_recompiler/runtime_info.h"
#include "video_core/amdgpu/liverpool.h"
#include "video_core/renderer_vulkan/liverpool_to_vk.h"
#include "video_core/renderer_vulkan/vk_instance.h"
#include "video_core/renderer_vulkan/vk_rasterizer.h"
#include "video_core/renderer_vulkan/vk_scheduler.h"
#include "video_core/renderer_vulkan/vk_shader_hle.h"
#include "video_core/texture_cache/image_view.h"
#include "video_core/texture_cache/texture_cache.h"

#ifdef MemoryBarrier
#undef MemoryBarrier
#endif

namespace Vulkan {

static Shader::PushData MakeUserData(const AmdGpu::Regs& regs) {
    // TODO(roamic): Add support for multiple viewports and geometry shaders when ViewportIndex
    // is encountered and implemented in the recompiler.
    Shader::PushData push_data{};
    push_data.xoffset = regs.viewport_control.xoffset_enable ? regs.viewports[0].xoffset : 0.f;
    push_data.xscale = regs.viewport_control.xscale_enable ? regs.viewports[0].xscale : 1.f;
    push_data.yoffset = regs.viewport_control.yoffset_enable ? regs.viewports[0].yoffset : 0.f;
    push_data.yscale = regs.viewport_control.yscale_enable ? regs.viewports[0].yscale : 1.f;
    return push_data;
}

Rasterizer::Rasterizer(const Instance& instance_, Scheduler& scheduler_,
                       AmdGpu::Liverpool* liverpool_)
    : instance{instance_}, scheduler{scheduler_}, page_manager{this},
      buffer_cache{instance, scheduler, liverpool_, texture_cache, page_manager},
      texture_cache{instance, scheduler, liverpool_, buffer_cache, page_manager},
      liverpool{liverpool_}, memory{Core::Memory::Instance()},
      pipeline_cache{instance, scheduler, liverpool} {
    if (!EmulatorSettings.IsNullGPU()) {
        liverpool->BindRasterizer(this);
    }
    memory->SetRasterizer(this);
}

Rasterizer::~Rasterizer() = default;

bool Rasterizer::HasPendingGpuWork() const noexcept {
    return instance.PeekGpuWorkSeq() != instance.SubmittedUptoGpuWorkSeq();
}

void Rasterizer::CpSync() {
    scheduler.EndRendering();
    auto cmdbuf = scheduler.CommandBuffer();

    const vk::MemoryBarrier ib_barrier{
        .srcAccessMask = vk::AccessFlagBits::eShaderWrite,
        .dstAccessMask = vk::AccessFlagBits::eIndirectCommandRead,
    };
    cmdbuf.pipelineBarrier(vk::PipelineStageFlagBits::eComputeShader,
                           vk::PipelineStageFlagBits::eDrawIndirect,
                           vk::DependencyFlagBits::eByRegion, ib_barrier, {}, {});
}

bool Rasterizer::FilterDraw() {
    const auto& regs = liverpool->regs;
    if (regs.color_control.mode == AmdGpu::ColorControl::OperationMode::EliminateFastClear) {
        // Clears the render target if FCE is launched before any draws
        EliminateFastClear();
        return false;
    }
    if (regs.color_control.mode == AmdGpu::ColorControl::OperationMode::FmaskDecompress) {
        // TODO: check for a valid MRT1 to promote the draw to the resolve pass.
        LOG_TRACE(Render_Vulkan, "FMask decompression pass skipped");
        ScopedMarkerInsert("FmaskDecompress");
        return false;
    }
    if (regs.color_control.mode == AmdGpu::ColorControl::OperationMode::Resolve) {
        LOG_TRACE(Render_Vulkan, "Resolve pass");
        Resolve();
        return false;
    }
    if (regs.primitive_type == AmdGpu::PrimitiveType::None) {
        LOG_TRACE(Render_Vulkan, "Primitive type 'None' skipped");
        ScopedMarkerInsert("PrimitiveTypeNone");
        return false;
    }

    const bool cb_disabled =
        regs.color_control.mode == AmdGpu::ColorControl::OperationMode::Disable;
    const auto depth_copy =
        regs.depth_render_override.force_z_dirty && regs.depth_render_override.force_z_valid &&
        regs.depth_buffer.DepthValid() && regs.depth_buffer.DepthWriteValid() &&
        regs.depth_buffer.DepthAddress() != regs.depth_buffer.DepthWriteAddress();
    const auto stencil_copy =
        regs.depth_render_override.force_stencil_dirty &&
        regs.depth_render_override.force_stencil_valid && regs.depth_buffer.StencilValid() &&
        regs.depth_buffer.StencilWriteValid() &&
        regs.depth_buffer.StencilAddress() != regs.depth_buffer.StencilWriteAddress();
    if (cb_disabled && (depth_copy || stencil_copy)) {
        // Games may disable color buffer and enable force depth/stencil dirty and valid to
        // do a copy from one depth-stencil surface to another, without a pixel shader.
        // We need to detect this case and perform the copy, otherwise it will have no effect.
        LOG_TRACE(Render_Vulkan, "Performing depth-stencil override copy");
        DepthStencilCopy(depth_copy, stencil_copy);
        return false;
    }

    return true;
}

void Rasterizer::PrepareRenderState(const GraphicsPipeline* pipeline) {
    // Prefetch render targets to handle overlaps with bound textures (e.g. mipgen)
    const auto& key = pipeline->GetGraphicsKey();
    const auto& regs = liverpool->regs;
    if (regs.color_control.degamma_enable) {
        LOG_WARNING(Render_Vulkan, "Color buffers require gamma correction");
    }

    const bool skip_cb_binding =
        regs.color_control.mode == AmdGpu::ColorControl::OperationMode::Disable;
    for (s32 cb = 0; cb < std::bit_width(key.mrt_mask); ++cb) {
        auto& [image_id, desc] = cb_descs[cb];
        const auto& col_buf = regs.color_buffers[cb];
        const u32 target_mask = regs.color_target_mask.GetMask(cb);
        if (skip_cb_binding || !col_buf || !target_mask || (key.mrt_mask & (1 << cb)) == 0) {
            image_id = {};
            continue;
        }
        const auto& hint = liverpool->last_cb_extent[cb];
        std::construct_at(&desc, col_buf, hint);
        image_id = bound_images.emplace_back(texture_cache.FindImage(desc));
        auto& image = texture_cache.GetImage(image_id);
        image.binding.is_target = 1u;
    }

    if ((regs.depth_control.depth_enable && regs.depth_buffer.DepthValid()) ||
        (regs.depth_control.stencil_enable && regs.depth_buffer.StencilValid())) {
        const auto htile_address = regs.depth_htile_data_base.GetAddress();
        const auto& hint = liverpool->last_db_extent;
        auto& [image_id, desc] = db_desc;
        std::construct_at(&desc, regs.depth_buffer, regs.depth_view, regs.depth_control,
                          htile_address, hint);
        image_id = bound_images.emplace_back(texture_cache.FindImage(desc));
        auto& image = texture_cache.GetImage(image_id);
        image.binding.is_target = 1u;
    } else {
        db_desc.first = {};
    }
}

static std::pair<u32, u32> GetDrawOffsets(
    const AmdGpu::Regs& regs, const Shader::Info& info,
    const std::optional<Shader::Gcn::FetchShaderData>& fetch_shader) {
    u32 vertex_offset = regs.index_offset;
    u32 instance_offset = 0;
    if (fetch_shader) {
        if (vertex_offset == 0 && fetch_shader->vertex_offset_sgpr != -1) {
            vertex_offset = info.user_data[fetch_shader->vertex_offset_sgpr];
        }
        if (fetch_shader->instance_offset_sgpr != -1) {
            instance_offset = info.user_data[fetch_shader->instance_offset_sgpr];
        }
    }
    return {vertex_offset, instance_offset};
}

void Rasterizer::EliminateFastClear() {
    auto& col_buf = liverpool->regs.color_buffers[0];
    if (!col_buf || !col_buf.info.fast_clear) {
        return;
    }
    VideoCore::TextureCache::ImageDesc desc(col_buf, liverpool->last_cb_extent[0]);
    const auto image_id = texture_cache.FindImage(desc);
    const auto& image_view = texture_cache.FindRenderTarget(image_id, desc);
    if (!texture_cache.IsMetaCleared(col_buf.CmaskAddress(), col_buf.view.slice_start)) {
        return;
    }
    for (u32 slice = col_buf.view.slice_start; slice <= col_buf.view.slice_max; ++slice) {
        texture_cache.TouchMeta(col_buf.CmaskAddress(), slice, false);
    }
    auto& image = texture_cache.GetImage(image_id);
    const auto clear_value = LiverpoolToVK::ColorBufferClearValue(col_buf);

    ScopeMarkerBegin(fmt::format("EliminateFastClear:MRT={:#x}:M={:#x}", col_buf.Address(),
                                 col_buf.CmaskAddress()));
    image.Clear(clear_value, desc.view_info.range);
    ScopeMarkerEnd();
}

/// The command buffer handle is kept in the journal only so entries can be grouped per queue - it
/// is never dereferenced, which is what makes it safe to hold on a dying device.
static u64 CmdBufValue(vk::CommandBuffer cmdbuf) {
    static_assert(sizeof(VkCommandBuffer) == sizeof(u64),
                  "the journal stores a command buffer handle as an opaque u64");
    return std::bit_cast<u64>(static_cast<VkCommandBuffer>(cmdbuf));
}

void Rasterizer::CollectShaderIdentity(const Pipeline* pipeline, GpuWorkPayload& out) const {
    u32 found = 0;
    for (const auto* stage : pipeline->GetStages()) {
        if (!stage) {
            continue;
        }
        if (found == 0) {
            out.primary_hash = stage->pgm_hash;
            out.primary_stage = static_cast<u8>(stage->stage);
        } else {
            out.secondary_hash = stage->pgm_hash;
            out.secondary_stage = static_cast<u8>(stage->stage);
        }
        if (++found == 2) {
            break;
        }
    }
}

void Rasterizer::NoteDrawPixelWork(const RenderState& state, u64 vertex_invocations,
                                   GpuWorkPayload& out) const {
    // ⚠⚠ BeginRendering SEEDS width/height with the DEVICE MAXIMUM (vk_rasterizer.cpp:1024) and
    // then min()s them down against each attachment. A draw with no colour and no depth attachment
    // therefore leaves them at 32768x32768, and reading that as a render area reports 1.07 BILLION
    // fragments for a 4-vertex draw - which is exactly what the first run of this code did. Note
    // that num_layers IS normalised back to 1 a few lines later (:1138) but the extent is NOT, so
    // "layers looks sane" is no evidence that the extent does.
    const bool has_target = state.num_color_attachments > 0 ||
                            static_cast<bool>(state.depth_stencil_attachment.image_view);
    const bool extent_is_device_max = state.width >= instance.GetMaxFramebufferWidth() ||
                                      state.height >= instance.GetMaxFramebufferHeight();
    if (!has_target || extent_is_device_max) {
        // No render target to bound the work, so there is no honest pixel figure. Leave it zero -
        // an unmarked guess reads as a fact.
        out.rt_width = 0;
        out.rt_height = 0;
        out.rt_layers = 0;
        out.pixel_estimate = 0;
        out.work_estimate = vertex_invocations;
        return;
    }
    out.rt_width = state.width;
    out.rt_height = state.height;
    out.rt_layers = std::max<u32>(state.num_layers, 1u);
    out.pixel_estimate =
        GpuWorkSatMul(GpuWorkSatMul(out.rt_width, out.rt_height), out.rt_layers);
    // MAX, not sum: the two numbers measure different pipeline stages, and adding them would invent
    // a quantity that is neither. The threshold should fire on whichever half is monstrous.
    out.work_estimate = std::max(vertex_invocations, out.pixel_estimate);
}

bool Rasterizer::TryReadIndirectArgs(VAddr addr, u32 num_dwords, u32* out, bool* gpu_modified) {
    *gpu_modified = false;
    if (addr == 0 || num_dwords == 0 || (addr % sizeof(u32)) != 0) {
        return false;
    }
    const u64 num_bytes = u64{num_dwords} * sizeof(u32);
    // IsMapped, not MemoryManager::IsValidMapping - the latter walks vma_map without its lock.
    if (!IsMapped(addr, num_bytes)) {
        return false;
    }
    // memcpy rather than a struct cast: the guest buffer is only guaranteed dword aligned.
    std::memcpy(out, std::bit_cast<const u32*>(addr), num_bytes);
    // A plain staleness STAMP, never a readback. Downloading the buffer for accuracy would put a
    // GPU->CPU stall inside the very submission being measured, which is exactly the class of
    // change that made the CDL run stop reproducing the bug.
    *gpu_modified = buffer_cache.IsRegionGpuModified(addr, num_bytes);
    return true;
}

void Rasterizer::Draw(bool is_indexed, u32 index_offset) {
    RENDERER_TRACE;

    scheduler.PopPendingOperations();

    if (!FilterDraw()) {
        return;
    }

    const auto& regs = liverpool->regs;
    const GraphicsPipeline* pipeline = pipeline_cache.GetGraphicsPipeline();
    if (!pipeline) {
        return;
    }

    PrepareRenderState(pipeline);
    if (!BindResources(pipeline)) {
        return;
    }
    const auto state = BeginRendering(pipeline);

    buffer_cache.BindVertexBuffers(*pipeline, buffer_barriers);
    if (is_indexed) {
        buffer_cache.BindIndexBuffer(index_offset, buffer_barriers);
    }

    pipeline->BindResources(set_writes, buffer_barriers, push_data);
    UpdateDynamicState(pipeline, is_indexed);
    scheduler.BeginRendering(state);

    const auto& vs_info = pipeline->GetStage(Shader::LogicalStage::Vertex);
    const auto& fetch_shader = pipeline->GetFetchShader();
    const auto [vertex_offset, instance_offset] = GetDrawOffsets(regs, vs_info, fetch_shader);

    const auto cmdbuf = scheduler.CommandBuffer();
    cmdbuf.bindPipeline(vk::PipelineBindPoint::eGraphics, pipeline->Handle());

    // Record only work that actually reaches the command buffer, so the journal's order is the
    // order the GPU was given - hence after every early-out above, not at function entry.
    GpuWorkPayload work{};
    work.kind = is_indexed ? GpuWorkKind::DrawIndexed : GpuWorkKind::Draw;
    work.cmdbuf = CmdBufValue(cmdbuf);
    work.count_a = regs.num_indices;
    work.count_b = regs.num_instances.NumInstances();
    NoteDrawPixelWork(state, GpuWorkSatMul(work.count_a, work.count_b), work);
    CollectShaderIdentity(pipeline, work);
    instance.RecordGpuWork(work);

    if (is_indexed) {
        cmdbuf.drawIndexed(regs.num_indices, regs.num_instances.NumInstances(), 0,
                           s32(vertex_offset), instance_offset);
    } else {
        cmdbuf.draw(regs.num_indices, regs.num_instances.NumInstances(), vertex_offset,
                    instance_offset);
    }
    DebugState.IncDrawCall();

    ResetBindings();
}

void Rasterizer::DrawIndirect(bool is_indexed, VAddr arg_address, u32 offset, u32 stride,
                              u32 max_count, VAddr count_address) {
    RENDERER_TRACE;

    scheduler.PopPendingOperations();

    if (!FilterDraw()) {
        return;
    }

    const GraphicsPipeline* pipeline = pipeline_cache.GetGraphicsPipeline();
    if (!pipeline) {
        return;
    }

    PrepareRenderState(pipeline);
    if (!BindResources(pipeline)) {
        return;
    }
    const auto state = BeginRendering(pipeline);

    buffer_cache.BindVertexBuffers(*pipeline, buffer_barriers);
    if (is_indexed) {
        buffer_cache.BindIndexBuffer(0, buffer_barriers);
    }

    const auto& [buffer, base] =
        buffer_cache.ObtainBuffer(arg_address + offset, stride * max_count, false);

    VideoCore::Buffer* count_buffer{};
    u32 count_base{};
    if (count_address != 0) {
        std::tie(count_buffer, count_base) = buffer_cache.ObtainBuffer(count_address, 4, false);
    }

    if (auto barrier = buffer->GetBarrier(vk::AccessFlagBits2::eIndirectCommandRead,
                                          vk::PipelineStageFlagBits2::eDrawIndirect)) {
        buffer_barriers.emplace_back(*barrier);
    }
    if (count_buffer) {
        if (auto barrier = count_buffer->GetBarrier(vk::AccessFlagBits2::eIndirectCommandRead,
                                                    vk::PipelineStageFlagBits2::eDrawIndirect)) {
            buffer_barriers.emplace_back(*barrier);
        }
    }

    pipeline->BindResources(set_writes, buffer_barriers, push_data);
    UpdateDynamicState(pipeline, is_indexed);
    scheduler.BeginRendering(state);

    // We can safely ignore both SGPR UD indices and results of fetch shader parsing, as vertex and
    // instance offsets will be automatically applied by Vulkan from indirect args buffer.

    const auto cmdbuf = scheduler.CommandBuffer();
    cmdbuf.bindPipeline(vk::PipelineBindPoint::eGraphics, pipeline->Handle());

    {
        GpuWorkPayload work{};
        work.kind = is_indexed ? GpuWorkKind::DrawIndexedIndirect : GpuWorkKind::DrawIndirect;
        work.cmdbuf = CmdBufValue(cmdbuf);
        work.guest_addr = arg_address + offset;
        // max_count is load-bearing, not bookkeeping: drawIndirect issues that MANY commands, so
        // total work is per-command work TIMES max_count. Kept in groups[] because count_a/count_b
        // carry the per-command numbers read below; the dump prints them for indirect draws.
        work.groups[0] = max_count;
        work.groups[1] = stride;
        work.count_a = 0;
        work.count_b = 0;
        // Only the FIRST command of the array, deliberately: walking max_count of them would read
        // an unbounded amount of guest memory on every indirect draw. So the estimate ASSUMES the
        // other commands are the same size - it is an order of magnitude, not a count.
        u32 args[8]{};
        const u32 num_dwords = std::min<u32>(stride / sizeof(u32), std::size(args));
        bool stale = false;
        if (num_dwords > 0 && TryReadIndirectArgs(work.guest_addr, num_dwords, args, &stale)) {
            work.flags |= GpuWorkFlag::IndirectArgsRead;
            if (stale) {
                work.flags |= GpuWorkFlag::IndirectArgsGpuModified;
            }
            // VkDraw(Indexed)IndirectCommand both start with a count then an instance count.
            work.count_a = args[0];
            if (num_dwords > 1) {
                work.count_b = args[1];
            }
        } else {
            work.flags |= GpuWorkFlag::IndirectArgsUnmapped;
        }
        NoteDrawPixelWork(
            state, GpuWorkSatMul(GpuWorkSatMul(work.count_a, work.count_b), max_count), work);
        CollectShaderIdentity(pipeline, work);
        instance.RecordGpuWork(work);
    }

    if (is_indexed) {
        ASSERT(sizeof(VkDrawIndexedIndirectCommand) == stride);

        if (count_address != 0) {
            cmdbuf.drawIndexedIndirectCount(buffer->Handle(), base, count_buffer->Handle(),
                                            count_base, max_count, stride);
        } else {
            cmdbuf.drawIndexedIndirect(buffer->Handle(), base, max_count, stride);
        }
        DebugState.IncDrawCall();
    } else {
        ASSERT(sizeof(VkDrawIndirectCommand) == stride);

        if (count_address != 0) {
            cmdbuf.drawIndirectCount(buffer->Handle(), base, count_buffer->Handle(), count_base,
                                     max_count, stride);
        } else {
            cmdbuf.drawIndirect(buffer->Handle(), base, max_count, stride);
        }
        DebugState.IncDrawCall();
    }

    ResetBindings();
}

void Rasterizer::DispatchDirect() {
    RENDERER_TRACE;

    scheduler.PopPendingOperations();

    const auto& cs_program = liverpool->GetCsRegs();
    const ComputePipeline* pipeline = pipeline_cache.GetComputePipeline();
    if (!pipeline) {
        return;
    }

    const auto& cs = pipeline->GetStage(Shader::LogicalStage::Compute);
    if (ExecuteShaderHLE(cs, liverpool->regs, cs_program, *this)) {
        return;
    }

    if (!BindResources(pipeline)) {
        return;
    }

    // GT_SKIP_EMPTY_DYNRC (default on, '0' = off): a producer dispatched while its dynrc
    // window is ALL ZERO consumes a guest table that has not been written yet - guaranteed
    // garbage, and with a WARM pipeline cache these dispatches run seconds earlier than any
    // cold boot ever did (no compile stalls), which is the race behind the deterministic
    // early ReadInvalid of runs 100/101/104 (cold run 99 was clean; stubbing the producer
    // removed the fault in run 98). The game re-dispatches every frame, so skipping the
    // unfed ones costs nothing once the table exists.
    static const bool skip_empty_dynrc = [] {
        const char* v = std::getenv("GT_SKIP_EMPTY_DYNRC");
        return !(v && v[0] == '0');
    }();
    if (skip_empty_dynrc && cs.HasAllZeroDynrcWindow()) {
        static std::atomic<u32> empty_dynrc_logs{0};
        if (empty_dynrc_logs.fetch_add(1, std::memory_order_relaxed) < 32) {
            LOG_CRITICAL(Render_Vulkan,
                         "[softclamp] cs {:#x}: dynrc window ALL ZERO - dispatch skipped "
                         "(guest table not written yet)",
                         cs.pgm_hash);
        }
        return;
    }

    scheduler.EndRendering();
    pipeline->BindResources(set_writes, buffer_barriers, push_data);

    const auto cmdbuf = scheduler.CommandBuffer();
    cmdbuf.bindPipeline(vk::PipelineBindPoint::eCompute, pipeline->Handle());

    GpuWorkPayload work{};
    work.kind = GpuWorkKind::DispatchDirect;
    work.cmdbuf = CmdBufValue(cmdbuf);
    work.groups[0] = cs_program.dim_x;
    work.groups[1] = cs_program.dim_y;
    work.groups[2] = cs_program.dim_z;
    work.threads_per_group[0] = cs_program.num_thread_x.full;
    work.threads_per_group[1] = cs_program.num_thread_y.full;
    work.threads_per_group[2] = cs_program.num_thread_z.full;
    work.lds_bytes = cs_program.SharedMemSize();
    work.num_vgprs = static_cast<u32>(cs_program.settings.num_vgprs);
    work.work_estimate = GpuWorkSatMul(
        GpuWorkSatMul(GpuWorkSatMul(work.groups[0], work.groups[1]), work.groups[2]),
        GpuWorkSatMul(GpuWorkSatMul(work.threads_per_group[0], work.threads_per_group[1]),
                      work.threads_per_group[2]));
    work.primary_hash = cs.pgm_hash;
    work.primary_stage = static_cast<u8>(cs.stage);
    instance.RecordGpuWork(work);

    cmdbuf.dispatch(cs_program.dim_x, cs_program.dim_y, cs_program.dim_z);
    DebugState.IncDispatch();

    ResetBindings();

    // GT_DISPATCH_BARRIER=1: a full memory barrier after every dispatch, WITHOUT splitting the
    // submission. Companion experiment to GT_SPLIT_DISPATCH, and the pair is what separates the
    // mechanism: splitting made the game run PAST the point where seven consecutive runs hung
    // (182 shader compiles, byte-stable fault signature - this run reached 203 and died on an
    // unrelated recompiler limit). A submit boundary changes several things at once; a barrier
    // changes exactly one - the visibility/ordering of this dispatch's writes for everything after
    // it, indirect argument reads included.
    //     barrier alone also passes the wall -> a MISSING BARRIER after some dispatch is the bug
    //         (a consumer - e.g. an indirect draw/dispatch reading GPU-written arguments - runs on
    //         garbage and the garbage is unbounded work, which is a TDR with zero memory faults)
    //     barrier alone still hangs         -> the cure was something else a submit does, and the
    //         search moves there (per-submit host work, descriptor timing, queue pacing)
    static const bool barrier_after_dispatch = [] {
        const char* v = std::getenv("GT_DISPATCH_BARRIER");
        return v && std::atoi(v) != 0;
    }();
    // GT_BINDLESS_LOWER (19 Aug, run 83 device fault): a shader with GPU-time BDA WRITES
    // (WriteConst / ConstAtomicIAdd32) bypasses every buffer-cache barrier - the next pass
    // reads those pages with no ordering at all. Always fence THESE dispatches; they are a
    // handful per frame, so this is not the global GT_DISPATCH_BARRIER cost.
    if (barrier_after_dispatch || cs.uses_dma) {
        const vk::MemoryBarrier2 mem_barrier = {
            .srcStageMask = vk::PipelineStageFlagBits2::eComputeShader,
            .srcAccessMask = vk::AccessFlagBits2::eShaderWrite,
            .dstStageMask = vk::PipelineStageFlagBits2::eAllCommands,
            .dstAccessMask = vk::AccessFlagBits2::eMemoryRead | vk::AccessFlagBits2::eMemoryWrite,
        };
        cmdbuf.pipelineBarrier2(vk::DependencyInfo{
            .memoryBarrierCount = 1,
            .pMemoryBarriers = &mem_barrier,
        });
    }

    // GT_SPLIT_DISPATCH=N: submit after every Nth dispatch, so each gets its own timeline tick.
    //
    // WHY: the device-fault census can only bound the hung work by TICK, and a tick normally covers
    // a whole command buffer - measured at ~6400 draws/dispatches here, 70 distinct shaders, which
    // is a suspect LIST, not a suspect. Splitting at dispatch boundaries (safe: EndRendering has
    // already run on this path, so no render pass is open) shrinks each tick's range to the work
    // between two dispatches - about 14 entries in the hung region - and the census then NAMES the
    // guilty range instead of narrowing it by one shader-patch experiment per run. Diagnostic only:
    // hundreds of extra submits per frame is real overhead, so it is env-gated, default off.
    // Read once - getenv on every dispatch would be thousands of libc calls a frame.
    static const int split_every = [] {
        const char* v = std::getenv("GT_SPLIT_DISPATCH");
        return v ? std::atoi(v) : 0;
    }();
    if (split_every > 0) {
        static int since_split = 0;
        if (++since_split >= split_every) {
            since_split = 0;
            SubmitInfo info{};
            scheduler.Flush(info);
        }
    }
}

void Rasterizer::DispatchIndirect(VAddr address, u32 offset, u32 size) {
    RENDERER_TRACE;

    scheduler.PopPendingOperations();

    const auto& cs_program = liverpool->GetCsRegs();
    const ComputePipeline* pipeline = pipeline_cache.GetComputePipeline();
    if (!pipeline) {
        return;
    }

    if (!BindResources(pipeline)) {
        return;
    }

    const auto [buffer, base] = buffer_cache.ObtainBuffer(address + offset, size, false);

    if (auto barrier = buffer->GetBarrier(vk::AccessFlagBits2::eIndirectCommandRead,
                                          vk::PipelineStageFlagBits2::eDrawIndirect)) {
        buffer_barriers.emplace_back(*barrier);
    }

    scheduler.EndRendering();
    pipeline->BindResources(set_writes, buffer_barriers, push_data);

    const auto cmdbuf = scheduler.CommandBuffer();
    cmdbuf.bindPipeline(vk::PipelineBindPoint::eCompute, pipeline->Handle());

    // The group counts of an indirect dispatch NEVER pass through the host - the GPU takes them
    // straight out of a buffer - so a dispatch of 2^32 workgroups is otherwise entirely invisible.
    // This is the one place that can see it at all.
    GpuWorkPayload work{};
    work.kind = GpuWorkKind::DispatchIndirect;
    work.cmdbuf = CmdBufValue(cmdbuf);
    work.guest_addr = address + offset;
    work.threads_per_group[0] = cs_program.num_thread_x.full;
    work.threads_per_group[1] = cs_program.num_thread_y.full;
    work.threads_per_group[2] = cs_program.num_thread_z.full;
    work.lds_bytes = cs_program.SharedMemSize();
    work.num_vgprs = static_cast<u32>(cs_program.settings.num_vgprs);
    {
        u32 args[3]{};
        bool stale = false;
        if (TryReadIndirectArgs(work.guest_addr, 3, args, &stale)) {
            work.flags |= GpuWorkFlag::IndirectArgsRead;
            if (stale) {
                work.flags |= GpuWorkFlag::IndirectArgsGpuModified;
            }
            work.groups[0] = args[0];
            work.groups[1] = args[1];
            work.groups[2] = args[2];
            work.work_estimate = GpuWorkSatMul(
                GpuWorkSatMul(GpuWorkSatMul(work.groups[0], work.groups[1]), work.groups[2]),
                GpuWorkSatMul(GpuWorkSatMul(work.threads_per_group[0], work.threads_per_group[1]),
                              work.threads_per_group[2]));
        } else {
            work.flags |= GpuWorkFlag::IndirectArgsUnmapped;
        }
    }
    CollectShaderIdentity(pipeline, work);
    instance.RecordGpuWork(work);

    cmdbuf.dispatchIndirect(buffer->Handle(), base);
    DebugState.IncDispatch();

    ResetBindings();

    // GT_DISPATCH_BARRIER=1: a full memory barrier after every dispatch, WITHOUT splitting the
    // submission. Companion experiment to GT_SPLIT_DISPATCH, and the pair is what separates the
    // mechanism: splitting made the game run PAST the point where seven consecutive runs hung
    // (182 shader compiles, byte-stable fault signature - this run reached 203 and died on an
    // unrelated recompiler limit). A submit boundary changes several things at once; a barrier
    // changes exactly one - the visibility/ordering of this dispatch's writes for everything after
    // it, indirect argument reads included.
    //     barrier alone also passes the wall -> a MISSING BARRIER after some dispatch is the bug
    //         (a consumer - e.g. an indirect draw/dispatch reading GPU-written arguments - runs on
    //         garbage and the garbage is unbounded work, which is a TDR with zero memory faults)
    //     barrier alone still hangs         -> the cure was something else a submit does, and the
    //         search moves there (per-submit host work, descriptor timing, queue pacing)
    static const bool barrier_after_dispatch = [] {
        const char* v = std::getenv("GT_DISPATCH_BARRIER");
        return v && std::atoi(v) != 0;
    }();
    if (barrier_after_dispatch) {
        const vk::MemoryBarrier2 mem_barrier = {
            .srcStageMask = vk::PipelineStageFlagBits2::eComputeShader,
            .srcAccessMask = vk::AccessFlagBits2::eShaderWrite,
            .dstStageMask = vk::PipelineStageFlagBits2::eAllCommands,
            .dstAccessMask = vk::AccessFlagBits2::eMemoryRead | vk::AccessFlagBits2::eMemoryWrite,
        };
        cmdbuf.pipelineBarrier2(vk::DependencyInfo{
            .memoryBarrierCount = 1,
            .pMemoryBarriers = &mem_barrier,
        });
    }

    // GT_SPLIT_DISPATCH=N: submit after every Nth dispatch, so each gets its own timeline tick.
    //
    // WHY: the device-fault census can only bound the hung work by TICK, and a tick normally covers
    // a whole command buffer - measured at ~6400 draws/dispatches here, 70 distinct shaders, which
    // is a suspect LIST, not a suspect. Splitting at dispatch boundaries (safe: EndRendering has
    // already run on this path, so no render pass is open) shrinks each tick's range to the work
    // between two dispatches - about 14 entries in the hung region - and the census then NAMES the
    // guilty range instead of narrowing it by one shader-patch experiment per run. Diagnostic only:
    // hundreds of extra submits per frame is real overhead, so it is env-gated, default off.
    // Read once - getenv on every dispatch would be thousands of libc calls a frame.
    static const int split_every = [] {
        const char* v = std::getenv("GT_SPLIT_DISPATCH");
        return v ? std::atoi(v) : 0;
    }();
    if (split_every > 0) {
        static int since_split = 0;
        if (++since_split >= split_every) {
            since_split = 0;
            SubmitInfo info{};
            scheduler.Flush(info);
        }
    }
}

u64 Rasterizer::Flush() {
    const u64 current_tick = scheduler.CurrentTick();
    SubmitInfo info{};
    scheduler.Flush(info);
    return current_tick;
}

void Rasterizer::Finish() {
    scheduler.Finish();
}

void Rasterizer::OnSubmit() {
    if (fault_process_pending) {
        fault_process_pending = false;
        buffer_cache.ProcessFaultBuffer();
    }
    texture_cache.ProcessDownloadImages();
    texture_cache.RunGarbageCollector();
    buffer_cache.RunGarbageCollector();
    // Drain the all-timelines-gated buffer graveyard here (per submit, on the one thread
    // every DeleteBuffer caller uses) - NOT via DeferOperation, whose callbacks run under
    // pending_ops_mutex and cannot re-queue themselves.
    buffer_cache.ProcessPendingDeaths();
}

bool Rasterizer::BindResources(const Pipeline* pipeline) {
    if (IsComputeImageCopy(pipeline) || IsComputeMetaClear(pipeline) ||
        IsComputeImageClear(pipeline)) {
        return false;
    }

    set_write_index = 0;
    set_writes.clear();
    buffer_barriers.clear();
    buffer_infos.clear();
    image_infos.clear();

    bool uses_dma = false;

    // Bind resource buffers and textures.
    Shader::Backend::Bindings binding{};
    push_data = MakeUserData(liverpool->regs);
    for (const auto* stage : pipeline->GetStages()) {
        if (!stage) {
            continue;
        }
        set_writes.resize(set_writes.size() + stage->buffers.size() + stage->images.size() +
                          stage->samplers.size());
        stage->PushUd(binding, push_data);
        BindBuffers(*stage, binding, push_data);
        BindTextures(*stage, binding);
        uses_dma |= stage->uses_dma;
    }

    if (uses_dma) {
        // We only use fault buffer for DMA right now.
        Common::RecursiveSharedLock lock{mapped_ranges_mutex};
        for (auto& range : mapped_ranges) {
            buffer_cache.SynchronizeBuffersInRange(range.lower(), range.upper() - range.lower());
        }
        fault_process_pending = true;
    }

    return true;
}

bool Rasterizer::IsComputeMetaClear(const Pipeline* pipeline) {
    if (!pipeline->IsCompute()) {
        return false;
    }

    // Most of the time when a metadata is updated with a shader it gets cleared. It means
    // we can skip the whole dispatch and update the tracked state instead. Also, it is not
    // intended to be consumed and in such rare cases (e.g. HTile introspection, CRAA) we
    // will need its full emulation anyways.
    const auto& info = pipeline->GetStage(Shader::LogicalStage::Compute);

    // Assume if a shader reads metadata, it is a copy shader.
    for (const auto& desc : info.buffers) {
        const VAddr address = desc.GetSharp(info).base_address;
        if (!desc.IsSpecial() && !desc.is_written && texture_cache.IsMeta(address)) {
            return false;
        }
    }

    // Metadata surfaces are tiled and thus need address calculation to be written properly.
    // If a shader wants to encode HTILE, for example, from a depth image it will have to compute
    // proper tile address from dispatch invocation id. This address calculation contains an xor
    // operation so use it as a heuristic for metadata writes that are probably not clears.
    if (!info.has_bitwise_xor) {
        // Assume if a shader writes metadata without address calculation, it is a clear shader.
        for (const auto& desc : info.buffers) {
            const VAddr address = desc.GetSharp(info).base_address;
            if (!desc.IsSpecial() && desc.is_written && texture_cache.ClearMeta(address)) {
                // Assume all slices were updates
                LOG_TRACE(Render_Vulkan, "Metadata update skipped");
                return true;
            }
        }
    }
    return false;
}

bool Rasterizer::IsComputeImageCopy(const Pipeline* pipeline) {
    if (!pipeline->IsCompute()) {
        return false;
    }

    // Ensure shader only has 2 bound buffers
    const auto& cs_pgm = liverpool->GetCsRegs();
    const auto& info = pipeline->GetStage(Shader::LogicalStage::Compute);
    if (cs_pgm.num_thread_x.full != 64 || info.buffers.size() != 2 || !info.images.empty()) {
        return false;
    }

    // Those 2 buffers must both be formatted. One must be source and another destination.
    const auto& desc0 = info.buffers[0];
    const auto& desc1 = info.buffers[1];
    if (!desc0.is_formatted || !desc1.is_formatted || desc0.is_written == desc1.is_written) {
        return false;
    }

    // Buffers must have the same size and each thread of the dispatch must copy 1 dword of data
    const AmdGpu::Buffer buf0 = desc0.GetSharp(info);
    const AmdGpu::Buffer buf1 = desc1.GetSharp(info);
    if (buf0.GetSize() != buf1.GetSize() || cs_pgm.dim_x != (buf0.GetSize() / 256)) {
        return false;
    }

    // Find images the buffer alias
    const auto image0_id = texture_cache.FindImageFromRange(buf0.base_address, buf0.GetSize());
    if (!image0_id) {
        return false;
    }
    const auto image1_id =
        texture_cache.FindImageFromRange(buf1.base_address, buf1.GetSize(), false);
    if (!image1_id) {
        return false;
    }

    // Image copy must be valid
    VideoCore::Image& image0 = texture_cache.GetImage(image0_id);
    VideoCore::Image& image1 = texture_cache.GetImage(image1_id);
    if (image0.info.guest_size != image1.info.guest_size ||
        image0.info.pitch != image1.info.pitch || image0.info.guest_size != buf0.GetSize() ||
        image0.info.num_bits != image1.info.num_bits) {
        return false;
    }

    // Perform image copy
    VideoCore::Image& src_image = desc0.is_written ? image1 : image0;
    VideoCore::Image& dst_image = desc0.is_written ? image0 : image1;
    if (instance.IsMaintenance8Supported() ||
        src_image.info.props.is_depth == dst_image.info.props.is_depth) {
        dst_image.CopyImage(src_image);
    } else {
        const auto& copy_buffer =
            buffer_cache.GetUtilityBuffer(VideoCore::MemoryUsage::DeviceLocal);
        dst_image.CopyImageWithBuffer(src_image, copy_buffer.Handle(), 0);
    }
    dst_image.flags |= VideoCore::ImageFlagBits::GpuModified;
    dst_image.flags &= ~VideoCore::ImageFlagBits::Dirty;
    return true;
}

bool Rasterizer::IsComputeImageClear(const Pipeline* pipeline) {
    if (!pipeline->IsCompute()) {
        return false;
    }

    // Ensure shader only has 2 bound buffers
    const auto& cs_pgm = liverpool->GetCsRegs();
    const auto& info = pipeline->GetStage(Shader::LogicalStage::Compute);
    if (cs_pgm.num_thread_x.full != 64 || info.buffers.size() != 2 || !info.images.empty()) {
        return false;
    }

    // From those 2 buffers, first must hold the clear vector and second the image being cleared
    const auto& desc0 = info.buffers[0];
    const auto& desc1 = info.buffers[1];
    if (desc0.is_formatted || !desc1.is_formatted || desc0.is_written || !desc1.is_written) {
        return false;
    }

    // First buffer must have size of vec4 and second the size of a single layer
    const AmdGpu::Buffer buf0 = desc0.GetSharp(info);
    const AmdGpu::Buffer buf1 = desc1.GetSharp(info);
    const u32 buf1_bpp = AmdGpu::NumBitsPerBlock(buf1.GetDataFmt());
    if (buf0.GetSize() != 16 || (cs_pgm.dim_x * 128ULL * (buf1_bpp / 8)) != buf1.GetSize()) {
        return false;
    }

    // Find image the buffer alias
    const auto image1_id =
        texture_cache.FindImageFromRange(buf1.base_address, buf1.GetSize(), false);
    if (!image1_id) {
        return false;
    }

    // Image clear must be valid
    VideoCore::Image& image1 = texture_cache.GetImage(image1_id);
    if (image1.info.guest_size != buf1.GetSize() || image1.info.num_bits != buf1_bpp ||
        image1.info.props.is_depth) {
        return false;
    }

    // Perform image clear
    const float* values = reinterpret_cast<float*>(buf0.base_address);
    const vk::ClearValue clear = {
        .color = {.float32 = std::array<float, 4>{values[0], values[1], values[2], values[3]}},
    };
    const VideoCore::SubresourceRange range = {
        .base =
            {
                .level = 0,
                .layer = 0,
            },
        .extent = image1.info.resources,
    };
    image1.Clear(clear, range);
    image1.flags |= VideoCore::ImageFlagBits::GpuModified;
    image1.flags &= ~VideoCore::ImageFlagBits::Dirty;
    return true;
}

void Rasterizer::BindBuffers(const Shader::Info& stage, Shader::Backend::Bindings& binding,
                             Shader::PushData& push_data) {
    buffer_bindings.clear();

    for (const auto& desc : stage.buffers) {
        const auto vsharp = desc.GetSharp(stage);
        if (!desc.IsSpecial() && vsharp.base_address != 0 && vsharp.GetSize() > 0) {
            // A V# whose base sits below the guest floor (or within a page of the top of the
            // 40-bit guest space) is torn, full stop - no legitimate guest data lives there;
            // the page manager refuses trackings under 64 KiB for the same reason. Runs
            // 83/84/86 postmortem: base 0x24 passed the base!=0 entry guard above, took the
            // tail clamp, CreateBuffer aligned it down to 0 and substituted the 16 KiB dummy,
            // and Buffer::Offset(0x24 - 0x4000) underflowed into a ~4 GiB descriptor offset
            // on a 16 KiB buffer - the IP+WriteInvalid device fault of all three runs.
            // Null-bind it here, before any of that machinery can run.
            constexpr VAddr GuestFloor = 64_KB;
            if (vsharp.base_address < GuestFloor ||
                vsharp.base_address >= (1ULL << 40) - GuestFloor) {
                static std::atomic<u32> floor_logs{0};
                if (floor_logs.fetch_add(1, std::memory_order_relaxed) < 32) {
                    LOG_CRITICAL(Render_Vulkan,
                                 "[softclamp] shader {:#x}: V# base {:#x} size {:#x} outside the "
                                 "guest floor/ceiling - null-bound (seq {})",
                                 stage.pgm_hash, vsharp.base_address, vsharp.GetSize(),
                                 instance.PeekGpuWorkSeq());
                }
                buffer_bindings.emplace_back(VideoCore::BufferId{}, vsharp, 0);
                continue;
            }
            // NOT torn after all - run 65 measured it: dozens of V#s at DIFFERENT bases inside a
            // ~2.6 GiB heap, each sized "whatever remains to the end of the heap" (561/584 MB,
            // 2.62 GiB in run 64). Classic TAIL DESCRIPTORS - legitimate engine practice. The
            // emulator's mistake was mirroring the whole tail into a device buffer per bind:
            // that is the 2.62 GiB vmaCreateBuffer OOM of run 64 (and likely runs 55/56).
            // Null-binding them (the first cap) broke every material instead. The honest middle:
            // bind the FIRST 256 MB of the tail - shaders index near their base, robustness
            // zero-fills anything past the clamp - and never ask VMA for a GiB again.
            static const bool soft_size = [] {
                const char* v = std::getenv("GT_SOFT_CLAMP");
                return v && v[0] == '1';
            }();
            constexpr u64 TailBindCap = 256_MB;
            u64 wanted_size = vsharp.GetSize();
            if (soft_size && wanted_size > TailBindCap) {
                static std::atomic<u32> tail_logs{0};
                if (tail_logs.fetch_add(1, std::memory_order_relaxed) < 32) {
                    LOG_CRITICAL(Render_Vulkan,
                                 "[softclamp] shader {:#x}: V# base {:#x} size {} MB - tail "
                                 "descriptor, binding the first {} MB",
                                 stage.pgm_hash, vsharp.base_address, wanted_size >> 20,
                                 TailBindCap >> 20);
                }
                wanted_size = TailBindCap;
            }
            const u64 size = memory->ClampRangeSize(vsharp.base_address, wanted_size);
            if (size == 0) {
                // GT_SOFT_CLAMP survivor: a torn V# (see ClampRangeSize). Null-bind it loudly
                // instead of asking the buffer cache for a buffer at an unmapped address.
                LOG_CRITICAL(Render_Vulkan,
                             "[softclamp] shader {:#x}: V# base {:#x} unmapped - null-bound",
                             stage.pgm_hash, vsharp.base_address);
                buffer_bindings.emplace_back(VideoCore::BufferId{}, vsharp, 0);
                continue;
            }
            const auto buffer_id = buffer_cache.FindBuffer(vsharp.base_address, size);
            buffer_bindings.emplace_back(buffer_id, vsharp, size);
        } else {
            buffer_bindings.emplace_back(VideoCore::BufferId{}, vsharp, 0);
        }
    }

    // Second pass to re-bind buffers that were updated after binding
    for (u32 i = 0; i < buffer_bindings.size(); i++) {
        const auto& [buffer_id, vsharp, size] = buffer_bindings[i];
        const auto& desc = stage.buffers[i];
        const bool is_storage = desc.IsStorage(vsharp);
        const u32 alignment =
            is_storage ? instance.StorageMinAlignment() : instance.UniformMinAlignment();
        // Buffer is not from the cache, either a special buffer or unbound.
        if (!buffer_id) {
            if (desc.buffer_type == Shader::BufferType::GdsBuffer) {
                const auto* gds_buf = buffer_cache.GetGdsBuffer();
                buffer_infos.emplace_back(gds_buf->Handle(), 0, gds_buf->SizeBytes());
            } else if (desc.buffer_type == Shader::BufferType::Flatbuf) {
                auto& vk_buffer = buffer_cache.GetUtilityBuffer(VideoCore::MemoryUsage::Stream);
                const u32 ubo_size = stage.flattened_ud_buf.size() * sizeof(u32);
                const u64 offset =
                    vk_buffer.Copy(stage.flattened_ud_buf.data(), ubo_size, alignment);
                buffer_infos.emplace_back(vk_buffer.Handle(), offset, ubo_size);
            } else if (desc.buffer_type == Shader::BufferType::ClipPlanes) {
                // Permutations compiled without enabled planes never read the buffer, so the
                // declared binding is satisfied with a null descriptor instead of a copy.
                if (liverpool->regs.clipper_control.user_clip_plane_enable == 0) {
                    buffer_infos.emplace_back(VK_NULL_HANDLE, 0, VK_WHOLE_SIZE);
                } else {
                    auto& vk_buffer = buffer_cache.GetUtilityBuffer(VideoCore::MemoryUsage::Stream);
                    std::array<float, AmdGpu::NUM_CLIP_PLANES * 4> planes{};
                    for (u32 i = 0; i < AmdGpu::NUM_CLIP_PLANES; ++i) {
                        const auto& plane = liverpool->regs.clip_user_data[i];
                        planes[i * 4 + 0] = std::bit_cast<float>(plane.data_x);
                        planes[i * 4 + 1] = std::bit_cast<float>(plane.data_y);
                        planes[i * 4 + 2] = std::bit_cast<float>(plane.data_z);
                        planes[i * 4 + 3] = std::bit_cast<float>(plane.data_w);
                    }
                    const u32 ubo_size = static_cast<u32>(sizeof(planes));
                    const u64 offset = vk_buffer.Copy(planes.data(), ubo_size, alignment);
                    buffer_infos.emplace_back(vk_buffer.Handle(), offset, ubo_size);
                }
            } else if (desc.buffer_type == Shader::BufferType::BdaPagetable) {
                const auto* bda_buffer = buffer_cache.GetBdaPageTableBuffer();
                buffer_infos.emplace_back(bda_buffer->Handle(), 0, bda_buffer->SizeBytes());
            } else if (desc.buffer_type == Shader::BufferType::FaultBuffer) {
                const auto* fault_buffer = buffer_cache.GetFaultBuffer();
                buffer_infos.emplace_back(fault_buffer->Handle(), 0, fault_buffer->SizeBytes());
            } else if (desc.buffer_type == Shader::BufferType::SharedMemory) {
                auto& lds_buffer = buffer_cache.GetUtilityBuffer(VideoCore::MemoryUsage::Stream);
                const auto& cs_program = liverpool->GetCsRegs();
                const auto lds_size = cs_program.SharedMemSize() * cs_program.NumWorkgroups();
                const auto [data, offset] = lds_buffer.Map(lds_size, alignment);
                std::memset(data, 0, lds_size);
                buffer_infos.emplace_back(lds_buffer.Handle(), offset, lds_size);
            } else {
                buffer_infos.emplace_back(VK_NULL_HANDLE, 0, VK_WHOLE_SIZE);
            }
        } else {
            const auto [vk_buffer, offset] = buffer_cache.ObtainBuffer(
                vsharp.base_address, size, desc.is_written, desc.is_formatted, buffer_id);
            const u32 offset_aligned = Common::AlignDown(offset, alignment);
            const u32 adjust = offset - offset_aligned;
            // GT_SOFT_CLAMP family, symptom #2: a V# whose base is MAPPED but garbage-misaligned
            // (the run-19/35/50 `adjust % 4` assert). Same torn GPU-driven descriptor as the
            // unmapped 0x24 case, wearing a base the validity check cannot reject. Null-bind one
            // frame, loudly, instead of killing the process.
            static const bool soft_misaligned = [] {
                const char* v = std::getenv("GT_SOFT_CLAMP");
                return v && v[0] == '1';
            }();
            // Never emit a descriptor whose window lies outside the VkBuffer that backs it: a
            // torn V# that survives every base guard (or an underflowed Offset) otherwise
            // becomes an out-of-range VkDescriptorBufferInfo - undefined behaviour that
            // robustness does NOT cover (robustness bounds accesses against the DECLARED
            // range; a range past the allocation is invalid usage) and the measured
            // WriteInvalid family of runs 83/84/86. Clamp against the real backing size.
            const u64 backing_size = vk_buffer->SizeBytes();
            const bool offset_past_end = offset_aligned >= backing_size;
            if ((soft_misaligned && (adjust % 4) != 0) || offset_past_end) {
                LOG_CRITICAL(Render_Vulkan,
                             "[softclamp] shader {:#x}: V# base {:#x} {} - null-bound",
                             stage.pgm_hash, vsharp.base_address,
                             offset_past_end
                                 ? fmt::format("descriptor offset {:#x} past backing size {:#x}",
                                               offset_aligned, backing_size)
                                 : fmt::format("misaligned (adjust {})", adjust));
                buffer_infos.emplace_back(VK_NULL_HANDLE, 0, VK_WHOLE_SIZE);
            } else {
            ASSERT(adjust % 4 == 0);
            u64 bind_range = size + adjust;
            if (offset_aligned + bind_range > backing_size) {
                static std::atomic<u32> range_logs{0};
                if (range_logs.fetch_add(1, std::memory_order_relaxed) < 32) {
                    LOG_CRITICAL(Render_Vulkan,
                                 "[softclamp] shader {:#x}: V# base {:#x} descriptor range {:#x} "
                                 "at offset {:#x} exceeds backing size {:#x} - clamped",
                                 stage.pgm_hash, vsharp.base_address, bind_range, offset_aligned,
                                 backing_size);
                }
                bind_range = backing_size - offset_aligned;
            }
            push_data.AddOffset(binding.buffer, adjust);
            buffer_infos.emplace_back(vk_buffer->Handle(), offset_aligned, bind_range);
            if (auto barrier =
                    vk_buffer->GetBarrier(desc.is_written ? vk::AccessFlagBits2::eShaderWrite
                                                          : vk::AccessFlagBits2::eShaderRead,
                                          vk::PipelineStageFlagBits2::eAllCommands)) {
                buffer_barriers.emplace_back(*barrier);
            }
            if (desc.is_written && desc.is_formatted) {
                texture_cache.InvalidateMemoryFromGPU(vsharp.base_address, size);
            }
            }
        }

        auto& set_write = set_writes[set_write_index++];
        set_write.dstSet = VK_NULL_HANDLE;
        set_write.dstBinding = binding.unified++;
        set_write.dstArrayElement = 0;
        set_write.descriptorCount = 1;
        set_write.descriptorType =
            is_storage ? vk::DescriptorType::eStorageBuffer : vk::DescriptorType::eUniformBuffer;
        set_write.pBufferInfo = &buffer_infos.back();
        ++binding.buffer;
    }
}

void Rasterizer::BindTextures(const Shader::Info& stage, Shader::Backend::Bindings& binding) {
    image_bindings.clear();
    const u32 first_image_idx = image_infos.size();
    // GT_IMG_TRACE=1: one line per image binding of the three GT7 producer shaders, carrying the
    // journal seq so it JOINS the stall dump's "OLDEST-TICK ENTRY seq N" exactly. Written because
    // the parked dispatch (cs_0xda05e7f8, 4x4x6 - dims normal, data real, fences honest) can only
    // be waiting on ITS images: cs_img31 is a mip-fallback descriptor ARRAY indexed by
    // flatbuf[29], and an index past NumBindings is a GPU-side OOB descriptor read - parked
    // invocations, no CPU-visible fault, and only the deep-mip dispatches would break, which is
    // exactly the one-in-thousands profile.
    static const bool img_trace = [] {
        const char* v = std::getenv("GT_IMG_TRACE");
        return v && v[0] == '1';
    }();
    const bool trace_this =
        img_trace && (stage.pgm_hash == 0xda05e7f8u || stage.pgm_hash == 0x018256c0u ||
                      stage.pgm_hash == 0x2a0cfcd2u ||
                      // The two WINDOWED consumers (GT_BINDLESS_IMGARRAY) - until run 124 only
                      // the producers were traceable, so the data problem's own consumers were
                      // invisible to the one tool built for image questions.
                      stage.pgm_hash == 0xa95f906eu || stage.pgm_hash == 0x3e50e1u);
    if (trace_this) {
        const auto& fb = stage.flattened_ud_buf;
        LOG_CRITICAL(Render_Vulkan, "[imgtrace] seq {} cs {:#x}: fb29 {} fb39 {}",
                     instance.PeekGpuWorkSeq(), stage.pgm_hash,
                     fb.size() > 29 ? fb[29] : 0xdeadu, fb.size() > 39 ? fb[39] : 0xdeadu);
    }
    // For loading/storing to explicit mip levels, when no native instruction support, bind an array
    // of descriptors consecutively, 1 for each mip level. The shader can index this with LOD
    // operand.
    // This array holds the size of each consecutive array with the number of bindings consumed.
    // This is currently always 1 for anything other than mip fallback arrays.
    boost::container::small_vector<u32, 8> image_descriptor_array_sizes;

    // A torn T# can carry an ABSURD extent and still pass every other gate: run 144 died
    // asking VMA for 1024x1024 x 5249 layers of R8G8B8A8 (~22 GB) - address mapped, format
    // valid, and the OOM step-down could not save a request host memory cannot hold either.
    // Vulkan itself caps array layers at 2048 on desktop GPUs; past these bounds it is
    // garbage, not content -> null-bind the slot instead of asking the allocator.
    const auto sharp_extent_sane = [](const AmdGpu::Image& s) {
        const u64 w = u64(s.width) + 1;
        const u64 h = u64(s.height) + 1;
        const u64 d = s.GetType() == AmdGpu::ImageType::Color3D ? u64(s.depth) + 1 : 1;
        const u64 layers = s.NumLayers();
        return layers <= 2048 && (w * h * d * layers) <= (u64{1} << 31);
    };

    for (const auto& image_desc : stage.images) {
        const auto tsharp = image_desc.GetSharp(stage);
        // The set layout was built from the BAKED count (run 116); every path below must emit
        // exactly this many descriptors or the write lands past the layout's array.
        const u32 num_bindings = image_desc.NumBindingsBaked(stage);
        const auto null_bind_all = [&] {
            for (u32 i = 0; i < num_bindings; i++) {
                image_bindings.emplace_back(std::piecewise_construct, std::tuple{}, std::tuple{});
            }
            image_descriptor_array_sizes.push_back(num_bindings);
        };
        if (texture_cache.IsMeta(tsharp.Address())) {
            LOG_WARNING(Render_Vulkan, "Unexpected metadata read by a shader (texture)");
        }

        if (image_desc.IsWindowed()) {
            // GT_BINDLESS_IMGARRAY: every slot is its own T#, read fresh from the guest table
            // and guarded INDIVIDUALLY - the table may be half-written this frame, and one
            // dead slot must not kill the window (a null-bound slot reads zeros via
            // robustness2 nullDescriptor and self-heals next bind). A slot whose type class
            // disagrees with slot 0's - the type the module was specialized against this
            // draw - is null-bound too: binding it would mismatch the SPIR-V OpTypeImage.
            // ⚠ If slot 0 ITSELF is junk, GetSharp collapses it to Image::Null (Color2D/Unorm)
            // and that dummy class becomes the anchor: every genuinely-valid slot of another
            // class is then null-bound as well - one bad slot 0 can manufacture "15/16
            // null-bound". That rejection is REQUIRED for Vulkan validity (the module was
            // specialized on slot 0), so it is not "fixed" here - it is MEASURED: the
            // per-reason counters below say whether the nulls are absent data (addr0/unmapped)
            // or class mismatch against a possibly-junk anchor (viewtype/integer + slot0=NULL).
            const auto view_type0 = tsharp.GetViewType(image_desc.is_array);
            const bool integer0 = AmdGpu::IsInteger(tsharp.GetNumberFmt());
            // Slot 0's own structural validity, for the log: a null anchor taints the
            // viewtype/integer counters.
            const auto sharp0 = image_desc.GetSharpAt(stage, 0);
            const bool anchor_null = sharp0.Address() == 0;
            u32 null_slots = 0;
            u32 n_addr0 = 0, n_badfmt = 0, n_unmapped = 0, n_viewtype = 0, n_integer = 0;
            u32 valid_mask = 0;
            // GT_IMGARRAY_FB0=1 (record-time only - cache-safe to flip): a null slot in a
            // READ window binds the first VALID slot's image instead of the zero-reading
            // null descriptor. Mechanism probe for the sun-flood wash: post-FX dividing by
            // a zero sample goes to infinity = a white screen; a real texture of the same
            // type class (the validity test below enforces the class) is wrong-but-plausible
            // data instead. WRITE windows keep the null on purpose: aliasing dead slots onto
            // slot 0's image would corrupt its one real output.
            static const bool raster_fb0_enabled = [] {
                const char* v = std::getenv("GT_IMGARRAY_FB0");
                return v && v[0] == '1';
            }();
            s32 first_valid_at = -1;
            u32 n_fb0 = 0;
            for (u32 i = 0; i < num_bindings; i++) {
                const auto slot_sharp = image_desc.GetSharpAt(stage, i);
                // First failing clause only, so the reason counters sum to null_slots.
                // IsMappedMemory, not IsValidMapping: the VMA map contains FREE areas and a
                // torn T# in one passed the old test (the run-94 lesson, resource.h:96).
                const char* why = nullptr;
                if (slot_sharp.Address() == 0) {
                    why = "addr0", ++n_addr0;
                } else if (slot_sharp.GetDataFmt() == AmdGpu::DataFormat::FormatInvalid) {
                    why = "badfmt", ++n_badfmt;
                } else if (!sharp_extent_sane(slot_sharp)) {
                    why = "extent", ++n_badfmt; // folded into badfmt for the census
                } else if (!memory->IsMappedMemory(slot_sharp.Address())) {
                    why = "unmapped", ++n_unmapped;
                } else if (slot_sharp.GetViewType(image_desc.is_array) != view_type0) {
                    why = "viewtype", ++n_viewtype;
                } else if (AmdGpu::IsInteger(slot_sharp.GetNumberFmt()) != integer0) {
                    why = "integer", ++n_integer;
                }
                if (why != nullptr) {
                    if (raster_fb0_enabled && !image_desc.is_written && first_valid_at >= 0) {
                        // Copy through a local: emplacing a reference into the same container
                        // is the classic self-reference trap.
                        auto fb_copy = image_bindings[first_valid_at];
                        image_bindings.emplace_back(std::move(fb_copy));
                        ++n_fb0;
                    } else {
                        image_bindings.emplace_back(std::piecewise_construct, std::tuple{},
                                                    std::tuple{});
                    }
                    ++null_slots;
                    continue;
                }
                valid_mask |= 1u << i;
                auto& [image_id, desc] = image_bindings.emplace_back(
                    std::piecewise_construct, std::tuple{}, std::tuple{slot_sharp, image_desc});
                image_id = texture_cache.FindImage(desc);
                auto* image = &texture_cache.GetImage(image_id);
                if (auto depth_image_id = texture_cache.GetAssociatedDepth(*image)) {
                    image_id = depth_image_id;
                    image = &texture_cache.GetImage(image_id);
                }
                if (image->binding.is_bound) {
                    image->binding.force_general |= image_desc.is_written;
                }
                image->binding.is_bound = 1u;
                if (first_valid_at < 0) {
                    first_valid_at = static_cast<s32>(image_bindings.size() - 1);
                }
            }
            if (null_slots != 0) {
                // Per-shader budget: the old 32-lines-per-RUN cap could not answer the one
                // question that matters ("do the tables fill in later?"). First 8 occurrences
                // per shader, then 1 in 256 - late samples ARE the self-heal measurement.
                // BindTextures runs on the single GpuCommandProcessor thread; no lock needed.
                static std::unordered_map<u64, u32> imgarray_logged;
                u32& seen = imgarray_logged[stage.pgm_hash];
                ++seen;
                const u64 table_va =
                    stage.buffers[image_desc.deref_buffer].GetSharp(stage).base_address +
                    image_desc.window_base_bytes;
                // LATE RE-READ PROBE: the record-time snapshot may simply be EARLY - the GPU
                // fills these ring tables later in the same frame. Re-reading the PREVIOUS
                // occurrence's table now (typically one dispatch later) says whether the
                // null slots were absent data or merely not-written-YET. This is the one
                // measurement that separates "table genuinely sparse" from "we read too soon".
                struct RasterPrevTable {
                    u64 table_va;
                    u32 stride;
                    u32 null_mask;
                    bool r128;
                };
                static std::unordered_map<u64, RasterPrevTable> imgarray_prev;
                u32 late_filled = 0, late_checked = 0;
                if (const auto it = imgarray_prev.find(stage.pgm_hash);
                    it != imgarray_prev.end() && !it->second.r128) {
                    for (u32 s = 0; s < 32; ++s) {
                        if (!(it->second.null_mask & (1u << s))) {
                            continue;
                        }
                        const u64 addr = it->second.table_va + u64(s) * it->second.stride;
                        ++late_checked;
                        if (!memory->IsMappedMemory(addr, sizeof(AmdGpu::Image))) {
                            continue;
                        }
                        AmdGpu::Image probe{};
                        std::memcpy(&probe, reinterpret_cast<const void*>(addr), sizeof(probe));
                        const u64 pva = probe.Address();
                        if (pva >= 0x10000 && pva + 4096 < (u64{1} << 40) && probe.Valid()) {
                            ++late_filled;
                        }
                    }
                }
                const u32 all_mask = num_bindings >= 32 ? ~0u : ((1u << num_bindings) - 1u);
                imgarray_prev[stage.pgm_hash] = {table_va, image_desc.window_stride_bytes,
                                                 all_mask & ~valid_mask, image_desc.is_r128};
                if (seen <= 8 || (seen & 255u) == 0) {
                    LOG_WARNING(Render_Vulkan,
                                "[imgarray] seq {} shader {:#x}: {}/{} null (addr0 {} badfmt {} "
                                "unmapped {} viewtype {} integer {}) valid {:#06x} fb0 {} late "
                                "{}/{} anchor vt{}/int{}{} table {:#x} (buffer {} base {} stride "
                                "{}) n={}",
                                instance.PeekGpuWorkSeq(), stage.pgm_hash, null_slots,
                                num_bindings, n_addr0, n_badfmt, n_unmapped, n_viewtype,
                                n_integer, valid_mask, n_fb0, late_filled, late_checked,
                                static_cast<u32>(view_type0), integer0 ? 1 : 0,
                                anchor_null ? " (NULL-anchor)" : "", table_va,
                                image_desc.deref_buffer, image_desc.window_base_bytes,
                                image_desc.window_stride_bytes, seen);
                }
            }
            image_descriptor_array_sizes.push_back(num_bindings);
            continue;
        }

        if (tsharp.Address() == 0 || tsharp.GetDataFmt() == AmdGpu::DataFormat::FormatInvalid ||
            !sharp_extent_sane(tsharp)) {
            null_bind_all();
            continue;
        }
        if (!memory->IsValidMapping(tsharp.Address())) {
            // A torn T# (same disease as the softclamp V# case): the address is nonzero but
            // nothing is mapped there - the game has not written this descriptor yet. FindImage
            // would die in ClampRangeSize; null-bind one frame instead, loudly.
            LOG_CRITICAL(Render_Vulkan,
                         "[softclamp] shader {:#x}: T# address {:#x} unmapped - null-bound",
                         stage.pgm_hash, tsharp.Address());
            null_bind_all();
            continue;
        }
        // MEASUREMENT ONLY (the windowed path above already switched): IsValidMapping answers
        // "inside the VMA map", which includes FREE areas (run 94) - IsMappedMemory is the
        // honest test. Before changing this game-wide behavior, count how often they disagree.
        if (!memory->IsMappedMemory(tsharp.Address())) {
            static u32 diverged = 0;
            if (++diverged <= 16) {
                LOG_CRITICAL(Render_Vulkan,
                             "[softclamp] shader {:#x}: T# address {:#x} passes IsValidMapping "
                             "but FAILS IsMappedMemory (free VMA) - would fault ({} so far)",
                             stage.pgm_hash, tsharp.Address(), diverged);
            }
        }

        const Shader::MipStorageFallbackMode mip_fallback_mode = image_desc.mip_fallback_mode;
        const u32 live_bindings = image_desc.NumBindings(stage);
        if (live_bindings != num_bindings) {
            // The live T# disagrees with the count the module/layout were compiled against.
            // With everything pinned to the baked count this is a stale frame, never an OOB
            // descriptor - but it is the run-116 mechanism firing, so it must be visible.
            static u32 logged = 0;
            if (logged < 16) {
                ++logged;
                LOG_CRITICAL(Render_Vulkan,
                             "[mipbake] shader {:#x}: live mip bindings {} != baked {} "
                             "(T# {:#x}, mips {}..{})",
                             stage.pgm_hash, live_bindings, num_bindings, tsharp.Address(),
                             static_cast<u32>(tsharp.base_level),
                             static_cast<u32>(tsharp.last_level));
            }
        }

        for (auto i = 0; i < num_bindings; i++) {
            auto& [image_id, desc] = image_bindings.emplace_back(
                std::piecewise_construct, std::tuple{}, std::tuple{tsharp, image_desc});

            if (mip_fallback_mode == Shader::MipStorageFallbackMode::ConstantIndex) {
                ASSERT(num_bindings == 1);
                desc.view_info.range.base.level += image_desc.constant_mip_index;
                desc.view_info.range.extent.levels = 1;
            } else if (mip_fallback_mode == Shader::MipStorageFallbackMode::DynamicIndex) {
                // Slots past the live mip chain duplicate the last real level (same philosophy
                // as the shader-side OpUMin) instead of creating a view of a level that does
                // not exist this frame. live_bindings is derived from a live T# and can be
                // garbage (last_level < base_level wraps u32) - clamp it to [1, baked] first.
                const u32 last_live = std::clamp<u32>(live_bindings, 1u, num_bindings) - 1;
                desc.view_info.range.base.level += std::min(static_cast<u32>(i), last_live);
                desc.view_info.range.extent.levels = 1;
            }

            image_id = texture_cache.FindImage(desc);
            auto* image = &texture_cache.GetImage(image_id);
            if (trace_this) {
                LOG_CRITICAL(Render_Vulkan,
                             "[imgtrace]   img: va {:#x} dfmt {} type {} bindings {} bind_i {} "
                             "mips {} base_mip {}",
                             tsharp.Address(), static_cast<u32>(tsharp.GetDataFmt()),
                             static_cast<u32>(desc.type), num_bindings, i,
                             static_cast<u32>(tsharp.last_level - tsharp.base_level + 1),
                             static_cast<u32>(desc.view_info.range.base.level));
            }
            if (auto depth_image_id = texture_cache.GetAssociatedDepth(*image)) {
                // If this image has an associated depth image, it's a stencil attachment.
                // Redirect the access to the actual depth-stencil buffer.
                image_id = depth_image_id;
                image = &texture_cache.GetImage(image_id);
            }
            if (image->binding.is_bound) {
                // The image is already bound. In case if it is about to be used as storage we
                // need to force general layout on it.
                image->binding.force_general |= image_desc.is_written;
            }
            image->binding.is_bound = 1u;
        }

        image_descriptor_array_sizes.push_back(num_bindings);
    }

    // Second pass to re-bind images that were updated after binding
    for (auto& [image_id, desc] : image_bindings) {
        bool is_storage = desc.type == VideoCore::TextureCache::BindingType::Storage;
        if (!image_id) {
            image_infos.emplace_back(VK_NULL_HANDLE, VK_NULL_HANDLE, vk::ImageLayout::eGeneral);
        } else {
            if (auto& old_image = texture_cache.GetImage(image_id);
                old_image.binding.needs_rebind) {
                old_image.binding = {};
                image_id = texture_cache.FindImage(desc);
            }

            bound_images.emplace_back(image_id);

            auto& image = texture_cache.GetImage(image_id);
            auto& image_view = texture_cache.FindTexture(image_id, desc);

            // The image is either bound as storage in a separate descriptor or bound as render
            // target in feedback loop. Depth images are excluded because they can't be bound as
            // storage and feedback loop doesn't make sense for them
            if ((image.binding.force_general || image.binding.is_target) &&
                !image.info.props.is_depth) {
                image.Transit(instance.IsAttachmentFeedbackLoopLayoutSupported() &&
                                      image.binding.is_target
                                  ? vk::ImageLayout::eAttachmentFeedbackLoopOptimalEXT
                                  : vk::ImageLayout::eGeneral,
                              vk::AccessFlagBits2::eShaderRead |
                                  (image.info.props.is_depth
                                       ? vk::AccessFlagBits2::eDepthStencilAttachmentWrite
                                       : vk::AccessFlagBits2::eColorAttachmentWrite |
                                             vk::AccessFlagBits2::eColorAttachmentRead),
                              {});
            } else {
                if (is_storage) {
                    image.Transit(vk::ImageLayout::eGeneral,
                                  vk::AccessFlagBits2::eShaderRead |
                                      vk::AccessFlagBits2::eShaderWrite,
                                  desc.view_info.range);
                } else {
                    const auto new_layout = image.info.props.is_depth
                                                ? vk::ImageLayout::eDepthStencilReadOnlyOptimal
                                                : vk::ImageLayout::eShaderReadOnlyOptimal;
                    image.Transit(new_layout, vk::AccessFlagBits2::eShaderRead,
                                  desc.view_info.range);
                }
            }
            image.usage.storage |= is_storage;
            image.usage.texture |= !is_storage;

            image_infos.emplace_back(VK_NULL_HANDLE, *image_view.image_view,
                                     image.backing->state.layout);
        }
    }

    u32 image_info_idx = first_image_idx;
    u32 image_binding_idx = 0;
    u32 image_res_idx = 0;
    for (u32 array_size : image_descriptor_array_sizes) {
        // The set LAYOUT's descriptorType came from the shader-side resource
        // (is_written ? eStorageImage : eSampledImage - vk_compute_pipeline.cpp /
        // vk_graphics_pipeline.cpp). Deriving the WRITE's type from array element 0's
        // ImageDesc broke the moment element 0 was NULL-BOUND: that desc is
        // default-constructed (type = Texture), so a storage window whose slot 0 happened to
        // be null was pushed as eSampledImage against an eStorageImage binding - invalid
        // Vulkan for the WHOLE window, every draw (cs_a95f906e, the red-map shader, is a
        // storage window measured at 15/16 nulls). image_descriptor_array_sizes is 1:1 with
        // stage.images (every branch above pushes exactly one entry), so index the resource
        // and take the same answer the layout took.
        const bool is_storage = stage.images[image_res_idx++].is_written;
        auto& set_write = set_writes[set_write_index++];
        set_write.dstSet = VK_NULL_HANDLE;
        set_write.dstBinding = binding.unified;
        set_write.dstArrayElement = 0;
        set_write.descriptorCount = array_size;
        set_write.descriptorType =
            is_storage ? vk::DescriptorType::eStorageImage : vk::DescriptorType::eSampledImage;
        set_write.pImageInfo = &image_infos[image_info_idx];

        image_info_idx += array_size;
        image_binding_idx += array_size;
        binding.unified += array_size;
    }

    for (const auto& sampler : stage.samplers) {
        auto ssharp = sampler.GetSharp(stage);
        if (sampler.disable_aniso) {
            const auto& tsharp = stage.images[sampler.associated_image].GetSharp(stage);
            if (tsharp.base_level == 0 && tsharp.last_level == 0) {
                ssharp.max_aniso.Assign(AmdGpu::AnisoRatio::One);
            }
        }
        const auto vk_sampler = texture_cache.GetSampler(ssharp, liverpool->regs.ta_bc_base);
        image_infos.emplace_back(vk_sampler, VK_NULL_HANDLE, vk::ImageLayout::eGeneral);
        auto& set_write = set_writes[set_write_index++];
        set_write.dstSet = VK_NULL_HANDLE;
        set_write.dstBinding = binding.unified++;
        set_write.dstArrayElement = 0;
        set_write.descriptorCount = 1;
        set_write.descriptorType = vk::DescriptorType::eSampler;
        set_write.pImageInfo = &image_infos.back();
    }
}

RenderState Rasterizer::BeginRendering(const GraphicsPipeline* pipeline) {
    attachment_feedback_loop = false;
    const auto& regs = liverpool->regs;
    const auto& key = pipeline->GetGraphicsKey();
    RenderState state;
    state.width = instance.GetMaxFramebufferWidth();
    state.height = instance.GetMaxFramebufferHeight();
    state.num_layers = std::numeric_limits<u16>::max();
    state.num_color_attachments = std::bit_width(key.mrt_mask);
    for (auto cb = 0u; cb < state.num_color_attachments; ++cb) {
        auto& [image_id, desc] = cb_descs[cb];
        if (!image_id) {
            state.color_attachments[cb] = {};
            continue;
        }
        auto* image = &texture_cache.GetImage(image_id);
        if (image->binding.needs_rebind) {
            image_id = bound_images.emplace_back(texture_cache.FindImage(desc));
            image = &texture_cache.GetImage(image_id);
        }
        texture_cache.UpdateImage(image_id);
        image->SetBackingSamples(key.color_samples[cb]);
        const auto& image_view = texture_cache.FindRenderTarget(image_id, desc);
        const auto slice = image_view.info.range.base.layer;
        const auto mip = image_view.info.range.base.level;

        const auto& col_buf = regs.color_buffers[cb];
        const bool is_clear = texture_cache.IsMetaCleared(col_buf.CmaskAddress(), slice);
        texture_cache.TouchMeta(col_buf.CmaskAddress(), slice, false);

        if (image->binding.is_bound) {
            ASSERT_MSG(!image->binding.force_general,
                       "Having image both as storage and render target is unsupported");
            image->Transit(instance.IsAttachmentFeedbackLoopLayoutSupported()
                               ? vk::ImageLayout::eAttachmentFeedbackLoopOptimalEXT
                               : vk::ImageLayout::eGeneral,
                           vk::AccessFlagBits2::eColorAttachmentWrite, {});
            attachment_feedback_loop = true;
        } else {
            image->Transit(vk::ImageLayout::eColorAttachmentOptimal,
                           vk::AccessFlagBits2::eColorAttachmentWrite |
                               vk::AccessFlagBits2::eColorAttachmentRead,
                           desc.view_info.range);
        }

        state.width = std::min<u32>(state.width, std::max(image->info.size.width >> mip, 1u));
        state.height = std::min<u32>(state.height, std::max(image->info.size.height >> mip, 1u));
        state.num_layers = std::min<u32>(state.num_layers, image_view.info.range.extent.layers);

        const auto clear_value =
            is_clear ? LiverpoolToVK::ColorBufferClearValue(col_buf) : vk::ClearValue{};
        auto& attachment = state.color_attachments[cb];
        attachment.image_view = *image_view.image_view;
        attachment.image_layout = image->backing->state.layout;
        attachment.clear_value = clear_value.color.uint32;
        attachment.is_clear = is_clear;

        image->usage.render_target = 1u;
    }
    for (u32 cb = state.num_color_attachments; cb < state.color_attachments.size(); ++cb) {
        state.color_attachments[cb] = {};
    }

    if (auto image_id = db_desc.first; image_id) {
        auto& desc = db_desc.second;
        const auto htile_address = regs.depth_htile_data_base.GetAddress();
        const auto& image_view = texture_cache.FindDepthTarget(image_id, desc);
        auto& image = texture_cache.GetImage(image_id);

        const auto slice = image_view.info.range.base.layer;
        const bool is_depth_clear =
            (regs.depth_render_control.depth_clear_enable && regs.depth_control.depth_enable &&
             regs.depth_control.depth_write_enable) ||
            texture_cache.IsMetaCleared(htile_address, slice);
        const bool is_stencil_clear = regs.depth_render_control.stencil_clear_enable;
        texture_cache.TouchMeta(htile_address, slice, false);
        ASSERT(desc.view_info.range.extent.levels == 1 && !image.binding.needs_rebind);

        const bool has_stencil = image.info.props.has_stencil;
        // Stencil writes can be enabled while depth writes are off.
        const bool stencil_write =
            has_stencil && regs.depth_control.stencil_enable && !desc.view_info.is_storage;
        const auto new_layout = desc.view_info.is_storage
                                    ? has_stencil ? vk::ImageLayout::eDepthStencilAttachmentOptimal
                                                  : vk::ImageLayout::eDepthAttachmentOptimal
                                : stencil_write
                                    ? vk::ImageLayout::eDepthReadOnlyStencilAttachmentOptimal
                                : has_stencil ? vk::ImageLayout::eDepthStencilReadOnlyOptimal
                                              : vk::ImageLayout::eDepthReadOnlyOptimal;
        image.Transit(new_layout,
                      vk::AccessFlagBits2::eDepthStencilAttachmentWrite |
                          vk::AccessFlagBits2::eDepthStencilAttachmentRead,
                      desc.view_info.range);

        state.width = std::min<u32>(state.width, image.info.size.width);
        state.height = std::min<u32>(state.height, image.info.size.height);
        state.num_layers = std::min<u32>(state.num_layers, image_view.info.range.extent.layers);

        auto& attachment = state.depth_stencil_attachment;
        attachment.image_view = *image_view.image_view;
        attachment.image_layout = image.backing->state.layout;
        attachment.clear_value = {};

        if (regs.depth_buffer.DepthValid()) {
            attachment.clear_value[0] = is_depth_clear ? std::bit_cast<u32>(regs.depth_clear) : 0u;
            attachment.has_depth = true;
            attachment.depth_clear = is_depth_clear;
        }
        if (regs.depth_buffer.StencilValid()) {
            attachment.clear_value[1] = is_stencil_clear ? regs.stencil_clear : 0u;
            attachment.has_stencil = true;
            attachment.stencil_clear = is_stencil_clear;
        }

        image.usage.depth_target = true;
    } else {
        state.depth_stencil_attachment = {};
    }

    if (state.num_layers == std::numeric_limits<u16>::max()) {
        state.num_layers = 1;
    }

    return state;
}

void Rasterizer::Resolve() {
    const auto& mrt0_hint = liverpool->last_cb_extent[0];
    const auto& mrt1_hint = liverpool->last_cb_extent[1];
    VideoCore::TextureCache::ImageDesc mrt0_desc{liverpool->regs.color_buffers[0], mrt0_hint};
    VideoCore::TextureCache::ImageDesc mrt1_desc{liverpool->regs.color_buffers[1], mrt1_hint};
    auto& mrt0_image = texture_cache.GetImage(texture_cache.FindImage(mrt0_desc, true));
    auto& mrt1_image = texture_cache.GetImage(texture_cache.FindImage(mrt1_desc, true));

    ScopeMarkerBegin(fmt::format("Resolve:MRT0={:#x}:MRT1={:#x}",
                                 liverpool->regs.color_buffers[0].Address(),
                                 liverpool->regs.color_buffers[1].Address()));
    mrt1_image.Resolve(mrt0_image, mrt0_desc.view_info.range, mrt1_desc.view_info.range);
    ScopeMarkerEnd();
}

void Rasterizer::DepthStencilCopy(bool is_depth, bool is_stencil) {
    auto& regs = liverpool->regs;

    auto read_desc = VideoCore::TextureCache::ImageDesc(
        regs.depth_buffer, regs.depth_view, regs.depth_control,
        regs.depth_htile_data_base.GetAddress(), liverpool->last_db_extent, false);
    auto write_desc = VideoCore::TextureCache::ImageDesc(
        regs.depth_buffer, regs.depth_view, regs.depth_control,
        regs.depth_htile_data_base.GetAddress(), liverpool->last_db_extent, true);

    auto& read_image = texture_cache.GetImage(texture_cache.FindImage(read_desc));
    auto& write_image = texture_cache.GetImage(texture_cache.FindImage(write_desc));

    VideoCore::SubresourceRange sub_range;
    sub_range.base.layer = liverpool->regs.depth_view.slice_start;
    sub_range.extent.layers = liverpool->regs.depth_view.NumSlices() - sub_range.base.layer;

    ScopeMarkerBegin(fmt::format(
        "DepthStencilCopy:DR={:#x}:SR={:#x}:DW={:#x}:SW={:#x}", regs.depth_buffer.DepthAddress(),
        regs.depth_buffer.StencilAddress(), regs.depth_buffer.DepthWriteAddress(),
        regs.depth_buffer.StencilWriteAddress()));

    read_image.Transit(vk::ImageLayout::eTransferSrcOptimal, vk::AccessFlagBits2::eTransferRead,
                       sub_range);
    write_image.Transit(vk::ImageLayout::eTransferDstOptimal, vk::AccessFlagBits2::eTransferWrite,
                        sub_range);

    auto aspect_mask = vk::ImageAspectFlags(0);
    if (is_depth) {
        aspect_mask |= vk::ImageAspectFlagBits::eDepth;
    }
    if (is_stencil) {
        aspect_mask |= vk::ImageAspectFlagBits::eStencil;
    }

    vk::ImageCopy region = {
        .srcSubresource =
            {
                .aspectMask = aspect_mask,
                .mipLevel = 0,
                .baseArrayLayer = sub_range.base.layer,
                .layerCount = sub_range.extent.layers,
            },
        .srcOffset = {0, 0, 0},
        .dstSubresource =
            {
                .aspectMask = aspect_mask,
                .mipLevel = 0,
                .baseArrayLayer = sub_range.base.layer,
                .layerCount = sub_range.extent.layers,
            },
        .dstOffset = {0, 0, 0},
        .extent = {write_image.info.size.width, write_image.info.size.height, 1},
    };
    scheduler.CommandBuffer().copyImage(read_image.GetImage(), vk::ImageLayout::eTransferSrcOptimal,
                                        write_image.GetImage(),
                                        vk::ImageLayout::eTransferDstOptimal, region);

    ScopeMarkerEnd();
}

void Rasterizer::FillBuffer(VAddr address, u32 num_bytes, u32 value, bool is_gds) {
    buffer_cache.FillBuffer(address, num_bytes, value, is_gds);
}

void Rasterizer::CopyBuffer(VAddr dst, VAddr src, u32 num_bytes, bool dst_gds, bool src_gds) {
    buffer_cache.CopyBuffer(dst, src, num_bytes, dst_gds, src_gds);
}

u32 Rasterizer::ReadDataFromGds(u32 gds_offset) {
    auto* gds_buf = buffer_cache.GetGdsBuffer();
    u32 value;
    std::memcpy(&value, gds_buf->mapped_data.data() + gds_offset, sizeof(u32));
    return value;
}

bool Rasterizer::InvalidateMemory(VAddr addr, u64 size) {
    if (!IsMapped(addr, size)) {
        // Not GPU mapped memory, can skip invalidation logic entirely.
        return false;
    }
    buffer_cache.InvalidateMemory(addr, size);
    texture_cache.InvalidateMemory(addr, size);
    return true;
}

bool Rasterizer::ReadMemory(VAddr addr, u64 size) {
    if (!IsMapped(addr, size)) {
        // Not GPU mapped memory, can skip invalidation logic entirely.
        return false;
    }
    buffer_cache.ReadMemory(addr, size);
    return true;
}

void Rasterizer::ProcessDownloadImages() {
    texture_cache.ProcessDownloadImages();
}

bool Rasterizer::IsMapped(VAddr addr, u64 size) {
    if (size == 0) {
        // There is no memory, so not mapped.
        return false;
    }
    if (static_cast<u64>(addr) > std::numeric_limits<u64>::max() - size) {
        // Memory range wrapped the address space, cannot be mapped.
        return false;
    }
    const auto range = decltype(mapped_ranges)::interval_type::right_open(addr, addr + size);

    Common::RecursiveSharedLock lock{mapped_ranges_mutex};
    return boost::icl::contains(mapped_ranges, range);
}

void Rasterizer::MapMemory(VAddr addr, u64 size) {
    {
        std::scoped_lock lock{mapped_ranges_mutex};
        mapped_ranges += decltype(mapped_ranges)::interval_type::right_open(addr, addr + size);
    }
    page_manager.OnGpuMap(addr, size);
}

void Rasterizer::UnmapMemory(VAddr addr, u64 size) {
    buffer_cache.InvalidateMemory(addr, size);
    texture_cache.UnmapMemory(addr, size);
    page_manager.OnGpuUnmap(addr, size);
    {
        std::scoped_lock lock{mapped_ranges_mutex};
        mapped_ranges -= decltype(mapped_ranges)::interval_type::right_open(addr, addr + size);
    }
}

void Rasterizer::UpdateDynamicState(const GraphicsPipeline* pipeline, const bool is_indexed) const {
    UpdateViewportScissorState();
    UpdateDepthStencilState();
    UpdatePrimitiveState(is_indexed);
    UpdateRasterizationState();
    UpdateColorBlendingState(pipeline);

    auto& dynamic_state = scheduler.GetDynamicState();
    dynamic_state.Commit(instance, scheduler.CommandBuffer());
}

void Rasterizer::UpdateViewportScissorState() const {
    const auto& regs = liverpool->regs;

    const auto combined_scissor_value_tl = [](s16 scr, s16 win, s16 gen, s16 win_offset) {
        return std::max({scr, s16(win + win_offset), s16(gen + win_offset)});
    };
    const auto combined_scissor_value_br = [](s16 scr, s16 win, s16 gen, s16 win_offset) {
        return std::min({scr, s16(win + win_offset), s16(gen + win_offset)});
    };
    const bool enable_offset = !regs.window_scissor.window_offset_disable;

    AmdGpu::Scissor scsr{};
    scsr.top_left_x = combined_scissor_value_tl(
        regs.screen_scissor.top_left_x, s16(regs.window_scissor.top_left_x),
        s16(regs.generic_scissor.top_left_x),
        enable_offset ? regs.window_offset.window_x_offset : 0);
    scsr.top_left_y = combined_scissor_value_tl(
        regs.screen_scissor.top_left_y, s16(regs.window_scissor.top_left_y),
        s16(regs.generic_scissor.top_left_y),
        enable_offset ? regs.window_offset.window_y_offset : 0);
    scsr.bottom_right_x = combined_scissor_value_br(
        regs.screen_scissor.bottom_right_x, regs.window_scissor.bottom_right_x,
        regs.generic_scissor.bottom_right_x,
        enable_offset ? regs.window_offset.window_x_offset : 0);
    scsr.bottom_right_y = combined_scissor_value_br(
        regs.screen_scissor.bottom_right_y, regs.window_scissor.bottom_right_y,
        regs.generic_scissor.bottom_right_y,
        enable_offset ? regs.window_offset.window_y_offset : 0);

    boost::container::static_vector<vk::Viewport, AmdGpu::NUM_VIEWPORTS> viewports;
    boost::container::static_vector<vk::Rect2D, AmdGpu::NUM_VIEWPORTS> scissors;

    if (regs.polygon_control.enable_window_offset &&
        (regs.window_offset.window_x_offset != 0 || regs.window_offset.window_y_offset != 0)) {
        LOG_ERROR(Render_Vulkan,
                  "PA_SU_SC_MODE_CNTL.VTX_WINDOW_OFFSET_ENABLE support is not yet implemented.");
    }

    const auto& vp_ctl = regs.viewport_control;
    for (u32 i = 0; i < AmdGpu::NUM_VIEWPORTS; i++) {
        const auto& vp = regs.viewports[i];
        const auto& vp_d = regs.viewport_depths[i];
        if (vp.xscale == 0) {
            continue;
        }

        const auto zoffset = vp_ctl.zoffset_enable ? vp.zoffset : 0.f;
        const auto zscale = vp_ctl.zscale_enable ? vp.zscale : 1.f;

        vk::Viewport viewport{};

        // https://gitlab.freedesktop.org/mesa/mesa/-/blob/209a0ed/src/amd/vulkan/radv_pipeline_graphics.c#L688-689
        // https://gitlab.freedesktop.org/mesa/mesa/-/blob/209a0ed/src/amd/vulkan/radv_cmd_buffer.c#L3103-3109
        // When the clip space is ranged [-1...1], the zoffset is centered.
        // By reversing the above viewport calculations, we get the following:
        if (regs.clipper_control.clip_space == AmdGpu::ClipSpace::MinusWToW) {
            viewport.minDepth = zoffset - zscale;
            viewport.maxDepth = zoffset + zscale;
        } else {
            viewport.minDepth = zoffset;
            viewport.maxDepth = zoffset + zscale;
        }

        if (!instance.IsDepthRangeUnrestrictedSupported()) {
            // Unrestricted depth range not supported by device. Restrict to valid range.
            viewport.minDepth = std::max(viewport.minDepth, 0.f);
            viewport.maxDepth = std::min(viewport.maxDepth, 1.f);
        }

        if (regs.IsClipDisabled()) {
            // In case if clipping is disabled we patch the shader to convert vertex position
            // from screen space coordinates to NDC by defining a render space as full hardware
            // window range [0..16383, 0..16383] and setting the viewport to its size.
            viewport.x = 0.f;
            viewport.y = 0.f;
            viewport.width = float(std::min<u32>(instance.GetMaxViewportWidth(), 16_KB));
            viewport.height = float(std::min<u32>(instance.GetMaxViewportHeight(), 16_KB));
        } else {
            const auto xoffset = vp_ctl.xoffset_enable ? vp.xoffset : 0.f;
            const auto xscale = vp_ctl.xscale_enable ? vp.xscale : 1.f;
            const auto yoffset = vp_ctl.yoffset_enable ? vp.yoffset : 0.f;
            const auto yscale = vp_ctl.yscale_enable ? vp.yscale : 1.f;

            viewport.x = xoffset - xscale;
            viewport.y = yoffset - yscale;
            viewport.width = xscale * 2.0f;
            viewport.height = yscale * 2.0f;
        }

        viewports.push_back(viewport);

        auto vp_scsr = scsr;
        if (regs.mode_control.vport_scissor_enable) {
            vp_scsr.top_left_x =
                std::max(vp_scsr.top_left_x, s16(regs.viewport_scissors[i].top_left_x));
            vp_scsr.top_left_y =
                std::max(vp_scsr.top_left_y, s16(regs.viewport_scissors[i].top_left_y));
            vp_scsr.bottom_right_x = std::min(AmdGpu::Scissor::Clamp(vp_scsr.bottom_right_x),
                                              regs.viewport_scissors[i].bottom_right_x);
            vp_scsr.bottom_right_y = std::min(AmdGpu::Scissor::Clamp(vp_scsr.bottom_right_y),
                                              regs.viewport_scissors[i].bottom_right_y);
        }
        scissors.push_back({
            .offset = {vp_scsr.top_left_x, vp_scsr.top_left_y},
            .extent = {vp_scsr.GetWidth(), vp_scsr.GetHeight()},
        });
    }

    if (viewports.empty()) {
        // Vulkan requires providing at least one viewport.
        constexpr vk::Viewport empty_viewport = {
            .x = -1.0f,
            .y = -1.0f,
            .width = 1.0f,
            .height = 1.0f,
            .minDepth = 0.0f,
            .maxDepth = 1.0f,
        };
        constexpr vk::Rect2D empty_scissor = {
            .offset = {0, 0},
            .extent = {1, 1},
        };
        viewports.push_back(empty_viewport);
        scissors.push_back(empty_scissor);
    }

    auto& dynamic_state = scheduler.GetDynamicState();
    dynamic_state.SetViewports(viewports);
    dynamic_state.SetScissors(scissors);
}

void Rasterizer::UpdateDepthStencilState() const {
    const auto& regs = liverpool->regs;
    auto& dynamic_state = scheduler.GetDynamicState();

    const auto depth_test_enabled =
        regs.depth_control.depth_enable && regs.depth_buffer.DepthValid();
    dynamic_state.SetDepthTestEnabled(depth_test_enabled);
    if (depth_test_enabled) {
        dynamic_state.SetDepthWriteEnabled(regs.depth_control.depth_write_enable &&
                                           !regs.depth_render_control.depth_clear_enable);
        dynamic_state.SetDepthCompareOp(LiverpoolToVK::CompareOp(regs.depth_control.depth_func));
    }

    const auto depth_bounds_test_enabled = regs.depth_control.depth_bounds_enable;
    dynamic_state.SetDepthBoundsTestEnabled(depth_bounds_test_enabled);
    if (depth_bounds_test_enabled) {
        dynamic_state.SetDepthBounds(regs.depth_bounds_min, regs.depth_bounds_max);
    }

    const auto depth_bias_enabled = regs.polygon_control.NeedsBias();
    dynamic_state.SetDepthBiasEnabled(depth_bias_enabled);
    if (depth_bias_enabled) {
        const bool front = regs.polygon_control.enable_polygon_offset_front;
        dynamic_state.SetDepthBias(
            front ? regs.poly_offset.front_offset : regs.poly_offset.back_offset,
            regs.poly_offset.depth_bias,
            (front ? regs.poly_offset.front_scale : regs.poly_offset.back_scale) / 16.f);
    }

    const auto stencil_test_enabled =
        regs.depth_control.stencil_enable && regs.depth_buffer.StencilValid();
    dynamic_state.SetStencilTestEnabled(stencil_test_enabled);
    if (stencil_test_enabled) {
        const StencilOps front_ops{
            .fail_op = LiverpoolToVK::StencilOp(regs.stencil_control.stencil_fail_front),
            .pass_op = LiverpoolToVK::StencilOp(regs.stencil_control.stencil_zpass_front),
            .depth_fail_op = LiverpoolToVK::StencilOp(regs.stencil_control.stencil_zfail_front),
            .compare_op = LiverpoolToVK::CompareOp(regs.depth_control.stencil_ref_func),
        };
        const StencilOps back_ops = regs.depth_control.backface_enable ? StencilOps{
            .fail_op = LiverpoolToVK::StencilOp(regs.stencil_control.stencil_fail_back),
            .pass_op = LiverpoolToVK::StencilOp(regs.stencil_control.stencil_zpass_back),
            .depth_fail_op = LiverpoolToVK::StencilOp(regs.stencil_control.stencil_zfail_back),
            .compare_op = LiverpoolToVK::CompareOp(regs.depth_control.stencil_bf_func),
        } : front_ops;
        dynamic_state.SetStencilOps(front_ops, back_ops);

        const bool stencil_clear = regs.depth_render_control.stencil_clear_enable;
        const auto front = regs.stencil_ref_front;
        const auto back =
            regs.depth_control.backface_enable ? regs.stencil_ref_back : regs.stencil_ref_front;
        // GCN REPLACE_OP writes DB_STENCILREFMASK.STENCILOPVAL, so a face whose stencil ops
        // include ReplaceOp takes its Vulkan reference from op_val.
        const auto& sc = regs.stencil_control;
        const auto uses_op_val = [](AmdGpu::StencilFunc fail, AmdGpu::StencilFunc zpass,
                                    AmdGpu::StencilFunc zfail) {
            return fail == AmdGpu::StencilFunc::ReplaceOp ||
                   zpass == AmdGpu::StencilFunc::ReplaceOp ||
                   zfail == AmdGpu::StencilFunc::ReplaceOp;
        };
        const bool front_op =
            uses_op_val(sc.stencil_fail_front, sc.stencil_zpass_front, sc.stencil_zfail_front);
        const bool back_op =
            regs.depth_control.backface_enable
                ? uses_op_val(sc.stencil_fail_back, sc.stencil_zpass_back, sc.stencil_zfail_back)
                : front_op;
        const auto ref_conflict = [](AmdGpu::CompareFunc func, const AmdGpu::StencilRefMask& ref) {
            return func != AmdGpu::CompareFunc::Always && func != AmdGpu::CompareFunc::Never &&
                   ref.stencil_test_val != ref.stencil_op_val;
        };
        if ((front_op && ref_conflict(regs.depth_control.stencil_ref_func, front)) ||
            (back_op && regs.depth_control.backface_enable &&
             ref_conflict(regs.depth_control.stencil_bf_func, back))) {
            LOG_WARNING(Render_Vulkan, "Stencil test requires test_val while ReplaceOp requires "
                                       "op_val; the stencil test will use op_val");
        }
        dynamic_state.SetStencilReferences(front_op ? front.stencil_op_val : front.stencil_test_val,
                                           back_op ? back.stencil_op_val : back.stencil_test_val);
        dynamic_state.SetStencilWriteMasks(!stencil_clear ? front.stencil_write_mask : 0U,
                                           !stencil_clear ? back.stencil_write_mask : 0U);
        dynamic_state.SetStencilCompareMasks(front.stencil_mask, back.stencil_mask);
    }
}

void Rasterizer::UpdatePrimitiveState(const bool is_indexed) const {
    const auto& regs = liverpool->regs;
    auto& dynamic_state = scheduler.GetDynamicState();

    const auto is_list_topology = [](const AmdGpu::PrimitiveType type) {
        const auto topology = LiverpoolToVK::PrimitiveType(type);
        return topology == vk::PrimitiveTopology::ePointList ||
               topology == vk::PrimitiveTopology::eLineList ||
               topology == vk::PrimitiveTopology::eTriangleList ||
               topology == vk::PrimitiveTopology::eLineListWithAdjacency ||
               topology == vk::PrimitiveTopology::eTriangleListWithAdjacency;
    };
    const auto is_patch_list_topology = [](const AmdGpu::PrimitiveType type) {
        // Quad and rect lists are emulated using tessellation.
        return type == AmdGpu::PrimitiveType::PatchPrimitive ||
               type == AmdGpu::PrimitiveType::QuadList || type == AmdGpu::PrimitiveType::RectList;
    };

    const auto prim_restart =
        (regs.enable_primitive_restart & 1) != 0 &&
        (instance.IsListRestartSupported() || !is_list_topology(regs.primitive_type)) &&
        (instance.IsPatchListRestartSupported() || !is_patch_list_topology(regs.primitive_type));
    ASSERT_MSG(!is_indexed || !prim_restart || regs.primitive_restart_index == 0xFFFF ||
                   regs.primitive_restart_index == 0xFFFFFFFF,
               "Primitive restart index other than -1 is not supported yet");

    const auto cull_mode = LiverpoolToVK::IsPrimitiveCulled(regs.primitive_type)
                               ? LiverpoolToVK::CullMode(regs.polygon_control.CullingMode())
                               : vk::CullModeFlagBits::eNone;
    const auto front_face = LiverpoolToVK::FrontFace(regs.polygon_control.front_face);

    dynamic_state.SetPrimitiveRestartEnabled(prim_restart);
    dynamic_state.SetRasterizerDiscardEnabled(regs.clipper_control.dx_rasterization_kill);
    dynamic_state.SetCullMode(cull_mode);
    dynamic_state.SetFrontFace(front_face);
}

void Rasterizer::UpdateRasterizationState() const {
    const auto& regs = liverpool->regs;
    auto& dynamic_state = scheduler.GetDynamicState();
    dynamic_state.SetLineWidth(regs.line_control.Width());
}

void Rasterizer::UpdateColorBlendingState(const GraphicsPipeline* pipeline) const {
    const auto& regs = liverpool->regs;
    auto& dynamic_state = scheduler.GetDynamicState();
    dynamic_state.SetBlendConstants(regs.blend_constants);
    dynamic_state.SetColorWriteMasks(pipeline->GetGraphicsKey().write_masks);
    dynamic_state.SetAttachmentFeedbackLoopEnabled(attachment_feedback_loop);
}

void Rasterizer::ScopeMarkerBegin(const std::string_view& str, bool from_guest) {
    if ((from_guest && !EmulatorSettings.IsVkGuestMarkersEnabled()) ||
        (!from_guest && !EmulatorSettings.IsVkHostMarkersEnabled())) {
        return;
    }
    const auto cmdbuf = scheduler.CommandBuffer();
    cmdbuf.beginDebugUtilsLabelEXT(vk::DebugUtilsLabelEXT{
        .pLabelName = str.data(),
    });
}

void Rasterizer::ScopeMarkerEnd(bool from_guest) {
    if ((from_guest && !EmulatorSettings.IsVkGuestMarkersEnabled()) ||
        (!from_guest && !EmulatorSettings.IsVkHostMarkersEnabled())) {
        return;
    }
    const auto cmdbuf = scheduler.CommandBuffer();
    cmdbuf.endDebugUtilsLabelEXT();
}

void Rasterizer::ScopedMarkerInsert(const std::string_view& str, bool from_guest) {
    if ((from_guest && !EmulatorSettings.IsVkGuestMarkersEnabled()) ||
        (!from_guest && !EmulatorSettings.IsVkHostMarkersEnabled())) {
        return;
    }
    const auto cmdbuf = scheduler.CommandBuffer();
    cmdbuf.insertDebugUtilsLabelEXT(vk::DebugUtilsLabelEXT{
        .pLabelName = str.data(),
    });
}

void Rasterizer::ScopedMarkerInsertColor(const std::string_view& str, const u32 color,
                                         bool from_guest) {
    if ((from_guest && !EmulatorSettings.IsVkGuestMarkersEnabled()) ||
        (!from_guest && !EmulatorSettings.IsVkHostMarkersEnabled())) {
        return;
    }
    const auto cmdbuf = scheduler.CommandBuffer();
    cmdbuf.insertDebugUtilsLabelEXT(vk::DebugUtilsLabelEXT{
        .pLabelName = str.data(),
        .color = std::array<f32, 4>(
            {(f32)((color >> 16) & 0xff) / 255.0f, (f32)((color >> 8) & 0xff) / 255.0f,
             (f32)(color & 0xff) / 255.0f, (f32)((color >> 24) & 0xff) / 255.0f})});
}

} // namespace Vulkan
