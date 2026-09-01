@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 242 - CRASH FRONT: the loop guard's gate learns the LAST link (the bool phi).
REM Same env as run 241 (pass code under GT_LOOP_WRAP_GUARD=1, already on).
REM
REM RUN 241 FINDINGS (logs/run241_imgclamp.txt + run241_device_fault.bin):
REM   - DIED ON THE SAME WRAP HANG AS 239: device fault (HANG), graphics queue parked on
REM     DrawIndexed fs_0xfa80e08f + hs_0x3827418d at World Circuits entry. The shader
REM     compiled (line 388135) and the loopguard STILL logged nothing for it - the
REM     LogicalAnd widening was necessary but not sufficient.
REM   - THE SECOND MISS, measured in shaders/hs_3827418d.spvasm line 1208:
REM         %489 = OpLogicalAnd(%206, %488)   -> the branch
REM         %206 = OpPhi(true, %489)          <- %489 ALSO feeds the NEXT-iteration phi
REM     The And's users are {ConditionRef, Phi}; the gate saw the Phi and refused. The
REM     "keep going" bool phi is condition plumbing, exactly like the And.
REM   - imgclamp: 0 lines - the run never reached the mid-race moment that kills with
REM     garbage views (it died at race entry first). Verdict carries over.
REM   - USER OBSERVATION: in-race counter says 15 FPS but driving FEELS 50+; image burned
REM     and trash. Priority set by the user: whitewash + tess trash NEXT (their shared
REM     root is first-read-zeros - the page registers only on first GPU fault, so one-shot
REM     producers run on zeros). This run finishes the wrap-hang arc first: the same race
REM     entry must stop dying before any visual verdict is readable.
REM
REM THE FIX (loop_wrap_guard_pass.cpp): the branch-condition gate is now a worklist that
REM follows ConditionRef / LogicalNot / LogicalAnd / LogicalOr / PHI users (visited set -
REM phi->and->phi is a real cycle). Plus NEAR-MISS LOGGING: any stepping-phi INotEqual the
REM gate refuses logs WHICH user opcode refused it - the next mismatch is one log line,
REM not another blind run.
REM
REM VERDICT METRICS:
REM   1. grep "loopguard" - hs_0x3827418d MUST log a rewrite (or a near-miss WARNING that
REM      names the refusing opcode - either way the mystery ends this run).
REM   2. World Circuits race entry survives (runs 239+241 kill).
REM   3. grep "imgclamp" / "REFUSED" - the other two guards, still watching.
REM   4. Letters; FPS; whitewash unchanged (next front, not this run's).
REM
REM PLAY: main game -> World Circuits -> the SAME race as 239/241, finish it with camera
REM cycling; then a second race.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 242: loop guard follows the bool phi (race-entry hang, round 3)

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
