@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 230 - PERF FRONT: WHERE do the job threads spin? Same as run 229 but GT_THREAD_PROF=2.
REM
REM RUN 229 FINDINGS (logs/run229_threadcensus.txt, 73 [tprof] windows):
REM   - proc ~930-1100% (9-11 cores) in the MENU and IN THE RACE alike.
REM   - The load is NOT one hog: ~60 guest threads named Job#0..Job#62, each a uniform
REM     ~13-19% of a core, phase-independent -> the game's job-system IDLE path (poll/spin),
REM     ~10 cores total. Plus tm_ffb_eventHandleThread 49-76% (the game's force-feedback
REM     poller) and our GpuCommandProcessor 46-75%.
REM   - User: longest race run so far, 8-11 FPS steady (no decay to 3-5 this time).
REM   - Red map stayed fixed (GT_CLEAR_RAW regression check passed).
REM
REM WHAT LEVEL 2 ADDS: every 5 s window, the census suspends each of the top-8 guest threads
REM (Job#N / ffb only - never our own GPU or audio threads) for MICROSECONDS, 3 times, 30 ms
REM apart, reads the instruction pointer and prints one [tprof2] line classifying it:
REM   guest:<addr>      = the game's own code (it spins by itself; fix = scheduler/affinity)
REM   shadps4.exe+off   = our emulator code (name the function; fix = make that path cheap)
REM   ntdll.dll+off     = parked in a host wait (the CPU% then comes from wake/sleep churn)
REM The two diagnoses need OPPOSITE fixes, which is why this must be measured first.
REM
REM PLAY: menu ~30 s, then a race for 1-2 minutes, then quit. A short run is fine - the
REM signature is phase-independent.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 230: thread census + RIP sampling (WHERE do the jobs spin)

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
