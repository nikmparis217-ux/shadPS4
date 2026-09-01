@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 246 - CRASH FRONT: null-bind monster T#s at the source. One env change:
REM GT_IMG_MAXMB=512 (new gate in vk_rasterizer BindTextures).
REM
REM RUN 245 FINDINGS (logs/run245_deadring.txt + run245_device_fault.bin):
REM   *** PROGRESS: the user FINISHED the whole race for the first time in this arc ***
REM   *** (243 died mid-first-race, 244 died mid-race, 245 died after the finish).  ***
REM   - THE DEAD-BUFFER RING ACQUITTED THE STALE-WRITE THEORY: 0 "DEAD buffer CONTAINS"
REM     lines. The WriteInvalid (0x7724b7000, 0x13000 past the live 3.35 GB heap buffer at
REM     guest 0x1000dfc000) really is past the end of the LIVE generation.
REM   - THE NEW SUSPECT, with exact address arithmetic: seconds before the fault, a T#
REM     claiming 256x256 x 1857 LAYERS arrived whose TILED guest footprint is 0xbd840000 =
REM     3.18 GB, ending at 0x10c8ca0000 - EXACTLY the heap buffer's end (0x1000dfc000 +
REM     0xc7ea4000). Detile REFUSED it (GT_DETILE_MAXMB); the page tracker REFUSED it
REM     ("torn descriptor registration") - but the Image object was still created,
REM     registered and synchronized, and the device died writing 76 KB past that end.
REM   - WHY EVERY EXISTING GUARD MISSED IT: sharp_extent_sane counts TEXELS (2^26.9 texels,
REM     1857 <= 2048 layers - PASSES). The 3.18 GB lives in the pitch/slice padding of the
REM     tiled layout, which only ImageInfo::guest_size can see.
REM   - Also seen at the death: the master semaphore reported tick 2^64-1 (device already
REM     dying) and our tick guard correctly REFUSED it.
REM
REM THE FIX (GT_IMG_MAXMB, vk_rasterizer.cpp): at BindTextures - the same place the V#
REM softclamp null-binds garbage V#s - any T# whose ImageInfo::guest_size exceeds the cap
REM is null-bound BEFORE FindImage can create the image. No Image object = no registration,
REM no 3 GB synchronize, no download, no write past the heap. Largest legit GT7 resource
REM is ~256 MB (8K lightmap); 512 MB cuts only garbage. Log line:
REM   "[softclamp] shader X: T# ... exceeds GT_IMG_MAXMB - null-bound before the texture
REM    cache could create it"
REM
REM VERDICT METRICS:
REM   1. grep "exceeds GT_IMG_MAXMB" - does the gate fire where detile REFUSED used to?
REM      (detile REFUSED should drop to 0 for these - the image never exists now.)
REM   2. The recurring WriteInvalid past the heap buffer end: gone?
REM   3. Race + post-race screens survive (245 died AFTER the finish - replay/results).
REM   4. Image freezes mid-race vs 243/244 (the 16384-cap A/B, still open).
REM
REM PLAY: same route: World Circuits -> car pick -> race, drive the whole race with
REM camera cycling; after the finish stay on the results/replay screens a while; then a
REM second race.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 246: null-bind monster T#s (3 GB tiled footprint killed run 245)

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
set GT_IMG_MAXMB=512
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
