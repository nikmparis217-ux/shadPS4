---
name: feedback-isa-fix-needs-a-game-that-uses-it
description: "Before an ISA-derived fix goes upstream, scan the game's shader dumps for the pattern — PR #5114 (F64 literal) fixed nothing in GT7 (0 uses in 267 shaders) and a maintainer found GTA V got worse"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e6748b20-5abc-4f48-99a6-a882a2f00f56
  modified: 2026-10-02T22:46:49.849Z
---

PR #5114 (F64 literal = high dword) was correct by the ISA, by LLVM and by a GPU test. It was found
by READING the ISA while implementing V_TRUNC_F64/V_MIN_F64, not from a bad value in a game. Its
body still said it "fixes incorrect values". Then:
- DanielSvoboda reported GTA V much brighter with it.
- StevenMiller123 asked "what game are you trying to fix?".

`scratchpad/f64lit_scan.exe` (GCN2 length walker over `*.bin` dumps; 0 desyncs = the literal
detection is right) found **0 F64 literals in all 267 GT7 1.71 shaders**. So the PR changed nothing
in GT7, the only game we test.

**27 Sep, same scanner on the TEST19b dumps** (`C:\Users\3E30~1\AppData\Local\Temp\claude\c--GTNikos\69673bdb-6869-4891-9c3e-5db85d30824f\scratchpad\f64lit_scan.exe <dump dir>`):
GoT 104 shaders / 36584 instructions, 0 desyncs, **0 F64 literals** (only V_CVT_F32_F64 + V_RCP_F64 without a literal, both
in the crashing cs 0x14906b6a); GoW 50 shaders, no F64 VOP1/VOPC at all. User's decision: **«leave 5114 for now. if we find
literal shaders we will update it so we have actual proof of the work»** — #5114 stays parked (fixed commit 75f39d66 unpushed)
until a scan finds one. Rescan GoT's dumps whenever it gets further (the uses_fp64 fix is what unblocks it).

**3 Oct 2026, the 17 64-bit integer compares main does not translate (no game of ours uses them):** the user chose
the proof for this case: «since we cant test this with a game we will make a regression test for this specifically» =
GPU tests in main's `tests/gcn` that fail without the fix and pass with it (plan in [[shadps4-gpu-path-map]]). Adding
missing cases differs from #5114: no game that runs today can change.

**Why:** a maintainer judges a fix by a game it improves. An unexercised ISA-correct change that
moves another game's pixels reads as a regression with no upside.

**How to apply:** before proposing a fix PR, scan the game's shader dumps (runs with
`dump_shaders` true) for the exact encoding or opcode the fix touches, and record the count. If
it is 0, say in the PR that it is spec-driven with no known game case, or hold it. Related:
[[shadps4-upstream-no-shader-dumps]], [[feedback-shadps4-pr-quality-method]].
