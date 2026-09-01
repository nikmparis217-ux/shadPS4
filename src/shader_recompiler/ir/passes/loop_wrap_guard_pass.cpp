// SPDX-FileCopyrightText: Copyright 2026 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include <algorithm>
#include <cstdlib>
#include <string_view>

#include <boost/container/small_vector.hpp>

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
static bool IsStepOf(const IR::Value& incoming, const IR::Inst* phi, u32 step_imm) {
    if (incoming.IsImmediate()) {
        return false;
    }
    const IR::Inst* const producer = incoming.InstRecursive();
    if (producer->GetOpcode() == IR::Opcode::IAdd32) {
        const IR::Value lhs = producer->Arg(0);
        const IR::Value rhs = producer->Arg(1);
        return !lhs.IsImmediate() && lhs.InstRecursive() == phi && rhs.IsImmediate() &&
               rhs.U32() == step_imm;
    }
    if (step_imm == 0xFFFFFFFFu && producer->GetOpcode() == IR::Opcode::ISub32) {
        const IR::Value lhs = producer->Arg(0);
        const IR::Value rhs = producer->Arg(1);
        return !lhs.IsImmediate() && lhs.InstRecursive() == phi && rhs.IsImmediate() &&
               rhs.U32() == 1u;
    }
    return false;
}

// A comparison is only a LOOP EXIT if its result feeds nothing but branch conditions -
// ConditionRef, reached through boolean plumbing (LogicalNot / LogicalAnd / LogicalOr) and
// through boolean PHIS. Both plumbing kinds are measured facts of hs_0x3827418d's real
// do-while exit (shaders/hs_3827418d.spvasm):
//     %488 = OpINotEqual(1, counter_phi)
//     %489 = OpLogicalAnd(%206, %488)      -> OpBranchConditional   (run 239's miss: the And)
//     %206 = OpPhi(true, %489)             <- %489 ALSO feeds the "keep going" phi of the
//                                             next iteration (run 241's miss: the Phi)
// A gate that stopped at either link silently refused to rewrite the very shader this pass
// was built for, twice - runs 239 and 241 both died on the same wrap hang with the guard
// present. The phi is condition plumbing like the And: for every count a real console can
// produce the rewritten compare computes identical values on every iteration, so the phi'd
// copy is identical too. An in-body `i != x` used as a VALUE (arithmetic, select, store)
// must still NOT be rewritten: `<` is not equivalent to `!=` there even for valid data.
// Iterative worklist with a visited set - phi -> and -> phi is a real cycle here.
static bool OnlyFeedsBranchConditions(IR::Inst& root, std::string_view* refused_by) {
    boost::container::small_vector<IR::Inst*, 8> worklist{&root};
    boost::container::small_vector<const IR::Inst*, 16> visited;
    while (!worklist.empty()) {
        IR::Inst* const inst = worklist.back();
        worklist.pop_back();
        if (std::ranges::find(visited, inst) != visited.end()) {
            continue;
        }
        visited.push_back(inst);
        if (visited.size() > 64) {
            *refused_by = "plumbing too large";
            return false;
        }
        if (!inst->HasUses()) {
            // A dead comparison decides nothing; leave it alone.
            *refused_by = "no uses";
            return false;
        }
        for (const auto& [user, arg_index] : inst->Uses()) {
            switch (user->GetOpcode()) {
            case IR::Opcode::ConditionRef:
                continue;
            case IR::Opcode::LogicalNot:
            case IR::Opcode::LogicalAnd:
            case IR::Opcode::LogicalOr:
            case IR::Opcode::Phi:
                worklist.push_back(user);
                continue;
            default:
                *refused_by = IR::NameOf(user->GetOpcode());
                return false;
            }
        }
    }
    return true;
}

// step_imm 0xFFFFFFFF = decrement-by-one (IAdd -1 or ISub 1); step_imm 1 = increment-by-one.
static const IR::Inst* AsSteppingPhi(const IR::Value& value, u32 step_imm) {
    if (value.IsImmediate()) {
        return nullptr;
    }
    const IR::Inst* const inst = value.InstRecursive();
    if (inst->GetOpcode() != IR::Opcode::Phi) {
        return nullptr;
    }
    for (size_t i = 0; i < inst->NumArgs(); ++i) {
        if (IsStepOf(inst->Arg(i), inst, step_imm)) {
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
            std::string_view refused_by{};
            if (!OnlyFeedsBranchConditions(inst, &refused_by)) {
                // Near-miss forensics: a stepping-phi compare the gate refused is exactly the
                // shape that cost runs 239 and 241 (the And link, then the Phi link). Name the
                // refusing user so the NEXT mismatch is one log line instead of a blind run.
                if (AsSteppingPhi(inst.Arg(0), 0xFFFFFFFFu) || AsSteppingPhi(inst.Arg(1), 0xFFFFFFFFu) ||
                    AsSteppingPhi(inst.Arg(0), 1u) || AsSteppingPhi(inst.Arg(1), 1u)) {
                    LOG_WARNING(Render_Recompiler,
                                "[loopguard] shader {:#x}: stepping-phi INotEqual NOT rewritten - "
                                "its result feeds '{}', not only branch conditions",
                                program.info.pgm_hash, refused_by);
                }
                continue;
            }
            const IR::Value a = inst.Arg(0);
            const IR::Value b = inst.Arg(1);
            const IR::Inst* phi = nullptr;
            // Shape 1 (hs_0x3827418d): DECREMENTING phi, small immediate exit constant.
            //     INotEqual(phi--, C)  ->  UGreaterThan(phi, C)
            u32 exit_const = 0;
            if (b.IsImmediate() && (phi = AsSteppingPhi(a, 0xFFFFFFFFu)) != nullptr) {
                exit_const = b.U32();
            } else if (a.IsImmediate() && (phi = AsSteppingPhi(b, 0xFFFFFFFFu)) != nullptr) {
                exit_const = a.U32();
                // Operand order flips: INotEqual(C, phi) becomes UGreaterThan(phi, C).
                inst.SetArg(0, b);
                inst.SetArg(1, a);
            } else {
                phi = nullptr;
            }
            if (phi != nullptr && exit_const <= MaxExitConst) {
                inst.ReplaceOpcode(IR::Opcode::UGreaterThan32);
                ++rewrites;
                continue;
            }
            // Shape 2 (cs_0xef4a0dc6, the garage new-car-load hang, run 236b): INCREMENTING
            // phi with the exit bound LOADED from a buffer (start and end both come from
            // memory). Real data always has start <= end, where `counter != end` and
            // `counter < end` select identical iteration counts (the +1 step passes through
            // every value, so it hits `end` exactly). Zero/garbage data can deliver
            // start > end, which `!=` turns into a 2^32-iteration wrap - `<` exits at once.
            // The end value being non-immediate is the POINT here, so no MaxExitConst gate.
            //     INotEqual(phi++, end)  ->  ULessThan(phi, end)
            if ((phi = AsSteppingPhi(a, 1u)) != nullptr && (b.IsImmediate() || b.InstRecursive() != phi)) {
                inst.ReplaceOpcode(IR::Opcode::ULessThan32);
                ++rewrites;
            } else if ((phi = AsSteppingPhi(b, 1u)) != nullptr &&
                       (a.IsImmediate() || a.InstRecursive() != phi)) {
                // Operand order flips: INotEqual(end, phi) becomes ULessThan(phi, end).
                inst.SetArg(0, b);
                inst.SetArg(1, a);
                inst.ReplaceOpcode(IR::Opcode::ULessThan32);
                ++rewrites;
            }
        }
    }
    if (rewrites != 0) {
        LOG_INFO(Render_Recompiler, "[loopguard] shader {:#x}: {} wrap-prone loop exit(s) made "
                 "wrap-proof (INotEqual -> ordered compare on a +/-1 stepping counter)",
                 program.info.pgm_hash, rewrites);
    }
}

} // namespace Shader::Optimization
