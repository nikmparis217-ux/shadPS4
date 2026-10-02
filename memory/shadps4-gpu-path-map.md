---
name: shadps4-gpu-path-map
description: "The exact order one shader/draw takes in shadPS4 from the game's submit to the screen (22 steps, file:line on main bf794b3f), where each known ending sits on that path (signals.cpp:144, PM4 type 0, Unknown opcode, Clamped size, Device lost), and the 3 Oct read-only check of steps 1-5 (GT7 CRASH_MAP #3 = packet reader, chain-bit lead)"
metadata:
  node_type: memory
  type: reference
  originSessionId: 69aee205-f92c-44e7-8367-5be64450ea3e
  modified: 2026-10-02T22:31:44.766Z
---

User, 3 Oct 2026: "save everything we learned ... so we always know the correct order without reading the whole code
again". Built read-only by builder shadps4-lane-f9 (git grep / git show on origin/main + grep of the newest logs).

**Pinned to main bf794b3fe7db0425fdc2f329f705d5d09446882d (2 Oct 2026, "started 0.19.1 WIP").** Line numbers drift
when main moves; the order rarely does. Re-pin with `C:\shadps4-gt7\GT7_upstream\builder_scripts\gpu_path_lines_v1.sh`
(v2-v4 fill the gaps; all read-only `git grep -n` / `git show` on origin/main in C:\shadps4-clean). Permalink form:
`https://github.com/shadps4-emu/shadPS4/blob/bf794b3fe7db0425fdc2f329f705d5d09446882d/<path>#L<n>`.
Files: gnmdriver.cpp = src/core/libraries/gnmdriver; liverpool.cpp, pm4_cmds.h, regs.h, regs_shader.h =
src/video_core/amdgpu; vk_*.cpp = src/video_core/renderer_vulkan; recompiler.cpp = src/shader_recompiler;
decode.cpp, structured_control_flow.cpp = .../frontend; translate.cpp, data_share.cpp = .../frontend/translate;
emit_spirv.cpp = .../backend/spirv; buffer_cache.cpp, texture_cache.cpp = src/video_core/<same name dir>;
memory.cpp, signals.cpp = src/core; driver.cpp = src/core/libraries/videoout.

The game's CPU code is x86-64 and runs directly (nothing translated). What it hands the emulator is GPU work: a PM4
command list plus GCN shader binaries.

### The 22 steps (example: GT7 fs 0x74f5f10c, the "Clamped size" shader)

In the game
1. The shader sits in game memory as GCN code; the game writes a PM4 command list into its memory (shader address,
   user-data pointers, draw).
2. `sceGnmSubmitCommandBuffers` gnmdriver.cpp:2348 -> `sceGnmSubmitCommandBuffersForWorkload` :2311 -> `PerformSubmit`
   :2174 -> `liverpool->SubmitGfx` :2244. Compute queues: `sceGnmDingDong` :293 -> `SubmitAsc` :320/:363.
   Submit-and-flip: :2249 (flip patch `PatchFlipRequest` :2090).

GPU command thread reads the list
3. `Liverpool::SubmitGfx` liverpool.cpp:1167 wraps the list in a coroutine task, `queue.submits.emplace` :1177,
   `submit_cv.notify_one` :1182 (`SubmitAsc` :1185, :1193, :1199). From here on it runs on the GPU thread.
4. `Liverpool::Process` :92 (thread "shadPS4:GpuCommandProcessor" :93) waits :102, round-robins the queues :116-118,
   `task.resume()` :128 -> `ProcessGraphics` :221 (the ccb goes to `ProcessCeUpdate` :155, started :232) reads packet by
   packet: type 2 = padding :251-254, type 0 = UNREACHABLE "Unimplemented PM4 type 0" :248, other = "Wrong PM4 type" :245.
5. `SET_SH_REG` :390 copies the shader address and user data into the emulated registers. Nothing translated yet.
6. `DRAW_INDEX_2` :421 -> `rasterizer->Draw(true)` :436 (`DRAW_INDEX_AUTO` :457/:469). Dispatch: `DISPATCH_DIRECT`
   :574/:590 (ASC :1021/:1044) -> `Rasterizer::DispatchDirect` vk_rasterizer.cpp:313.

The draw asks for the shader
7. `Rasterizer::Draw` vk_rasterizer.cpp:182 (PopPendingOperations :185, FilterDraw :187) -> `GetGraphicsPipeline` :192 ->
   vk_pipeline_cache.cpp:337 -> `RefreshGraphicsKey` :339/:391 -> per stage `regs.ProgramForStage` :507 (regs.h:167) ->
   `AmdGpu::GetParams` :514 = regs_shader.h:243: code pointer = `ShaderProgram::address` (40 bits, :57),
   `SearchBinaryInfo` :224 finds the BinaryInfo block Sony's compiler puts after the code; length -> code span :248,
   `bininfo.shader_hash` :249 = the hash in logs and dumps -> `GetProgram` :516 -> :653.
   Compute: `GetComputePipeline` :367 -> `GetProgram` :616.
8. `GetProgram` `program_cache.try_emplace(hash)` :657. New -> `CompileModule` :662. Known -> pgm_base / user_data
   :676-677, `RefreshFlatBuf` :678, `StageSpecialization` :679, find the permutation :686; none -> `CompileModule` :689
   (new permutation), else reuse :695. `CompileModule` :620: LOG "Compiling {} shader {:#x}" :623, DumpShader "bin" :625.

Translation GCN -> IR -> SPIR-V (first time only)
9. `Shader::TranslateProgram` :627 -> recompiler.cpp:63: first-dword check (s_mov_b32 vcc_hi) :65-69; decode loop :77-79
   (decode.cpp:111 `decodeInstruction`).
10. CFG :86 -> `EmitControlFlowGraph` :87 (def :34) -> `translator.Translate` :43 -> translate.cpp:1202 -> per instruction
    :1220 `TranslateInstruction` :1227 -> switch by category (DataShare :1230-1231 -> `EmitDataShare` data_share.cpp:10;
    S_SWAPPC_B64 -> `EmitFetch` :1213-1216). **Unknown opcode:** `LogMissingOpcode` translate.cpp:1195 (LOG_ERROR
    "Unknown opcode {} ({}, category = {})" :1196, `translation_failed = true` :1199) -> recompiler.cpp:48 ASSERT
    "Shader translation has failed". GoW's DS_ORDERED_COUNT stopped here on main (data_share.cpp:94).
11. Passes on the unstructured IR :94-118: LowerFp64ToFp32 (no f64 only) :95, SsaRewrite :97, ConstantPropagation :98,
    ReadLaneElimination :99, Hull/Domain transforms :100-106, RingAccessElimination :107, **dump pre-res-discover :108**,
    **ResourceDiscoverPass :109** (which V#/T#/S# the shader uses and where each comes from), FlattenExtendedUserdata
    :110, **dump pre-res-patch :111**, ResourcePatchingPass :112, LowerBufferFormatToRaw :113, SharedMemorySimplify :114,
    SharedMemoryToStorage :115, LowerUserClipPlanes :116, PhiSimplification :117, InverseBallotElimination :118,
    **dump pre-lower-phi :119**. (InjectClipDistanceAttributes :91. PR #5218 adds its guard pass in this function.)
12. LowerPhisToRegs :127 -> `BuildASL` :130 (structured_control_flow.cpp:803) -> GenerateBlocks :131 -> PostOrder :132
    -> SsaRepair :135, SsaRewrite :136, SharedMemoryBarrier :137, DCE :138, LowerWave64Ballot :139,
    LowerHardwareIntrinsics :140, ConstProp :141, DCE :142, CollectShaderInfo :143, **final dump :144** (a file write
    when dumps are on; NOT an assert).
13. `EmitSPIRV` vk_pipeline_cache.cpp:628 -> emit_spirv.cpp:658 (DefineMain :661, Assemble :666); DumpShader "spv" :629.
14. Shader patch file (setting) :633-637, else `CompileSPV` :639 -> vk_shader_util.cpp:9/:15 (createShaderModule);
    `RegisterShaderBinary` :642 (disk cache); back in GetProgram `RegisterShaderMeta` :666/:691, `AddPermut` :667/:692.
15. `graphics_pipelines.try_emplace(key)` :342; new -> LOG "Compiling graphics pipeline {:#x}" :345 ->
    `make_unique<GraphicsPipeline>` :348 -> vk_graphics_pipeline.cpp:427 `createGraphicsPipelineUnique` = the host
    driver compiles the SPIR-V into GPU machine code -> `RegisterPipelineData` :352. Compute: LOG :374,
    `make_unique<ComputePipeline>` :377.
    Next launch: `WarmUp` (called vk_pipeline_cache.cpp:327) = vk_pipeline_serialization.cpp:304 loads the saved
    ShaderBinary / ShaderMeta / PipelineKey blobs, refills `program_cache` :270 (CompileSPV :272/:290) and rebuilds the
    pipelines (graphics :234-237, compute :159-163) at boot, so steps 9-15 are skipped for cached shaders.

Every draw: bind the data, record the draw
16. PrepareRenderState vk_rasterizer.cpp:197 -> `BindResources` :198 -> :403 -> per stage `BindBuffers` :425 -> :719:
    per V# `ClampRangeSize` :777 (memory.cpp:102; ASSERT IsValidMapping :110) -> **LOG_ERROR "Clamped size from {} to {}
    for stage {:#x}" :779** -> `ObtainBuffer` :782 (buffer_cache.cpp:170 -> EnsureResident :182, def :276);
    `BindTextures` :426 -> :812 -> `FindImage` :860/:888.
17. BeginRendering :201, BindVertexBuffers :203, BindIndexBuffer :205, FlushBarriers :209,
    `pipeline->BindResources(set_writes, push_data)` :212, UpdateDynamicState :213, scheduler.BeginRendering :214.
18. `scheduler.CommandBuffer()` :220, `bindPipeline` :221, `drawIndexed` :224 / `draw` :227 = RECORDED only; nothing has
    run on the host GPU yet. ResetBindings :232.

To the host GPU and the screen
19. `EVENT_WRITE_EOP` liverpool.cpp:675: `rasterizer->OnFence` :678 (vk_rasterizer.cpp:399 -> texture_cache.cpp:71
    ProcessDownloadImages -> DownloadImageMemory per queued image), `SignalFence` :680 writes the label into game memory
    (TryWriteBacking :682-683) and raises the GfxEop interrupt :685. Unless something flushed earlier, the draws are
    still only recorded at this point. (EVENT_WRITE_EOS ~:661, with a `rasterizer->Finish` at :668.)
20. `sceGnmSubmitDone` gnmdriver.cpp:2355 (WaitGpuIdle :2359, `liverpool->SubmitDone` :2363) -> Process loop
    `if (submit_done)` liverpool.cpp:142 -> OnSubmit :145, `rasterizer->Flush` :146 -> vk_rasterizer.cpp:381 ->
    scheduler.Flush :384 -> vk_scheduler.cpp:107/:112 -> `SubmitExecution` :185 -> `queue.submit` :241 -> ASSERT
    "Device lost during submit" :242. A GPU hang is reported by WHICHEVER submit comes next (see endings below).
21. The host GPU runs the VS per vertex and the driver's code of the FS per pixel, reads what step 16 bound, writes the
    texture cache's host image of the render target.
22. Flip: `VideoOutDriver::SubmitFlip` driver.cpp:292 -> `presenter->PrepareFrame` :326 (vk_presenter.cpp:666, copies the
    display buffer into a frame) -> `VideoOutDriver::Flip` :236 -> `presenter->Present(req.frame)` :241
    (vk_presenter.cpp:843) -> the window.

Steps 9-15 run once per shader (or permutation); steps 1-8 and 16-22 run for every draw.

### Where each known ending sits (checked 3 Oct)
- **signals.cpp:144** (same line in 07a74022, 6b19950f and main): LOG_CRITICAL "Unhandled Exception code {:#x} at {}"
  + Emulator Shutdown :145 = the last-resort Windows exception handler. The address names whose code crashed:
  GT7 CRASH_MAP #5 eboot+0x302a83b (Job thread), #6 eboot+0x18eaf37 (WorkT), #11 libc.prx+0x1cb5e (defTS) = the game's
  own CPU code, outside the 22 steps; **GoT** TEST1 + TEST2 (every run) = nvoglv64.dll+0xee32d (driver 32.0.15.9186) on
  the GPU command thread while "Compiling compute pipeline 0x98170c4bfeeeaffe" right after "Compiling cs shader
  0x14906b6a" = **step 15** (`C:\shadps4-gow\logs\games_test2_runs_audit.txt:148`). **GoW: no log ends there** (all 34
  files of `C:\shadps4-gow\logs` grepped). Do not confuse with recompiler.cpp:144 (final IR dump) or module.cpp:144
  (LoadModuleToMemory Info lines at boot).
- **GoW endings** (line numbers of those builds): TEST2 r1, r2 and TEST1 r2 = buffer_cache.cpp:443
  `SubmitPendingArenaBinds` "Device lost during submit" (GT_DIAG: "setting up: dispatch 1x1x1 groups: cs 0xe75563c7");
  TEST1 r1 = vk_scheduler.cpp:245 `SubmitExecution`; TEST1 r3 = vk_presenter.cpp:1119 `GetRenderFrame` assert.
- Unknown opcode = step 10. "Clamped size" = step 16 ([[shadps4-unbounded-vsharp-clamp]]). GT7 "PM4 type 0" = step 4.

### Steps 1-5, read-only check (3 Oct)
- **GT7 CRASH_MAP #3 "PM4 type 0"** (15 runs; TEST39 r1 and TEST40 r2 = 2 of the last 4 GT7 runs; our builds print
  liverpool.cpp:249, main :248): the reader takes a zero dword as a type-0 header ("base reg 0, size 1"); the log does
  not say where the reader was. Lead, untested: `PM4CmdIndirectBuffer` pm4_cmds.h:887 has `chain` (bit 20 of dw2, :896,
  "set to chain to IB allocations"; ib_size bits 0-19 :895, vmid 24-31 :897) and main never reads it: liverpool.cpp
  :794-805 (GFX) and :928-938 (ASC) always run the sub-buffer and come back to read after the packet; with chain=1 the
  hardware does not come back. Instrument (first job after the reset, user's go): a [test] log at the type-0 stop:
  queue, buffer start + size, top-level or IB, offset of the zero dword, the last ~16 packets with raw headers (IB dw2
  with the chain bit). A chained IB right before it -> fix in step 4 (stop reading the current buffer after a chained
  IB: one general commit); otherwise the same log names the source.
- **GoW**: the only step 1-5 message is "Encountered compute SetQueueReg: vqid = 4, reg_offset = 0xb", 273 (TEST2 r2) +
  306 (TEST2 r1); main logs and skips the packet (liverpool.cpp:1015-1019); the first one comes right before "Compiling
  cs shader 0x20d30df5". SET_QUEUE_REG writes the compute queue's own registers, not shader state: an unlikely hang
  cause; register 0xb not identified.
- Other step-4 messages on main, none in GT7 TEST40 r2 or GoW TEST2 r1/r2: "Unimplemented IT_SET_PREDICATION" :413
  (draws the game wanted skipped get drawn), "unhandled IT_COPY_DATA" :742, "Unimplemented IT_STRMOUT_BUFFER_UPDATE"
  :821, "Unimplemented IT_GET_LOD_STATS" :830, "IT_COND_EXEC used a reserved command" :836, UNREACHABLE "Unknown PM4
  type 3 opcode" :212 (CE) / :847 (GFX) / :1119 (ASC), "Invalid PM4 type" :165 / :917, NextPacket "packet length exceeds
  remaining submission size" :56. Log grep: `builder_scripts\step1to5_logs_v1.sh`.

**Why:** the user wants the order kept so no session has to read the whole code again; every crash question starts
with "which step is this".
**How to apply:** answer "where does X happen / end" from this map; before quoting a line number, re-run
gpu_path_lines_v1.sh against the current origin/main, and re-pin this file if main moved.

Related: [[gt7-shadps4-lane]], [[shadps4-unbounded-vsharp-clamp]], [[gow-fixes-for-pr]], [[gt7-crash-status-20260930]].
