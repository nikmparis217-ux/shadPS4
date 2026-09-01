#!/usr/bin/env python3
"""Remove the OpControlBarrier that sits INSIDE a loop, to test for a barrier deadlock.

    python drop_loop_barrier.py <shader-stem>          e.g. cs_0x00000000ef4a0dc6_0

WHY THIS AND NOT ANOTHER CAP
    Capping iterations answered nothing about this shader, twice (1000 and 65536), and it never could
    have. `cs_ef4a0dc6` is the ONLY shader in the whole dump with a barrier inside a loop, and its
    loop exits on `i != end` with BOTH bounds loaded from memory:

        %259 = OpPhi ...            i, starting at mem[a], += 1 each turn
        OpControlBarrier ...        <-- every invocation must reach this, every iteration
        %286 = OpINotEqual %259 %156    end, from mem[b]
        OpBranchConditional ...     exit when i == end

    If two invocations in a workgroup compute different `end` values they need different trip counts.
    The one that leaves early never reaches the barrier again; the one still looping waits at it for
    a partner that no longer exists, and waits for ever. An iteration cap changes WHEN invocations
    leave, not WHETHER they leave together - so it cannot fix, and cannot rule out, this failure. The
    barrier has to go instead.

WHAT THIS COSTS, STATED
    Removing a barrier removes real synchronisation: the shader shares data through `shared_mem_u64`,
    so without it invocations can read what a neighbour has not written yet. Results may be wrong.
    That is acceptable ONLY as a diagnostic and must never be shipped - the fix for a real barrier
    deadlock is to make the loop's trip count uniform across the workgroup, not to delete the barrier.

READING THE RESULT
    hang disappears -> a non-uniform barrier IS the hang. The fix is uniformity, not deletion.
    hang remains    -> the barrier is not the mechanism, and this shader is finally exhausted:
                       its loop is capped-and-innocent AND its barrier is innocent.
"""

import os
import re
import shutil
import subprocess
import sys

SDK = r"C:\VulkanSDK\1.4.357.0\Bin"
DUMPS = r"C:\Users\3E30~1\AppData\Roaming\shadPS4\shader\dumps"
PATCH = r"C:\Users\3E30~1\AppData\Roaming\shadPS4\shader\patch"
WORK = os.path.join(os.path.dirname(os.path.abspath(__file__)), "work")


def main() -> int:
    if len(sys.argv) != 2:
        print(__doc__)
        return 1
    stem = sys.argv[1]
    src = os.path.join(DUMPS, stem + ".spv")
    if not os.path.exists(src):
        print(f"no such dumped shader: {src}")
        return 1
    os.makedirs(WORK, exist_ok=True)
    asm = os.path.join(WORK, stem + ".nobar.asm")
    out = os.path.join(WORK, stem + ".nobar.spv")

    subprocess.run([os.path.join(SDK, "spirv-dis.exe"), src, "-o", asm], check=True)
    with open(asm, encoding="utf-8") as f:
        lines = f.read().split("\n")

    # Locate the loop constructs by their OpLoopMerge, then the barriers that fall inside one. Block
    # ORDER is what decides "inside": SPIR-V requires structured control flow, so a block between a
    # loop header and its merge label belongs to that loop.
    labels = [i for i, l in enumerate(lines) if re.match(r"\s*%\w+ = OpLabel\s*$", l)]
    loops = []
    for i, l in enumerate(lines):
        m = re.match(r"\s*OpLoopMerge (%\w+) (%\w+) ", l)
        if m:
            merge = m.group(1)
            mline = next((j for j, x in enumerate(lines)
                          if re.match(rf"\s*{re.escape(merge)} = OpLabel\s*$", x)), len(lines))
            loops.append((i, mline, merge))

    removed = []
    for i, l in enumerate(lines):
        if "OpControlBarrier" not in l:
            continue
        inside = next(((h, m) for h, m, _ in loops if h < i < m), None)
        if inside:
            removed.append(i)
            print(f"  removing line {i + 1}: {l.strip()}")
        else:
            print(f"  KEEPING line {i + 1} (outside every loop): {l.strip()}")

    if not removed:
        print("no OpControlBarrier inside a loop - nothing to do, and nothing to learn here")
        return 1

    kept = [l for i, l in enumerate(lines) if i not in removed]
    with open(asm, "w", encoding="utf-8") as f:
        f.write("\n".join(kept))

    for tool, args in (("spirv-as.exe", ["--target-env", "vulkan1.3", asm, "-o", out]),
                       ("spirv-val.exe", ["--target-env", "vulkan1.3", out])):
        r = subprocess.run([os.path.join(SDK, tool)] + args, capture_output=True, text=True)
        if r.returncode != 0:
            print(f"{tool} FAILED: {' '.join((r.stdout + r.stderr).split())[:200]}")
            return 1

    # Clear every other patch: one variable per run, or the result is unattributable.
    os.makedirs(PATCH, exist_ok=True)
    for f in os.listdir(PATCH):
        if f.endswith(".spv"):
            os.remove(os.path.join(PATCH, f))
    shutil.copyfile(out, os.path.join(PATCH, stem + ".spv"))
    print(f"\ninstalled {stem}.spv with {len(removed)} in-loop barrier(s) removed")
    print("this is the ONLY patch installed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
