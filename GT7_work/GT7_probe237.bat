@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 237 - CRASH FRONT: the real fix for the tessellation hang. GT_SKIP_TESS goes OFF,
REM GT_LOOP_WRAP_GUARD=1 comes on (one conceptual change: the diagnostic skip is replaced by
REM the fix).
REM
REM RUN 236 FINDINGS (logs/run236_skiptess_stuck.txt):
REM   *** CONVICTION LOCKED: with tessellation draws skipped the game CANNOT die. ***
REM   - 262,144+ tess draws skipped; no device lost, no exception, full session alive.
REM   - Main game reached car select, browsed cars, "stuck" turned out to be a slow load that
REM     recovered by itself. Letters render in the MAIN GAME UI too.
REM   - The cost: GT7 tessellates the CAR BODIES - the preview car is a grey silhouette
REM     (wheels/glass/light strips still draw, the tessellated panels do not).
REM   - Race active 14-15 FPS; PAUSED drops to 6-7 (the pause blur/UI stack is render-bound -
REM     the wash front, unchanged).
REM
REM THE HANG MECHANISM (from hs_0x3827418d's own SPIR-V, GT7_work/shaders/hs_3827418d.spvasm):
REM   The control-point loop is a do-while whose counter DECREMENTS by 1 with exit test
REM   `counter != 1`. Real hardware always gets count >= 1 from the game. Under the emulator
REM   the count can arrive 0 (first-GPU-read-zeros: the SRT/flatbuf page is unregistered at
REM   loading time), and 0 != 1 wraps the counter through the full 32-bit range: 4.3 BILLION
REM   iterations x 6 SSBO loads = the draw that never retires = the device loss. That is why
REM   it always died at loading moments.
REM
REM WHAT GT_LOOP_WRAP_GUARD=1 DOES: an IR pass rewrites INotEqual(counter,C) loop exits into
REM UGreaterThan(counter,C), ONLY when the counter is a phi that provably decrements by one
REM and C <= 4. Identical iteration count for every value a real console can produce; in the
REM wrap case the loop exits after one pass instead of 2^32. Log: "[loopguard] shader ...".
REM
REM VERDICT METRICS:
REM   1. Car bodies BACK (preview car has paint, races have real cars).
REM   2. No device lost at race entry / car change / loading bursts (was 100% before).
REM   3. grep [loopguard]: how many shaders carried the wrap-prone shape.
REM   4. First frames after loads may still show garbage tess geometry (the DATA is still
REM      zeros until the page registers - that is the next front, not this one).
REM
REM PLAY: main game -> World Circuits -> enter a race, drive a few minutes; change cars in
REM the garage; then a Music Rally lap. Note FPS and the car bodies.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 237: wrap-proof loop exits (tess draws back on)

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
set GT_THREAD_PROF=2
set GT_SLEEPQ_MUTEX=1
set GT_STALL_DUMP=1
set GT_DETILE_CHUNK=262144
set GT_SKIP_TESS=0
set GT_LOOP_WRAP_GUARD=1
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
