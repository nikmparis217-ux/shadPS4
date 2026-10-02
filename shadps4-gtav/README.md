# shadPS4 tests: Grand Theft Auto V (CUSA00411)

This folder is the GTA V line of the shadPS4 tests: its launchers, exes, profile and logs. Each
game has its own folder: `C:\shadps4-gow`, `C:\shadps4-got`, `C:\shadps4-gtav`; GT7 stays in
`C:\shadps4-gt7\GT7_upstream`. Every test exe is built in `C:\shadps4-clean` (ninja only) as
upstream main + our fixes that main does not have + the GT_* log tools, and TEST(n) = TEST(n-1) +
one commit. The user starts every run.

## TEST2 (2 Oct 2026, built 14:00): the GPU check GT_GUARDCHECK

- Branch `gtav-test2-main-d9cf41ba` e8a9f602 = TEST1 7d09a8a8 + one [test] commit, "[test] Have
  shaders report through GT_GUARDCHECK any read of an image or sampler their compile judged dead".
  GoT runs the same commit and exe (`got-test2-main-d9cf41ba`); GoW carries the same commit on its
  TEST1 (TEST2 6b19950f), GT7 on its TEST39 (TEST40 07a74022).
- What it checks: the resource-guard fix nulls the images and samplers a draw cannot read. With
  GT_GUARDCHECK set, a shader with resource guards gets a small storage buffer, and every read of a
  slot its compile nulled first sets a bit in it, in the same block as the read. So the bit is set
  only if the GPU really executes such a read, i.e. only when the verdict was wrong. After each
  submit the emulator logs each new bit as `[GT_DIAG] guardcheck HIT: <stage> <hash> perm <n> ...`
  (Error), and a `[GT_DIAG] guardcheck: ... modules compiled ... hits and ... canaries so far`
  summary at most every 60 s. Expected: no HIT.
- GT_GUARDCHECK=2 also logs `[GT_DIAG] guardcheck canary` lines: the live image reads of the first
  4 modules with resource guards set a bit too, which shows that a write of the GPU reaches the log.
- While GT_GUARDCHECK is set the emulator neither reads nor writes the pipeline cache, and the frame
  rate of a check run is not comparable with other runs.
- What there is to check: in TEST1 r3 and r4 (fix on) the `[GT_DIAG] guardsum` lines counted
  **0 shaders with guards** up to the hull-shader assert (`hull_shader_transform.cpp:395`, hs
  0xf74f71e4930a1c25) that ended r3-r5 with the fix on and with it off. Until a run gets past that
  assert, a TEST2 run has nothing to check: it should log the start-up `guardcheck:` line and no
  `guardcheck on` line or summary (the check buffer is made only when a shader with guards is
  bound).
- Exe `backup_exe\shadps4_gtav_test2_e8a9f602.exe`, 62,604,800 bytes, SHA256
  AB67D3663F164E317A2E538CC2C75DBB0CAF74D684C9ABD085D5777ECB04F48A. The exe and its pdb are side by
  side in `backup_exe\pdb_gtav_test2_e8a9f602`. Build log: `logs\games_test2_build.log` (0 errors,
  0 warnings).
- `GTAV_TEST2_e8a9f602_guardcheck_console.bat`: TEST1's fix-on launcher + GT_GUARDCHECK=1.
- `GTAV_TEST2_e8a9f602_guardcheck_canary_console.bat`: the same with GT_GUARDCHECK=2.
- Console and exit code: `logs\console_gtav_test2_<guardcheck|canary>_<time>.txt`; the previous log
  is copied to `logs\shad_log_gtav_test2_prelaunch_<time>.txt`. The TEST1 launchers stay.

## TEST1 (1 Oct 2026)

- Branch `gtav-test1-main-d9cf41ba` 7d09a8a8 = origin/main d9cf41ba + 15 commits. GoT runs the same
  commit and exe. GoW's TEST1 is 1c6cff84 since 1 Oct 16:13: this commit + the three GoW fixes
  (see `C:\shadps4-gow\README.md`).
  - Fixes: BC images in macro-tiled modes (a923e927); preload with each permutation's own flattened
    user data (d899672b); the tiled-texture set of PR #5196 (e5a7e3f7, d0dfe411, 664f621f); the
    resource-guard fix, which skips the images and samplers a draw does not read (c8408b45,
    2d7c711e).
  - Log tools: GT_DIAG (d85d47bb, f0d6db04, 743d79c2, 9c234bd2), GT_IMGDUMP_DIR (92919af1),
    GT_BINDLOG (76d902a9) and its guard log (3913017d), GT_GUARDLOG and GT_NOGUARDS (7d09a8a8).
  - Not in it: the T# check and SnormNz (dropped on 30 Sep).
- Exe `backup_exe\shadps4_gtav_test1_7d09a8a8.exe`, SHA256
  2037E1044D9F131FA3F0976F280EA5F6BF404EDF6E756BA0E5D9579E072D4028. The exe and its pdb are side by
  side in `backup_exe\pdb_gtav_test1_7d09a8a8`. The build log is `C:\shadps4-gow\logs\games_test1_build.log`.
- `GTAV_TEST1_7d09a8a8_fixon_console.bat`: the fix on, GT_DIAG=1, GT_GUARDLOG=1.
- `GTAV_TEST1_7d09a8a8_fixoff_console.bat`: the same exe with GT_NOGUARDS=1, the baseline without
  the fix.
- Both launchers start cold: the previous pipeline cache and shader dumps are moved to
  `cache_before_launch_<time>` and `shader_before_launch_<time>`. They copy the previous log to
  `logs\`, and write the console and exit code to `logs\console_gtav_test1_<mode>_<time>.txt`,
  shown live and colored in a second window.
- The game is `F:\PS4_Dumps\GTA_V_shadps4\CUSA00411`; the emulator overlays the v1.57 patch in the
  `CUSA00411-patch` folder next to it. The raw dump is in `F:\PS4_Dumps\GTA_V_CUSA00411_v1.57`.

## The profile

`user\` is the GoT TEST19B profile without its cache, log, shader dumps and save data:
patch_shaders off, dump_shaders on, log sync on, the same pad. There is no starting save, since no
build of ours has run this game before.

## Reading a run

    awk -f tools\runsummary.awk user\log\shad_log.txt

This prints the pad check, the GT_* switches, the compile counts, the guard decisions and totals,
what the old descriptor checks caught, the crash line and the top warning kinds. "Worse with the
fix" means a fix-on run ends earlier or worse than a fix-off run of the same exe.

## History

This is the first GTA V line; where TEST1 stops is the first result.
