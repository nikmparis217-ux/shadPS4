// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#include <boost/container/set.hpp>
#include <boost/container/small_vector.hpp>
#include "common/types.h"

namespace Serialization {
struct Archive;
}

namespace Shader {

using PFN_SrtWalker = void PS4_SYSV_ABI (*)(const u32* /*user_data*/, u32* /*flat_dst*/);
PFN_SrtWalker RegisterWalkerCode(const u8* ptr, size_t size);

// GT_DYNRC_WINDOW (GT7): a ReadConst whose dword offset is computed at RUNTIME cannot be
// pre-copied field-by-field by the SRT walker (it does not know which fields). Instead the
// walker bulk-copies a WINDOW of the base pointer's guest memory into the flattened buffer
// and the shader indexes inside that window. The window is described in the instruction's
// 32-bit flags (flags==0 stays "unassigned" = the legacy read-flatbuf[0] fallback):
//   bit 31        set = windowed
//   bits 30..16   window base, in dwords into the flattened buffer (max 32767)
//   bits 15..0    window size, in dwords
constexpr u32 SrtWindowFlagBit = 0x80000000u;
// GT_BINDLESS_LOWER (GT7): this ReadConst was CREATED by the bindless lowering in the
// resource tracker (its base is a GPU-fetched V#, not an SRT pointer). It must ALWAYS
// emit the GPU-time read_const_dynamic path - independently of the global DMA setting,
// which stays OFF because routing EVERY shader through the BDA walk measured "very very
// slow" (run 74): the rasterizer then re-synchronizes all mapped ranges on every draw.
// With only this bit set, exactly the ~9 bindless shaders pay the DMA cost.
constexpr u32 SrtBindlessFlagBit = 0x40000000u;
constexpr u32 MakeSrtWindowFlags(u32 base_dw, u32 size_dw) {
    return SrtWindowFlagBit | (base_dw << 16) | size_dw;
}
constexpr u32 SrtWindowBaseDw(u32 flags) {
    return (flags >> 16) & 0x7FFFu;
}
constexpr u32 SrtWindowSizeDw(u32 flags) {
    return flags & 0xFFFFu;
}

struct PersistentSrtInfo {
    // Special case when fetch shader uses step rates.
    struct SrtSharpReservation {
        u32 sgpr_base;
        u32 dword_offset;
        u32 num_dwords;
    };

    PFN_SrtWalker walker_func{};
    size_t walker_func_size{};
    u32 flattened_bufsize_dw = 16; // NumUserDataRegs

    void Serialize(Serialization::Archive& ar) const;
    bool Deserialize(Serialization::Archive& ar);
};

} // namespace Shader
