@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 213 - THE CLIPPED WIDENING. Play ~2 min menu + ~1 min race.
REM
REM Run 212 delivered both verdicts:
REM   [hostimport] VERDICT OK - the driver imports the guest backing and gives it a BDA
REM     (memoryType 2, HostVisible|HostCoherent). Stages 4-5 are licensed; probe stays off now.
REM   [widetbl] CONFIRMED - the stale-upload mechanism caught in the act: widened marks swept
REM     pages holding cs_018256c0's GPU-written record buffers (5 distinct ranges named), and
REM     the game died on a null-deref consuming the poisoned records (run 211 died as a device
REM     hang on the same root).
REM
REM This build CLIPS the widen around every noted suspect range: those pages keep the old
REM exact-fault behavior, everything else gets the 20-100x fault collapse run 211 measured.
REM If this run survives the race, GT_FAULT_WIDE graduates to the daily driver; if it crashes
REM WITH [widetbl] "clipped" lines and a fresh signature, another BDA-store target exists and
REM the T# table harvest is the next site.
REM
REM The daily driver GT7_rtshape.bat stays safe (GT_FAULT_WIDE=0) until this run passes.

title GT7 - run 213: fault widening clipped around GPU record buffers

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
set GT_HOSTIMPORT=0
set GT_FAULT_WIDE=65536
set GT_CB_TRACE=
set GT_WATCH_VA=0
set GT_WATCH_SIZE=0

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo ================================================================
pause
