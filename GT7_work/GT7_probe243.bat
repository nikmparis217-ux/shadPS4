@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 243 - CRASH FRONT: cap garbage loop BOUNDS. One env change: GT_LOOP_BOUND_CAP=1048576.
REM
REM RUN 242 FINDINGS (logs/run242_loopguard_phi.txt + run242_device_fault.bin) - THE BIG ONE:
REM   *** THE WRAP ARC IS CLOSED: hs_0x3827418d finally rewritten (base + permutation), ***
REM   *** and the phi-following gate matched 962 SHADERS / 1746 rewrites - the do-while ***
REM   *** with phi plumbing is GT7's NORMAL loop idiom. Longest session in days:       ***
REM   *** Music Rally menu -> race -> car select browsing, zero faults for most of it. ***
REM   - 1 near-miss, correctly refused (compare feeding SelectU1 = a value use).
REM   - imgclamp 0, detile REFUSED 0 - armed, not needed this session.
REM   - THEN a NEW hang at race load after car pick: cs_0xc3d5603f (DispatchDirect 1x1x1,
REM     64 threads), 2 IPs parked in one shader, no bad memory access. 0 loopguard
REM     rewrites, 0 near-misses for it - NOT a wrap loop.
REM
REM THE MECHANISM (measured in shaders/cs_c3d5603f.spvasm, extracted from the pipeline
REM cache): %102 = load(srt_flatbuf[16]) - a record count snapshotted by the CPU SRT
REM walker; %107 = (%102+63)>>6; loop `while (counter < %107)`, counter stepping +1.
REM ZEROS EXIT INSTANTLY (this is not the wrap family). STALE/GARBAGE flatbuf data (float
REM bits, pointers) makes %107 tens of millions -> one 64-thread group looping an
REM SSBO-touching body forever = TDR. Same disease GT_18256C0_GUARD fixed per-shader for
REM cs_0x018256c0's flatbuf[52]/[53]; per-shader clamps do not scale.
REM
REM WHAT GT_LOOP_BOUND_CAP=1048576 DOES (loop_wrap_guard_pass.cpp): for any loop exit
REM `(+1 stepping phi) < (LOADED bound)` (or `bound > phi`), the bound is wrapped in
REM UMin/SMin(bound, cap). Legit trip counts here are thousands, so the min is an identity;
REM only a bound demanding >1M iterations per invocation - a TDR by definition - is cut.
REM Signed compares use signed min so negative garbage still exits instantly. Log:
REM "[loopguard] shader X: N loaded loop bound(s) capped at 1048576 iterations".
REM
REM VERDICT METRICS:
REM   1. Race load after car pick (run 242's kill) - survive?
REM   2. grep "capped at" - how many shaders carry loaded bounds (expect MANY, like the
REM      962-shader wrap census).
REM   3. World Circuits entry + camera cycling still clean (242's wins must not regress).
REM   4. grep imgclamp / REFUSED / "NOT rewritten" - the other guards.
REM   5. Letters; FPS; whitewash unchanged (the data front comes after the game stops dying).
REM
REM PLAY: main game -> World Circuits -> pick a car -> the race that killed run 242, drive
REM it with camera cycling; then a second race; then garage browsing.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 243: cap garbage loop bounds (race-load TDR after car pick)

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
set GT_LOOP_BOUND_CAP=1048576
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
