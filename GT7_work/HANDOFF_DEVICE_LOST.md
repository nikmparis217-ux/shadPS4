# HANDOFF: GT7 VK_ERROR_DEVICE_LOST hunt (18 Aug, ~01:30)

Repo: `C:\Users\Νίκος\Documents\GitHub\shadPS4` (use 8.3 path `C:\Users\3E30~1\...` in every tool -
the Greek username breaks python/cmd paths). Build: `GT7_work\build.bat` (Clang, judge by
`BUILD EXIT 0` **and** the exe timestamp - UBT-style "up to date" lies happen here too). Run:
user double-clicks `GT7_work\GT7.bat` -> `run_gt7.ps1` (bypasses the Qt launcher, which overwrites
config.json). **The user runs, Claude reads the log**: `C:\Users\3E30~1\AppData\Roaming\shadPS4\log\shad_log.txt`.
Config is UTF-8 **with BOM** - read/write with `utf-8-sig`. Logs of every run are archived in
`GT7_work\logs\runNN_*.txt`.

## THE ONE METRIC THAT DECIDES A RUN

`grep -c "CompileModule: Compiling" shad_log.txt`
- **182 = THE WALL.** Seven+ unmodified runs all device-lost at exactly 182 shader compiles, with a
  byte-stable fault signature `0x200082xxx` (10-14 instruction pointers inside ~0x2a0 bytes, ZERO
  memory-access faults = hang, not OOB).
- **>182 = passed the wall.** Dying later at `Bindless sharp access detected` (resource_tracking_pass
  assert on `cs_0xa95f906e`, compile #203) counts as PASSING - that is a known, separate recompiler
  limitation, out of scope from the original plan.
- ⚠ The IP addresses are stable **only between runs with the same shader-patch set** - installing
  patches changes module sizes and shifts every address. Do not read address drift as "different bug".

## THE RUN LEDGER (what was tried, what it proved)

| run | change | outcome | conclusion |
|---|---|---|---|
| 19 | ALL 24 loop-shaders capped at 1000 | BindBuffers `adjust%4` assert, never reached the hang | one global cap corrupts GPU-driven data; caps must be per-shader |
| 20 | first 12 capped | device lost @182 | census showed which loop-shaders were really in the hung cmdbuf |
| 21 | only c3d5603f+ef4a0dc6 capped | device lost, EARLIER + new signature | c3d5603f's legit trip count is 16384 (`ceil(bytes/64)`); cap 1000 = corruption |
| 22 | only ef4a0dc6 @65536 | device lost | its loop is not the hang |
| 23 | no patches, host passes journaled | device lost @182, signature IDENTICAL to run 1 | HOST-detile IS in the hung cmdbuf (155x) but clamp never fired; addresses stable |
| 24 | ef4a0dc6 barrier REMOVED (loop kept) | device lost | its in-loop barrier is not the hang either - shader exhausted |
| 25 | 7c3468f9+6421a7b6 v2-capped (sound counter) | device lost @182 | ALL SIX loop-bearing guest shaders in the hung cmdbuf validly excluded |
| 26 | **GT_SPLIT_DISPATCH=1** (submit per dispatch) | **PASSED: 203 compiles**, died at Bindless | the hang is NOT a shader; a submit boundary cures it |
| 27 | GT_DISPATCH_BARRIER=1 (full memory barrier per dispatch, ONE submission) | device lost @182 | NOT memory visibility between GPU commands |
| 28 | GT_SPLIT_DISPATCH=64 | PASSED the wall (195), later device fault @`0x2000f58xx` | the exact boundary does not matter; risk scales with the parse->execute lag window |
| 29 | **GT_DEFER_EOP=1** (gfx EOP/EOS fences deferred to real GPU tick, NO split) | device lost @**97** (earlier - honest pacing is slower), classic signature | gfx-queue fence deferral ALONE does not cure it |

## THE SURVIVING HYPOTHESIS (strong, one experiment from proof)

**shadPS4 signs "the GPU finished" fences at PARSE time, before the translated work is even
submitted.** `PM4CmdEventWriteEop/Eos::SignalFence` and `PM4CmdReleaseMem::SignalFence` write guest
memory synchronously in `liverpool.cpp`. A GPU-driven game (GT7) believes the fence, recycles
command/argument/ring memory, and the real GPU work then consumes recycled bytes -> garbage indirect
args / descriptors -> unbounded work -> TDR with zero memory faults. This explains EVERY observation:
stable one-shader signature (same consumer), immunity to loop caps and barriers, cure by ANY
submission splitting (shrinks the parse->execute window), probabilistic onset after ~2900 identical
frames.

Run 29's failure does NOT kill it: only the **gfx** EOP/EOS were deferred. The **compute queues'
`ReleaseMem`** (liverpool.cpp ~line 1144, ASC coroutines) is still eager - and the split that cured
the wall split at **dispatches**, i.e. exactly the compute-queue stream. GT7's GPU-driven streaming
runs on those queues.

### NEXT CONCRETE STEP (was mid-implementation when this handoff was written)
Defer `ReleaseMem` fences the same way, behind the same `GT_DEFER_EOP` env var:
- Copy the packet **by value** (it lives in ring memory the game reuses - reading it later IS the bug
  being fixed).
- `rasterizer->GetScheduler().DeferPriorityOperation(...)` - NOT `DeferOperation` (ordinary queue only
  drains on the next submit; a game quietly polling the fence would deadlock). Then
  `rasterizer->Flush()` immediately, or the deferred tick never completes.
- ⚠ `ReleaseMem::SignalFence(signal_irq, gds_to_mem)` has a **GDS variant** whose lambda calls
  `rasterizer->CopyBuffer(...)` = records GPU commands; running that on the priority thread is a data
  race. Defer ONLY plain memory-write fences (data_sel Data32/Data64/GpuClock64/PerfCounter); keep the
  GDS path synchronous. Packet struct: `pm4_cmds.h` line ~892 (`PM4CmdReleaseMem`, SignalFence ~937).
- `Flush()` from ASC coroutine context is proven safe empirically (the split hook did it for whole runs).
- Self-wait safety confirmed: gfx `WaitRegMem` busy-waits with `YIELD_GFX` (liverpool.cpp:876-893),
  ASC with `YIELD_ASC` (:1200) - both release once the priority thread writes the fence, which it can,
  because the Flush handed the work to the driver.
- If EOP+ReleaseMem deferred (no split) passes the wall -> **root cause proven**; the fix direction is
  honest fences (possibly with a lighter completion mechanism than a full Flush per fence).
- If it STILL hangs -> eager fences are exonerated; the remaining discriminator is that split(1,64)
  passes and everything else fails, i.e. per-submission workload size. Next: N-scan upward
  (GT_SPLIT_DISPATCH=512, 4096) to find the threshold, and consider the TDR/preemption story
  (one giant uninterrupted submission; TdrDelay registry experiment was declared out of scope).

## CURRENT STATE OF THE WORKING TREE (all diagnostic changes env-gated, default off)

- `src/video_core/renderer_vulkan/vk_master_semaphore.{h,cpp}`: **Refresh() refuses impossible ticks**
  (the driver returns `eSuccess` + `0xFFFF...F` after a hang; accepting it disabled ALL lifetime
  tracking at once and buried the real fault under 3277 secondary errors). `HasDeviceLost()`,
  `HasSeenBogusTick()`. Wait() logs the fault and UNREACHABLEs on device lost.
- `src/video_core/renderer_vulkan/vk_instance.{h,cpp}`: the **GPU work journal** (32768-entry ring;
  8192 was smaller than one command buffer and silently dropped 2657 entries of the hung buffer),
  SubmitRecord ring (tick **+ timeline index** - ticks are per-scheduler and matching on tick alone
  copied the draw census into present/flip), IN FLIGHT census per scheduler (256-shader table;
  distinct-vs-entries mislabel fixed), host passes journaled as `HOST-detile/tile` kinds, cmdbuf
  ownership table, buffer graveyard, device-fault dump with honest SUMMARY wording ("parked
  invocations", NOT "a loop" - that word cost six runs).
- `src/video_core/renderer_vulkan/vk_scheduler.cpp`: RegisterTimeline/RegisterCommandBuffer/
  MarkGpuWorkSubmitted wiring (submitted-only, after vkQueueSubmit succeeds).
- `src/video_core/texture_cache/tile_manager.cpp`: `ClampTilingMips` (real host stack-overflow bug:
  `num_mips` unchecked against `mips[16]`, and it is the ONLY bound of tiling.comp's GetMipLevel
  loop; robustBufferAccess makes the OOB read zeroes = hang shape) + journals both dispatch sites.
- `src/video_core/renderer_vulkan/vk_rasterizer.cpp`: `GT_SPLIT_DISPATCH=N` (flush every Nth
  dispatch, both Direct and Indirect sites) and `GT_DISPATCH_BARRIER=1` (full MemoryBarrier2 after
  every dispatch). Also pre-existing from earlier: TryReadIndirectArgs journaling.
- `src/video_core/amdgpu/liverpool.cpp`: `GT_DEFER_EOP=1` defers **gfx EventWriteEop + EventWriteEos
  (SignalFence case only)** to the real GPU tick via DeferPriorityOperation + Flush; packet copied by
  value. GdsStore stays synchronous. **ReleaseMem NOT yet deferred - that is the next step.**
- `GT7_work/run_gt7.ps1` currently sets: `GT_SPLIT_DISPATCH=0`, `GT_DISPATCH_BARRIER=0`,
  `GT_DEFER_EOP=1`. Flip these per experiment - ONE variable per run.
- **PSN lane (18 Aug, separate workstream):** run_gt7.ps1 gained a `-Net` switch (used by
  `GT7_PSN.bat`): starts `psn_local\shadnet_local_server.py` (a local shadNet server on
  127.0.0.1:31313), flips `shad_net_enabled`/`connected_to_network` on and the game boots
  SIGNED IN. **Default runs (plain GT7.bat) force both flags FALSE**, so the hunt's baseline
  is untouched - but a -Net run overrides env to SPLIT=1/DEFER_EOP=0 for runway, so never
  read a -Net log as a wall experiment. Also from this lane:
  - `src/core/libraries/network/{sockets.h,posix_sockets.cpp}`: **PosixSocket::Connect now
    reports the real completion of a non-blocking connect on Windows** (NOT env-gated - a
    correctness fix). Winsock answers WSAEALREADY to connect() re-polls forever even after
    the attempt FAILED (BSD/PS4 returns the real error once done), so GT7's SimpleTcpClient
    spun eternally on a refused connection (run30's predecessor: 28k+ "error code: 37" lines).
    Now: select()+SO_ERROR verdict, cached per socket (`win_nb_connect_error`) because
    Windows clears SO_ERROR on first read. Known residue: when the GAME consumes SO_ERROR
    itself first, the verdict can degrade to ORBIS_NET_EINTERNAL(204) instead of
    ECONNREFUSED(61) - still definitive, GT7 tears down cleanly and moves on.
  - **Windows hosts file** now pins `asset.gt7.game.gran-turismo.com`,
    `portal.gt7.game.gran-turismo.com`, `api.develop-stable.vegas.granturismo-online.net`
    to 127.0.0.1 (marker-tagged lines; undo = `psn_local\hosts_redirect.ps1 -Undo` elevated).
    Reason: sceSsl is a stub, so the game's own HTTPS can NEVER complete - refused-fast
    beats the eternal sceSslWrite spin (19k+ calls, boot frozen at 13 compiles), and the
    emulator stops poking Polyphony's real AWS endpoints.
  - `logs/run30_PSN_SIGNEDIN_past_wall_bindless_203.txt`: -Net run, signed in, ZERO EALREADY
    spam, network phase passed, died at the KNOWN bindless assert at compile 203 (same as
    run 26 - consistent with SPLIT=1 passing the wall).
- Shader patch dir `...\shadPS4\shader\patch\` is EMPTY (all patches retired; `patch_shaders=True`
  stays in config, harmless). Backup `config.json.pre_shaderpatch` exists. Loop-cap tooling lives in
  `GT7_work/patchwork/`: `add_loop_guard.py` (v1 - ⚠ counter unsound for 27/63 loops whose exit is a
  nested break), `add_loop_guard2.py` (v2 - counter in the continue block = always sound;
  `GT_NOBREAK=1` disables its break-insertion path, which has an undiagnosed dominance error on
  nested loops), `cap_all_loops.py`, `bisect_loops.py`, `drop_loop_barrier.py`, `set_dump_shaders.py`.

## FACTS THAT KEEP BEING RE-DERIVED (don't)

- Shader dump (`shader\dumps\`): 194 .spv from a `dumpShaders` run - 55 cs / 83 fs / 53 vs / 2 gs /
  1 es. **Only 25 have loops, ALL compute.** All 69-70 distinct shaders of the hung cmdbuf are in the
  dump (verified, 0 missing). `cs_aaa36b0e` (biggest dispatch, 13.8M invocations) is 167 instructions,
  0 loops = milliseconds, NOT a hang candidate.
- The `.spvasm` files in GT7_work are UTF-16 - grep finds nothing; always `spirv-dis` the real .spv
  (SDK at `C:\VulkanSDK\1.4.357.0\Bin`).
- The vendor dump `log\device_fault.bin` (NVIDIA, AD104/RTX4070, r590) is opaque without the
  Aftermath SDK; strings give only GPU/driver/date.
- The present/flip schedulers journal NO work of their own - their census ranges are copies of draw
  work. Compare DRAW command buffers only.
- shadPS4 log lines have NO timestamps. Progress is measured in compile count / submissions kept.
- `assert_fail_impl` runs `Emulator::Shutdown()` BEFORE `Crash()` - a "clean-looking" tail can still
  be an assert death; grep for `Assertion Failed` and `Unreachable`.
- Untouched known bugs found by validation earlier (separate from the hang):
  `VUID-vkCmdDraw-magFilter-04553` (LINEAR on integer video formats), frame-image layout mismatch in
  host passes, `vkResetFences`/`vkAcquireNextImageKHR` misuse in the present path,
  `ObtainBufferForImage` never consults `IsBufferInvalid`.

## METHOD RULES THAT PAID FOR THEMSELVES

1. **One variable per run.** The monitor classifies by the compile-count wall, not by exit code.
2. A cap/guard only exonerates if the guarded thing **cannot** fail any more - check the arithmetic
   (1e6 cap on a 32-iteration loop proved nothing; a counter in a block that is skipped counts wrong).
3. Clustered fault IPs prove ONE shader with parked invocations - **not** "a loop". Barrier
   divergence and giant work look identical there.
4. When a symptom has a familiar name, test the name against cheap evidence before acting
   (dumpmatgraph/log-grep class of checks).
5. Every conclusion that mattered came from making the instrument print what it could NOT see
   (scrolled-out entries, host passes, unsound counters).
