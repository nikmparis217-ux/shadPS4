# stuckstack.ps1 - capture live thread stacks (with symbols) from a hung shadps4.exe.
#
# WHY THIS EXISTS: runs 244 and 246 both ended as "stuck" - the GpuCommandProcessor thread
# blocked at ~0% CPU in something that logs nothing, faults nothing and never TDRs. Both times
# the process was killed before anyone captured a stack, and the mechanism was lost. This
# script names the blocked function in one command, while the hang is still alive.
#
# USAGE (from any PowerShell, while the game is stuck):
#   powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\stuckstack.ps1
#
# It writes GT7_work\logs\stuckstack_<yyyyMMdd_HHmmss>.txt and prints it. Threads are
# suspended only for the microseconds of one context read + walk, then resumed.
#
# Symbols: dbghelp.dll (present on every Windows) + the build's own PDB. The symbol search
# path uses 8.3 short paths - the Greek profile name breaks ANSI/UTF-8 boundaries otherwise.

$ErrorActionPreference = 'Stop'

$OutDir = 'C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\logs'
$PdbDir = 'C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\Build\x64-Clang-RelWithDebInfo'
$Stamp  = Get-Date -Format 'yyyyMMdd_HHmmss'
$OutFile = Join-Path $OutDir "stuckstack_$Stamp.txt"

Add-Type -TypeDefinition @'
using System;
using System.Text;
using System.Runtime.InteropServices;

public static class StackCap {
    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern IntPtr OpenProcess(uint access, bool inherit, int pid);
    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern IntPtr OpenThread(uint access, bool inherit, uint tid);
    [DllImport("kernel32.dll")]
    public static extern uint SuspendThread(IntPtr h);
    [DllImport("kernel32.dll")]
    public static extern uint ResumeThread(IntPtr h);
    [DllImport("kernel32.dll")]
    public static extern bool CloseHandle(IntPtr h);
    [DllImport("kernel32.dll")]
    public static extern int GetThreadDescription(IntPtr h, out IntPtr desc);
    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern bool GetThreadContext(IntPtr h, IntPtr ctx);

    [DllImport("dbghelp.dll", SetLastError=true, CharSet=CharSet.Unicode)]
    public static extern bool SymInitializeW(IntPtr hProc, string searchPath, bool invade);
    [DllImport("dbghelp.dll")]
    public static extern bool SymCleanup(IntPtr hProc);
    [DllImport("dbghelp.dll")]
    public static extern uint SymSetOptions(uint opts);
    [DllImport("dbghelp.dll", SetLastError=true)]
    public static extern bool StackWalk64(uint machine, IntPtr hProc, IntPtr hThread,
        IntPtr frame, IntPtr ctx, IntPtr readMem, IntPtr funcTable, IntPtr getModBase, IntPtr translate);
    [DllImport("dbghelp.dll")]
    public static extern IntPtr SymFunctionTableAccess64(IntPtr hProc, ulong addr);
    [DllImport("dbghelp.dll")]
    public static extern ulong SymGetModuleBase64(IntPtr hProc, ulong addr);
    [DllImport("dbghelp.dll", SetLastError=true, CharSet=CharSet.Unicode)]
    public static extern bool SymFromAddrW(IntPtr hProc, ulong addr, out ulong disp, IntPtr sym);
    [DllImport("psapi.dll", CharSet=CharSet.Unicode)]
    public static extern uint GetMappedFileNameW(IntPtr hProc, IntPtr addr, StringBuilder name, uint size);

    // x64 CONTEXT: 1232 bytes, 16-aligned. ContextFlags at 0x30, Rsp 0x98, Rbp 0xA0, Rip 0xF8.
    public const int CtxSize = 1232;
    public const uint CONTEXT_FULL_AMD64 = 0x10000B;
    // STACKFRAME64: AddrPC(24) AddrReturn(24) AddrFrame(24) AddrStack(24) AddrBStore(24)
    //   FuncTableEntry(8) Params(32) Far(4) Virtual(4) Reserved(24) KdHelp(...) -> use 300 zeroed.
    public const int FrameSize = 300;

    public static string GetName(IntPtr h) {
        IntPtr p;
        if (GetThreadDescription(h, out p) >= 0 && p != IntPtr.Zero) {
            string s = Marshal.PtrToStringUni(p);
            Marshal.FreeHGlobal(p);
            return s;
        }
        return "";
    }

    public static string Symbolize(IntPtr hProc, ulong addr) {
        // SYMBOL_INFOW layout (x64): SizeOfStruct 0, TypeIndex 4, Reserved 8..24, Index 24,
        // Size 28, ModBase 32, Flags 40, Value 48, Address 56, Register 64, Scope 68, Tag 72,
        // NameLen 76, MaxNameLen 80, Name (WCHAR) 84. sizeof(SYMBOL_INFOW) = 88.
        int cap = 88 + 512 * 2;
        IntPtr buf = Marshal.AllocHGlobal(cap);
        try {
            for (int i = 0; i < cap; ++i) Marshal.WriteByte(buf, i, 0);
            Marshal.WriteInt32(buf, 0, 88);       // SizeOfStruct
            Marshal.WriteInt32(buf, 80, 511);     // MaxNameLen (chars)
            ulong disp;
            if (SymFromAddrW(hProc, addr, out disp, buf)) {
                string name = Marshal.PtrToStringUni(new IntPtr(buf.ToInt64() + 84));
                return string.Format("{0}+0x{1:x}", name, disp);
            }
            return "";
        } finally { Marshal.FreeHGlobal(buf); }
    }

    public static ulong[] Walk(IntPtr hProc, IntPtr hThread, out ulong rip, out ulong rsp) {
        rip = 0; rsp = 0;
        IntPtr ctx = Marshal.AllocHGlobal(CtxSize + 16);
        long aligned = (ctx.ToInt64() + 15) & ~15L;
        IntPtr actx = new IntPtr(aligned);
        IntPtr frame = Marshal.AllocHGlobal(FrameSize);
        var pcs = new System.Collections.Generic.List<ulong>();
        try {
            for (int i = 0; i < CtxSize; ++i) Marshal.WriteByte(actx, i, 0);
            Marshal.WriteInt32(actx, 0x30, unchecked((int)CONTEXT_FULL_AMD64));
            uint sc = SuspendThread(hThread);
            if (sc == 0xFFFFFFFF) return pcs.ToArray();
            try {
                if (!GetThreadContext(hThread, actx)) return pcs.ToArray();
                rip = (ulong)Marshal.ReadInt64(actx, 0xF8);
                rsp = (ulong)Marshal.ReadInt64(actx, 0x98);
                ulong rbp = (ulong)Marshal.ReadInt64(actx, 0xA0);
                for (int i = 0; i < FrameSize; ++i) Marshal.WriteByte(frame, i, 0);
                // AddrPC / AddrFrame / AddrStack: {Offset(8) Segment(2) pad(2) Mode(4)}; Mode 3 = flat
                Marshal.WriteInt64(frame, 0, (long)rip);   Marshal.WriteInt32(frame, 12, 3);
                Marshal.WriteInt64(frame, 48, (long)rbp);  Marshal.WriteInt32(frame, 60, 3);
                Marshal.WriteInt64(frame, 72, (long)rsp);  Marshal.WriteInt32(frame, 84, 3);
                for (int i = 0; i < 64; ++i) {
                    if (!StackWalk64(0x8664, hProc, hThread, frame, actx, IntPtr.Zero,
                                     Marshal.GetFunctionPointerForDelegate(FtaDel),
                                     Marshal.GetFunctionPointerForDelegate(GmbDel), IntPtr.Zero)) break;
                    ulong pc = (ulong)Marshal.ReadInt64(frame, 0);
                    if (pc == 0) break;
                    pcs.Add(pc);
                }
            } finally { ResumeThread(hThread); }
            return pcs.ToArray();
        } finally { Marshal.FreeHGlobal(ctx); Marshal.FreeHGlobal(frame); }
    }

    public delegate IntPtr FtaProc(IntPtr hProc, ulong addr);
    public delegate ulong GmbProc(IntPtr hProc, ulong addr);
    public static FtaProc FtaDel = SymFunctionTableAccess64;
    public static GmbProc GmbDel = SymGetModuleBase64;

    public static string ModuleOf(IntPtr hProc, ulong addr) {
        var sb = new StringBuilder(520);
        if (GetMappedFileNameW(hProc, new IntPtr((long)addr), sb, 512) > 0) {
            string s = sb.ToString();
            int k = s.LastIndexOf('\\');
            return k >= 0 ? s.Substring(k + 1) : s;
        }
        return "?";
    }
}
'@

$proc = Get-Process shadps4 -ErrorAction SilentlyContinue
if (-not $proc) { Write-Host "shadps4 is not running - nothing to capture."; exit 1 }

$report = New-Object System.Collections.Generic.List[string]
$report.Add("stuckstack capture $Stamp  pid $($proc.Id)  WS $([math]::Round($proc.WorkingSet64/1GB,1)) GB")

# PROCESS_QUERY_INFORMATION | PROCESS_VM_READ
$hProc = [StackCap]::OpenProcess(0x0410, $false, $proc.Id)
if ($hProc -eq [IntPtr]::Zero) { Write-Host "OpenProcess failed"; exit 1 }

[StackCap]::SymSetOptions(0x00000004 -bor 0x00000200 -bor 0x00000002) | Out-Null  # DEFERRED | AUTO_PUBLICS? keep: DEFERRED_LOADS|FAIL_CRITICAL_ERRORS|UNDNAME
$exeDir = Split-Path $proc.Path
$searchPath = "$PdbDir;$exeDir"
if (-not [StackCap]::SymInitializeW($hProc, $searchPath, $true)) {
    $report.Add("SymInitializeW FAILED (err $([Runtime.InteropServices.Marshal]::GetLastWin32Error())) - stacks will be raw addresses")
}

# Two CPU samples 3 s apart so a spinning thread and a blocked one read differently.
$cpu0 = @{}
foreach ($t in $proc.Threads) { $cpu0[$t.Id] = $t.TotalProcessorTime.TotalMilliseconds }
Start-Sleep -Seconds 3
$proc.Refresh()

foreach ($t in $proc.Threads) {
    # THREAD_SUSPEND_RESUME | THREAD_GET_CONTEXT | THREAD_QUERY_LIMITED_INFORMATION
    $hT = [StackCap]::OpenThread(0x004A, $false, [uint32]$t.Id)
    if ($hT -eq [IntPtr]::Zero) { continue }
    $name = [StackCap]::GetName($hT)
    $delta = if ($cpu0.ContainsKey($t.Id)) { [math]::Round($t.TotalProcessorTime.TotalMilliseconds - $cpu0[$t.Id]) } else { -1 }
    $state = if ($t.ThreadState -eq 'Wait') { "Wait/$($t.WaitReason)" } else { "$($t.ThreadState)" }

    # Full stacks only for interesting threads: named shadPS4 threads, or anything burning CPU.
    $interesting = ($name -like 'shadPS4*') -or ($delta -gt 300) -or ($name -match 'Gpu|Rendr|Present')
    $rip = [uint64]0; $rsp = [uint64]0
    $pcs = [StackCap]::Walk($hProc, $hT, [ref]$rip, [ref]$rsp)
    if ($name -eq '') { $name = '(unnamed)' }
    $report.Add(("--- tid {0,6}  {1,-40}  cpu+{2,6}ms/3s  {3}" -f $t.Id, $name, $delta, $state))
    if ($interesting -and $pcs.Length -gt 0) {
        foreach ($pc in $pcs) {
            $sym = [StackCap]::Symbolize($hProc, $pc)
            $mod = [StackCap]::ModuleOf($hProc, $pc)
            $report.Add(("      {0:x12}  {1,-14} {2}" -f $pc, $mod, $sym))
        }
    } elseif ($pcs.Length -gt 0) {
        # One-line summary: the top frame only.
        $sym = [StackCap]::Symbolize($hProc, $pcs[0])
        $mod = [StackCap]::ModuleOf($hProc, $pcs[0])
        $report.Add(("      top: {0:x12}  {1} {2}" -f $pcs[0], $mod, $sym))
    }
    [StackCap]::CloseHandle($hT) | Out-Null
}

[StackCap]::SymCleanup($hProc) | Out-Null
[StackCap]::CloseHandle($hProc) | Out-Null

$report | Set-Content -Path $OutFile -Encoding UTF8
Write-Host "written: $OutFile"
$report | Select-Object -First 80 | ForEach-Object { Write-Host $_ }
