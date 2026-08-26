// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#include <cstdlib>

#include <boost/container/set.hpp>
#include <boost/container/small_vector.hpp>
#include "common/types.h"

namespace Serialization {
struct Archive;
}

namespace Shader {

using PFN_SrtWalker = void PS4_SYSV_ABI (*)(const u32* /*user_data*/, u32* /*flat_dst*/);
PFN_SrtWalker RegisterWalkerCode(const u8* ptr, size_t size);

// The absolute host address the emitted walkers bake into their machine code (the
// CopyDynrcWindowClamped call). The pipeline cache's BuildGeneration hashes it so a cached
// walker can never be replayed by a binary whose helper moved (runs 170/171: a relink of
// uncommitted local edits shifted the helper, the scm-string generation stayed identical,
// and the stale imm64 called mid-instruction into .text - a deterministic write AV).
uintptr_t SrtWalkerHelperAddress();

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

// GT_DYNRC_GPU=1 (GT7): route WINDOWED dynamic ReadConsts through the GPU-time
// read_const_dynamic (the BDA walk) even with global DMA off. The window in the flatbuf is a
// RECORD-time snapshot; the guest tables the three GT7 producers read are written by earlier
// GPU dispatches, so the snapshot can be stale/wrong - the honest read sees GPU-time memory.
// Cost: every shader carrying a window pays the rasterizer's per-draw all-mapped-ranges
// re-sync (uses_dma) - run-74's disease at reduced scale, ~3 producers instead of everything.
// ⚠ COMPILE-AFFECTING: flipping this env needs a pipeline-cache wipe (the run-117 law).
inline bool DynrcGpuReadsEnabled() {
    static const bool enabled = [] {
        const char* v = std::getenv("GT_DYNRC_GPU");
        return v && v[0] == '1';
    }();
    return enabled;
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
