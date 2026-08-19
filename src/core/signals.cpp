// SPDX-FileCopyrightText: Copyright 2024-2026 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include "common/arch.h"
#include "common/assert.h"
#include "common/decoder.h"
#include "common/signal_context.h"
#include "core/cpu_patches.h" // Windows static guest red-zone protection
#include "core/libraries/kernel/threads/exception.h"
#include "core/signals.h"
#include "emulator.h"

#ifdef _WIN32
#include <atomic>
#include <windows.h>
#include <dbghelp.h>
#include "common/path_util.h"
#include "core/linker.h"
static constexpr DWORD MS_VC_EXCEPTION = 0x406D1388;
#else
#include <csignal>
#include <pthread.h>
#ifdef ARCH_X86_64
#include <Zydis/Formatter.h>
#endif
#endif

#ifndef _WIN32
namespace Libraries::Kernel {
void SigactionHandler(int native_signum, siginfo_t* inf, ucontext_t* raw_context);
extern std::array<OrbisKernelExceptionHandler, 32> Handlers;
} // namespace Libraries::Kernel
#endif

namespace Core {

#if defined(_WIN32)

// GT7 FWRKR boot-crash hunt (18 Aug): six A/B theories died in a row - the verdict was "the
// next step is a debugger, not a run". These helpers make every unhandled guest AV
// self-reporting, so the ~50-70% boot crash pays out evidence instead of another retry:
//  - the log names the guest MODULE+OFFSET of the faulting IP (module bases drift a few MiB
//    per run, so a raw IP is not comparable across runs; "+0x273d in module X" is),
//  - a raw stack scan annotates every qword that resolves into a guest module = the return
//    addresses = a poor man's callstack, readable straight from shad_log.txt,
//  - a minidump with the faulting thread's real stack memory lands next to the log for
//    WinDbg (guest threads run on stacks in GUEST memory, outside the TEB-known range, so
//    MiniDumpNormal alone would capture the WRONG stack - hence the explicit ranges).
// Best-effort by design: every memory read is VirtualQuery-guarded, one dump per process,
// disable with GT_NO_GUEST_DUMP=1. Runs BEFORE Emulator::Shutdown().

static bool DescribeGuestAddress(u64 addr, char* buf, size_t buf_size) noexcept {
    auto* linker = Common::Singleton<Core::Linker>::Instance();
    if (linker == nullptr) {
        return false;
    }
    Core::Module* module = linker->FindByAddress(addr);
    if (module == nullptr) {
        return false;
    }
    std::snprintf(buf, buf_size, "%s+0x%llx", module->name.c_str(),
                  static_cast<unsigned long long>(addr - module->GetBaseAddress()));
    return true;
}

static bool IsReadableProtect(DWORD protect) noexcept {
    if (protect & (PAGE_NOACCESS | PAGE_GUARD)) {
        return false;
    }
    return (protect & (PAGE_READONLY | PAGE_READWRITE | PAGE_WRITECOPY | PAGE_EXECUTE_READ |
                       PAGE_EXECUTE_READWRITE | PAGE_EXECUTE_WRITECOPY)) != 0;
}

static void LogGuestCrashContext(EXCEPTION_POINTERS* pExp) noexcept {
    if (pExp == nullptr || pExp->ContextRecord == nullptr) {
        return;
    }
    const CONTEXT& ctx = *pExp->ContextRecord;
    char desc[512];
    if (DescribeGuestAddress(ctx.Rip, desc, sizeof(desc))) {
        LOG_CRITICAL(Debug, "guest crash: rip {:#x} = {}", ctx.Rip, desc);
    }
    LOG_CRITICAL(Debug,
                 "guest crash context: rsp={:#x} rbp={:#x} rax={:#x} rbx={:#x} rcx={:#x} "
                 "rdx={:#x} rsi={:#x} rdi={:#x} r8={:#x} r9={:#x} r10={:#x} r11={:#x} "
                 "r12={:#x} r13={:#x} r14={:#x} r15={:#x}",
                 ctx.Rsp, ctx.Rbp, ctx.Rax, ctx.Rbx, ctx.Rcx, ctx.Rdx, ctx.Rsi, ctx.Rdi, ctx.R8,
                 ctx.R9, ctx.R10, ctx.R11, ctx.R12, ctx.R13, ctx.R14, ctx.R15);
    // A register that resolves into a guest module often IS the object whose field was
    // dereferenced - name them.
    const u64 regs[] = {ctx.Rax, ctx.Rbx, ctx.Rcx, ctx.Rdx, ctx.Rsi, ctx.Rdi, ctx.Rbp,
                        ctx.R8,  ctx.R9,  ctx.R10, ctx.R11, ctx.R12, ctx.R13, ctx.R14, ctx.R15};
    const char* reg_names[] = {"rax", "rbx", "rcx", "rdx", "rsi", "rdi", "rbp", "r8",
                               "r9",  "r10", "r11", "r12", "r13", "r14", "r15"};
    for (size_t i = 0; i < std::size(regs); ++i) {
        if (DescribeGuestAddress(regs[i], desc, sizeof(desc))) {
            LOG_CRITICAL(Debug, "guest crash: {} = {:#x} = {}", reg_names[i], regs[i], desc);
        }
    }
    // Scan the first 16 KiB above rsp; every slot that resolves into a guest module is a
    // candidate return address. VirtualQuery-guarded - the scan must never fault itself.
    int printed = 0;
    u64 off = 0;
    while (off < 0x4000 && printed < 64) {
        const u64 slot = ctx.Rsp + off;
        MEMORY_BASIC_INFORMATION mbi{};
        if (VirtualQuery(reinterpret_cast<LPCVOID>(slot), &mbi, sizeof(mbi)) == 0) {
            break;
        }
        const u64 region_end = reinterpret_cast<u64>(mbi.BaseAddress) + mbi.RegionSize;
        if (mbi.State != MEM_COMMIT || !IsReadableProtect(mbi.Protect)) {
            off = ((region_end - ctx.Rsp) + 7) & ~7ull; // skip the whole unreadable region
            continue;
        }
        const u64 value = *reinterpret_cast<volatile u64*>(slot);
        if (DescribeGuestAddress(value, desc, sizeof(desc))) {
            LOG_CRITICAL(Debug, "guest stack rsp+{:#05x}: {:#x} = {}", off, value, desc);
            ++printed;
        }
        off += 8;
    }
    if (printed == 0) {
        LOG_CRITICAL(Debug,
                     "guest stack scan: no guest-module return addresses in 16 KiB above rsp");
    }
}

struct GuestDumpRegions {
    static constexpr int MaxRegions = 8;
    u64 base[MaxRegions];
    u64 size[MaxRegions];
    int count{0};
    int next{0};
};

static void AddCommittedRange(GuestDumpRegions& regions, u64 want_base, u64 want_size) noexcept {
    u64 addr = want_base;
    const u64 end = want_base + want_size;
    while (addr < end && regions.count < GuestDumpRegions::MaxRegions) {
        MEMORY_BASIC_INFORMATION mbi{};
        if (VirtualQuery(reinterpret_cast<LPCVOID>(addr), &mbi, sizeof(mbi)) == 0) {
            return;
        }
        const u64 region_end = reinterpret_cast<u64>(mbi.BaseAddress) + mbi.RegionSize;
        if (mbi.State == MEM_COMMIT && IsReadableProtect(mbi.Protect)) {
            const u64 hi = region_end < end ? region_end : end;
            regions.base[regions.count] = addr;
            regions.size[regions.count] = hi - addr;
            ++regions.count;
        }
        addr = region_end;
    }
}

static BOOL CALLBACK GuestDumpCallback(PVOID param, const PMINIDUMP_CALLBACK_INPUT input,
                                       PMINIDUMP_CALLBACK_OUTPUT output) {
    auto* regions = static_cast<GuestDumpRegions*>(param);
    switch (input->CallbackType) {
    case MemoryCallback:
        // Called repeatedly while we return TRUE with a non-empty range.
        if (regions->next < regions->count) {
            output->MemoryBase = regions->base[regions->next];
            output->MemorySize = static_cast<ULONG>(regions->size[regions->next]);
            ++regions->next;
            return TRUE;
        }
        return FALSE;
    case CancelCallback:
        output->Cancel = FALSE;
        output->CheckCancel = FALSE;
        return TRUE;
    default:
        return TRUE;
    }
}

static void WriteGuestCrashDump(EXCEPTION_POINTERS* pExp) noexcept {
    static std::atomic<bool> dumped{false};
    if (dumped.exchange(true)) {
        return; // one dump per process - a crash cascade must not write GBs
    }
    if (std::getenv("GT_NO_GUEST_DUMP") != nullptr) {
        return;
    }
    try {
        const auto path =
            Common::FS::GetUserPath(Common::FS::PathType::LogDir) / "guest_crash.dmp";
        const HANDLE file = CreateFileW(path.wstring().c_str(), GENERIC_WRITE, 0, nullptr,
                                        CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);
        if (file == INVALID_HANDLE_VALUE) {
            LOG_CRITICAL(Debug, "guest crash minidump: CreateFile failed ({})", GetLastError());
            return;
        }
        GuestDumpRegions regions{};
        if (pExp != nullptr && pExp->ContextRecord != nullptr) {
            // The faulting thread's REAL stack (guest memory - not in the TEB range the
            // normal dump captures) and the code around the faulting IP.
            AddCommittedRange(regions, pExp->ContextRecord->Rsp & ~0xFFFull, 0x20000);
            AddCommittedRange(regions, (pExp->ContextRecord->Rip & ~0xFFFull) - 0x1000, 0x3000);
        }
        MINIDUMP_EXCEPTION_INFORMATION mei{};
        mei.ThreadId = GetCurrentThreadId();
        mei.ExceptionPointers = pExp;
        mei.ClientPointers = FALSE;
        MINIDUMP_CALLBACK_INFORMATION mci{};
        mci.CallbackRoutine = GuestDumpCallback;
        mci.CallbackParam = &regions;
        const auto type = static_cast<MINIDUMP_TYPE>(
            MiniDumpNormal | MiniDumpWithThreadInfo | MiniDumpWithIndirectlyReferencedMemory);
        const BOOL ok = MiniDumpWriteDump(GetCurrentProcess(), GetCurrentProcessId(), file, type,
                                          &mei, nullptr, &mci);
        CloseHandle(file);
        LOG_CRITICAL(Debug, "guest crash minidump {} ({} extra memory ranges): {}",
                     ok ? "WRITTEN" : "FAILED", regions.count,
                     Common::FS::PathToUTF8String(path));
    } catch (...) {
        // A crash reporter must never crash the crash.
    }
}

static LONG WINAPI SignalHandler(EXCEPTION_POINTERS* pExp) noexcept {
    const auto* signals = Signals::Instance();
    // Windows static guest red-zone protection
    const bool use_static_windows_guest_red_zone_protection =
        WindowsGuestRedZoneProtection::IsStaticPatchingEnabled();
    DWORD code = 0;
    PVOID address = nullptr;

    if (pExp != nullptr && pExp->ExceptionRecord != nullptr) {
        code = pExp->ExceptionRecord->ExceptionCode;
        address = pExp->ExceptionRecord->ExceptionAddress;
    }

    bool handled = false;
    bool static_protection_exception = false; // Windows static guest red-zone protection
    switch (code) {
    case EXCEPTION_ACCESS_VIOLATION: {
        // WILD JUMP GUARD (run 58): a guest thread jumped through a garbage function pointer
        // (rip == the unmapped fault address, or a DEP execute violation). No AV handler can fix
        // executing garbage, and letting the dispatch chain Zydis-decode AT that rip re-faults
        // INSIDE the handler - the nested exception then reports ZydisInputPeek as the crash site
        // and buries the real context (this is exactly what run 58's log showed). Capture the
        // ORIGINAL context - the guest stack's return addresses name whoever called the garbage
        // pointer - and shut down cleanly.
        if (pExp->ExceptionRecord->NumberParameters >= 2) {
            const ULONG_PTR wj_op = pExp->ExceptionRecord->ExceptionInformation[0];
            const ULONG_PTR wj_addr = pExp->ExceptionRecord->ExceptionInformation[1];
            const u64 wj_rip = pExp->ContextRecord ? pExp->ContextRecord->Rip : 0;
            if (wj_op == 8 || (wj_rip != 0 && wj_addr == wj_rip)) {
                LOG_CRITICAL(Debug, "GUEST WILD JUMP: execution at unmapped/NX {:#x}", wj_rip);
                LogGuestCrashContext(pExp);
                WriteGuestCrashDump(pExp);
                Common::Singleton<Core::Emulator>::Instance()->Shutdown();
                return EXCEPTION_CONTINUE_SEARCH;
            }
        }
        static_protection_exception = true; // Windows static guest red-zone protection
        handled = signals->DispatchAccessViolation(
            pExp, reinterpret_cast<void*>(pExp->ExceptionRecord->ExceptionInformation[1]));
        break;
    }
    case EXCEPTION_ILLEGAL_INSTRUCTION:
        static_protection_exception = true; // Windows static guest red-zone protection
        handled = signals->DispatchIllegalInstruction(pExp);
        break;
    case EXCEPTION_PRIV_INSTRUCTION: // Windows static guest red-zone protection
        if (use_static_windows_guest_red_zone_protection) {
            static_protection_exception = true;
            handled = signals->DispatchIllegalInstruction(pExp);
        }
        break;
    case DBG_PRINTEXCEPTION_C:
    case DBG_PRINTEXCEPTION_WIDE_C:
        // Used by OutputDebugString functions.
        return EXCEPTION_CONTINUE_EXECUTION;
    case MS_VC_EXCEPTION:
        LOG_DEBUG(Debug, "Pass MS_VC_EXCEPTION at {} to handler", address);
        return EXCEPTION_EXECUTE_HANDLER;
    default:
        break;
    }

    if (handled) {
        return EXCEPTION_CONTINUE_EXECUTION;
    }

    // Windows static guest red-zone protection
    const bool report_unhandled = use_static_windows_guest_red_zone_protection
                                      ? static_protection_exception
                                      : code != EXCEPTION_BREAKPOINT;
    if (report_unhandled) { // Windows static guest red-zone protection
        // For access violations Windows also tells us WHICH address was touched and whether it
        // was a read or a write. Without it a crash report only says where the code was, not
        // what it tried to reach.
        if (code == EXCEPTION_ACCESS_VIOLATION && pExp != nullptr &&
            pExp->ExceptionRecord != nullptr && pExp->ExceptionRecord->NumberParameters >= 2) {
            const ULONG_PTR op = pExp->ExceptionRecord->ExceptionInformation[0];
            const ULONG_PTR fault_address = pExp->ExceptionRecord->ExceptionInformation[1];
            const char* what = op == 0 ? "reading" : (op == 1 ? "writing" : "executing");
            LOG_CRITICAL(Debug, "Unhandled Exception code {:#x} at {} while {} {:#x}", code,
                         address, what, static_cast<u64>(fault_address));
        } else {
            LOG_CRITICAL(Debug, "Unhandled Exception code {:#x} at {}", code, address);
        }
        if (code == EXCEPTION_ACCESS_VIOLATION || code == EXCEPTION_ILLEGAL_INSTRUCTION) {
            // See the helpers above: name the guest module, annotate the stack, write a
            // minidump - the FWRKR boot crash cannot be diagnosed from one IP that drifts
            // every run. Must run BEFORE Shutdown() tears the process state down.
            LogGuestCrashContext(pExp);
            WriteGuestCrashDump(pExp);
        }
        Common::Singleton<Core::Emulator>::Instance()->Shutdown();
    }

    return EXCEPTION_CONTINUE_SEARCH;
}

#else

static std::string DisassembleInstruction(void* code_address) {
    char buffer[256] = "<unable to decode>";

#ifdef ARCH_X86_64
    ZydisDecodedInstruction instruction;
    ZydisDecodedOperand operands[ZYDIS_MAX_OPERAND_COUNT];
    const auto status =
        Common::Decoder::Instance()->decodeInstruction(instruction, operands, code_address);
    if (ZYAN_SUCCESS(status)) {
        ZydisFormatter formatter;
        ZydisFormatterInit(&formatter, ZYDIS_FORMATTER_STYLE_INTEL);
        ZydisFormatterFormatInstruction(&formatter, &instruction, operands,
                                        instruction.operand_count_visible, buffer, sizeof(buffer),
                                        reinterpret_cast<u64>(code_address), ZYAN_NULL);
    }
#endif

    return buffer;
}

void SignalHandler(int sig, siginfo_t* info, void* raw_context) {
    const auto* signals = Signals::Instance();

    auto* code_address = Common::GetRip(raw_context);

    switch (sig) {
    case SIGSEGV:
    case SIGBUS: {
        const bool is_write = Common::IsWriteError(raw_context);
        if (!signals->DispatchAccessViolation(raw_context, info->si_addr)) {
            // If the guest has installed a custom signal handler, and the access violation didn't
            // come from HLE memory tracking, pass the signal on
            if (Libraries::Kernel::Handlers[Libraries::Kernel::NativeToOrbisSignal(sig)]) {
                Libraries::Kernel::SigactionHandler(sig, info,
                                                    reinterpret_cast<ucontext_t*>(raw_context));
                return;
            }
            UNREACHABLE_MSG("Unhandled access violation at code address {}: {} address {}",
                            fmt::ptr(code_address), is_write ? "Write to" : "Read from",
                            fmt::ptr(info->si_addr));
        }
        break;
    }
    case SIGILL:
        if (!signals->DispatchIllegalInstruction(raw_context)) {
            if (Libraries::Kernel::Handlers[Libraries::Kernel::NativeToOrbisSignal(sig)]) {
                Libraries::Kernel::SigactionHandler(sig, info,
                                                    reinterpret_cast<ucontext_t*>(raw_context));
                return;
            }
            UNREACHABLE_MSG("Unhandled illegal instruction at code address {}: {}",
                            fmt::ptr(code_address), DisassembleInstruction(code_address));
        }
        break;
    default:
        if (sig == SIGSLEEP) {
            // Sleep thread until signal is received again
            sigset_t sigset;
            sigemptyset(&sigset);
            sigaddset(&sigset, SIGSLEEP);
            sigwait(&sigset, &sig);
        }
        break;
    }
}

#endif

SignalDispatch::SignalDispatch() {
#if defined(_WIN32)
    ASSERT_MSG(handle = AddVectoredExceptionHandler(0, SignalHandler),
               "Failed to register exception handler.");
#else
    struct sigaction action{};
    action.sa_sigaction = SignalHandler;
    action.sa_flags = SA_SIGINFO | SA_ONSTACK;
    sigemptyset(&action.sa_mask);

    ASSERT_MSG(sigaction(SIGSEGV, &action, nullptr) == 0 &&
                   sigaction(SIGBUS, &action, nullptr) == 0,
               "Failed to register access violation signal handler.");
    ASSERT_MSG(sigaction(SIGILL, &action, nullptr) == 0,
               "Failed to register illegal instruction signal handler.");
    ASSERT_MSG(sigaction(SIGSLEEP, &action, nullptr) == 0,
               "Failed to register sleep signal handler.");
#endif
}

SignalDispatch::~SignalDispatch() {
#if defined(_WIN32)
    ASSERT_MSG(RemoveVectoredExceptionHandler(handle), "Failed to remove exception handler.");
#else
    struct sigaction action{};
    action.sa_handler = SIG_DFL;
    action.sa_flags = 0;
    sigemptyset(&action.sa_mask);

    ASSERT_MSG(sigaction(SIGSEGV, &action, nullptr) == 0 &&
                   sigaction(SIGBUS, &action, nullptr) == 0,
               "Failed to remove access violation signal handler.");
    ASSERT_MSG(sigaction(SIGILL, &action, nullptr) == 0,
               "Failed to remove illegal instruction signal handler.");
#endif
}

bool SignalDispatch::DispatchAccessViolation(void* context, void* fault_address) const {
    for (const auto& [handler, _] : access_violation_handlers) {
        if (handler(context, fault_address)) {
            return true;
        }
    }
    return false;
}

bool SignalDispatch::DispatchIllegalInstruction(void* context) const {
    for (const auto& [handler, _] : illegal_instruction_handlers) {
        if (handler(context)) {
            return true;
        }
    }
    return false;
}

} // namespace Core
