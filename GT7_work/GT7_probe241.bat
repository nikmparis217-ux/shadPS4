@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 241 - CRASH FRONT: out-of-range image views stop aborting the process. Same env
REM as run 240 (the change is unconditional texture-cache code - semantically correct
REM handling of a garbage view, not an experiment).
REM
REM RUN 240 FINDINGS (logs/run240_loopguard_and.txt):
REM   - Crashed MID-RACE on a HOST ASSERT: image.cpp:306 GetBarriers
REM     `subres_idx < subresource_states.size()` - no device fault, no guest dump. It fired
REM     right after "Compiling graphics pipeline 0x7ec598b5131e6658" (a mid-race permutation
REM     storm): a texture VIEW claimed more mips/layers than its image owns, the subresource
REM     walk indexed past the state array, and the ASSERT killed the process. The
REM     garbage-descriptor family again (same family as the 769-layer monster image).
REM   - The run-240 loopguard fix is UNTESTED: hs_0x3827418d never compiled this session
REM     (different race than 239's). Its verdict carries over to this run.
REM   - Monster detile: 0 REFUSED again. Letters unknown; FPS "a couple higher" (user).
REM   - Whitewash unchanged - that is the exposure/LUT front, untouched by these runs.
REM
REM THE FIX (image.cpp GetBarriers): clamp the requested subresource range to the image's
REM own mips/layers before the walk. Base out of range -> transition the whole image
REM instead; extent overshoot -> trim it. Every clamp logs "[imgclamp] ..." with the full
REM shape of the lie (rate-limited to 32) = free forensics on the garbage-view family.
REM Barriers on the real subresources are correct; the view's phantom entries do not exist
REM to need transitioning. The abort becomes a survivable, logged event.
REM
REM VERDICT METRICS:
REM   1. Finish a full race (run 240's kill was mid-race) - survive?
REM   2. grep "imgclamp" - how many garbage views, and their shapes.
REM   3. grep "loopguard" - hs_0x3827418d must log when ITS race loads (run 239's kill;
REM      pick the same race as 239 at least once).
REM   4. grep "[detile] .* REFUSED" - still watching for the 750MB monster.
REM   5. Camera changes + garage new cars still clean; letters; FPS.
REM
REM PLAY: main game -> World Circuits -> the SAME race as run 239 first (tests loopguard),
REM finish it with camera cycling (tests imgclamp); then another race; then garage.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 241: clamp garbage image views (mid-race assert)

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
set GT_STREAM_MEMO=1
set GT_RESOLVE_SWAP=1
set GT_CLEAR_RAW=1
set GT_THREAD_PROF=2
set GT_SLEEPQ_MUTEX=1
set GT_STALL_DUMP=1
set GT_DETILE_CHUNK=262144
set GT_DETILE_MAXMB=256
set GT_SKIP_TESS=0
set GT_LOOP_WRAP_GUARD=1
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
