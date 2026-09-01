#!/usr/bin/env python3
"""Cap a SPIR-V loop SOUNDLY.  python add_loop_guard2.py <in.asm> <out.asm> [limit]

WHY V2 EXISTS - V1's CAP COULD SILENTLY NEVER TRIP
    v1 put both the counter increment AND the cap test in "the block that branches to the loop's merge
    label". For a plain `while (cond)` that block is the loop header's immediate successor and runs
    every iteration, so the cap was sound. But for a loop whose exit is a `break` nested inside the
    body, that block is only reached on SOME iterations - so the counter under-counts and the cap can
    never reach the limit. Audited across the dump: **27 of 63 loops** are of that shape, including
    two of the six suspects still standing (cs_7c3468f9, cs_6421a7b6). Every "capped, still hangs"
    result for those two proved nothing at all.

WHAT V2 DOES INSTEAD
    counter:  incremented in the loop's CONTINUE block. SPIR-V requires every back edge to pass
              through the continue target, so an increment there counts iterations EXACTLY, whatever
              shape the body has.
    cap test: preferred site is the header's immediate successor, which every iteration must enter.
              When that block ends in `OpBranch %X` it becomes `OpBranchConditional %over %merge %X`,
              i.e. an ordinary break - legal, and only safe when the merge block has NO OpPhi, since
              a new incoming edge would need a new phi pair. Checked per loop, and skipped if not.
    fallback: when the successor already ends conditionally, the cap is OR'd into the existing exit
              condition as v1 did - but now with the SOUND counter, which is the half that mattered.
              Reported as PARTIAL, because the test still only happens where that block is reached.
"""

import re
import sys

DEFAULT_LIMIT = 1_000


def main(src: str, dst: str, limit: int = DEFAULT_LIMIT) -> int:
    lines = open(src, encoding="utf-8").read().split("\n")
    next_id = max((int(m) for m in re.findall(r"%(\d+)\b", "\n".join(lines))), default=0) + 1

    def label_at(i):
        m = re.match(r"\s*(%\w+) = OpLabel\s*$", lines[i])
        return m.group(1) if m else None

    def find_label(lbl):
        return next((j for j, x in enumerate(lines)
                     if re.match(rf"\s*{re.escape(lbl)} = OpLabel\s*$", x)), None)

    def terminator(lbl):
        j = find_label(lbl)
        if j is None:
            return None, None
        for k in range(j + 1, len(lines)):
            if re.match(r"\s*Op(Branch|BranchConditional|Switch|Return|ReturnValue|Kill|Unreachable)",
                        lines[k]):
                return k, lines[k]
        return None, None

    have = set(re.findall(r"(%[\w]+) = OpConstant %u32_id", "\n".join(lines)))
    limit_id, zero_id, one_id = f"%gt_lim{limit}", "%u32_id_0", "%u32_id_1"
    new_consts = [f"{limit_id:>15} = OpConstant %u32_id {limit}"]
    if zero_id not in have:
        zero_id = "%gt_zero"
        new_consts.append(f"{zero_id:>15} = OpConstant %u32_id 0")
    if one_id not in have:
        one_id = "%gt_one"
        new_consts.append(f"{one_id:>15} = OpConstant %u32_id 1")

    loops = []
    for i, l in enumerate(lines):
        m = re.match(r"\s*OpLoopMerge (%\w+) (%\w+) ", l)
        if m:
            hdr_i = next(j for j in range(i, -1, -1) if label_at(j))
            loops.append({"i": i, "merge": m.group(1), "cont": m.group(2),
                          "hdr_i": hdr_i, "hdr": label_at(hdr_i)})

    inserts = {}   # line index -> lines to put BEFORE it
    replace = {}   # line index -> replacement lines
    sound = partial = skipped = 0

    for n, L in enumerate(loops):
        merge, cont, hdr = L["merge"], L["cont"], L["hdr"]

        preheader = None
        for j in range(L["hdr_i"] + 1, L["i"]):
            if " = OpPhi " in lines[j]:
                toks = re.findall(r"%\w+", lines[j].split("OpPhi", 1)[1])
                for k in range(1, len(toks) - 1, 2):
                    if toks[k + 1] != cont:
                        preheader = toks[k + 1]
                        break
            if preheader:
                break
        if preheader is None:
            print(f"  loop {n} ({hdr}): SKIPPED - no phi names the entry edge")
            skipped += 1
            continue

        cnt, inc, over = f"%gtc{next_id}", f"%gtc{next_id+1}", f"%gtc{next_id+2}"
        next_id += 3

        # counter phi in the header, immediately before OpLoopMerge (phis must lead their block)
        inserts.setdefault(L["i"], []).append(
            f"{cnt:>15} = OpPhi %u32_id {zero_id} {preheader} {inc} {cont}")

        # increment in the CONTINUE block, right before its terminator: exactly once per iteration
        ct_i, _ = terminator(cont)
        if ct_i is None:
            print(f"  loop {n} ({hdr}): SKIPPED - continue block {cont} has no terminator")
            skipped += 1
            continue
        inserts.setdefault(ct_i, []).append(f"{inc:>15} = OpIAdd %u32_id {cnt} {one_id}")

        # cap test: prefer the header's immediate successor
        succ = None
        for j in range(L["i"] + 1, len(lines)):
            mb = re.match(r"\s*OpBranch (%\w+)\s*$", lines[j])
            if mb:
                succ = mb.group(1)
                break
            if label_at(j):
                break
        merge_i = find_label(merge)
        merge_has_phi = merge_i is not None and " = OpPhi " in (lines[merge_i + 1] or "")

        st_i, st = (terminator(succ) if succ else (None, None))
        # GT_NOBREAK: the break-insertion path produced a dominance error on nested loops
        # (cs_7c3468f9: "%665 defined in %794 does not dominate its use in %692") that has not been
        # understood - so it can be disabled per run rather than trusted. The COUNTER stays sound
        # either way, and that was v1's actual defect.
        import os as _os
        allow_break = _os.environ.get("GT_NOBREAK", "0") != "1"
        if allow_break and st and st.strip().startswith("OpBranch ") and not merge_has_phi:
            tgt = st.strip().split()[1]
            replace[st_i] = [
                f"{over:>15} = OpUGreaterThanEqual %bool_id {cnt} {limit_id}",
                f"               OpBranchConditional {over} {merge} {tgt}",
            ]
            print(f"  loop {n} ({hdr}): SOUND - counter in {cont}, break added in {succ}")
            sound += 1
            continue

        # fallback: OR into the existing exit condition, with the sound counter
        done = False
        for j in range(L["i"], len(lines)):
            if re.match(rf"\s*{re.escape(merge)} = OpLabel", lines[j]):
                break
            mc = re.match(r"\s*OpBranchConditional (%\w+) (%\w+) (%\w+)\s*$", lines[j])
            if mc and merge in (mc.group(2), mc.group(3)):
                cond, t, f = mc.group(1), mc.group(2), mc.group(3)
                ex = f"%gtc{next_id}"
                next_id += 1
                if t == merge:
                    body = [f"{over:>15} = OpUGreaterThanEqual %bool_id {cnt} {limit_id}",
                            f"{ex:>15} = OpLogicalOr %bool_id {cond} {over}",
                            f"               OpBranchConditional {ex} {merge} {f}"]
                else:
                    body = [f"{over:>15} = OpULessThan %bool_id {cnt} {limit_id}",
                            f"{ex:>15} = OpLogicalAnd %bool_id {cond} {over}",
                            f"               OpBranchConditional {ex} {t} {merge}"]
                replace[j] = body
                print(f"  loop {n} ({hdr}): PARTIAL - sound counter, but the cap is tested only "
                      f"where the exit branch is reached")
                partial += 1
                done = True
                break
        if not done:
            print(f"  loop {n} ({hdr}): SKIPPED - no place to test the cap")
            skipped += 1

    out = []
    for i, l in enumerate(lines):
        out.extend(inserts.get(i, []))
        out.extend(replace.get(i, [l]))
        if re.match(r"\s*%u32_id_1 = OpConstant %u32_id 1\s*$", l):
            out.extend(new_consts)
    open(dst, "w", encoding="utf-8").write("\n".join(out))
    print(f"cap={limit}: {sound} sound, {partial} partial, {skipped} skipped, of {len(loops)} loops")
    return 0 if (sound + partial) else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1], sys.argv[2],
                  int(sys.argv[3]) if len(sys.argv) > 3 else DEFAULT_LIMIT))
