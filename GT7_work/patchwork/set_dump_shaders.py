#!/usr/bin/env python3
"""Turn shadPS4's shader dumping on or off.  python set_dump_shaders.py on|off

WHY THIS IS NEEDED
    The loop-cap experiment can only cover shaders that exist on disk, and the dump holds 194 - all
    of them compute shaders - collected during one partial earlier run. `dumpShaders` is not even
    present in config.json, so it has been off ever since. If capping all 60 loops in those 194
    changes nothing, the culprit is either not a loop or is in a shader the dump never captured, and
    the two cannot be told apart without the complete set. This makes the set complete.

⚠ RUN THIS ONLY WHILE THE EMULATOR IS CLOSED. shadPS4 loads config.json at startup and writes it back
  on exit, so an edit made mid-session is silently discarded at shutdown - the change would appear to
  have been made and then have no effect, which is the worst of both.

⚠ config.json is UTF-8 WITH A BOM. Reading it as plain utf-8 fails on the first byte, and writing it
  back without the BOM has to be avoided as well - hence utf-8-sig on both sides.
"""

import io
import json
import os
import sys

CFG = r"C:\Users\3E30~1\AppData\Roaming\shadPS4\config.json"


def main() -> int:
    if len(sys.argv) != 2 or sys.argv[1] not in ("on", "off"):
        print(__doc__)
        return 1
    want = sys.argv[1] == "on"

    with io.open(CFG, encoding="utf-8-sig") as f:
        cfg = json.load(f)

    gpu = cfg.setdefault("GPU", {})
    before = gpu.get("dumpShaders", "(absent)")
    gpu["dumpShaders"] = want

    # Keep a copy the first time, so a bad edit is recoverable without guessing the defaults.
    bak = CFG + ".pre_dumpshaders"
    if not os.path.exists(bak):
        with io.open(CFG, encoding="utf-8-sig") as src, io.open(bak, "w", encoding="utf-8-sig") as dst:
            dst.write(src.read())
        print(f"backup written: {bak}")

    with io.open(CFG, "w", encoding="utf-8-sig") as f:
        json.dump(cfg, f, indent=4)

    # Read it back: a write that did not land is exactly the failure this file warns about.
    with io.open(CFG, encoding="utf-8-sig") as f:
        again = json.load(f)
    now = again.get("GPU", {}).get("dumpShaders", "(absent)")
    print(f"GPU.dumpShaders: {before} -> {now}")
    if now != want:
        print("THE WRITE DID NOT LAND - is the emulator running?")
        return 1
    d = r"C:\Users\3E30~1\AppData\Roaming\shadPS4\shader\dumps"
    n = len([x for x in os.listdir(d) if x.endswith(".spv")]) if os.path.isdir(d) else 0
    print(f"dump currently holds {n} .spv - compare after the next run to see what was added")
    return 0


if __name__ == "__main__":
    sys.exit(main())
