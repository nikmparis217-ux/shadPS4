@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 219 - PARALLEL GPU PAGE-PROTECTION PROBE.
REM
REM Run 218 measured 20,000-43,000 claimed guest writes per two-second window while the scene
REM fell from 10-12 FPS to 4 FPS. The same 1 MiB ranges faulted far more than their 256 distinct
REM pages, proving rapid upload/reprotect/write ping-pong. The protection calls alone consumed up
REM to 3.6 aggregate seconds per window because every guest thread queued behind AddressSpace's
REM single exclusive regions-map lock.
REM
REM GT_FAST_PROTECT changes no watcher, dirty, upload, readback, or page granularity semantics.
REM It lets PageManager protection calls for disjoint ranges hold a shared regions-map lock;
REM map/unmap and guest mprotect remain exclusive. Keep the run through the same welcome/Music
REM Rally sequence. The [protprof] line must show whether the convoy disappeared; [faulthist]
REM remains enabled so FPS and audio can be compared at the same fault volume.

title GT7 - run 219: parallel GPU page protection

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
