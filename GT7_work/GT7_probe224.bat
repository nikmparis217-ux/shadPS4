@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 224 - FINISH THE PER-DRAW MAP. Same switches as runs 222/223; the binary gained six
REM more [fprof] buckets and NO behavior change. Play ~1 min extra in the menus first (the
REM rebuild wiped the pipeline cache again), then the usual: menus + the first Music Rally race.
REM
REM RUN 223 VERDICTS (logs/run223_drawprof.txt):
REM   - ACQUITTED: journal/setCheckpointNV (4-15 ms) and vkcmd (10-20 ms). Two suspects that
REM     would each have been a wrong fix - the instrumentation run paid for itself.
REM   - bufscan+bufemit == bindbuf exactly (e.g. 118+134 vs 257): the buffer bill is the two
REM     passes themselves, and emit is almost entirely ObtainBuffer.
REM   - split measured 30-273 ms - real, third place.
REM   - STILL UNSPLIT: bindtex's body (100-530 ms; findimg/findtex are small, so the cost is
REM     sharp+guards+ImageDesc / Transit / GetSampler - unknown which) and the dispatch body
REM     beyond split (disp minus split still 100-450 ms; at 1599 disp that is 260 us per
REM     dispatch, unexplained).
REM
REM NEW [fprof] FIELDS this run reports:
REM   imgpass: scan  - BindTextures pass 1 (T# reads + guards + ImageDesc build + FindImage)
REM            emit  - pass 2 (rebind check + FindTexture + layout Transit)
REM            samp  - the sampler loop (GetSampler cache lookup per bind)
REM   disp2:   endr  - scheduler.EndRendering per dispatch (render-pass churn: every dispatch
REM                    closes the pass and the next draw reopens it)
REM            descpush - vkCmdPushDescriptorSet (pipeline->BindResources), draws+dispatches
REM            hle   - ExecuteShaderHLE
REM
REM PRIMARY VERDICT: the full cost table of the heavy windows. After this run every
REM millisecond of the draw/dispatch path has a name, and run 225 fixes the largest.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 224: finish the per-draw map

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
