---
name: shadps4-fix-candidates
description: "NOT the plan: the 3 Oct 2026 list of known fix candidates (GT7 crash classes with their leads, emulator-wide items, other games' first stops, open PRs) with the next step that needs no build; knowledge for when the user plans the next fixes"
metadata:
  node_type: memory
  type: project
  originSessionId: 69aee205-f92c-44e7-8367-5be64450ea3e
  modified: 2026-10-02T22:54:45.729Z
---

User, 3 Oct 2026: "this is not the plan but we can save it as a future knowledge for planing". The user decides the
plan; this only lists what is known, so planning starts from facts instead of a new search. Counts are from
`C:\shadps4-gt7\GT7_upstream\CRASH_MAP.md` as of TEST40 r2 (2 Oct); check it for newer runs. Step numbers refer to
[[shadps4-gpu-path-map]].

### GT7 (CRASH_MAP number, runs, lead, next step without a build)
- **#1 GPU fault, write to address 0** (17): an image copy "source layers 8, destination layers 48" comes 1-2 frames
  before it in all 11 logs with a driver report, in no other ending. Next: read main's image-copy path for what a
  layer-count mismatch does.
- **#2 GPU fault in a 64 KiB hole between two 8 MiB blocks** (17 with the address, +10 same symptom): a page_manager
  warning "Tracking memory region 0x3f80000000 - 0x3f80000000" (a zero-size texture-cache track or untrack) comes 0-1
  frames before it in all 17, in no other ending; the page belongs to no Vulkan allocation. Next: find who issues a
  zero-size track and what it does to that memory.
- **#3 PM4 type 0** (15; step 4): a zero dword read as a packet header. Lead: main never reads INDIRECT_BUFFER's
  `chain` bit (pm4_cmds.h:896; liverpool.cpp:794-805 GFX, :928-938 ASC). Next needs a build: a [test] log at the stop
  (buffer, offset of the zero dword, last ~16 packets with raw headers).
- **#4 Protect address 0 (9), #7 Unknown tile mode (4), #13 SurfaceFormat / ComponentSwizzle (3, +7 before TEST22)**:
  all on the unused image slots of fs 0x2a265dff; TEST39 (dead-slot pass running) bound images #0 and #1 null at every
  bind, 0 of #13 in 2 runs. That is PR #5218's subject: waits for its review.
- **#5 / #6 / #11 game-thread crashes** (5 / 6 / 1): the game's own code at eboot+0x302a83b (Job), eboot+0x18eaf37
  (WorkT, ~9-10 s of race time), libc.prx+0x1cb5e (defTS); the same instruction every time. Next: what the emulator
  handed the game just before (log side).
- Smaller: #8 subresource index (2), #9 Bc6 + SnormNz (1, no run has reached that draw since test25_4), #12 GPU fault
  past a 192 MiB staging buffer (1), #10 no gamepad (6, a run without "Gamepad registered for slot 0" is void).
- **"Clamped size"** (not a crash; ~550 lines a frame): u32 `GetSize` overflow + an ERROR for a legal "no limit" V#.
  Plan ready in [[shadps4-unbounded-vsharp-clamp]] (TEST41 measurement, then fix A or B).

### The emulator in general
- **17 missing 64-bit integer compares**: 17 `case` lines on the existing `V_CMP_U64` helper + a GPU regression test
  in `tests/gcn` (user's choice of proof, no game uses them); plan in [[shadps4-gpu-path-map]]. Needs a build.
- **20 16-bit compares (PS4 Pro / Neo mode)**: main translates 0, none in our 302 logs; no helper to reuse; later, a
  separate PR.
- **GoT stops in step 15**: NVIDIA's driver crashes compiling cs 0x14906b6a, whose SPIR-V is invalid (it uses
  V_CVT_F32_F64 + V_RCP_F64; `C:\shadps4-got\README.md:27`); our notes name a "uses_fp64" fix as what unblocks it
  ([[feedback-isa-fix-needs-a-game-that-uses-it]]). Next: check that fix's state and whether main already has it.
- **GTA V stops early**: hull-shader assert `hull_shader_transform.cpp:395` (`C:\shadps4-gtav\README.md:27`). Next:
  read the assert and what GTA V's hull shader does.
- **GoW hangs the GPU ~27 s after DS_ORDERED_COUNT compiles** (our local branch translates it): next test (build) =
  skip the ordered wait, keep the atomic ([[gow-fixes-for-pr]]). GoW also sends "SetQueueReg vqid 4 reg 0xb" (579 in
  two runs), skipped by main; unlikely to matter.
- **Open PRs come first whenever a dev asks**: #5218 (resource guards; its code has never run, port
  `GtInsertGuardChecks` before any GT_GUARDCHECK build) and #5155 (device lost at SDRSettingRoot with a warm cache).

Builder's suggestion on 3 Oct (not a decision): research #1 and #2 first (the two biggest GT7 killers, each with a
precursor seen in every log), then GTA V's assert and GoT's fp64 shader (each stops a whole game early).

**Why:** the user plans the next fixes for GT7 and the emulator and wants the known candidates kept.
**How to apply:** when the user starts planning, offer this list (re-check CRASH_MAP counts and the PR states first);
never present it as the plan.

Related: [[gt7-shadps4-lane]], [[gt7-crash-status-20260930]], [[shadps4-gpu-path-map]].
