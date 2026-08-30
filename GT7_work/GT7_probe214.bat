@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 214 - THE HEAL. Play ~2 min menu + ~1 min race.
REM
REM Run 213 (the clip) still hung the device at race load, and the work journal named the
REM same dispatch again: DispatchDirect 0x18256c0, tick frozen with 3331 submits behind it.
REM The post-mortem found the structural hole: the record V#s are BINDINGS 0/1, obtained
REM (and their poisoned upload recorded) BEFORE the flatbuf branch where the suspects were
REM noted - so the table could never save the CURRENT dispatch, and the fatal widen landed
REM during the race-load storm (31.8k faults / ~2 GB widened in one 2 s window) on an
REM address the table had not seen yet.
REM
REM This build HEALS instead: before any binding of cs_018256c0 is obtained, the speculative
REM CPU-dirty marks a widen left on its record pages are CLEARED ([healtbl] logs each one),
REM so the stale upload is never recorded at all. Safe because pre-widening stability proves
REM the game does not CPU-write those pages between producer and consumer.
REM
REM If this run survives the race, GT_FAULT_WIDE graduates to the daily driver. If it hangs
REM again on 0x18256c0 WITH [healtbl] lines, the poison reaches the records through yet
REM another door and the widening experiment gets parked in favor of stages 3-4.
REM
REM The daily driver GT7_rtshape.bat stays safe (GT_FAULT_WIDE=0) until this run passes.

title GT7 - run 214: heal the record pages before the bind

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
