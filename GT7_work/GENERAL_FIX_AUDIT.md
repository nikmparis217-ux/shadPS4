# General-fix audit of the GT_* gates (6 Sep 2026)

Rule, from the user (6 Sep): every fix that ends up in the final build must be a general fix
for every game - the emulator is a console implementation, not a set of per-game patches.
Environment gates, shader-hash lists and "turn a setting on for this game" are allowed only
while a title is being brought up; before a title is called done, everything that works becomes
default behaviour with no gate, or it is removed. This file is the inventory that plan works from.

90 gates under `src/` (`grep -rhoE 'getenv\("GT_[A-Z0-9_]+"\)' src | sort -u`), classified by
reading every use. DEFAULT is what happens when the variable is unset.

| class | count | what to do in the final build |
|---|---|---|
| FIX | 19 | become default-on, gate removed (15 of them are OFF today - a normal user never gets them) |
| PERF | 16 | measure each on GT7 + GoW; default-on if stable, else remove |
| EXPERIMENT | 20 | decide: promote the proven ones to FIX, delete the rest |
| HACK | 6 | delete, or replace by a general mechanism (the ReadConst fix is the model) |
| DIAG | 29 | drop from the PR, or keep only as ordinary debug settings of the emulator |

## Launcher dependencies today

`run_gt7.ps1` sets, for every mode: `GT_SPLIT_DISPATCH=64`, `GT_DISPATCH_BARRIER=0`,
`GT_DEFER_EOP=1`, `GT_STORE_CLAMP=1`. With `-Net`/`-Offline` also: `GT_DEFER_RELEASEMEM=1`,
`GT_BINDLESS_STUB=1`, `GT_STALL_DUMP=1`, `GT_SOFT_CLAMP=1`, `GT_BINDLESS_LOWER=1`,
`GT_BINDLESS_IMG=1`, `GT_BINDLESS_STORES=1`, `GT_BINDLESS_IMGARRAY=16`, `GT_IMGARRAY_SYNC=0`,
`GT_IMGARRAY_SYNC_MAX=64`, `GT_IMGWRITE_SCRUB=1`, `GT_RT_SCRUB=92126594`, `GT_HASH_BASELINE=1`,
`GT_DYNRC_WINDOW=1`, `GT_DYNRC_GPU=0`, `GT_LUT_IDENT=0`, `GT_INVAL_IMG_ON_SSBO=0`.
So GT7 today depends on: DEFER_EOP, DEFER_RELEASEMEM, SOFT_CLAMP, STORE_CLAMP, DYNRC_WINDOW,
BINDLESS_LOWER/IMG/STORES/IMGARRAY=16, HASH_BASELINE, plus the workarounds BINDLESS_STUB,
IMGWRITE_SCRUB, RT_SCRUB=<hash> and the SPLIT_DISPATCH=64 submission change.

`run_game.ps1` (God of War) sets nothing. GoW runs gate-free on the same binary.

## FIX (19) - correctness; all of these become default

| gate | default | what it does |
|---|---|---|
| GT_DEFER_EOP | off | gfx EOP/EOS fences signalled at the real GPU tick, not at PM4 parse time |
| GT_DEFER_RELEASEMEM | off | same for the compute queues' RELEASE_MEM completion fences |
| GT_STORE_CLAMP | off | OpUMin every storage-buffer store/atomic index against OpArrayLength |
| GT_SOFT_CLAMP | off | torn GPU-driven descriptor (unmapped/misaligned/oversized) null-binds instead of asserting |
| GT_DYNRC_WINDOW | off (N dwords) | SRT walker copies an N-dword window per base pointer so windowed ReadConsts index real data |
| GT_BINDLESS_LOWER | off | untrackable bindless ReadConstBuffer -> GPU-time BDA read instead of stubbing the shader |
| GT_BINDLESS_IMGARRAY | off (N slots) | runtime-indexed T# arrays as windowed, UMin-clamped image bindings |
| GT_IMGARRAY_SYNC | off (mode) | read back GPU-written windowed T# tables before a dispatch |
| GT_INVAL_IMG_ON_SSBO | off | GPU writes through unformatted SSBOs also notify the texture cache |
| GT_GPUWRITE_NOCLOBBER | off | orphan GpuDirty with no tracked buffer keeps the GPU image, no re-upload of guest RAM |
| GT_RT_NOCLOBBER | off (mode 2) | RefreshImage does not re-upload guest RAM over a GpuModified render/depth target |
| GT_VERTICAL_ALIAS | off | vertically overlapping images aliasing one range copy the newer content |
| GT_CLEAR_RAW | off (presence) | clear colour gets only the format remap, not a second comp_swap permutation |
| GT_RESOLVE_SWAP | off (presence) | MRT resolve with differing comp_swaps goes through a swizzling draw copy |
| GT_LOOP_WRAP_GUARD | off | decrement-by-one loop exit `!= C` rewritten to `> C` so a zero count cannot wrap 2^32 |
| GT_HASH_BASELINE | ON | content-hash baseline also recorded on GpuDirty refreshes |
| GT_TESS_LANEFIX | ON | tess-constant walker folds ReadLane(chain,k), visits WriteLane once |
| GT_ZERO_VRAM | ON | device-local buffers and clearable colour images zero-initialised |
| GT_ZPASS_FAKE | ON | rising fake occlusion result for every ZPASS_DONE event |

## HACK (6) - delete or generalise

| gate | what it does | general replacement |
|---|---|---|
| GT_18256C0_GUARD / _LOOP_MAX | clamps two flatbuf dwords for shader 0x018256c0 | STORE_CLAMP + LOOP guards by default; then remove |
| GT_RT_SCRUB=<hash list> | scrubs non-finite / fp16-ceiling colour outputs of named fragment shaders | find why those shaders produce inf (windowed image writes landing? see IMGARRAY_SYNC) |
| GT_STUB_SHADERS=<hash list> | no-op module for listed program hashes | none - a stub is never a fix |
| GT_IMGZERO | zero-seeds one image shape (64x64x>=512 B10G11R11) | ZERO_VRAM already covers creation; the upload path needs the NOCLOBBER fixes |
| GT_LUT_IDENT | identity LUT for any 64^3 RGBA16F volume | the compute-baked LUT must be produced (IMGARRAY_SYNC + INVAL_IMG_ON_SSBO) |

## EXPERIMENT (20) - promote or delete

GT_BDA_IMPORT, GT_BINDLESS_IMG (on), GT_BINDLESS_STORES (on), GT_BINDLESS_STUB, GT_CONDEXEC,
GT_DETILE_MAXMB, GT_DISPATCH_BARRIER, GT_DYNRC_GPU, GT_DYNREADCONST_STUB, GT_FCE_FORCE,
GT_IMGARRAY_FB0, GT_IMGWRITE_SCRUB, GT_IMG_MAXMB, GT_READBACKS_ONRACE, GT_RT_FORCECLEAR,
GT_SKIP_EMPTY_DYNRC (on), GT_SKIP_TESS, GT_SPLIT_DISPATCH, GT_TESS_REGION.
Open questions each of these answers are listed in ACT2/ACT3; the ones GT7 runs with today
(BINDLESS_STUB, IMGWRITE_SCRUB, SPLIT_DISPATCH=64, SKIP_EMPTY_DYNRC) need a real fix underneath
before they can go.

## PERF (16) - measure, then default or delete

GT_BIND_SKIP, GT_BUFFER_GC (on), GT_DETILE_CHUNK, GT_DIRECT_IMPORT, GT_DMA_DIRTY_LOG,
GT_FAST_PROTECT, GT_FAULT_WIDE, GT_HOT_PIN, GT_HOT_PIN_DECAY, GT_IMGARRAY_SYNC_MAX,
GT_READ_PREFETCH, GT_READ_WINDOW, GT_SLEEPQ_MUTEX, GT_STREAM_MEMO, GT_TEX_GC (on),
GT_TEXEL_MEMO. GT_BUFFER_GC is a correctness matter in practice (upstream never calls its own
buffer GC); GT_DMA_DIRTY_LOG is the first lever for the selective-DMA shaders' cost.

## DIAG (29) - not part of the product

GT_ACB_WATCH, GT_AUTOSHOT, GT_CACHE_VERIFY, GT_CB_TRACE, GT_DUMP_HASHES, GT_EXPO_TRACE,
GT_FAULT_HIST, GT_FRAME_PROF, GT_GPU_CHECKPOINTS (on), GT_HDR_DRAWPROBE, GT_HDR_DRAWPROBE_PS,
GT_HDR_DRAWPROBE_S, GT_HDR_PROBE, GT_HDR_PROBE_S, GT_HDR_TEXPROBE, GT_HDR_TEXWATCH,
GT_HOSTIMPORT, GT_IMG_CENSUS, GT_IMG_TRACE, GT_INDARGS_GPU, GT_LUT_DUMP, GT_LUT_DUMP_INTERVAL,
GT_NO_GUEST_DUMP (on), GT_READ_TRACE, GT_STALL_DUMP, GT_TESS_DUMP, GT_THREAD_PROF,
GT_WATCH_SIZE, GT_WATCH_VA. The device-fault / checkpoint / journal reporting is worth
keeping as a normal emulator debug option (it is what named every hang so far).

## Order of work

1. Flip the 15 off-by-default FIX gates to default-on one family at a time, GT7 + GoW run
   after each (cache generation already hashes every gate, so a flip recompiles honestly).
2. Replace the 6 HACKs by the general mechanism they stand in for; RT_SCRUB last.
3. Decide the 20 EXPERIMENTs; the four GT7 depends on need the underlying bug fixed.
4. Measure the PERF levers with the fps counter on both titles.
5. Strip DIAG for the upstream PR; keep fault reporting as a debug setting.
6. Final proof: both titles run from launchers that set no GT_* at all.

## Ungated defects found and fixed on the way (6 Sep, God of War run 008)

- The SRT walker's pointer resolution accepted any GetUserData/ReadConst found anywhere
  upstream of a pointer (BFS), so GPU-computed pointers (Phi, loaded through a V#) were chased
  on the CPU, faulted, and were patched to zero. Now: strict adjacent-dword-pair resolution,
  everything else is a GPU-time read. No gate.
- The signal-handler patch was persisted: walker bytes were serialized from the LIVE code
  after the first (in-compile) run. Now stored as generated. No gate.
