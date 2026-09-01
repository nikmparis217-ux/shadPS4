@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 232 - MAIN-GAME REPRO RUN: no behavior change vs run 231. Two goals:
REM   (a) reproduce the race-entry crash in the main game (World Circuits)
REM   (b) confirm the run-231 perf win holds in the real game (not just Music Rally)
REM
REM RUN 231 VERDICT (logs/run231_sleepqmutex.txt, 74 tprof + 73 tprof2 windows):
REM   *** GT_SLEEPQ_MUTEX CONFIRMED AND WON ***
REM   - proc fell from ~930-1100% (runs 229/230) to ~280-410%: about SIX CORES returned.
REM   - The ~60 Job#N workers fell from a uniform 13-19% each to 1-3% each; their RIP samples
REM     are now pure ntdll waits (parked) - the Common::SpinLock::lock samples are GONE.
REM   - Job#0 alone runs real guest code at 90-97% (the game's main job thread - legitimate).
REM   - User: intro at 60 FPS, sound FIXED, world map 29 FPS. Music Rally menu still 6-17 FPS
REM     (render-bound - the wash front), race image still washed white.
REM   - Regressions clean: red map stays fixed (32 [clear] lines), 0 resolve-differs.
REM
REM   REMAINING TOP THREADS (the next perf targets, in order):
REM   - tm_ffb_eventHandleThread now PEGGED at 99-100% of a core (was 49-81%), every RIP
REM     sample in NtWaitForMultipleObjects = wait/wake churn, likely the equeue "Timer
REM     cancelled" path (5515 such lines this run). Needs an instrument first.
REM   - shadPS4:GpuCommandProcessor 22-98% (ours, scales with draw count).
REM
REM   THE CRASH: device lost during submit while ENTERING A MAIN-GAME RACE - the OLD hang
REM   family (master semaphore read garbage, NO bad memory access, live shader 0xfa80e08f;
REM   run 230's was 0x6421a7b6 - different shader each time, so it is the hang CLASS, not one
REM   shader). It fired inside the loading burst: the last [fprof] window shows 6142 draws /
REM   858 dispatches in 2.1 s. Dump archived as logs/run231_device_fault.bin.
REM
REM PLAY: main game, offline mode -> World Circuits -> enter a race. If it survives, drive
REM 2-3 minutes and quit. If it crashes again at entry, that is ALSO a result (repro = we can
REM chase it); try a second time to see if a warm pipeline cache changes it.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 232: main-game repro (same env as 231)

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
