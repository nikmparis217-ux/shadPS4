@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 244 - CRASH FRONT: the bound cap was too generous. One env change:
REM GT_LOOP_BOUND_CAP 1048576 -> 16384.
REM
REM RUN 243 FINDINGS (logs/run243_boundcap.txt + run243_device_fault.bin):
REM   *** THE CAP WORKED: cs_0xc3d5603f got its bound capped, and run 242's kill (race ***
REM   *** load after car pick) PASSED - the user got into the race and drove it.       ***
REM   - 425 distinct shaders / 704 compiles carry loaded loop bounds - the pattern is as
REM     widespread as the wrap census (962 shaders) suggested.
REM   - USER: image FREEZES for seconds mid-race while the game keeps counting behind;
REM     FPS lower overall. THAT IS THE CAP ITSELF: a garbage bound that used to be an
REM     infinite hang now runs 1,048,576 iterations - the GPU grinds for seconds instead
REM     of dying. 1M was oversized: legit per-invocation trip counts here are THOUSANDS
REM     (cs_0x018256c0's real counts were <= a few thousand; its per-shader guard used
REM     1024). 16384 keeps every legit loop identical and makes a garbage dispatch 64x
REM     cheaper - freezes should shrink from seconds to tens of milliseconds.
REM   - THE KILL was a NEW mechanism again: WriteInvalid at 0x779343000, 0xb000 bytes
REM     PAST THE END of a 3.28 GB registered buffer - a real out-of-bounds WRITE through
REM     a raw BDA pointer (BDA writes have no clamping), i.e. the garbage-data family on
REM     the WRITE side. Filed; if it recurs this run the fault record is the evidence.
REM   - The exposure "sun" pulse and unbuilt textures: the data front, next after this.
REM
REM VERDICT METRICS:
REM   1. Image freezes mid-race: gone or much shorter? (The A/B for "the freezes were
REM      the 1M cap".) FPS vs run 243.
REM   2. Race load + race completion still survive (243's wins must not regress).
REM   3. If WriteInvalid recurs: archive the fault record - the write-side garbage case.
REM   4. grep "capped at 16384" / imgclamp / REFUSED / "NOT rewritten".
REM
REM PLAY: same route: World Circuits -> car pick -> race, drive the whole race with
REM camera cycling; then a second race.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 244: bound cap 16384 (multi-second freezes were the 1M cap)

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
set GT_LOOP_BOUND_CAP=16384
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
