@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 217 - WARM-CACHE TEXTURE-GC A/B.
REM
REM Run 216b reused the exact same executable and preloaded 1187 pipelines, yet the one-second
REM black checkerboard, audio slowdown, progressive FPS collapse, wash, and red map remained.
REM The live texture set repeatedly fell by 5-7 images per GC pass and then grew again during
REM scene transitions. This run preserves every run-216 setting and its warm pipeline cache but
REM disables image deletion for one short run. Do not rebuild or clear the cache before testing.
REM
REM PRIMARY VERDICTS:
REM   1. Does the initial checkerboard still remain black for about one second?
REM   2. Does audio still stutter/slow while an image appears?
REM   3. Does FPS still decay over 30-45 seconds after entering the first race?
REM   4. Does the wash/red-map content change? (Not expected, but record it.)
REM
REM Keep this test short. With image GC disabled, VRAM use can only grow during the run.

title GT7 - run 217: warm cache, texture GC disabled

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
