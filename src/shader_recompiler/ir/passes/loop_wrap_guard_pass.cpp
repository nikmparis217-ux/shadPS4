// SPDX-FileCopyrightText: Copyright 2026 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include <cstdlib>

#include "common/logging/log.h"
#include "shader_recompiler/ir/program.h"

namespace Shader::Optimization {

// GT7 lane, runs 231/235/236 (the main-game GPU hang, convicted by GT_SKIP_TESS):
// hs_0x3827418d's control-point loop is a do-while whose counter DECREMENTS by 1 and whose
// exit test is `counter != 1`. On real hardware the game always feeds it a count >= 1, so the
// test is fine there. Under the emulator the count can arrive as 0 (the first-GPU-read-zeros
// family: the SRT/flatbuf page is not registered yet at loading time), and `0 != 1` then
// wraps the counter through the FULL 32-bit range - 4.3 billion iterations of a 6-load body,
// i.e. the "one draw that starts and never retires" device loss.
//
// GT_LOOP_WRAP_GUARD=1 rewrites exactly that shape:
//     INotEqual32(counter_phi, C)  ->  UGreaterThan32(counter_phi, C)   (unsigned)
// but ONLY when the phi provably decrements by one (an incoming value IAdd32(phi, 0xFFFFFFFF)
// or ISub32(phi, 1)) and C is a small immediate. For every count a real console can produce
// the two tests select identical iteration counts (N-1 passes from N down to C); they differ
// only in the wrap case, where `>` exits after the first pass instead of looping 2^32 times.
// An up-counting phi is deliberately NOT rewritten - `>` would kill such a loop instantly.
static bool IsDecrementOf(const IR::Value& incoming, const IR::Inst* phi) {
    if (incoming.IsImmediate()) {
        return false;
    }
    const IR::Inst* const producer = incoming.InstRecursive();
    if (producer->GetOpcode() == IR::Opcode::IAdd32) {
        const IR::Value lhs = producer->Arg(0);
        const IR::Value rhs = producer->Arg(1);
        return !lhs.IsImmediate() && lhs.InstRecursive() == phi && rhs.IsImmediate() &&
               rhs.U32() == 0xFFFFFFFFu;
    }
    if (producer->GetOpcode() == IR::Opcode::ISub32) {
        const IR::Value lhs = producer->Arg(0);
        const IR::Value rhs = producer->Arg(1);
        return !lhs.IsImmediate() && lhs.InstRecursive() == phi && rhs.IsImmediate() &&
               rhs.U32() == 1u;
    }
    return false;
}

static const IR::Inst* AsDecrementingPhi(const IR::Value& value) {
    if (value.IsImmediate()) {
        return nullptr;
    }
    const IR::Inst* const inst = value.InstRecursive();
    if (inst->GetOpcode() != IR::Opcode::Phi) {
        return nullptr;
    }
    for (size_t i = 0; i < inst->NumArgs(); ++i) {
        if (IsDecrementOf(inst->Arg(i), inst)) {
            return inst;
        }
    }
    return nullptr;
}

void LoopWrapGuardPass(IR::Program& program) {
    static const bool enabled = [] {
        const char* v = std::getenv("GT_LOOP_WRAP_GUARD");
        return v && v[0] == '1';
    }();
    if (!enabled) {
        return;
    }
    // Small bound only: the observed exit constant is 1, and a large constant would make the
    // "legit start below C" case (which `>` exits and `!=` wraps) more plausible.
    constexpr u32 MaxExitConst = 4;
    u32 rewrites = 0;
    for (IR::Block* const block : program.blocks) {
        for (IR::Inst& inst : block->Instructions()) {
            if (inst.GetOpcode() != IR::Opcode::INotEqual32) {
                continue;
            }
            const IR::Value a = inst.Arg(0);
            const IR::Value b = inst.Arg(1);
            const IR::Inst* phi = nullptr;
            u32 exit_const = 0;
            if (b.IsImmediate() && (phi = AsDecrementingPhi(a)) != nullptr) {
                exit_const = b.U32();
            } else if (a.IsImmediate() && (phi = AsDecrementingPhi(b)) != nullptr) {
                exit_const = a.U32();
                // Operand order flips: INotEqual(C, phi) becomes UGreaterThan(phi, C).
                inst.SetArg(0, b);
                inst.SetArg(1, a);
            } else {
                continue;
            }
            if (exit_const > MaxExitConst) {
                continue;
            }
            inst.ReplaceOpcode(IR::Opcode::UGreaterThan32);
            ++rewrites;
        }
    }
    if (rewrites != 0) {
        LOG_INFO(Render_Recompiler, "[loopguard] shader {:#x}: {} wrap-prone loop exit(s) made "
                 "wrap-proof (INotEqual -> UGreaterThan on a decrementing counter)",
                 program.info.pgm_hash, rewrites);
    }
}

} // namespace Shader::Optimization
