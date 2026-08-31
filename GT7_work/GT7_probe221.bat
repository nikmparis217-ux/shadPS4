@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 221 - HOT-PAGE PINNING. Play ~2 min menu + the first Music Rally race.
REM
REM Run 220's verdict pair:
REM   - GT_DIRECT_IMPORT never served a byte: every query (up to 1888/window) was rejected as
REM     "cached" - the hot ranges ALREADY have cached buffers, because the write->upload cycle
REM     is what created them. The switch stays on here only for its telemetry; it is inert.
REM   - The ping-pong is intact and concentrated: one 1 MiB range took 20,337 write faults in
REM     a single 2 s window (80x its 256 pages), with 0.7-1.0 s of protection work per window
REM     in-race even after run 219's parallel protections.
REM
REM GT_HOT_PIN attacks the cycle itself with today's snapshot semantics unchanged: a page that
REM faults AGAIN within one decay interval is caught in the write->upload->reprotect->fault
REM loop and gets PINNED - it stays CPU-dirty, is never re-protected, uploads on every bind,
REM and never faults again. Pins are earned by two REAL faults (never speculative - the
REM run-211/213 stale-upload poison cannot occur) and decay every third sweep so cooled pages
REM stop re-uploading. The BIND_SKIP gate is bypassed for windows holding pins, or it would
REM skip the very uploads a pin promises.
REM
REM PRIMARY VERDICTS:
REM   1. [protprof] claimed faults in-race: 51-57k/window must COLLAPSE if pins catch the storm.
REM   2. [pinprof]: pages pinned per window, and page-marks kept dirty (the re-upload traffic).
REM   3. [spanprof] copies/KiB: the price - how much extra upload bandwidth the pins cost.
REM   4. FPS at scene entry and after 30 s; checkerboard delay; audio; any new artifact
REM      (a stale-texture artifact here would mean a pinned page feeding something that needed
REM      the fault to invalidate - report it, the log will name the range).
REM
REM The daily driver GT7_rtshape.bat is unchanged until this run passes.

title GT7 - run 221: pin the ping-pong pages

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
set GT_HOT_PIN=1
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
