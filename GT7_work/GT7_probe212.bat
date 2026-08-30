@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 212 - TWO PROBES IN ONE RUN. This .bat EXPECTS a possible crash; that is the point.
REM Play ~2 min menu + ~1 min race, or until it dies - either way the log carries the answers.
REM
REM 1. GT_HOSTIMPORT=1 (unified-memory stage 1): at boot, import 64 MiB of the guest backing
REM    view via VK_EXT_external_memory_host, bind a buffer, ask for its device address, free
REM    it. [hostimport] VERDICT lines decide whether the import family (BDA-pagetable
REM    fallback = the fix for the 1s checkerboard + red minimap; in-place stream reads) is
REM    licensed or dead on this driver. Costs nothing after boot.
REM
REM 2. GT_FAULT_WIDE=65536 again, WITH the [widetbl] instrument armed: run 211 proved the
REM    widening collapses the protect storm 20-100x and then hung the device in cs_018256c0
REM    with no evidence of WHICH range the stale upload poisoned. The instrument remembers
REM    the dispatch's record-buffer ranges and logs [widetbl] the moment a widened range
REM    overlaps one - the mechanism caught in the act, BEFORE the hang. If it crashes again
REM    with [widetbl] lines, the mechanism is confirmed and stage 2's exclusion knows its
REM    target; if it crashes WITHOUT them, the theory is wrong and must be rethought.
REM
REM The daily driver GT7_rtshape.bat stays safe (GT_FAULT_WIDE=0) - use it for normal play.

title GT7 - run 212: host-import probe + widen evidence

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
set GT_HOSTIMPORT=1
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
