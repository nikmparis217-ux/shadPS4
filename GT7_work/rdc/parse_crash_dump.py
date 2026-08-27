# parse_crash_dump.py - post-mortem twin of dump_live_stacks.py: parse an EXISTING minidump
# (shadPS4's own WriteGuestCrashDump output), name the module at the faulting rip, and walk
# the crashing thread's stack for host-exe return addresses, symbolized against the
# fixed-base exe (/BASE:0x700000000000, /DYNAMICBASE:NO).
# Streams: 3 ThreadList, 4 ModuleList, 6 Exception, 24 ThreadNames.
# Usage: python parse_crash_dump.py <dump> [max_stack_bytes]
# ASCII only. Built for run 180's 17GB-memcpy read AV.
import os, struct, subprocess, sys

EXE_BASE = 0x700000000000
EXE_END = EXE_BASE + 0x6000000
EXE = r"C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\Build\x64-Clang-RelWithDebInfo\shadps4.exe"
SYMBOLIZERS = [
    r"C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\Llvm\x64\bin\llvm-symbolizer.exe",
    r"C:\Program Files\LLVM\bin\llvm-symbolizer.exe",
]


def read_dump(path):
    data = open(path, "rb").read()
    sig, ver, nstreams, dir_rva = struct.unpack_from("<4sIII", data, 0)
    assert sig == b"MDMP", "not a minidump"
    streams = {}
    for i in range(nstreams):
        stype, dsize, rva = struct.unpack_from("<III", data, dir_rva + 12 * i)
        streams.setdefault(stype, []).append((rva, dsize))
    return data, streams


def parse_threads(data, streams):
    threads = {}
    for rva, _ in streams.get(3, []):
        (count,) = struct.unpack_from("<I", data, rva)
        off = rva + 4
        for t in range(count):
            tid, _sc, _pc, _pr, _teb, sbase, ssize, srva, csize, crva = struct.unpack_from(
                "<IIIIQQIIII", data, off + 48 * t)
            threads[tid] = (sbase, ssize, srva, csize, crva)
    return threads


def parse_names(data, streams):
    names = {}
    for rva, _ in streams.get(24, []):
        (count,) = struct.unpack_from("<I", data, rva)
        for t in range(count):
            tid, name_rva = struct.unpack_from("<IQ", data, rva + 4 + 12 * t)
            (slen,) = struct.unpack_from("<I", data, name_rva)
            names[tid] = data[name_rva + 4: name_rva + 4 + slen].decode(
                "utf-16-le", errors="replace")
    return names


def parse_modules(data, streams):
    mods = []
    for rva, _ in streams.get(4, []):
        (count,) = struct.unpack_from("<I", data, rva)
        off = rva + 4
        for m in range(count):
            # MINIDUMP_MODULE is 108 bytes; ModuleNameRva is a 32-bit RVA at offset 20.
            base, size, _cksum, _tstamp, name_rva = struct.unpack_from(
                "<QIIII", data, off + 108 * m)
            (slen,) = struct.unpack_from("<I", data, name_rva)
            name = data[name_rva + 4: name_rva + 4 + slen].decode("utf-16-le",
                                                                  errors="replace")
            mods.append((base, size, name))
    return sorted(mods)


def parse_exception(data, streams):
    for rva, _ in streams.get(6, []):
        tid, _align = struct.unpack_from("<II", data, rva)
        code, flags, inner, addr, nparams = struct.unpack_from("<IIQQI", data, rva + 8)
        params = struct.unpack_from("<8Q", data, rva + 8 + 32)[:nparams]
        crva, csize = struct.unpack_from("<II", data, rva + 8 + 24 + 8 * 15 + 8)
        # MINIDUMP_EXCEPTION_STREAM: tid, align, MINIDUMP_EXCEPTION (152), then ThreadContext
        crva_off = rva + 8 + 152
        ctx_size, ctx_rva = struct.unpack_from("<II", data, crva_off)
        return tid, code, addr, params, ctx_size, ctx_rva
    return None


def module_for(mods, addr):
    for base, size, name in mods:
        if base <= addr < base + size:
            return "%s+0x%x" % (name.split("\\")[-1], addr - base)
    return None


def symbolize(addrs):
    addrs = sorted(set(addrs))
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
    path = sys.argv[1]
    max_scan = int(sys.argv[2]) if len(sys.argv) > 2 else 16384
    data, streams = read_dump(path)
    threads = parse_threads(data, streams)
    names = parse_names(data, streams)
    mods = parse_modules(data, streams)
    exc = parse_exception(data, streams)
    print("dump: %s (%d bytes), %d threads, %d modules" %
          (path, len(data), len(threads), len(mods)))
    if not exc:
        print("no exception stream")
        return
    tid, code, addr, params, ctx_size, ctx_rva = exc
    print("exception 0x%08x in tid %d (%s), access addr 0x%x" %
          (code, tid, names.get(tid, "?"), params[1] if len(params) > 1 else 0))
    rip = struct.unpack_from("<Q", data, ctx_rva + 0xF8)[0]
    rsp = struct.unpack_from("<Q", data, ctx_rva + 0x98)[0]
    m = module_for(mods, rip)
    print("rip 0x%x = %s" % (rip, m or ("exe" if EXE_BASE <= rip < EXE_END else "?")))
    if tid not in threads:
        print("crash thread not in thread list")
        return
    sbase, ssize, srva, _cs, _cr = threads[tid]
    print("stack base 0x%x size 0x%x, rsp 0x%x" % (sbase, ssize, rsp))
    rets = []
    if ssize and srva:
        lo = max(0, rsp - sbase)
        blob = data[srva + int(lo): srva + min(ssize, int(lo) + max_scan)]
        for i in range(0, len(blob) - 7, 8):
            v = struct.unpack_from("<Q", blob, i)[0]
            if EXE_BASE <= v < EXE_END:
                rets.append((rsp + i, v))
            elif module_for(mods, v) and v > 0x7ff000000000:
                rets.append((rsp + i, v))
            if len(rets) >= 40:
                break
    syms = symbolize([v for _, v in rets if EXE_BASE <= v < EXE_END])
    for sp, v in rets:
        if EXE_BASE <= v < EXE_END:
            print("  [rsp+0x%04x] %s" % (sp - rsp, syms.get(v, hex(v))))
        else:
            print("  [rsp+0x%04x] %s" % (sp - rsp, module_for(mods, v)))


main()
