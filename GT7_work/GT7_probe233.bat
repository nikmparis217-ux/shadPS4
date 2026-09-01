@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 233 - CRASH FRONT: is the device loss a STALLED PACKET or a sudden driver death?
REM Same env as run 232 plus GT_STALL_DUMP=1 (already in the binary since the run-42 era - NO
REM rebuild, so the pipeline cache stays warm; that matters for the text question too).
REM
REM RUN 232 FINDINGS (3 attempts, 3 crashes - 2 during initialisation, 1 mid-race):
REM   - THIRD distinct live shader at death (0xef4a0dc6; 231 was 0xfa80e08f, 230 0x6421a7b6).
REM     Different shader every time = the hang CLASS, not one shader's bug.
REM   - Every crash sits inside a LOADING BURST: the last [fprof] windows show up to 26180
REM     draws in 2.0 s. Frequency ROSE after the sleepq win - the freed ~6 cores feed the GPU
REM     denser bursts, so the exposure increased even though the fix is correct.
REM   - GT_CLEAR_RAW is ACQUITTED for the missing text: the only clear it changed all run is
REM     fmt=6 (10_11_11 float, no alpha channel stored) where only alpha differed - zero
REM     memory effect. The text suspect is elsewhere (candidate: pipeline cache corrupted by
REM     the crash-restart cycle; a fresh-cache run is the dedicated test if text stays gone).
REM
REM WHAT GT_STALL_DUMP ANSWERS: it watches the master semaphore live and, if a completed tick
REM freezes for >700 ms while >256 submits pile up, dumps the work journal AT THAT MOMENT,
REM naming the oldest unfinished tick (the hung work) while the rings still hold it.
REM   - Stall dump fires, then device lost  -> a packet really hangs (TDR class); the dump
REM     names the shader/draw to chase.
REM   - Device lost with NO stall dump      -> sudden death, driver/semaphore class; opposite
REM     next step (queue pacing will not help).
REM
REM PLAY: main game, offline -> World Circuits -> enter a race. One or two attempts is enough;
REM a crash is a RESULT. Also note whether text-box letters render this time.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 233: live stall dump on the main-game crash

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
