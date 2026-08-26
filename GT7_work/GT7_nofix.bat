@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is "Nikos" in Greek and cmd.exe reads this
REM file in the OEM codepage, so a real path here would be mangled and "not found".
REM
REM EXPERIMENT B for the init stall (runs 166/167). Everything OFF - byte-for-byte the
REM pre-134b9428 behavior on the same binary:
REM   GT_LUT_IDENT=0      - no identity seeding.
REM   GT_HASH_BASELINE=0  - the clobber fix reverts to the upstream rule (baseline recorded
REM                         only on !is_gpu_dirty refreshes). Runtime-only, warm cache OK.
REM
REM Verdict table:
REM   boots to the menu  -> the core fix causes the stall; keep the gate, investigate.
REM   stalls again       -> the fix is innocent: the stall is environmental (the init
REM                         phase was already flaky - it crashed there pre-fix too, and
REM                         RenderDoc injection used to slow everything down).

title GT7 - EXPERIMENT B: seed OFF, clobber fix OFF (pre-fix behavior)

set GT_LUT_IDENT=0
set GT_HASH_BASELINE=0
set GT_WATCH_VA=101e400000
set GT_WATCH_SIZE=200000

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo  If it said "Close these first", close shadPS4QtLauncher and retry.
echo ================================================================
pause
