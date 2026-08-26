@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is "Nikos" in Greek and cmd.exe reads this
REM file in the OEM codepage, so a real path here would be mangled and "not found".
REM
REM EXPERIMENT A for the init stall (runs 166/167: intro flips, then the game submits ASC
REM compute forever and never flips again). Single variable vs GT7_lutident.bat:
REM   GT_LUT_IDENT=0  - no identity seeding, so the seed's new side effects (marking the
REM                     seeded LUTs GpuModified + recording their baselines) are OFF.
REM   GT_HASH_BASELINE stays at its default '1' - the core clobber fix stays ON.
REM
REM Verdict table:
REM   boots to the menu  -> the seed path is the culprit; the core fix is fine.
REM   stalls again       -> run GT7_nofix.bat (experiment B).

title GT7 - EXPERIMENT A: seed OFF, clobber fix ON

set GT_LUT_IDENT=0
set GT_WATCH_VA=101e400000
set GT_WATCH_SIZE=200000

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo  If it said "Close these first", close shadPS4QtLauncher and retry.
echo ================================================================
pause
