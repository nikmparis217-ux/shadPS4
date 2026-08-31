@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 218 - HOT PROTECTION-FAULT RANGE CENSUS.
REM
REM Run 217 proved that image GC is innocent: the exact warm-cache build had only five shader
REM compiles and zero texture-deletion activity, yet every visible, audio and FPS symptom was
REM unchanged. Imported BDA also removed all 2,026 old "Accessed non-GPU cached memory" events
REM without changing the checkerboard or red map, refuting the old first-read-zero diagnosis.
REM
REM This run changes no renderer behavior. GT_FAULT_HIST only counts claimed protection faults
REM in lock-free 1 MiB guest ranges and reports the ten hottest ranges every two seconds. Keep
REM the run going until the welcome scene or first Music Rally screen has fallen below 5 FPS,
REM then close normally. The log decides whether the storm is one repeated arena, a linear
REM sweep, or many unrelated buffers; that determines the safe optimization.

title GT7 - run 218: hot protection-fault range census

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
set GT_HOSTIMPORT=0
set GT_BDA_IMPORT=1
set GT_FAULT_WIDE=0
set GT_TEX_GC=0
set GT_CB_TRACE=
set GT_WATCH_VA=0
set GT_WATCH_SIZE=0

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo ================================================================
pause
