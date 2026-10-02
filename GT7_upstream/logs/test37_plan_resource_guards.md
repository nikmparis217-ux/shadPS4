# Plan: bind only the images and samplers a draw can read (root of GT7 crash classes 2, 4, 7)

## Context

The user rejected the T# check (d833bab4) as a symptom guard ("we find the core of the problem ... and fix it
there"). Read-only research on 30 Sep (no build, no run) found the core.

**Root cause.** A PS4 GPU reads a T#/S# only when an executed instruction uses it, so a slot behind a uniform
branch the draw does not take may hold anything. shadPS4 decodes, specializes on, compiles against and binds every
declared image and sampler on every draw.

**Measured on GT7 (TEST36 profile cache `C:\shadps4-test19-gt7\user\cache\CUSA24767`, logs in `GT7_upstream\logs`):**
- fs 0x2a265dff reads fs_img0, fs_img1 and fs_samp0 only inside `if (0u != srt_flatbuf.data[50u])`; data[50] is 0
  in all 39 permutation snapshots. The slots hold matrices, stale T#s and PM4-like dwords; the live fs_img2 is
  byte-identical in all 39, so the 39 permutations are driven by garbage alone (the review found the metas differ
  only in those key bytes and the flat buffer). Permutation 26's fs_img1 decodes as a pow2pad cube, tiling index
  24, 9 mips; the patching pass even swaps a guarded sample for the FMask constants when the garbage decodes as FMask.
- Crash classes this explains: **class 7** (tiling index 27/29 UNREACHABLE; test32 prelaunch:1351397 reads image #1
  of fs 0x2a265dff, a guarded slot, with float dwords); **class 4** (Protect at address 0 while setting up a draw of
  fs 0x2a265dff whose only unguarded image is valid); **class 2** (GPU fault in the 64 KiB staging hole: a
  ±1.0-float T# with base 0x3f80000000 decodes as a 16384x16384x8 cube whose u32 size wraps to 0, then a 0-byte
  staging ref is read with a 64 KiB stride). Class 2's T# is the same family as the dead slots, but no cached meta
  contains it (metas only record compile-triggering draws), so its link is inferred, not proven: TEST37 decides.
- Census of 1187 cached GT7 shaders: 469 (74% of fragment shaders) have images/samplers read only under
  flat-buffer conditions, 3397 slots. God of War has the same pattern. No upstream issue or PR prunes by use
  (#4884/#4889/#4934 T# checks, #5137 default S#, #4701/#5008 null descriptors all judge a sharp by its contents).
- Spot checks of real flat buffers: 0xa688735e and 0x2dfb96ae have dead slots behind `f[237] > 0.0` / `f[134] > 0.0`
  with -10000.0, `d[241] > 0u` with 0, and a float weight guard `!(1.0 <= (1 - f[287]) - clamp(max(0, f[294]), 0, 1))`
  with f[287] = 0.0, f[294] = 1.0 (live, exact values). Every dead decision seen is an exact integer or float compare.

**User decisions (30 Sep):** images + samplers only (buffers later, same mechanism); proof = TEST37 judged by
lines the log already has; d833bab4 (T# check) and 9dce3330 (SnormNz) are dropped in TEST37 (both reverse-apply
cleanly on 04558db8).

## The fix

A new recompiler pass finds, for every sampled-image and sampler group, the uniform branch conditions that must
hold for any of its uses to run, and stores them as a small expression table over flat-buffer dwords. Each draw
evaluates the table on the flat buffer it is about to upload. A group all of whose uses sit behind a condition that
is definitely false is **dead** for that draw, and `GetSharp` returns a null image / zero S# for it - at compile
time, in the permutation key and at bind time alike. No shader instruction is removed or rewritten; a dead slot
is simply never decoded. Every doubt answers "live", which is today's behaviour.

## Design, IR half (all of src/shader_recompiler is identical in origin/main and test36 except specialization.h)

**Pass.** New `ir/passes/resource_guard_pass.cpp`, declared in `ir_passes.h`, called in recompiler.cpp between :110
(FlattenExtendedUserdata) and :112 (ResourcePatching) as `ResourceGuardPass(program, resources)`. Table and
evaluator in new `src/shader_recompiler/resource_guard.h/.cpp`. Both added to CMakeLists.txt (next to :979,
:1048-1050).

**Which edges guard a use.** `IR::ComputeDominators(program.post_order_blocks)` (valid here; idoms are null until
SsaRepairPass), then reset every `immediate_dominator` to null afterwards (dominance.cpp treats a non-null idom as
done; stale ones break SsaRepairPass at :135). A block B contributes its incoming condition when B is not the
entry, B has exactly one predecessor P, P has two successors and a `branch_cond`, and B is P's
`cfg_block->branch_true` (condition) or `branch_false` (its negation) (AddBranch keeps order and refuses
duplicates, basic_block.cpp:42-51; a V_CMPX block has a `branch_cond` and one successor). A use's guard = AND of
the conditions on its block's idom chain (memoized; a null idom stops the walk).

**Shapes it meets** (ir_emitter.cpp:168-189; scalar_alu.cpp:348-382, 608-684; vector_alu.cpp:1187-1221;
`SplitDivergenceScopes` control_flow_graph.cpp:162-281): s_cmp/s_bitcmp -> `IEqual32`/`INotEqual32`/... on SCC
(`0u != d[50]` = false edge of `IEqual32(Flatbuf 50, 0)`; bit test = `IEqual32(BitwiseAnd32(ShiftRightLogical32(x, k), 1), 1)`);
v_cmp -> `Ballot(cmp)` whose U32 halves constant propagation folds back; an exec scope (s_and_saveexec, s_andn2
exec, v_cmpx) ends its parent with Execnz, true edge = the scope, condition
`InverseBallot(BitwiseAnd64(Ballot(true), Ballot(cmp)))`. InverseBallotElimination (:118) has not run yet.

**Groups.** Keyed by `ConstructSharpFetch<T>(usage.sharps[i])` on the ResourceDiscoverPass data - the identity
`Descriptors::Add` dedups on (resource_patching_pass.cpp:114-134, 181-207); `ConstructSharpFetch` moves to
resource_pass.h with a quiet variant. T# = sharps[0]; S# = sharps[1] of `ImageSampleRaw`. Deadness is per group
(OR over all its uses), never per use. **Never guarded (always live):** inline/invalid fetches, and any T# group
with an `ImageWrite` or image-atomic use. That is exactly the storage path: `is_written` = write or atomic
(resource_patching_pass.cpp:236), the layout's descriptor type is `is_written` alone (vk_graphics_pipeline.cpp:512),
and the mip-storage fallback (`has_lod && is_written && !supports_image_load_store_lod`, :238-240; mode and array
size from the T#'s view type, :254-285) exists only there. So a guarded group is always a sampled image with one
binding, and its descriptor type and count never depend on deadness. `ImageQueryLod` drops its S# and samples
through sampler binding 0 (vector_memory.cpp:736-758, emit_spirv_image.cpp:282), so its term joins every sampler
group. `ResourceDiscovery` gains `std::array<u8, 2> guards`; the patching pass copies them into `.guard` of the
ImageResource (:241-249), FMaskResource (:310-312) and SamplerResource (:326-332) it creates.

**Evaluator** (False / True / Unknown; identical code at compile time and per draw):
- Leaves: `Flatbuf(idx)` only for `GetUserData(reg)` and a flattened `ReadConst` (flags != 0,
  flatten_extended_userdata_pass.cpp:213-215, 622) - exactly what the SPIR-V reads from the flat buffer
  (emit_spirv_context_get_set.cpp:49-65); immediates. Everything else is Unknown, notably `ReadConstBuffer` even
  when flattened (still emitted as a buffer load), `ReadConst` with flags 0 (guest memory or flatbuf[0]), phis,
  attributes, image/buffer results, lane ops.
- Logic: ConditionRef (identity), LogicalNot/And/Or (Kleene), Xor, Select (known only if the arms agree).
- Lane masks, mirroring InverseBallotElimination (inverse_ballot_elimination_pass.cpp:83-163): `InverseBallot(Ballot x)`
  = x, `InverseBallot` of 0 / ~0 = False / True, pushed through BitwiseAnd/Or/Xor/Not64 and Select; any other use of
  a 64-bit mask (popcount, compare, find-first) is Unknown.
- U32: bitwise ops, shifts (Unknown when >= 32), bitfield extract (Unknown out of range), integer compares,
  wrapping add/sub, min/max, float-to-int only when exact and in range.
- F32: BitCastF32U32, compares, add/sub/mul, neg/abs, min/max/med3/saturate/clamp - evaluated only when every
  operand is a finite normal float or zero and the result is exactly representable and not subnormal; otherwise
  Unknown. An exact result is the same under the RTE or RTZ mode the module may declare (emit_spirv.cpp:525-585),
  subnormals never occur so FTZ cannot differ, NaN never occurs so NaN rules and FMin/FMax/FClamp NaN cases
  cannot differ, and NoContraction forbids fusing. So host and GPU can only disagree by the host saying Unknown.

**Table** (`ResourceGuards`, plain data inside `InfoPersistent`, ~1.4 KB): 128 nodes of 8 bytes (op, three u8
operand indices, u32 imm; built bottom-up in program order, identical nodes shared, Unknown propagated, `Not(Not x)`
and constants folded), 16 conditions (kept only if the tree reaches a flat-buffer leaf), 32 groups of up to 4 terms
(u16 masks of conditions; an empty term = always live; over capacity, intersect with the nearest term, empty =
live). Sized from the census (up to 24 guarded resources and ~4 distinct guards per shader; a float weight guard ~9
nodes, a bit test ~6); any overflow leaves resources live. Built from the code alone, so every permutation of a
program builds the same table. Dead set per draw: `EvaluateDead(flatbuf)` -> u32 of dead groups (group dead iff it
has terms and every term contains a condition evaluated False).

**Compile-time effect.** The pass ends by setting `info.dead_resource_guards`: from the key's dead set when the
caller supplied one (every permutation compile, see below), otherwise `EvaluateDead` of this compile's flat
buffer (a program's first compile). From then on every `GetSharp` of the compile - patching's view type
(:254-285), FMask (:288-318), sample arguments (:642-825), image arguments (:840-922) and the SPIR-V emitter
(spirv_emit_context.cpp:890, 968-1018) - takes the null image / zero S# for a dead group.

## Design, runtime half (file:line = origin/main; test36 differs only where given)

- **Info / resources** (`resource.h`, `info.h`): `InfoPersistent` gains `ResourceGuards resource_guards` (rides
  the existing raw copy, vk_pipeline_serialization.cpp:391); `ImageResource`, `SamplerResource`, `FMaskResource`
  gain `u8 guard` (0xFF = none) as their LAST member, outside every dedup key (designated initializers at
  resource_patching_pass.cpp:213/241/326 keep compiling). `Info` gains `u32 dead_resource_guards`, an optional
  key-supplied dead set for the compile, and `RefreshResourceGuards()`, called at the end of `RefreshFlatBuf`
  (info.h:167-174) and after `Info::Deserialize` reads the flat buffer (a cache load never refreshes). Test36 line
  only: also after 5ece2f75's preload flat-buffer swap (vk_pipeline_cache.cpp T:294).
- **GetSharp** (resource.h:134-153, :183-204, :211-213): dead group -> `Image::Null(is_depth)` / `Sampler{}`
  (before the sampler's T#-dword-3 read at :187) / null FMask. Every reader already goes through these:
  specialization.h:131-153, the patching pass, the SPIR-V emitter, both pipeline layouts
  (vk_graphics_pipeline.cpp:510, vk_compute_pipeline.cpp:50), BindTextures; the texture cache only receives sharps
  BindTextures fetched.
- **Permutation key** (`specialization.h`): carries `dead_resource_guards`, compared always and serialized with
  the spec. A module is reused only by draws with the same dead set, so one compiled with a group dead never
  serves a draw where it is live and vice versa. (The dead image already drops its bitset bit through GetSharp.)
- **GetProgram** (vk_pipeline_cache.cpp:653-703): after `RefreshFlatBuf` the key is built from `program->info`;
  the permutation branch constructs `new_info` right before `CompileModule` and hands it that same dead set, so
  the module matches its key even when the two SRT walkers' flat buffers differ (walker fault patches are per
  copy, flatten pass :71-121). With shader patching on (`IsPatchShaders`, :632-636) or a module replaced through
  `ReplaceShader`, the table stays empty (today's behaviour): patched SPIR-V may read what the original guards.
- **BindTextures** (vk_rasterizer.cpp:812-978): no change. A dead image is sampled-only by construction, so the
  existing null path (VK_NULL_HANDLE, Texture type, one entry = NumBindings of a null T#) is right and never
  reaches FindImage/FindTexture/Transit; a zero S# goes through `GetSampler` to the same cached sampler #5137's
  fallback binds (texture_cache.cpp:965-981). Compute uses the same BindResources.
- **Cache** (vk_pipeline_serialization.cpp:15-17): bump ShaderMetaVersion and ShaderBinaryVersion, and
  PipelineKeyVersion too if the spec is part of the key record. TEST37 is cold either way (TEST36 already reports
  "Preloaded 0 / 427 stale"; the launcher restores the same snapshot every run).

## Files

New: `src/shader_recompiler/resource_guard.h`, `resource_guard.cpp`, `ir/passes/resource_guard_pass.cpp`.
Changed: `recompiler.cpp`, `ir/passes/ir_passes.h`, `ir/passes/resource_pass.h`, `ir/passes/resource_patching_pass.cpp`,
`resource.h`, `info.h`, `specialization.h`, `src/video_core/renderer_vulkan/vk_pipeline_cache.cpp`,
`vk_pipeline_serialization.cpp`, `CMakeLists.txt`. One commit, no comments, no GT_*, no game named, no trailer.

## Left out on purpose (separate issues found on the way, one fix per PR)

- Resource lists of later permutations can differ from `program->info`'s (FMask early return
  resource_patching_pass.cpp:288-320, the mip-fallback key) while binding uses `program->info`'s: a guarded T#
  that is a real FMask in some draws still has this hazard (today it has it randomly). Structural fix = bind each
  permutation with its own Info.
- `AddBindings` (info.h:162-165) counts a DynamicIndex image as 1; a null STORAGE image is written as
  eSampledImage by the null path (texture_cache.h:67); `DisableAnisoIfSingleLod` can read flatbuf[0xFFFF]
  (resource.h:187 + resource_patching_pass.cpp:329-330); NumBindings on a live garbage T# with base_level >
  last_level wraps; image sizes are u32 (`MipInfo`/`guest_size`, `mip_info.size *= num_slices`); V#s behind dead
  branches (buffers, out of scope).

## Steps after approval

1. Records: HANDOFF.md update block, lane memory paragraph, its MEMORY.md line (check mtimes first). Check PR
   #5196 read-only before every step; a live review comes first.
2. Notice to the auditor, then branch `test37-main-2338a06f` from 04558db8: `git revert 9dce3330`,
   `git revert d833bab4`, the fix as one commit (three commits over TEST36, by the user's decision). Grep the edits
   on disk.
3. Tell the user and build only on their go: `ninja` only, 8.3 path. Exe `backup_exe\shadps4_test37_<hash>_gt7.exe`
   + pdb, launcher `TEST37_GT7_<hash>_warm_diag_console.bat` (TEST36's with EXE, prelaunch copy, CONSOLE,
   GT_IMGDUMP_DIR, title, echo renamed); build details to the auditor. The user runs; the auditor audits.
4. PR only when the three criteria hold and the user asks: branch from origin/main, cherry-pick the fix commit
   alone, push to `mine`; the user writes the text.

## Verification: lines the log already has (TEST30-36 = 35 GT7 at-exit logs)

| measure (per run) | TEST30-36 | TEST36 r1 | TEST37 expected |
|---|---|---|---|
| `Compiling fs shader 0x2a265dff` | 15-58 in every run that reaches the race | 39 | 1 (its 39 keys collapse) |
| `Rejecting invalid S#` (upstream check, unchanged) | 5-1277 | 458 | roughly half (~250, a correlation estimate) |
| `Rejecting invalid T#` (narrower after reverting d833bab4) | 4-384 | 123 | roughly half (~60) |
| asserts the dropped fixes held off (SurfaceFormat "Unknown data_format", ComponentSwizzle "Unreachable", `pixel_format.h:359`) | 1 run each (test18, test25) | 0 | 0 |
| `Creating tiling pipeline Thick3DThickPrt_32 detiler` (class-2 precursor) | 11 of 35 runs | 0 | 0 |
| `GetArrayMode: Unreachable` (class 7) | test15, test30, test32 | 0 | 0 |
| `Compiling ... (permutation)` total | - | 270 | at most ~232 |
| endings class 2 / 4 / 7 | the most frequent endings | class 1 | none |
| GT_IMGDUMP (32 files) and GT_BINDLOG picture of fs 0x74f5f10c | identical to TEST34 r1 | identical | identical |
| distinct Warning / Error / Critical signatures (msgsig) | 423 (TEST35 r1-r7) | 407 | no new one |

The first three rows move in every run; the assert and ending rows are rare and need several runs. Rejections
that remain come from live slots holding garbage or placeholders, from guards the evaluator leaves Unknown, or
from storage images, which stay live by design. If the class-2 precursor survives, its T# is in a live slot and
the next step is a `GT_*` line naming the shader and slot, not a new symptom check.
