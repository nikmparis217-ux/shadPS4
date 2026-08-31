@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 223 - NAME THE PER-DRAW MILLISECONDS. Same switches as run 222 (the known 12->5-6
REM baseline); the binary gained six [fprof] sub-buckets and NO behavior change of any kind.
REM Play ~1 min extra in the menus first (the rebuild wiped the pipeline cache, the first
REM minutes recompile), then the usual: menus + the first Music Rally race.
REM
REM WHY: run 222 showed the FPS decay is not a leak - the heavy menu runs 1500-4000 draws per
REM frame (vs 50-300 on the early screens) at ~30 us of CPU per draw, GPU thread 60-75% busy.
REM But at t=106s the draw bucket held 1178 ms while its stage buckets summed 869 ms: ~300 ms
REM per window was UNNAMED, and the bindbuf/bindtex loop bodies hid ~250 ms more beyond their
REM sub-scopes. Nothing gets fixed until those milliseconds have names.
REM
REM NEW [fprof] FIELDS this run reports:
REM   body: filter J  - PopPendingOperations + FilterDraw
REM         journal J - the GpuWork journal per draw/dispatch, INCLUDING the setCheckpointNV
REM                     driver call the crash hunt installed (a per-draw Vulkan call!)
REM         vkcmd V   - bindPipeline + the vkCmdDraw/vkCmdDispatch recording itself
REM         split S   - GT_SPLIT_DISPATCH's per-dispatch scheduler.Flush = one vkQueueSubmit
REM                     per dispatch; disp windows spike to 700+ ms and this names their share
REM   bufpass: scan A - BindBuffers pass 1 (sharp walk + guards + FindBuffer)
REM            emit B - BindBuffers pass 2 (ObtainBuffer + descriptor assembly)
REM
REM PRIMARY VERDICT: in the heavy windows (Music Rally menu / race), which of
REM   journal / vkcmd / split / bufscan / bufemit / (bindtex - findimg - findtex)
REM is the biggest slice of the draw path. THAT one gets the fix in run 224.
REM Also: is the washed-out white still there? (run 222 says it predates hot-pin)
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 223: name the per-draw milliseconds

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
set GT_HOT_PIN=0
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
