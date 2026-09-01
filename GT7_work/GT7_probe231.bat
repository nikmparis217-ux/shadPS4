@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 231 - PERF FRONT: park the sleep-queue contention. Same as run 230 plus
REM GT_SLEEPQ_MUTEX=1 (the ONE behavior change).
REM
REM RUN 230 FINDINGS (logs/run230_ripsample_crash.txt, 22 [tprof2] windows):
REM   - The Job#N workers' RUNNING samples land in Common::SpinLock::lock
REM     (shadps4.exe+9d5e2 = spin_lock.cpp:37) and their parked samples in
REM     NtWaitForSingleObject. Job#0 alone runs real guest code. tm_ffb parks in
REM     NtWaitForMultipleObjects.
REM   - So the ~10 cores are NOT guest spinning: GT7 parks ~60 workers on condvars at a high
REM     wake rate, and every wait/wake round-trip fights the sleep-queue CHAIN SPINLOCK
REM     (sleepq.cpp) - all waiters of one condvar hash to the same chain, and the spin has no
REM     backoff. Death by contention, phase-independent.
REM   - The run ended in a GPU DEVICE LOST (hang class, shader 0x6421a7b6, no bad memory
REM     access) - the OLD hang family, seen long before the census existed. Dump archived as
REM     logs/run230_device_fault.bin. If run 231 also dies this way, we compare; the census
REM     suspends guest threads for microseconds only and never touches GPU/audio threads.
REM
REM WHAT THIS RUN CHANGES (GT_SLEEPQ_MUTEX=1):
REM   The sleep-queue chain lock becomes std::mutex (SRWLOCK): contending threads PARK instead
REM   of spinning. Safe here because sleepq lock/unlock is always same-thread (the condvar
REM   wait loop is lock -> unlock -> Sleep -> lock). This is ALSO the A/B that separates the
REM   two remaining suspects: if proc% collapses, the burn was sleepq contention; if it stays
REM   ~1000%, the spinlock samples were page_manager's fault path on the same threads.
REM
REM VERDICT METRICS:
REM   1. [tprof] proc% at menu and in race vs run 229/230 (~930-1100%). A big drop = win.
REM   2. [tprof] per-Job% (was a uniform 13-19%).
REM   3. FPS: menu was 4-8, race 8-11. Any change either way.
REM   4. Red map stays fixed; no new stutter (mutex parking adds wake latency - audio is the
REM      canary).
REM
REM PLAY: menu ~30 s, then a race 2-3 minutes, then quit.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 231: sleepq chain mutex (park, do not spin)

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
