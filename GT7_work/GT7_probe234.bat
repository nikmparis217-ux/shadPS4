@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 234 - CRASH FRONT: chunk the monster detile. One behavior change: GT_DETILE_CHUNK=262144.
REM
REM RUN 233 FINDINGS (logs/run233_stalldump.txt + run233_device_fault.bin):
REM   *** THE KILLER IS NAMED: OUR OWN HOST DETILE PASS ***
REM   - The cmdbuf that died held exactly one entry: HOST-detile, groups 13,331,456 x 64
REM     threads = 853 MILLION invocations in ONE non-preemptible dispatch (counts 1x1089,
REM     guest_addr 0x100b460000). Live shader 0x00000000 at the checkpoint = not a guest
REM     shader - it was us. Long enough at low GPU clocks to trip the Windows 2 s watchdog.
REM   - Every earlier "different live shader each crash" was the draw that happened to sit
REM     nearby; the class was this pass all along. Loading bursts = detile storms, which is
REM     why every crash sat inside one.
REM   - GT_STALL_DUMP never fired and COULD NOT have: its >256-submit pileup gate needs ~4 s
REM     of pileup at the measured 15-20 submits/s while TDR kills at 2 s. Gate lowered to 16
REM     in this build (read-only instrument, stays on).
REM   - Text still missing with a warm cache. THIS build forces a fresh pipeline cache (any
REM     rebuild does), so this run doubles as the corrupted-cache test for the letters:
REM     letters back = the crash cycle had poisoned the cache; still gone = theory dead.
REM
REM WHAT GT_DETILE_CHUNK=262144 DOES: any (de)tile dispatch bigger than 262,144 groups is
REM issued as dispatchBase() chunks of that size inside the same command buffer - disjoint
REM texel ranges, no barrier, nothing crosses a submit - giving the driver a preemption
REM opportunity every ~17M threads instead of one indivisible 853M-thread monster. Each
REM chunked image also logs one [detile] line naming its extent/layers/format so we can judge
REM whether an 850 MB "texture" is even legitimate or a garbage ImageInfo.
REM
REM VERDICT METRICS:
REM   1. Does the main game survive race entry + a few minutes of racing? (was 4/4 crashes)
REM   2. [detile] lines: how big and how frequent are the monsters, and WHAT image is it?
REM   3. If it still dies: did the stall dump fire first this time (gate now 16)?
REM   4. Letters on the text boxes (fresh cache).
REM   5. First minutes stutter = shader recompiles (cache wiped by the rebuild) - expected.
REM
REM PLAY: main game, offline -> World Circuits -> enter a race, drive a few minutes, quit.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 234: chunk the monster detile (TDR guard)

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
