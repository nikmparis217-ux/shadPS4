// SPDX-FileCopyrightText: Copyright 2024-2026 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include "common/assert.h"
#include "core/emulator_settings.h"
#include "shader_recompiler/backend/spirv/emit_spirv_instructions.h"
#include "shader_recompiler/backend/spirv/spirv_emit_context.h"
#include "shader_recompiler/ir/attribute.h"
#include "shader_recompiler/ir/patch.h"
#include "shader_recompiler/runtime_info.h"

#include <algorithm>
#include <cstdlib>
#include <magic_enum/magic_enum.hpp>
#include <string>
#include <vector>

namespace Shader::Backend::SPIRV {

using PointerType = EmitContext::PointerType;
using PointerSize = EmitContext::PointerSize;

static std::pair<Id, bool> OutputAttrComponentType(EmitContext& ctx, IR::Attribute attr) {
    if (IR::IsParam(attr)) {
        const u32 index{u32(attr) - u32(IR::Attribute::Param0)};
        const auto& info{ctx.output_params.at(index)};
        return {info.component_type, info.is_integer};
    }
    if (IR::IsMrt(attr)) {
        const u32 index{u32(attr) - u32(IR::Attribute::RenderTarget0)};
        const auto& info{ctx.frag_outputs.at(index)};
        return {info.component_type, info.is_integer};
    }
    switch (attr) {
    case IR::Attribute::Position0:
    case IR::Attribute::ClipDistance:
    case IR::Attribute::CullDistance:
    case IR::Attribute::Depth:
    case IR::Attribute::PointSize:
        return {ctx.F32[1], false};
    case IR::Attribute::RenderTargetIndex:
    case IR::Attribute::ViewportIndex:
    case IR::Attribute::SampleMask:
        return {ctx.U32[1], true};
    case IR::Attribute::StencilRef:
        return {ctx.S32[1], true};
    default:
        UNREACHABLE_MSG("Write attribute {}", attr);
    }
}

// GT_RT_SCRUB=1 enables poisoned render-target containment for every fragment shader.
// A comma-separated hexadecimal hash list limits it to named shaders. GT7's foliage shader
// fs_92126594 was measured writing exactly 65000 to 10,563 pixels in one draw because its
// guest clamp converts NaNs into the finite fp16 ceiling before this output boundary. Catch
// both genuinely non-finite values and that saturated ceiling; ordinary finite HDR remains
// untouched.
static bool GtRtScrubEnabled(u64 hash) {
    struct Config {
        bool all{};
        std::vector<u64> hashes;
    };
    static const Config config = [] {
        Config result{};
        const char* env = std::getenv("GT_RT_SCRUB");
        if (env == nullptr || env[0] == '\0' || (env[0] == '0' && env[1] == '\0')) {
            return result;
        }
        const std::string value{env};
        if (value == "1") {
            result.all = true;
            return result;
        }
        size_t pos = 0;
        while (pos <= value.size()) {
            size_t comma = value.find(',', pos);
            if (comma == std::string::npos) {
                comma = value.size();
            }
            if (comma > pos) {
                result.hashes.push_back(
                    std::strtoull(value.substr(pos, comma - pos).c_str(), nullptr, 16));
            }
            pos = comma + 1;
        }
        return result;
    }();
    return config.all || std::find(config.hashes.begin(), config.hashes.end(), hash) !=
                             config.hashes.end();
}

Id EmitGetUserData(EmitContext& ctx, IR::ScalarReg reg) {
    const u32 index = ctx.binding.user_data + ctx.info.ud_mask.Index(reg);
    const u32 half = PushData::UdRegsIndex + (index >> 2);
    const Id ud_ptr{ctx.OpAccessChain(ctx.TypePointer(spv::StorageClass::PushConstant, ctx.U32[1]),
                                      ctx.push_data_block, ctx.ConstU32(half),
                                      ctx.ConstU32(index & 3))};
    const Id ud_reg{ctx.OpLoad(ctx.U32[1], ud_ptr)};
    ctx.Name(ud_reg, fmt::format("ud_{}", u32(reg)));
    return ud_reg;
}

// GT_BINDLESS_LOWER: the write half of the GPU-time path. Resolve the guest address
// through the BDA pagetable and store one dword; a page that is not resident records a
// fault (get_bda_pointer does that) and the store is dropped this frame - the page will
// exist on the next one, mirroring what the read path does with its zero fallback.
void EmitWriteConst(EmitContext& ctx, IR::Inst* inst, Id base, Id offset, Id value) {
    const Id base_lo{ctx.OpUConvert(ctx.U64, ctx.OpCompositeExtract(ctx.U32[1], base, 0))};
    const Id base_hi{ctx.OpUConvert(ctx.U64, ctx.OpCompositeExtract(ctx.U32[1], base, 1))};
    const Id base_addr{
        ctx.OpBitwiseOr(ctx.U64, base_lo, ctx.OpShiftLeftLogical(ctx.U64, base_hi, ctx.ConstU32(32U)))};
    const Id offset_bytes{ctx.OpShiftLeftLogical(ctx.U32[1], offset, ctx.ConstU32(2U))};
    const Id addr{ctx.OpIAdd(ctx.U64, base_addr, ctx.OpUConvert(ctx.U64, offset_bytes))};

    const Id ptr64 = ctx.OpFunctionCall(ctx.U64, ctx.get_bda_pointer, addr);
    const Id is_available = ctx.OpINotEqual(ctx.U1[1], ptr64, ctx.u64_zero_value);
    const Id store_label = ctx.OpLabel();
    const Id merge_label = ctx.OpLabel();
    ctx.OpSelectionMerge(merge_label, spv::SelectionControlMask::MaskNone);
    ctx.OpBranchConditional(is_available, store_label, merge_label);
    ctx.AddLabel(store_label);
    const Id addr_ptr = ctx.OpConvertUToPtr(ctx.physical_pointer_type_u32, ptr64);
    ctx.OpStore(addr_ptr, value, spv::MemoryAccessMask::Aligned, 4u);
    ctx.OpBranch(merge_label);
    ctx.AddLabel(merge_label);
}

// GT_BINDLESS_LOWER: atomic add through the BDA path (buffer_atomic_add off a GPU-fetched
// V#). Non-resident page: fault recorded by get_bda_pointer, op dropped, returns 0.
Id EmitConstAtomicIAdd32(EmitContext& ctx, IR::Inst* inst, Id base, Id offset, Id value) {
    const Id base_lo{ctx.OpUConvert(ctx.U64, ctx.OpCompositeExtract(ctx.U32[1], base, 0))};
    const Id base_hi{ctx.OpUConvert(ctx.U64, ctx.OpCompositeExtract(ctx.U32[1], base, 1))};
    const Id base_addr{
        ctx.OpBitwiseOr(ctx.U64, base_lo, ctx.OpShiftLeftLogical(ctx.U64, base_hi, ctx.ConstU32(32U)))};
    const Id offset_bytes{ctx.OpShiftLeftLogical(ctx.U32[1], offset, ctx.ConstU32(2U))};
    const Id addr{ctx.OpIAdd(ctx.U64, base_addr, ctx.OpUConvert(ctx.U64, offset_bytes))};

    const Id ptr64 = ctx.OpFunctionCall(ctx.U64, ctx.get_bda_pointer, addr);
    const Id is_available = ctx.OpINotEqual(ctx.U1[1], ptr64, ctx.u64_zero_value);
    const Id op_label = ctx.OpLabel();
    const Id skip_label = ctx.OpLabel();
    const Id merge_label = ctx.OpLabel();
    ctx.OpSelectionMerge(merge_label, spv::SelectionControlMask::MaskNone);
    ctx.OpBranchConditional(is_available, op_label, skip_label);
    ctx.AddLabel(op_label);
    const Id addr_ptr = ctx.OpConvertUToPtr(ctx.physical_pointer_type_u32, ptr64);
    const Id scope = ctx.ConstU32(static_cast<u32>(spv::Scope::Device));
    const Id result =
        ctx.OpAtomicIAdd(ctx.U32[1], addr_ptr, scope, ctx.u32_zero_value, value);
    ctx.OpBranch(merge_label);
    ctx.AddLabel(skip_label);
    ctx.OpBranch(merge_label);
    ctx.AddLabel(merge_label);
    return ctx.OpPhi(ctx.U32[1], result, op_label, ctx.u32_zero_value, skip_label);
}

Id EmitReadConst(EmitContext& ctx, IR::Inst* inst, Id addr, Id offset) {
    const u32 flags = inst->Flags<u32>();
    if (flags & SrtBindlessFlagBit) {
        // GT_BINDLESS_LOWER: this read's base is a V# the shader itself fetched at GPU
        // time - there is no flatbuf snapshot of it, the ONLY correct source is guest
        // memory through the BDA walk, whatever the global DMA setting says.
        return ctx.OpFunctionCall(ctx.U32[1], ctx.read_const_dynamic, addr, offset);
    }
    if (flags & SrtWindowFlagBit) {
        // GT_DYNRC_WINDOW (GT7): the SRT walker bulk-copied a window of this pointer's
        // guest memory into the flatbuf. The offset operand is the shader's own runtime
        // dword offset into the pointer; clamp it inside the window so a stray index can
        // never read another window's data. Under DMA the honest dynamic read exists -
        // prefer it (it sees GPU-time memory, the window is a dispatch-time snapshot).
        // GT_DYNRC_GPU=1 takes the honest read WITHOUT global DMA: only shaders carrying
        // windows pay the per-draw re-sync (the collection pass keeps uses_dma alive for
        // them, same keep-alive as the bindless bit above).
        if (EmulatorSettings.IsDirectMemoryAccessEnabled() || DynrcGpuReadsEnabled()) {
            return ctx.OpFunctionCall(ctx.U32[1], ctx.read_const_dynamic, addr, offset);
        }
        const Id clamped =
            ctx.OpUMin(ctx.U32[1], offset, ctx.ConstU32(SrtWindowSizeDw(flags) - 1u));
        return ctx.EmitFlatbufferLoad(
            ctx.OpIAdd(ctx.U32[1], ctx.ConstU32(SrtWindowBaseDw(flags)), clamped));
    }
    const u32 flatbuf_off_dw = flags;
    if (!EmulatorSettings.IsDirectMemoryAccessEnabled()) {
        return ctx.EmitFlatbufferLoad(ctx.ConstU32(flatbuf_off_dw));
    }
    // We can only provide a fallback for immediate offsets.
    if (flatbuf_off_dw == 0) {
        return ctx.OpFunctionCall(ctx.U32[1], ctx.read_const_dynamic, addr, offset);
    } else {
        return ctx.OpFunctionCall(ctx.U32[1], ctx.read_const, addr, offset,
                                  ctx.ConstU32(flatbuf_off_dw));
    }
}

Id EmitReadConstBuffer(EmitContext& ctx, u32 handle, Id index) {
    const auto& buffer = ctx.buffers[handle];
    if (const Id offset = buffer.Offset(PointerSize::B32); Sirit::ValidId(offset)) {
        index = ctx.OpIAdd(ctx.U32[1], index, offset);
    }
    const auto [id, pointer_type] = buffer.Alias(PointerType::U32);
    const Id ptr{ctx.OpAccessChain(pointer_type, id, ctx.u32_zero_value, index)};
    const Id result{ctx.OpLoad(ctx.U32[1], ptr)};
    return result;
}

Id EmitGetAttribute(EmitContext& ctx, IR::Attribute attr, u32 comp, u32 index) {
    if (IR::IsParam(attr)) {
        const u32 param_index{u32(attr) - u32(IR::Attribute::Param0)};
        const auto& param{ctx.input_params.at(param_index)};
        const Id value = [&] {
            if (param.is_array) {
                ASSERT(param.num_components > 1);
                if (param.is_loaded) {
                    return ctx.OpCompositeExtract(param.component_type, param.id_array[index],
                                                  comp);
                } else {
                    return ctx.OpLoad(param.component_type,
                                      ctx.OpAccessChain(param.pointer_type, param.id,
                                                        ctx.ConstU32(index), ctx.ConstU32(comp)));
                }
            } else {
                ASSERT(!param.is_loaded);
                if (param.num_components > 1) {
                    return ctx.OpLoad(
                        param.component_type,
                        ctx.OpAccessChain(param.pointer_type, param.id, ctx.ConstU32(comp)));
                } else {
                    return ctx.OpLoad(param.component_type, param.id);
                }
            }
        }();
        return param.is_integer ? ctx.OpBitcast(ctx.F32[1], value) : value;
    }
    if (IR::IsBarycentricCoord(attr) && ctx.profile.supports_fragment_shader_barycentric) {
        ++comp;
    }
    switch (attr) {
    case IR::Attribute::Position0:
        ASSERT(ctx.l_stage == LogicalStage::Geometry);
        return ctx.OpLoad(ctx.F32[1],
                          ctx.OpAccessChain(ctx.input_f32, ctx.gl_in, ctx.ConstU32(index),
                                            ctx.ConstU32(0U), ctx.ConstU32(comp)));
    case IR::Attribute::FragCoord:
        return ctx.OpLoad(ctx.F32[1],
                          ctx.OpAccessChain(ctx.input_f32, ctx.frag_coord, ctx.ConstU32(comp)));
    case IR::Attribute::TessellationEvaluationPointU:
        return ctx.OpLoad(ctx.F32[1],
                          ctx.OpAccessChain(ctx.input_f32, ctx.tess_coord, ctx.u32_zero_value));
    case IR::Attribute::TessellationEvaluationPointV:
        return ctx.OpLoad(ctx.F32[1],
                          ctx.OpAccessChain(ctx.input_f32, ctx.tess_coord, ctx.ConstU32(1U)));
    case IR::Attribute::BaryCoordSmooth:
        return ctx.OpLoad(ctx.F32[1], ctx.OpAccessChain(ctx.input_f32, ctx.bary_coord_smooth,
                                                        ctx.ConstU32(comp)));
    case IR::Attribute::BaryCoordSmoothCentroid:
        return ctx.OpLoad(
            ctx.F32[1],
            ctx.OpAccessChain(ctx.input_f32, ctx.bary_coord_smooth_centroid, ctx.ConstU32(comp)));
    case IR::Attribute::BaryCoordSmoothSample:
        return ctx.OpLoad(ctx.F32[1], ctx.OpAccessChain(ctx.input_f32, ctx.bary_coord_smooth_sample,
                                                        ctx.ConstU32(comp)));
    case IR::Attribute::BaryCoordNoPersp:
        return ctx.OpLoad(ctx.F32[1], ctx.OpAccessChain(ctx.input_f32, ctx.bary_coord_nopersp,
                                                        ctx.ConstU32(comp)));
    case IR::Attribute::BaryCoordNoPerspSample:
        return ctx.OpLoad(
            ctx.F32[1],
            ctx.OpAccessChain(ctx.input_f32, ctx.bary_coord_nopersp_sample, ctx.ConstU32(comp)));
    default:
        UNREACHABLE_MSG("Read attribute {}", attr);
    }
}

Id EmitGetAttributeU32(EmitContext& ctx, IR::Attribute attr, u32 comp) {
    switch (attr) {
    case IR::Attribute::VertexId:
        return ctx.OpLoad(ctx.U32[1], ctx.vertex_index);
    case IR::Attribute::InstanceId:
        return ctx.OpLoad(ctx.U32[1], ctx.instance_id);
    case IR::Attribute::WorkgroupIndex:
        return ctx.workgroup_index_id;
    case IR::Attribute::WorkgroupId:
        return ctx.OpCompositeExtract(ctx.U32[1], ctx.OpLoad(ctx.U32[3], ctx.workgroup_id), comp);
    case IR::Attribute::LocalInvocationId:
        return ctx.OpCompositeExtract(ctx.U32[1], ctx.OpLoad(ctx.U32[3], ctx.local_invocation_id),
                                      comp);
    case IR::Attribute::IsFrontFace:
        return ctx.OpSelect(ctx.U32[1], ctx.OpLoad(ctx.U1[1], ctx.front_facing), ctx.u32_one_value,
                            ctx.u32_zero_value);
    case IR::Attribute::SampleIndex:
        return ctx.OpLoad(ctx.U32[1], ctx.sample_index);
    case IR::Attribute::RenderTargetIndex:
        return ctx.OpLoad(ctx.U32[1], ctx.output_layer);
    case IR::Attribute::PrimitiveId:
        return ctx.OpLoad(ctx.U32[1], ctx.primitive_id);
    case IR::Attribute::InvocationId:
        ASSERT(ctx.info.l_stage == LogicalStage::Geometry ||
               ctx.info.l_stage == LogicalStage::TessellationControl);
        return ctx.OpLoad(ctx.U32[1], ctx.invocation_id);
    case IR::Attribute::PatchVertices:
        ASSERT(ctx.info.l_stage == LogicalStage::TessellationControl);
        return ctx.OpLoad(ctx.U32[1], ctx.patch_vertices);
    case IR::Attribute::PackedHullInvocationInfo: {
        ASSERT(ctx.info.l_stage == LogicalStage::TessellationControl);
        // [0:8]: patch id within VGT
        // [8:12]: output control point id
        // But 0:8 should be treated as 0 for attribute addressing purposes
        if (ctx.runtime_info.hs_info.IsPassthrough()) {
            // Gcn shader would run with 1 thread, but we need to run a thread for
            // each output control point.
            // If Gcn shader uses this value, we should make sure all threads in the
            // Vulkan shader use 0
            return ctx.ConstU32(0u);
        } else {
            const Id invocation_id = ctx.OpLoad(ctx.U32[1], ctx.invocation_id);
            return ctx.OpShiftLeftLogical(ctx.U32[1], invocation_id, ctx.ConstU32(8u));
        }
    }
    default:
        UNREACHABLE_MSG("Read U32 attribute {}", attr);
    }
}

void EmitSetAttribute(EmitContext& ctx, IR::Attribute attr, Id value, u32 element) {
    Id store_value = value;
    const auto op_store = [&](Id pointer) {
        const auto [component_type, is_integer] = OutputAttrComponentType(ctx, attr);
        if (is_integer) {
            ctx.OpStore(pointer, ctx.OpBitcast(component_type, store_value));
        } else {
            ctx.OpStore(pointer, store_value);
        }
    };
    if (IR::IsParam(attr)) {
        const u32 attr_index{u32(attr) - u32(IR::Attribute::Param0)};
        if (ctx.stage == Stage::Local) {
            const auto component_ptr = ctx.TypePointer(spv::StorageClass::Output, ctx.F32[1]);
            return op_store(ctx.OpAccessChain(component_ptr, ctx.output_attr_array,
                                              ctx.ConstU32(attr_index), ctx.ConstU32(element)));
        } else {
            const auto& info{ctx.output_params.at(attr_index)};
            ASSERT(info.num_components > 0);
            if (info.num_components == 1) {
                return op_store(info.id);
            } else {
                return op_store(
                    ctx.OpAccessChain(info.pointer_type, info.id, ctx.ConstU32(element)));
            }
        }
    }
    if (IR::IsMrt(attr)) {
        const u32 index{u32(attr) - u32(IR::Attribute::RenderTarget0)};
        const auto& info{ctx.frag_outputs.at(index)};
        if (!info.is_integer && GtRtScrubEnabled(ctx.info.pgm_hash)) {
            const Id is_nan = ctx.OpIsNan(ctx.U1[1], store_value);
            const Id is_inf = ctx.OpIsInf(ctx.U1[1], store_value);
            const Id non_finite = ctx.OpLogicalOr(ctx.U1[1], is_nan, is_inf);
            const Id magnitude = ctx.OpFAbs(ctx.F32[1], store_value);
            const Id saturated = ctx.OpFOrdGreaterThanEqual(
                ctx.U1[1], magnitude, ctx.ConstF32(65000.0f));
            const Id poisoned = ctx.OpLogicalOr(ctx.U1[1], non_finite, saturated);
            store_value =
                ctx.OpSelect(ctx.F32[1], poisoned, ctx.ConstF32(0.0f), store_value);
        }
        if (info.num_components == 1) {
            return op_store(info.id);
        } else {
            return op_store(ctx.OpAccessChain(info.pointer_type, info.id, ctx.ConstU32(element)));
        }
    }
    switch (attr) {
    case IR::Attribute::Position0:
        return op_store(
            ctx.OpAccessChain(ctx.output_f32, ctx.output_position, ctx.ConstU32(element)));
    case IR::Attribute::ClipDistance:
        return op_store(
            ctx.OpAccessChain(ctx.output_f32, ctx.clip_distances, ctx.ConstU32(element)));
    case IR::Attribute::CullDistance:
        return op_store(
            ctx.OpAccessChain(ctx.output_f32, ctx.cull_distances, ctx.ConstU32(element)));
    case IR::Attribute::PointSize:
        return op_store(ctx.output_point_size);
    case IR::Attribute::RenderTargetIndex:
        return op_store(ctx.output_layer);
    case IR::Attribute::ViewportIndex:
        return op_store(ctx.output_viewport_index);
    case IR::Attribute::Depth:
        return op_store(ctx.frag_depth);
    case IR::Attribute::SampleMask:
        return op_store(ctx.OpAccessChain(ctx.output_u32, ctx.sample_mask, ctx.u32_zero_value));
    case IR::Attribute::StencilRef:
        if (ctx.profile.supports_shader_stencil_export) {
            return op_store(ctx.stencil_ref);
        }
        return;
    default:
        UNREACHABLE_MSG("Write attribute {}", attr);
    }
}

Id EmitGetTessGenericAttribute(EmitContext& ctx, Id vertex_index, Id attr_index, Id comp_index) {
    const auto attr_comp_ptr = ctx.TypePointer(spv::StorageClass::Input, ctx.F32[1]);
    return ctx.OpLoad(ctx.F32[1], ctx.OpAccessChain(attr_comp_ptr, ctx.input_attr_array,
                                                    vertex_index, attr_index, comp_index));
}

Id EmitReadTcsGenericOuputAttribute(EmitContext& ctx, Id vertex_index, Id attr_index,
                                    Id comp_index) {
    const auto attr_comp_ptr = ctx.TypePointer(spv::StorageClass::Output, ctx.F32[1]);
    return ctx.OpLoad(ctx.F32[1], ctx.OpAccessChain(attr_comp_ptr, ctx.output_attr_array,
                                                    vertex_index, attr_index, comp_index));
}

void EmitSetTcsGenericAttribute(EmitContext& ctx, Id value, Id attr_index, Id comp_index) {
    // Implied vertex index is invocation_id
    const auto component_ptr = ctx.TypePointer(spv::StorageClass::Output, ctx.F32[1]);
    Id pointer =
        ctx.OpAccessChain(component_ptr, ctx.output_attr_array,
                          ctx.OpLoad(ctx.U32[1], ctx.invocation_id), attr_index, comp_index);
    ctx.OpStore(pointer, value);
}

Id EmitGetPatch(EmitContext& ctx, IR::Patch patch) {
    const u32 index{IR::GenericPatchIndex(patch)};
    const Id element{ctx.ConstU32(IR::GenericPatchElement(patch))};
    const Id type{ctx.l_stage == LogicalStage::TessellationControl ? ctx.output_f32
                                                                   : ctx.input_f32};
    const Id pointer{ctx.OpAccessChain(type, ctx.patches.at(index), element)};
    return ctx.OpLoad(ctx.F32[1], pointer);
}

void EmitSetPatch(EmitContext& ctx, IR::Patch patch, Id value) {
    const Id pointer{[&] {
        if (IR::IsGeneric(patch)) {
            const u32 index{IR::GenericPatchIndex(patch)};
            const Id element{ctx.ConstU32(IR::GenericPatchElement(patch))};
            return ctx.OpAccessChain(ctx.output_f32, ctx.patches.at(index), element);
        }
        switch (patch) {
        case IR::Patch::TessellationLodLeft:
        case IR::Patch::TessellationLodRight:
        case IR::Patch::TessellationLodTop:
        case IR::Patch::TessellationLodBottom: {
            const u32 index{static_cast<u32>(patch) - u32(IR::Patch::TessellationLodLeft)};
            const Id index_id{ctx.ConstU32(index)};
            return ctx.OpAccessChain(ctx.output_f32, ctx.output_tess_level_outer, index_id);
        }
        case IR::Patch::TessellationLodInteriorU:
            return ctx.OpAccessChain(ctx.output_f32, ctx.output_tess_level_inner,
                                     ctx.u32_zero_value);
        case IR::Patch::TessellationLodInteriorV:
            return ctx.OpAccessChain(ctx.output_f32, ctx.output_tess_level_inner, ctx.ConstU32(1u));
        default:
            UNREACHABLE_MSG("Patch {}", u32(patch));
        }
    }()};
    ctx.OpStore(pointer, value);
}

template <u32 N, PointerType alias>
static Id EmitLoadBufferB32xN(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address) {
    const auto& spv_buffer = ctx.buffers[handle];
    if (const Id offset = spv_buffer.Offset(PointerSize::B32); Sirit::ValidId(offset)) {
        address = ctx.OpIAdd(ctx.U32[1], address, offset);
    }
    const auto& data_types = alias == PointerType::U32 ? ctx.U32 : ctx.F32;
    const auto [id, pointer_type] = spv_buffer.Alias(alias);

    boost::container::static_vector<Id, N> ids;
    for (u32 i = 0; i < N; i++) {
        const Id index_i = i == 0 ? address : ctx.OpIAdd(ctx.U32[1], address, ctx.ConstU32(i));
        const Id ptr_i = ctx.OpAccessChain(pointer_type, id, ctx.u32_zero_value, index_i);
        const Id result_i = ctx.OpLoad(data_types[1], ptr_i);
        ids.push_back(result_i);
    }

    const Id result = N == 1 ? ids[0] : ctx.OpCompositeConstruct(data_types[N], ids);
    return result;
}

Id EmitLoadBufferU8(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address) {
    const auto& spv_buffer = ctx.buffers[handle];
    if (const Id offset = spv_buffer.Offset(PointerSize::B8); Sirit::ValidId(offset)) {
        address = ctx.OpIAdd(ctx.U32[1], address, offset);
    }
    const auto [id, pointer_type] = spv_buffer.Alias(PointerType::U8);
    const Id ptr{ctx.OpAccessChain(pointer_type, id, ctx.u32_zero_value, address)};
    const Id result{ctx.OpLoad(ctx.U8, ptr)};
    return result;
}

Id EmitLoadBufferU16(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address) {
    const auto& spv_buffer = ctx.buffers[handle];
    if (const Id offset = spv_buffer.Offset(PointerSize::B16); Sirit::ValidId(offset)) {
        address = ctx.OpIAdd(ctx.U32[1], address, offset);
    }
    const auto [id, pointer_type] = spv_buffer.Alias(PointerType::U16);
    const Id ptr{ctx.OpAccessChain(pointer_type, id, ctx.u32_zero_value, address)};
    const Id result{ctx.OpLoad(ctx.U16, ptr)};
    return result;
}

Id EmitLoadBufferU32(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address) {
    return EmitLoadBufferB32xN<1, PointerType::U32>(ctx, inst, handle, address);
}

Id EmitLoadBufferU32x2(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address) {
    return EmitLoadBufferB32xN<2, PointerType::U32>(ctx, inst, handle, address);
}

Id EmitLoadBufferU32x3(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address) {
    return EmitLoadBufferB32xN<3, PointerType::U32>(ctx, inst, handle, address);
}

Id EmitLoadBufferU32x4(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address) {
    return EmitLoadBufferB32xN<4, PointerType::U32>(ctx, inst, handle, address);
}

Id EmitLoadBufferU64(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address) {
    const auto& spv_buffer = ctx.buffers[handle];
    if (const Id offset = spv_buffer.Offset(PointerSize::B64); Sirit::ValidId(offset)) {
        address = ctx.OpIAdd(ctx.U32[1], address, offset);
    }
    const auto [id, pointer_type] = spv_buffer.Alias(PointerType::U64);
    const Id ptr{ctx.OpAccessChain(pointer_type, id, ctx.u64_zero_value, address)};
    const Id result{ctx.OpLoad(ctx.U64, ptr)};
    return result;
}

Id EmitLoadBufferF32(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address) {
    return EmitLoadBufferB32xN<1, PointerType::F32>(ctx, inst, handle, address);
}

Id EmitLoadBufferF32x2(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address) {
    return EmitLoadBufferB32xN<2, PointerType::F32>(ctx, inst, handle, address);
}

Id EmitLoadBufferF32x3(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address) {
    return EmitLoadBufferB32xN<3, PointerType::F32>(ctx, inst, handle, address);
}

Id EmitLoadBufferF32x4(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address) {
    return EmitLoadBufferB32xN<4, PointerType::F32>(ctx, inst, handle, address);
}

Id EmitLoadBufferFormatF32(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address) {
    UNREACHABLE_MSG("SPIR-V instruction");
}

template <u32 N, PointerType alias>
static void EmitStoreBufferB32xN(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address,
                                 Id value) {
    const auto& spv_buffer = ctx.buffers[handle];
    if (const Id offset = spv_buffer.Offset(PointerSize::B32); Sirit::ValidId(offset)) {
        address = ctx.OpIAdd(ctx.U32[1], address, offset);
    }
    address = ctx.ClampBufferIndex(handle, address, alias, N);
    const auto& data_types = alias == PointerType::U32 ? ctx.U32 : ctx.F32;
    const auto [id, pointer_type] = spv_buffer.Alias(alias);

    for (u32 i = 0; i < N; i++) {
        const Id index_i = i == 0 ? address : ctx.OpIAdd(ctx.U32[1], address, ctx.ConstU32(i));
        const Id ptr_i = ctx.OpAccessChain(pointer_type, id, ctx.u32_zero_value, index_i);
        const Id value_i = N == 1 ? value : ctx.OpCompositeExtract(data_types[1], value, i);
        ctx.OpStore(ptr_i, value_i);
    }
}

void EmitStoreBufferU8(EmitContext& ctx, IR::Inst*, u32 handle, Id address, Id value) {
    const auto& spv_buffer = ctx.buffers[handle];
    if (const Id offset = spv_buffer.Offset(PointerSize::B8); Sirit::ValidId(offset)) {
        address = ctx.OpIAdd(ctx.U32[1], address, offset);
    }
    address = ctx.ClampBufferIndex(handle, address, PointerType::U8, 1);
    const auto [id, pointer_type] = spv_buffer.Alias(PointerType::U8);
    const Id ptr{ctx.OpAccessChain(pointer_type, id, ctx.u32_zero_value, address)};
    ctx.OpStore(ptr, value);
}

void EmitStoreBufferU16(EmitContext& ctx, IR::Inst*, u32 handle, Id address, Id value) {
    const auto& spv_buffer = ctx.buffers[handle];
    if (const Id offset = spv_buffer.Offset(PointerSize::B16); Sirit::ValidId(offset)) {
        address = ctx.OpIAdd(ctx.U32[1], address, offset);
    }
    address = ctx.ClampBufferIndex(handle, address, PointerType::U16, 1);
    const auto [id, pointer_type] = spv_buffer.Alias(PointerType::U16);
    const Id ptr{ctx.OpAccessChain(pointer_type, id, ctx.u32_zero_value, address)};
    ctx.OpStore(ptr, value);
}

void EmitStoreBufferU32(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address, Id value) {
    EmitStoreBufferB32xN<1, PointerType::U32>(ctx, inst, handle, address, value);
}

void EmitStoreBufferU32x2(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address, Id value) {
    EmitStoreBufferB32xN<2, PointerType::U32>(ctx, inst, handle, address, value);
}

void EmitStoreBufferU32x3(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address, Id value) {
    EmitStoreBufferB32xN<3, PointerType::U32>(ctx, inst, handle, address, value);
}

void EmitStoreBufferU32x4(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address, Id value) {
    EmitStoreBufferB32xN<4, PointerType::U32>(ctx, inst, handle, address, value);
}

void EmitStoreBufferU64(EmitContext& ctx, IR::Inst*, u32 handle, Id address, Id value) {
    const auto& spv_buffer = ctx.buffers[handle];
    if (const Id offset = spv_buffer.Offset(PointerSize::B64); Sirit::ValidId(offset)) {
        address = ctx.OpIAdd(ctx.U32[1], address, offset);
    }
    address = ctx.ClampBufferIndex(handle, address, PointerType::U64, 1);
    const auto [id, pointer_type] = spv_buffer.Alias(PointerType::U64);
    const Id ptr{ctx.OpAccessChain(pointer_type, id, ctx.u64_zero_value, address)};
    ctx.OpStore(ptr, value);
}

void EmitStoreBufferF32(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address, Id value) {
    EmitStoreBufferB32xN<1, PointerType::F32>(ctx, inst, handle, address, value);
}

void EmitStoreBufferF32x2(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address, Id value) {
    EmitStoreBufferB32xN<2, PointerType::F32>(ctx, inst, handle, address, value);
}

void EmitStoreBufferF32x3(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address, Id value) {
    EmitStoreBufferB32xN<3, PointerType::F32>(ctx, inst, handle, address, value);
}

void EmitStoreBufferF32x4(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address, Id value) {
    EmitStoreBufferB32xN<4, PointerType::F32>(ctx, inst, handle, address, value);
}

void EmitStoreBufferFormatF32(EmitContext& ctx, IR::Inst* inst, u32 handle, Id address, Id value) {
    UNREACHABLE_MSG("SPIR-V instruction");
}

void EmitGetThreadBitScalarReg(EmitContext& ctx) {
    UNREACHABLE_MSG("Unreachable instruction");
}

void EmitSetThreadBitScalarReg(EmitContext& ctx) {
    UNREACHABLE_MSG("Unreachable instruction");
}

void EmitGetScalarRegister(EmitContext&) {
    UNREACHABLE_MSG("Unreachable instruction");
}

void EmitSetScalarRegister(EmitContext&) {
    UNREACHABLE_MSG("Unreachable instruction");
}

void EmitGetVectorRegister(EmitContext& ctx) {
    UNREACHABLE_MSG("Unreachable instruction");
}

void EmitSetVectorRegister(EmitContext& ctx) {
    UNREACHABLE_MSG("Unreachable instruction");
}

void EmitSetGotoVariable(EmitContext&) {
    UNREACHABLE_MSG("Unreachable instruction");
}

void EmitGetGotoVariable(EmitContext&) {
    UNREACHABLE_MSG("Unreachable instruction");
}

void EmitSetMaskLaneVariable(EmitContext&) {
    UNREACHABLE_MSG("Unreachable instruction");
}

void EmitGetMaskLaneVariable(EmitContext&) {
    UNREACHABLE_MSG("Unreachable instruction");
}

} // namespace Shader::Backend::SPIRV
