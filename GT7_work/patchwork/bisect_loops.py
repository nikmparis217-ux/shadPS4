#!/usr/bin/env python3
"""Bisect the 24 capped shaders down to the one whose loop hangs.

USE ONLY AFTER a full-cap run has shown the hang DISAPPEAR. If the hang survived the full cap, the
answer is not in this set and bisecting it would burn runs on a set already excluded.

    python bisect_loops.py status                 what is installed right now
    python bisect_loops.py keep <n>               install the first n of the ordered set (a half)
    python bisect_loops.py drop <n>               install all EXCEPT the first n
    python bisect_loops.py only <substr> [...]    install just the named ones
    python bisect_loops.py all                    reinstall every capped shader
    python bisect_loops.py none                   remove every patch (ship the real shaders)

THE ORDER IS FIXED AND RECORDED, which is the whole point: a bisection over a set that reorders
between steps is not a bisection. `keep`/`drop` slice this same list every time, so "keep 12" then
"keep 6" halves a stable interval and each run's result stays comparable to the last.

Reading a result: with a subset installed, the shaders NOT installed are running unmodified.
    hang returns  -> the culprit is among the ones NOT installed
    hang absent   -> the culprit is among the ones installed
Five runs settle 24 candidates. Record each verdict in the log below by hand - a bisection whose
history is not written down is a bisection that gets repeated.
"""

import os
import shutil
import sys

WORK = os.path.join(os.path.dirname(os.path.abspath(__file__)), "work")
PATCH = r"C:\Users\3E30~1\AppData\Roaming\shadPS4\shader\patch"

# The fixed order. Deliberately grouped so that shaders sharing a hash (permutations of one program)
# stay adjacent: a hash is one piece of guest code, and splitting its permutations across halves
# would let a bisection step change two unrelated things at once.
ORDER = [
    "cs_0x00000000018256c0_0", "cs_0x00000000018256c0_1",
    "cs_0x000000002a0cfcd2_0", "cs_0x000000002a0cfcd2_1", "cs_0x000000002a0cfcd2_2",
    "cs_0x000000002bbbbf0e_0",
    "cs_0x00000000366177d6_0",
    "cs_0x000000006421a7b6_0",
    "cs_0x000000007c3468f9_0", "cs_0x000000007c3468f9_1",
    "cs_0x00000000a911a841_0",
    "cs_0x00000000be0c3e4d_0",
    "cs_0x00000000c3d5603f_0",
    "cs_0x00000000d7208a63_0", "cs_0x00000000d7208a63_1", "cs_0x00000000d7208a63_2",
    "cs_0x00000000d7208a63_3", "cs_0x00000000d7208a63_4",
    "cs_0x00000000da05e7f8_0", "cs_0x00000000da05e7f8_1", "cs_0x00000000da05e7f8_2",
    "cs_0x00000000da05e7f8_3",
    "cs_0x00000000e49d4094_0",
    "cs_0x00000000ef4a0dc6_0",
]

# NOT COVERED by any of this: spirv-val rejects the guarded version (its continue block is not
# dominated by the condition block, which add_loop_guard.py assumes). If the bisection excludes every
# shader below, this one is the remaining candidate in the dumped set.
UNCOVERED = ["cs_0x00000000b603a2d6_0"]


def install(names):
    os.makedirs(PATCH, exist_ok=True)
    for f in os.listdir(PATCH):
        if f.endswith(".spv"):
            os.remove(os.path.join(PATCH, f))
    missing = []
    for n in names:
        src = os.path.join(WORK, n + ".spv")
        if not os.path.exists(src):
            missing.append(n)
            continue
        shutil.copyfile(src, os.path.join(PATCH, n + ".spv"))
    print(f"installed {len(names) - len(missing)} patch(es):")
    for n in names:
        if n not in missing:
            print(f"  {n}")
    if missing:
        print("MISSING from work/ (run cap_all_loops.py first):")
        for n in missing:
            print(f"  {n}")
    print(f"\nrunning UNMODIFIED this run: {len(ORDER) - len(names) + len(UNCOVERED)} shader(s)")
    for n in ORDER:
        if n not in names:
            print(f"  {n}")
    for n in UNCOVERED:
        print(f"  {n}   (never coverable - spirv-val rejects the guard)")


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__)
        return 1
    cmd = sys.argv[1]
    if cmd == "status":
        have = sorted(f[:-4] for f in os.listdir(PATCH) if f.endswith(".spv")) \
            if os.path.isdir(PATCH) else []
        print(f"{len(have)} patch(es) installed:")
        for h in have:
            print(f"  {h}")
        return 0
    if cmd == "all":
        install(ORDER)
    elif cmd == "none":
        install([])
    elif cmd == "keep":
        install(ORDER[:int(sys.argv[2])])
    elif cmd == "drop":
        install(ORDER[int(sys.argv[2]):])
    elif cmd == "only":
        pick = [n for n in ORDER if any(s in n for s in sys.argv[2:])]
        if not pick:
            print("nothing matched")
            return 1
        install(pick)
    else:
        print(__doc__)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
