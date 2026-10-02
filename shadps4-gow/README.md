# shadPS4 tests: God of War (CUSA07411)

This folder is the God of War line of the shadPS4 tests: its launchers, exes, profile and logs.
Each game has its own folder: `C:\shadps4-gow`, `C:\shadps4-got`, `C:\shadps4-gtav`; GT7 stays in
`C:\shadps4-gt7\GT7_upstream`. Every test exe is built in `C:\shadps4-clean` (ninja only) as
upstream main + our fixes that main does not have + the GT_* log tools, and TEST(n) = TEST(n-1) +
one commit. The user starts every run.

## TEST2 (2 Oct 2026, built 13:56): the GPU check GT_GUARDCHECK

- Branch `gow-test2-main-d9cf41ba` 6b19950f = TEST1 1c6cff84 + one [test] commit, "[test] Have
  shaders report through GT_GUARDCHECK any read of an image or sampler their compile judged dead".
  GoT and GTA V carry the same commit on their TEST1 (TEST2 e8a9f602), GT7 on its TEST39 (TEST40
  07a74022).
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
- What there is to check: TEST1 r2 (fix on) logged 106 shaders with guards, 81 of them with a dead
  set at some bind, before the GPU hang (nvlddmkm 153) that ended all three TEST1 runs, fix on and
  off; a TEST2 run is expected to end there too.
- Exe `backup_exe\shadps4_gow_test2_6b19950f.exe`, 62,615,040 bytes, SHA256
  E3D6193AB1685A5477FD3A3E3DB42634BD59A751EB354E23FD3111E0ADEBB8F4. The exe and its pdb are side by
  side in `backup_exe\pdb_gow_test2_6b19950f`. Build log: `logs\gow_test2_build.log` (0 errors,
  0 warnings).
- `GOW_TEST2_6b19950f_guardcheck_console.bat`: TEST1's fix-on launcher + GT_GUARDCHECK=1.
- `GOW_TEST2_6b19950f_guardcheck_canary_console.bat`: the same with GT_GUARDCHECK=2.
- Console and exit code: `logs\console_gow_test2_<guardcheck|canary>_<time>.txt`; the previous log
  is copied to `logs\shad_log_gow_test2_prelaunch_<time>.txt`. The TEST1 launchers stay.

## TEST1 (1 Oct 2026, built 16:13), with the GoW fixes

- Branch `gow-test1-main-d9cf41ba` 1c6cff84 = origin/main d9cf41ba + 18 commits: the 15 commits of
  7d09a8a8 (which is still the GoT and GTA V TEST1) + the three GoW fixes, cherry-picked from their
  local branches:
  - f6258522 = `tg-size-sgpr` b89a2772: compute shaders get the thread group size SGPR;
  - 0a8c27c2 = `ds-ordered-count` a1af1159: DS_ORDERED_COUNT;
  - 1c6cff84 = `tsharp-dw1-mask` dc08b752: a T# dword1 masked with an immediate.

  Each pick has the same lines as its source. Only the cache versions differ (ShaderBinaryVersion
  8, ShaderMetaVersion 10), and the T# mask field comes before the guard field in ImageResource.
- The other fixes, as in 7d09a8a8: BC images in macro-tiled modes (a923e927); preload with each
  permutation's own flattened user data (d899672b); the tiled-texture set of PR #5196 (e5a7e3f7,
  d0dfe411, 664f621f); the resource-guard fix, which skips the images and samplers a draw does not
  read (c8408b45, 2d7c711e).
- Log tools: GT_DIAG (d85d47bb, f0d6db04, 743d79c2, 9c234bd2), GT_IMGDUMP_DIR (92919af1), GT_BINDLOG
  (76d902a9) and its guard log (3913017d), GT_GUARDLOG and GT_NOGUARDS (7d09a8a8).
- Not in it: the T# check and SnormNz (dropped on 30 Sep).
- Exe `backup_exe\shadps4_gow_test1_1c6cff84.exe`, 62,605,824 bytes, SHA256
  B142D73C6660CE19E2EF8FBA0205AF121849C2896878F0CC73072C036C88E07E. The exe and its pdb are side by
  side in `backup_exe\pdb_gow_test1_1c6cff84`. Build log: `logs\gow_test1_build.log` (0 errors,
  0 warnings).
- `GOW_TEST1_1c6cff84_fixon_console.bat`: the resource guards on, GT_DIAG=1, GT_GUARDLOG=1.
- `GOW_TEST1_1c6cff84_fixoff_console.bat`: the same exe with GT_NOGUARDS=1, the baseline without the
  resource-guard fix. The three GoW fixes are on in both launchers.
- Both launchers start cold: the previous pipeline cache and shader dumps are moved to
  `cache_before_launch_<time>` and `shader_before_launch_<time>`. They restore the save from
  `save_start\CUSA07411`, copy the previous log to `logs\`, and write the console and exit code to
  `logs\console_gow_test1_<mode>_<time>.txt`, shown live and colored in a second window.
- What to expect: GOW3 (27 Sep, the same three fixes on main 8151ee25) compiled cs 0x38c7b95b with
  0 `Unknown opcode`, reached about 320 shaders and the Sony splash, then hit a GPU timeout
  (nvlddmkm 153, `Device lost during submit`, vk_scheduler.cpp:242) about 27 s after cs 0x38c7b95b
  first compiled.
- The first TEST1 build (7d09a8a8, without the GoW fixes) was deleted before any run, by the
  user's decision: without DS_ORDERED_COUNT it would have stopped about 50 shaders in, as TEST3 and
  TEST19B did. Its build log `logs\games_test1_build.log` stays here because GoT and GTA V still
  run that exe.

## The profile

`user\` is the TEST19B GoW profile without its cache, log and shader dumps: patch_shaders off,
dump_shaders on, log sync on, the same pad. Its config.json differs from GOW3's only in
patch_shaders (on in GOW3). `save_start\` holds the save every run starts from.

## Reading a run

    awk -f tools\runsummary.awk user\log\shad_log.txt

This prints the pad check, the GT_* switches, the compile counts, the guard decisions and totals,
what the old descriptor checks caught, the crash line and the top warning kinds. "Worse with the
fix" means a fix-on run ends earlier or worse than a fix-off run of the same exe.

## History

- The GoW fixes stay as one-commit local branches for future PRs: `tg-size-sgpr` b89a2772,
  `ds-ordered-count` a1af1159 (built on top of tg-size-sgpr) and `tsharp-dw1-mask` dc08b752. TEST1
  carries cherry-picks of them. With all three, GOW3 (27 Sep) reached 320 shaders and the Sony
  splash, then hit a GPU timeout (nvlddmkm 153, device lost).
- Older launchers (TEST3, TEST19B, GOW1-3) are copied in `old_tests\`, pointing at
  `C:\shadps4-archive`. Their exes and logs are in `C:\shadps4-gt7\GT7_upstream\backup_exe` and
  `\logs`.
