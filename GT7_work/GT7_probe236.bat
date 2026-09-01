@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 236 - CRASH FRONT: skip the tessellation draws. One change: GT_SKIP_TESS=1.
REM
REM RUN 235 FINDINGS (logs/run235_readlane_gate.txt):
REM   - Music Rally race SURVIVED (run 234's crash point) at ~14 FPS avg, letters visible in
REM     the race UI. The readlane gate never fired because vs 0x41e57240 was never requested
REM     this run (different content) - the gate stays armed but is live-unverified.
REM   - MAIN GAME still dies at the same pre-race spot: device lost, NO memory fault, Top and
REM     Bottom checkpoints frozen on journal seq 5154922 = DrawIndexed with
REM     fs 0xfa80e08f + hs_0x3827418d - a TESSELLATION pipeline, neighboured by more hs_
REM     draws. Same fs hash as run 231's death: reproducible, one draw that starts and never
REM     retires. The detile chunker is innocent here (2 monsters split cleanly, no HOST entry
REM     in the dying cmdbuf).
REM   - The stall detector stayed silent even at gate 16: when the hang blocks the CPU side
REM     too (cache waits on the frozen tick), submits stop piling up. Pileup-based detection
REM     is structurally weak; not worth more iterations now that the journal names the draw.
REM   - Pipeline cache is per-build ("written by a different build - ignoring"): every rebuild
REM     is a full recompile storm (4324 compiles this run). Expect first-minutes stutter again.
REM
REM WHAT GT_SKIP_TESS=1 DOES: FilterDraw() drops every draw whose pipeline enables the hull
REM shader stage (regs.stage_enable.hs_en), logging "[tess] skipped tessellation draw #N" at
REM power-of-two counts. Diagnostic first, mitigation second:
REM   - main game survives race entry  -> conviction locked: the tess draws are the hang.
REM   - what disappears from the frame -> tells us what GT7 tessellates (suspected: the track
REM     surface that already renders as white wash - compare the road before/after).
REM
REM VERDICT METRICS:
REM   1. Main game: World Circuits race entry - survive? (231/232/235: dead every time)
REM   2. [tess] skip count and where in the flow it climbs.
REM   3. What changed visually (road? curbs? nothing?) - a screenshot helps.
REM   4. Letters in the MAIN GAME text boxes (Music Rally showed them again in 235).
REM
REM PLAY: main game, offline -> World Circuits -> enter a race, drive a bit. A Music Rally lap
REM afterwards for comparison is welcome but optional.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 236: skip tessellation draws (hang conviction A/B)

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
set GT_SKIP_TESS=1
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
