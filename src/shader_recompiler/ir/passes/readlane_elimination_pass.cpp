// SPDX-FileCopyrightText: Copyright 2025 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include <unordered_map>
#include <queue>
#include "common/logging/log.h"
#include "shader_recompiler/ir/program.h"

namespace Shader::Optimization {

// GT7 run 237 (unifies runs 142/234/237 - all three were THIS): IR::Value is a union, so
// calling InstRecursive() on an IMMEDIATE value returns the constant's bits as an Inst*. In
// this emulator low addresses are mapped guest memory, so the garbage pointer READS - as
// zeroed-ish data: opcode 0 (= Phi), parent null - which is why it masqueraded as a
// "dangling phi" for three separate crashes (TrackSharp assert, then twice AV reading 0x8 in
// Inst::Use when a use was registered into the fake inst's null-headed use list).
// The immediate cases are all SEMANTICALLY WELL-DEFINED: an immediate register value holds
// that constant in every lane, so ReadLane of it IS the immediate. Handle, don't refuse.
//
// chain_broken is set when a WriteLane chain's BASE register resolves to an immediate (the
// chain ends without a matching lane write). The caller must then treat the chain's value
// for this lane as `inst->Arg(0).Resolve()` of the returned WriteLane, NOT Arg(1).
static IR::Inst* SearchChain(IR::Inst* inst, u32 lane, bool& chain_broken) {
    while (inst->GetOpcode() == IR::Opcode::WriteLane) {
        if (inst->Arg(2).U32() == lane) {
            // We found a possible write lane source, return it.
            return inst;
        }
        IR::Inst* const next = inst->Arg(0).TryInstRecursive();
        if (next == nullptr) {
            chain_broken = true;
            return inst;
        }
        inst = next;
    }
    return inst;
}

static bool IsPossibleToEliminate(IR::Inst* inst, u32 lane) {
    // Breadth-first search visiting the right most arguments first
    boost::container::small_vector<IR::Inst*, 16> visited;
    std::queue<IR::Inst*> queue;
    queue.push(inst);

    while (!queue.empty()) {
        // Pop one instruction from the queue
        IR::Inst* inst{queue.front()};
        queue.pop();

        // If it's a WriteLane search for possible candidates
        bool chain_broken = false;
        if (inst = SearchChain(inst, lane, chain_broken); inst->GetOpcode() == IR::Opcode::WriteLane) {
            // Either a matching write lane source, or (chain_broken) a chain whose base is
            // an immediate - the lane's value is that immediate. Both are eliminable.
            continue;
        }
        // If there are other instructions in-between that use the value we can't eliminate.
        if (inst->GetOpcode() != IR::Opcode::ReadLane && inst->GetOpcode() != IR::Opcode::Phi) {
            return false;
        }
        // GT7 runs 234/237: what looked like a DANGLING node in vs 0x41e57240 was in fact an
        // IMMEDIATE phi argument dereferenced as an Inst* (see the SearchChain comment) - the
        // fake pointer read guest memory as opcode 0 (= Phi) with a null parent. The immediate
        // routes are handled properly now; this stays as defense in depth for any REAL corpse:
        // nothing on a parentless node is safe to touch, so refuse the elimination outright.
        if (!inst->HasParent()) {
            LOG_ERROR(Render_Recompiler,
                      "ReadLane chain reaches a parentless (likely dangling) node - elimination "
                      "refused, ReadLane kept");
            return false;
        }
        // Visit the right most arguments first
        for (size_t arg = inst->NumArgs(); arg--;) {
            auto arg_value{inst->Arg(arg)};
            if (arg_value.IsImmediate()) {
                continue;
            }
            // Queue instruction if it hasn't been visited
            IR::Inst* arg_inst{arg_value.InstRecursive()};
            if (std::ranges::find(visited, arg_inst) == visited.end()) {
                visited.push_back(arg_inst);
                queue.push(arg_inst);
            }
        }
    }
    return true;
}

using PhiMap = std::unordered_map<IR::Inst*, IR::Inst*>;

static IR::Value GetRealValue(PhiMap& phi_map, IR::Inst* inst, u32 lane) {
    // If this is a WriteLane op search the chain for a possible candidate.
    bool chain_broken = false;
    if (inst = SearchChain(inst, lane, chain_broken); inst->GetOpcode() == IR::Opcode::WriteLane) {
        if (chain_broken) {
            // No write to this lane anywhere in the chain and the base register is an
            // immediate: every untouched lane holds the base constant.
            return inst->Arg(0).Resolve();
        }
        return inst->Arg(1);
    }

    // If this is a phi, duplicate it and populate its arguments with real values.
    if (inst->GetOpcode() == IR::Opcode::Phi) {
        // We are in a phi cycle, use the already duplicated phi.
        const auto [it, is_new_phi] = phi_map.try_emplace(inst);
        if (!is_new_phi) {
            return IR::Value{it->second};
        }

        if (!inst->HasParent()) {
            // Twin of the TrackSharp guard (run 142's GetParent assert): a phi with no parent
            // block cannot host a duplicate. Hand back the phi itself - the original value,
            // lane-writes kept - instead of asserting the session away.
            LOG_ERROR(Render_Recompiler, "ReadLane phi without a parent block - kept as-is");
            it->second = inst;
            return IR::Value{inst};
        }

        // Create new phi and insert it right before the old one.
        const auto insert_point = IR::Block::InstructionList::s_iterator_to(*inst);
        IR::Block* block = inst->GetParent();
        IR::Inst* new_phi{&*block->PrependNewInst(insert_point, IR::Opcode::Phi)};
        new_phi->SetFlags(IR::Type::U32);
        it->second = new_phi;

        // Gather all arguments.
        boost::container::static_vector<IR::Value, 5> phi_args;
        for (size_t arg_index = 0; arg_index < inst->NumArgs(); arg_index++) {
            const IR::Value arg_value = inst->Arg(arg_index).Resolve();
            if (arg_value.IsImmediate()) {
                // THE run 142/234/237 crash: this used to call InstRecursive() on the
                // immediate, turning the constant's bits into a fake Inst*. An immediate
                // phi argument means every lane holds that constant on this path, so the
                // lane's real value is simply the immediate itself.
                phi_args.push_back(arg_value);
                continue;
            }
            const IR::Value arg = GetRealValue(phi_map, arg_value.InstRecursive(), lane);
            phi_args.push_back(arg);
        }
        const IR::Value arg0 = phi_args[0].Resolve();
        if (std::ranges::all_of(phi_args,
                                [&](const IR::Value& arg) { return arg.Resolve() == arg0; })) {
            new_phi->ReplaceUsesWith(arg0);
        } else {
            for (size_t arg_index = 0; arg_index < inst->NumArgs(); arg_index++) {
                new_phi->AddPhiOperand(inst->PhiBlock(arg_index), phi_args[arg_index]);
            }
        }
        return IR::Value{new_phi};
    }
    UNREACHABLE();
}

void ReadLaneEliminationPass(IR::Program& program) {
    PhiMap phi_map;
    for (IR::Block* const block : program.blocks) {
        for (IR::Inst& inst : block->Instructions()) {
            if (inst.GetOpcode() != IR::Opcode::ReadLane) {
                continue;
            }
            if (!inst.Arg(1).IsImmediate()) {
                continue;
            }

            const u32 lane = inst.Arg(1).U32();
            if (inst.Arg(0).Resolve().IsImmediate()) {
                // ReadLane of an immediate register value: every lane holds the constant.
                inst.ReplaceUsesWith(inst.Arg(0).Resolve());
                continue;
            }
            IR::Inst* prod = inst.Arg(0).InstRecursive();

            // Check simple case of no control flow and phis
            bool chain_broken = false;
            if (prod = SearchChain(prod, lane, chain_broken);
                prod->GetOpcode() == IR::Opcode::WriteLane) {
                // chain_broken: no write to this lane, immediate base - the value is the base.
                inst.ReplaceUsesWith(chain_broken ? prod->Arg(0).Resolve() : prod->Arg(1));
                continue;
            }

            // Traverse the phi tree to see if it's possible to eliminate
            if (prod->GetOpcode() == IR::Opcode::Phi && IsPossibleToEliminate(prod, lane)) {
                inst.ReplaceUsesWith(GetRealValue(phi_map, prod, lane));
                phi_map.clear();
            }
        }
    }
}

} // namespace Shader::Optimization
