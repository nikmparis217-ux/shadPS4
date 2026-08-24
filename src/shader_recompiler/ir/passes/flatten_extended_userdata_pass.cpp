// SPDX-FileCopyrightText: Copyright 2024-2026 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include <algorithm>
#include <unordered_map>
#include <boost/container/flat_map.hpp>
#include <xbyak/xbyak.h>
#include <xbyak/xbyak_util.h>
#include "common/arch.h"
#include "common/decoder.h"
#include "common/io_file.h"
#include "common/logging/log.h"
#include "common/path_util.h"
#include "common/signal_context.h"
#include "core/emulator_settings.h"
#include "core/memory.h"
#include "core/signals.h"
#include "shader_recompiler/info.h"
#include "shader_recompiler/ir/breadth_first_search.h"
#include "shader_recompiler/ir/opcodes.h"
#include "shader_recompiler/ir/passes/srt.h"
#include "shader_recompiler/ir/program.h"
#include "shader_recompiler/ir/reg.h"
#include "shader_recompiler/ir/srt_gvn_table.h"
#include "shader_recompiler/ir/value.h"

#ifdef ARCH_X86_64

using namespace Xbyak::util;

static Xbyak::CodeGenerator g_srt_codegen(32_MB);
static const u8* g_srt_codegen_start = nullptr;

// The dynrc window copy, clamped to what is actually mapped. Replaces the walker's blind
// dword loop: that loop overran small tables into unmapped memory (runs 125-128: 32 walkers
// faulted at the two region ends 0x204800000 / 0x206e00000 during ONE race load) and the
// signal handler then patched the loop's load to xor - PERMANENTLY - so 32 race shaders read
// all-zero windows for the rest of the session. Their garbage outputs are the leading suspect
// for the corrupted GPU-driven stream (SearchBinaryInfo garbage shader address, ACB PM4
// opcode 0xff) AND the wrong on-track visuals. This helper runs PER DISPATCH: it copies the
// mapped prefix and zeroes only the tail, so a table that becomes mapped later is picked up
// again instead of being zeroed forever.
// ⚠ Serialized walkers embed this function's ABSOLUTE address - safe ONLY because the exe is
// linked /DYNAMICBASE:NO /BASE:0x700000000000 (CMakeLists.txt:1359/1373), so the address is
// identical in every process. If ASLR is ever enabled, serialized walkers must be invalidated.
// ⚠ TOCTOU: the game can unmap between the clamp and the memcpy - the same exposure every
// ReadGuestSharp memcpy already has. A fault here lands OUTSIDE the walker code range, so the
// SrtWalkerSignalHandler will not patch anything; it would be a plain guest-crash dump.
static void PS4_SYSV_ABI CopyDynrcWindowClamped(const u32* src, u32* dst, u64 size_dw) {
    auto* memory = Core::Memory::Instance();
    const VAddr src_addr = reinterpret_cast<VAddr>(src);
    const u64 want_bytes = size_dw * sizeof(u32);
    // ⚠ NOT ClampRangeSize: it returns the size UNCHANGED below MinSizeToClamp (1 GB,
    // memory.cpp:103-107) - the first version of this helper trusted it, memcpy'd blind and
    // died in the CRT reading 0x204e00000 (run 129). Ask IsMappedMemory PER PAGE instead:
    // per page, not for the whole range, because Contains() wants the range inside ONE vma
    // and a window legitimately spanning two adjacent mapped vmas must not be truncated at
    // their seam. 8 KiB window = at most 3 lock-free map lookups.
    constexpr u64 kPage = 0x1000;
    u64 have_bytes = 0;
    while (have_bytes < want_bytes) {
        const VAddr chunk_addr = src_addr + have_bytes;
        const u64 chunk =
            std::min(want_bytes - have_bytes, kPage - (chunk_addr & (kPage - 1)));
        if (!memory->IsMappedMemory(chunk_addr, chunk)) {
            break;
        }
        have_bytes += chunk;
    }
    const u64 have_dw = have_bytes / sizeof(u32);
    if (have_dw != 0) {
        std::memcpy(dst, src, have_dw * sizeof(u32));
    }
    if (have_dw < size_dw) {
        std::memset(dst + have_dw, 0, (size_dw - have_dw) * sizeof(u32));
        static u32 clamp_logged = 0;
        if (clamp_logged < 8) {
            ++clamp_logged;
            LOG_WARNING(Render_Recompiler,
                        "dynrc window at {:#x}: {} of {} dw mapped - tail zeroed for THIS "
                        "dispatch only ({} so far)",
                        src_addr, have_dw, size_dw, clamp_logged);
        }
    }
}

namespace Shader {

PFN_SrtWalker RegisterWalkerCode(const u8* ptr, size_t size) {
    const auto func_addr = (PFN_SrtWalker)g_srt_codegen.getCurr();
    g_srt_codegen.db(ptr, size);
    g_srt_codegen.ready();
    return func_addr;
}

} // namespace Shader

namespace {

static void DumpSrtProgram(const Shader::Info& info, const u8* code, size_t codesize) {
    using namespace Common::FS;

    const auto dump_dir = GetUserPath(PathType::ShaderDir) / "dumps";
    if (!std::filesystem::exists(dump_dir)) {
        std::filesystem::create_directories(dump_dir);
    }
    const auto filename = fmt::format("{}_{:#018x}.srtprogram.txt", info.stage, info.pgm_hash);
    const auto file = IOFile{dump_dir / filename, FileAccessMode::Create, FileType::TextFile};

    u64 address = reinterpret_cast<u64>(code);
    u64 code_end = address + codesize;
    ZydisDecodedInstruction instruction;
    ZydisDecodedOperand operands[ZYDIS_MAX_OPERAND_COUNT];
    ZyanStatus status = ZYAN_STATUS_SUCCESS;
    while (address < code_end && ZYAN_SUCCESS(Common::Decoder::Instance()->decodeInstruction(
                                     instruction, operands, reinterpret_cast<void*>(address)))) {
        std::string s =
            Common::Decoder::Instance()->disassembleInst(instruction, operands, address);
        s += "\n";
        file.WriteString(s);
        address += instruction.length;
    }
}

static bool SrtWalkerSignalHandler(void* context, void* fault_address) {
    // Only handle if the fault address is within the SRT code range
    const u8* code_start = g_srt_codegen_start;
    const u8* code_end = code_start + g_srt_codegen.getSize();
    const void* code = Common::GetRip(context);
    if (code < code_start || code >= code_end) {
        return false; // Not in SRT code range
    }

    // Patch instruction to zero register
    ZydisDecodedInstruction instruction;
    ZydisDecodedOperand operands[ZYDIS_MAX_OPERAND_COUNT];
    ZyanStatus status = Common::Decoder::Instance()->decodeInstruction(instruction, operands,
                                                                       const_cast<void*>(code), 15);

    ASSERT(ZYAN_SUCCESS(status) && instruction.mnemonic == ZYDIS_MNEMONIC_MOV &&
           operands[0].type == ZYDIS_OPERAND_TYPE_REGISTER &&
           operands[1].type == ZYDIS_OPERAND_TYPE_MEMORY);

    size_t len = instruction.length;
    const size_t patch_size = 3;
    u8* code_patch = const_cast<u8*>(reinterpret_cast<const u8*>(code));

    // We can only encounter rdi or r10d as the first operand in a
    // fault memory access for SRT walker.
    switch (operands[0].reg.value) {
    case ZYDIS_REGISTER_RDI:
        // mov rdi, [rdi + (off_dw << 2)] -> xor rdi, rdi
        code_patch[0] = 0x48;
        code_patch[1] = 0x31;
        code_patch[2] = 0xFF;
        break;
    case ZYDIS_REGISTER_R10D:
        // mov r10d, [rdi + (off_dw << 2)] -> xor r10d, r10d
        code_patch[0] = 0x45;
        code_patch[1] = 0x31;
        code_patch[2] = 0xD2;
        break;
    default:
        UNREACHABLE_MSG("Unsupported register for SRT walker patch");
        return false;
    }

    // Fill nops
    memset(code_patch + patch_size, 0x90, len - patch_size);

    // CRITICAL, not WARNING: this patch is PERMANENT and GLOBAL for the shader that owns
    // this walker - a patched window-copy load stores ZEROS for every dword of the window on
    // every later dispatch, which downstream reads exactly as "the guest table is empty"
    // (the ALL-ZERO dynrc verdict) with no further hint that the walker was the cause.
    // Cross-reference the address against the "srt walker for shader ..." emission lines to
    // name the owner.
    LOG_CRITICAL(Render_Recompiler, "Patched SRT walker at {}, fault address {} - this "
                 "walker's faulting load reads ZERO from now on",
                 code, fault_address);

    return true;
}

using namespace Shader;

struct PassInfo {
    // map offset to inst
    using PtrUserList = boost::container::flat_map<u32, Shader::IR::Inst*>;

    Optimization::SrtGvnTable gvn_table;
    // keys are GetUserData or ReadConst instructions that are used as pointers
    std::unordered_map<IR::Inst*, PtrUserList> pointer_uses;
    // GetUserData instructions corresponding to sgpr_base of SRT roots
    boost::container::small_flat_map<IR::ScalarReg, IR::Inst*, 1> srt_roots;

    // pick a single inst for a given value number
    std::unordered_map<u32, IR::Inst*> vn_to_inst;

    // GT_DYNRC_WINDOW: ReadConsts with RUNTIME-computed offsets, grouped by their
    // deduplicated base pointer. VisitPointer emits one bulk window copy per pointer and
    // stamps every user's flags with the window's location (see srt.h for the encoding).
    std::unordered_map<IR::Inst*, boost::container::small_vector<Shader::IR::Inst*, 4>>
        dyn_window_uses;

    // Bumped during codegen to assign offsets to readconsts
    u32 dst_off_dw;

    PtrUserList* GetUsesAsPointer(IR::Inst* inst) {
        auto it = pointer_uses.find(inst);
        if (it != pointer_uses.end()) {
            return &it->second;
        }
        return nullptr;
    }

    // Return a single instruction that this instruction is identical to, according
    // to value number
    // The "original" is arbitrary. Here it's the first instruction found for a given value number
    IR::Inst* DeduplicateInstruction(IR::Inst* inst) {
        auto it = vn_to_inst.try_emplace(gvn_table.GetValueNumber(inst), inst);
        return it.first->second;
    }
};
} // namespace

namespace Shader::Optimization {

namespace {

// GT_DYNRC_WINDOW: 0/absent = off (a dynamic ReadConst keeps the legacy read-flatbuf[0]
// fallback); "1" = on with the default 2048 dwords (8 KiB) per base pointer; any other
// number = that many dwords (capped to fit the 16-bit size field). Measured need (GT7,
// cs_0x2a0cfcd2 dump): 12-byte records at byte offsets 160..304+ off one static base -
// small tables, 8 KiB covers them with room to spare.
static u32 DynReadConstWindowDw() {
    static const u32 window_dw = [] {
        const char* v = std::getenv("GT_DYNRC_WINDOW");
        if (v == nullptr || v[0] == '0') {
            return 0u;
        }
        const unsigned long parsed = std::strtoul(v, nullptr, 10);
        if (parsed <= 1) {
            return 2048u;
        }
        return static_cast<u32>(std::min<unsigned long>(parsed, 0xFFFFu));
    }();
    return window_dw;
}

static inline void PushPtr(Xbyak::CodeGenerator& c, u32 off_dw) {
    c.push(rdi);
    c.mov(rdi, ptr[rdi + (off_dw << 2)]);
    c.mov(r10, 0xFFFFFFFFFFFFULL);
    c.and_(rdi, r10);
}

static inline void PopPtr(Xbyak::CodeGenerator& c) {
    c.pop(rdi);
};

static void VisitPointer(u32 off_dw, IR::Inst* subtree, Info& info, PassInfo& pass_info,
                         Xbyak::CodeGenerator& c) {
    PushPtr(c, off_dw);
    PassInfo::PtrUserList* use_list = pass_info.GetUsesAsPointer(subtree);
    ASSERT(use_list);

    // First copy all the src data from this tree level
    // That way, all data that was contiguous in the guest SRT is also contiguous in the
    // flattened buffer.
    // TODO src and dst are contiguous. Optimize with wider loads/stores
    // TODO if this subtree is dynamically indexed, don't compact it (keep it sparse)
    for (auto [src_off_dw, use] : *use_list) {
        c.mov(r10d, ptr[rdi + (src_off_dw << 2)]);
        c.mov(ptr[rsi + (pass_info.dst_off_dw << 2)], r10d);

        use->SetFlags<u32>(pass_info.dst_off_dw);
        pass_info.dst_off_dw++;
    }

    // GT_DYNRC_WINDOW: dynamic readers of this pointer index into it at runtime, so no
    // field list exists to copy - reserve a window in the flattened buffer and bulk-copy
    // it. The copy is a CALL to CopyDynrcWindowClamped (see its header comment): the old
    // inline dword loop overran small tables into unmapped memory and the signal handler's
    // patch then zeroed the window FOREVER (32 shaders in one race load, runs 125-128).
    // The helper clamps to the mapped size per dispatch instead.
    if (const auto dyn_it = pass_info.dyn_window_uses.find(subtree);
        dyn_it != pass_info.dyn_window_uses.end() && !dyn_it->second.empty()) {
        const u32 window_dw = DynReadConstWindowDw();
        const u32 window_base_dw = pass_info.dst_off_dw;
        ASSERT_MSG(window_base_dw < 0x8000 && window_dw <= 0xFFFF,
                   "flatbuf window does not fit the flag encoding");
        // SysV call: rdi = src (already the current base pointer), rsi = dst, rdx = dwords.
        // rdi/rsi are call-clobbered and the walker still needs them, so save around the
        // call; rsp is realigned through rbp because the walker's own push depth varies.
        c.push(rdi);
        c.push(rsi);
        c.lea(rsi, ptr[rsi + (window_base_dw << 2)]);
        c.mov(edx, window_dw);
        c.mov(rax, reinterpret_cast<uintptr_t>(&CopyDynrcWindowClamped));
        c.push(rbp);
        c.mov(rbp, rsp);
        c.and_(rsp, -16);
        c.call(rax);
        c.mov(rsp, rbp);
        c.pop(rbp);
        c.pop(rsi);
        c.pop(rdi);
        pass_info.dst_off_dw += window_dw;
        const u32 flags = MakeSrtWindowFlags(window_base_dw, window_dw);
        for (IR::Inst* use : dyn_it->second) {
            use->SetFlags<u32>(flags);
        }
        // Hand the window to RefreshFlatBuf so it can report, for the first few dispatches,
        // whether the snapshot carried real data (see info.h).
        if (info.dynrc_windows.size() < info.dynrc_windows.capacity()) {
            info.dynrc_windows.emplace_back(window_base_dw, window_dw);
            info.dynrc_log_budget = 4;
        }
    }

    // Then visit any children used as pointers
    for (const auto [src_off_dw, use] : *use_list) {
        if (pass_info.GetUsesAsPointer(use)) {
            VisitPointer(src_off_dw, use, info, pass_info, c);
        }
    }

    PopPtr(c);
}

static void GenerateSrtProgram(Info& info, PassInfo& pass_info) {
    Xbyak::CodeGenerator& c = g_srt_codegen;

    if (pass_info.srt_roots.empty()) {
        return;
    }

    // Register the signal handler for SRT walker, if not already registered
    if (g_srt_codegen_start == nullptr) {
        g_srt_codegen_start = c.getCurr();
        auto* signals = Core::Signals::Instance();
        // Call after the memory invalidation handler
        constexpr u32 priority = 1;
        signals->RegisterAccessViolationHandler(SrtWalkerSignalHandler, priority);
    }

    info.srt_info.walker_func = c.getCurr<PFN_SrtWalker>();
    pass_info.dst_off_dw = NUM_USER_DATA_REGS;
    ASSERT(pass_info.dst_off_dw == info.srt_info.flattened_bufsize_dw);

    for (const auto& [sgpr_base, root] : pass_info.srt_roots) {
        VisitPointer(static_cast<u32>(sgpr_base), root, info, pass_info, c);
    }

    c.ret();
    c.ready();

    info.srt_info.walker_func_size =
        c.getCurr() - reinterpret_cast<const u8*>(info.srt_info.walker_func);

    // Attribution for "Patched SRT walker at <address>": print the code range of every
    // walker that carries a dynrc WINDOW (the shaders whose zeros downstream cares about),
    // so a patch address maps to its owner post-hoc. ⚠ Warm-cache walkers are re-registered
    // at a DIFFERENT address by RegisterWalkerCode - this line only covers cold compiles.
    if (!info.dynrc_windows.empty()) {
        LOG_INFO(Render_Recompiler, "srt walker for shader {:#x}: code {}..{} ({} windows)",
                 info.pgm_hash, reinterpret_cast<const void*>(info.srt_info.walker_func),
                 static_cast<const void*>(c.getCurr()), info.dynrc_windows.size());
    }

    if (EmulatorSettings.IsDumpShaders()) {
        DumpSrtProgram(info, reinterpret_cast<const u8*>(info.srt_info.walker_func),
                       info.srt_info.walker_func_size);
    }

    info.srt_info.flattened_bufsize_dw = pass_info.dst_off_dw;
}

}; // namespace

void FlattenExtendedUserdataPass(IR::Program& program) {
    Shader::Info& info = program.info;
    PassInfo pass_info;

    // traverse at end and assign offsets to duplicate readconsts, using
    // vn_to_inst as the source
    boost::container::small_vector<IR::Inst*, 32> all_readconsts;

    for (auto r_it = program.post_order_blocks.rbegin(); r_it != program.post_order_blocks.rend();
         r_it++) {
        IR::Block* block = *r_it;
        for (IR::Inst& inst : *block) {
            if (inst.GetOpcode() == IR::Opcode::ReadConst) {
                if (!inst.Arg(1).IsImmediate()) {
                    // The SRT walker only pre-copies statically known regions; a ReadConst
                    // with a runtime-computed offset reads whatever happens to sit in the
                    // flattened buffer. GT7: cs_0xda05e7f8 / 0x18256c0 / 0x2a0cfcd2.
                    // ⚠ RUN 35 PROVED STUBBING THESE IS WRONG: they are PRODUCERS in the
                    // GPU-driven pipeline (they write descriptor tables downstream work
                    // consumes) - as no-ops the game fed garbage to BindBuffers (assert at
                    // vk_rasterizer.cpp:967, the run-19 signature). They were NOT the 19x
                    // hang either (run 34: stubbed, still hung; run 35: split+defer, no hang).
                    // So this stub sits behind ITS OWN switch, default OFF - a diagnostic,
                    // not a fix. GT_BINDLESS_STUB (the tracker path) stays separate: those
                    // shaders CANNOT compile at all, stubbing them is the only option.
                    static const bool stub_dynamic = [] {
                        const char* v = std::getenv("GT_DYNREADCONST_STUB");
                        return v && v[0] == '1';
                    }();
                    if (stub_dynamic) {
                        LOG_ERROR(Render_Recompiler,
                                  "shader {:#x}: ReadConst has non-immediate offset - shader "
                                  "will be stubbed",
                                  info.pgm_hash);
                        info.has_bindless_sharp = true;
                        return;
                    }
                    if (const u32 window_dw = DynReadConstWindowDw(); window_dw != 0) {
                        // GT_DYNRC_WINDOW: resolve the BASE the same way the static path
                        // below does; the walker will bulk-copy `window_dw` dwords from it
                        // (see VisitPointer) and EmitReadConst indexes inside that window.
                        IR::Inst* ptr_composite = inst.Arg(0).InstRecursive();
                        const auto pred = [](IR::Inst* i) -> std::optional<IR::Inst*> {
                            if (i->GetOpcode() == IR::Opcode::GetUserData ||
                                i->GetOpcode() == IR::Opcode::ReadConst) {
                                return i;
                            }
                            return std::nullopt;
                        };
                        const auto base0 = IR::BreadthFirstSearch(ptr_composite->Arg(0), pred);
                        const auto base1 = IR::BreadthFirstSearch(ptr_composite->Arg(1), pred);
                        if (base0 && base1) {
                            IR::Inst* ptr_lo = pass_info.DeduplicateInstruction(base0.value());
                            // The pointer must exist in the walker's graph even when no
                            // static read uses it, or VisitPointer never descends into it.
                            pass_info.pointer_uses.try_emplace(ptr_lo,
                                                               PassInfo::PtrUserList{});
                            pass_info.dyn_window_uses[ptr_lo].push_back(&inst);
                            if (ptr_lo->GetOpcode() == IR::Opcode::GetUserData) {
                                pass_info.srt_roots[ptr_lo->Arg(0).ScalarReg()] = ptr_lo;
                            }
                            LOG_INFO(Render_Recompiler,
                                     "shader {:#x}: dynamic ReadConst windowed ({} dwords)",
                                     info.pgm_hash, window_dw);
                            continue;
                        }
                        LOG_WARNING(Render_Recompiler,
                                    "shader {:#x}: dynamic ReadConst base not resolvable - "
                                    "keeping the flatbuf[0] fallback",
                                    info.pgm_hash);
                        continue;
                    }
                    LOG_WARNING(Render_Recompiler, "ReadConst has non-immediate offset");
                    continue;
                }

                all_readconsts.push_back(&inst);
                if (pass_info.DeduplicateInstruction(&inst) != &inst) {
                    // This is a duplicate of a readconst we've already visited
                    continue;
                }

                IR::Inst* ptr_composite = inst.Arg(0).InstRecursive();

                const auto pred = [](IR::Inst* inst) -> std::optional<IR::Inst*> {
                    if (inst->GetOpcode() == IR::Opcode::GetUserData ||
                        inst->GetOpcode() == IR::Opcode::ReadConst) {
                        return inst;
                    }
                    return std::nullopt;
                };
                auto base0 = IR::BreadthFirstSearch(ptr_composite->Arg(0), pred);
                auto base1 = IR::BreadthFirstSearch(ptr_composite->Arg(1), pred);
                ASSERT_MSG(base0 && base1, "ReadConst not from constant memory");

                IR::Inst* ptr_lo = base0.value();
                ptr_lo = pass_info.DeduplicateInstruction(ptr_lo);

                auto ptr_uses_kv =
                    pass_info.pointer_uses.try_emplace(ptr_lo, PassInfo::PtrUserList{});
                PassInfo::PtrUserList& user_list = ptr_uses_kv.first->second;

                user_list[inst.Arg(1).U32()] = &inst;

                if (ptr_lo->GetOpcode() == IR::Opcode::GetUserData) {
                    IR::ScalarReg ud_reg = ptr_lo->Arg(0).ScalarReg();
                    pass_info.srt_roots[ud_reg] = ptr_lo;
                }
            }
        }
    }

    GenerateSrtProgram(info, pass_info);

    // Assign offsets to duplicate readconsts
    for (IR::Inst* readconst : all_readconsts) {
        ASSERT(pass_info.vn_to_inst.contains(pass_info.gvn_table.GetValueNumber(readconst)));
        IR::Inst* original = pass_info.DeduplicateInstruction(readconst);
        readconst->SetFlags<u32>(original->Flags<u32>());
    }

    info.RefreshFlatBuf();
}

} // namespace Shader::Optimization

#else

namespace Shader {

PFN_SrtWalker RegisterWalkerCode(const u8* ptr, size_t size) {
    UNREACHABLE_MSG("RegisterWalkerCode unimplemented for target architecture.");
}

namespace Optimization {

void FlattenExtendedUserdataPass(IR::Program& program) {
    UNREACHABLE_MSG("FlattenExtendedUserdataPass unimplemented for target architecture.");
}

} // namespace Optimization

} // namespace Shader

#endif
