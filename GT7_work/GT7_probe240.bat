@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 240 - CRASH FRONT: the loop-wrap guard finally guards its OWN shader. Same env as
REM run 239 (the change is pass code under GT_LOOP_WRAP_GUARD=1, already on).
REM
REM RUN 239 FINDINGS (logs/run239_detilecap.txt + run239_device_fault.bin):
REM   - World map rendered like the REAL game for the first time (user: "a regular main
REM     menu of gt7") - the map bloom blobs faded as data settled, i.e. transient
REM     first-read-zeros, not a standing defect. Letters worked. 29 FPS on the map.
REM   - Monster detile: 0 REFUSED lines - the 750MB garbage image did not reappear this
REM     run (its trigger is data-dependent). The cap stays armed.
REM   - DEVICE FAULT (HANG, no bad memory access) at the CHOICE OF RACE: graphics queue
REM     parked Top AND Bottom of pipe on seq 9697075 = DrawIndexed fs_0xfa80e08f +
REM     hs_0x3827418d - THE ORIGINAL WRAP-LOOP SHADER. It compiled FRESH at race load
REM     (line 271538) and the loopguard logged NOTHING for it.
REM
REM THE DEFECT (measured in shaders/hs_3827418d.spvasm): the guard's branch-condition gate
REM only accepted ConditionRef and LogicalNot users. The real do-while exit is
REM     %488 = OpINotEqual(1, counter_phi);  %489 = OpLogicalAnd(%206, %488) -> branch
REM - the comparison feeds a LogicalAnd, so the gate REFUSED the rewrite. The safety gate
REM added for shape 2 had disabled the guard for the very shader shape 1 was built for.
REM It never matched in ANY run (grep: no loopguard line for 3827418d anywhere); runs
REM 237/238 survived because the count happened not to arrive 0 at those moments.
REM
REM THE FIX (loop_wrap_guard_pass.cpp): the gate now walks LogicalAnd/LogicalOr/LogicalNot
REM chains (depth-limited) and accepts the comparison only if EVERY terminal use is a
REM ConditionRef. `going && (counter != 1)` is as pure a loop exit as the bare compare.
REM
REM CACHE NOTE: BuildGeneration hashes the BUILD DATE, so every new binary invalidates the
REM whole shader cache - hs_0x3827418d WILL recompile fresh this run and the guard runs.
REM
REM VERDICT METRICS:
REM   1. grep "loopguard" - hs_0x3827418d (and how many more hs shaders) must now log.
REM   2. Race choice + race start survive (run 239's kill).
REM   3. Camera changes + garage new cars still clean (237/238 wins must not regress).
REM   4. grep "[detile] .* REFUSED" - still watching for the 750MB monster.
REM   5. Letters in text boxes; FPS.
REM
REM PLAY: main game -> World Circuits -> pick the SAME race as run 239 -> race with camera
REM cycling; then Music Rally; then garage car changes.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 240: loop guard now passes LogicalAnd exits (race-choice hang)

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
