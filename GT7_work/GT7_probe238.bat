@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 238 - CRASH FRONT: the readlane immediate-as-pointer fix. Same env as run 237 (the
REM fix is unconditional pass code - it is semantically CORRECT handling, not an experiment).
REM
REM RUN 237 FINDINGS (logs/run237_loopwrapguard.txt):
REM   *** THE GPU-HANG FAMILY IS DEAD: 0 device faults the whole run. ***
REM   - [loopguard] shader 0xef4a0dc6: 1 wrap-prone loop exit made wrap-proof - the garage
REM     new-car killer got its rewrite and the garage survived.
REM   - Tessellation back on (48 hs compiles), no hang at race entry or loading bursts.
REM   - BUT: guest CPU crash (AV reading 0x8 in Shader::IR::Inst::Use) when changing camera
REM     view while driving - the view change requested NEW pipelines, recompiling
REM     vs 0x41e57240: the run-142/234 shader, for the THIRD time.
REM
REM THE REAL ROOT CAUSE (unifies runs 142 + 234 + 237): IR::Value is a union, so calling
REM InstRecursive() on an IMMEDIATE phi argument returns the constant's bits as an Inst*
REM (crash context rdx=0x2090081 = the immediate). Low addresses are mapped GUEST MEMORY in
REM this emulator, so the fake pointer READS - as near-zero data: opcode 0 (= Phi), parent
REM null - which is why it masqueraded as a "dangling phi" for three crashes in three eras.
REM The run-235 gate was in IsPossibleToEliminate, which SKIPS immediate args - wrong place.
REM
REM THE FIX (readlane_elimination_pass.cpp, unconditional): an immediate register value holds
REM that constant in EVERY lane, so ReadLane of it IS the immediate. All four deref sites now
REM handle it: phi args pass the immediate through as the phi operand; WriteLane chains whose
REM BASE is an immediate resolve to that base (SearchChain grew a chain_broken flag); a
REM ReadLane whose Arg(0) is immediate folds outright. Parentless guards stay as defense.
REM
REM VERDICT METRICS:
REM   1. Change camera views while driving (run 237's kill) - survive?
REM   2. Car bodies still painted, no device fault (run 237's wins must not regress).
REM   3. grep "kept as-is" - should be GONE (that log line was the garbage pointer talking).
REM   4. FPS in race / menus; letters in text boxes.
REM
REM PLAY: main game -> World Circuits -> race, CYCLE ALL CAMERA VIEWS repeatedly; garage car
REM changes (new cars); a Music Rally lap with view changes there too.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 238: readlane immediate fix (camera-change crash)

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
