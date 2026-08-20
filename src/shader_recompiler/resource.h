// SPDX-FileCopyrightText: Copyright 2025 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#include <cstring>
#include "common/types.h"
#include "core/memory.h"
#include "shader_recompiler/ir/type.h"
#include "video_core/amdgpu/resource.h"

#include <boost/container/static_vector.hpp>

namespace Shader {

static constexpr u32 NUM_USER_DATA_REGS = 16;
static constexpr u32 NUM_IMAGES = 64;
static constexpr u32 NUM_BUFFERS = 40;
static constexpr u32 NUM_SAMPLERS = 16;
static constexpr u32 NUM_FMASKS = 8;

enum class BufferType : u32 {
    Guest,
    Flatbuf,
    BdaPagetable,
    FaultBuffer,
    GdsBuffer,
    SharedMemory,
    ClipPlanes,
};

struct Info;

struct BufferResource {
    u32 sharp_idx;
    IR::Type used_types;
    AmdGpu::Buffer inline_cbuf;
    BufferType buffer_type;
    u8 instance_attrib{};
    bool is_written{};
    bool is_formatted{};

    bool IsSpecial() const noexcept {
        return buffer_type != BufferType::Guest;
    }

    bool IsStorage([[maybe_unused]] const AmdGpu::Buffer buffer) const noexcept {
        // When using uniform buffers, a size is required at compilation time, so we need to
        // either compile a lot of shader specializations to handle each size or just force it to
        // the maximum possible size always. However, for some vendors the shader-supplied size is
        // used for bounds checking uniform buffer accesses, so the latter would effectively turn
        // off buffer robustness behavior. Instead, force storage buffers which are bounds checked
        // using the actual buffer size. We are assuming the performance hit from this is
        // acceptable.
        return true; // buffer.GetSize() > profile.max_ubo_size || is_written;
    }

    constexpr AmdGpu::Buffer GetSharp(const auto& info) const noexcept {
        AmdGpu::Buffer buffer{};
        if (inline_cbuf) {
            buffer = inline_cbuf;
            if (inline_cbuf.base_address != 1) {
                buffer.base_address += info.pgm_base; // address fixup
            }
        } else {
            buffer = info.template ReadUdSharp<AmdGpu::Buffer>(sharp_idx);
        }
        if (!buffer.Valid()) {
            LOG_DEBUG(Render, "Encountered invalid buffer sharp");
            return AmdGpu::Buffer::Null();
        }
        return buffer;
    }
};
using BufferResourceList = boost::container::static_vector<BufferResource, NUM_BUFFERS>;

// GT7 bindless (19 Aug): read a T#/S# straight out of guest memory. Used by resources
// whose sharp does not live in the SRT snapshot: the descriptor is stored in a buffer the
// game indexes at GPU time, but at a CONSTANT offset inside a TRACKED buffer - so its
// address is known whenever GetSharp runs (compile, specialization and bind all re-read
// it, so a game-side update is picked up on the next bind). A garbage V# returns a zeroed
// sharp, which every caller already treats as invalid.
template <typename SharpT>
SharpT ReadGuestSharp(const auto& info, s32 buf_index, u32 off_dw) noexcept {
    SharpT ret{};
    const AmdGpu::Buffer vsharp = info.buffers[buf_index].GetSharp(info);
    const u64 addr = vsharp.base_address + u64(off_dw) * 4;
    if (!vsharp.Valid() || vsharp.base_address < 0x10000 ||
        addr + sizeof(SharpT) >= (u64{1} << 40)) {
        return ret;
    }
    // Range guards are NOT enough: runs 93/94 crashed the MAIN thread at BOOT dereferencing
    // a plausible-but-unmapped guest address - the pipeline cache rebuilds pipelines (and so
    // re-runs GetSharp) before the game has mapped the table this V# points at. The same
    // mechanism is the prime suspect for the run-83/84 "boot fault with images on" verdict.
    // ⚠ IsValidMapping is NOT the right test (run 94 proved it): it answers "is this range
    // inside the VMA map", and the map contains FREE VMAs - a Free area passes it and the
    // memcpy still faults. IsMappedMemory asks the VMA itself.
    if (!Core::Memory::Instance()->IsMappedMemory(addr, sizeof(SharpT))) {
        return ret;
    }
    std::memcpy(&ret, reinterpret_cast<const void*>(addr), sizeof(SharpT));
    return ret;
}

enum class MipStorageFallbackMode : u32 { None, DynamicIndex, ConstantIndex };

struct ImageResource {
    u32 sharp_idx;
    // GT7 bindless: when >= 0 the T# is ReadGuestSharp'd from buffer resource
    // [deref_buffer] at deref_offset_dw dwords, instead of the SRT snapshot.
    s32 deref_buffer{-1};
    u32 deref_offset_dw{};
    bool is_depth{};
    bool is_atomic{};
    bool is_array{};
    bool is_written{};
    bool is_r128{};
    MipStorageFallbackMode mip_fallback_mode{};
    u32 constant_mip_index{};
    // The descriptor COUNT the compiled SPIR-V module was built against, persisted with the
    // module (run 116): NumBindings() re-reads the LIVE T#, and a warm-cache preload rebuilds
    // the set layout BEFORE the game has written that T# - descriptorCount=1 under a module
    // carrying TypeArray(image, 9), and BindTextures then writes 9 descriptors into a 1-slot
    // binding = the ReadInvalid 0x300100000 family. Layout, module array, clamp and bind count
    // must all come from THIS value; the live count is only a specialization signal.
    u32 num_bindings_baked{0};

    constexpr AmdGpu::Image GetSharp(const auto& info) const noexcept {
        AmdGpu::Image image{};
        if (deref_buffer >= 0) {
            if (!is_r128) {
                image = ReadGuestSharp<AmdGpu::Image>(info, deref_buffer, deref_offset_dw);
            } else {
                const auto raw = ReadGuestSharp<u128>(info, deref_buffer, deref_offset_dw);
                std::memcpy(&image, &raw, sizeof(raw));
                image.pitch = image.width;
            }
            // Junk-table guard (19 Aug, run 81): a T# read before the game has written the
            // table is random bits, and its "address" walked ResolveOverlaps into wild
            // memory (Image::Address() spans 46 bits, the guest space only 40). Treat it
            // as no image this frame; the next bind re-reads the table.
            const u64 va = image.Address();
            if (va < 0x10000 || va + 4096 >= (u64{1} << 40)) {
                return AmdGpu::Image::Null(is_depth);
            }
        } else if (!is_r128) {
            image = info.template ReadUdSharp<AmdGpu::Image>(sharp_idx);
        } else {
            const auto raw = info.template ReadUdSharp<u128>(sharp_idx);
            std::memcpy(&image, &raw, sizeof(raw));
            image.pitch = image.width;
        }
        if (!image.Valid()) {
            LOG_DEBUG(Render_Vulkan, "Encountered invalid image sharp");
            image = AmdGpu::Image::Null(is_depth);
        } else if (is_depth) {
            const auto data_fmt = image.GetDataFmt();
            if (data_fmt != AmdGpu::DataFormat::Format16 &&
                data_fmt != AmdGpu::DataFormat::Format32) {
                LOG_DEBUG(Render_Vulkan,
                          "Encountered non-depth image used with depth instruction!");
                image = AmdGpu::Image::Null(true);
            }
        }
        return image;
    }

    u32 NumBindings(const auto& info) const {
        const AmdGpu::Image tsharp = GetSharp(info);
        return (mip_fallback_mode == MipStorageFallbackMode::DynamicIndex)
                   ? (tsharp.last_level - tsharp.base_level + 1)
                   : 1;
    }

    // The count everything baked-per-module must use (set layout, SPIR-V array size, bind-time
    // descriptor writes). 0 = a record from before the field existed; fall back to live.
    u32 NumBindingsBaked(const auto& info) const {
        return num_bindings_baked != 0 ? num_bindings_baked : NumBindings(info);
    }
};
using ImageResourceList = boost::container::static_vector<ImageResource, NUM_IMAGES>;

struct SamplerResource {
    u32 sharp_idx;
    // GT7 bindless: same guest-memory deref as ImageResource.
    s32 deref_buffer{-1};
    u32 deref_offset_dw{};
    AmdGpu::Sampler inline_sampler;
    u32 is_inline_sampler : 1;
    u32 associated_image : 4;
    u32 disable_aniso : 1;

    constexpr AmdGpu::Sampler GetSharp(const auto& info) const noexcept {
        if (deref_buffer >= 0) {
            return ReadGuestSharp<AmdGpu::Sampler>(info, deref_buffer, deref_offset_dw);
        }
        return is_inline_sampler ? inline_sampler
                                 : info.template ReadUdSharp<AmdGpu::Sampler>(sharp_idx);
    }
};
using SamplerResourceList = boost::container::static_vector<SamplerResource, NUM_SAMPLERS>;

struct FMaskResource {
    u32 sharp_idx;

    constexpr AmdGpu::Image GetSharp(const auto& info) const noexcept {
        return info.template ReadUdSharp<AmdGpu::Image>(sharp_idx);
    }
};
using FMaskResourceList = boost::container::static_vector<FMaskResource, NUM_FMASKS>;

struct PushData {
    static constexpr u32 XOffsetIndex = 0;
    static constexpr u32 YOffsetIndex = 1;
    static constexpr u32 XScaleIndex = 2;
    static constexpr u32 YScaleIndex = 3;
    static constexpr u32 UdRegsIndex = 4;
    static constexpr u32 BufOffsetIndex = UdRegsIndex + NUM_USER_DATA_REGS / 4;

    float xoffset;
    float yoffset;
    float xscale;
    float yscale;
    std::array<u32, NUM_USER_DATA_REGS> ud_regs;
    std::array<u8, NUM_BUFFERS> buf_offsets;

    void AddOffset(u32 binding, u32 offset) {
        ASSERT(offset < 256 && binding < buf_offsets.size());
        buf_offsets[binding] = offset;
    }
};
static_assert(sizeof(PushData) <= 128,
              "PushData size is greater than minimum size guaranteed by Vulkan spec");

} // namespace Shader
