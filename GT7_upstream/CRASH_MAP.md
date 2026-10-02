# GT7 1.71 on shadPS4: every way a run crashes (29 Sep 2026, 20:40; TEST32 runs 1-5 added 22:40, runs 6-9 and two TEST30 comparison runs 23:15; TEST33 runs 1-4 30 Sep 07:25; TEST34 runs 1-4 17:10, run 5 17:45; TEST35 runs 1-3 18:25, runs 4-7 19:00; TEST36 run 1 19:15; TEST37 runs 1-4 1 Oct 00:20; TEST39 runs 1-2 00:58; TEST40 run 1 2 Oct 14:35, run 2 14:55)

Written by the auditor from the archived logs in `logs\` (126 at-exit logs, 54 prelaunch copies) and the audit files
of TEST13-TEST30. Run names are `testNN_gt7_R` (TEST NN, run R). The logs of TEST21, TEST21M, TEST26, TEST27 and
TEST27b-pr5166 are no longer on disk; for those runs the audit files are the record. Census script:
`endings.sh` in the auditor's scratchpad `f85ea0bf...`; its full output is `endings_at_exit.txt` there.

## Open crashes, most runs first

| # | Crash | What the log and the driver show | Where in the game | Runs | Best lead |
|---|---|---|---|---|---|
| 1 | GPU fault, write to address 0 | device lost at submit, `WriteInvalid 0x0`; nvlddmkm 13 "WIDTH CT Violation (0x4, 0x0)" + ESR 0x80000010 + 153 | in the race, the pause menu, after a failed race | 17 | a copy "source layers 8, destination layers 48" comes 0.25-0.93 s (1-2 frames) before it in all 11 logs with a report, and in no other ending |
| 2 | GPU fault in a 64 KiB hole between two 8 MiB blocks | device lost at submit (TEST33 r3 and all three TEST35 runs first noticed it at a sparse bind: `buffer_cache.cpp:443`), `WriteInvalid` on a page inside the 64 KiB gap between two 8 MiB "no name" live ranges, 0-52 KiB past the lower one (0x4a6002000 up to TEST30, 0x4a4600000 / 0x4a4602000 / 0x4a460d000 in TEST32, 0x4a4602000 in TEST33, TEST34 and TEST35); nvlddmkm 153 only | mostly before the race: PlayGo dialogs, Buddy screens | 17 with the address, 10 more with the same symptom | a page_manager warning "Tracking memory region 0x3f80000000 - 0x3f80000000", a zero-size texture-cache track or untrack at 0x3f80000000, comes 0.05-0.10 s (0-1 frames) before it in all 17 logs with the address and in no other ending; the page belongs to no Vulkan allocation; both neighbours are 8 MiB and the gap 64 KiB in every layout, and the fault moves with them |
| 3 | PM4 type 0 | `liverpool.cpp:249` (was :256) "Unimplemented PM4 type 0, base reg: 0, size: 1" | anywhere: boot, menus, race | 15 | a zero dword read as a packet header; the log does not say where the parser was. TEST39 r1 and TEST40 r2 (the dead-slot pass running) still end here; TEST40 r2 and test35_3 both in a first pause, ~100 s after PauseRoot, and with test34_2 the same last draw set up (draw count 4, fs 0x5ad38338 / vs 0xfa3f5430) |
| 4 | Protect address 0 | `page_manager.cpp:141` "Tracking memory region 0x0 - N ... not fully GPU mapped", then `address_space.cpp:552` "addr 0x0 out of bounds" | before the race | 9 | the image at address 0 is texture binding 0 of fs 0x2a265dff (TEST17d r5) |
| 5 | Game thread crash A | `signals.cpp:144` 0xC0000005 at eboot+0x302a83b, a Job thread | the PlayGo top menu (TopRootWindow) | 5 | the same instruction in all five runs; in three of them (test25_2, test33_4, test40_1) back at TopRootWindow after a failed race, 0.7-0.83 s after it appeared |
| 6 | Game thread crash B | `signals.cpp:144` 0xC0000005 at eboot+0x18eaf37, thread WorkT | in the race, 9.0-10.4 s after a race start | 6 | the same instruction in all six runs; 9.0-9.4 s after the start in four, 10.4 s in test35_7, whose frame rate was lower (15.6 fps against 23-27); test39_2: 10.18 s of racing after a restart with two short pauses in between (11.8 s counting them), so the clock looks like race time |
| 7 | Unknown tile mode | `tiling.cpp:65` GetArrayMode "Unknown tile mode = 27" or "= 29" | menus and race | 4 | the 22:42 TEST30 run names it: image #1 of fs 0x2a265dff (the draw of #4) holds float data read as a T# with tiling index 29; the T# check does not test the tiling index |
| 8 | Subresource index | `image.cpp:259` ASSERT(subres_idx < subresource_states.size()) | race / menus | 2 | both runs tracked an image in a range that is "not fully GPU mapped" first, like #4 |
| 9 | Bc6 + SnormNz | `pixel_format.h:359` MapNumberConversion "data_fmt = 40" | deep in the race | 1 | changed TEST28-TEST36 (no conversion); TEST37 reverts it (028f3c8a); no run has reached that draw since test25_4 |
| 10 | No gamepad | 0xC0000005 right after the first boot screen (TEST6: eboot+0xa985af, thread Updat) | boot | 6 (+3 in TEST6) | only in runs where "Gamepad registered for slot 0" is missing |
| 11 | Game thread crash C | `signals.cpp:144` 0xC0000005 in libc.prx + 0x1cb5e, thread defTS | the PlayGo top menu (TopRootWindow) | 1 | new in TEST32; the same point in the game as #5 |
| 12 | GPU fault just past the end of a staging buffer | device lost at submit, `WriteInvalid` on the first page after a live 192 MiB Buffer "StagingBufferPool:Dedicated" bound 0.12 s before; no range above it, 0 owners; nvlddmkm 153 only | in the race (79.7 s in, no pause) | 1 | new in TEST35 (test35_1); the dedicated buffer is RoundAllocationSize(request) long, and a page_manager warning 245 ms before tracks a 170.6 MiB range, a request size that rounds to exactly 192 MiB; the last draws are the class-1 end-of-frame set, but there is no 8->48 copy |
| 13 | SurfaceFormat / ComponentSwizzle assert (reopened in TEST37) | `liverpool_to_vk.cpp:788` SurfaceFormat "Unknown data_format=46 and num_format=0" / "=19 and num_format=9", `:428` ComponentSwizzle unreachable, while binding image #0 of fs 0x2a265dff (before TEST22: `:788/:792` 19/9 and 44/0, `:428`) | the PlayGo menus, before the race | 3 (+7 before TEST22) | the T# check held it off TEST22-TEST36 and TEST37 reverts it. test37_1, _2, _3: the same draw (fs 0x2a265dff + vs 0x610d64f, draw count 3) bound image #0 holding three different T#s (46/0, 19/9, 12/0). TEST37's dead-slot pass never ran: it skips every shader when patch_shaders is on, and the test profile has it on. TEST39 (the pass runs): 0 in 2 runs; images #0 and #1 of fs 0x2a265dff are judged dead and bound null at every bind |

## TEST30 (10 runs): what each one died of

| run | crash | # |
|---|---|---|
| 1, 2 | Protect address 0 | 4 |
| 3, 9 | GPU fault near 0x4a6002000 | 2 |
| 4 | PM4 type 0 | 3 |
| 5, 10 | GPU fault at address 0 (WIDTH CT) | 1 |
| 6, 8 | game thread crash A (eboot+0x302a83b) | 5 |
| 7 | game thread crash B (eboot+0x18eaf37) | 6 |

None of them is `info.h:183` or `info.h:190`. Each class above predates TEST30.

## TEST32 (2ccb31e0, every stage reads its user data from the flat buffer): runs so far

| run | crash | # |
|---|---|---|
| 1 | game thread crash C (libc.prx, defTS), PlayGo top menu | 11 (new) |
| 2, 3 | GPU fault just past the 8 MiB block, key-assign / Buddy screens | 2 |
| 4 | PM4 type 0, key-assign screens | 3 |
| 5 | game thread crash B, 9.1 s after restarting a failed race | 6 |
| 6 | GPU fault at address 0, 6.8 s after restarting a failed race | 1 |
| 7 | GPU fault at address 0, in the pause menu (50 s into the first pause) | 1 |
| 8 | GPU fault in the 64 KiB hole, Buddy screens | 2 |
| 9 | GPU fault at address 0, 64 s into the race | 1 |

Run 5 reached the race and both TEST27b pause draws (vs 0x7bab5d15, the 17-slot draw, and vs 0xdbbb8a3c) ran with all
their user data read from the flat buffer; the pause menu came up correctly. Runs 6-9: every .spv written (1574, 1293,
568 and 1291 files) loads its user data only from the flat buffer; run 7 ran vs 0xdbbb8a3c again. First pauses: run 5
184 s (807 pipelines and 1278 modules compiled), run 6 45 s (199), run 7 about 22 s until frames came back (119).
The long first pause is not TEST32's: the 22:42 TEST30 run, with its 424 pipelines preloaded, stalled 141 s at its
first pause (736 pipelines, 1188 modules); those pipelines are not in the version-5 snapshot either. The user ran two
TEST30 runs between the TEST32 ones (the builder's visual comparison): the 22:42 one ended on #7 (tile mode 29, in the
race, after also running vs 0x7bab5d15 without stopping), the 22:55 one with exit code 0 four seconds into its first
pause. Details: `logs\test32_gt7_runs_audit.txt`.

## TEST33 (34e1d0da = main e754ce62, which has #5137 and #5181, + TEST32's other 8 commits + small mips of macro-tiled images in the 1D layout): runs so far

| run | crash | # |
|---|---|---|
| 1 | GPU fault in the 64 KiB hole, Buddy screen, 20.5 s after BuddyWindowRoot (not watched: exit code from the console) | 2 |
| 2 | GPU fault at address 0, 71 s into the race | 1 |
| 3 | GPU fault in the 64 KiB hole, Buddy screen, 1.4 s after BuddyWindowRoot; the loss was noticed by a sparse bind | 2 |
| 4 | game thread crash A (eboot+0x302a83b), the PlayGo top menu 0.7 s after returning from a failed 138 s race | 5 |

fs 0x74f5f10c, the Buddy-screen BC7 draw the new commit is about, was bound in every run (27, 337, 262 and 1384
times, each bind with a "Clamped size" line for that stage), and class 2 still comes at the Buddy screen. The .spv of
runs 1-3 (515, 1086 and 580) read all their user data from the flat buffer. Details: `logs\test33_gt7_runs_audit.txt`.

## TEST34 (76a35aac = TEST33 + a bring-up dump of the guest bytes of BC images with mips in the 1D layout, `GT_IMGDUMP_DIR`): runs so far

| run | crash | # |
|---|---|---|
| 1 | GPU fault in the 64 KiB hole, 0.13 s after the TopRootWindow that follows the first-race key-assign dialogs | 2 |
| 2 | PM4 type 0, 0.29 s after PlayGoPreQuickRoot (past the key-assign and assist-preset dialogs) | 3 |
| 3 | Protect address 0, 0.78 s after BuddyWindowRoot (past the key-assign and assist-preset dialogs) | 4 |
| 4 | Protect address 0, on the first Buddy screen, 11.6 s after BuddyWindowRoot | 4 |
| 5 | game thread crash B (eboot+0x18eaf37), 9.0 s after restarting a failed race (144 s of racing, a 65 s first pause before it) | 6 |

Runs 1-4 died before the race, 79-102 s after launch; run 5 raced. Nothing points at the new commit (it only writes
files). Each run wrote the same 16 dumps during its first Buddy screen, the tool's cap (the first 16 BC images with
1D-layout mips, each at its first upload, none GPU-modified, none written a second time), so run 5's race and pause
wrote nothing more: 43,045,853 B per run, all 32 files byte-identical across the five runs. Dump 00 (Bc7SrgbBlock
1024x1024, 11 mips, 0x30041e0000) is logged between the first two binds of fs 0x74f5f10c in every run; fs 0x74f5f10c
was bound 220, 238, 165, 225 and 2162 times. The .spv of runs 1-5 (586, 577, 570, 578, 1907) read all their user data
from the flat buffer. Details: `logs\test34_gt7_runs_audit.txt`.

## TEST35 (91ffbea6 = origin/main 2338a06f, which adds #5184, #5185, #5141 and #5193, + the TEST34 stack + 0ca8528f thick mips + a bind log of fs 0x74f5f10c, `GT_BINDLOG`): runs so far

| run | crash | # |
|---|---|---|
| 1 | GPU fault on the first page past a 192 MiB "StagingBufferPool:Dedicated" buffer, 79.7 s into the first race | 12 (new) |
| 2 | GPU fault in the 64 KiB hole, first Buddy screen, 12.8 s after BuddyWindowRoot; noticed by the sparse bind | 2 |
| 3 | PM4 type 0, in the first pause 102 s after PauseRoot (exit 0xC0000005) | 3 |
| 4 | GPU fault in the 64 KiB hole, a Buddy screen inside the first-race key-assign dialogs, 0.52 s after BuddyWindowRoot; noticed by the sparse bind | 2 |
| 5 | GPU fault in the 64 KiB hole, 1.54 s after BuddyWindowRoot (past the key-assign and assist-preset dialogs); noticed by the sparse bind | 2 |
| 6 | GPU fault at address 0, 16.0 s into the first race; the 8->48 copy 0.29 s (2 frames) before it | 1 |
| 7 | game thread crash B (eboot+0x18eaf37), 10.4 s after restarting a failed 130 s race | 6 |

Class 2 still comes with #5193 in the build: the same page and the same two 8 MiB blocks in runs 2, 4 and 5, each
first noticed by the sparse bind, and each with the zero-length tracking warning at 0x3f80000000 0.08-0.10 s before
(see #2). The bind log names the textures of fs 0x74f5f10c in every run: slot 4 is the Bc7SrgbBlock 1024x1024 at
0x30041e0000 = image dump 00, the only 1D-layout BC image the stage reads; slot 2 is another Bc7UnormBlock 1024x1024
(tile_mode 13, no 1D-layout mips) at one of three addresses; slot 6 changes on nearly every bind (43-44 images x 6
views of a 4x4 R32G32Uint array) and fills 249 of the 256 lines, so the cap comes at bind 349-378, during the first
one to three Buddy screens. The 16 dumps are byte-identical to TEST34's in all seven runs. The .spv of runs 1-7 (1103,
557, 1420, 551, 570, 983, 1492) read all their user data from the flat buffer. The bind counts quoted for TEST33 and TEST34
(and first for TEST35) are counts of "Clamped size" lines for the stage, and the bind log shows they undercount: at its
cap the counter was at bind 349-378 with 270-276 such lines logged. Details: `logs\test35_gt7_runs_audit.txt`.

## TEST36 (04558db8 = TEST35 + one commit: tile mode 18 takes the PRT 3D thin array mode, 128-bit display micro tiles the thin element order): runs so far

| run | crash | # |
|---|---|---|
| 1 | GPU fault at address 0, 12.5 s after the resume from the second pause; the 8->48 copy 0.28 s (1 frame) before it | 1 |

Neither changed path ran: the 17 detilers the run built (tile_manager.cpp:173) are all among TEST35's 18, and none is a
tile mode 18 or a 128-bit display one. Nothing new in the log: every distinct Warning / Error / Critical line is in
the TEST35 runs; the one new Info line is an ls shader permutation compile in the first pause that test30_5 also
logged. Dumps and bind log as in TEST35; the 1426 .spv read all their user data from the flat buffer. Details:
`logs\test36_gt7_runs_audit.txt`.

## TEST37 (ebcfc8a2 = TEST36 without 9dce3330 SnormNz and d833bab4 the T# check + one commit: images and samplers a draw does not read are skipped): runs so far

| run | crash | # |
|---|---|---|
| 1 | SurfaceFormat assert "Unknown data_format=46 and num_format=0" binding image #0 of fs 0x2a265dff (draw count 3, vs 0x610d64f), right after a new permutation of that shader was compiled; the PlayGo menus, 1.76 s (24 frames) after BuddyWindowRoot, 118 s into the run | 13 |
| 2 | SurfaceFormat assert "Unknown data_format=19 and num_format=9", the same draw and slot (T# type 8), right after a new permutation of fs 0x2a265dff; the PlayGo menus, 3.35 s after BuddyWindowRoot, 77 s in | 13 |
| 3 | ComponentSwizzle unreachable (`:428`), the same draw and slot (T# 12/0, type 12); the PlayGo menus, 1.13 s after BuddyWindowRoot, 69 s in | 13 |
| 4 | GPU fault at address 0 in the first race, 65.9 s after InRaceRoot; the 8->48 copy 0.29 s (1 frame) before it; nvlddmkm 13 "WIDTH CT Violation (0x4, 0x0)" + ESR 0x80000010 + 153; 154 s in | 1 |

**The fix never ran in TEST37** (builder, 1 Oct ~00:19; checked): FindResourceGuards (resource_patching_pass.cpp:1524)
collects guards only `if (!EmulatorSettings.IsPatchShaders())`, the test profile's config.json has
`"patch_shaders": true`, and `user\shader\patch` is empty. So no slot was ever judged dead, and TEST37 is in effect
TEST36 without the two symptom fixes. What its runs do show: without the T# check, 3 of 4 runs ended in the menus
(69-118 s) on the asserts it used to catch, all at image #0 of fs 0x2a265dff in one draw. TEST38 changes the skip to
shaders that really have a patch file.

Run 1 against the plan (`logs\test37_plan_resource_guards.md`, "Verification"): fs 0x2a265dff was compiled 35 times (35
.spv) in 108 s, against 33 in TEST36 r1's first 108 s, so its keys did not collapse. S# rejections 147, T# rejections
38 (main's check again), permutations 119, against 182 / 52 / 138 in TEST36 r1's first 108 s (TEST36 r1 was in the
race by then and this run in the menus, so it is not a like-for-like comparison). No Thick3DThickPrt_32 detiler, no
GetArrayMode / tiling.cpp:66, no zero-length region at 0x3f80000000. One detiler no archived run built before:
Depth2DThin64_64. Signatures without the line number: 3 new, all from the revert (the assert, its GT_DIAG context
line, main's T# rejection text). The 32 dump files are identical to TEST34 r1's; the bind log of fs 0x74f5f10c is
TEST36 r1's (no slot disappeared); the 585 .spv read all their user data from the flat buffer; no nvlddmkm or Display
events. Details: `logs\test37_gt7_runs_audit.txt`.

## TEST39 (0247e2e9 = TEST37 + 9bc582bb, the pass skipped only for a shader with a patch file (TEST38, no runs), + a [test] log of the guard decisions of the GT_BINDLOG shaders): runs so far

| run | crash | # |
|---|---|---|
| 1 | PM4 type 0 in the first race, 51.7 s (768 frames) after the resume from the first pause; the assert fired outside a draw, the last one set up was draw count 4, fs 0x9c23f9ea / vs 0x8167a22c; 267 s in | 3 |
| 2 | game thread crash B (eboot+0x18eaf37), 10.18 s of racing after restarting a failed race (11.8 s with two short pauses in between); 405 s in | 6 |

**The pass runs, and does what the plan says.** In both runs fs 0x2a265dff was compiled once (TEST36 r1: 39; TEST37
r1-r4: 24-39), there was not a single "Rejecting invalid S#" or "Rejecting invalid T#" line (TEST36 r1: 458 and 123),
and none of #13's asserts, #7's GetArrayMode, the Thick3DThickPrt_32 detiler or #2's zero-length region at 0x3f80000000
appeared. Both runs reached the race (three of TEST37's four died in the menus). The guard log gives one decision per
shader for the whole run: for fs 0x2a265dff one condition, on flat-buffer dword 50, which reads 0, so false; images #0
and #1 and sampler #0 are dead and bound null, and image #2, which has no guard, is bound (a 1920x1080 D32S8 depth
image, the only image of that draw in the bind log). For fs 0x74f5f10c nothing is dead. The recomputation agrees with
the pass at every logged bind. Neither ending is a crash the pass is about.

Nothing else new in the log: against TEST35 r1-r7 and TEST36 r1 the only new Warning/Error/Critical is main's PM4
bounds check (`liverpool.cpp:60` NextPacket, "packet length exceeds remaining submission size", 4810 dwords with 4
left), once in run 2, in the race, and the run went on; the archive has it in test32_6 and test33_4 as well, always with
4 dwords left, and never in a run that ended in #3. The new Info lines are the instrument's own. The 32 dump files are
identical to TEST34 r1's; the bind log of fs 0x74f5f10c is TEST36 r1's; the 1520 and 2300 .spv read all their user data
from the flat buffer; no nvlddmkm or Display events. The bind log
numbers images from 0, like the guard log ("image 2 of 3" = image #2). Details: `logs\test39_gt7_runs_audit.txt`.

## TEST40 (07a74022 = TEST39 + a [test] check, `GT_GUARDCHECK`: every image read of a group a compile judged dead sets a bit that the emulator reads back after each submit and logs as a "guardcheck HIT"): runs so far

| run | crash | # |
|---|---|---|
| 1 | game thread crash A (eboot+0x302a83b, Job thread), 0.83 s (20 frames) after TopRootWindow, back from a failed 171 s race (music rally); 346 s in; `GT_GUARDCHECK=2` (canary launcher) | 5 |
| 2 | PM4 type 0 in the first pause of the second race, 97.3 s (742 frames) after PauseRoot, no resume; outside a draw, the last one set up was draw count 4 fs 0x5ad38338 / vs 0xfa3f5430 (= test34_2, test35_3); 553 s in; `GT_GUARDCHECK=1` | 3 |

**The check found no wrong "dead" verdict.** Run 1 compiled 1522 modules (the cache is not used in a check run), 577 of
them with resource guards and 224 with at least one image or sampler judged dead; 0 HIT lines in 346 s of menus and a
race. Run 2: 2206 modules, 885 with guards, 449 with a dead image or sampler, 0 HIT lines in 553 s (two races and a
pause). The 4 canaries (the live image reads of the first 4 guarded modules: cs 0x2b96ae5c perm 0 and 1, fs 0x74f5f10c,
fs 0xf10530e6) reached the log, so the path from the shader to the log works. The TEST39 checks are unchanged: fs
0x2a265dff compiled once, its images #0 and #1 and sampler #0 dead at every bind, 0 S# / T# rejections, none of #13, #7
or #2's zero-length region; dumps = TEST34 r1, bind log of fs 0x74f5f10c = TEST36 r1. Against TEST35, TEST36 r1 and
TEST39 r1-r2 no new Warning/Error/Critical; the 5 new Info lines are the check's own. No nvlddmkm or Display events.
FPS is not comparable (every module compiled cold: 6 FPS in the race). Details: `logs\test40_gt7_runs_audit.txt`.

## The details

### 1. GPU fault: write to address 0, "WIDTH CT Violation"
- **Runs (17):** test13_1, test17_4, test18_6, test19b_2, test22_2, test25_3, test27_3, test28_2, test30_5, test30_10,
  test32_6, test32_7, test32_9, test33_2, test35_6, test36_1, test37_4. Every one that can be placed was in the race: racing
  (test32_9, 64 s in; test33_2, 71 s in; test35_6, 16 s into the first race; test36_1, 12.5 s after the resume from its
  second pause), in the pause
  menu (test30_10, 0.24 s after the third pause; test32_7, 50 s into the first pause), or after a failed race
  (test22_2: FailureRoot, then ConfirmDialog; test32_6: 6.8 s after the restart's InRaceRoot).
- **Driver:** the same ESR every time (0x510420=0x80000010 0x510434=0x4 0x510438=0xf00 0x51043c=0x0), "Graphics
  Exception on GPC 2: WIDTH CT Violation. Coordinates: (0x4, 0x0)", then 153 (test35_6 and test36_1 too). In the ten runs
  whose GT_DIAG report is on disk the fault record is `WriteInvalid 0x0` with no owner.
- **Lead, measured on 29 Sep:** the log line `SanitizeCopyLayers: Coercing copy source layers 8 and destination layers 48
  to minimum` appears in 12 of the 12 logs of this class still on disk (test17_4, test22_2, test25_3, test28_2, test30_5,
  test30_10, test32_6, test32_7, test32_9, test33_2, test35_6, test36_1). In the 10 with a report its last occurrence
  comes 0.25-0.93 s and 1-2 frames before the device lost (test25_3 0.31 s, test28_2 0.93, test30_5 0.60, test30_10
  0.25, test32_6 0.49, test32_7 0.29, test32_9 0.26, test33_2 0.34, test35_6 0.29, test36_1 0.28). It is in 0 of 17 race runs that ended
  some other way (test30_7, test25_2, test25_4, test24_1, test23_2, test27b f2a5983c 2 and 3, test28_3, test17_6,
  test14_2, test32_5, the 22:42 TEST30 run, test33_4, test34_5, test35_1, test35_3, test35_7), including races of 2-6
  minutes. It is also in none of the 17 class-2 logs on disk. Unproven suspect from 27 Sep (read only):
  `Runtime::CopyImage` / `ResolveImage` take the extent from the source with no clamp to the destination.
- **The last recorded draws:** all 10 reports stop recording at the same place in a frame: a group of fs 0x4e0b9acd /
  es 0x72d3a762 / gs 0x227b3323 draws, then draw indexed fs 0x9c23f9ea / vs 0x8167a22c (the newest in 8 of the 10;
  test33_2's and test36_1's 16 are 8 x fs 0xabe48410e49af89f, fs 0x5ad38338, 6 x fs 0x4e0b9acd, then fs 0x9c23f9ea; test35_6's are
  5 x fs 0xabe48410e49af89f, fs 0x5ad38338, 6 x fs 0x4e0b9acd, fs 0x9c23f9ea, then fs 0x286567c0, fs 0xabe484107e4ac039
  and fs 0x15ff214a). None of the class-2 reports has either shader in its last 16 (test35_4 and _5 checked too). That list is where the CPU was recording, not the work the
  GPU faulted in; it places the fault in the race frame and does not name the writer.
- **Needed in the log:** at that coercion, both images (guest address, width x height, format, mips, layers, tile mode)
  and the copy regions; which call made the copy. Optionally a run with `GT_GPU_CHECKPOINTS=1`, which names the last
  command the GPU reached (it adds a command per draw, so it changes timing).

### 2. GPU fault: write into a 64 KiB hole between two 8 MiB blocks (near 0x4a6002000)
- **Runs with the address:** test23_1, test25_5, test27b f2a5983c_1, test28_1, test30_3, test30_9 (all 0x4a6002000);
  test24_1 (0x4a6008000, in the race); test25_1 (0x4a5e02000); test32_2 (0x4a4602000), test32_3 (0x4a4600000),
  test32_8 (0x4a460d000); test33_1 and test33_3 (both 0x4a4602000); test34_1 (0x4a4602000); test35_2, test35_4 and
  test35_5 (all 0x4a4602000).
- **The hole (measured 29 Sep, 23:00; TEST33-TEST35 30 Sep):** every report that lists both neighbours (15 of the 17) puts the fault page
  inside a 64 KiB gap between two 8 MiB "no name" live ranges: 0x4a5800000-0x4a5ffffff and 0x4a6010000-0x4a680ffff
  (test25_5, test27b f2a5983c_1, test28_1, test30_3, test30_9: fault at gap +8 KiB), 0x4a5600000-0x4a5dfffff and
  0x4a5e10000-0x4a660ffff (test25_1: +8 KiB), 0x4a3e00000-0x4a45fffff and 0x4a4610000-0x4a4e0ffff (test32_2 +8 KiB,
  test32_3 +0, test32_8 +52 KiB, test33_1 +8 KiB, test33_3 +8 KiB, test34_1 +8 KiB, test35_2, test35_4 and test35_5
  +8 KiB). Both blocks are exactly 8 MiB and the gap exactly 64 KiB in all three layouts. The
  write lands anywhere in the gap, so it may run past the end of the lower block or start before the upper one.
- **Same symptom** (device lost, nvlddmkm 153 only, before the race), address not kept: test21_5, test26_1, _2, _4,
  _5, test27_1 (in the race), _2, _4, test27b pr5166 2 and 4.
- **What the report says:** the page is covered by no live or unbound Vulkan range (0 owners in every report, e.g.
  4635 binds / 950 unbinds searched in test30_9). The nearest live range below it ends 8 KiB below the fault
  (0x4a5800000-0x4a5ffffff in test30_3 and _9). The 16 last-recorded draws come from the rasterizer only. Copies, fills,
  DMA and the detiling passes are not in that list, and they also write memory. In test30_9 the list holds fs 0x2a265dff /
  vs 0x610d64f, the draw of #4.
- **TEST32 (runs 2, 3 and 8):** GPU memory is laid out differently: the two 8 MiB blocks sit at 0x4a3e00000-0x4a45fffff
  and 0x4a4610000-0x4a4e0ffff, 26 MiB lower than up to TEST30, and the faults landed at gap +8 KiB (0x4a4602000, run 2),
  +0 (0x4a4600000, run 3) and +52 KiB (0x4a460d000, run 8). So the fault is tied to those allocations, not to a fixed
  address. In runs 2 and 3 and in test30_9 the assert's work-context line names draw count 4: fs 0xabe48410e49af89f /
  vs 0xabe484105b605917 (the pipeline of the eight fs 0xabe48410e49af89f draws in the class-1 lists); run 8 has none.
- **TEST33 (runs 1 and 3):** the same two blocks and the same page as test32_2, both at the Buddy screen (20.5 s and
  1.4 s after BuddyWindowRoot); run 3's work-context line names the same draw count 4 fs 0xabe48410e49af89f, run 1 has
  none; both last-draw lists hold vs 0xabe484101cef4c3a x2 and fs 0x2a265dff / vs 0x610d64f x2. In run 3 the loss was
  first noticed by the arena's sparse bind (`buffer_cache.cpp:443` SubmitPendingArenaBinds, "device lost (sparse
  bind)") instead of the submit; the fault record is the same, so this is where the loss was seen, not a new crash.
- **TEST34 (run 1):** the same page and the same two blocks again, 0.13 s after the TopRootWindow that follows the
  first-race key-assign dialogs (the last BuddyWindowRoot 3.04 s before); the work-context line names the same draw
  count 4 fs 0xabe48410e49af89f, the last-draw list holds vs 0xabe484101cef4c3a x2 and fs 0x2a265dff / vs 0x610d64f x2,
  as in test33_1 and _3; nvlddmkm 153 only.
- **TEST35 (runs 2, 4 and 5), with main's #5193 in the build** (it changes the offsets the sparse arena binds at): the
  same page and the same two blocks again: run 2 on the first Buddy screen 12.8 s after BuddyWindowRoot, run 4 on a
  Buddy screen inside the first-race key-assign dialogs 0.52 s after BuddyWindowRoot, run 5 past the key-assign and
  assist-preset dialogs 1.54 s after BuddyWindowRoot. All three were first noticed by the sparse bind
  (`buffer_cache.cpp:443`, "Device lost during submit"), as in test33_3 and in no other build; all three name draw count 4
  fs 0xabe48410e49af89f in the work-context line and hold vs 0xabe484101cef4c3a x2 and fs 0x2a265dff / vs 0x610d64f x2
  in the last-draw list; nvlddmkm 153 only. So #5193 neither removed nor moved it.
- **The zero-length region (measured 30 Sep, 18:40-18:52, over 142 GT7 test logs):** every class-2 log with the address,
  all 17 in both layouts (test33_1 through its prelaunch copy), has exactly one `page_manager.cpp:141` line "Tracking
  memory region 0x3f80000000 - 0x3f80000000 which is not fully GPU mapped" on the GPU thread, 49-439 lines = 3-6 ticks =
  0.05-0.10 s, 0-1 frames before the device lost. No log of another ending has it (all 11 class-1 logs, classes 3-9 and
  12). Five older logs with no fault report have it too: test14_gt7 and test16_gt7_4 end in "Device lost during submit"
  0.26 s and 0.07 s after it, test15_gt7_2, test15_gt7_6 and test16_gt7_3 end 10-100 lines after it with no crash line.
  The warning prints the page-aligned range, so this is a call with size 0 at 0x3f80000000; its only callers are the
  texture cache's image Track / Untrack functions, and of those only two can pass size 0 (91ffbea6 source, read-only):
  `TrackImage` for an image whose guest_size is 0 at 0x3f80000000, or `UntrackImageTail` for an image that ends exactly
  at 0x3f80000000 (size = end - AlignDown(end)), which runs when a write invalidates the image's last page.
- **Needed in the log:** at a zero-size `UpdatePageWatchers` call, which function made it and the image: guest address
  and guest_size, format, width x height x depth, mips, layers, tile mode, how it is used (render target, depth,
  storage, sampled) and the Vulkan memory behind it (DeviceMemory and range, to match against the two 8 MiB blocks and
  the hole); for `UntrackImageTail` also the invalidated address and the thread. Earlier ask (sent to the builder on 29
  Sep at the user's command), still useful: which objects own the two 8 MiB blocks and what is bound in the pages next
  to the hole; or one run with `GT_GPU_CHECKPOINTS=1`.

### 3. PM4 type 0
- **Runs (15):** test15_3, test17c_5, test17d_2, test18_2, test18_4, test21_2, test27b pr5166 3 (in the race) and 5,
  test29_1 (before the first boot screen), test30_4, test32_4 (key-assign screens), test34_2 (0.29 s after
  PlayGoPreQuickRoot; the assert fired outside a draw, the last one set up was draw count 4 fs 0x5ad38338 / vs
  0xfa3f5430), test35_3 (in the first pause, 102 s after PauseRoot; exit 0xC0000005; the same last draw set up as
  test34_2), test39_1 (in the first race, 51.7 s after the resume from the first pause; outside a draw, the last one
  set up was draw count 4 fs 0x9c23f9ea / vs 0x8167a22c), test40_2 (in the first pause of the second race, 97.3 s
  after PauseRoot with no resume, 742 frames; exit 0xC0000005; outside a draw, the last one set up was draw count 4
  fs 0x5ad38338 / vs 0xfa3f5430, the same as test34_2 and test35_3).
- **The pause pattern (TEST35 on):** test35_3 and test40_2 both died in a first pause, 102 s and 97.3 s after
  PauseRoot, with the same last draw set up, which test34_2 (0.29 s after PlayGoPreQuickRoot) also had. In test40_2
  the pause compiled 172 graphics pipelines and 248 modules cold (the check run uses no cache) and the parser hit the
  zero dword 55 s after the last of them.
- **Related, not an ending:** main's bounds check `liverpool.cpp:60` NextPacket "packet length exceeds remaining
  submission size" fired in test32_6 (5266 dwords), test33_4 (314) and test39_2 (4810), each time with 4 dwords of the
  submission left, and each run went on (they ended in #1, #5 and #6). So the parser also meets headers it cannot fit
  in the last 4 dwords of a submission; whether that is the same memory as #3's zero dword is open.
- **What it is:** the graphics command processor read a zero dword where a PM4 packet header should be.
- **Needed in the log:** where the parser was (command buffer guest address, offset in dwords, its size), the last few
  packet headers before it, and whether that range was written after it was submitted.

### 4. Protect address 0
- **Runs (9):** test16_1 (its log ends on the warning), test17c_1, test17d_5 (Protect at 0x28000, no warning), test22_1,
  test29_2, test30_1, test30_2, test34_3 (region 0x0 - 0x1000, 0.78 s after BuddyWindowRoot), test34_4 (region 0x0 -
  0x65000, on the first Buddy screen 11.6 s after BuddyWindowRoot). All of them before the race; both TEST34 runs name
  the draw fs 0x2a265dff / vs 0x610d64f in the work-context line.
- **The chain:** an image whose guest range starts at 0 is tracked ("Tracking memory region 0x0 - N which is not fully GPU
  mapped"), then write-protecting page 0 asserts. Draw at the assert: fs 0x2a265dff / vs 0x610d64f. TEST17d r5's image
  map named texture binding 0 of fs 0x2a265dff.
- **Lead (unproven):** on 26 Sep the sampler slot of the same shader was shown to hold unrelated data, because its only
  samples are behind a branch that is not taken in those draws (that is why #5137 survives a garbage S#). The texture
  slot may be the same case: a descriptor the draw never reads, with base 0, still gets an image and page tracking.
  #7 now shows image #1 of the same fs holding floats (29 Sep, the 22:42 TEST30 run).
- **Needed in the log (the log ask still waiting for your go):** the path that creates and tracks the image at address 0,
  and the raw T# dwords.

### 5. Game thread crash A: eboot+0x302a83b
- **Runs (5):** test25_2 (after a failed race, back at TopRootWindow), test30_6 and test30_8 (TopRootWindow, before
  the race), test33_4 (after a failed 138 s race, 0.7 s after TopRootWindow; eboot at 0xbc90000, fault at 0xecba83b),
  test40_1 (after a failed 171 s race, then ConfirmDialog and PlayGoPreQuickRoot; 51 netctl ticks = 0.83 s, 20 frames,
  after the next TopRootWindow; eboot at 0xbb50000, fault at 0xeb7a83b). Job#62 / Job#13 / Job#14 / Job#48 / Job#47,
  EXIT 0xC0000005.
- **What the log has:** only the instruction address; the next lines are the game's own teardown.
- **Needed in the log:** the address the instruction touched, read or write, the registers, and the thread's last
  library calls before it. The same instruction in five runs means it is repeatable, and three of them came under 1 s
  after TopRootWindow on the way back from a failed race.

### 6. Game thread crash B: eboot+0x18eaf37
- **Runs (6):** test17_6, test30_7, test32_5, test34_5 (eboot at 0xbd90000, fault at 0xd67af37), test35_7 (eboot at
  0xbac0000, fault at 0xd3aaf37), test39_2 (eboot at 0xbb40000, fault at 0xd42af37). Thread WorkT, in the race.
- **test39_2 and the pause:** it came after a restart (FailureRoot, then InRaceRoot) with two short pauses in the next
  10 s, so its last InRaceRoot was a resume 2.45 s (150 ticks) before the crash. From the restart's InRaceRoot it is
  722 ticks = 11.8 s, of which 99 in the two pauses: 623 ticks = 10.18 s of racing, 206 frames. So the clock looks like
  race time, which stops in the pause, not wall time since the last InRaceRoot.
- **It has a clock:** it comes 9.0-10.4 s after the last RaceCommon_InRaceRoot, measured on the netctl clock:
  test17_6 578 ticks = 9.4 s / 250 frames (a first race start), test30_7 562 = 9.2 s / 209, test32_5 556 = 9.1 s / 211,
  test34_5 552 = 9.0 s / 214 and test35_7 635 = 10.4 s / 162 (all four a restart after FailureRoot). test35_7 ran at
  15.6 fps in that window against 22.8-26.5 in the others, so it is neither a fixed time nor a fixed frame count. WorkT
  logs nothing between the race start and the crash in any of them. It is not every start: test30_7, test32_5, test34_5
  and test35_7 each survived their first start (test35_7 raced 130 s), and test34_5 also the InRaceRoot of a resume from
  the pause (19.5 s to its FailureRoot). What the game does about 9-10 s into a race start is the trigger to find.
- **Needed in the log:** as for #5, around that moment.

### 7. Unknown tile mode 27 / 29
- **Runs (4):** test15_4 (29, in the race), test21m_1 (27), test26_3 (27), the TEST30 comparison run of 29 Sep 22:42
  (29, in the race, 112.7 s after the last InRaceRoot; its clean log is `shad_log_test32_gt7_prelaunch_20260929_224915.txt`,
  line 1351394).
- **The resource, named by the GT_DIAG work context in that run (lines 1351398-1351399):** image #1 of the Fragment
  stage of the draw fs 0x2a265dff / vs 0x610d64f (the draw of #4), during texture binding: tiling_index 29,
  data_format 19, num_format 0, type 12, size 14797x4204x801, pitch 8453, levels 14-14, layers 3081-2120. All eight T#
  dwords read as floats between -619.9 and 863.6, so the slot holds other data, not an image descriptor. The T# check
  (`vk_rasterizer.cpp` BindTextures) tests the address mapping, the data and number formats and the component mapping,
  not the tiling index, so this descriptor passes it and reaches `GetArrayMode`. TEST32 has the same check.
- **Same shader as #4:** there texture binding 0 of fs 0x2a265dff has base 0; here binding #1 holds floats. Both fit the
  #4 lead: descriptors the draw never reads still get an image.

### 8. image.cpp:259 subresource index
- **Runs (2):** test17c_3 and test23_2 (52 s into the race, after `image.cpp:170 Bc2UnormBlock type 1D is not
  supported`). Both first tracked an image in a range that is "not fully GPU mapped", as in #4.
- **Log:** TEST24 added a line before this assert (image, range, index and size). No run has hit it since.

### 9. pixel_format.h:359, Bc6 with SnormNz
- **Runs (1):** test25_4, about 2 minutes into the race. Changed in TEST28 (return no conversion for SnormNz formats
  without one; commit 3bc09423 in TEST31). A run that reaches that draw now logs `Rejecting invalid T# ...
  num_format=6` instead of stopping. Not seen since.

### 10. No gamepad
- **Runs:** test18_1 and five TEST20 runs (6 of 6 runs with the pad missing; memory note of 27 Sep; the TEST20 logs
  lost the crash line). TEST6's three early deaths also had no pad: the same screen, logs of the same length (~7,900
  lines), AV at eboot+0xa985af (thread Updat). At the time those were blamed on the copied save state.
- The trigger is the environment, but a PS4 game with no usable pad should not crash: this is an emulator bug worth its
  own look later. Every run with the pad registered passes that screen.

### 11. Game thread crash C: libc.prx + 0x1cb5e (new in TEST32)
- **Runs (1):** test32_1, thread defTS, about 7 s after the PlayGo TopRootWindow appeared (the same point as #5 in
  test30_6 and _8: 26 flatten_extended_userdata_pass lines in all three). defTS logs nothing before the crash line.
- None of the 13 archived logs with a `signals.cpp:144` ending is in libc.prx or on defTS. One run: it may belong to
  TEST32 or it may be rare; more runs will tell.
- **Needed in the log:** as for #5.

### 12. GPU fault just past the end of a staging buffer (new in TEST35)
- **Runs (1):** test35_1, in the first race, 79.7 s after InRaceRoot, no pause. EXIT 0x80000003 (device lost at submit,
  `vk_scheduler.cpp:245`).
- **The fault record:** `WriteInvalid 0xa6e200000`, 0 live and 0 unbound ranges on the page (8528 binds / 3194 unbinds
  searched). The nearest live range below ends exactly at the page: Buffer "StagingBufferPool:Dedicated",
  0xa62200000-0xa6e1fffff (192 MiB), bound 117.6 ms before the report; nothing live above it. So the GPU wrote the
  first page past the end of a staging buffer bound 0.12 s earlier. nvlddmkm 153 only (no 13). No other archived log
  on disk has a WriteInvalid address other than 0x0 and the class-2 hole, or a staging buffer next to a fault.
- **The buffer:** `StagingBufferPool::RequestLarge` (vk_staging_buffer_pool.cpp) makes a "Dedicated" buffer
  RoundAllocationSize(size) long (step = bit_floor(size) / 4) and hands out a ref of the requested size; any request of
  160-192 MiB gets exactly 192 MiB. The only `page_manager.cpp:141` line of the run, 245 ms (15 ticks) before the
  device lost, tracks 0x4437607000 - 0x444209d000 "not fully GPU mapped" = 178,872,320 B (170.6 MiB), a size in that
  range. That is a size match, not proof that the two belong together.
- **Around it:** the last recorded draws are the class-1 end-of-frame set (fs 0x4e0b9acd / es 0x72d3a762 / gs
  0x227b3323, fs 0xabe48410e49af89f, then draw indexed fs 0x9c23f9ea / vs 0x8167a22c), and the work-context line names
  draw count 4 fs 0x5ad38338 / vs 0xfa3f5430; but there is no 8->48 copy and no nvlddmkm 13, so it is not #1 as
  defined.
- **New in TEST35 that touches sizes or memory:** 0ca8528f (image sizes of thick mips) and #5193 (sparse arena offsets,
  barriers after writes, texture-cache GC floors). One run so far.
- **Needed in the log:** for each dedicated staging request, the requested size, the buffer size, and what the ref is
  used for (the image or buffer, the copy regions with their buffer offsets and extents).

### 13. SurfaceFormat assert (reopened in TEST37)
- **Runs:** test37_1 (46/0), test37_2 (19/9), test37_3 (`:428`, 12/0): TEST37 reverts the T# check, and its dead-slot
  pass never ran (skipped with patch_shaders on). Before TEST22: test10_1, test18_5 (`:428` ComponentSwizzle, in its
  crash record), test19b_1, test21_1, _3, _4 and test21m_3 (19/9 and 44/0).
- **test37_1:** EXIT 0x80000003 at 118 s, in the PlayGo menus. `liverpool_to_vk.cpp:788` "Unknown data_format=46 and
  num_format=0"; the GT_DIAG context lines: image #0 of the Fragment stage during texture binding, a T# with
  data_format 46, num_format 0, type 12, size 3603x4276x812; the draw: count 3, instances 1, fs 0x2a265dff, vs
  0x610d64f. Just before it: `Compiling fs shader 0x2a265dff (permutation)` and its graphics pipeline.
- **The link to #4 and #7:** the same shader and the same slots: in #4 image 0 of fs 0x2a265dff is at address 0, in #7
  image #1 of it holds float data read as a T#.
- **TEST39 (the pass runs), 2 runs, none of these asserts.** Its guard log has what this section asked for: images #0
  and #1 and sampler #0 of fs 0x2a265dff hang on one condition, flat-buffer dword 50, which read 0 at the first bind
  and never changed in either run (one decision per run), so all three were dead and bound null at every bind; image
  #2 has no guard and is bound (a 1920x1080 D32S8 depth image). The shader compiled once per run (24-39 times in
  TEST37). Next: more TEST39 runs; #4, #7 and #13 all go through these two slots.

## Fixed (for reference)

| crash | runs | fix |
|---|---|---|
| `info.h:183` PushUd, 17 user-data registers in one draw | test27b f2a5983c 2-5, pr5166 1, test28_3 | TEST30 600bce36 (flat buffer when the push slots are full). Verified: test30_7 (the in-race draw) and test30_10 (the pause draw of T27b r4) passed. TEST32 2ccb31e0 (PR #5181 review: all user data from the flat buffer, the assert removed): test32_5 ran both T27b pause draws (vs 0x7bab5d15 and vs 0xdbbb8a3c), pause menu correct; test32_7 ran vs 0xdbbb8a3c again. The 22:42 TEST30 comparison run ran vs 0x7bab5d15 (hs 0x27d2194a permutation) without stopping, the first TEST30 run to reach that draw. MERGED: #5181 in main 29 Sep 20:36:59Z (8c91be2b); its head 5d6c51d8 has the same patch-id as TEST32's two user-data commits together (3bc09423..2ccb31e0, 10 files +23/-66), so main carries the code TEST32 ran |
| stall: LDS `Map` without `Commit` | lab runs | #5070 (merged) |
| `hull_shader_transform.cpp:479` "patch addr non imm" (hs 0x27d2194a) | test11 | #5169 readlane (merged) |
| device lost at SDRSettingRoot (`vk_presenter.cpp:1113` "Device lost during waiting for a frame") | test4_2, test4_3, clean171_07; test20b_6, _7 (built with the preload fix reverted) | #5155 preload fix (open PR, in the test build) |
| `liverpool_to_vk.cpp:394` MipFilter unreachable (garbage S#) | test8, test8_2 | #5137 (MERGED 29 Sep 20:36:44Z, 1a0f5be8; the same patch as TEST32's 901d6daa) |
| `liverpool_to_vk.cpp:788/792` SurfaceFormat 19/9 and 44/0; `:428` ComponentSwizzle | test10, test18_5 (`:428`), test19b_1, test21_1, _3, _4, test21m_3 | the T# check (TEST22-TEST36, 175fa0c4 in TEST31); TEST37 reverts it (22105b66) and the assert is back as #13 (test37_1) |
| `image_info.cpp:184` BC in macro-tiled modes | test20a_8 and older | "texture_cache: Allow block-compressed images in macro-tiled modes" (in the test build; the full per-mip fix is still to do, HANDOFF section 5.3) |
| GPU thread silent at BuddyDummyRoot | test27b pr5165 1, 2, pr5166 1 (first builds) | our own instrument (hash through the guest address); the rebuild reads through `BackingPages()` |

## Older builds only (not seen on the current line)
- 0xC0000096 (privileged instruction) at eboot+0x26e443d: test4_4.
- `image_info.cpp:300` assert: clean171_13.
- 0xC0000005 inside the emulator's own code on the GPU thread, no assert: test9_2. Not a separate crash: the 26 Sep
  notes put it with the other TEST9 border-colour crashes, which #5137 fixed.
- GT7 1.00 lab: the "PCL Event" thread dies when `BreakFaultLoop` refuses a second fault streak (run 349b, precise
  readbacks). Parked.

## Suggested order
0. **More TEST39 / TEST40 runs.** The pass nulls images #0 and #1 of fs 0x2a265dff at every bind, the two slots #4, #7
   and #13 come through (none of the three in 4 runs so far, and no S# / T# rejection at all); more runs show whether
   they are gone and that nothing regresses. TEST40's check adds a direct test of every dead verdict: 0 HITs in 224
   and 449 modules with a dead slot in runs 1 and 2.
1. **#2 the 64 KiB hole.** The most runs overall (3 of the 7 TEST35 runs, all before the race), and now a precursor in
   all 17 logs with the address and in no other ending: a zero-size texture-cache track or untrack at 0x3f80000000,
   0.05-0.10 s before the fault, from one of two calls (`TrackImage` or `UntrackImageTail`). One log line at that call
   names the image; that is the next log ask.
2. **#4 Protect address 0.** Nine runs (two of the four TEST34 runs), the whole chain is in the log, one known draw, one
   binding. The fix direction can be tested with a single commit.
3. **#1 address-0 GPU fault.** Sixteen runs, and the 8-to-48 layer copy comes one or two frames before it in all 10 logs
   with a report and in no other ending. First the log lines for that copy, then a test.
4. **#7 tile mode.** The log now names the resource: a descriptor slot of fs 0x2a265dff that holds floats, and a T#
   check that does not test the tiling index. It shares its draw with #4.
5. **#3 PM4 type 0, #5 / #6 / #11 game thread crashes:** each first needs the log lines listed above.
   #6 is the easiest of these to catch: it comes 9.0-10.4 s after a race start.
6. **#12 the staging-buffer overrun (new in TEST35, one run):** first the log lines listed in its section; it is worth
   knowing early whether 0ca8528f or #5193 brought it.
