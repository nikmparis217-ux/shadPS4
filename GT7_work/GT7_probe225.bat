@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 225 - FIRST FIX FROM THE COMPLETED MAP: GT_STREAM_MEMO. Same switches as run 224 plus
REM GT_STREAM_MEMO=1 (the ONE behavior change) and two zero-behavior redundancy counters.
REM Play the usual: menus + the first Music Rally race. The pipeline cache is WARM this time
REM (no shader work was touched), so the pipe-compile spikes of run 224 should also be gone -
REM that part is the cache, not this change.
REM
REM RUN 224 VERDICTS (logs/run224_fullmap.txt) - the map is CLOSED:
REM   - The bill is a DISTRIBUTED tax, not one villain: ~2 us x 100-160k buffer binds +
REM     60-130k texture binds per 2 s window = 450-800 ms of a ~1400 ms busy GPU thread.
REM     bufscan 51-336 / bufemit 74-258 / imgscan 46-272 / imgemit 61-141 ms; samp free.
REM   - endr = 0 EVERYWHERE: EndRendering-per-dispatch acquitted. hle = 0. descpush 9-108 ms.
REM   - The "unnamed dispatch body" is the compute-side share of the SAME bind buckets
REM     (bindbuf/bindtex are accumulated inside the shared functions) - nothing new to name.
REM   - [obtprof] deflated the memcpy theory: the stream copies are 31-90 ms/window (95-220 MB)
REM     of an obtain bucket of 60-250 ms. Real, but not the champion on time alone.
REM   - pipe spikes 500-2400 ms were cold-cache pipeline compiles (the rebuild wiped the
REM     cache); the steady floor is 60-100 ms.
REM
REM WHAT THIS RUN CHANGES (GT_STREAM_MEMO=1):
REM   ObtainBuffer's read-only <=16K path memcpy'd the SAME guest ranges into the stream ring
REM   on EVERY bind. Now: (addr,size) -> offset memo, valid within one scheduler tick (one
REM   submit) and one ring wrap epoch. The IsRegionGpuModified guard stays UPSTREAM of the
REM   lookup, so GPU-written ranges never come out of the memo. Honest door, pre-declared: a
REM   CPU rewrite of an untracked read-only range WITHIN one submit serves the first bind's
REM   snapshot (a race on real hardware too). If NEW visual artifacts appear that runs
REM   222-224 did not have, that door is the suspect and GT_STREAM_MEMO=0 is the revert.
REM
REM VERDICT METRICS:
REM   1. [smemo] hits vs copies = the hit rate (the whole bet: how repetitive is the stream).
REM   2. [obtprof] "copy" ms should drop by ~the hit rate; [fprof] bufemit with it.
REM   3. [fprof] "redun: buf N tex N" vs binds = the run-226 design datum for a FULL bind
REM      memo (zero behavior, just counters this run).
REM   4. FPS + feel vs runs 222/223 (12 -> 5-6 baseline), wash/checkerboard/red-map unchanged.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 225: stream-copy memo + bind redundancy census

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
