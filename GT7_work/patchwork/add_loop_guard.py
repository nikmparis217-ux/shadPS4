#!/usr/bin/env python3
"""Add an iteration cap to every loop in a SPIR-V assembly listing.

WHY THIS SHAPE OF EXPERIMENT
    The question is only "does this shader hang?", and it has to be answered without changing what
    the shader COMPUTES. An early `OpReturn` would answer nothing: the shader's results feed later
    draws, so starving them could produce a different hang and a "still crashes" result would be
    unattributable. A cap leaves every legitimate execution untouched - the binary search in this
    shader converges in about 32 iterations and the cap is 1,000,000 - while forcing any
    non-converging loop to end. So:
        crash disappears -> a loop here really did not terminate
        crash remains    -> this shader's loops are NOT the hang, and it is ruled out for good
    Both outcomes are informative, which is the whole point.

WHAT IS INSERTED, per loop
    header block:      %cnt = OpPhi %u32 %zero <preheader> %inc <continue>
    condition block:   %inc  = OpIAdd %u32 %cnt %one
                       %over = OpUGreaterThanEqual %bool %cnt %limit
                       %exit = OpLogicalOr %bool <original exit cond> %over
                       OpBranchConditional %exit <merge> <body>

    %inc is defined in the condition block and consumed by the header phi on the edge from the
    continue block. That is legal because the condition block dominates the continue block - every
    path back to the header runs through it. The original condition value is left ALONE, because in
    this shader it is also fed into a phi and reused on the next iteration.
"""

import re
import sys

# ⚠ ONE CAP CANNOT SERVE EVERY SHADER, which is why this is now an argument. The two loops under
# investigation have completely different legitimate trip counts, and BOTH bounds come from memory:
#   cs_ef4a0dc6:  for (i = mem[a]; i != mem[b]; ++i)  - terminates on !=, so if mem[b] < mem[a] it
#                 runs ~2^32 times. A legitimate range is small, so 65536 keeps it AND still bites.
#   cs_c3d5603f:  trips = (mem[16] + 63) >> 6         - mem[16] is a BYTE count rounded up to 64-byte
#                 units, so a legitimate 1 MB buffer is 16384 trips. A cap of 1000 cut that to 6% of
#                 its work, and because this shader WRITES memory a later dispatch reads back as
#                 buffer descriptors, the truncation surfaced as a misaligned-address assert
#                 elsewhere. That is a corruption dressed up as a result.
# Set the cap ABOVE the legitimate count and far BELOW the runaway one, per shader.
LIMIT = 1_000


def main(src_path: str, dst_path: str, limit: int | None = None) -> int:
    global LIMIT
    if limit is not None:
        LIMIT = limit
    with open(src_path, "r", encoding="utf-8") as f:
        lines = f.read().split("\n")

    # Highest %N in the module; new ids continue above it.
    next_id = max((int(m) for m in re.findall(r"%(\d+)\b", "\n".join(lines))), default=0) + 1

    def label_of(i: int) -> str | None:
        m = re.match(r"\s*(%\w+) = OpLabel\s*$", lines[i])
        return m.group(1) if m else None

    # Every loop, identified by its OpLoopMerge.
    loops = []
    for i, line in enumerate(lines):
        m = re.match(r"\s*OpLoopMerge (%\w+) (%\w+) (\w+)\s*$", line)
        if not m:
            continue
        merge, cont = m.group(1), m.group(2)
        # The header is the closest OpLabel above.
        header_idx = next(j for j in range(i, -1, -1) if label_of(j))
        loops.append({"merge_line": i, "merge": merge, "cont": cont, "header_idx": header_idx,
                      "header": label_of(header_idx)})

    print(f"loops found: {len(loops)}")
    if not loops:
        return 1

    # A constant for the cap, plus whichever of 0/1 the module lacks.
    have = set(re.findall(r"(%[\w]+) = OpConstant %u32_id", "\n".join(lines)))
    limit_id = f"%gtcap_{LIMIT}"
    new_consts = [f"{limit_id:>15} = OpConstant %u32_id {LIMIT}"]
    zero_id = "%u32_id_0" if "%u32_id_0" in have else None
    one_id = "%u32_id_1" if "%u32_id_1" in have else None
    if zero_id is None:
        zero_id = "%gtcap_zero"
        new_consts.append(f"{zero_id:>15} = OpConstant %u32_id 0")
    if one_id is None:
        one_id = "%gtcap_one"
        new_consts.append(f"{one_id:>15} = OpConstant %u32_id 1")

    edits = {}   # line index -> list of lines replacing it
    patched = 0
    for n, L in enumerate(loops):
        header, merge, cont = L["header"], L["merge"], L["cont"]

        # The preheader is the incoming label of an existing phi in the header that is NOT the
        # continue block. Taking it from the phi rather than by scanning predecessors keeps this
        # honest: it is the block the loop is actually entered from, as the module already states.
        preheader = None
        for j in range(L["header_idx"] + 1, L["merge_line"]):
            if " = OpPhi " in lines[j]:
                # OpPhi is "%result = OpPhi %TYPE (%value %label)+" - the type comes FIRST and is not
                # part of any pair. Pairing naively from token 0 marries the type to the first value
                # and yields a VALUE where a label is expected, which spirv-val catches as
                # "incoming basic block is not an OpLabel".
                toks = re.findall(r"%\w+", lines[j].split("OpPhi", 1)[1])
                pairs = [(toks[k], toks[k + 1]) for k in range(1, len(toks) - 1, 2)]
                for _val, lbl in pairs:
                    if lbl != cont:
                        preheader = lbl
                        break
            if preheader:
                break
        if preheader is None:
            print(f"  loop {n} ({header}): SKIPPED - no phi names a preheader, so the entry edge "
                  f"cannot be established without guessing")
            continue

        # The block that branches to the merge label is the one carrying the exit condition.
        cond_idx = None
        for j in range(L["merge_line"], len(lines)):
            m = re.match(r"\s*OpBranchConditional (%\w+) (%\w+) (%\w+)\s*$", lines[j])
            if m and merge in (m.group(2), m.group(3)):
                cond_idx = j
                cond_val, t_lbl, f_lbl = m.group(1), m.group(2), m.group(3)
                break
            if re.match(rf"\s*{re.escape(merge)} = OpLabel", lines[j]):
                break   # reached the merge without finding it
        if cond_idx is None:
            print(f"  loop {n} ({header}): SKIPPED - no conditional branch to {merge} found")
            continue

        cnt, inc, over, exitc = (f"%gtc{next_id + k}" for k in range(4))
        next_id += 4

        # header: the counter phi, inserted immediately before OpLoopMerge (phis must lead the block)
        edits[L["merge_line"]] = [
            f"{cnt:>15} = OpPhi %u32_id {zero_id} {preheader} {inc} {cont}",
            lines[L["merge_line"]],
        ]

        # condition block: count, compare, widen the exit condition
        exit_is_true_branch = (t_lbl == merge)
        if exit_is_true_branch:
            combined, other = exitc, f_lbl
            new_branch = f"               OpBranchConditional {exitc} {merge} {other}"
            combine_op = f"{exitc:>15} = OpLogicalOr %bool_id {cond_val} {over}"
        else:
            # The branch leaves on FALSE, so the cap has to be ANDed into the "keep going" value.
            combined, other = exitc, t_lbl
            new_branch = f"               OpBranchConditional {exitc} {other} {merge}"
            notover = f"%gtc{next_id}"
            next_id += 1
            combine_op = (f"{notover:>15} = OpULessThan %bool_id {cnt} {limit_id}\n"
                          f"{exitc:>15} = OpLogicalAnd %bool_id {cond_val} {notover}")

        block = [
            f"{inc:>15} = OpIAdd %u32_id {cnt} {one_id}",
        ]
        if exit_is_true_branch:
            block.append(f"{over:>15} = OpUGreaterThanEqual %bool_id {cnt} {limit_id}")
        block.extend(combine_op.split("\n"))
        block.append(new_branch)
        edits[cond_idx] = block
        patched += 1
        print(f"  loop {n}: header {header} cond-block-branch line {cond_idx + 1} "
              f"(exit on {'true' if exit_is_true_branch else 'false'}) -> capped")

    if patched == 0:
        print("nothing patched")
        return 1

    out = []
    for i, line in enumerate(lines):
        if i in edits:
            out.extend(edits[i])
        else:
            out.append(line)
        # Constants go right after the last existing u32 constant so they precede all uses.
        if re.match(r"\s*%u32_id_1 = OpConstant %u32_id 1\s*$", line):
            out.extend(new_consts)

    with open(dst_path, "w", encoding="utf-8") as f:
        f.write("\n".join(out))
    print(f"patched {patched} of {len(loops)} loops, cap = {LIMIT}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1], sys.argv[2],
                  int(sys.argv[3]) if len(sys.argv) > 3 else None))
