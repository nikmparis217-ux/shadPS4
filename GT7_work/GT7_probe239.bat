@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 239 - CRASH FRONT: refuse monster host-detile images. One env change:
REM GT_DETILE_MAXMB=256.
REM
REM RUN 238 FINDINGS (logs/run238_acb_stall.txt + run238b_crash.txt):
REM   *** THE READLANE FIX HOLDS: camera changes while driving SURVIVED (run 237's kill), ***
REM   *** and "kept as-is" is gone from the log. ***
REM   - 238a: stall before the main menu - renderer went silent, 65k lines of service noise.
REM     A compute queue was REMAPPED (pipe1 queue3 vq8 -> vq10, vq10 previously pipe0 queue4)
REM     and the first 4-dw submission parsed as garbage (header 0x204729c8 = an ADDRESS, not
REM     PM4); the stitcher dropped it - if that was the fence write, the game waits forever.
REM     Unique to that run; filed, not yet fixed (retry-not-drop is the likely shape).
REM   - 238b: Music Rally race start DEVICE FAULT, WriteInvalid at an address matching NO
REM     registered buffer. Checkpoint parked on the LAST chunk of a HOST-detile of a
REM     FIRST-EVER-SEEN "image": 256x256 x 769 layers, guest_size 0x2cc42000 = 750 MB -
REM     larger than any texture a PS4 game can carry (GT7's biggest legit: 105 MB), and the
REM     size is not even divisible by the layer count. A garbage-described image (the
REM     first-read-zeros/garbage-descriptor family) fed to the tiling math.
REM   - Letters: missing again this run (warm-cache correlation suspected by the user).
REM
REM WHAT GT_DETILE_MAXMB=256 DOES: DetileImage/TileImage refuse host tiling work above the
REM cap - the texture stays tiled (garbled pixels, possibly one broken texture on screen)
REM instead of the device dying. Log: "[detile] ... REFUSED: extent ...". Every refusal
REM prints the full image description = free forensics on the garbage-descriptor family.
REM
REM VERDICT METRICS:
REM   1. Music Rally race start (238b's kill) - survive?
REM   2. grep "[detile] .* REFUSED" - how many monsters, and their shapes.
REM   3. Camera changes + garage new cars still clean (237/238 wins must not regress).
REM   4. Letters in text boxes; FPS.
REM
REM PLAY: Music Rally race first (238b died there), then main game -> World Circuits ->
REM race with camera cycling, garage car changes.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 239: refuse monster detile images (750MB garbage descriptor)

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
