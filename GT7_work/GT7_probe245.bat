@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 245 - CRASH FRONT: name the stale-write suspect. Same env as run 244 (the change
REM is logging-only forensics in the binary: the BDA registry now remembers DEAD buffers).
REM
REM RUN 244 FINDINGS (logs/run244_boundcap16k.txt + run244_device_fault.bin):
REM   - The "stuck" the user reported WAS the slow march to the device fault: the log kept
REM     growing (service threads) while the renderer ground to the WriteInvalid.
REM   - THE SAME WriteInvalid AS RUN 243, REPRODUCED: the write lands a few dozen KB PAST
REM     THE END of the SAME multi-gigabyte cache buffer at guest 0x1000dfc000 - whose size
REM     DIFFERS between runs (243: 0xc3d38000 = 3.28 GB; 244: 0x91c24000 = 2.44 GB). That
REM     buffer is the game's streaming heap, and the cache keeps replacing it with bigger
REM     generations as the heap grows (17.3 GB working set at death).
REM   - PRIME SUSPECT: a write through the BDA of an ALREADY-REPLACED generation of that
REM     buffer (stale address after the cache grew it). From the outside, a stale write
REM     into a freed range looks EXACTLY like "past the end of the live one".
REM   - Freeze A/B inconclusive: the run died before a clean comparison. Cap stays 16384.
REM
REM THE INSTRUMENT (bda_registry, buffer.cpp): UnregisterBdaRange now keeps a ring of the
REM last 64 dead buffer ranges. On a device fault, DescribeBdaAddressForFault also checks
REM the DEAD ring: a fault inside a recently freed range prints
REM   "DEAD buffer CONTAINS the fault ... A STALE WRITE THROUGH A REPLACED BUFFER'S ADDRESS"
REM which convicts (or acquits) the stale-write theory in one line. Logging only - no
REM behavior change anywhere.
REM
REM VERDICT METRICS:
REM   1. If the WriteInvalid recurs: does the fault record name a DEAD buffer? That line
REM      decides the next fix (lifetime tracking vs binding clamp vs pagetable gap).
REM   2. Image freezes mid-race vs run 243 (the 16384-cap A/B, still pending a clean run).
REM   3. Race load + driving still survive; grep "capped at 16384" / imgclamp / REFUSED.
REM
REM PLAY: same route: World Circuits -> car pick -> race, drive the whole race with
REM camera cycling; then a second race.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 245: dead-buffer forensics (the recurring WriteInvalid past the heap)

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
