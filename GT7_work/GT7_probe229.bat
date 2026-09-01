@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 229 - PERF FRONT: name the CPU hog. Same switches as run 228 (GT_CLEAR_RAW stays - the
REM red map is FIXED, verified by the user and by the "[clear] comp_swap-sensitive" log) plus
REM GT_THREAD_PROF=1, a pure INSTRUMENT: every 5 s one "[tprof]" line names every thread
REM burning more than 2% of a core (GetThreadTimes + thread names), plus the process total.
REM This answers the question run 198 died on: WHICH threads peg 11-12 cores while the GPU
REM sits at 20%/210 MHz - game's own emulated code, pipeline creation, fault processing,
REM or the DMA rescan.
REM
REM PLAY: menu first, then START A RACE and drive 2-3 minutes (the FPS decay needs the scene
REM to load in), then quit. The tprof timeline across menu -> loading -> driving is the data.
REM
REM VERDICT METRICS:
REM   1. The [tprof] table at the decayed-FPS phase: which named threads hold the cores.
REM   2. proc% vs sum of named threads (a gap = many small unnamed threads).
REM   3. Red map stays fixed (GT_CLEAR_RAW regression check for free).
REM   4. No FPS change from the instrument itself (5 s cadence, negligible).
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 229: thread census (who burns 12 cores)

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
set GT_STREAM_MEMO=1
set GT_RESOLVE_SWAP=1
set GT_CLEAR_RAW=1
set GT_THREAD_PROF=1
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
