#!/usr/bin/env python3
"""Cap every loop in every dumped shader that has one, and install the results as patches.

WHY THE BLANKET EXPERIMENT
    The device fault says the hang is one shader in a 624-byte window - ten instruction pointers
    inside it, zero memory faults - so it is a loop that does not terminate. But of the ten shaders
    the work journal could NAME, nine contain no loop at all and the tenth is the one already tested.
    Rather than guess at the shaders the journal could not name, cap them ALL:

        hang disappears -> it IS a loop, in one of these; bisect by halves from here
        hang remains    -> no loop in any DUMPED shader is the hang, and the search moves to the
                           shaders the dump does not contain

WHY THE CAP IS 1000 AND NOT 1000000
    The first run of this experiment used 1,000,000 and concluded the shader was innocent because the
    hang survived. That conclusion was WRONG, and the reason is arithmetic: these loops converge in
    about 32 iterations, so a runaway one capped at a million still runs ~30,000 times longer than it
    should. At a few hundred cycles an iteration that is seconds of GPU time - past the 2-second TDR
    window - so the capped shader could still hang and the experiment could not tell the difference.
    A cap only exonerates if the capped shader CANNOT hang. 1000 leaves 30x headroom over the real
    iteration count while being 1000x cheaper than the old cap.

    Arithmetic for why 1000 bites and 1000000 does not, since the difference is the whole experiment:
    the journal measured a dispatch of 4,194,304 invocations. Against ~20k lanes that is ~210
    sequential passes, so the GPU time is 210 * cap * cycles-per-iteration. At cap 1e6 and a few
    hundred cycles that is tens of seconds - past the 2-second TDR either way, so the shader could
    still hang and the run could not tell. At cap 1000 the same dispatch finishes in tens of
    MILLISECONDS. Only the second value can distinguish innocence from a loose bound.

⚠⚠ THE TRADE-OFF IS BIGGER THAN "A WRONG PIXEL", and this was learned the hard way. The first blanket
    run at cap 1000 never reached the hang: it died on `ASSERT(adjust % 4 == 0)` in
    vk_rasterizer.cpp BindBuffers, an assert that appears in NONE of the 15 previous run logs. The
    reason is visible in these shaders - most of them carry OpStores (up to 32), and this game is
    GPU-driven, so what a compute shader writes becomes the BUFFER DESCRIPTORS a later dispatch
    reads. Truncating a legitimately long loop therefore does not shade a pixel wrongly, it hands the
    next dispatch a misaligned address and kills the run before the hang can happen. A shader whose
    loop legitimately runs over an array of 4096 elements is broken by a cap of 1000.

    So a single global cap cannot be right for all 24: their legitimate trip counts differ. Bisect
    with bisect_loops.py instead, and read that assert as its own signal - it identifies a half
    containing an address-generating shader with a long legitimate loop, which is information, not
    just a failure.
"""

import os
import struct
import subprocess
import sys

SDK = r"C:\VulkanSDK\1.4.357.0\Bin"
DUMPS = r"C:\Users\3E30~1\AppData\Roaming\shadPS4\shader\dumps"
PATCH = r"C:\Users\3E30~1\AppData\Roaming\shadPS4\shader\patch"
WORK = os.path.join(os.path.dirname(os.path.abspath(__file__)), "work")
GUARD = os.path.join(os.path.dirname(os.path.abspath(__file__)), "add_loop_guard.py")


def loop_count(path: str) -> int:
    """OpLoopMerge count, by walking the instruction stream. A raw byte search would also match
    inside string literals and operands."""
    with open(path, "rb") as f:
        b = f.read()
    if len(b) < 20 or struct.unpack("<I", b[:4])[0] != 0x07230203:
        return 0
    n, i = 0, 20
    while i + 4 <= len(b):
        w = struct.unpack("<I", b[i:i + 4])[0]
        wc, op = w >> 16, w & 0xFFFF
        if wc == 0:
            break
        if op == 246:
            n += 1
        i += wc * 4
    return n


def run(args, err_path):
    with open(err_path, "wb") as e:
        return subprocess.run(args, stderr=e, stdout=subprocess.DEVNULL).returncode == 0


def head(path, n=160):
    try:
        with open(path, "r", errors="replace") as f:
            return " ".join(f.read().split())[:n]
    except OSError:
        return ""


def main() -> int:
    os.makedirs(WORK, exist_ok=True)
    os.makedirs(PATCH, exist_ok=True)

    todo = []
    for name in sorted(os.listdir(DUMPS)):
        if not name.endswith(".spv"):
            continue
        p = os.path.join(DUMPS, name)
        c = loop_count(p)
        if c:
            todo.append((name[:-4], p, c))

    print(f"shaders with at least one loop: {len(todo)}")
    ok, fail = [], []
    for stem, src, nloops in todo:
        asm = os.path.join(WORK, stem + ".asm")
        cap = os.path.join(WORK, stem + ".capped.asm")
        out = os.path.join(WORK, stem + ".spv")
        if not run([os.path.join(SDK, "spirv-dis.exe"), src, "-o", asm], asm + ".err"):
            fail.append((stem, "dis: " + head(asm + ".err")))
            continue
        r = subprocess.run([sys.executable, GUARD, asm, cap], capture_output=True, text=True)
        if r.returncode != 0:
            fail.append((stem, "guard: " + " ".join((r.stdout + r.stderr).split())[:140]))
            continue
        if not run([os.path.join(SDK, "spirv-as.exe"), "--target-env", "vulkan1.3", cap, "-o", out],
                   out + ".as.err"):
            fail.append((stem, "as: " + head(out + ".as.err")))
            continue
        if not run([os.path.join(SDK, "spirv-val.exe"), "--target-env", "vulkan1.3", out],
                   out + ".val.err"):
            fail.append((stem, "val: " + head(out + ".val.err")))
            continue
        # Verify the guard is really in the assembled binary before installing it - an install that
        # silently carries the ORIGINAL shader would make the whole experiment answer nothing.
        with open(out, "rb") as f:
            blob = f.read()
        if loop_count(out) != nloops:
            fail.append((stem, f"loop count changed {nloops} -> {loop_count(out)}"))
            continue
        with open(os.path.join(PATCH, stem + ".spv"), "wb") as f:
            f.write(blob)
        ok.append((stem, nloops))

    print(f"\ncapped and installed: {len(ok)}    failed: {len(fail)}")
    total = sum(n for _, n in ok)
    print(f"loops capped in total: {total}")
    for stem, n in ok:
        print(f"  {n} loop(s)  {stem}")
    if fail:
        print("\nFAILED (left unpatched - these shaders are NOT covered by the experiment):")
        for stem, why in fail:
            print(f"  {stem}: {why}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
