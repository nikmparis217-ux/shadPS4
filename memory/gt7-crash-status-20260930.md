---
name: gt7-crash-status-20260930
description: "Full GT7 1.71 crash status on shadPS4, 30 Sep 2026 ~21:30 (auditor gtnikos-e8, at the user's request): PR #5196 state, fixes applied but not polished, every open crash class with its lead and the log line it needs, one-off endings, the old research line; leaves out errors fixed in main or covered by #5155/#5196"
metadata:
  node_type: memory
  type: project
  originSessionId: 93d56559-da04-4f23-82f0-dd25eada7a18
  modified: 2026-09-30T18:39:10.500Z
---

A dated snapshot the user asked for on 30 Sep ~21:30 ("i want all this result saved somewhere in your md that you
could review at any time and send it to the other chat"). Sent to the builder as a pointer.

**Why:** one place that answers "which GT7 crashes are still ours, what is half-done, and where does #5196 stand".
**How to apply:** it is a snapshot. Run counts and PR state move on. Before quoting a number, check `CRASH_MAP.md`
(the live class catalog) and the PR through the API. Related: [[gt7-shadps4-lane]], [[gt7-shadps4-auditor-handoff]].

**Sources.** Everything was read-only:
- `GT7_upstream\CRASH_MAP.md` (30 Sep 19:19)
- the 29 run audits `logs\*audit*.txt` (TEST21M-TEST36)
- `GT7_upstream\HANDOFF.md` (with the 21:05 update by builder gtnikos-02) and `superseded\*.md`
- the other lane documents (`README.md`, `REPORT_PR5165_PR5166.md`, `GT7_171_RUN348/350.md`, `IMAGE_PROBLEMS_MAP.md`)
- the memory [[gt7-shadps4-lane]] (all 2629 lines)
- `git show claude:CLAUDE_MEMORY.md`
- git in the shared ref store (`--no-optional-locks`)
- the public GitHub API

**Verification.**
- PR #5196 read live about 21:10. CI 10/10 is from the builder's 21:05 note.
- origin/main is still 2338a06f, from the builder's 20:57 fetch and the API.
- The four #5196 commits of the TEST36 stack give exactly the PR's six files.
- test9_2 was checked against its archived log.

---

**Left out, as the user asked** (named in the appendix):
- 10 errors already fixed in upstream main: 8 by our merged PRs (#5070, #5131, #5137, #5150, #5169, #5181) and 2 by
  other people's (#5087; #5125 and #5127).
- 2 covered by our open PRs: #5155 (the warm-cache device lost at SDRSettingRoot) and #5196 (the image_info.cpp:184
  block-compressed assert and the mip detiling).

## 1. PR #5196 (state at ~21:10)
- **Open since 30 Sep 20:36 local (17:36:30Z):** 1 commit, 6 files, +54/−41. Head `mine/tiled-mip-layout` 4697d56c
  = origin/main 2338a06f + 1 commit. CI is 10/10 green and the PR is mergeable. Main hasn't moved.
- **No review has started:** 0 reviews, 0 comments, 0 review comments, no reviewer requested; updated_at =
  created_at.
- **What backs it:**
  - the addrlib checker: 333/333 cases, against 0/333 for main;
  - the GPU test: 0 of 387 cases wrong, against 342 for main (73 of those are the assert in UpdateSize);
  - the TEST34 dumps of GT7's 16 BC7 textures;
  - TEST36 run 1, with no regression.
- **The thin spot:** TEST36 has only one run. Class 12 was seen once (test35_1), and one of its two suspects, 0ca8528f
  (the thick-array slice count), is part of #5196. More TEST36 runs are the cheapest check.
- **It does not fix class 7.** It only moves that UNREACHABLE from tiling.cpp:65 to :66.
- **#5155:** no reviews or comments since 27 Sep, CI green, no conflicts with main (head e62bfbc7 = the fix + a
  GitHub "Update branch" merge of 2338a06f).

## 2. Fixes applied but not polished

| Fix | In the run build | What it stops | Proof so far | Missing before a PR |
|---|---|---|---|---|
| T# format/swizzle check (d833bab4; earlier 103b0976 → 25e63680 → 175fa0c4 → cad636ac) | since TEST22 | the SurfaceFormat assert (liverpool_to_vk.cpp:788/792: data_format 19/9, 44/0) and the ComponentSwizzle unreachable (:428), ~8 runs from TEST10 to TEST21M | neither has happened since TEST22 | It is a guard: it doesn't log which descriptors trip it, or whether they are garbage or real formats missing from the table. It still lets a T# at address 0 through, because `IsValidGpuMapping` (memory.h:208) only tests addr + size < 1 TiB and the check calls it with size 0; that is the class 4 lead. It never tests the tiling index, a 5-bit field whose values 27-30 have no TileMode (class 7). |
| SnormNz "no conversion" (9dce3330; earlier 05d66732 → 3bc09423 → 791ebf03) | since TEST28 | class 9: pixel_format.h:359 MapNumberConversion, Bc6 + SnormNz, 1 run (test25_4) | none: no run has reached that draw since | A run that reaches it, whose log shows "Rejecting invalid T# … num_format=6", and which format hit it. |

**Not in the run build:**
- **Dropped when TEST19 removed all T# guards.** Neither was ever shown to change a run:
  - 6dbece23 / 494a78d1 rejected a T# with an undefined tile mode (class 7);
  - 9fb8d553 / 5dc75198 rejected a T# whose image size is zero. Class 2's precursor is a zero-size image track.
- **Old research line** (fork, GT7 1.00): about 30 fixes were never ported to main, in the pipeline cache, shader
  recompiler, texture cache and command processing. None is in the run build, and none is tied to a crash on the
  current line.
  - 4720205e (fences complete in order) doesn't apply, because main has no deferred fences.
  - Closed #4996 still has four things missing from main: the coroutine-frame leak fix, the loop-wrap guard, 17 64-bit
    compare opcodes and a ReadLane subgroup mask.
- **God of War (paused):** tsharp-dw1-mask, tg-size-sgpr and ds-ordered-count. They are local, sit on old main 8151ee25,
  and need a rebase and a cache-version bump to 7.

## 3. Errors left to look into (current line since 25 Sep: upstream main + our stack, GT7 1.71)

The table is in CRASH_MAP's suggested order.

| # | Crash | Runs | Where | Lead | Next |
|---|---|---|---|---|---|
| 2 | GPU fault in a 64 KiB hole between two 8 MiB driver blocks (device lost, nvlddmkm 153) | 27: 17 with the address, 10 with the same symptom; 3 of the 7 TEST35 runs | before the race: PlayGo, Buddy screens | A zero-size texture-cache track or untrack (TrackImage or UntrackImageTail) comes 0.05-0.10 s before it in all 17 logs with the address, and in no other ending. #5193 didn't move it. | One log line at that call, naming the image and the Vulkan memory behind it. |
| 4 | Protect at address 0 (page_manager.cpp:141, then the address_space.cpp:552 assert) | 9 | before the race | Texture binding 0 of fs 0x2a265dff has base 0. Possibly a slot the draw never reads. | The path that creates the image, and the raw T#. |
| 1 | GPU fault writing to address 0 ("WIDTH CT Violation", nvlddmkm 13 + 153) | 16 | in the race, the pause menu, after a failed race | See below. | Both images and the copy regions at that copy. Optionally one GT_GPU_CHECKPOINTS=1 run. |
| 7 | unknown tile mode 27/29 (tiling.cpp:65) | 4 (last 29 Sep) | menus, race | Image #1 of the same fs 0x2a265dff holds floats read as a T#. | Finishing the T# check covers it. |
| 3 | PM4 type 0 (liverpool.cpp:249) | 13, plus 6 on the old line | anywhere | Old-line dumps show the command buffer's memory rewritten 57-107 ms after the submit, while the parser read it. | The parser position, the last packet headers, and whether the range was written after the submit. |
| 6 | game-thread crash B (WorkT, access violation at one fixed instruction) | 5 | 9.0-10.4 s after a race start or restart | It comes 9-10 s after a race start, so it is the easiest of the three to catch. | The address touched, read or write, the registers, and the last library calls. |
| 5 | game-thread crash A (Job thread) | 4 | PlayGo top menu | The same instruction every time. | As #6. |
| 11 | game-thread crash C (libc, defTS) | 1 (test32_1) | PlayGo top menu, at the same point as #5 | – | As #6. |
| 12 | GPU fault just past a 192 MiB "StagingBufferPool:Dedicated" buffer | 1 (test35_1) | 80 s into a race | Suspects: 0ca8528f (in #5196) or #5193 (in main). It didn't come back in test36_1. | A log line for each dedicated staging request: size, buffer size, what it is for. |
| 8 | image.cpp:259 subresource index assert | 2 (test17c_3, test23_2) | race, menus | Both runs first tracked a "not fully GPU mapped" range, like #4. | A log line has existed since TEST24; not hit since. |
| 10 | no gamepad: a crash after the first boot screen | 6, plus 3 in TEST6 (at the time blamed on the copied save) | boot | The trigger is the environment, but a PS4 game shouldn't crash without a pad. | Later. |

**Class 1's lead:** an 8→48 layer copy is in all 12 class-1 logs still on disk, 1-2 frames before the fault in the 10
that have a report. It is in none of the 17 races that ended some other way. The suspect is unproven: CopyImage and
ResolveImage take the copy size from the source with no clamp to the destination.

Class 9 is in section 2.

**Seen once or twice, never classified:**
- a guest wild jump, after which the emulator's own crash handler crashed while decoding it (TEST17d r4, TEST18 r3);
- a menu GPU reset with a 1.56 GiB image range and an arena migration (TEST17 r1);
- an integer divide-by-zero (0xC0000094) inside the NVIDIA driver (TEST15 r5);
- a privileged instruction (0xC0000096) in game code (TEST4 r4);
- an image_info.cpp:300 assert (clean171_13);
- a host access violation on a Job thread (TEST3);
- a guest fault the user parked (TEST12);
- a hang at load, exit 0 (TEST17d r1);
- 8 endings whose crash line the async log lost: TEST15 r2/r6, TEST16 r3, TEST17 r5, TEST17b r1, TEST17c r2, TEST21M
  r2/r4. Three of them (TEST15 r2/r6, TEST16 r3) show class 2's precursor.

## 4. Old research line (fork, GT7 1.00, 2-24 Sep): parked, not seen on the current line
- **Crash D:** a guest access violation on the Rendr thread in the game's text layout (runs 354, 355), after a
  used-car purchase with seven Collector level-ups. The font HLE checked clean, both by reading and with the fontwatch
  observer.
- **Single Race setup:** 7 guest crashes at one instruction on the "PCL Event" timer thread, plus a hang (292) and a
  silent death (293), in runs 286-294. A pointer's high dword was garbage, written on the CPU side. The next step then
  was a hardware watchpoint.
- **"PCL Event" thread death** when our lab fault-loop breaker refuses a second fault streak under precise readbacks
  (349b, 351b, 357). This is lab code.
- **Run 358:** stopped for 27 minutes entering the post-race Replay and never recovered. The guest itself stopped:
  there was no [gpuwait].
  - The 28-100 s GPU waits of runs 310 and 316 recovered on their own, so they did not end a run.
- **Recompiler:**
  - resource_patching_pass.cpp:807 PatchImageSampleArgs (run 347; the user said leave it);
  - resource_patching_pass.cpp:471, thread-ID buffer addressing outside compute (run 344);
  - a GPU timeout on one compute shader (run 343).
- **Other:**
  - at least 10 guest wild jumps, including run 260 with precise readbacks from boot;
  - clean01 (1.00 on plain upstream): an access violation at the top menu on the save-data thread, parked because the
    save had changed;
  - a host access violation at ~298 s (10 Sep).
- **Fixed only on the fork; upstream was never checked:**
  - an over-unmap at the logo;
  - the 182/195-compile device-loss wall;
  - a GC use-after-free;
  - torn-descriptor asserts;
  - VRAM exhaustion;
  - readback-switch asserts;
  - a stale shader-walker crash.

## 5. Next, in the agreed order
1. #5196's review when it comes. A code change means TEST37 = TEST36 + that commit, rerunning the checker and the GPU
   test, and a push only on the user's word.
2. More TEST36 runs, which also check class 12.
3. Finish the T# check (address 0 for #4, the tiling index for #7) and prove SnormNz, each with the log line that shows
   it.
4. Then #2, #4, #1, #7, #3, #6/#5/#11 and #12. Each first needs the log lines listed in section 3 (CRASH_MAP has the
   full "Needed in the log" per class).

**Pending CRASH_MAP correction** (at the next update): its "Older builds only" row test9_2 is one of the three TEST9
custom-border-colour crashes that #5137 fixed. The 26 Sep notes say so, and its archived log ends in a host access
violation in emulator code on the GPU thread, with no assert.

## Appendix: the 12 left out, and where each went

| Error | Fixed by |
|---|---|
| `info.h:183` PushUd (17 user-data registers in one draw) | #5181, merged 29 Sep (8c91be2b) |
| 0xC0000409 compiling fs 0xf10530e6 (undefined `sample_index`) | #5131, merged (e0cd957a) |
| Garbage S#: MipFilter unreachable (liverpool_to_vk.cpp:394), MaxAniso unreachable (resource.h:494), custom border colour AV (sampler.cpp:27, TEST9 ×3 incl. test9_2) | #5137, merged 29 Sep (1a0f5be8); #5132 and #5135 were closed in its favour |
| hull_shader_transform.cpp:479 "patch addr non imm" | #5169, merged (4c7b287f) |
| AV on a guest write to the last dword of a page (TEST17b r2) | #5150, merged (c01ae7e6) |
| LDS `Map` without `Commit` stall / device lost (old line) | #5070, merged 23 Sep (bc028b7c) |
| V_INTERP_MOV_F32 assert (fs 0x74f5f10c) | #5087 (not ours), merged 25 Sep (23356292) |
| Missing V_MIN_F64 / V_TRUNC_F64, "Shader translation has failed" | #5125 / #5127 (not ours), merged 26 Sep |
| Device lost at SDRSettingRoot with a warm cache (vk_presenter.cpp:1113) | #5155, open |
| `image_info.cpp:184` ASSERT(!props.is_block) + the mip detiling | #5196, open |

#5126 (compute FLOAT_MODE) and #5114 (F64 literal decoding) fixed no GT7 crash.
