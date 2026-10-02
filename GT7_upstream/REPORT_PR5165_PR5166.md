# GT7 test runs of upstream PRs #5165 and #5166

28 Sep 2026. Builds and analysis: gtnikos-d9 (builder). Every run archived and audited by gtnikos-8c
(watcher/auditor); the audit files are listed at the end. All figures below were read from the
console captures and cross-checked against those audits.

**Status, 28 Sep 23:41 (UTC+3):** #5165 was merged upstream as fca10b26 ("seems faster than always
splitting"); #5166 was closed without merging four seconds later. The final heads of both PRs
(3b8aca53, 56027bf7) are the exact commits tested below. This report is now a record, not a pending
review.

## Summary

- **Neither PR changes GT7's device lost.** Without a PR 3 of 5 runs lost the device; with #5165
  4 of 5, with #5166 4 of 4.
- **Neither PR changes the wrong glyphs or the black shapes.** Both show up with and without the
  PRs, and have been there since long before them.
- **No run ended in a way that is new with either PR.** Every ending was also seen in builds without
  the PRs, or is a separate emulator limit that neither PR touches.
- **Not measured yet:** performance, which is what #5166 was opened for, and whether GT7 ever reaches
  the case the two PRs fix.
- **The tested code is the current code of both PRs** (same patch-id as each PR head).
- **Side finding, not from the PRs:** the wrong glyphs very likely come from the texture cache's
  "maybe dirty" path, not from upload order. The stale-image check found 76 cases in two code paths.
  The proof is still to come (see Next steps).

## What was tested

### The PRs

| PR | title | head | size | tested as |
|---|---|---|---|---|
| #5165 | video_core: Remove memory batching | 3b8aca53 | 6 files, +36/-145 | 83031bba (same patch-id) |
| #5166 | buffer_cache: Always split command buffers on possible fences | 56027bf7 | 1 file, +65/-66 | 8b013d3e (same patch-id) |

Both are open and by the same author. #5165: *"Resolve data corruption issues caused by reordering
uploads too early."* #5166: *"Sister PR of #5165 and solves same issues. Opened so performance of
either solution can be compared."* Neither names a game.

### The base

TEST25 = `8b967597` = upstream main at `e518a651` (27 Sep) plus:

- 8 emulator fixes of ours, some of them open upstream PRs:
  - shader_recompiler: Put 32-bit literals in the high dword of 64-bit floats
  - shader_recompiler: Define SampleId for BaryCoordSmoothSample on the KHR path
  - vk_rasterizer: Bind a default sampler for S# with undefined fields
  - page_manager: Keep the fault probe within the faulting page
  - texture_cache: Allow block-compressed images in macro-tiled modes
  - Preload: build a pipeline from its own permutation's flattened user data
  - shader_recompiler: Eliminate readlanes before the tessellation and ring passes
  - vk_rasterizer: Reject T# with an unsupported format or component swizzle
- one commit and its revert, which cancel out;
- 3 diagnostic commits that only log (device faults, recent GPU work, the draw behind an assert) when
  `GT_DIAG` is set. With `GT_DIAG` on they also wait up to 0.5 s after each Critical line so the log
  queue is written out.

### The builds

| build | what it is | used for |
|---|---|---|
| TEST25 | the base, no PR | control |
| TEST26 | TEST25 + #5165 (83031bba) | #5165 |
| TEST27 | TEST25 + #5166 (8b013d3e) | #5166 |
| TEST27b v1 | TEST26 / TEST27 + a stale-image check (96aad9aa / 329a88b2) | **excluded**: the check itself had a defect (below) |
| TEST27b rebuilt | TEST26 + fixed check (f2a5983c), TEST27 + fixed check (e9e8a11a) | the glyph question; the check changes timing, so not a clean PR comparison |

### Conditions (the same for every run)

- GT7 1.71 (CUSA24767).
- Windows 11 Pro, NVIDIA GeForce RTX 4070 SUPER, driver 591.86, Vulkan 1.4.325.
- Before each launch the launcher restored:
  - the same warm pipeline cache, 1520 files, with the count checked;
  - the same save state;
  - the same profile, log filter and asynchronous logging, with `GT_DIAG=1`.
- The user played the same route each time: boot, menus, then into a race.
- Every run registered the gamepad (run valid), and its exit code was captured.
- 8c archived every log and compared all copies.

## Results

### By build

| build | runs | reached the race | device lost | other endings |
|---|---|---|---|---|
| TEST25 (no PR) | 5 | 3 | 3 (2 before the race, 1 in it) | 1 unhandled access violation (in the race), 1 texture-format unreachable (in the race) |
| TEST26 (#5165) | 5 | 0 | 4 (all before the race) | 1 `tiling.cpp:65` unreachable (before the race) |
| TEST27 (#5166) | 4 | 2 | 4 (2 before the race, 2 in it) | none |
| TEST27b rebuilt, #5165 | 5 | 4 | 1 (before the race) | 4 `info.h:183` PushUd assert (in the race) |
| TEST27b rebuilt, #5166 | 5 | 2 | 2 (before the race) | 1 PushUd assert (in the race), 2 "Unimplemented PM4 type 0" (1 in the race, 1 before) |

Every device lost in these runs happened at submit (`vk_scheduler.cpp:245`, "Device lost during
submit"), on either the GPU command-processor thread or the present thread.

### Every run

Exit codes: 0x80000003 = the breakpoint an assert or an unreachable ends with; 0xC0000005 = access violation.

| build | run | start | length | ended with | thread | exit |
|---|---|---|---|---|---|---|
| TEST25 | 1 | 20:11:05 | 113 s | device lost, before the race | present | 0x80000003 |
| TEST25 | 2 | 20:14:08 | 249 s | unhandled access violation (`signals.cpp:144`), in the race | guest | 0xC0000005 |
| TEST25 | 3 | 20:19:13 | 122 s | device lost, in the race | present | 0x80000003 |
| TEST25 | 4 | 20:22:21 | 207 s | `pixel_format.h:359` unreachable (texture format), in the race | GPU | 0x80000003 |
| TEST25 | 5 | 21:03:22 | 96 s | device lost, before the race | GPU | 0x80000003 |
| TEST26 | 1 | 20:55:01 | 283 s | device lost, before the race | GPU | 0x80000003 |
| TEST26 | 2 | 21:05:51 | 133 s | device lost, before the race | GPU | 0x80000003 |
| TEST26 | 3 | 21:10:29 | 76 s | `tiling.cpp:65` unreachable (array mode), before the race | GPU | 0x80000003 |
| TEST26 | 4 | 21:11:55 | 59 s | device lost, before the race | present | 0x80000003 |
| TEST26 | 5 | 21:13:23 | 108 s | device lost, before the race | GPU | 0x80000003 |
| TEST27 | 1 | 21:31:06 | 283 s | device lost, in the race | GPU | 0x80000003 |
| TEST27 | 2 | 21:37:14 | 59 s | device lost, before the race | GPU | 0x80000003 |
| TEST27 | 3 | 21:39:52 | 103 s | device lost, in the race | GPU | 0x80000003 |
| TEST27 | 4 | 21:43:16 | 213 s | device lost, before the race | present | 0x80000003 |
| 27b rebuilt #5165 | 1 | 22:56:55 | 118 s | device lost, before the race | GPU | 0x80000003 |
| 27b rebuilt #5165 | 2 | 22:59:48 | 202 s | PushUd assert, in the race | GPU | 0x80000003 |
| 27b rebuilt #5165 | 3 | 23:03:55 | 136 s | PushUd assert, in the race | GPU | 0x80000003 |
| 27b rebuilt #5165 | 4 | 23:06:35 | 82 s | PushUd assert, in the race, right after pausing | GPU | 0x80000003 |
| 27b rebuilt #5165 | 5 | 23:08:26 | 83 s | PushUd assert, in the race, right after pausing | GPU | 0xC0000005 |
| 27b rebuilt #5166 | 1 | 23:10:23 | 165 s | PushUd assert, in the race, right after pausing | GPU | 0x80000003 |
| 27b rebuilt #5166 | 2 | 23:15:42 | 65 s | device lost, before the race | present | 0x80000003 |
| 27b rebuilt #5166 | 3 | 23:18:17 | 160 s | "Unimplemented PM4 type 0", in the race (87 s raced) | GPU | 0x80000003 |
| 27b rebuilt #5166 | 4 | 23:22:27 | 114 s | device lost, before the race | GPU | 0x80000003 |
| 27b rebuilt #5166 | 5 | 23:25:44 | 70 s | "Unimplemented PM4 type 0", before the race | GPU | 0x80000003 |

"Length" runs from the launch to the last write of the console capture. TEST27b v1 had 3 runs:
#5165 at 22:20 and 22:32, #5166 at 22:35. All three froze at the same draw and the user closed the
window (exit 0). They are left out of the tables (see Method notes).

### Where each ending was seen before

- **Device lost:** every build, with and without the PRs. It also ended runs of earlier builds,
  before either PR (for example TEST18).
- **`signals.cpp:144` unhandled access violation:** 11 earlier runs across TEST3-TEST17, before
  either PR.
- **`pixel_format.h:359`:** a T# format the emulator does not map. Without a PR, in TEST25.
- **`tiling.cpp:65` (array mode unreachable):** also ended a TEST15 run, before either PR.
- **"Unimplemented PM4 type 0, base reg: 0, size: 1":** the same message ended runs of TEST15,
  TEST17c, TEST17d, TEST18 and TEST21, before either PR. It did not appear in the 14 TEST25-27 runs.
- **`info.h:183` PushUd:** a separate emulator limit that neither PR touches (below). It ended 5 of
  the 6 rebuilt runs that reached the race; the sixth ended with "PM4 type 0" after 87 s of racing.
  None of the earlier race runs ever drew those pipelines (their vertex shaders are in none of those
  logs).

### The PushUd assert (separate from the PRs, parked)

`Shader::Info::PushUd` appends every used user-data register of every stage of a pipeline to one
push block of `NUM_USER_DATA_REGS` = 16 (the per-stage loop in `Rasterizer::BindResources`,
`resource.h:14`). Each of the
five asserting draws is tessellated: LS + HS + VS + FS together need more than 16. Neither PR, nor
the stale-image check, changes that code. Upstream main (197655f8, 28 Sep) still has 16, and no open
PR or issue covers it. Parked by the user until this PR review is finished.

### Visual

- Wrong glyphs (letters replaced by others, e.g. s drawn as e, b drawn as P) and black shapes were
  seen by the user with every build: TEST25, TEST26, TEST27 and TEST27b. Wrong glyphs were first
  seen in TEST11.
- Photos: `logs\user_photos_test27_gt7_1\` (TEST27 run 1, 4 photos) and
  `logs\user_photos_test27b_pr5165_f2a5983c_gt7_1\` (TEST27b rebuilt #5165 run 1).

## What the report can say per PR

### #5165 (Remove memory batching)

- Device lost in 4 of 5 runs, against 3 of 5 without the PR.
- Wrong glyphs and black shapes unchanged.
- No new kind of failure. Its one other ending (`tiling.cpp:65`) had been seen before the PR.
- Reached the race 0 of 5 against 3 of 5. That is not a PR effect we can report: see Caveats.

### #5166 (Always split command buffers on possible fences)

- Device lost in 4 of 4 runs, against 3 of 5 without the PR.
- Wrong glyphs and black shapes unchanged.
- No new kind of failure in TEST27. The rebuilt runs had 2 "PM4 type 0" endings. That message is
  older than both PRs, and 2 in 5 runs is too few to tie it to #5166.
- Reached the race 2 of 4 against 3 of 5 (see Caveats).

## Caveats

- **Few runs.** 5, 5 and 4 runs per build cannot show a difference smaller than several runs.
- **Blocks, not alternation.** The builds were run mostly in blocks: TEST25 20:11-20:25 plus one run
  at 21:03, TEST26 20:55-21:15, TEST27 21:31-21:46. Every TEST25-27 run after 20:55 ended before the
  race except TEST27 runs 1 and 3. So the time of day, or the machine's state, cannot be separated
  from the build.
- **The stale-image check changes timing.** It hashes on the GPU thread. The rebuilt 27b runs reached
  the race 6 of 10 times on the same two PR bases where TEST26 and TEST27 got there 2 of 9 times.
  The 27b runs therefore say nothing about the PRs' effect on progress. They are compared only with
  each other, and for the glyph question.
- **Diagnostics on.** All builds ran with `GT_DIAG=1` and asynchronous logging. The same applies to
  every build, but it is not a plain user setup.

## Not measured yet

1. **Does GT7 ever reach the case the PRs fix?** The case is a fence with nothing to upload, after
   which uploads run ahead of draws recorded before the fence. A counter at that point in the build
   without a PR would say how often. If it is never, neither PR can change GT7's picture, and only
   their cost matters. This needs one test build (TEST25 + one commit).
2. **Performance, which the author asked about.** The log lines carry no timestamps, so FPS over a
   stretch of a run cannot be computed from the logs alone. It needs a timed measure: for example a
   `GT_DIAG` line every few seconds with the frame count, taken over the same stretch in the three
   builds. The only FPS readings so far are the on-screen counter in two photos of the same dialog,
   8 FPS in both, and both builds have a PR: TEST27 run 1 and TEST27b rebuilt #5165 run 1.

## Side finding: why the glyphs are wrong (not from the PRs)

The stale-image check of TEST27b rebuilt hashes an image's whole guest range, read the way the upload
reads it, at upload and again later. It reports images whose memory changed while the texture cache
still considered them clean: 76 reports over the 13 TEST27b runs.

- **34 fit inside one 4 KB page** and were kept by the check that compares only the first 64 bytes of
  a "maybe dirty" image. This is `TextureCache::InvalidateMemory`'s single-page branch
  (`MarkAsMaybeDirty`), followed by `RefreshImage` ("For now we'll just check up to 64 first pixels").
- **42 span 2 or more pages and were only partly watched** (39 span 2 pages, 2 span 7, 1 spans 31).
  This is `InvalidateMemory`'s other two branches (`UntrackImageHead` / `UntrackImageTail`): a
  write to neighbouring data on one of their pages drops the watch on that part without marking the
  image. A later write to that part then goes unnoticed.
- **By kind:** 69 of the 76 are one-channel R8Unorm images 64 pixels wide (16 to 36 rows), the rest
  are 4 R8G8B8A8Unorm 32x32, 2 R32G32Uint 4x4 and 1 BC7 340x340. One report falls on the same screen
  as a wrong-glyph dialog in the user's photo.

Whether a letter comes out right depends on which write reaches that page first. That is why it looks
random. Possible general fix: compare the whole image instead of its first 64 bytes, and treat
partly watched images the same way. No upstream PR or issue covers either path.

## Next steps (each needs the user's go)

1. **Counter build:** does GT7 ever reach the case the PRs fix? (TEST25 + one commit.)
2. **Timed performance measure:** FPS for no PR, #5165 and #5166.
3. **TEST28 = TEST27b rebuilt #5165 + the texture cache fix:** if the letters draw right and the
   stale reports drop to zero, the glyph cause is proven.
4. **Parked:** the PushUd 16-register limit.

## Method notes

- **The TEST27b v1 builds had a defect in the stale-image check itself.** It read the guest range
  straight through the guest address, while the upload copies it page by page through the backing
  and writes zeros for pages with no backing. All 3 v1 runs froze at the same draw. TEST26, the same
  base without the check, passed that point in 5 of 5 runs. The rebuilt check hashes through the
  backing pages the way the upload copies; with it, the freeze did not come back in 10 runs.
- **The window title shows "test18-prfault … b5fa4401" in every build.** That text is set when the
  build folder is configured (27 Sep) and ninja-only builds do not change it. The exe that ran was
  confirmed from the process list and from the launcher.

## Files

- **Audits (8c)** in `logs\`:
  - `test25_run_4_audit.txt`
  - `test26_build_audit.txt`, `test26_runs_1_5_audit.txt`
  - `test27_build_audit.txt`, `test27_runs_1_2_audit.txt`, `test27_run_3_audit.txt`, `test27_run_4_audit.txt`
  - `test27b_build_audit.txt`, `test27b_runs_1_3_audit.txt`, `test27b_rebuild_audit.txt`
  - `test27b_rebuild_run_1_audit.txt`, `test27b_rebuild_run_2_audit.txt`, `test27b_rebuild_runs_3_5_audit.txt`
  - `test27b_rebuild_pr5166_run_1_audit.txt` to `test27b_rebuild_pr5166_run_5_audit.txt`
- **Console captures:** `logs\console_test25_gt7_*`, `console_test26_gt7_*`, `console_test27_gt7_*`,
  `console_test27b_pr516x_gt7_*`.
- **Launchers:**
  - `TEST25_GT7_8b967597_…`, `TEST26_…`, `TEST27_GT7_8b013d3e_…`
  - `TEST27b_PR5165_GT7_f2a5983c_…`, `TEST27b_PR5166_GT7_e9e8a11a_…`
  - v1: `superseded\`
- **Exes and pdbs:** `backup_exe\`.
