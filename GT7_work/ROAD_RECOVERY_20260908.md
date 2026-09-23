# GT7 road recovery, 8 September 2026

## Use the September 8 reference, not the September 6 rollback

The user confirmed the road worked in a later run and asked us to inspect screenshot times.
Inspected the September 8 screenshot sequence, including both Music Rally attempts in run 305.
The display-calibration screen is a reference picture, not evidence of working gameplay.

| Evidence | Screenshot in `%APPDATA%/shadPS4/screenshots` |
|---|---|
| Textured road, lane markings and kerbs | `CUSA24769_20260908_204450_774_game_000093.png` |
| Road still present in the second attempt | `CUSA24769_20260908_204629_231_game_000131.png` |
| Missing road and stretched racing-line geometry | `CUSA24769_20260908_211830_640_game_000020.png` |

The first two belong to `logs/shad_log_run305_2026-09-08_firstplay.txt`, revision
`5d9ea8e5`, launched with probe 294's diagnostic settings. The third belongs to
`logs/shad_log_run306_2026-09-08_logfilter_restored.txt`, revision `73f3bb1e`, using
the reduced-diagnostic probe 305. These are both AFTER the upstream merge.
The good run still has other scenery defects; this reference establishes the road only.

## Concrete regression

`GtFrameProf::Flush()` returned immediately when `GT_FRAME_PROF` was off. It also owned
the `GT_READBACKS_ONRACE` detector and armed the runtime readback-mode switch. Probe 305
cleared `GT_FRAME_PROF` while leaving `GT_READBACKS_ONRACE=2`, silently disabling the fix.

The good run's log lines 47134 and 47140 record the switch at t=76 seconds, with 2454
colour indirect draws in the final qualifying window. The bad run has no `[readbacks]`
transition and starts with readbacks mode 0. This is a functional dependency on the
profiler, not evidence that debug-log timing itself caused this road regression.

The new `VideoCore::GtReadbacksOnRace` owns its own count and timer. `DrawIndirect`
feeds it outside profiling guards; `Rasterizer::OnSubmit` polls it independently of
`GtFrameProf::Flush`. The threshold remains three consecutive two-second windows with
more than 500 colour indirect draws. The switch still executes once on the GPU command
thread using the existing mode-setting and read-protection resynchronization sequence.
Depth-only boot draws do not trigger it. The gate remains opt-in.

## Build and test scope

Build the current branch (`1d0cd4d1` plus these uncommitted recovery changes), not a
detached checkout. Compared with good-run revision `5d9ea8e5`, the pre-existing C++ delta
is ONLY the `Sampler::MaxAniso` reserved-value fallback. Keep it: run 305 eventually
ended on the old `UNREACHABLE` in that function. The interpolation experiment is already
reverted in this branch. No shader arithmetic changes are part of this recovery.

`tests/video_core/test_gt_readbacks_onrace.cpp` exercises profiling-free activation,
two-second boundaries, exact draw threshold, interrupted windows, depth-only boot,
disabled mode, one-shot switching and frequent submits. It is a standalone C++ test
and is also registered in `tests/CMakeLists.txt`.

Probe 305 retains profiling OFF and its current behavior settings. Its header now
states the actual fix and expected log. Probe 294 is unchanged.

## Runtime verification procedure

Run `GT7_work/GT7_probe305.bat`, enter the same Music Rally / Alsace race, and compare
the new timestamped frames with the references above. Expect `[readbacks] ... switched
GPU readbacks mode 0 -> 2` despite no `[fprof]` messages. Timing depends on game progress.
The frame must show asphalt/kerbs, not merely reach gameplay.

The 21:53 and 22:05 guest wild jumps happened before the readback transition. This patch
does not establish their root cause or prove that they are fixed. The previous rollback
rebuilt `5d9ea8e5` at 21:45 then switched source back to the branch, leaving source and
executable mismatched and dropping the sampler crash fallback.

Previous exe/PDB, config, probe 305, and the 22:05 crash log are preserved under
`logs/recovery_before_20260908/`. No saved games, shader caches, drivers or network
configuration were cleared. The existing unrelated server log modification is untouched.

## Verified build

Standalone regression executable passed; emulator build exited 0 and linked successfully.
Exe: 73,814,016 bytes, built 2026-09-08 22:19:15 local time; matching PDB at 22:19:16.
SHA256: B96EB43A814C338FC1226B22EB22F136C62E491C560AEB736F2B106413716211.
Generated SCM identifies 1d0cd4d1-dirty, build date 22:18:03.
Build log: logs/build_305_readback_recovery_20260908.log.
Runtime confirmation followed in the 22:21 launch: see below.

## User-verified road checkpoint (22:24)

The user reported "great we fixed it" and provided four fresh images showing the road
present with the remaining scenery corruption. The matching live run, PID 7064,
identifies `1d0cd4d1-dirty`; log lines 42710/42727 show readbacks switching at t=50 s
(3312 colour indirect draws, 157 regions, 1129 CPU-dirty pages preserved).
There are no frame-profiler messages. This verifies the runtime dependency fix.

The next task is the stretched triangles, repeated scenery and missing distant surfaces.
Preserved the verified exe/PDB, probe and fresh 22:21-22:25 autoshots in
`logs/roadfixed_20260908_2219/`, along with a live log snapshot. Restore this checkpoint
if the road regresses. A complete final log still needs archiving when the user closes
the process; the checkpoint copy is explicitly a live snapshot.

