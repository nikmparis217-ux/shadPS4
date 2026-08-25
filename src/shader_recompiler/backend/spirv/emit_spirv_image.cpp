// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include <cstdlib>

#include <boost/container/static_vector.hpp>
#include "shader_recompiler/backend/spirv/emit_spirv_instructions.h"
#include "shader_recompiler/backend/spirv/spirv_emit_context.h"

namespace Shader::Backend::SPIRV {

struct ImageOperands {
    void Add(spv::ImageOperandsMask new_mask, Id value) {
        if (!Sirit::ValidId(value)) {
            return;
        }
        mask = static_cast<spv::ImageOperandsMask>(static_cast<u32>(mask) |
                                                   static_cast<u32>(new_mask));
        operands.push_back(value);
    }
    void Add(spv::ImageOperandsMask new_mask, Id value1, Id value2) {
        mask = static_cast<spv::ImageOperandsMask>(static_cast<u32>(mask) |
                                                   static_cast<u32>(new_mask));
        operands.push_back(value1);
        operands.push_back(value2);
    }

    void AddOffset(EmitContext& ctx, const IR::Value& offset,
                   bool can_use_runtime_offsets = false) {
        if (offset.IsEmpty()) {
            return;
        }
        if (offset.IsImmediate()) {
            const s32 operand = offset.U32();
            Add(spv::ImageOperandsMask::ConstOffset, ctx.ConstS32(operand));
            return;
        }
        IR::Inst* const inst{offset.InstRecursive()};
        if (inst->AreAllArgsImmediates()) {
            switch (inst->GetOpcode()) {
            case IR::Opcode::CompositeConstructU32x2:
                Add(spv::ImageOperandsMask::ConstOffset,
                    ctx.ConstS32(static_cast<s32>(inst->Arg(0).U32()),
                                 static_cast<s32>(inst->Arg(1).U32())));
                return;
            case IR::Opcode::CompositeConstructU32x3:
                Add(spv::ImageOperandsMask::ConstOffset,
                    ctx.ConstS32(static_cast<s32>(inst->Arg(0).U32()),
                                 static_cast<s32>(inst->Arg(1).U32()),
                                 static_cast<s32>(inst->Arg(2).U32())));
                return;
            default:
                break;
            }
        }
        if (can_use_runtime_offsets) {
            Add(spv::ImageOperandsMask::Offset, ctx.Def(offset));
        } else {
            LOG_WARNING(Render_Vulkan,
                        "Runtime offset provided to unsupported image sample instruction");
        }
    }

    void AddDerivatives(EmitContext& ctx, Id derivatives_dx, Id derivatives_dy) {
        if (!Sirit::ValidId(derivatives_dx) || !Sirit::ValidId(derivatives_dy)) {
            return;
        }
        Add(spv::ImageOperandsMask::Grad, derivatives_dx, derivatives_dy);
    }

    spv::ImageOperandsMask mask{};
    boost::container::static_vector<Id, 4> operands;
};

// GT_BINDLESS_IMGARRAY: a windowed image's handle arrives as
// CompositeConstruct(packed bindings, runtime index) - opcodes.inc declares the operand
// Opaque, so the emitters take the IR::Value and unpack it here.
struct ImgUnpackedHandle {
    u32 packed;
    Id window_index{};
};

static ImgUnpackedHandle ImgUnpack(EmitContext& ctx, const IR::Value& handle) {
    if (handle.IsImmediate()) {
        return {handle.U32()};
    }
    const IR::Inst* composite = handle.InstRecursive();
    return {composite->Arg(0).U32(), ctx.Def(composite->Arg(1))};
}

// The OpUMin-clamped, NonUniform-decorated pointer into a windowed descriptor array.
static Id ImgWindowedPtr(EmitContext& ctx, const EmitContext::TextureDefinition& texture,
                         Id window_index) {
    ASSERT_MSG(Sirit::ValidId(window_index), "windowed image without a runtime index");
    const Id idx = ctx.OpUMin(ctx.U32[1], window_index, ctx.ConstU32(texture.num_bindings - 1));
    const Id ptr_type = ctx.TypePointer(spv::StorageClass::UniformConstant, texture.image_type);
    const Id ptr = ctx.OpAccessChain(ptr_type, texture.id, idx);
    ctx.Decorate(ptr, spv::Decoration::NonUniform);
    return ptr;
}

// Loads the image, going through the windowed descriptor array when the resource is one.
static Id ImgLoad(EmitContext& ctx, const EmitContext::TextureDefinition& texture,
                  Id window_index) {
    if (!texture.is_windowed) {
        return ctx.OpLoad(texture.image_type, texture.id);
    }
    const Id image = ctx.OpLoad(texture.image_type, ImgWindowedPtr(ctx, texture, window_index));
    ctx.Decorate(image, spv::Decoration::NonUniform);
    return image;
}

Id EmitImageSampleRaw(EmitContext& ctx, IR::Inst* inst, const IR::Value& handle, Id address1,
                      Id address2, Id address3, Id address4) {
    UNREACHABLE_MSG("Unreachable instruction");
}

Id EmitImageSampleImplicitLod(EmitContext& ctx, IR::Inst* inst, const IR::Value& handle,
                              Id coords, Id bias, const IR::Value& offset) {
    const auto [packed, window_index] = ImgUnpack(ctx, handle);
    const auto& texture = ctx.images[packed & 0xFFFF];
    const Id image = ImgLoad(ctx, texture, window_index);
    const Id result_type = texture.data_types->Get(4);
    const Id sampler = ctx.OpLoad(ctx.sampler_type, ctx.samplers[packed >> 16]);
    const Id sampled_image = ctx.OpSampledImage(texture.sampled_type, image, sampler);
    if (texture.is_windowed) {
        ctx.Decorate(sampled_image, spv::Decoration::NonUniform);
    }
    ImageOperands operands;
    operands.Add(spv::ImageOperandsMask::Bias, bias);
    operands.AddOffset(ctx, offset);
    const Id sample = ctx.OpImageSampleImplicitLod(result_type, sampled_image, coords,
                                                   operands.mask, operands.operands);
    return texture.is_integer ? ctx.OpBitcast(ctx.F32[4], sample) : sample;
}

Id EmitImageSampleExplicitLod(EmitContext& ctx, IR::Inst* inst, const IR::Value& handle,
                              Id coords, Id lod, const IR::Value& offset) {
    const auto [packed, window_index] = ImgUnpack(ctx, handle);
    const auto& texture = ctx.images[packed & 0xFFFF];
    const Id image = ImgLoad(ctx, texture, window_index);
    const Id result_type = texture.data_types->Get(4);
    const Id sampler = ctx.OpLoad(ctx.sampler_type, ctx.samplers[packed >> 16]);
    const Id sampled_image = ctx.OpSampledImage(texture.sampled_type, image, sampler);
    if (texture.is_windowed) {
        ctx.Decorate(sampled_image, spv::Decoration::NonUniform);
    }
    ImageOperands operands;
    operands.Add(spv::ImageOperandsMask::Lod, lod);
    operands.AddOffset(ctx, offset);
    const Id sample = ctx.OpImageSampleExplicitLod(result_type, sampled_image, coords,
                                                   operands.mask, operands.operands);
    return texture.is_integer ? ctx.OpBitcast(ctx.F32[4], sample) : sample;
}

Id EmitImageSampleDrefImplicitLod(EmitContext& ctx, IR::Inst* inst, const IR::Value& handle,
                                  Id coords, Id dref, Id bias, const IR::Value& offset) {
    const auto [packed, window_index] = ImgUnpack(ctx, handle);
    const auto& texture = ctx.images[packed & 0xFFFF];
    const Id image = ImgLoad(ctx, texture, window_index);
    const Id result_type = texture.data_types->Get(1);
    const Id sampler = ctx.OpLoad(ctx.sampler_type, ctx.samplers[packed >> 16]);
    const Id sampled_image = ctx.OpSampledImage(texture.sampled_type, image, sampler);
    if (texture.is_windowed) {
        ctx.Decorate(sampled_image, spv::Decoration::NonUniform);
    }
    ImageOperands operands;
    operands.Add(spv::ImageOperandsMask::Bias, bias);
    operands.AddOffset(ctx, offset);
    const Id sample = ctx.OpImageSampleDrefImplicitLod(result_type, sampled_image, coords, dref,
                                                       operands.mask, operands.operands);
    const Id sample_typed = texture.is_integer ? ctx.OpBitcast(ctx.F32[1], sample) : sample;
    return ctx.OpCompositeConstruct(ctx.F32[4], sample_typed, ctx.f32_zero_value,
                                    ctx.f32_zero_value, ctx.f32_zero_value);
}

Id EmitImageSampleDrefExplicitLod(EmitContext& ctx, IR::Inst* inst, const IR::Value& handle,
                                  Id coords, Id dref, Id lod, const IR::Value& offset) {
    const auto [packed, window_index] = ImgUnpack(ctx, handle);
    const auto& texture = ctx.images[packed & 0xFFFF];
    const Id image = ImgLoad(ctx, texture, window_index);
    const Id result_type = texture.data_types->Get(1);
    const Id sampler = ctx.OpLoad(ctx.sampler_type, ctx.samplers[packed >> 16]);
    const Id sampled_image = ctx.OpSampledImage(texture.sampled_type, image, sampler);
    if (texture.is_windowed) {
        ctx.Decorate(sampled_image, spv::Decoration::NonUniform);
    }
    ImageOperands operands;
    operands.Add(spv::ImageOperandsMask::Lod, lod);
    operands.AddOffset(ctx, offset);
    const Id sample = ctx.OpImageSampleDrefExplicitLod(result_type, sampled_image, coords, dref,
                                                       operands.mask, operands.operands);
    const Id sample_typed = texture.is_integer ? ctx.OpBitcast(ctx.F32[1], sample) : sample;
    return ctx.OpCompositeConstruct(ctx.F32[4], sample_typed, ctx.f32_zero_value,
                                    ctx.f32_zero_value, ctx.f32_zero_value);
}

Id EmitImageGather(EmitContext& ctx, IR::Inst* inst, const IR::Value& handle, Id coords,
                   const IR::Value& offset) {
    const auto [packed, window_index] = ImgUnpack(ctx, handle);
    const auto& texture = ctx.images[packed & 0xFFFF];
    const Id image = ImgLoad(ctx, texture, window_index);
    const Id result_type = texture.data_types->Get(4);
    const Id sampler = ctx.OpLoad(ctx.sampler_type, ctx.samplers[packed >> 16]);
    const Id sampled_image = ctx.OpSampledImage(texture.sampled_type, image, sampler);
    if (texture.is_windowed) {
        ctx.Decorate(sampled_image, spv::Decoration::NonUniform);
    }
    const u32 comp = inst->Flags<IR::TextureInstInfo>().gather_comp.Value();
    ImageOperands operands;
    operands.AddOffset(ctx, offset, true);
    const Id texels = ctx.OpImageGather(result_type, sampled_image, coords, ctx.ConstU32(comp),
                                        operands.mask, operands.operands);
    return texture.is_integer ? ctx.OpBitcast(ctx.F32[4], texels) : texels;
}

Id EmitImageGatherDref(EmitContext& ctx, IR::Inst* inst, const IR::Value& handle, Id coords,
                       const IR::Value& offset, Id dref) {
    const auto [packed, window_index] = ImgUnpack(ctx, handle);
    const auto& texture = ctx.images[packed & 0xFFFF];
    const Id image = ImgLoad(ctx, texture, window_index);
    const Id result_type = texture.data_types->Get(4);
    const Id sampler = ctx.OpLoad(ctx.sampler_type, ctx.samplers[packed >> 16]);
    const Id sampled_image = ctx.OpSampledImage(texture.sampled_type, image, sampler);
    if (texture.is_windowed) {
        ctx.Decorate(sampled_image, spv::Decoration::NonUniform);
    }
    ImageOperands operands;
    operands.AddOffset(ctx, offset, true);
    const Id texels = ctx.OpImageDrefGather(result_type, sampled_image, coords, dref, operands.mask,
                                            operands.operands);
    return texture.is_integer ? ctx.OpBitcast(ctx.F32[4], texels) : texels;
}

Id EmitImageQueryDimensions(EmitContext& ctx, IR::Inst* inst, u32 handle, Id lod, bool has_mips) {
    const auto& texture = ctx.images[handle & 0xFFFF];
    const Id image = ctx.OpLoad(texture.image_type, texture.id);
    const auto sharp = ctx.info.images[handle & 0xFFFF].GetSharp(ctx.info);
    const Id zero = ctx.u32_zero_value;
    const auto mips{[&] { return has_mips ? ctx.OpImageQueryLevels(ctx.U32[1], image) : zero; }};
    const bool uses_lod{texture.view_type != AmdGpu::ImageType::Color2DMsaa && !texture.is_storage};
    const auto query{[&](Id type) {
        return uses_lod ? ctx.OpImageQuerySizeLod(type, image, lod)
                        : ctx.OpImageQuerySize(type, image);
    }};
    switch (texture.view_type) {
    case AmdGpu::ImageType::Color1D:
        return ctx.OpCompositeConstruct(ctx.U32[4], query(ctx.U32[1]), zero, zero, mips());
    case AmdGpu::ImageType::Color1DArray:
    case AmdGpu::ImageType::Color2D:
    case AmdGpu::ImageType::Color2DMsaa:
        return ctx.OpCompositeConstruct(ctx.U32[4], query(ctx.U32[2]), zero, mips());
    case AmdGpu::ImageType::Color2DArray:
    case AmdGpu::ImageType::Color3D:
        return ctx.OpCompositeConstruct(ctx.U32[4], query(ctx.U32[3]), mips());
    default:
        UNREACHABLE_MSG("SPIR-V Instruction");
    }
}

Id EmitImageQueryLod(EmitContext& ctx, IR::Inst* inst, u32 handle, Id coords) {
    const auto& texture = ctx.images[handle & 0xFFFF];
    const Id image = ctx.OpLoad(texture.image_type, texture.id);
    const Id sampler = ctx.OpLoad(ctx.sampler_type, ctx.samplers[handle >> 16]);
    const Id sampled_image = ctx.OpSampledImage(texture.sampled_type, image, sampler);
    const Id zero{ctx.f32_zero_value};
    return ctx.OpImageQueryLod(ctx.F32[2], sampled_image, coords);
}

Id EmitImageGradient(EmitContext& ctx, IR::Inst* inst, const IR::Value& handle, Id coords,
                     Id derivatives_dx, Id derivatives_dy, const IR::Value& offset,
                     const IR::Value& lod_clamp) {
    const auto [packed, window_index] = ImgUnpack(ctx, handle);
    const auto& texture = ctx.images[packed & 0xFFFF];
    const Id image = ImgLoad(ctx, texture, window_index);
    const Id result_type = texture.data_types->Get(4);
    const Id sampler = ctx.OpLoad(ctx.sampler_type, ctx.samplers[packed >> 16]);
    const Id sampled_image = ctx.OpSampledImage(texture.sampled_type, image, sampler);
    if (texture.is_windowed) {
        ctx.Decorate(sampled_image, spv::Decoration::NonUniform);
    }
    ImageOperands operands;
    operands.AddDerivatives(ctx, derivatives_dx, derivatives_dy);
    operands.AddOffset(ctx, offset);
    const Id sample = ctx.OpImageSampleExplicitLod(result_type, sampled_image, coords,
                                                   operands.mask, operands.operands);
    return texture.is_integer ? ctx.OpBitcast(ctx.F32[4], sample) : sample;
}

Id EmitImageRead(EmitContext& ctx, IR::Inst* inst, const IR::Value& handle, Id coords, Id lod,
                 Id ms) {
    const auto [packed, window_index] = ImgUnpack(ctx, handle);
    const auto& texture = ctx.images[packed & 0xFFFF];
    const Id color_type = texture.data_types->Get(4);
    ImageOperands operands;
    operands.Add(spv::ImageOperandsMask::Sample, ms);
    Id texel;
    if (!texture.is_storage) {
        const Id image = ImgLoad(ctx, texture, window_index);
        if (texture.view_type != AmdGpu::ImageType::Color2DMsaa) {
            if (Sirit::ValidId(ms)) {
                LOG_ERROR(Render_Recompiler, "image is not MS but ms operand is provided");
            }
            operands.Add(spv::ImageOperandsMask::Lod, lod);
        }
        texel = ctx.OpImageFetch(color_type, image, coords, operands.mask, operands.operands);
    } else {
        Id image_ptr = texture.id;
        if (texture.is_windowed) {
            // Windowed + mip-fallback is rejected at patch time, so the array dimension is
            // exclusively the window's here.
            image_ptr = ImgWindowedPtr(ctx, texture, window_index);
        }
        if (ctx.profile.supports_image_load_store_lod) {
            operands.Add(spv::ImageOperandsMask::Lod, lod);
        } else if (Sirit::ValidId(lod) && !texture.is_windowed) {
            // Was UNREACHABLE ("confusing what interactions cause this path") - but an
            // UNREACHABLE in a user run costs the whole run. Mirror the EmitImageWrite clamp
            // below and report reachability instead; the first shader to land here tells us
            // the case exists.
            LOG_CRITICAL(Render_Recompiler,
                         "shader {:#x}: ImageRead with LOD took the mip-array fallback "
                         "(previously UNREACHABLE) - clamped to {} bindings",
                         ctx.info.pgm_hash, texture.num_bindings);
            ASSERT(texture.mip_fallback_mode == MipStorageFallbackMode::DynamicIndex);
            const Id single_image_ptr_type =
                ctx.TypePointer(spv::StorageClass::UniformConstant, texture.image_type);
            const Id lod_clamped =
                ctx.OpUMin(ctx.U32[1], lod, ctx.ConstU32(texture.num_bindings - 1));
            image_ptr = ctx.OpAccessChain(single_image_ptr_type, image_ptr,
                                          std::array{lod_clamped});
        }
        const Id image = ctx.OpLoad(texture.image_type, image_ptr);
        if (texture.is_windowed) {
            ctx.Decorate(image, spv::Decoration::NonUniform);
        }
        texel = ctx.OpImageRead(color_type, image, coords, operands.mask, operands.operands);
    }
    return texture.is_integer ? ctx.OpBitcast(ctx.F32[4], texel) : texel;
}

void EmitImageWrite(EmitContext& ctx, IR::Inst* inst, const IR::Value& handle, Id coords, Id lod,
                    Id ms, Id color) {
    const auto [packed, window_index] = ImgUnpack(ctx, handle);
    const auto& texture = ctx.images[packed & 0xFFFF];
    Id image_ptr = texture.id;
    const Id color_type = texture.data_types->Get(4);
    ImageOperands operands;
    operands.Add(spv::ImageOperandsMask::Sample, ms);
    if (texture.is_windowed) {
        // Windowed + mip-fallback is rejected at patch time; the array dimension is the
        // window's. cs_a95f906e (ImageWrite indexed by WorkgroupId.z) lands here.
        image_ptr = ImgWindowedPtr(ctx, texture, window_index);
    }
    if (ctx.profile.supports_image_load_store_lod) {
        operands.Add(spv::ImageOperandsMask::Lod, lod);
    } else if (Sirit::ValidId(lod) && !texture.is_windowed) {
        LOG_WARNING(Render, "Fallback for ImageWrite with LOD");
        ASSERT(texture.mip_fallback_mode == MipStorageFallbackMode::DynamicIndex);
        const Id single_image_ptr_type =
            ctx.TypePointer(spv::StorageClass::UniformConstant, texture.image_type);
        // CLAMP the runtime mip index to the descriptor array. The index comes from
        // GPU-driven data (flatbuf/dynrc), and with a warm pipeline cache this shader runs
        // before the game has written it - an unclamped garbage index reads a DESCRIPTOR
        // past the array, which the driver dereferences as a raw address: the deterministic
        // "IP 0x2000f1330 + ReadInvalid 0x300100000" device fault of runs 95-97, proven by
        // substitution in run 98 (stubbing this shader removed exactly that fault).
        const Id lod_clamped = ctx.OpUMin(ctx.U32[1], lod, ctx.ConstU32(texture.num_bindings - 1));
        image_ptr = ctx.OpAccessChain(single_image_ptr_type, image_ptr, std::array{lod_clamped});
    }
    const Id image = ctx.OpLoad(texture.image_type, image_ptr);
    if (texture.is_windowed) {
        ctx.Decorate(image, spv::Decoration::NonUniform);
    }
    // GT_IMGWRITE_SCRUB: contain Inf/NaN at the storage-image write boundary. A poisoned
    // light probe or bloom mip floods the whole frame white (the ramp over 2-3 s is the
    // probe filling face by face), and the dump analysis found a concrete NaN factory:
    // cs_da05e7f8 normalizes sample directions read from a dynrc window that can be all
    // zero at record time - normalize(0) = Inf/NaN, accumulated and written per mip. This
    // turns NaN into 0 and clamps to the fp16 range, so one bad dispatch's write cannot
    // permanently poison a persistent target.
    static const bool imgwrite_scrub = [] {
        const char* v = std::getenv("GT_IMGWRITE_SCRUB");
        return v && v[0] == '1';
    }();
    Id write_color = color;
    if (imgwrite_scrub && !texture.is_integer) {
        const Id nan_mask = ctx.OpIsNan(ctx.U1[4], write_color);
        const Id zero4 = ctx.ConstF32(0.f, 0.f, 0.f, 0.f);
        write_color = ctx.OpSelect(ctx.F32[4], nan_mask, zero4, write_color);
        const Id lo = ctx.ConstF32(-65504.f, -65504.f, -65504.f, -65504.f);
        const Id hi = ctx.ConstF32(65504.f, 65504.f, 65504.f, 65504.f);
        write_color = ctx.OpFClamp(ctx.F32[4], write_color, lo, hi);
    }
    const Id texel = texture.is_integer ? ctx.OpBitcast(color_type, write_color) : write_color;
    ctx.OpImageWrite(image, coords, texel, operands.mask, operands.operands);
}

Id EmitCubeFaceIndex(EmitContext& ctx, IR::Inst* inst, Id cube_coords) {
    if (ctx.profile.supports_native_cube_calc) {
        return ctx.OpCubeFaceIndexAMD(ctx.F32[1], cube_coords);
    } else {
        UNREACHABLE_MSG("SPIR-V Instruction");
    }
}

} // namespace Shader::Backend::SPIRV
