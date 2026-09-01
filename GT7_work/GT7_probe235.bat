@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 235 - CRASH FRONT: refuse ReadLane elimination through a dangling IR node.
REM Same env as run 234 (GT_DETILE_CHUNK stays); the ONE change is in code, always-on: a pure
REM correctness gate in the readlane elimination pass.
REM
REM RUN 234 FINDINGS (logs/run234_detilechunk.txt + run234_guest_crash.dmp):
REM   - THE TDR CLASS IS BEATEN: no "Device lost during submit" anywhere. GT_DETILE_CHUNK
REM     split two real monsters (7424x7424@16bpp = 110 MB, and 128x128 x 1024 LAYERS x 8 mips
REM     @32bpp = 86 MB) and race FPS rose 8-11 -> 18-25.
REM   - The crash MOVED: CPU access violation reading 0x8 on GpuCommandProcessor at
REM     shadps4.exe+0xb8a1aa = Shader::IR::Inst::Use -> emplace_front into a NULL-headed use
REM     list. Last log line before it: "ReadLane phi without a parent block - kept as-is",
REM     compiling vs 0x41e57240 - THE SAME SHADER that died in run 142 (TrackSharp assert).
REM   - Mechanism: that shader's IR carries a DANGLING reference; the freed node reads as
REM     zeroed memory (opcode 0 = Phi, parent = null). The run-142-era guard handed the corpse
REM     back as a value, AddPhiOperand tried to register a use on it, boom. Warm caches masked
REM     it for 90 runs because the shader never recompiled; run 234's fresh cache re-ran the
REM     translation.
REM
REM WHAT THIS BUILD CHANGES: IsPossibleToEliminate() now refuses the whole elimination when
REM the chain reaches a parentless node (log: "elimination refused, ReadLane kept"). The graph
REM is never modified, nothing touches the corpse, the backend emits the ReadLane as-is.
REM
REM VERDICT METRICS:
REM   1. vs 0x41e57240 compiles (grep "elimination refused" - expect >=1) and the game does
REM      NOT crash at Music Rally race entry.
REM   2. Main game: enter a World Circuits race - does it survive now? (run 232: 3/3 dead)
REM   3. No device lost (detile chunking regression check), FPS holds 18-25.
REM   4. Letters on the text boxes - warm cache this time (same binary family as 234's cache?
REM      NO: this rebuild wipes the cache again, so first minutes stutter, letters observed
REM      on a FRESH cache once more).
REM
REM PLAY: Music Rally race first (the 234 crash point), then main game -> World Circuits ->
REM race a few minutes. Note FPS and whether text-box letters render.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 235: dangling-IR gate (readlane) + detile chunking

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
