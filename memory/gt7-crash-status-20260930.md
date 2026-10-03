---
name: gt7-crash-status-20260930
description: "Crash list + remaining issues, updated 3 Oct 2026 ~12:30 by builder shadps4-lane-f9 at the user's request (first written 30 Sep by auditor gtnikos-e8): every crash reached so far (GT7 classes 1-13 with runs and state, the 11 fixed in main, one-offs, the old 1.00 line, where GoW / GoT / GTA V / My First Gran Turismo stop) and what is still open in the user's order (PRs, crashes, visuals, emulator-wide); live counts stay in CRASH_MAP.md"
metadata:
  node_type: memory
  type: project
  originSessionId: 93d56559-da04-4f23-82f0-dd25eada7a18
  modified: 2026-10-03T09:14:45.471Z
---

# Crash list and remaining issues (updated 3 Oct 2026, ~12:30)

First written 30 Sep ~21:30 by the auditor gtnikos-e8 ("i want all this result saved somewhere in your md that you
could review at any time and send it to the other chat"). Rewritten 3 Oct by the builder shadps4-lane-f9 ("ok update
the list and make the list of the remaining isues"). The 30 Sep text stays in the history of branch `claude`
(bb901923) and as a draft in `C:\Users\Νίκος\.claude\plans\gather-every-single-error-jaunty-hamster.md`.

**Sources, all read-only on 3 Oct:** `GT7_upstream\CRASH_MAP.md` (through test40dma_gt7_1),
`GT7_upstream\IMAGE_PROBLEMS_MAP.md`, the READMEs of `C:\shadps4-gow`, `-got`, `-gtav` and `-mfgt`, the TEST2 audits
`C:\shadps4-gow\logs\gow_test2_runs_audit.txt` and `games_test2_runs_audit.txt`, [[shadps4-fix-candidates]], the
public GitHub API at ~12:15 and `git ls-remote` (main 8e23388a).

**Why:** one place that answers "which crashes did we reach, which are still open, what is next for each".
**How to apply:** a snapshot. Before quoting a run count, check CRASH_MAP.md (the live catalog); check PR states
through the API. The plan is the user's; this is the list it starts from.

## 1. Every crash reached so far

### GT7 1.71, current line (upstream main + our stack, since 25 Sep): 13 classes still open

| # | Crash | Runs | Where | State on 3 Oct |
|---|---|---|---|---|
| 1 | GPU fault, write to address 0 ("WIDTH CT Violation", nvlddmkm 13 + 153) | 17 | race, pause menu, after a failed race | open |
| 2 | GPU fault in a 64 KiB hole between two 8 MiB blocks (nvlddmkm 153) | 17, +10 with the same symptom | before the race: PlayGo, Buddy screens | open |
| 3 | PM4 type 0 (`liverpool.cpp:249`) | 15 (+6 on the old line) | anywhere | open |
| 4 | Protect address 0 (`page_manager.cpp:141`, then `address_space.cpp:552`) | 9 | before the race | in PR #5218, not proven yet |
| 5 | game thread crash A, eboot+0x302a83b (Job thread) | 5 | PlayGo top menu | open |
| 6 | game thread crash B, eboot+0x18eaf37 (WorkT) | 7 | in a race, 9-16 s after a start or restart | open |
| 7 | unknown tile mode 27 / 29 (`tiling.cpp:65`) | 4 (last 29 Sep) | menus, race | in PR #5218, not proven yet |
| 8 | `image.cpp:259` subresource index | 2 | race, menus | open; its log line exists since TEST24, not hit since |
| 9 | `pixel_format.h:359` Bc6 + SnormNz | 1 (test25_4) | deep in a race | open; no fix in the run build since TEST37 |
| 10 | no gamepad: crash after the first boot screen | 6 (+3 in TEST6) | boot | open, low priority (only without "Gamepad registered for slot 0") |
| 11 | game thread crash C, libc.prx+0x1cb5e (defTS) | 1 | PlayGo top menu | open |
| 12 | GPU fault just past a 192 MiB staging buffer | 1 (test35_1) | 80 s into a race | open |
| 13 | SurfaceFormat / ComponentSwizzle assert (`liverpool_to_vk.cpp:788` / `:428`) | 3 (+7 before TEST22) | PlayGo menus | in PR #5218: 3 of the 4 TEST37 runs (no guard at all), 0 of the 5 runs with the pass |

**Since the 30 Sep version** (9 runs: TEST37 r1-r4, TEST39 r1-r2, TEST40 r1-r2, test40dma_gt7_1): #13 three times, #3
twice, #6 twice, #1 once, #5 once. No new kind of crash.

### Fixed in upstream main: 11

| Error | Fixed by |
|---|---|
| `info.h:183` PushUd (17 user-data registers in one draw) | #5181, merged 29 Sep (8c91be2b) |
| 0xC0000409 compiling fs 0xf10530e6 (undefined `sample_index`) | #5131 (e0cd957a) |
| garbage S#: MipFilter unreachable, MaxAniso unreachable, custom border colour AV (3 errors) | #5137, merged 29 Sep (1a0f5be8) |
| `hull_shader_transform.cpp:479` "patch addr non imm" | #5169 (4c7b287f) |
| AV on a guest write to the last dword of a page | #5150 (c01ae7e6) |
| LDS `Map` without `Commit` stall / device lost (old line) | #5070, merged 23 Sep (bc028b7c) |
| `image_info.cpp:184` block-compressed assert + the mip detiling | **#5196, merged 2 Oct 01:16 (squash 7e778987), new since 30 Sep** |
| V_INTERP_MOV_F32 assert (fs 0x74f5f10c) | #5087 (not ours), merged 25 Sep |
| missing V_MIN_F64 / V_TRUNC_F64 | #5125 / #5127 (not ours), merged 26 Sep |

Nine of the eleven by our PRs. #5126 (compute FLOAT_MODE) and #5114 (F64 literal) fixed no GT7 crash.

**Covered by our open PRs:** #5155 (device lost at SDRSettingRoot with a warm cache, `vk_presenter.cpp:1113`) and
#5218 (#4, #7 and #13 above).

### Seen once or twice, never classified (no change since 30 Sep)
- a guest wild jump, then the emulator's crash handler crashed decoding it (TEST17d r4, TEST18 r3);
- a menu GPU reset with a 1.56 GiB image range and an arena migration (TEST17 r1);
- integer divide-by-zero 0xC0000094 inside the NVIDIA driver (TEST15 r5);
- privileged instruction 0xC0000096 in game code (TEST4 r4);
- `image_info.cpp:300` assert (clean171_13);
- a host access violation on a Job thread (TEST3); a guest fault the user parked (TEST12); a hang at load, exit 0
  (TEST17d r1);
- 8 endings whose crash line the async log lost (TEST15 r2/r6, TEST16 r3, TEST17 r5, TEST17b r1, TEST17c r2, TEST21M
  r2/r4); three of them show class 2's precursor.

### Old research line (fork, GT7 1.00, 2-24 Sep): parked, never seen on the current line
- crash D: a guest AV on the Rendr thread in the game's text layout (runs 354, 355);
- Single Race setup: 7 guest crashes at one instruction on the "PCL Event" timer thread, a hang (292) and a silent
  death (293), runs 286-294;
- the "PCL Event" thread dies when the lab's fault-loop breaker refuses a second fault streak (349b, 351b, 357; lab
  code);
- run 358: the guest stopped for 27 minutes entering the post-race Replay (no [gpuwait]);
- recompiler: `resource_patching_pass.cpp:807` PatchImageSampleArgs (347), `:471` thread-ID buffer addressing outside
  compute (344), a GPU timeout on one compute shader (343);
- at least 10 guest wild jumps; clean01's AV on the save-data thread; a host AV at ~298 s (10 Sep);
- fixed only on the fork, upstream never checked: an over-unmap at the logo, the 182/195-compile device-loss wall, a
  GC use-after-free, torn-descriptor asserts, VRAM exhaustion, readback-switch asserts, a stale shader-walker crash.

### The other games (each has its own folder and README)

| Game | Where every recent run stops | Runs |
|---|---|---|
| God of War (CUSA07411) | with our three GoW fixes: a GPU hang, device lost (nvlddmkm 153), as in GOW3 on 27 Sep, ~27 s after cs 0x38c7b95b first compiled. Main without our DS_ORDERED_COUNT stops ~50 shaders in (TEST3, TEST19B) | TEST1 r1-r3, TEST2 r1-r2 |
| Ghost of Tsushima (CUSA13323) | an access violation inside NVIDIA's driver (nvoglv64.dll, `signals.cpp:144`) on the GPU thread, compiling the pipeline right after cs 0x14906b6a, whose SPIR-V is invalid (f64 operations without the Float64 capability; spirv-val rejects it) | TEST1, TEST2 r1-r3 |
| GTA V (CUSA00411) | `hull_shader_transform.cpp:395` assert on hs 0xf74f71e4930a1c25 | TEST1 r3-r5, TEST2 r1-r2 |
| My First Gran Turismo (CUSA49696) | "Invalid PM4 type 0" in the compute queue (`liverpool.cpp:917`); the same on plain main (upstream #5204, open) | one outside run with #5218, 3 Oct |

## 2. Remaining issues, in the user's order

User, 3 Oct: "after we find why every crash would happen and fix the problem from the root, we should focus on visual
fixes since no game should fall under any error crash". A live PR comes before everything (lane rule). Until Sun 4 Oct
12:00 only changes the devs ask for on #5218 / #5155 (budget hold).

### 2a. Open PRs
- **#5218** "shader_recompiler: Skip images and samplers behind untaken branches": open, head 91a806e5, CI 10 green + 1
  skipped, mergeable. raphaelthegreat's request of 2 Oct (the pass in its own file) is done; no review since. Open
  point: the PR's own head has never run in a game (TEST39 / TEST40 carry the version before the review); port
  `GtInsertGuardChecks` before any GT_GUARDCHECK build on it.
- **#5155** "video_core: Use each preloaded permutation's own flattened user data": open, head 7dba76ce, no review or
  comment. One failed check: linux-sdl at "Add LLVM repository" (a network failure, not the PR); GitHub shows the PR
  as "unstable" until that job runs again.

### 2b. Crashes: root cause and root fix first

GT7, in CRASH_MAP's suggested order. Each "next" is a log line or a test; CRASH_MAP has the full "Needed in the log".

| Order | # | Lead | Next |
|---|---|---|---|
| 0 | 13, 4, 7 | all three go through images #0 / #1 of fs 0x2a265dff, which the pass binds null at every bind; 0 wrong "dead" verdicts in 3 check runs (224, 449 and 189 modules with a dead slot) | more runs: #13 has not come back in 5 runs; #4 and #7 are rarer and need more |
| 1 | 2 | a zero-size texture-cache track or untrack at 0x3f80000000, 0-1 frames before the fault in all 17 logs with the address, in no other ending | one log line at that call: which function, the image, the Vulkan memory behind it |
| 2 | 4 | the image at address 0 is texture binding 0 of fs 0x2a265dff | covered by #5218 if more runs agree |
| 3 | 1 | a copy "source layers 8, destination layers 48" 1-2 frames before it in all 11 logs with a report, in no other ending; suspect: CopyImage / ResolveImage take the extent from the source with no clamp | log both images and the copy regions at that copy |
| 4 | 7 | image #1 of fs 0x2a265dff holds floats read as a T# | covered by #5218 if more runs agree |
| 5 | 3 | lead: main never reads INDIRECT_BUFFER's chain bit (`pm4_cmds.h:896`); test35_3 and test40_2 both died ~100 s into a first pause with the same last draw | a [test] log at the stop: the buffer, the offset of the zero dword, the last ~16 packet headers. My First Gran Turismo is a second test case |
| 5 | 6, 5, 11 | the game's own code, the same instruction every time | the address touched, read or write, the registers, the thread's last library calls |
| 6 | 12 | one run; a 170.6 MiB request rounds to exactly the 192 MiB buffer | a log line per dedicated staging request |
| – | 8, 9, 10 | #8: its log line waits for a hit; #9: needs a run that reaches the draw; #10: a missing pad should not crash the game | later |

Builder's suggestion on 3 Oct (not a decision): #1 and #2 first, then GTA V's assert and GoT's f64 shader, since each
of those two stops a whole game early.

Other games:
- **GTA V:** read the `hull_shader_transform.cpp:395` assert and what hs 0xf74f71e4930a1c25 does (no build).
- **Ghost of Tsushima:** cs 0x14906b6a: check the state of the "uses_fp64" fix our notes name, and whether main has
  it.
- **God of War:** the hang after cs 0x38c7b95b; next test = skip the ordered wait, keep the atomic. The three GoW fixes
  are not ready for a PR (2 Oct check) and need a cache-version bump on a rebase.
- **My First Gran Turismo:** goes with GT7 #3.

### 2c. Visuals, after the crashes (GT7: `IMAGE_PROBLEMS_MAP.md`)

| Row | What you see | Cause | Next |
|---|---|---|---|
| 1 | road, terrain, buildings missing (black ground) | readbacks off: the CPU reads zeros where the GPU wrote | run (a), readbacks on |
| 2 | distant road and terrain, green / yellow strips | not found | after row 1 draws |
| 3 | red minimap | not found | run (b) done 3 Oct: still red; run (a) open |
| 4 | wrong material values | DMA off: constant reads the flatten pass cannot place load dword 0 | run (b) done 3 Oct: no visible change, lower FPS; the defect is real but not behind the faults seen; low priority ([[shadps4-srt-walker-dword0]]) |
| 5 | whitewash | NaN from cs 0xda05e7f8 (lab) | does it happen on 1.71 |
| 6 | corrupted far mips | preload built every permutation from one snapshot | fixed in our builds by the preload fix, PR #5155 |
| 7 | wrong letters | two texture-cache paths miss CPU writes | the fix, then count the reports; re-read on main first (#5219 reworked the texture cache) |

Not mapped yet: the washed-out left half, black stripes, a flat grey mirror. The user's look at the music rally on
3 Oct: green shapes over the trees, black ground, a mirror-like road, red minimap.

### 2d. Emulator-wide, not crashes
- "BindBuffers: Clamped size" (~550 lines a frame, 98 % of the renderer errors): a legal "no limit" V#, a u32 size and
  an ERROR level. Plan: TEST41 measurement, then fix A or B ([[shadps4-unbounded-vsharp-clamp]]).
- SRT-walker reads that become dword 0 with DMA off: real, low priority since the 3 Oct test; the fix should flatten
  the reads (push the load through the Phi), not lean on DMA.
- The pipeline cache's WarmUp check ignores the DMA setting (it compares only `Shader::Profile`), so a cached run can
  reuse SPIR-V built for the other setting.
- 17 missing 64-bit V_CMP opcodes (proof: a GPU regression test in `tests/gcn`, no game uses them); 20 Neo-mode 16-bit
  compares (none in our logs).
- Closed #4996's leftovers, not in main: the coroutine-frame leak fix, the loop-wrap guard, a ReadLane subgroup mask.
- Text input: main has the IME dialog (PR #3973); a run that reaches GT7's name prompt shows whether it works.
- Not ours: PR #5192 (mavethee), 10 findings and a ~170-line fix plan kept for later ([[shadps4-pr5192-review]]).

### What closed since 30 Sep
- #5196 merged (2 Oct); #5219 (raphaelthegreat's texture cache, carrying #5196's code) is in main 8e23388a.
- The T# check and SnormNz left the run build on 30 Sep (TEST37). #5218's pass now does the T# check's job; class 9
  has no fix in the build.
- The 30 Sep version's pending CRASH_MAP correction (test9_2 belongs to the TEST9 border-colour crashes #5137 fixed)
  is in CRASH_MAP.

Related: [[gt7-shadps4-lane]], [[gt7-shadps4-auditor-handoff]], [[shadps4-fix-candidates]], [[gt7-image-problems-map]],
[[shadps4-gpu-path-map]].
