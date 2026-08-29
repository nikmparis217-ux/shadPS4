@echo off
REM Targeted proof run for the GT7 foliage poisoned render-target output.
REM Only fs_92126594 is scrubbed. NaN/Inf and its 65000 poison ceiling become zero.
REM Keep unrelated LUT, descriptor-array, RenderDoc, and render-target experiments disabled.

title GT7 - targeted foliage RT scrub

set GT_RT_SCRUB=92126594
set GT_LUT_IDENT=0
set GT_LUT_DUMP=0
set GT_RT_NOCLOBBER=0
set GT_IMGARRAY_SYNC=0
set GT_INVAL_IMG_ON_SSBO=0
set GT_IMG_TRACE=0
set GT_WATCH_VA=
set GT_WATCH_SIZE=
set GT_AE_FORCE=0

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Proof run complete. Keep this window open for the log summary.
echo ================================================================
pause
