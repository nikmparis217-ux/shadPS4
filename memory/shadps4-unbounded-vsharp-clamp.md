---
name: shadps4-unbounded-vsharp-clamp
description: "PARKED until the weekly limit resets (Sun 4 Oct 2026 12:00): the BindBuffers 'Clamped size from 4294967295' ERROR (GT7 ~550 lines/frame) = V#s the shader builds from a raw pointer with num_records 0xFFFFFFFF; GT7's read range is decided on the GPU, so no bound exists; real defects = u32 GetSize overflow + ERROR on a legal V#; plan = measure the cost (TEST41 log-only counter), then core fix A (size model) or B (address-based reads)"
metadata:
  node_type: memory
  type: project
  originSessionId: 69aee205-f92c-44e7-8367-5be64450ea3e
  modified: 2026-10-02T19:01:34.170Z
---

User, 2 Oct 2026: "i want a fix in its core not just επιφανειακο fix", then (~21:40) "keep these findings in
your memory for after the limit weekly reset". Found by builder shadps4-lane-f9, read-only. Evidence:
`GT7_upstream\logs\vsharp_unbounded_scan_20261002.txt`, `vsharp_access_20261002.txt`; scripts
`builder_scripts\vsharp_scan_v1.py` (V# recipes in cache .meta), `vsharp_access_v1.py` + `spv_trace_v1.py`
(index expressions in the cached SPIR-V).

- Path on main: `vk_rasterizer.cpp` BindBuffers -> `memory->ClampRangeSize` (memory.cpp:102; only sizes >= 1 GB:
  `ASSERT_MSG(IsValidMapping)` "Attempted to access invalid address", then cut to the end of the VMA + contiguous
  mapped VMAs) -> `LOG_ERROR "Clamped size from {} to {} for stage {:#x}"` -> `ObtainBuffer` (> 16 KB: arena,
  EnsureResident + SynchronizeMemory of the WHOLE range). The clamp is #2447 (da0ab005, Feb 2025, on purpose: "not
  reasonable to expect the game needing all of the memory"); the ERROR line is #4782 (1cf28cbc, 5 Sep 2026).
- Source: the shader builds the V# itself: dwords 0-1 = a 64-bit pointer from user data, dword 2 = the constant
  0xFFFFFFFF ("no limit"; on the GPU num_records is only the bounds check), dword 3 = 0x2000C004. GT7 fs 0x74f5f10c,
  0x840464a6, 0x5598df2e, 0x1416ac3d: stride 0, read-only -> GetSize 4294967295. GoW cs 0x7463e726 / 0x42ba6f62:
  user-data dwords 2-3 + post-op OR 0x00100000 (stride 16) -> 16 x 0xFFFFFFFF wrapped in u32 = 4294967280 (IR dump
  `C:\shadps4-gow\user\shader\dumps\cs_0x000000007463e726.pre-res-discover.irprogram.txt`).
- Counts: GT7 TEST40 r2 (553 s) 1,605,678 lines + 2,065,140 suppressed, 786 stages, every one "from 4294967295";
  TEST37 r1 (fix off) the same value. GoW TEST2 ~300 lines in 6 stages. The V# assert: 0 of 343 archived logs.
- How GT7 reads them: fs 0x74f5f10c dword index X*16 + c + Y (64-byte records), 0x840464a6 X*32 + c + Y (128-byte);
  X is read from another buffer at an index made from an image fetch = decided on the GPU per pixel; Y = push_data
  `buf_offsets` = BindBuffers' own alignment adjust. GoW cs 0x7463e726: (x & 3) * 4 + (y & 3), stride 16, offset 656 =
  at most ~904 bytes. So for GT7 neither the recompiler nor the host can bound the range before the draw: binding to
  the end of the mapping is the correct conservative choice of the bind-a-range model.
- Real defects: (1) `AmdGpu::Buffer::GetSize()` = stride * num_records in u32 (stride 16 x 0x10000000 -> 0 ->
  BindBuffers binds a null buffer, the shader reads zeros); (2) a legal "no limit" V# is an ERROR at every bind, on
  the GPU command thread; (3) the cost of whole-range binds (sync, residency, barrier checks, log): NOT measured.
- Main's address path: `directMemoryAccess` (default false) = BDA page table + fault buffer, used only for dynamic
  ReadConst; pages that are not resident are fixed after the submit, so a first read can be stale.

**Plan (resume after the reset, after any PR review work):**
1. TEST41 = TEST40 07a74022 + one log-only [test] commit: per frame, for clamped binds: count, bytes bound, bytes
   uploaded, barrier hits, microseconds in bind + log; GT_GUARDCHECK off so frame times compare. Notice to the auditor
   before the checkout switch; the user's go before the build.
2. Small cost -> A: 64-bit extent + "unbounded" handled as an expected case (bind to the end of the mapping on purpose,
   no error). Large cost -> B: address-based reads for unbounded V#s on the existing BDA page table, plus A for the
   overflow.

**Why:** the user rejects symptom fixes, and every fix in this lane is proven by a measurement.
**How to apply:** nothing on this before Sun 4 Oct 2026 12:00 (budget hold: only dev-requested changes on #5218 /
#5155 until then); afterwards start at step 1.

Related: [[gt7-shadps4-lane]], [[feedback-shadps4-pr-quality-method]].
