---
name: gow-fixes-for-pr
description: "God of War (CUSA07411) shadPS4 fixes kept as three separate one-commit LOCAL branches for future PRs (tg-size-sgpr, ds-ordered-count, tsharp-dw1-mask); what each does, the evidence, and what each still needs before a PR"
metadata:
  node_type: memory
  type: project
  originSessionId: 0bdb4255-1ac0-4abb-9dd3-ea05165bd11b
  modified: 2026-10-02T18:01:55.946Z
---

User, 27 Sep 2026: "we finish this last gow fix since you implemented it but we continue to gt7. keep the fixes for
gow separated one by one and clean on your memory for future pr". So GoW is PAUSED after the GOW3 run and work
returns to GT7. The three fixes below are kept apart, one commit each, on local branches in the shared repo
(`C:\shadps4-clean`, one ref store for all worktrees). **None is pushed.** Base = upstream `origin/main` 8151ee25.
Commit style = PR style: title only, no comments in the code, no `GT_*`, no trailer.

**1. `tg-size-sgpr` b89a2772 "shader_recompiler: Provide the thread group size SGPR to compute shaders"**
- COMPUTE_PGM_RSRC2 bit 10 (TG_SIZE_EN) → `ComputeProgram::IsTgSizeEnabled` → `HwComputeRuntimeInfo::tg_size_enable`
  (in operator==) → the compute prologue writes the SGPR after the TGID SGPRs:
  `{first_wave << 31 | ordered_append_term[10:0] << 6 | waves_in_group[5:0]}`. That is the Work-Group Info SGPR layout
  in LLVM AMDGPUUsage. Waves are 64-lane GCN waves (`LocalInvocationIndex >> 6`, `DivCeil(threads, 64)`), not host subgroups.
- Cache: ShaderBinaryVersion AND ShaderMetaVersion 5 → 6 (runtime_info is serialized raw in the spec, and the SPIR-V
  of every TG_SIZE_EN shader changes).
- Why: upstream left the SGPR undefined. GoW cs 0x38c7b95b builds M0 = `bfe(TG_SIZE, 6, 11) | (addr << 16)`, and an
  undefined source can poison the whole M0 (old fork run 010 saw exactly this).
- Before a PR: a game that uses it without DS_ORDERED_COUNT would make the PR stand alone. Otherwise it is the
  prerequisite of #2 and can go in the same PR as a first commit, if the maintainers prefer.

**2. `ds-ordered-count` a1af1159 "shader_recompiler: Implement DS_ORDERED_COUNT" (STACKED on #1)**
- DS_ORDERED_COUNT → `GdsOrderedCount` → resource patching → `BufferOrderedCount` on the GDS buffer:
  - the counter is at M0[31:16] + index*4 (offset0 bits 2-3);
  - ONE atomic per wave (lowest active lane), add or swap (offset1 bit 4), the result is broadcast to the wave;
  - order = a ticket dword at `GdsOrderedTicketOffset` 0x10000 (GDS buffer 64 KB + 4), zeroed before every dispatch
    by `Rasterizer::ResetOrderedCount`, plus `IsBufferAccessed` for the barrier;
  - the turn is released at the op when offset1 bits 0-1 say release/done;
  - S_ENDPGM (`GdsOrderedSignal`) waits for ticket >= wave, then CAS(wave → wave+1). That releases a wave that never
    released and does nothing for an idle subgroup of a wave that already did.
  - Compute stage only (elsewhere it stays "missing opcode"). `uses_ordered_count` is a pre-scan in recompiler.cpp.
  - ShaderMetaVersion 6 → 7 (`InfoPersistent::uses_ordered_count`).
- Sources: Sea Islands/GCN3 ISA ("in order of wavefront creation"); Vega 7nm ISA (packers, count_bits);
  LLVM `AMDGPUDSOrderedIntrinsic` + SIISelLowering (offset1 = release | done<<1 | shader type<<2 | swap<<4).
  Upstream gap #496; #2899 was closed by its author after squidbus asked for exactly these semantics.
- Evidence: GOW1 (06:02) — cs 0x38c7b95b compiles, 0 "Unknown opcode". GOW2 (12:41) — TDR 153 after 44 s. The suspect
  then: the upper 32-lane subgroup held its own ticket until S_ENDPGM, so the dispatch ran one workgroup at a time.
  That is what the 64-lane-wave change fixes. **GOW3 (586d0579, 27 Sep 13:24): the change works as designed and did
  NOT move the TDR.** IR: TG_SIZE = WorkgroupIndex + (LocalInvocationIndex >> 6), waves = 1; both BufferOrderedCount ops
  and the S_ENDPGM BufferOrderedSignal take that wave index; the ops sit inside `If (LocalInvocationId.x == 0)`. Still a
  bare nvlddmkm 153 (Properties bit-identical to GOW2's) → "Device lost during submit" (vk_scheduler.cpp:242), at the
  SAME point as GOW2: the "Sony Interactive Entertainment presents" splash, 27.2 s after cs 0x38c7b95b first compiled
  (GOW2 26.3 s), same last-compiled shader (fs 0x9ec17c26, compiled just AFTER the 153, so a marker, not the culprit),
  same 3793 dumps / 1307 cache files. So removing the upper subgroup's ticket did not change when or where the GPU hangs;
  the TDR cause is still unknown and nothing ties it to DS_ORDERED_COUNT. Log `logs\shad_log_gow3_1_at_exit_132526.txt`,
  artifacts `logs\gow3_1_artifacts` (the log names no last submit/dispatch; device fault output is not printed).
  spirv-val (vulkan1.3) on the GOW3 `cs_0x0000000038c7b95b_0.spv`: VALID, checked by both sessions.
  If GoW is resumed, the next one-variable run: a `GT_*` gate that skips the ordered WAIT but keeps the atomic. TDR gone →
  the wait deadlocks (Vulkan guarantees no forward progress between workgroups); TDR still there → the hang is elsewhere.
  First candidate then: `Clamped size from 0xFFFFFFF0`, which starts before the ordered-count shader in both runs (counting
  the "Skipped N duplicate messages" lines: GOW2 ≥3734 events in ~46 s, GOW3 ≥2624 in ~40 s).
- Before a PR: a per-GCN-wave LDS claim/mailbox. Without it three cases hang, none of them hit by GoW:
  (a) two active subgroups of one GCN wave at the op;
  (b) an idle subgroup reaching S_ENDPGM before its own wave's op, with no barrier in between (its CAS steals the turn);
  (c) a second ordered op after a release (WaitForTurn(== w) never matches again).
  GoW is safe only because thread 0 alone runs the op and $174 starts with a workgroup barrier.

**3. `tsharp-dw1-mask` dc08b752 "shader_recompiler: Handle a T# dword1 masked with an immediate"**
- GoW fs 0xcc4267a6: the T# dword1 = `BitwiseAnd32(ReadConst, 0xC3FFFFFF)` clears NUM_FORMAT (dw1 bits 26-29) →
  UNORM (an sRGB texture read as linear). Since #4782 (5 Sep) that hits
  `resource_discover_pass.cpp:257 ASSERT(IsSharpSource(source))`.
- Fix: post-op `BitwiseAndDw1WithImm` + `ImageResource::post_op_dw1_mask` (also in the dedup key), applied in
  `ImageResource::GetSharp`; `CheckImageDw1MaskPattern` accepts the immediate on either side. The IR value stays
  (it has other uses: SGPR9 and SCC). ShaderMetaVersion 5 → 6.
- Evidence: GOW2 — fs 0xcc4267a6 compiles, 0 discover asserts. The peer scanned all 83 GOW1 dumps: this is the only mask shape.
- ⚠ **Before a PR:** the user's OWN #4999 (10 Sep, branch `pr-descriptor-dword-mask`, closed 24 Sep without merge)
  covered this same GoW mask. baggins183: "the approach would work although it doesn't really match other cases that use
  SharpFetchPostOp. But I would rather handle this in srt program itself". So either redesign it in the SRT walker
  program, or ask him first. Do not resubmit the post-op as it is.

**Test branch, NOT for PR:** `gow-orderedcount` 7ad6b6d0 = the three fixes (as WIP commits) + b8c30ff2 (the #5137
catch-all) + a merge of origin/main 8151ee25. Exes `backup_exe\shadps4_gow{1,2,3}_*_gow.exe`, profile
`C:\shadps4-archive\shadps4-gow1\user` (moved from `C:\shadps4-gow1` on 1 Oct), launchers `GT7_upstream\GOW{1,2,3}_*.bat`
(they still name the old path; working copies in `C:\shadps4-gow\old_tests`), run artifacts `logs\gow{1,2}_1_artifacts`.
**1 Oct: GoW has its own folder `C:\shadps4-gow` (README.md). Its first TEST1 7d09a8a8 lacked these three branches
and was deleted before any run (user, 16:08: "that was my mistake"). GoW TEST1 is now `gow-test1-main-d9cf41ba`
1c6cff84 = 7d09a8a8 + cherry-picks f6258522 (b89a2772), 0a8c27c2 (a1af1159), 1c6cff84 (dc08b752): same +/- lines as
the sources; conflicts only in the cache versions (B8/M10) and the ImageResource order (post_op_dw1_mask, then
guard). Built 16:13, exe B142D73C, not run yet. GoT and GTA V TEST1 stay 7d09a8a8 (no GoW fixes).**

**2 Oct 2026 ~21:05, PR-readiness check (builder shadps4-lane-f9), read-only; output
`C:\shadps4-gow\logs\gow_fixes_pr_check_20261002.txt`, scripts `C:\shadps4-gow\tools\gow_cf_check_v2.sh`,
`gow_merge_check_v1.sh`, `gow_upstream_search_v1.py`:**
- Formatting is clean: clang-format 19.1.5 the way upstream CI runs it (every changed `src/*.cpp|h`, the WHOLE file, style
  from `src/.clang-format`), `--dry-run --Werror` rc 0 and no diff in all 6 + 19 + 4 files, no trailing whitespace, LF.
  Controls: main's copies of the same files clean, a copy with a badly formatted line added flagged. The 1 Oct "every
  file flagged" was a method error (style pointed at a root `.clang-format` that does not exist).
- On origin/main bf794b3f (B6/M6), `merge-tree --merge-base=8151ee25`: ⚠ tg-size-sgpr merges WITHOUT a conflict only
  because its 5 -> 6 equals main's current values, so a plain rebase silently carries no cache bump; tg + ds conflict
  only in ShaderMetaVersion, tsharp only in the version lines. Set main + 1 by hand on every rebase.
- Main still lacks all three (no DS_ORDERED_COUNT translator, no `tg_size` in src, the :257 assert). Upstream has
  nothing new for any of them; none of the three branches was ever opened as a PR. Main's named post-ops
  (BitwiseOrDw1WithImm, ClearAnisoRatioAndThreshold = a fixed-immediate AND on an S# dword) came with #4782 (5 Sep),
  i.e. they are the "other cases" baggins183 meant on #4999; #5059 (merged 19 Sep) extended the discover pass with a
  V_READFIRSTLANE_B32 sharp-source pattern.
- Verdict: none is ready, for the content reasons above (tg: no standalone failure; ds: GoW still hangs the GPU after
  it in every run, wave-model cases (a)-(c) open; tsharp: the maintainer's SRT-program request). PR criterion 2 (no
  other game worse) is shown for none: only the GoW test line (TEST1 1c6cff84, TEST2 6b19950f) carries them.

**Turning one into a PR (only when the user asks):**
- rebase onto the current origin/main, keeping ONE commit, and re-check the cache version lines. Cache constants:
  upstream B5/M5 → `tg-size-sgpr` B6/M6 → `ds-ordered-count` B6/M7; `tsharp-dw1-mask` B5/M6. Both tg and tsharp set
  Meta 6, so whichever lands second upstream must bump again (peer audit, 27 Sep). ⚠ Upstream main is already at
  B6/M6 by d9cf41ba (1 Oct), so on a rebase each of them needs main's value + 1;
- clang-format 19 = VS BuildTools `VC\Tools\Llvm\x64\bin\clang-format.exe`; upstream CI lints only `src/**.cpp|.h`;
- test on GT7 + GoW + GoT;
- look up upstream PRs/issues AND the user's own closed PRs (`pulls?head=nikmparis217-ux:<branch>`);
- push only to `mine`; the user writes the PR text.
See [[gt7-shadps4-lane]], [[feedback-check-existing-branches-first]], [[feedback-shadps4-comments-cleanup-later]].
