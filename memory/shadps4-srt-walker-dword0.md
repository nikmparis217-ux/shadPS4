---
name: shadps4-srt-walker-dword0
description: "GT7 renderer errors, 3 Oct 2026: 98.4% = 'Clamped size' (see shadps4-unbounded-vsharp-clamp); the second group, 'Failed to compute offset for SRT walker' (Phi / GetAttributeU32), makes the shader read flat-buffer dword 0 (user-data SGPR0) in place of the wanted constant whenever directMemoryAccess is off (default, and GT7's profile): 818 of 2210 compiles (792 shaders) in TEST40 r2; fs 0x74f5f10c reads dword 0 twelve times into a multiply-add chain. Likely visual-bug cause; not in upstream"
metadata:
  node_type: memory
  type: project
  originSessionId: b5cd4610-ed8e-4e80-b4f1-9139bfdb73d5
  modified: 2026-10-03T08:15:35.852Z
---

User, 3 Oct 2026: "when playing gt7 i get renderer errors. what is the problem for that?" Read-only research by
builder shadps4-lane-f9 (no build).

**Counts, GT7 TEST40 r2** (`GT7_upstream\logs\shad_log_test40_gt7_2_at_exit_143236.txt`, 553 s; script
`builder_scripts\render_msgs_v1.sh`): renderer errors 1,631,813 lines = 1,605,678 "BindBuffers: Clamped size"
(98.4%, plus most of the 2,065,888 collapsed duplicates; [[shadps4-unbounded-vsharp-clamp]]) + 13,070 "Failed to
compute offset for SRT walker" + 12,991 "Unexpected instruction for offset computation, Phi" + 74 "..., GetAttributeU32".
Warnings: 129 "Unexpected metadata read by a shader (texture)", 11 "Fallback for ImageWrite with LOD" (NVIDIA lacks
VK_AMD_shader_image_load_store_lod), 15 wave64 Ballot/ReadLane in non-uniform control flow, 3 "Coercing copy source
layers 8 and destination layers 48" (= CRASH_MAP #1's precursor), 3 "Unimplemented clamp mode 4", start-up lines about
missing AMD extensions and formats (information, not errors).

**What the SRT-walker failure does (main 8e23388a):**
- `FlattenExtendedUserdataPass` (recompiler.cpp:110) builds a CPU "walker" that copies the constants a shader reads
  through user-data pointers into the flat buffer before each draw. `VisitPointer`
  (flatten_extended_userdata_pass.cpp:588-634): when a read's offset depends on a Phi or a vertex attribute, which
  only the shader knows at run time, `ComputeOffset` fails (:563), the read is skipped (:612-614 `continue`; :596-598
  skips a whole pointer) and keeps flat-buffer offset 0.
- `EmitReadConst` (emit_spirv_context_get_set.cpp:55-65): with `directMemoryAccess` off it emits
  `EmitFlatbufferLoad(ConstU32(flatbuf_off_dw))` even when the offset is 0, so the shader reads flat-buffer dword 0 =
  user-data SGPR0 (`Info::RefreshFlatBuf`, info.h:167-174), silently. With DMA on, the read goes to guest memory through
  the BDA page table (`read_const_dynamic`), and `CollectShaderInfoPass` logs "Enabling DMA for shader" (ERROR).
- GT7's profile: `GPU directMemoryAccess: false`. In TEST40 r2, 818 of 2,210 shader compiles (792 different
  shaders, ~16 failures each) logged the failure.
- Proof in a compiled shader (cache snapshot `C:\shadps4-test19-gt7\cache_before_launch_20261002_142311\CUSA24767`,
  `builder_scripts\spv_flatbuf0_v1.py`): fs 0x74f5f10c reads `srt_flatbuf[0]` 12 times, each bitcast to float ->
  OpFMul -> OpFAdd; every other flat-buffer read is a distinct index >= 16 read once. So 12 table values (a 3x4-matrix
  shape) are all replaced by SGPR0. Confirmation still open: an IR dump (`pre-res-patch`) showing those ReadConsts with
  offset 0.
- Upstream: no issue or PR (searched "SRT walker", "Failed to compute offset", directMemoryAccess); the code is #4782
  (LNDF, merged 31 Jul 2026); our closed #4996 did not touch it. My First Gran Turismo's outside log had 5,794 such
  failures but DMA on.

**Fix directions (none started):**
1. Never read dword 0 silently: for a shader with an unflattened dynamic read, use the DMA read for that shader even
   when the global setting is off, or at least make it visible.
2. Push the load through the Phi when every incoming offset is computable (ReadConst(Phi(a,b)) -> Phi(ReadConst(a),
   ReadConst(b))), so the walker can flatten both; loop induction Phis and attribute offsets stay DMA-only.
3. The pass's own TODO (:607): keep a dynamically indexed subtree sparse in the flat buffer, which needs a bound.
Cheapest first test (no build, the user's call): one GT7 run with `directMemoryAccess: true` as the only change,
compared with a run without it (DMA's own caveat: a non-resident page is fixed after the submit, so a first read can
be stale). **Test validity:** the pipeline cache's compatibility check compares only `Shader::Profile` (GPU features,
vk_pipeline_serialization.cpp:311-338), while the DMA setting is read at compile time, so a cached run reuses SPIR-V
built for the other setting (a small bug of its own). Run it with the TEST40 `GT_GUARDCHECK=1` launcher (no cache
read or write; = TEST40 r2's launcher, so a one-variable comparison with r2) or with the cache off. The switch: line 20
of `C:\shadps4-test19-gt7\user\config.json`, `"direct_memory_access_enabled": false` -> true, set back after. Classifying the Phis (if/else merge vs loop) needs a run with shader dumps on.

**Why:** the user wants every crash fixed at its root first, then visuals; this is an emulator-general visual
candidate with a measured footprint.
**How to apply:** treat as a visual-phase candidate ([[shadps4-fix-candidates]], [[gt7-image-problems-map]]); start
with the DMA-on run or the IR dump, one variable at a time.
