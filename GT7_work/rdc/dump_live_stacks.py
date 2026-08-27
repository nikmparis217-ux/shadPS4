# dump_live_stacks.py - snapshot EVERY thread's rip/rsp + stack return addresses of a live
# shadps4.exe and symbolize the host ones. No debugger, no minidump library (its PEB parser
# dies on a Normal-level dump): MiniDumpWriteDump via ctypes, then a hand-rolled parse of
# stream 3 (threads: context+stack bytes) and stream 24 (thread NAMES). Symbolized with
# llvm-symbolizer against the fixed-base exe (/BASE:0x700000000000, /DYNAMICBASE:NO).
# Usage: python dump_live_stacks.py [pid]
# ASCII only. Built for the runs-166..173 GT7 init stall.
import ctypes, os, struct, subprocess, sys

EXE_BASE = 0x700000000000
EXE_END = EXE_BASE + 0x6000000
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "live_stall.dmp")
EXE = r"C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\Build\x64-Clang-RelWithDebInfo\shadps4.exe"
SYMBOLIZERS = [
    r"C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\Llvm\x64\bin\llvm-symbolizer.exe",
    r"C:\Program Files\LLVM\bin\llvm-symbolizer.exe",
]

def find_pid():
    if len(sys.argv) > 1:
        return int(sys.argv[1])
    out = subprocess.check_output(["tasklist", "/FI", "IMAGENAME eq shadps4.exe", "/FO", "CSV"],
                                  text=True, encoding="utf-8", errors="replace")
    for line in out.splitlines()[1:]:
        parts = [p.strip('"') for p in line.split('","')]
        if len(parts) >= 2:
            return int(parts[1])
    raise SystemExit("shadps4.exe not running")

def write_dump(pid):
    PROCESS_ALL = 0x1F0FFF
    k32 = ctypes.windll.kernel32
    dbghelp = ctypes.windll.dbghelp
    hproc = k32.OpenProcess(PROCESS_ALL, False, pid)
    if not hproc:
        raise SystemExit("OpenProcess failed: %d" % k32.GetLastError())
    GENERIC_WRITE, CREATE_ALWAYS = 0x40000000, 2
    hfile = k32.CreateFileW(OUT, GENERIC_WRITE, 0, None, CREATE_ALWAYS, 0x80, None)
    if hfile == -1:
        raise SystemExit("CreateFile failed")
    # 0x0 Normal (stacks+contexts) | 0x1000 WithThreadInfo (brings ThreadNamesStream along)
    ok = dbghelp.MiniDumpWriteDump(hproc, pid, hfile, 0x1000, None, None, None)
    k32.CloseHandle(hfile)
    k32.CloseHandle(hproc)
    if not ok:
        raise SystemExit("MiniDumpWriteDump failed: %d" % k32.GetLastError())
    print("dump written: %s (%d bytes)" % (OUT, os.path.getsize(OUT)))

def parse(path):
    data = open(path, "rb").read()
    sig, ver, nstreams, dir_rva = struct.unpack_from("<4sIII", data, 0)
    assert sig == b"MDMP", "not a minidump"
    threads, names = [], {}
    for i in range(nstreams):
        stype, dsize, rva = struct.unpack_from("<III", data, dir_rva + 12 * i)
        if stype == 3:  # ThreadListStream
            (count,) = struct.unpack_from("<I", data, rva)
            off = rva + 4
            for t in range(count):
                tid, _sc, _pc, _pr, _teb, stack_base, stack_size, stack_rva, ctx_size, ctx_rva = \
                    struct.unpack_from("<IIIIQQIIII", data, off + 48 * t)
                threads.append((tid, stack_base, stack_size, stack_rva, ctx_size, ctx_rva))
        elif stype == 24:  # ThreadNamesStream
            (count,) = struct.unpack_from("<I", data, rva)
            for t in range(count):
                tid, name_rva = struct.unpack_from("<IQ", data, rva + 4 + 12 * t)
                (slen,) = struct.unpack_from("<I", data, name_rva)
                names[tid] = data[name_rva + 4 : name_rva + 4 + slen].decode("utf-16-le",
                                                                             errors="replace")
    return data, threads, names

def symbolize(addrs):
    addrs = sorted(addrs)
    if not addrs:
        return {}
    sym = next((s for s in SYMBOLIZERS if os.path.exists(s)), None)
    if not sym:
        return {a: "exe+0x%x" % (a - EXE_BASE) for a in addrs}
    inp = "".join("0x%x\n" % (a - EXE_BASE) for a in addrs)
    p = subprocess.run([sym, "--obj=" + EXE, "--relative-address", "-f", "-i"],
                       input=inp, capture_output=True, text=True,
                       encoding="utf-8", errors="replace")
    out = {}
    for a, block in zip(addrs, p.stdout.strip().split("\n\n")):
        lines = block.strip().splitlines()
        fn = lines[0] if lines else "?"
        loc = lines[1].split("\\")[-1].split("/")[-1] if len(lines) > 1 else ""
        out[a] = fn + (" @" + loc if loc else "")
    return out

def main():
    pid = find_pid()
    print("pid:", pid)
    write_dump(pid)
    data, threads, names = parse(OUT)
    print("%d threads, %d named" % (len(threads), len(names)))
    all_addrs = set()
    rows = []
    for tid, sbase, ssize, srva, csize, crva in threads:
        rip = struct.unpack_from("<Q", data, crva + 0xF8)[0]
        rsp = struct.unpack_from("<Q", data, crva + 0x98)[0]
        rets = []
        if ssize and srva:
            # the stack bytes are embedded; rsp sits inside [sbase, sbase+ssize)
            lo = max(0, rsp - sbase)
            blob = data[srva + int(lo) : srva + min(ssize, int(lo) + 4096)]
            for i in range(0, len(blob) - 7, 8):
                v = struct.unpack_from("<Q", blob, i)[0]
                if EXE_BASE <= v < EXE_END:
                    rets.append(v)
                    if len(rets) >= 8:
                        break
        rows.append((tid, rip, rets))
        if EXE_BASE <= rip < EXE_END:
            all_addrs.add(rip)
        all_addrs.update(rets)
    syms = symbolize(all_addrs)
    def nm(a):
        return syms.get(a, "0x%x" % a) if EXE_BASE <= a < EXE_END else "0x%x" % a
    # named/interesting threads first
    rows.sort(key=lambda r: (names.get(r[0], "") == "", names.get(r[0], "")))
    for tid, rip, rets in rows:
        name = names.get(tid, "")
        line = "tid %6d %-28s rip %s" % (tid, name[:28], nm(rip))
        for r in rets:
            line += "\n%45s<- %s" % ("", nm(r))
        print(line)

main()
