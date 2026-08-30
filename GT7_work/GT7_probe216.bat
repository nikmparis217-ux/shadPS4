@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 216 - SERIALIZED IMPORTED-BDA PAGE-TABLE UPDATES.
REM
REM Run 215 proved that GT_BDA_IMPORT was active and reduced the old write-fault/protection
REM storm from roughly 10k-20k faults per two seconds to tens/hundreds. It did NOT improve the
REM one-second checkerboard/image delay, audio stutter, FPS decay, wash, or red map. Those are
REM separate open problems.
REM
REM Run 215 also exposed a new deterministic host crash when the first race was selected. The
REM map logs proved that Game:Main and FWRKR were calling WriteDataBuffer/Fill on the Vulkan
REM scheduler's command buffer concurrently with shadPS4:GpuCommandProcessor. The crash ended
REM in two simultaneous host/driver access violations. This build queues guest map/unmap events
REM on their producer threads and records every BDA page-table update only from BindResources on
REM the GPU command-processor thread.
REM
REM PRIMARY VERDICTS:
REM   1. Boot log must contain "[bdaimport] ACTIVE".
REM   2. Every "[bdaimport] mapped" line must name shadPS4:GpuCommandProcessor and end in
REM      "[GPU thread]"; Game:Main/FWRKR must never record one.
REM   3. Enter the first Music Rally race. The run-215 dual host access violation should be gone.
REM   4. Record FPS at first scene appearance and after 30 seconds. The checkerboard delay, audio,
REM      wash, and red map are expected to remain unchanged in this isolation run.

title GT7 - run 216: serialized imported-BDA updates

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
set GT_BDA_IMPORT=1
set GT_FAULT_WIDE=0
set GT_TEX_GC=1
set GT_CB_TRACE=
set GT_WATCH_VA=0
set GT_WATCH_SIZE=0

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo ================================================================
pause
