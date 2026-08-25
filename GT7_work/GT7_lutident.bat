@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is "Nikos" in Greek and cmd.exe reads this
REM file in the OEM codepage, so a real path here would be mangled and "not found".
REM
REM Double-click for the GT_LUT_IDENT run (Act 11 step 2): every 64^3 RGBA16F volume the game
REM creates is seeded with an IDENTITY grading LUT instead of uninitialized guest RAM. The
REM output transform lerps every pixel toward that LUT with a per-frame weight (measured:
REM three RenderDoc captures of one PAUSED frame - identical inputs, output min 0.005 ->
REM 0.054 -> 0.42), so identity turns the blend into a no-op. EXPECT: the white wash GONE,
REM the paused-frame pulsing GONE, the track preview no longer solid red. Normal fps.
REM
REM The same run also arms the LUT-writer hunt: [lut3d] logs every 64x64x64 image bind and
REM [vawatch] logs everything touching the LUT's guest range (0x101e400000, from Act 10's
REM RenderDoc). Grep the log for "[lutident]", "[lut3d]", "[vawatch]" afterwards.
REM
REM Run 161 findings folded in: the LUT baker EXISTS (cs_0xf04a69f0, one WRITE bind at
REM load), the second LUT (0x101e600000) is never written by anything, and the user
REM correlated the wash episodes live with cs_da05e7f8's [imgtrace] bursts - the probe
REM NaN flood GT_IMGWRITE_SCRUB was built for. That scrub is now ON via run_gt7.ps1
REM default (it was never set before - off since the day it was written).
REM
REM Set-GtDefault in run_gt7.ps1 lets a parent-shell value win, so setting knobs here is the
REM supported way to flip them for one run.

title GT7 - LUT IDENTITY run (launcher bypassed)

REM GT_LUT_DUMP stays OFF now: its one job is done (it proved the baked LUT holds the
REM CORRECT tone curve rotated one channel right - alpha in R, RGB slid into GBA), and
REM each dump is a mid-bind pipeline drain nothing should pay for in a play run.
set GT_LUT_IDENT=1
set GT_WATCH_VA=101e400000
set GT_WATCH_SIZE=200000

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo  If it said "Close these first", close shadPS4QtLauncher and retry.
echo ================================================================
pause
