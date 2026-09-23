# Other games on this fork - what is ours and what is not

`run_game.ps1` launches ANY installed title on our build. It deliberately sets NO `GT_*` env
var and starts no shadNet server (those are GT7-only, run_gt7.ps1 owns them), so a non-GT7 run
gets upstream behaviour plus the three fixes that live in the binary itself: the VRAM graveyard
fix, the `ReadUdSharp` bounds guard, and the hull-shader patch-const drop.

    .\run_game.ps1                          list installed titles (reads each param.sfo)
    .\run_game.ps1 CUSA03281                launch
    .\run_game.ps1 CUSA03281 -Readbacks relaxed|precise|off   -Dma   -NoFps

Two traps it now handles, both of which cost real time on 21 Aug:

* **The log filter in config.json is whatever the LAST run left there**, and run_gt7.ps1 leaves
  `Lib.Pad:off`. Inherited by another game, every controller call is invisible - which reads
  exactly like a game that never asks for input. A general run states its own filter.
* **shadPS4 rewrites config.json when it exits**, so a second instance silently undoes whatever
  the script just set. The script refuses to start while one is running.

The **fps counter is forced on** for a general run. It is the one measurement that separates
"black screen because nothing is presented" from "black screen because it renders at 2 fps" -
two problems with opposite fixes.

## Uncharted 2: Among Thieves Remastered (CUSA03281) - NOT our regression

Symptom: black screen, GPU pegged, **2 fps / 560 ms per frame** on an RTX 4070 SUPER, then a
device loss. Measured, in this order:

1. It is not stuck: it plays the ND logo movie, loads `menu.pak`, and `scePadOpen` succeeds for
   one user (`player index = 1`).
2. VideoOut is set up correctly - 3 buffers, 1920x1080, `A8B8G8R8Srgb`, flip event registered.
3. Our own GPU checkpoints **name the killer**: `graphics queue at Top/BottomOfPipe: journal seq
   10043, shader 0x43b8ee5e` - a full-screen compute pass (`DispatchDirect`, groups 240x135x1,
   threads 8x8 = 2073600 invocations). Disassembled from the cache: 2 images, 1 sampler, 1 SSBO,
   and **7 `OpLoopMerge` loops**. A data-dependent loop whose bound arrives wrong is exactly
   "GPU at 100%, half-second frames, eventual TDR" - 14M compute invocations per batch is ~1-2 ms
   of work for this GPU, so 560 ms is a bug and not a shortage of hardware.
4. **The stock shadPS4 0.17.0 build on the Desktop does the same thing** - black screen, then
   `SubmitExecution: Device lost during submit`. That is the attribution: the blocker is upstream
   shadPS4's handling of this game, not our GT7 work.
5. The official compatibility issue for this exact title
   (shadps4-compatibility#2689, opened Jul 2026, v0.16.0) reports precisely this: menu background
   not rendered, severe flicker in cutscenes, then a crash or a black screen.

`-Readbacks relaxed` was tried (the usual lever for Naughty Dog engines): it died EARLIER, with a
guest wild jump on a job worker thread. One run per setting is not proof, but there is no reason
to keep it on.

⚠ `0xdeadbeef54321abc` showing up in a guest crash context is **not** a poison pointer - it is
`g_stack_chk_guard` in kernel.cpp, a legitimate constant the guest reads. Do not build a theory on it.

⚠ `internal_screen_width/height` is the VideoOut driver's size, NOT a render-target scale for the
guest - the game renders at whatever resolution it chooses. Dropping it to 720p does not shrink
that compute pass, and it is not a fix for this.

Artefacts kept: `log/run_u2_ourfork_devicefault.txt`, `log/device_fault.bin`, `log/guest_crash.dmp`.
