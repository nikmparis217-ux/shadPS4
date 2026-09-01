@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is "Nikos" in Greek and cmd.exe reads this
REM file in the OEM codepage, so a real path here would be mangled and "not found".
REM
REM Double-click for the GT_IMGARRAY_SYNC PROOF RUN (Act 11): before every windowed bake
REM dispatch whose T# table reads null, the emulator flushes, waits for the GPU, copies the
REM table back into guest RAM and re-reads it. EXPECT SINGLE-DIGIT FPS - this run exists to
REM prove the mechanism (grep "[imgsync]" in the log: "valid 1/16 -> 16/16" = proven), and
REM to check by eye that the wash is reduced and the track preview is no longer solid red.
REM Config is otherwise byte-identical to a plain -Net run (one variable per run).
REM
REM Set-GtDefault in run_gt7.ps1 lets a parent-shell value win, so setting it here is the
REM supported way to flip one knob for one run.

title GT7 - IMGARRAY SYNC proof run (launcher bypassed)

set GT_IMGARRAY_SYNC=2

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo  If it said "Close these first", close shadPS4QtLauncher and retry.
echo ================================================================
pause
