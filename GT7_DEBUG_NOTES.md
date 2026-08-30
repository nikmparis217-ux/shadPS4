# GT7 Debug Notes

## 2026-08-26 - Initial repository audit

### Repository state

- Checkout: `C:\Users\Νίκος\Documents\GitHub\shadPS4`
- Branch/HEAD: `gt7-v0.18.0` at `6f8b38ed` (`v.0.18.0-41-g6f8b38ed-dirty`).
- Base: upstream tag/commit `v.0.18.0` / `e3ce810f`; `origin/main` is `5869ff1e` (0.18.1 development).
- Worktree was inspected before editing. Existing user state is preserved: modified submodule worktree `externals/sirit` plus many untracked `GT7_work`/handoff artifacts.
- This file is the only change made by this audit so far.

### Architecture relevant to GT7

- Guest GNM entry points and submission: `src/core/libraries/gnmdriver/gnmdriver.cpp`.
- PM4 parsing and Liverpool GPU state: `src/video_core/amdgpu` and `src/video_core/liverpool.*`.
- Vulkan draw/dispatch and state binding: `src/video_core/renderer_vulkan/vk_rasterizer.*`.
- Shader translation: `src/shader_recompiler` (GCN frontend -> IR passes -> SPIR-V backend).
- Shader/pipeline creation and serialization: `src/video_core/renderer_vulkan/vk_pipeline_cache.*` and `vk_pipeline_serialization.*`.
- Buffer/descriptor address translation: `src/video_core/buffer_cache` plus shader SRT/resource tracking passes.
- Images, tiling, render targets, and aliases: `src/video_core/texture_cache` and `src/video_core/renderer_vulkan/tile_manager.*`.
- Queueing/synchronization: Vulkan scheduler/rasterizer/presenter paths under `src/video_core/renderer_vulkan`.
- Presentation: `vk_presenter.*`, reached successfully in prior GT7 runs.
- Logging: common category logger plus extensive budgeted, environment-gated GT7 diagnostics already added throughout the graphics paths.

### Proven pipeline progress

Existing run ledgers and logs prove all of the following execute: executable/module loading, kernel/filesystem startup, Vulkan initialization, GNM command submission, shader translation, Vulkan pipeline creation, resource/render-target binding, draw/dispatch, and presentation. Runs documented in `GT7_work/HANDOFF_RENDERING*.md` reached Music Rally driving and the world map. Therefore the earliest current rendering divergence is after command/state decoding, in shader resource interpretation and image contents, not initial presentation.

### Current custom work

The branch contains 41 commits beyond v0.18.0. Major GT7-specific areas include PRT/array image handling, SRT dynamic-window and bindless lowering, descriptor/address guards, texture reupload/hash tracking, synchronization and device-fault diagnostics, shader stubbing/dumps, buffer lifetime experiments, and pipeline-cache serialization. These are already committed; none were rewritten during the audit.

### Latest failure and current fix under test

- Runs 170/171 crash deterministically on `shadPS4:GpuCommandProcessor` at host address `0x700000b33500`, writing `0x700000b3348d`.
- Commit `6f8b38ed` attributes this to a serialized raw SRT walker containing an absolute `CopyDynrcWindowClamped` address from a prior local binary. A relink moved the helper while the old cache generation remained accepted.
- The patch mixes `SrtWalkerHelperAddress()` into `BuildGeneration()`, so a helper-address change invalidates incompatible serialized walkers.
- Status: code evidence is strong, but the fix is not yet verified by a fresh build/run in this audit.

### Ranked current hypotheses

1. **Dynamic SRT/bindless descriptor interpretation remains the highest-probability rendering defect.** Prior runs required GPU-time lowering and descriptor guards; remaining visual errors and stalls correlate with dynamic resource tables and torn/stale descriptors.
2. **3D LUT/image view interpretation is the highest-probability color/post-processing defect.** Recent commits/log notes say the baked 64^3 LUT is correct but the sampled result is rotated; `dst_sel`, view type/layer interpretation, or tiled-address mapping is therefore a narrower target than shader arithmetic generally.
3. **Texture cache CPU reupload can overwrite GPU-produced aliased content.** Recent guest-hash baseline commits directly target this, but it needs an A/B run on the current binary.
4. **Cross-queue synchronization/resource lifetime remains a stability risk.** Prior buffer GC device losses and explicit DMA barriers show real multi-queue hazards; buffer GC is intentionally disabled pending all-queue retirement.
5. **Unsupported PM4/GNM or basic presentation is currently lower probability.** Existing deep runs submit large workloads and present useful 3D output; no current evidence identifies an unknown packet as the first divergence.

### Next test

1. Build current HEAD using the repository's established Windows/Clang short-path procedure.
2. Verify the produced executable timestamp/size and build diagnostics.
3. Run the normal GT7 configuration with the new cache generation and capture a fresh log.
4. Confirm that old cached walkers are rejected/rebuilt and that the run no longer repeats the run-170/171 host AV.
5. If stable, inspect the first incorrect LUT/resource binding using the existing focused trace gates before changing behavior.

## 2026-08-26 - Run 172 (normal configuration)

- Build: successful Clang `RelWithDebInfo`; fresh `shadps4.exe` (72,338,432 bytes) and PDB linked at 21:05. Bundled libusb emitted warnings; project link succeeded.
- Configuration confirmed by the emulator log: validation off, pipeline cache on, global DMA off, revision `6f8b38ed`.
- **Cache-generation fix verified:** log line 111 says the prior cache was written by a different build, was ignored, and was refilled. The run did not repeat the run-170/171 host write AV.
- New result: Vulkan device lost during submit after roughly 77,675 journal entries. Saved as `GT7_work/logs/run172_cachegen_fixed_devicelost.txt`.
- Device-fault extension was not enabled/supported for this device in this run, so there are no driver fault-address records. A stale vendor dump file still exists; it must not be attributed to run 172.
- Draw scheduler ticks 6564..6565 and present tick 2436 were unfinished. The in-flight journal contains many compute shaders, host detiles, and draws; the newest submitted `cs_e3dae865` is not by itself evidence of guilt.
- Buffer graveyard census reports no unmet retirement tick among the newest 256 entries, but that does not prove safety across the separate present/flip schedulers. The diagnostics explicitly request a synchronization-validation run to identify any destroyed resource still referenced by a named command buffer.
- Next test: run `GT7_sync.bat`, then search for `VUID-vkDestroyBuffer-buffer-00922`, `VUID-vkDestroyImage-image-01000`, sync hazards, and the owning command-buffer handle.

## 2026-08-26 - Run 173 (synchronization validation)

- Emulator log proves `VK_LAYER_KHRONOS_validation` loaded and both master validation and synchronization validation were enabled.
- No `VUID-*`, `SYNC-HAZARD`, `vkDestroyBuffer`, or `vkDestroyImage` validation report appeared before termination. This is negative evidence only for the executed prefix; it does not clear all resource lifetime/synchronization hypotheses.
- Failure mode changed from device lost to a guest wild jump on `Job#56`: execution at unmapped/NX `0x5748957e`. Register and guest-stack context point back into `eboot.bin`; a minidump was written.
- Saved artifacts: `GT7_work/logs/run173_sync_wildjump.txt` and `GT7_work/logs/run173_sync_guest_crash.dmp`.
- Interpretation: the validation layer perturbs timing enough that run 173 is not a reproduction of run 172. It did not provide the requested command-buffer/resource VUID proof. Do not treat the absence of VUIDs as proof that the normal-run device loss is unrelated to synchronization.
- The cache was again rejected as a different build in this validation process. Run 172 aborted before normal shutdown, so this can simply be the same old on-disk cache being rejected again; it is not evidence that the new generation changes across processes. The executable is intentionally fixed-address (`0x700000000000`) in this project, as noted beside `CopyDynrcWindowClamped`.

## 2026-08-26 - Candidate fix after runs 172/173

- `GT_STORE_CLAMP` was implemented after runs 139/147/149 traced device faults to an unchecked storage-buffer index in `cs_6421a7b6`; runs 151-155 were recorded stable with it enabled.
- `run_gt7.ps1` did not set the gate, so normal runs compiled unclamped SPIR-V. Run 172's unfinished draw tick contains `cs_6421a7b6` twice, matching the known family.
- Patch: default `GT_STORE_CLAMP=1` while keeping the producer shader live, and mix the code-generation gate into `BuildGeneration()` so an unclamped cached module cannot bypass it.
- Test: rebuild and verify that a normal run passes the previous ~77.7k-operation device-loss point.

## 2026-08-26 - Run 174 (`GT_STORE_CLAMP=1`)

- Console proved `GT_STORE_CLAMP=1`; the cache generation changed and all touched shaders recompiled.
- Result: the previous failure moved from ~77,675 to 152,242 submitted journal entries. `cs_6421a7b6` is absent from the unfinished tick, supporting the known store-clamp diagnosis.
- A later device loss remains. Its complete unfinished tick contains only `cs_e3dae865`, `cs_a911a841`, and `cs_ef4a0dc6`.
- Saved log: `GT7_work/logs/run174_storeclamp_devicelost.txt`.
- Next diagnostic: `GT_SPLIT_DISPATCH=1` so each dispatch receives a separate timeline tick and the three-shader set can be reduced to one. `run_gt7.ps1` now honors a parent override for this variable.

## 2026-08-26 - Runs 175/176 (submission boundary)

- Run 175, `GT_SPLIT_DISPATCH=1`: passed both the run-172 and run-174 walls without device loss or guest crash; stopped manually after the diagnostic answered its question. Log: `run175_split1_passed_walls_userstop.txt`.
- Because splitting prevents the hang instead of naming one persistent shader, the remaining issue is tied to submission length/host submit processing rather than uniquely to `e3dae865`, `a911a841`, or `ef4a0dc6`.
- Run 176, `GT_SPLIT_DISPATCH=64`: also passed both walls and remained alive beyond 38k log lines; stopped manually. This reduces the diagnostic's additional-submit frequency by approximately 64x. Log: `run176_split64_passed_walls_userstop.txt`.
- Adopted `GT_SPLIT_DISPATCH=64` as the normal baseline default. Existing `-Net/-Offline` mode still selects its previously proven `1` setting.
- Regression risk: extra submits can reduce throughput and alter timing. N=64 is evidence-backed for the tested boot prefix, but a longer driving session is still required before claiming full stability.

## 2026-08-30 - Real-PS4 reference frames (YouTube captures, Music Rally / Alsace Village)

The user supplied real-hardware captures of the exact scene the perf runs use. Three visual
ground truths for the wash / red-map arc, recorded here so the eventual fixes have a target:

- The top-right minimap is a WHITE track OUTLINE on a TRANSPARENT background. There is no
  red panel anywhere: our solid-red rectangle with white arrows is the "map produced on
  zeros" artifact (BDA first-read-zero; the one-shot producer ran once on an unregistered
  page) plus whatever ships as the fallback clear color - the arrows we render are the only
  part that survives.
- Exposure: normal blue sky, dark shadowed trees, full contrast in both the in-race cockpit
  view and the rotating aerial menu flyover. Our renders wash toward white in exactly those
  scenes - the exposure chain, not the scene, is at fault.
- The aerial flyover frames (menu background) are a per-pixel reference for the menu scene
  that currently renders half-white.
