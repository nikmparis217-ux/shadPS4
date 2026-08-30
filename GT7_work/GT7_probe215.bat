@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 215 - IMPORTED-BACKING BDA FALLBACK.
REM
REM Run 214 closed the fault-widening experiment: even after the record-page heal fired, the
REM process died abruptly and the profiler still measured 9.6k-20.6k claimed write faults plus
REM 0.7-1.9 seconds of page-protection work per two-second window. Widening is OFF here.
REM
REM GT_BDA_IMPORT imports the process-lifetime 8.25-GiB guest backing through
REM VK_EXT_external_memory_host in one-GiB chunks. A physically-backed guest page that has no
REM normal cached Vulkan buffer receives the imported backing's BDA instead of zero. Therefore
REM an unregistered BDA read sees the real guest bytes and an unregistered BDA store reaches the
REM real backing instead of being dropped. Normal cached buffers still override these entries.
REM Map/unmap and cache unregister restore the correct fallback or zero entry.
REM
REM PRIMARY VERDICTS:
REM   1. Boot log must contain "[bdaimport] ACTIVE" (otherwise this test did not run).
REM   2. The one-second black checkerboards should load immediately if dropped unknown-page reads
REM      were their cause.
REM   3. The solid-red Music Rally map should change if its GPU-written records were previously
REM      dropped on unregistered pages.
REM   4. Record FPS at first scene appearance and after 30 seconds; note wash/pulsing separately.
REM
REM This is still an experimental A/B. The daily driver remains GT7_rtshape.bat with the import
REM and widening both off.

title GT7 - run 215: imported-backing BDA fallback

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
set GT_CB_TRACE=
set GT_WATCH_VA=0
set GT_WATCH_SIZE=0

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo ================================================================
pause
