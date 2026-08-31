@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 220 - STRICT READ-ONLY DIRECT-IMPORT PROBE.
REM
REM Run 219 reduced aggregate page-protection cost by roughly 4-5x, yet visuals, audio, FPS and
REM crashes stayed unchanged. It proved the global protection lock was overhead, not the root
REM cause. The remaining cycle is guest write -> cache upload -> reprotect -> guest fault, at
REM 27,000-58,000 repeated writes per two-second window.
REM
REM GT_DIRECT_IMPORT serves only large, unformatted GPU-read-only buffers directly from the
REM already imported HOST_COHERENT guest backing. It rejects cached, GPU-modified, image-aliased,
REM fragmented and cross-chunk ranges. Written/texel/image buffers retain the old path exactly.
REM The [directimport] line reports hits and rejection reasons; [faulthist] shows whether the
REM repeated-fault population falls.

title GT7 - run 220: direct coherent read buffers

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
