# dump_dissect.py - parse shadPS4 guest-crash minidumps (run170/run171),
# list memory ranges + thread contexts, disassemble around the faulting IP,
# scan the stack for return addresses, and diff the IP bytes across dumps.
# ASCII only. Measured facts only: if a range is absent from the dump, say so.

import struct
import sys
import os

from minidump.minidumpfile import MinidumpFile
import capstone

HERE = os.path.dirname(os.path.abspath(__file__))
LOGS = os.path.normpath(os.path.join(HERE, "..", "logs"))
DUMPS = [
    ("run170", os.path.join(LOGS, "run170_guest_crash.dmp")),
    ("run171", os.path.join(LOGS, "run171_guest_crash.dmp")),
]

FAULT_IP = 0x700000B33500
FAULT_WRITE = 0x700000B3348D

# x64 CONTEXT structure offsets (standard CONTEXT_AMD64)
CTX_FIELDS = [
    ("ContextFlags", 0x30, "I"),
    ("SegCs", 0x38, "H"), ("SegDs", 0x3A, "H"), ("SegEs", 0x3C, "H"),
    ("SegFs", 0x3E, "H"), ("SegGs", 0x40, "H"), ("SegSs", 0x42, "H"),
    ("EFlags", 0x44, "I"),
    ("Dr0", 0x48, "Q"), ("Dr1", 0x50, "Q"), ("Dr2", 0x58, "Q"),
    ("Dr3", 0x60, "Q"), ("Dr6", 0x68, "Q"), ("Dr7", 0x70, "Q"),
    ("Rax", 0x78, "Q"), ("Rcx", 0x80, "Q"), ("Rdx", 0x88, "Q"),
    ("Rbx", 0x90, "Q"), ("Rsp", 0x98, "Q"), ("Rbp", 0xA0, "Q"),
    ("Rsi", 0xA8, "Q"), ("Rdi", 0xB0, "Q"),
    ("R8", 0xB8, "Q"), ("R9", 0xC0, "Q"), ("R10", 0xC8, "Q"),
    ("R11", 0xD0, "Q"), ("R12", 0xD8, "Q"), ("R13", 0xE0, "Q"),
    ("R14", 0xE8, "Q"), ("R15", 0xF0, "Q"),
    ("Rip", 0xF8, "Q"),
]


class Dump:
    def __init__(self, tag, path):
        self.tag = tag
        self.path = path
        self.raw = open(path, "rb").read()
        self.mf = MinidumpFile.parse(path)
        # collect memory segments as (vaddr, size, file_off)
        self.segs = []
        if self.mf.memory_segments_64 is not None:
            for s in self.mf.memory_segments_64.memory_segments:
                self.segs.append((s.start_virtual_address, s.size,
                                  s.start_file_address))
        if self.mf.memory_segments is not None:
            for s in self.mf.memory_segments.memory_segments:
                self.segs.append((s.start_virtual_address, s.size,
                                  s.start_file_address))
        self.segs.sort()
        # modules
        self.modules = []
        if self.mf.modules is not None:
            for m in self.mf.modules.modules:
                self.modules.append((m.baseaddress, m.size, m.name))
        self.modules.sort()

    def read_vmem(self, vaddr, size):
        """Read up to size bytes at vaddr from whatever segments the dump
        holds. Returns (bytes, actual_start) or (None, None) if nothing."""
        for (sva, ssz, foff) in self.segs:
            if sva <= vaddr < sva + ssz:
                avail = sva + ssz - vaddr
                take = min(size, avail)
                off = foff + (vaddr - sva)
                return self.raw[off:off + take], vaddr
        return None, None

    def seg_holding(self, vaddr):
        for (sva, ssz, foff) in self.segs:
            if sva <= vaddr < sva + ssz:
                return (sva, ssz, foff)
        return None

    def module_for(self, vaddr):
        for (base, size, name) in self.modules:
            if base <= vaddr < base + size:
                return "%s+0x%x" % (os.path.basename(name), vaddr - base)
        return None


def parse_context(raw, rva, size):
    if size < 0x100:
        return None
    blob = raw[rva:rva + size]
    ctx = {}
    for (name, off, fmt) in CTX_FIELDS:
        ctx[name] = struct.unpack_from("<" + fmt, blob, off)[0]
    return ctx


def list_threads(d):
    print("--- threads (%d) ---" % len(d.mf.threads.threads))
    crash_tid = None
    if d.mf.exception is not None:
        er = d.mf.exception.exception_records[0]
        crash_tid = er.ThreadId
        code = er.ExceptionRecord.ExceptionCode
        code = getattr(code, "value", code)
        print("exception stream: code=%s tid=0x%x addr=0x%x nparams=%d"
              % (hex(code) if isinstance(code, int) else str(code),
                 er.ThreadId,
                 er.ExceptionRecord.ExceptionAddress,
                 er.ExceptionRecord.NumberParameters))
        params = er.ExceptionRecord.ExceptionInformation[
            :er.ExceptionRecord.NumberParameters]
        if len(params) >= 2:
            kind = {0: "READ", 1: "WRITE", 8: "DEP-EXEC"}.get(
                params[0], str(params[0]))
            print("  access violation: %s at 0x%x" % (kind, params[1]))
    else:
        print("exception stream: ABSENT")

    # the exception stream carries the FAULTING context (the thread-list
    # context is captured later, inside the crash handler)
    fault_ctx = None
    if d.mf.exception is not None:
        loc = d.mf.exception.exception_records[0].ThreadContext
        fault_ctx = parse_context(d.raw, loc.Rva, loc.DataSize)
        if fault_ctx:
            print("--- FAULTING context (from exception stream) ---")
            regs = ["Rax", "Rbx", "Rcx", "Rdx", "Rsi", "Rdi", "Rbp", "Rsp",
                    "R8", "R9", "R10", "R11", "R12", "R13", "R14", "R15",
                    "Rip", "EFlags"]
            for i in range(0, len(regs), 3):
                row = "  ".join("%-6s=0x%016x" % (r, fault_ctx[r])
                                for r in regs[i:i+3])
                print("  " + row)
        else:
            print("--- exception stream context blob too small ---")

    contexts = {}
    for t in d.mf.threads.threads:
        rva = t.ThreadContext.Rva
        size = t.ThreadContext.DataSize
        ctx = parse_context(d.raw, rva, size)
        contexts[t.ThreadId] = ctx
        mark = " <-- CRASHING THREAD" if t.ThreadId == crash_tid else ""
        if ctx:
            print("tid=0x%-6x rip=0x%012x rsp=0x%012x%s"
                  % (t.ThreadId, ctx["Rip"], ctx["Rsp"], mark))
        else:
            print("tid=0x%-6x (context blob %d bytes, too small)%s"
                  % (t.ThreadId, size, mark))
    if crash_tid is not None and contexts.get(crash_tid):
        c = contexts[crash_tid]
        print("--- crashing thread full context (tid=0x%x) ---" % crash_tid)
        regs = ["Rax", "Rbx", "Rcx", "Rdx", "Rsi", "Rdi", "Rbp", "Rsp",
                "R8", "R9", "R10", "R11", "R12", "R13", "R14", "R15",
                "Rip", "EFlags"]
        for i in range(0, len(regs), 3):
            row = "  ".join("%-6s=0x%016x" % (r, c[r]) for r in regs[i:i+3])
            print("  " + row)
        print("  SegCs=0x%04x SegSs=0x%04x Dr7=0x%x"
              % (c["SegCs"], c["SegSs"], c["Dr7"]))
    return crash_tid, contexts, fault_ctx


def list_memranges(d):
    print("--- memory ranges in dump (%d) ---" % len(d.segs))
    for (sva, ssz, foff) in d.segs:
        mod = d.module_for(sva)
        extra = ("  [%s]" % mod) if mod else ""
        print("  0x%012x - 0x%012x  (%7d bytes, file off 0x%x)%s"
              % (sva, sva + ssz, ssz, foff, extra))
    if d.modules:
        print("--- modules in dump (%d) --- (first/last 8)" % len(d.modules))
        show = d.modules if len(d.modules) <= 16 else \
            d.modules[:8] + d.modules[-8:]
        for (base, size, name) in show:
            print("  0x%012x +0x%08x  %s" % (base, size, name))
    else:
        print("--- module list: ABSENT ---")


def hexdump(data, base, per=16):
    out = []
    for i in range(0, len(data), per):
        chunk = data[i:i+per]
        hx = " ".join("%02x" % b for b in chunk)
        asc = "".join(chr(b) if 32 <= b < 127 else "." for b in chunk)
        out.append("  %012x  %-*s  %s" % (base + i, per * 3 - 1, hx, asc))
    return "\n".join(out)


def disasm_around_ip(d):
    print("--- code around IP 0x%x ---" % FAULT_IP)
    seg = d.seg_holding(FAULT_IP)
    if seg is None:
        print("  the dump holds NO memory at the faulting IP")
        return None
    sva, ssz, foff = seg
    print("  IP lives in dump range 0x%x-0x%x" % (sva, sva + ssz))
    want_lo = max(sva, FAULT_IP - 512)
    want_hi = min(sva + ssz, FAULT_IP + 512)
    data = d.raw[foff + (want_lo - sva): foff + (want_hi - sva)]
    print("  extracted 0x%x bytes: 0x%x .. 0x%x"
          % (len(data), want_lo, want_hi))

    # raw hexdump of the 96 bytes bracketing the IP and the write target
    lo = max(want_lo, FAULT_WRITE - 16)
    hi = min(want_hi, FAULT_IP + 64)
    print("  hexdump around write target (0x%x) and IP (0x%x):"
          % (FAULT_WRITE, FAULT_IP))
    print(hexdump(data[lo - want_lo: hi - want_lo], lo))

    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_64)
    md.detail = False

    def run(start_va, label, max_ins=200):
        print("  -- disassembly starting at 0x%x (%s) --" % (start_va, label))
        code = data[start_va - want_lo:]
        n = 0
        hit_ip = False
        for ins in md.disasm(code, start_va):
            mark = ""
            if ins.address == FAULT_IP:
                mark = "   <=== FAULTING IP"
                hit_ip = True
            if ins.address <= FAULT_WRITE < ins.address + ins.size:
                mark += "   <== write target is INSIDE this instruction's bytes"
            print("    0x%012x: %-8s %-40s%s"
                  % (ins.address,
                     ins.bytes.hex(), ins.mnemonic + " " + ins.op_str, mark))
            n += 1
            if n >= max_ins:
                print("    ... (truncated at %d instructions)" % max_ins)
                break
            if ins.address >= FAULT_IP + 96:
                break
        if n == 0:
            print("    capstone decoded NOTHING here (invalid encoding)")
        return hit_ip

    # pass 1: start exactly at the faulting IP (always well-aligned by def.)
    run(FAULT_IP, "the faulting IP itself", max_ins=24)
    # pass 2: from 512 before, to see whether a coherent stream reaches the IP
    hit = run(want_lo, "IP-512, alignment unknown", max_ins=400)
    print("  linear stream from IP-512 %s the faulting IP"
          % ("REACHES" if hit else "does NOT reach"))
    # pass 3: around the write target
    run(max(want_lo, FAULT_WRITE - 32), "write-target - 32", max_ins=24)
    return data, want_lo


def scan_stack(d, ctx):
    rsp = ctx["Rsp"]
    print("--- stack scan at rsp=0x%x (16 KiB) ---" % rsp)
    data, start = d.read_vmem(rsp, 16384)
    if data is None:
        print("  the dump holds NO memory at rsp")
        return
    print("  dump holds 0x%x bytes at rsp (asked 0x4000)" % len(data))
    found = 0
    for off in range(0, len(data) - 7, 8):
        val = struct.unpack_from("<Q", data, off)[0]
        cls = None
        if 0x7FF000000000 <= val <= 0x7FFFFFFFFFFF:
            cls = "HOST-DLL"
        elif 0x140000000 <= val < 0x150000000:
            cls = "EXE"
        elif 0x700000000000 <= val < 0x700100000000:
            cls = "GUEST/JIT-region"
        if cls is None:
            continue
        mod = d.module_for(val)
        modtxt = ("  [%s]" % mod) if mod else ""
        # is the value itself inside a dumped range (could verify code)?
        indump = " (in dump)" if d.seg_holding(val) else ""
        print("  rsp+0x%04x  0x%016x  %s%s%s"
              % (off, val, cls, modtxt, indump))
        found += 1
        if found >= 120:
            print("  ... (truncated at 120 hits)")
            break
    if found == 0:
        print("  no qword in the 16 KiB matched host-DLL/exe/guest patterns")


EXE_PATH = os.path.normpath(os.path.join(
    HERE, "..", "..", "Build", "x64-Clang-RelWithDebInfo", "shadps4.exe"))
CORRECT_HELPER_RVA = 0xB33E30  # CopyDynrcWindowClamped entry (llvm-symbolizer)


def callsite_at_rsp(d, ctx):
    """Recover the caller: disassemble the bytes ending at [rsp]."""
    print("--- call-site recovery at [rsp] ---")
    stack, _ = d.read_vmem(ctx["Rsp"], 8)
    if stack is None:
        print("  no stack memory in dump")
        return
    ret = struct.unpack("<Q", stack)[0]
    print("  [rsp] = 0x%x" % ret)
    seg = d.seg_holding(ret)
    if seg is None:
        print("  the dump holds NO memory around [rsp]'s value")
        return
    sva, ssz, foff = seg
    lo = max(sva, ret - 0x30)
    data = d.raw[foff + (lo - sva): foff + (ret - sva) + 0x20]
    print(hexdump(data, lo))
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_64)
    for back in range(0x30, 0, -1):
        start = ret - back
        if start < sva:
            continue
        code = d.raw[foff + (start - sva): foff + (ret - sva)]
        insns = list(md.disasm(code, start))
        if insns and insns[-1].address + insns[-1].size == ret and \
           insns[-1].mnemonic.startswith("call"):
            print("  coherent stream ends in a CALL at [rsp]-%d:" %
                  insns[-1].size)
            for i in insns:
                print("    0x%012x: %-16s %s %s"
                      % (i.address, i.bytes.hex(), i.mnemonic, i.op_str))
            break


def compare_with_exe(d):
    """Byte-compare the dumped exe .text range with the on-disk binary and
    scan the binary for disp32 references to the fault target and to the
    correct helper entry."""
    print("--- on-disk exe comparison ---")
    if not os.path.exists(EXE_PATH):
        print("  %s not found; skipping" % EXE_PATH)
        return
    exe = open(EXE_PATH, "rb").read()
    e = struct.unpack_from("<I", exe, 0x3C)[0]
    ts = struct.unpack_from("<I", exe, e + 8)[0]
    nsec = struct.unpack_from("<H", exe, e + 6)[0]
    optsz = struct.unpack_from("<H", exe, e + 0x14)[0]
    sec0 = e + 0x18 + optsz
    text = None
    for i in range(nsec):
        o = sec0 + i * 40
        if exe[o:o+8].rstrip(b"\0") == b".text":
            vsz, va, rsz, ro = struct.unpack_from("<IIII", exe, o + 8)
            text = (va, vsz, ro, rsz)
    dump_ts = None
    for (base, size, name) in d.modules:
        if "shadps4" in name.lower():
            for m in d.mf.modules.modules:
                if m.baseaddress == base:
                    dump_ts = m.timestamp
    print("  exe TimeDateStamp on disk 0x%08x, in dump %s"
          % (ts, ("0x%08x" % dump_ts) if dump_ts else "?"))
    seg = d.seg_holding(FAULT_IP)
    if seg and text:
        sva, ssz, foff = seg
        rva = sva - 0x700000000000
        va, vsz, ro, rsz = text
        eb = exe[ro + (rva - va): ro + (rva - va) + ssz]
        db = d.raw[foff: foff + ssz]
        nd = sum(1 for a, b in zip(db, eb) if a != b)
        print("  dumped range 0x%x (+0x%x) vs on-disk .text: %d differing "
              "bytes" % (sva, ssz, nd))
    if text:
        va, vsz, ro, rsz = text
        body = exe[ro:ro + rsz]
        for tgt, label in ((FAULT_IP - 0x700000000000, "fault target"),
                           (CORRECT_HELPER_RVA, "CopyDynrcWindowClamped")):
            refs = []
            for p in range(0, rsz - 4):
                disp = struct.unpack_from("<i", body, p)[0]
                if (va + p + 4 + disp) == tgt:
                    refs.append(va + p)
            print("  disp32 refs in exe .text to exe+0x%x (%s): %s"
                  % (tgt, label, [hex(r) for r in refs[:8]] or "NONE"))


def main():
    ip_bytes = {}
    for (tag, path) in DUMPS:
        print("=" * 78)
        print("DUMP %s  (%s, %d bytes)" % (tag, path, os.path.getsize(path)))
        print("=" * 78)
        d = Dump(tag, path)
        # streams present
        names = []
        for e in d.mf.header.__dict__.items():
            pass
        list_memranges(d)
        crash_tid, contexts, fault_ctx = list_threads(d)
        r = disasm_around_ip(d)
        if r is not None:
            data, lo = r
            ip_bytes[tag] = (lo, data)
        if fault_ctx:
            print("(scanning the FAULTING rsp from the exception stream)")
            scan_stack(d, fault_ctx)
            callsite_at_rsp(d, fault_ctx)
            compare_with_exe(d)
        elif crash_tid is not None and contexts.get(crash_tid):
            print("(no exception context; falling back to thread-list rsp)")
            scan_stack(d, contexts[crash_tid])
        else:
            print("--- no context at all; skipping stack scan ---")
        print()

    print("=" * 78)
    print("DIFF run170 vs run171: bytes around IP")
    print("=" * 78)
    if len(ip_bytes) == 2:
        lo0, b0 = ip_bytes["run170"]
        lo1, b1 = ip_bytes["run171"]
        if lo0 != lo1:
            print("ranges differ: run170 starts 0x%x, run171 starts 0x%x"
                  % (lo0, lo1))
        n = min(len(b0), len(b1))
        diffs = [i for i in range(n) if b0[i] != b1[i]]
        if not diffs and len(b0) == len(b1):
            print("IDENTICAL: all 0x%x bytes at 0x%x..0x%x match"
                  % (n, lo0, lo0 + n))
        else:
            print("%d differing byte(s) of 0x%x compared" % (len(diffs), n))
            for i in diffs[:64]:
                print("  0x%012x: run170=%02x run171=%02x"
                      % (lo0 + i, b0[i], b1[i]))
    else:
        print("could not extract IP bytes from both dumps: have %s"
              % list(ip_bytes.keys()))


if __name__ == "__main__":
    main()
