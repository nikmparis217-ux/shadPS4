@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 222 - REVERT TO THE RUN-220 CONFIG. Play ~2 min menu + the first Music Rally race.
REM
REM Run 221's verdict: GT_HOT_PIN is REFUTED BY ITS OWN MEASUREMENT, twice over.
REM   - It did its stated job: claimed faults collapsed (51-57k -> 1.5-8k per window) and
REM     protection work collapsed (0.7-1.0 s -> 10-90 ms per window).
REM   - But the price was catastrophic: 2-3.4 MILLION page-marks kept dirty per window
REM     ([pinprof]) turned into 226k-417k copies / 5.7-13.7 GB per 2 s window ([spanprof]),
REM     with memcpy alone at 850-1300 ms per window. FPS fell 7-8 -> 2 in the MENUS.
REM   - The measured ratio: a hot page is BOUND ~60-100x more often than it FAULTS. Any
REM     scheme that uploads per bind instead of per write loses by that factor. The fault
REM     ping-pong is not waste - it is the cheap change detector, and the cycle is the
REM     game's steady-state streaming pattern.
REM   - Correctness too: the screen washed out white. A pinned page re-uploads CPU bytes on
REM     every bind, clobbering GPU-written data sharing the same 4 KiB page (the ~gpu guard
REM     only checks pin-time state, and BDA writes are invisible to the tracker anyway) -
REM     the run-211/213 poison class served through a new door.
REM
REM GT_HOT_PIN=0 here restores run 220's behavior bit for bit (the code is env-gated).
REM
REM WHAT THIS RUN ANSWERS:
REM   1. FPS back to 7-8? (confirms the regression was the pins and nothing else)
REM   2. Is the washed-out white GONE? Gone = the pin clobber was its mechanism, case
REM      closed. Still there = it predates run 221 and joins the checkerboard/red-map
REM      open cluster.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 222: revert hot-pin, back to the run-220 config

set GT_RT_NOCLOBBER=0
set GT_LUT_IDENT=0
set GT_IMG_TRACE=0
set GT_VERTICAL_ALIAS=1
set GT_GPUWRITE_NOCLOBBER=0
set GT_SPLIT_DISPATCH=1
set GT_18256C0_GUARD=1
set GT_18256C0_LOOP_MAX=1024
set GT_DMA_DIRTY_LOG=1
set GT_BIND_SKIP=1
set GT_TEXEL_MEMO=1
set GT_FRAME_PROF=1
set GT_FAULT_HIST=1
set GT_FAST_PROTECT=1
set GT_HOSTIMPORT=0
set GT_BDA_IMPORT=1
set GT_DIRECT_IMPORT=1
set GT_HOT_PIN=0
set GT_FAULT_WIDE=0
set GT_CB_TRACE=
set GT_WATCH_VA=0
set GT_WATCH_SIZE=0

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo ================================================================
pause
