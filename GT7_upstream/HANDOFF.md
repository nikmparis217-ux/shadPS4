# shadPS4 lane - builder handoff (30 Sep 2026, ~20:50)

> **Update 3 Oct ~01:40, builder shadps4-lane-f9: the path of one shader from the game to the screen (user: "save
> everything we learned ... so we always know the correct order"). Read-only (git grep on origin/main bf794b3f + grep
> of the newest logs); nothing built. Saved as memory `shadps4-gpu-path-map.md`: 22 steps with file:line; re-pin the
> lines with `builder_scripts\gpu_path_lines_v1.sh` (v2-v4 fill gaps).**
> - "144" = `signals.cpp:144`, the last-resort exception handler ("Unhandled Exception code"): GT7 game-thread crashes
>   #5/#6/#11 (the game's own code); GoT TEST1 + TEST2 = nvoglv64.dll while "Compiling compute pipeline
>   0x98170c4bfeeeaffe" (cs 0x14906b6a) = step 15, the driver's SPIR-V compile; no GoW log ends there. GoW TEST2 r1/r2
>   (and TEST1 r2) report the device loss from buffer_cache.cpp:443 SubmitPendingArenaBinds, TEST1 r1 from
>   vk_scheduler.cpp:245, TEST1 r3 from vk_presenter.cpp:1119.
> - Steps 1-5: GT7 CRASH_MAP #3 (PM4 type 0, 15 runs, 2 of the last 4) is the packet reader. Lead, untested: main never
>   reads INDIRECT_BUFFER's `chain` bit (pm4_cmds.h:896; liverpool.cpp:794-805 GFX, :928-938 ASC). Proposed first after
>   the reset (user's go): a [test] log at the type-0 stop (buffer, offset of the zero dword, last ~16 packets with raw
>   headers). GoW's only step 1-5 message: "Encountered compute SetQueueReg: vqid = 4, reg_offset = 0xb" (579 in
>   TEST2 r1 + r2), skipped by main.

> **Update 2 Oct ~21:45, builder shadps4-lane-f9: BUDGET HOLD (user): 10 % of the weekly limit is left; it resets
> Sun 4 Oct 2026 12:00. Until then only changes the devs ask for on our open PRs (#5218, #5155): no new research,
> builds or tests. The "Clamped size" findings and their plan are in memory `shadps4-unbounded-vsharp-clamp.md`
> (resume after the reset, after any PR review work).**

> **Update 2 Oct ~21:35, builder shadps4-lane-f9: user: "i want a fix in its core", not a surface fix of the
> "Clamped size" error. Root-cause research, read-only; nothing built.**
> - History: the clamp is #2447 (da0ab005, Feb 2025): huge V#s that start in a valid mapping, "not reasonable to
>   expect the game needing all of the memory", clamped to avoid the GPU-tracking assert. The ERROR line came with
>   #4782 (1cf28cbc, 5 Sep 2026, new sharp tracking).
> - How GT7 reads them (cached SPIR-V, `logs\vsharp_access_20261002.txt`, `builder_scripts\vsharp_access_v1.py` +
>   `spv_trace_v1.py`): fs 0x74f5f10c dword index = X*16 + c + Y (64-byte records), 0x840464a6 X*32 + c + Y (128-byte);
>   X is read from another buffer (ssbo_2 / ssbo_3) at an index made from an image fetch, i.e. decided on the GPU per
>   pixel from texture data; Y = push_data buf_offsets = BindBuffers' own alignment adjust. GoW cs 0x7463e726 is
>   different: index (x & 3) * 4 + (y & 3), stride 16, offset 656, at most ~904 bytes. So neither the recompiler nor
>   the host can bound GT7's range before the draw: binding the rest of the mapping is the conservative, correct choice
>   in shadPS4's bind-a-range model (the PS4 itself reads by address; reading unmapped memory faults there too).
> - Main's address-based path: `directMemoryAccess` (default false) gives a shader a BDA page table + fault buffer,
>   used only for dynamic ReadConst; missing pages are repaired after the submit (fault buffer), so a first read can
>   be stale.
> - Real defects found: the ERROR for a legal descriptor (per bind, GpuCommandProcessor thread); `GetSize()`
>   multiplies stride * num_records in u32 (GoW's 4294967280 is already a wrap of 0xF_FFFF_FFF0; stride 16 x
>   0x10000000 would wrap to 0 and bind a null buffer). Not measured: what the whole-range binds cost (sync, residency,
>   barrier checks, log) per frame.
> - Proposed (waiting): a log-only [test] cost counter for these binds first, then choose: the size model (64-bit
>   extent, "unbounded" as an expected case) if the cost is small, or address-based reads for unbounded V#s (on the
>   existing BDA page table) if it is large.

> **Update 2 Oct ~21:25, builder shadps4-lane-f9: what the "Clamped size" error is (user's question), read-only.**
> - Source: the shaders build the V# themselves from a 64-bit pointer in their user data, with num_records = the
>   constant 0xFFFFFFFF ("no limit"; on the GPU num_records is only the bounds check) and dword3 0x2000C004. GoW cs
>   0x7463e726 IR: `CompositeConstructU32x4 %7 (SGPR2), %146 (= SGPR3 | 0x100000, stride 16), #4294967295,
>   #536920068` -> `LoadBufferU32x2`. Cache metas (`builder_scripts\vsharp_scan_v1.py`, output
>   `logs\vsharp_unbounded_scan_20261002.txt`): GoW cs 0x7463e726 / 0x42ba6f62 = flat-buffer dwords 2-3 + post-op OR
>   0x00100000; GT7 fs 0x74f5f10c, 0x840464a6, 0x5598df2e, 0x1416ac3d = flat-buffer dwords 0-1, stride 0, no post-op;
>   all read-only (is_written 0). GetSize: GT7 = num_records = 4294967295; GoW = 16 x 0xFFFFFFFF in u32 = 4294967280.
> - What main does: BindBuffers -> `ClampRangeSize` (size >= 1 GB: assert the address is mapped, cut to the end of the
>   guest mapping holding it + contiguous mapped neighbours) -> LOG_ERROR whenever the size changed, at every bind of
>   every draw (GpuCommandProcessor thread) -> `ObtainBuffer` with the clamped size (tens of MB, > the 16 KB stream
>   threshold), so the arena blocks of the whole range are made resident and the whole range synchronized each bind.
>   The clamp itself is right (a host buffer needs a finite range); the ERROR is noise for a legal descriptor.
> - Not measured: what the log line or the whole-range synchronization costs per frame.

> **Update 2 Oct ~21:15, builder shadps4-lane-f9: the user asked whether #5218's mechanism should also cover V#
> (buffers). Answer from code and logs, read-only: it could, but no measurement says it is needed.**
> - #5218's pass collects only image instructions (resource_guard_pass.cpp:614; storage-image writes stay live), so
>   every V# is still read and bound on every draw.
> - Main, per V# (vk_rasterizer.cpp BindBuffers): address 0 or size 0 -> null descriptor already; else
>   `ClampRangeSize` (memory.cpp:102: sizes >= 1 GB only, `ASSERT_MSG(IsValidMapping)` "Attempted to access invalid
>   address" first) with `LOG_ERROR "Clamped size from {} to {} for stage {:#x}"`, then `ObtainBuffer`, and
>   `InvalidateMemoryFromGPU` when the shader writes it. stride / is_formatted / swizzle (+ formats) are in the
>   permutation key (BufferSpecialization), so a dead V# with garbage could cost compiles, as the dead T#s did.
> - Logs: the invalid-address assert is in 0 of 343 archived logs (GT7 312, GoW 9, GoT 9, GTA V 13). GT7 TEST40 r2
>   (553 s, fix on): 1,605,678 "Clamped size" lines + 2,065,140 suppressed repeats over 786 stages, every one "from
>   4294967295" (num_records 0xFFFFFFFF), the same in TEST37 r1 (fix off, 25,934); GoW TEST2 r1/r2 only 4294967280 /
>   4294967216 (stride 16 x a near-max record count, u32 product overflow) in 6 stages. One fixed value across
>   hundreds of shaders = a deliberate unbounded buffer, not garbage (the dead T#/S#s gave a different value at every
>   stop). Permutations in TEST40 r2: 414 against 1796 first compiles, the most for one shader 9 (vs 0x3863962b);
>   nothing like fs 0x2a265dff's 24-39 per run before the fix. "not fully GPU mapped": 0 in TEST40 r2 (1 in TEST37 r1).
> - So: not for #5218 (one fix per PR; the reviewer asked to keep the guard code apart). The way to know: a log-only
>   [test] line running the same analysis over buffer uses and counting bound V#s behind false conditions; only a find
>   there would make a V# follow-up PR. Side fact: the clamp line (num_records 0xFFFFFFFF, a live descriptor) is GT7's
>   biggest log volume; a guard would not remove it.

> **Update 2 Oct ~21:05, builder shadps4-lane-f9: GoW fixes PR-readiness check, read-only (next in the job order
> after #5218). None of the three is ready for a PR, and formatting is not the reason.** Output and scripts:
> `C:\shadps4-gow\logs\gow_fixes_pr_check_20261002.txt`; `C:\shadps4-gow\tools\gow_cf_check_v2.sh`,
> `gow_merge_check_v1.sh`, `gow_upstream_search_v1.py`.
> - clang-format 19.1.5 run the way upstream CI runs it (`.github/workflows/scripts/clang-format.sh`: every changed
>   `src/*.cpp|h`, the whole file, style `src/.clang-format`): tg-size-sgpr b89a2772 6 files, ds-ordered-count a1af1159
>   19, tsharp-dw1-mask dc08b752 4. All 29: `--dry-run --Werror` rc 0, no diff, no trailing whitespace, LF. Main's
>   versions of the same files are clean too; a copy with an added badly formatted line is flagged (rc 1). The 1 Oct
>   "every file flagged" result was the wrong style path, as gtnikos-02 said.
> - Trial merges onto bf794b3f (`merge-tree --merge-base=8151ee25`): tg-size-sgpr has no conflict, but only because it
>   changes the cache versions 5 -> 6, the values main has now, so a plain rebase would carry NO bump; tg +
>   ds-ordered-count conflict only in ShaderMetaVersion (main 6, branch 7); tsharp-dw1-mask only in the version lines
>   (main B6/M6, branch B5/M6). Each rebased commit needs main's value + 1 set by hand (tg B7/M7, then ds M8; tsharp M7,
>   or M8 if it lands second). Main changed touched files since 8151ee25 (#5181, #5133, #5199, #5203, #5201, #5193,
>   #5137, #5169, #5165, #5131, #5145); all merge cleanly, so a rebased commit still needs a compile and runs.
> - Main still has every gap: no translator for DS_ORDERED_COUNT (only format.cpp / opcodes.h name it), no `tg_size`
>   anywhere in src, and `ASSERT(IsSharpSource(source))` still at resource_discover_pass.cpp:257.
> - Upstream: no new PR or issue for DS_ORDERED_COUNT (#496 aggregate open; #2899 closed 2025; #4247, raphaelthegreat's
>   closed "reg type tracking", also matches) or for the TG_SIZE SGPR; none of the three branches was ever opened as a
>   PR; #4999 closed 24 Sep. The named post-ops BitwiseOrDw1WithImm / ClearAnisoRatioAndThreshold came with #4782 (5
>   Sep): those are the "other cases" of baggins183's #4999 comment. #5059 (merged 19 Sep) added a sharp-source pattern
>   (V_READFIRSTLANE_B32) to the discover pass.
> - What blocks each (memory gow-fixes-for-pr.md, unchanged): tg-size-sgpr fixes no failure on main by itself (no game
>   known to read that SGPR without DS_ORDERED_COUNT: PR criterion 1); ds-ordered-count gets GoW past main's "Unknown
>   opcode" stop, but every GoW run with it (GOW2, GOW3, TEST1, TEST2) then hangs the GPU (GOW2/GOW3: ~27 s after the
>   ordered-count shader compiles), cause unknown, and the three wave-model hang cases (a)-(c) are open; tsharp-dw1-mask
>   keeps the post-op design the maintainer asked to move into the SRT program. Criterion 2 is shown for none: only GoW's
>   test line carries them.
> - Proposed, waiting for the user: the one-variable GoW test the memory names (a [test] gate that skips the ordered
>   wait and keeps the atomic: hang gone = the wait deadlocks, hang stays = it is elsewhere), or the next CRASH_MAP
>   problem, or the run of #5218's own code.

> **Update 2 Oct ~20:55, builder shadps4-lane-f9: the user confirmed shadps4-lane-8f as the new watcher/auditor.** The
> authorized pair is now shadps4-lane-f9 (builder) and shadps4-lane-8f (auditor), for the two builder messages of
> section 2: a notice before a checkout switch, the build details after a build. ListAgents 20:53: only
> shadps4-lane-8f (gtnikos-e8 and gtnikos-02 are gone). Re-checked 20:53: #5218, #5155, #5219, origin/main and `mine`
> unchanged since 18:37 (no comment, no review, same heads; #5219's two Linux jobs still failing). No message sent.
> Next: the GoW PR-readiness check (read-only).

> **Update 2 Oct ~18:40, builder shadps4-lane-f9 (replaces gtnikos-02; started in C:\shadps4-lane): state checked
> read-only 18:20-18:37. Nothing built, changed, launched or pushed, except the md copies to `claude`.**
> - origin/main = **bf794b3f** "started 0.19.1 WIP" (17:05; CMakeLists.txt + flake.nix version lines only). Cache
>   versions on main: ShaderBinaryVersion 6, ShaderMetaVersion 6.
> - **#5218**: head **9a6e7de8** = the user's GitHub merge of bf794b3f (17:39:44; its diff against 4af30efb = those
>   version lines only), 5 commits, 14 files +1127 -53, mergeable clean. No comment, review comment or review after the
>   user's reply of 13:45:40Z (the PR's only two comments are raphaelthegreat's 13:19:59Z and that reply). CI: 4af30efb
>   (run 37015435275) 10 success + pre-release skipped, done 14:33Z; 9a6e7de8 the same, done 15:19Z. The PR's code (v2 +
>   the move) has never run in a game: every test exe carries the version from before the move.
> - **#5155**: head 302facf1 = two more GitHub merges (7393baea of c7e065d1 at 16:48, 302facf1 of bf794b3f at 17:39);
>   net diff against main still 1 file +1; 0 comments, 0 reviews; CI 10 success + pre-release skipped.
> - **#5219**: unchanged (head be258106, 11 commits, 0 comments, 0 reviews); linux-sdl and linux-sdl-gcc still
>   failure, mergeable_state unstable. Side fact for CRASH_MAP #2: it removes TrackImageHead / TrackImageTail.
> - Local `resource-guards` = 18dc8618, two GitHub merges behind `mine` (4af30efb, 9a6e7de8): fast-forward it before any
>   change to the PR. Checkout `C:\shadps4-clean` = resource-guards 18dc8618, only ` M externals/mesa-kosmickrisp`.
>   `mine/claude` was 7cbbd0f0 (the auditor's handoff for its successor, 18:30). The GoW branches still sit on 8151ee25
>   (cache lines tg-size-sgpr B6/M6, ds-ordered-count B6/M7, tsharp-dw1-mask B5/M6).
> - No shadps4 process. Newest files in the four `logs` folders: TEST40 r2 (14:32), the audits (15:03),
>   `pr5218_guardpass_build.log` (16:41); every profile's `user\log\shad_log.txt` is older than 14:44: no run since.
> - ListAgents: gtnikos-e8 (busy), gtnikos-02 (idle), shadps4-lane-8f (busy, started with this session; not confirmed
>   as the auditor). No message sent.
> - Main still ignores the CHAIN bit of INDIRECT_BUFFER (liverpool.cpp:794 GFX, :928 ASC): it processes the child, then
>   goes on with the rest of the parent. That is the untested 24 Sep lead for CRASH_MAP #3 (CLAUDE_MEMORY.md section 5).
> - Proposed to the user, waiting: (1) #5218 waits for its review; nothing to answer. (2) The GoW PR-readiness check,
>   read-only: clang-format 19 `--dry-run --Werror` with `src\.clang-format` on each branch's src files, merge-tree onto
>   bf794b3f, upstream search. (3) A run of the PR's own code: each game's stack replayed onto bf794b3f with the PR's
>   current guard code, plus GtInsertGuardChecks ported into resource_guard_pass.cpp (builds need the user's go; the new
>   file and the version lines make CMake re-run). (4) Then CRASH_MAP: none of the 4 runs with the fix (TEST39 r1-r2,
>   TEST40 r1-r2) ended at #2, #4, #7 or #13; of the rest, #1 (17 runs) and #3 (15) each need their log lines first.

> **Update 2 Oct ~17:05, builder gtnikos-02: raphaelthegreat opened his own PR #5219 "video_core: Renderer
> optimizations pt2 (texture cache edition)"; checked read-only, nothing built, changed, pushed or launched.**
> 13:52:33 UTC, head be258106, 11 commits, 27 files +871 -849, all in src/common and src/video_core (no
> shader_recompiler file), merge-base 4355d9eb. His text: CPU-overhead micro-optimizations of the texture cache, to be
> reviewed commit by commit, and the locking change is what needs testing (ff0f4997: the global texture-cache mutex
> leaves FindImage / InvalidateMemory / InvalidateMemoryFromGPU / UnmapMemory, each Image gets its own mutex). Fetched to
> the local ref `refs/pr/5219` in C:\shadps4-clean (fetch only, the checkout did not change). Facts for our PRs:
> - #5196 (merged): 56237fa8 moves our UpdateSize loop verbatim into the constexpr `ComputeImageSize` in tile.h
>   (IsMacroTiledMip, micro_tiled_mips and the thickness rounding of num_slices unchanged); c5a80206 moves
>   GetArrayMode / GetMicroTileMode / GetAltNumBanks verbatim into tiling.h (Thin3DThinPrt -> ArrayPrt3DTiledThin1
>   kept); the micro_tiled_mips path of tiling.comp is unchanged. c5a80206 also makes MipInfo pitch/height u16 (and
>   uint16_t in tiling.comp's uniform; a T# pitch/height is at most 16384), SubresourceBase/Extent u16, and adds a fast
>   path for square pow2 64/128-bit BCn Thin1DThin images up to 1024 with a full mip chain, read from tables that the
>   same ComputeImageSize builds from the same inputs.
> - #5218 (open): no file in common; `git merge-tree --write-tree mine/resource-guards refs/pr/5219` = no conflict
>   (tree a813f78e). 480dfba9 makes `image_bindings` a member std::array; its two null paths only set `image_id = {}`
>   and keep that slot's previous `desc`, and the descriptor-write loop takes `desc.type` from it, so a null image is
>   written with the type of whatever image was last bound at that index (eStorageImage after a storage image, e.g. of
>   a compute dispatch); in main a null entry is a fresh ImageDesc (type Texture), always eSampledImage. The dead slots
>   of #5218 take that null path, and the layout declares them sampled. 886eecce: SurfaceFormat moves into
>   liverpool_to_vk.h as constexpr with the same ASSERT_MSG "Unknown data_format={} and num_format={}" (the #5218 text
>   quotes only the message); NumComponents / NumBitsPerBlock / NumBitsPerElement lose their range ASSERT (42-entry
>   tables, DataFormat goes to 63), but in ImageInfo(T#) SurfaceFormat still runs first and no format >= 42 has a
>   surface entry, so the fix-off assert at data_format 46 stays the same assert; GetSampler (slot vector + intrusive
>   LRU, same XXH3 hash) still maps a zero S# to one cached sampler; the IsMeta warning in BindTextures is removed;
>   bank_swizzle is now set only with alt_tile_mode, which equals main because GetBankSwizzle returns 0 without it.
> - #5218 now: head 4af30efb = the user's GitHub merge of main c7e065d1 ("tagged 0.19.0 release": CMakeLists.txt +
>   flake.nix version lines only, same lines as 3912336f..c7e065d1) at 16:48, 4 commits, mergeable clean, no new
>   comment since the user's reply at 16:45 (which asked raphaelthegreat to look at #5155), no check runs reported on
>   4af30efb. The local `resource-guards` in C:\shadps4-clean is still 18dc8618, one merge behind `mine`.
> - ~17:15, the user asked whether #5219 changes anything visually: by the code, no. Mip layouts and sizes, formats,
>   swizzles (identity -> vk::ComponentMapping{} = the same mapping, the rest converted at view creation instead of
>   at ImageViewInfo construction) and the GC rules (same configure / num_deletions / download conditions; TouchImage
>   still called at the same 4 places, now inline) all give main's results; the PR gives no performance numbers.
>   Only failure modes could show: the per-image locking; the null-slot descriptor type; and tiling.comp now reads
>   uint16_t from its UNIFORM buffer (binding 2, eUniformBuffer) while vk_instance.cpp enables only
>   storageBuffer16BitAccess, not uniformAndStorageBuffer16BitAccess (SSBO 16-bit BLOCK_TYPE was already used).
> - ~17:20, the user: one of his checks failed. CI of #5219 head be258106 (run 37015950340, public API ~17:10):
>   FAILED linux-sdl (clang-19, libstdc++, Release + IPO + mold) and linux-sdl-gcc (gcc-14, same), both in the
>   build step, annotation only "Process completed with exit code 2"; passed: macos-sdl (AppleClang + libc++),
>   the three "Run C++ Tests" jobs (ubuntu = clang + -stdlib=libc++ in Debug, ENABLE_TESTS=ON, cmake --build),
>   clang-format, reuse; windows-sdl still in progress. The error line itself is not readable without a GitHub
>   login (API job logs: 403 "Must have admin rights"; job page: "Sign in to view logs"); not found by reading
>   the diff either. Our CI: db68308b success, 18dc8618 success (14:20 UTC), 4af30efb (run 37015435275) in
>   progress at 14:20 UTC.
> - ~17:40, the user: every md a session writes also goes to branch `claude` on `mine`, pushed right after the
>   write (rule line in the CLAUDE.md block; recipe, paths and what stays out in memory
>   shadps4-claude-notes-branch.md). First builder commit there: this HANDOFF.md, memory/gt7-shadps4-lane.md (new
>   on the branch), the updated memory note and the shadPS4 section of C:\GTNikos\CLAUDE.md, on top of the
>   auditor's f498fe6e.
> - ~18:10, the user agreed: lane sessions now start in C:\shadps4-lane, whose own CLAUDE.md (7 KB, against 509 KB
>   for C:\GTNikos\CLAUDE.md) is a short brief + the RULES block, kept in step with the copy in C:\GTNikos\CLAUDE.md;
>   that folder's Claude memory folder is a junction to the c--GTNikos one, so both see the same memory files.
>   C:\GTNikos\CLAUDE.md was not shortened. NEXT_AUDITOR_PROMPT.txt points the next auditor there. Details:
>   memory shadps4-lane-folder.md.

> **Update 2 Oct ~16:45, builder gtnikos-02: the reviewer's change is done and PUSHED - #5218 head 18dc8618, 3
> commits** (user: "ok proceed as he asked"; a new commit on top, no force-push, as the user kept the history before).
> 18dc8618 "shader_recompiler: Move the resource guards into a separate pass" (title only, author/committer
> nikmparis217-ux noreply, no trailer), parent db68308b. Made by `scratchpad\move_guard_pass.py` from the 16369d61 blob,
> which refuses to write unless every boundary line matches: new `src/shader_recompiler/ir/passes/resource_guard_pass.cpp`
> (924 lines) = the analysis (16369d61 lines 940-1515, byte-identical) + `ResourceGuardPass(IR::Program&,
> ResourceDiscoveryList&)` (= FindResourceGuards, writing `resources[i].guards` instead of returning a list) + the
> per-draw evaluator (lines 1608-1879, byte-identical); `ResourceDiscovery` gains `std::array<u8, 2> guards{NO_GUARD,
> NO_GUARD}`; SharpLocationFromSource / ConstructSharpFetch (with the `warn` flag) moved to resource_pass.h, which now
> includes resource.h + common/logging/log.h instead of forward-declaring SharpFetchPostOp; recompiler.cpp calls
> ResourceGuardPass right before ResourcePatchingPass(program.info, ...) (main's call again); ir_passes.h = main + one
> declaration; CMakeLists.txt + 1 line. resource_patching_pass.cpp vs main 3912336f: only -44 (the two helpers) and +3
> (`.guard = resource.guards[0|1]`). clang-format 19.1.5 `--dry-run --Werror` clean on all 5 files (controls: a main
> file clean, a bad file flagged); `git diff --check` clean, 0 CR bytes, 0 GT_ lines. Build 16:35:24-16:41:31 in
> C:\shadps4-clean (resource-guards checked out at db68308b first; notice to gtnikos-e8 before the switch): CMake
> re-ran and rebuilt everything, 2383 steps, NINJA_EXIT=0, 0 warnings in src (the 2559 others are externals', incl. one
> in fmt's own format.cc); log `logs\pr5218_guardpass_build.log`; no exe kept, the build output is now this PR build.
> Push `db68308b..18dc8618` (fast-forward). PR after: 14 files, +1127 -53, mergeable, CI running. Build details sent to
> gtnikos-e8 (+ a time correction). ⚠ The earlier GoW clang-format result ("every file flagged") was MY method error:
> the style file is `src/.clang-format` and the command pointed at a root `.clang-format` that does not exist; redo the
> GoW check with `--dry-run --Werror` on the real files. ⚠ Future GT_GUARDCHECK test lines must port GtInsertGuardChecks
> to the new file layout.

> **Update 2 Oct ~16:23, builder gtnikos-02: the user opened PR #5218 "shader_recompiler: Skip images and samplers
> behind untaken branches"** (13:11:33 UTC, head db68308b = 16369d61 + GitHub's merge of main 3912336f, 2 commits by the
> user's choice, description = the user's text). **First review comment** (raphaelthegreat, 5953280337, 13:19:59 UTC):
> "Firstly can you move all the resource guard pass into a separate pass/different cpp at least so it doesnt clutter
> resource patching". Facts gathered (read-only): in 16369d61 resource_patching_pass.cpp grows 955 -> 1879 lines; the
> analysis (GuardBuilder / GuardCollector / GuardGroups / FindResourceGuards) is lines 940-1574 and the per-draw
> evaluator (ResourceGuards::EvaluateDead + helpers, runtime code) lines 1608-1879; the rest are small edits (`.guard =`,
> the `warn` flag of SharpLocationFromSource / ConstructSharpFetch, ResourcePatchingPass taking the Program). It sits
> there only because the test builds avoided new source files (a new file = a CMake re-run); the 30 Sep plan had it as
> its own pass between FlattenExtendedUserdataPass and ResourcePatchingPass. The move needs the user's go: a CMake
> re-run, a checkout switch (notice to gtnikos-e8 first), a compile check, a push that changes #5218 at once. The GoW
> PR check (user: "now for the GOW fixes") is paused for the PR; so far: none of the three is ready as it stands
> (see memory gow-fixes-for-pr); each merges onto 3912336f with conflicts only in the cache version lines; a
> clang-format check flagged every file of all three and is not trusted yet (to redo).

> **Update 2 Oct ~15:22, builder gtnikos-02: `mine/resource-guards` is now db68308b, not 16369d61.** db68308b =
> "Merge branch 'shadps4-emu:main' into resource-guards" (parents 16369d61 + main 3912336f, 15:19:58 from the user's
> account = GitHub's update-branch button). Checked: its tree = `git merge-tree` of the two, and its diff against
> 3912336f has the same patch-id as 7e778987..16369d61 (c92647a1...), 11 files +1083/-16: the merge adds nothing but
> main. The user is on GitHub's open-PR page (no PR yet); because of the 2 commits GitHub proposes the branch name as
> the title; title given: the commit's own, "shader_recompiler: Skip images and samplers behind untaken branches".
> Offered, not done: rebase 16369d61 onto 3912336f + force-push, for one commit again (needs the user's go; before the
> PR exists, or the PR changes at once). **User ~16:09: keeps the 2 commits as they are ("it is an experiment
> anyway").** The PR description is the user's text (reviewed in chat for facts and typos only); no PR open yet
> (public API, 16:09).

> **Update 2 Oct ~15:05, builder gtnikos-02: the fix stays ONE commit and ONE PR (user: "ok so we keep it a whole");
> a plain explanation of it given in chat for the user's own PR text. Nothing built, changed, pushed or launched.**
> The split question was answered first, read-only: the mechanism (conditions found at compile time, the per-draw
> evaluation, null at GetSharp, the dead set in the permutation key, the cache version) only works as a whole; a cut by
> condition family (mechanism + integer ~790 lines, lane masks ~75, float ~220) would work part by part (unknown =
> live, the logic is monotonic), but part 1 stays most of the code. The user will say in the review that the fix is
> experimental. Run facts used, from gtnikos-e8's audits (`logs\test40_gt7_runs_audit.txt`,
> `C:\shadps4-gow\logs\gow_test2_runs_audit.txt`, `games_test2_runs_audit.txt`): fs 0x2a265dff with the fix off
> (TEST37 r1-r4) 24-39 compiles a run, `Rejecting invalid T#/S#` 18-65 / 74-283, 3 of 4 runs ended on the SurfaceFormat
> / ComponentSwizzle assert at its image #0; with it on (TEST39 r1-r2, TEST40 r1-r2) 1 compile, 0 / 0, no such assert,
> all 4 reached a race; GT_GUARDCHECK 0 HIT in GT7 r1-r2 (224 / 449 modules with a dead slot), GoW r1-r2 (up to 92),
> GoT r1-r3 (1), GTA V nothing to check (no shader with guards); every run ended where earlier runs of that game did.

> **Update 2 Oct ~14:05, builder gtnikos-02: all steps done (user: "ok do all steps") - 4 builds, 8 launchers, the
> push. Nothing launched.** No shadps4 process during any build (the last run before them, GTA V r5, ended 13:17:22).
> gtnikos-e8 got a notice before the first switch and build details after each build. Checkout now
> got-test2-main-d9cf41ba e8a9f602.
> (1) **PR commit v2 16369d61 compiles on main 7e778987**: 13:44:55-13:46:51, 214 steps, NINJA_EXIT=0, 0 warnings, no
> CMake (log `logs\pr_resource_guards_16369d61_build.log`; no exe kept). **Pushed**: `mine/resource-guards`
> `+ 4e06ba5b...16369d61 (forced update)`; no PR on it. origin/main is now 3912336f (5 commits past 7e778987: #5186,
> #5182, #5212, #5208, #5214), none touching the fix's 11 files; `git merge-tree` of 16369d61 onto 3912336f is clean.
> #5155: head 5d55be06 (another GitHub "Update branch" merge, main ef08b1e1), 0 reviews, 0 comments.
> (2) **The [test] commits were amended once**: the first TEST40 build gave 2 warnings (-Wunused-result: the
> [[nodiscard]] result of `ir.BufferAtomicOr` ignored, resource_patching_pass.cpp:1611/1613); both calls are now in
> `static_cast<void>(...)` (the codebase's idiom, common/logging/log.cpp:81), +4 -3, same behaviour (the atomic has
> side effects). New hashes: **GT7 TEST40 = 07a74022** (was 6ccc1abc), **GoW TEST2 = 6b19950f** (was 1cb4c9b2),
> **GoT / GTA V TEST2 = e8a9f602** (was d4da0296; got-test2 and gtav-test2 both point at it); the [test] commit has
> patch-id bdda5971 on both TEST1 lines.
> (3) Builds, all NINJA_EXIT=0, 0 warnings, 0 errors, no CMake: TEST40 107 s / 204 steps (6ccc1abc) + 8 s / 3 steps
> after the amend; GoW TEST2 60 s / 109 steps; GoT/GTA V TEST2 59 s / 106 steps. Exes, each with a pdb dir beside it:
> `backup_exe\shadps4_test40_07a74022_gt7.exe` 44C88540...73A6; `C:\shadps4-gow\backup_exe\shadps4_gow_test2_6b19950f.exe`
> E3D6193A...B8F4; `shadps4_got_test2_e8a9f602.exe` / `shadps4_gtav_test2_e8a9f602.exe` AB67D366...F48A (one copy per
> game folder). Details: `logs\test40_build_details.txt`, the TEST2 section of each game README, the build logs
> (`logs\test40_build.log`, `C:\shadps4-gow\logs\gow_test2_build.log`, `C:\shadps4-got\logs\games_test2_build.log` +
> a copy in `C:\shadps4-gtav\logs`).
> (4) Launchers, each = its predecessor with exact substitutions (`builder_scripts\make_test40_launchers.pl`,
> `builder_scripts\make_test2_launchers.pl`): GT7 `TEST40_GT7_07a74022_guardcheck_diag_console.bat` (GT_GUARDCHECK=1)
> and `TEST40_GT7_07a74022_guardcheck_canary_diag_console.bat` (=2), from TEST39's (GT_DIAG, GT_IMGDUMP_DIR,
> GT_BINDLOG, snapshot and save A kept; log names test40, the same for both modes, the mode is in the log);
> GoW / GoT / GTA V `<GAME>_TEST2_<hash>_guardcheck_console.bat` and `..._guardcheck_canary_console.bat`, from each
> TEST1 fixon launcher (GT_GUARDLOG kept; console `console_<game>_test2_guardcheck|canary_<TS>.txt`). The TEST1 and
> TEST39 launchers are unchanged.
> (5) What there is to check, from the earlier logs: GT7 469 of 1187 cached shaders have guarded slots; GoW TEST1 r2
> 106 shaders with guards, 81 with a dead set at some bind, before the GPU hang; GoT TEST1 r2 5 / 4 before the driver
> crash on cs 0x14906b6a; **GTA V TEST1 r3/r4: 0 shaders with guards** up to the hull-shader assert that ends every
> run, so a GTA V check run should show only the start-up `guardcheck:` line. NEXT: the user's runs - a canary run
> (=2) per game shows GPU write -> log; a `guardcheck HIT` line = a wrong "dead" verdict, naming stage/hash/perm.

> **Update 2 Oct ~13:40, builder gtnikos-02: the three risk options are written, NOT built, NOT pushed** (user: "all
> 3"). Made with plumbing (temp index + commit-tree, merge-tree); `C:\shadps4-clean` stays on gow-test1-main-d9cf41ba
> 1c6cff84, untouched. clang-format 22.1.8, CR and trailing whitespace: clean.
> (A) **PR commit v2 = 16369d61** (parent main 7e778987, same title, no trailer, 0 GT_ lines, 11 files) = 4e06ba5b +:
> FAbs results count as float-op results (a zero result is never reinterpreted as bits); a GPU setting
> `resource_guards_enabled` (default true, per-game override, `SETTING_FORWARD_BOOL_READONLY` ->
> `IsResourceGuardsEnabled()`, startup line "GPU resourceGuards"); `HasShaderPatch` -> `SkipResourceGuards()` = setting
> off OR `shader_collect` on (the shader editor's ReplaceShader only reaches collected modules) OR a patch file;
> `skip_resource_guards` moved into InfoPersistent so the meta saves it, and LoadPipelineStage rejects a meta whose saved
> value differs from today's decision (a cache built with the other setting is recompiled, never reused). Local branch
> `resource-guards` = 16369d61; `mine/resource-guards` is still 4e06ba5b (push not done; no PR is open on it).
> (B) **GPU check `GT_GUARDCHECK`, [test] commit**: GT7 **TEST40 = 6ccc1abc** (`test40-main-2338a06f`, on TEST39
> 0247e2e9), GoW **TEST2 = 1cb4c9b2** (`gow-test2-main-d9cf41ba`, on 1c6cff84), GoT / GTA V **TEST2 = d4da0296**
> (`got-test2-main-d9cf41ba` = `gtav-test2-main-d9cf41ba`, on 7d09a8a8); the same added lines in all three (patch-id
> 00ac867f on the TEST1 lines; GT7 ported by hand in 2 files, line-identical). What it does: a program with guards (its
> first compile decides) gets a `BufferType::GtGuardCheck` storage buffer; before pass 2 of ResourcePatchingPass every
> image instruction using a group this compile judged dead gets `BufferAtomicOr(slot, bits)` in its own block; the
> slot = compile order (PipelineCache keeps hash/stage/perm/dead set per slot); the rasterizer binds a 512 KB HostCached
> buffer and, after each submit, a DeferOperation reads it: `[GT_DIAG] guardcheck HIT: <stage> <hash> perm <n> ...`
> (ERROR) per new bit, a summary every 60 s, `guardcheck canary` lines with GT_GUARDCHECK=2 (live reads of the first 4
> guarded modules - proves GPU write -> log); the pipeline cache is neither read nor written while it is set. FPS of a
> check run is not comparable. NEXT (needs the user's go): builds (PR commit compile check on 7e778987, TEST40,
> GoW TEST2, GoT/GTA V TEST2), launchers with GT_GUARDCHECK=1 and a canary one with =2, the push of 16369d61.

> **Update 2 Oct ~13:00, builder gtnikos-02: read-only audit of 4e06ba5b for a wrong "dead" verdict** (user, on the
> review's "possible risk" line: "could we do anything with the possible risk?"). No build, no run, no push, no
> checkout switch. A wrong verdict needs wrong data, a wrong condition or wrong arithmetic; none was found:
> (1) data: GetUserData and a flattened ReadConst (flags != 0) both compile to EmitFlatbufferLoad, DMA on or off;
> the dead set and the uploaded buffer are the same `program->info.flattened_ud_buf`, refreshed by GetProgram on
> every draw (BindBuffers copies `stage.flattened_ud_buf`); (2) conditions: the pass runs before structurization,
> on one IR block per CFG block with edges added branch_true then branch_false (EmitControlFlowGraph), and
> `branch_cond` is the block's own CFG condition (translate.cpp:1223); an exec scope's parent always has a false
> edge around the scope (SplitDivergenceScopes), and InverseBallot reads only the invocation's own bit, which that
> invocation wrote, so the lane-mask view is exact per lane, Not64/Xor64 included; (3) arithmetic: SPIR-V-undefined
> cases return Unknown (shift >= 32, BitFieldUExtract out of range, FClamp lo > hi); float ops only on normal/zero
> operands with exact results; a zero made by a float op is never reinterpreted as bits.
> Corners found: (a) FAbs: the evaluator clears the sign bit, GLSL.std.450 defines FAbs as "x if x >= 0", so the
> bits of FAbs(-0.0) are not pinned; reachable only through a bitcast of an FAbs result; closable by treating
> FAbs/FNeg zero results like other float results. (b) ReplaceShader (devtools shader editor, shader_list.cpp:62)
> keeps the guards, while the plan said the table stays empty there. (c) #5155 moves `flattened_ud_buf` without
> RefreshResourceGuards: no effect today (a guarded group is sampled-only, so its binding count and type never
> depend on deadness, and GetProgram refreshes before every draw), but whichever PR merges second should refresh
> after the move. Worst case of a wrong verdict, stated exactly: the shader reads zeros from that slot (pixel
> shader: black/transparent texture; compute/vertex: zeros in what it computes); nothing is decoded.
> Proposed, NOT started: a GT_* GPU-side check - in a module compiled with a dead set, a read of a dead slot first
> sets a bit (program, group) in a host-visible buffer, the host logs set bits per frame; the write sits on the
> branch the verdict says is never taken, so it runs only if the verdict is wrong; the only check that does not rely
> on the evaluator; a silent log over a run = no nulled slot was read in that run (evidence for PR criterion 2).
> FPS from such a build is not comparable (a storage write in a pixel shader can turn off early depth tests).
> Optional: a user-facing off switch. Waiting for the user's choice.

> **Update 2 Oct ~02:45, builder gtnikos-02: the resource-guard fix is ONE commit on the fork, branch
> `resource-guards` = 4e06ba5b** (user: "a commit of a different branch on our latest fix with the 1000+ line code.
> make a proper tittle in the commit on OUR fork not origin"). Title only: "shader_recompiler: Skip images and
> samplers behind untaken branches"; parent = main 7e778987; author/committer nikmparis217-ux noreply; no trailer.
> Content = ebcfc8a2 + 9bc582bb (the GT7 TEST38/TEST39 line) = c8408b45 + 2d7c711e (the TEST1 line on d9cf41ba):
> all three give patch-id 67b0b53b; the [test] commits (0247e2e9 guardlog, 3913017d / 7d09a8a8 GT_GUARDLOG,
> GT_NOGUARDS) are left out; 0 added lines with GT_. 9 files, +1068 -15; cache ShaderBinary/ShaderMeta 7/7 (main
> 6/6). Made with `git merge-tree --write-tree` (clean; main's 4 commits since d9cf41ba touch none of these files) +
> commit-tree, so `C:\shadps4-clean` stayed on gow-test1-main-d9cf41ba; clang-format 22.1.8, trailing whitespace and
> CR: 0 issues in all 9 files. NOT compiled on 7e778987 (the same code compiled on 2338a06f in TEST38/TEST39 and on
> d9cf41ba in TEST1). Pushed as a new branch (`* [new branch] resource-guards`), no PR opened, nothing on origin.
> Local branch `resource-guards` = 4e06ba5b. PR criteria still open: (2) no other working game worse is not shown
> (GoW TEST1 on/off identical but it stops early; GoT ends on an unrelated invalid-SPIR-V crash; GTA V's guards-on
> run lasted 2 s), and GT7 has 2 runs with the pass running.

> **Update 2 Oct ~01:35, builder gtnikos-02: cleanup after the #5196 merge (user: "delete all unecesery stuff we dont
> need anymore"; asked about the rest: "none other").** Deleted: local branch `tiled-mip-layout` (43db7964, tree =
> main 7e778987) and the local tag `pr5196-before-numslices`; stale remote-tracking refs `mine/tiled-mip-layout` and
> `mine/user-data-flatbuf-fallback` (both already gone from the fork); the stale worktree entry `C:/shadps4-pr5126`
> (folder was already gone; branch `compute-float-mode` stays). `builder_scripts\bc_checker`: the PR-only
> before/after scaffolding is gone (pre_* / lt / t36 variants, run5-run15 outputs, gpu_main / gpu_fixed / gpu_run
> outputs, main_src, gpu_obj, pr_evidence, build18*/pre_mipmode/gpu_test_main builds, patch_fixed.py,
> tiling_prt18.cpp) - so the run14/run15/pr_evidence/gpu_* files cited in older blocks no longer exist; KEPT the two
> tools: `bc_checker.cpp` + `bc_checker.exe` (= the old bc_checker_t36.exe, built from this source) + build.bat +
> stub, and `tiling_gpu_test.cpp` + exe + build_gpu_test.bat, plus classify/dumpsheet/proofsheet.py. Claude Code's
> own `Temp\claude\bash-edit-diff` cache deleted (9.9 GB, 14,503 files). NOT deleted (user said no): GT7 TEST3 /
> TEST19 / TEST29-TEST38 exes, the pre-24-Sep logs, the gow1-3 exes. Side fact: #5155's branch got another GitHub
> "Update branch" merge at 01:27 (acf37d88, main 7e778987 merged in).

> **Update 2 Oct ~01:20, builder gtnikos-02: PR #5196 is MERGED.** CI on 43db7964 finished 01:16 local: 10 success +
> pre-release skipped (same set as before). The user had replied "on it" in the num_slices thread (4160941382, 22:01
> UTC). raphaelthegreat APPROVED 43db7964 (review 5386247151, 22:16:12 UTC) and merged it 6 s later (22:16:18 UTC) as a
> squash: upstream main is now **7e778987** "video_core: Fix mip layout and detiling of tiled textures (#5196)", parent
> fecfbed0, author nikmparis217-ux, committer GitHub, **tree ae943cc8 = the tree of our 43db7964** (zero diff).
> Local origin/main fetched (dd43d1ca -> 7e778987). Consequences: the next test line built on main >= 7e778987 drops
> the PR's commits from our stack (the TEST1 / TEST39 stacks carry the pre-num_slices version e5a7e3f7 / d0dfe411 /
> 664f621f etc.; main wins the TilingInfo order); the GPU test's "main" layout variant (`TilingInfoHost` without
> micro_tiled_mips, 12 + 16*16) only matches main BEFORE 7e778987. Open PRs of ours: only **#5155** "video_core: Use
> each preloaded permutation's own flattened user data" (head 584cc21c, 0 comments, 0 reviews, updated 1 Oct 15:40 UTC).

> **Update 2 Oct ~01:05, builder gtnikos-02: the num_slices change is made and FORCE-PUSHED (user: "ok make the change
> and force push it", then "remembre only ghat one line he asked").** PR #5196 head is now **43db7964** = ONE commit on
> fecfbed0 (was ee17897f = 4697d56c + 2 GitHub merges), same title-only message, same author and author date, no
> trailer. Its tree = ee17897f's tree + only the requested change: `micro_tiled_mips` takes the slot of the unused
> `num_slices` in `TilingInfo` (tile_manager.cpp) AND in the shader's `TilingInfo` block (tiling.comp), and the two
> `params.num_slices = ...` lines (DetileImage, TileImage) became the `params.micro_tiled_mips = ...` lines; field order
> bank_swizzle, micro_tiled_mips, num_mips, mips (268 B, = main's size). Vs main the two files now show 4 replaced
> lines (3 C++, 1 GLSL). Checked before the push: diff ee17897f..43db7964 = those files only (+4 -8), no `num_slices`
> left in them, no CR bytes, no trailing whitespace, local clang-format 22.1.8 leaves tile_manager.cpp unchanged (CI
> uses clang-format-19 on .cpp/.h; whitespace check on all of src). Made with git plumbing (temporary index,
> commit-tree), so the `C:\shadps4-clean` checkout stayed on gow-test1-main-d9cf41ba; nothing built locally (CI is the
> build check). Push `--force-with-lease` against ee17897f: `+ ee17897f...43db7964 (forced update)`. Local
> `tiled-mip-layout` = 43db7964 (no longer behind); the old head is local tag `pr5196-before-numslices` = ee17897f (not
> pushed). PR after the push: 1 commit, 6 files, +54 -45, CI running. ⚠ `bc_checker\tiling_gpu_test.cpp` mirrors the
> OLD 272 B layout (`TilingInfoHost` :374-381, num_slices set at :639): it still matches the SPIR-V of the current
> build (all test lines carry the old PR code) but needs the new order before it is rebuilt against a build with
> 43db7964's tiling.comp. The test lines (GT7 TEST39, GoW TEST1, GoT/GTA V TEST1) keep the old PR version; num_slices
> was never read, so they behave the same.

> **Update 2 Oct ~00:55, builder gtnikos-02: two more review comments on PR #5196 (raphaelthegreat), one asking for a
> code change. Nothing changed, built or pushed; nothing written upstream.** (1) 4160785655, 21:41 UTC, reply in the
> 128 bpp thread: "ciaddrlib from what I saw fallbacks to micro tiling, so i guess this is fine". Fact:
> `ciaddrlib.cpp:1267-1272` changes the micro tile TYPE (displayable -> non-displayable = the thin micro tiling) and
> leaves the array mode alone (2D stays 2D); the only 1D_TILED_THIN1 fallback in ciaddrlib (`:736`) is the
> depth/stencil tile-config match. The PR's 128 bpp display order equals the thin order, which tiling.comp uses in both
> the 1D and the 2D path (`:226`, `:340`). (2) 4160844678, 21:48 UTC, new thread on `tile_manager.cpp` line 35 (the
> added `u32 micro_tiled_mips;`): "Can you replace num_slices here since its unused". Facts: `TilingInfo::num_slices`
> is written at `tile_manager.cpp:205` (DetileImage) and `:295` (TileImage) and declared at `tiling.comp:104`; the
> shader reads only bank_swizzle (:332), num_mips (:420), micro_tiled_mips (:439) and mips[] (:419-433). Same on main
> (declared :104, written :204/:293): never read since #3374 introduced it (d9108cd3, Aug 2025). The uniform block is
> `scalar` (tiling.comp:102), so the C++ struct and the GLSL block must keep the same fields in the same order: with
> the PR 16 B + 16 mips x 16 B = 272 B, without num_slices 268 B (= main's size). A change touches tile_manager.cpp:33,
> :205, :295 and tiling.comp:104; nothing else in src uses the struct (`num_slices` in vk_runtime.cpp:91 and
> image_info.cpp:85/100/200-202 are unrelated locals/params). The local GPU test mirrors the struct
> (`tiling_gpu_test.cpp:374-381` `TilingInfoHost`, static_assert 16 + 16*16, num_slices set at :639) and needs the same
> change to stay valid; bc_checker does not use the struct. A change = a new commit on mine/tiled-mip-layout (ee17897f
> = 4697d56c + 2 GitHub merges) or an amend + force-push; local `tiled-mip-layout` is still 4697d56c. PR: open,
> mergeable clean, head ee17897f, 4 reviews (all COMMENTED), 4 review comments, 1 issue comment.

> **Update 2 Oct ~00:30, builder gtnikos-02: PR #5196 got its first review comment (a question) and a test report;
> no code change needed, nothing written upstream.** (1) squidbus, issue comment 1 Oct 20:40 UTC: the PR lets Sonic
> Colors Ultimate go in-game with correct textures "aside from some bugged UI elements" (removing the assert alone gave
> mostly garbled textures); 2 screenshots. (2) raphaelthegreat, inline review (COMMENTED) 20:43 UTC on
> `src/video_core/host_shaders/tiling.comp` line 161 at ee17897f: "Why was this changed?" = the 128 bpp case of the
> DISPLAY micro-tile branch, old `y0,x0,x1,x2,y1,y2` -> new `x0,y0,x1,y1,x2,y2`. Facts handed to the user: the old order
> is addrlib's generic `Lib::ComputePixelIndexWithinMicroTile` ADDR_DISPLAYABLE case 128 (`addrlib1.cpp:3070-3076`), the
> new one its ADDR_NON_DISPLAYABLE order (`addrlib1.cpp:3083-3090`); SI and CI never use the former for 128 bpp:
> `SiLib::HwlSetupTileInfo` (`siaddrlib.cpp:1952-1957`, "128 bpp/thick tiling must be non-displayable") and
> `CiLib::HwlSetupTileInfo` (`ciaddrlib.cpp:1267-1272`, "128 bpp tiling must be non-displayable") set
> `inTileType = ADDR_NON_DISPLAYABLE` (addrlib = `externals/mesa-kosmickrisp/externals/mesa/src/amd/addrlib`); GPCS4's
> port of the address library: `computeSurfaceTileMode` sets kMicroTileModeThin for 128 bpp, `getTileFuncSse2` /
> `getDetileFuncSse2` have no Display 128 bpp entry (NULL). Measured: bc_checker gives addrlib the PS4 tile index and
> uses the tile type addrlib returns; old order only (`run15_t36_prt18only_hawaii.txt`) = 30 of 333 cases wrong, all 128
> bpp in Display2DThin / Display2DThinPrt / DisplayThinPrt (10 each); with the change (`run14`) 0. GPU test: the 70
> cases of 128 bpp in display modes, main 70 wrong, fix 0 (incl. Display1DThin, where only the order differs). GT7/GoW
> never use a 128-bit display detiler. PR head ee17897f = a 2nd GitHub "Update branch" merge (15:39 UTC) on top of
> 0d1df373; net diff vs main fecfbed0 = the commit 4697d56c line for line; CI on ee17897f 10 success + pre-release
> skipped. Local `tiled-mip-layout` is still 4697d56c, behind `mine` by the two merges: never push it without them.
> origin/main is now fecfbed0 (#5118) beyond dd43d1ca. **00:32: the user posted the answer** (review 5385808557,
> reply 4160704815 to 4160290545, 21:32 UTC): the checker's 30 of 333, the two HwlSetupTileInfo lines, the addrlib
> path. Checked: upstream's mesa-kosmickrisp pin bac93e02 -> mesa 063dfaee has siaddrlib.cpp, ciaddrlib.cpp and
> addrlib1.cpp identical to our checkout (kosmickrisp 3af11268 -> mesa dc41592a), so the cited line numbers land on the
> quoted lines upstream too; the path exists in a recursive checkout (externals/mesa is a nested submodule). Only
> imprecision: "30 out of 333 checkers" = 30 of the one checker's 333 cases. No answer from the reviewer yet.

> **Update 1 Oct ~16:20, builder gtnikos-02: GoW TEST1 rebuilt WITH the three GoW fixes; GoW TEST1 is now 1c6cff84
> (built, not run).** User (16:05): "you are right that was my mistake. delete the old prob and make a new including
> our gow fixes". Deleted from `C:\shadps4-gow`: the GoW 7d09a8a8 exe copy, its pdb dir and the two
> GOW_TEST1_7d09a8a8 launchers (never run; the GoT/GTA V copies are byte-identical and stay). Branch
> `gow-test1-main-d9cf41ba` moved 7d09a8a8 -> 1c6cff84 by cherry-picking f6258522 = tg-size-sgpr b89a2772, 0a8c27c2 =
> ds-ordered-count a1af1159, 1c6cff84 = tsharp-dw1-mask dc08b752; each pick has the same +/- lines as its source.
> Conflicts only in the cache versions (now ShaderBinaryVersion 8 / ShaderMetaVersion 10; main d9cf41ba is 6/6,
> 7d09a8a8 7/7) and the ImageResource member + designated-initializer order (post_op_dw1_mask, then guard). The
> guard groups key on the same `sharps[0]` whose dword1 the discover pass has already unmasked, so a masked T# groups
> like its ImageResource. Build `ninja -k 0` 106 steps, 16:12:46-16:13:41, 0 errors, 0 warnings, log
> `C:\shadps4-gow\logs\gow_test1_build.log`; exe 62,605,824 B, SHA256 B142D73C...E07E (BufferOrderedCount /
> GdsOrderedSignal strings present, absent from 7d09a8a8), pdb D7198E06...FCEC7. Launchers
> `GOW_TEST1_1c6cff84_{fixon,fixoff}_console.bat` (scratchpad make_gow_test1_launchers.pl): same body as the deleted
> ones, only the header, EXE and echo differ; GoW fixes on in both. Profile unchanged; vs GOW3's (archive
> shadps4-gow1) only patch_shaders differs (GOW3 true). Expectation = GOW3: ~320 shaders, Sony splash, then nvlddmkm
> 153 -> "Device lost during submit" (vk_scheduler.cpp:242). Notice before the checkout change + build details sent to
> gtnikos-e8 (authorized). GoT/GTA V TEST1 stay 7d09a8a8 (no GoW fixes). Base main kept at d9cf41ba: origin/main is
> now dd43d1ca (#5203 OpImageTexelPointer 1D coords, #5194 V_CVT_PK_U8_F32), not taken. PRs #5196 / #5155 at 16:06:
> open, 0 reviews, 0 comments.

> **Update 1 Oct ~08:55, builder gtnikos-02: work is now SEPARATED PER GAME, and each of GoW / GoT / GTA V has a
> TEST1 built (not run).** User: test the fix on GoW, GoT and GTA V; gather the shadPS4 folders scattered on C: into
> one new folder, except shadps4-gt7 and the upstream folder; make one folder per game; "we still use main plus our
> fixes for our games". Folders: `C:\shadps4-archive` (README.md lists each move): the GoW/GoT profiles gow1,
> test19-gow, test3-gow, test19-got, test3-got, the worktrees shadps4-sync (13 uncommitted changes kept) and
> shadps4-wt35 (`git worktree repair`; sync's 54 submodule links rewritten, status and submodule status identical
> before/after, link backup in `_gitlinks_backup_shadps4-sync`), outputs\shadps4-pr4999, C:\w. Stayed: shadps4-gt7,
> shadps4-clean, shadps4-test19-gt7 + shadps4-test4-gt7 (TEST39's profile and save A), Documents\GitHub\shadPS4 (the
> repo of all worktrees), the Desktop games folder. New: `C:\shadps4-gow`, `C:\shadps4-got`, `C:\shadps4-gtav` (each:
> README.md, 2 launchers, backup_exe, logs, tools\runsummary.awk, user\ profile from the TEST19B GoT/GoW profile with
> patch_shaders false; GoW/GoT save_start; old_tests\ = the retired GoW/GoT launchers repointed at the archive, the
> originals here untouched). TEST1 = branches gow-/got-/gtav-test1-main-d9cf41ba, all 7d09a8a8 = origin/main d9cf41ba
> (4 new commits, all checked against the fix) + TEST39's stack without d833bab4 / 9dce3330 / their reverts (14
> cherry-picks, no conflict) + 7d09a8a8 "[test] ... GT_GUARDLOG ... GT_NOGUARDS": GT_GUARDLOG logs every guarded
> shader's decision (first bind + changes, 16 lines max) and a `[GT_DIAG] guardsum` every 131072 binds; GT_NOGUARDS
> makes no guard tables and forces the dead set to 0 (also for cache-loaded programs) = fix-off baseline, same exe; a
> once-only `[GT_DIAG] tools:` line names the GT_* switches. Build 123 steps, 61 s, NINJA_EXIT=0; exe SHA256
> 2037E104...4028, one copy + pdb per game folder; build details sent to gtnikos-e8 (authorized). Expect GoW to stop
> ~50 shaders in at "Unknown opcode DS_ORDERED_COUNT" -> recompiler.cpp:48 (TEST3 and TEST19B did; main still lacks
> it): the three local GoW branches are NOT in TEST1 - the user decides. Open PRs: #5196 AND #5155 (preload, open since
> 27 Sep), both 0 reviews / 0 comments; at 04:45 UTC both got a GitHub "Update branch" merge commit from the user's
> account (mine/tiled-mip-layout 0d1df373, mine/preload-permutation-ud 2ef0de22): the local branches are behind, so
> never push them without first taking the merge.

> **Update 1 Oct ~07:50, builder gtnikos-02: before/after table for the user (fix off = TEST37 r1-r4, on = TEST39
> r1-r2) + "what was the problem, what drove the fix".** New counts, all at-exit logs TEST30-39, "Skipped N" added
> (`builder_scripts\beforeafter.awk`, table `logs\test39_beforeafter_counts.txt`): `Rejecting invalid T#/S#` TEST37
> 38/149, 27/102, 18/74, 65/283 against 0/0 (the ~00:57 figures 18-63 / 74-281 had no "Skipped"); fs 0x2a265dff's
> permutations are 34/119, 26/112, 23/109, 38/206 of each TEST37 run's permutations (18-29 %), and in r4 all 38 are
> followed by a new graphics pipeline; every other shader's permutations per distinct shader: TEST37 0.183-0.189,
> TEST39 0.205 / 0.231, earlier race runs without the fix 0.191-0.239 (TEST35 r7, TEST36 r1, TEST34 r5, TEST32 r5) =
> unchanged; "Unimplemented clamp mode" TEST37 84/62/57/179 (modes 4, 5, 7) against 9/9 (mode 4 only; TEST35 r7 501,
> TEST36 r1 275); distinct Warning/Error/Critical signatures TEST37 95, TEST39 77, none new (the 3 TEST39 lines absent
> from TEST30-37 are main's own BindBuffers "Clamped size", BindTextures "Unexpected metadata read", "Sharp source was
> not flatenned" at moved line numbers), 22 gone incl. SurfaceFormat `:788`, ComponentSwizzle `:428`, ClampMode `:321`
> and the two rejections; TEST37 r1 built one detiler no TEST39 run built (Depth2DThin64_64, source not in the log).

> **Update 1 Oct ~07:00, builder gtnikos-02: frame rate, measured from the logs - no change the fix can be blamed
> for.** User: "this fix had only an impact to fps, they are a bit lower". Clock = the ~61.2 Hz `netctl.cpp:99` line,
> frames = `gamelivestreaming.cpp:70` (+ "Skipped N"), per EVENT_ROOT scene and in 2 s buckets
> (`builder_scripts\fpsseg.awk`, `fpsbuck.awk`, `racemix.awk`). Menus and loading: the same in TEST35-39 (boot 59.6-59.7,
> PlayGo TopRootWindow 19.9-26.4 with ~121 compiles, Buddy 1.5-4.6, the race start 2.1-3.8 fps with 255-619 pipeline
> compiles: the cache is cold in every run). In-race 2 s buckets with no compile in them or the bucket before: TEST39
> r2 median 19.9 (3 buckets), TEST35 r7 17.9 (8), TEST34 r5 25.9 (5), TEST32 r5 27.4 (7), r6 22.4 (4); looser filter
> (no compile in the bucket): TEST39 r1 17.9 (2), r2 18.9 (11), TEST35 r7 20.4 (16), TEST35 r1 24.9 (2). One build's
> runs differ as much as the builds do. Log volume in the race is the same in every build (591-698 lines a frame, ~550
> of them main's `BindBuffers: Clamped size from 4294967295` error with its "Skipped" duplicates). The fix adds one
> guard-table evaluation per stage per GetProgram; TEST39 adds a second one (GT_DIAG) in BindTextures and a full scan
> of the bind-log list per texture of the two named shaders (0x74f5f10c is drawn fewer than 4 times a frame in the
> race). TEST38 has the fix without TEST39's logging.

> **Update 1 Oct ~01:03, builder gtnikos-02: the auditor's TEST39 review (message from gtnikos-e8, sent on the
> user's word) agrees with the ~00:57 reading.** It adds: r1 267 s, EXIT 0x80000003, 51.7 s (768 frames) after the
> resume from the first pause; r2 405 s, EXIT 0xC0000005, 10.18 s of racing after a restart (11.8 s with two short
> pauses); 0 "(recomputed" disagreements; the 32 dumps equal TEST34 r1's, 0x74f5f10c's bind log equals TEST36 r1's;
> the only new Warning/Error/Critical is main's `liverpool.cpp:60` NextPacket "packet length exceeds remaining
> submission size" (4810 dwords, 4 left) once in r2, also in test32_6 and test33_4, never in a #3 run; the bind log's
> "image N of M" is 0-based (checked: it prints the slot index). Its CRASH_MAP "Suggested order" item 0 is "more TEST39
> runs"; the user said ~00:50 there will be no more runs. No reply sent (not an authorized builder message).

> **Update 1 Oct ~00:57, builder gtnikos-02: TEST39 r1 + r2 read against TEST37 r1-r4 (the same code with the fix
> switched off by its patch_shaders gate). User ~00:50: "im not doing another run".** r2 00:41:08-00:47:54
> (`logs\shad_log_test39_gt7_2_at_exit_004806.txt`, pad registered) ended on CRASH_MAP class 6: `signals.cpp:144`
> 0xC0000005 at 0xd42af37 = eboot (0xbb40000) + 0x18eaf37, thread WorkT, 11.3 s after a race start request (the race
> had been restarted). No r3; TEST38 never ran. Fix off (TEST37 r1-r4) against on (TEST39 r1-r2): the SurfaceFormat /
> ComponentSwizzle assert while binding image #0 of fs 0x2a265dff ended 3 of 4 (1-2 min in, Buddy / TopRoot screens)
> against 0 of 2 (both raced; guardlog: images #0/#1 and sampler #0 dead at every bind of both runs); fs 0x2a265dff
> compiled 24-39 times against 1; `Rejecting invalid T#/S#` 18-63 / 74-281 against 0 / 0, and all 16 earlier runs
> that reached the race (TEST30-37) had 45-384 / 169-1277 (the three earlier 0/0 runs, test30_6, test30_8 and
> test32_1, died at the PlayGo top menu). Classes 2 / 4 / 7: none in either group, so 6 runs cannot tell; the slots
> the map names for 4 and 7 (texture binding 0 and image #1 of fs 0x2a265dff) were never read in TEST39. The two
> TEST39 endings (classes 3 and 6) have nothing to do with image slots. The user's question on the "switch": TEST37's
> gate keyed on the `patch_shaders` option, which all 6 test profiles have on with an empty patch folder (code default
> false since #3181, 6 Jul 2025; default TRUE from #1633, 30 Nov 2024, written into every config saved then, and later
> versions keep the file's value). With the option on, every game ran as main; TEST38's HasShaderPatch gate fixes it
> and goes into the PR commit. Not measured: any other game on TEST38/39 (PR criterion 2).

> **Update 1 Oct ~00:46, builder gtnikos-02: TEST39 r1 - the fix RAN and did what the plan said; the run ended on
> crash class 3.** r1 00:36:27-00:40:53, `logs\shad_log_test39_gt7_1_at_exit_004102.txt`, pad registered. Ending:
> `liverpool.cpp:249` "Unimplemented PM4 type 0, base reg: 0, size: 1" (CRASH_MAP class 3, 13 earlier runs since
> test15_3), ~47 s after the start line (scenes InRaceRoot, PauseRoot, InRaceRoot); GtLogWorkContext: outside a draw,
> last one set up draw count 4 fs 0x9c23f9ea / vs 0x8167a22c. Against TEST36 r1 (at_exit_190730, same profile, also
> raced): fs 0x2a265dff compiled **1** time (39), vs 0x610d64f 1 (3); `Rejecting invalid T#` **0** (123), `S#` **0**
> (458); SurfaceFormat / Thick3DThickPrt_32 detiler / GetArrayMode lines 0. Permutation compiles 258 (270): the
> plan's "at most ~232" did not hold because r1 compiled 252 programs TEST36 r1 never reached; over the 1010 programs
> both compiled, 5 compiled 43 fewer times (fs 0x2a265dff -38) and 32 compiled 37 more in +1/+2 steps, the spread two
> runs of one build show (TEST35 r1 vs r3: +32 in 18, -35 in 10). Guardlog, ONE line each for the whole run:
> fs 0x2a265dff "7 nodes, conds F, groups g0=c0 g1=c0 g2=c0, dead 0x7; reads [50]=0x0; images #0 g0 dead #1 g1 dead
> #2 -; samplers #0 g2 dead" (the plan's prediction); fs 0x74f5f10c "21 nodes, conds ?T, dead 0x0; reads [164]=0x0
> [163]=0x1ff; images #1 g0 live?, #6-#9 live". The picture is unchanged (user ~00:44 with a run-2 photo: "exactly
> the same as before"), as it must be: a dead slot is one the draw never samples. The black road/terrain and the red
> minimap are IMAGE_PROBLEMS_MAP.md rows 1 and 3 (readbacksMode 0), parked. Run 2 started 00:41:10. PR #5196 at
> ~00:45: open, head 4697d56c, 0 comments, 0 reviews.

> **Update 1 Oct ~00:36, builder gtnikos-02: TEST39 is BUILT = TEST38 + a [test] guard-decision log; no run yet.**
> Request: the auditor's note relayed by the user (~00:28: the fix logs nothing about its decisions), and the user's
> "use the same prob[e]" = GT_BINDLOG. `test39-main-2338a06f` **0247e2e9** "[test] Log the resource-guard decisions of
> GT_BINDLOG shaders and of each image in its binding note" (3 files +168/-7): `ResourceGuards::GtEvaluate` (the
> EvaluateDead evaluation split into false/true conditions, dead and surely-reachable groups); `[GT_DIAG] guardlog`
> lines for every GT_BINDLOG shader at its first bind and whenever its decision changes (conds F/T/?, group terms, dead
> mask, the flat-buffer dwords read, each image/sampler as `-`/dead/live/live?), max 512 per shader; the image note
> during texture binding says "guard live|guard undecided|no guard|guard dead"; the image bind log is capped at 256 lines
> PER SHADER (0x74f5f10c alone filled the old shared cap). Launcher `TEST39_GT7_0247e2e9_warm_diag_console.bat`
> 70D5200F...BA4F sets `GT_BINDLOG=0x74f5f10c,0x2a265dff`. Exe `backup_exe\shadps4_test39_0247e2e9_gt7.exe`
> AE4EADE5...D472, `pdb_test39_0247e2e9` 250B32B2...A5C2. Details: `logs\test39_build_details.txt`. TEST37 r2
> (at_exit_000906) ended like r1 (SurfaceFormat, image #0 of fs 0x2a265dff; 27 compiles). Auditor notified before the
> switch (~00:33) and after the build (~00:36). The PR takes ebcfc8a2 + 9bc582bb only.

> **Update 1 Oct ~00:23, builder gtnikos-02: TEST38 is BUILT (user's go ~00:17, "do the suggested"); no run yet.**
> `test38-main-2338a06f` **9bc582bb** = TEST37 ebcfc8a2 + "vk_pipeline_cache: Skip resource guards only for shaders
> that have a patch" (4 files +19/-2): `Info::skip_resource_guards`, set in CompileModule to `IsPatchShaders() &&
> HasShaderPatch(hash, stage)` (any `<stage>_<hash>_*.spv` in `user\shader\patch`, so all permutations of a patched
> program agree); the pass no longer includes `core/emulator_settings.h`. In the GT7 profile the analysis now runs on
> every shader, for the first time. clang-format 19.1.5: 0 warnings on all 9 files of ebcfc8a2 + 9bc582bb. Build 40 s,
> NINJA_EXIT=0, 69 steps, no CMake. Exe `backup_exe\shadps4_test38_9bc582bb_gt7.exe` 16A7A96D...8690,
> `pdb_test38_9bc582bb` 33EA0628...5FB8; launcher `TEST38_GT7_9bc582bb_warm_diag_console.bat` 941E0B3F...2E40
> (`make_test38_launcher.pl`). Details: `logs\test38_build_details.txt`. Auditor notified before the switch (~00:19)
> and after the build (~00:22). main 2338a06f, #5196 unchanged (00:18). Next: TEST38 runs, audited against the
> verification table.

> **Update 1 Oct ~00:12, builder gtnikos-02: TEST37's fix is SWITCHED OFF in the GT7 profile, so its runs do not test
> it.** `FindResourceGuards` (resource_patching_pass.cpp:1524) skips the whole analysis when
> `EmulatorSettings.IsPatchShaders()` is true, and `C:\shadps4-test19-gt7\user\config.json` has `"patch_shaders": true`
> (so do all six test profiles; the code default is false). The profile's `user\shader\patch` is EMPTY, so nothing is
> patched: the setting only disables the fix. TEST37 r1 (00:04:48-00:06:57, pad OK, 116k lines) = main behaviour
> without the two dropped fixes: `Compiling fs shader 0x2a265dff` 35, `Rejecting invalid S#` 147, T# 38,
> `(permutation)` 119, and it ENDED at `liverpool_to_vk.cpp:788 SurfaceFormat: Assertion Failed!` "Unknown
> data_format=46 and num_format=0" while binding image #0 of fs 0x2a265dff (address 0x4473087e00, type 12,
> 3603x4276x8127): a guarded slot, the assert the reverted T# check used to hold off. r2 (from 00:07:40) runs the same
> exe and profile. Proposed: gate on a patch file that exists for the shader (CompileModule already looks it up), not on
> the setting; TEST38 = TEST37 + that commit. Waiting for the user.

> **Update 30 Sep ~23:57, builder gtnikos-02: TEST37 is BUILT (user's go ~23:52, "build test 37"); no run yet.**
> origin/main still 2338a06f (fetched 23:52); #5196 unchanged (open, clean, 0 comments, 0 reviews, head 4697d56c).
> `test37-main-2338a06f` **ebcfc8a2** built with `build_clean.bat -k 0`: 69 s, NINJA_EXIT=0, 117 steps, 0 warning or
> error lines, CMake did not run (version line still test29-main-e35735c2 / 106e7263); log `logs\test37_build.log`.
> Exe `backup_exe\shadps4_test37_ebcfc8a2_gt7.exe` 53280C4E...F217C, `pdb_test37_ebcfc8a2` 1FECD5BD...7099; exe strings:
> the instruments are there, the reverted T# check's `dst_sel=` format is gone. Launcher
> `TEST37_GT7_ebcfc8a2_warm_diag_console.bat` 5697579...B4A3 (`builder_scripts\make_test37_launcher.pl`: lines 2, 3, 7,
> 57, 58, 96, 103, 113, 114 differ from TEST36's). Everything, with what a run should show:
> `logs\test37_build_details.txt`. Build details sent to the auditor gtnikos-e8 (~23:56). Next: the user runs TEST37,
> the auditor arms and audits; then analyse against the verification table of the plan.

> **Update 30 Sep ~23:40, builder gtnikos-02: TEST37 is committed, NOT BUILT; the build waits for the user's go.**
> Auditor notified at ~23:12 (checkout switch). `C:\shadps4-clean` is on `test37-main-2338a06f` = 04558db8 +
> 028f3c8a (revert of 9dce3330) + 22105b66 (revert of d833bab4) + **ebcfc8a2 "shader_recompiler: Skip images and
> samplers a draw does not read"** (8 files, +1051/-15; edits grepped on disk; clang-format clean). Two changes from
> the plan, both for the lane rules: (1) no new source files, because they would make ninja re-run CMake (the rule
> is "`ninja` only, no reconfigure"), so the guard analysis runs as pass 0 of `ResourcePatchingPass` (which now takes
> the Program) and the evaluator sits in the same .cpp; (2) the evaluator covers only the measured guard shapes (bit
> tests, integer compares, float compares, float add/sub/min/max/med3/clamp/neg/abs, the NaN tests of legacy max,
> lane masks); anything else stays live. `ReplaceShader` (devtools live editing only) is left alone; shader patching
> on = no guards. BindTextures is unchanged. `info.h`/`resource.h` changes rebuild most of the recompiler and renderer.
> For the auditor's log reading: GT_BINDLOG lines of fs 0x74f5f10c disappear for any slot now judged dead.

> **Update 30 Sep ~23:10, builder gtnikos-02: the root of classes 2, 4 and 7 found by read-only research (no build,
> no run); the user approved the fix plan. TEST37 = TEST36 - 9dce3330 - d833bab4 + the fix; the build waits for the
> user's go.** The user rejected the T# check as a symptom guard. Root cause: a PS4 GPU reads a T#/S# only when an
> executed instruction uses it, while shadPS4 decodes, specializes on and binds every declared image and sampler on
> every draw, so slots behind a uniform branch the draw does not take (GT7 leaves stale data there) become images.
> fs 0x2a265dff reads fs_img0/img1/samp0 only inside `if (0u != srt_flatbuf.data[50u])`; data[50] is 0 in all 39
> cached permutations and the live fs_img2 is identical in all 39, so its 39 permutations come from garbage alone.
> Census: 469 of GT7's 1187 cached shaders (3397 slots) read images/samplers only under flat-buffer conditions; God
> of War has the same pattern; nothing upstream prunes by use. Plan, with file:line for every step:
> `logs\test37_plan_resource_guards.md`. In short: a recompiler pass between FlattenExtendedUserdata and
> ResourcePatching records, per sampled-image/sampler group, the uniform branch conditions guarding its uses; each
> draw evaluates them on the flat buffer it uploads; a group with every use behind a definitely-false condition is
> dead, and `GetSharp` returns a null image / zero S# for it at compile time, in the permutation key (which carries
> the dead set) and at bind time. Storage images stay live; the evaluator answers Unknown (= live) unless exact.
> User decisions: images + samplers only (buffers later); proof by lines the log already has (`Compiling fs shader
> 0x2a265dff` 15-58 per run -> 1, S#/T# rejections about half, no `Thick3DThickPrt_32 detiler`, no class 2/4/7);
> d833bab4 and 9dce3330 dropped in TEST37. Class 2's link is inferred (same +-1.0 garbage family; no cached meta
> holds its T#): TEST37 decides. #5196 unchanged at 23:08 (open, clean, 0 comments, 0 reviews); origin/main 2338a06f
> (fetched 23:08). Next: notice to the auditor (gtnikos-e8), branch `test37-main-2338a06f`, implement, then ask the
> user for the build.

> **Update 30 Sep ~21:05, builder gtnikos-02 (replaces gtnikos-66). State checked read-only 20:57-21:03, nothing
> changed in the code, the checkout or the runs.** origin/main still 2338a06f (fetched 20:57). #5196: CI finished,
> 10 of 10 checks success, pre-release skipped (last one done 17:53:01Z); 0 comments, 0 review comments, 0 reviews,
> mergeable clean, `updated_at` = `created_at`. #5155 unchanged (0 comments, 0 reviews, CI green, clean, head e62bfbc7).
> No shadps4 process; no TEST36 run after r1; no watcher or catcher process (they idle-stopped at 19:37); nothing armed.
> Checkout still `test36-main-2338a06f` 04558db8. `ListAgents`: gtnikos-04 is gone; the only peer is gtnikos-e8
> (started ~20:54, idle), not confirmed as the watcher/auditor; no message sent. **Class 7's line moved:** in TEST36
> (and in #5196) GetArrayMode's `UNREACHABLE_MSG("Unknown tile mode ...")` is `tiling.cpp:66`, not `:65` (04558db8 added
> a line above it); TEST36 r1's log has no `tiling.cpp` line at any number, so its count of 0 stands. Read for the T#
> check (no edit): `IsValidGpuMapping` (memory.h:208) tests only `addr + size < 1 TiB`, so the check's call with size 0
> (vk_rasterizer.cpp:1145) passes a T# at address 0; `MemoryManager::IsValidMapping` tests the address against the VMA
> map. `tiling_index` is a 5-bit field (resource.h:161) and `TileMode` has 0-26 and 31, so 27-30 reach that UNREACHABLE.
> Waiting for the user's go.

Written by the builder session `gtnikos-66` for the chat that replaces it. Read, in this order:

1. this file, all of it;
2. the RULES block at the end of `C:\GTNikos\CLAUDE.md` (binding for every session in this lane);
3. the first ~160 lines of the memory `gt7-shadps4-lane.md` (newest first; it is ~420 KB, so Read it with `limit`);
4. the memory `feedback-shadps4-comments-cleanup-later.md`, and again **before every review of a PR draft** (section 4);
5. `git -C C:\shadps4-clean show claude:CLAUDE_MEMORY.md` (the public notes branch; stale since TEST9).

The watcher/auditor role is in the memory `gt7-shadps4-auditor-handoff.md` (its current state is at the top). The
previous version of this file (d9's of 29 Sep, with the update blocks of f3 and 66 on top) is
`superseded\HANDOFF_20260930_builder_66.md`; what is not repeated here is history.

Goal: fix upstream shadPS4 bugs so Gran Turismo 7 1.71 (CUSA24767) runs, one general fix per PR. God of War
(CUSA07411) is paused (section 9).

## 1. State on 30 Sep ~20:45

- **Live PR: #5196** "video_core: Fix mip layout and detiling of tiled textures", opened by the user 30 Sep 17:36:30Z
  (20:36 local): https://github.com/shadps4-emu/shadPS4/pull/5196. Head `mine/tiled-mip-layout` **4697d56c** =
  origin/main 2338a06f + one commit, 6 files +54/-41, "allow edits by maintainers" on. At 20:40: 0 comments, 0 reviews,
  mergeable, CI 3 of 10 checks finished (all success), 7 in progress. A live PR always comes first (section 4).
- **Open, waiting: #5155** "video_core: Use each preloaded permutation's own flattened user data" (head
  `mine/preload-permutation-ud` e62bfbc7 = the fix + a GitHub "Update branch" merge of 2338a06f; 0 comments since 27 Sep;
  `git merge-tree` against 2338a06f: clean). Monitor read-only.
- **Merged** (the user's): #5070, #5126, #5131, #5114, #5150, #5169, and #5137 + #5181 (29 Sep 20:36Z). Closed without
  merge: #4996, #4999, #5132, #5135.
- **origin/main = 2338a06f** (fetched 30 Sep 19:51). Fetch again before any build or PR step.
- **Checkout `C:\shadps4-clean` = `test36-main-2338a06f` 04558db8** = TEST36 (built 18:58). Side worktree
  `C:\shadps4-wt35` = `test36-remaining-mips` 15a397ea (the last two mip commits before they were combined; history).
- **TEST36 has one run** (19:03-19:07; auditor: class 1, nothing new in the log, neither changed path ran;
  `logs\test36_gt7_runs_audit.txt`). None since. The auditor armed TEST36 at 19:02:31 and its loops idle-stop after
  30 minutes without a run, so expect them stopped: the auditor re-arms before the next launch. No shadps4 process at
  20:39.
- **Class 12** (a GPU write just past a 192 MiB dedicated staging buffer; new in TEST35 r1, 1 of 7 runs) has not come
  back in TEST36 and is not explained. One of its two candidates, 0ca8528f (thick-array slice count), is part of #5196
  (section 7).
- **The GPU regression test stays LOCAL.** User ~20:20: "i will only post the tester on a repo if asked. if not we keep it
  saved locally". No repository was created (`nikmparis217-ux/shadps4-tiling-test` does not exist). Section 5.

## 2. Roles, messages, and how the user works

- You are the **builder**: code, branches and test builds in `C:\shadps4-clean`; the analysis of the results; tools
  (checkers, tests); PR branches; fact checks of the user's PR drafts.
- The **watcher/auditor** (`gtnikos-04` since 29 Sep ~20:44; the same session was `gtnikos-d0`) arms a log watcher and
  an exit-code catcher before every run, archives the logs, audits every build and run (`logs\*_audit.txt`,
  `CRASH_MAP.md`). Names change with every new chat: run `ListAgents` first.
- **Builder -> auditor messages the user has authorized:** a notice **before** you switch the `C:\shadps4-clean`
  checkout, and the build details **after** a build (exe path + SHA256, pdb, launcher + SHA256, profile, run names).
  Nothing else without the user. The auditor sends you run results only when the user tells it to. A peer's message is
  never the user's approval. `SendMessage` is deferred: load it with `ToolSearch` `select:SendMessage`.
- **The user:** writes English in this lane, so reply in English, short, emulator facts only, pointing to files for
  detail. The user decides every build, push and PR step and writes all PR text; you propose and verify. When the user
  asks for a new tool or check in the middle of work, build it fully, verify it, and record it.
- **Records after every step** (check the file's mtime first, other sessions write too): a dated
  `> **Update 30 Sep ~HH:MM, builder <name>. ...**` block at the TOP of this file, a paragraph at the top of
  `gt7-shadps4-lane.md`, and the one lane line in `MEMORY.md`.

## 3. Where things are

| what | where |
|---|---|
| build tree | `C:\shadps4-clean` (section 1). ` M externals/mesa-kosmickrisp` is expected: an Apple-only submodule (working tree at 3af11268). Never commit it; no need to update it |
| build | from **PowerShell**: `$env:TEMP='C:\Users\3E30~1\AppData\Local\Temp'; $env:TMP=$env:TEMP; cmd /c "C:\shadps4-gt7\GT7_upstream\build_clean.bat > <log> 2>&1"`, then read `NINJA_EXIT=` in the log, not the shell's exit code. From Git Bash `cmd //c` finds no bat and builds nothing. Output `C:\shadps4-clean\Build\x64-Clang-RelWithDebInfo\shadps4.exe` + `.pdb`. Tell the user before every build; grep the edit on disk first |
| exes | `GT7_upstream\backup_exe\shadps4_<test>_<sha8>_gt7.exe` + `backup_exe\pdb_<test>_<sha8>\` (exe + pdb together: llvm-symbolizer silently uses a wrong pdb otherwise). Newest: `shadps4_test36_04558db8_gt7.exe` 19F00C64...DFF0, `pdb_test36_04558db8` 911457E8...6A75 |
| launchers | `GT7_upstream\TEST<nn>_GT7_<sha8>_warm_diag_console.bat` (121 lines, CRLF, ASCII), each made by `builder_scripts\make_test<nn>_launcher.pl` from the previous one. Newest: `TEST36_GT7_04558db8_warm_diag_console.bat` EFF3CBC4...0B12 (`make_test36_launcher.pl` changes lines 2, 3, 7, 103, 113, 114 and the test names in 57, 58, 96) |
| profile | `C:\shadps4-test19-gt7` (`user\config.json`: `sync: false`). Input cache snapshot `cache_input_warm_20260927_184409` (1520 files); save A `C:\shadps4-test4-gt7\user_warm_after_runs1to3`. Every run is cold since TEST32 (cache versions 6 vs the version-5 snapshot) |
| logs | `GT7_upstream\logs\`: `shad_log_*_at_exit_*`, `*_prelaunch_*`, `console_*`, `game_log_*`, `shots_*`, `imgdump_*`, the auditor's `*_audit.txt`, and `test<nn>_build_details.txt` |
| crash classes | `GT7_upstream\CRASH_MAP.md` (the auditor's: 12 open classes, the log lines each needs, per-test tables, suggested order) |
| helper scripts | `GT7_upstream\builder_scripts\`: `replay_onto_main.sh` (replays our stack onto a new main without touching the checkout, and checks each commit keeps its +/- lines), `make_test<nn>_launcher.pl`, `spvcmp.sh` (cache comparison) |
| tile checker, GPU test | `builder_scripts\bc_checker\` (section 5) |
| remotes | `origin` = shadps4-emu/shadPS4 (never push). `mine` = nikmparis217-ux/shadPS4, the public fork: `claude`, `gt7-v0.18.0`, `main`, `preload-permutation-ud`, `tiled-mip-layout`. Push one branch with an explicit refspec, only when the user asks. Commit identity `nikmparis217-ux <295578344+nikmparis217-ux@users.noreply.github.com>`, title only, no trailer |
| GitHub, reading | `gh` is NOT logged in. Use the public API with curl: `https://api.github.com/repos/shadps4-emu/shadPS4/pulls/5196` (field `body` = the PR text), `.../issues/5196/comments`, `.../pulls/5196/comments`, `.../pulls/5196/reviews`, `.../commits/<sha>/check-runs`; our PRs: `https://api.github.com/search/issues?q=repo:shadps4-emu/shadPS4+is:pr+author:nikmparis217-ux`. 60 requests/hour unauthenticated. Pushes go through git (Git Credential Manager has the login); set `GIT_TERMINAL_PROMPT=0` so a missing credential fails instead of hanging |
| tools | clang-format **19**: `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\Llvm\x64\bin\clang-format.exe` with `src\.clang-format` (`C:\Program Files\LLVM` is 22; upstream CI uses 19). Compiler `C:\PROGRA~1\LLVM\bin\clang-cl.exe`. GPU resets: the System log, provider `nvlddmkm` (153 = timeout, 13 = graphics exception with the ESR values). GPU: NVIDIA GeForce RTX 4070 SUPER |

What a launch does: refuses to start if an emulator runs; clears `GT_*` and sets `GT_DIAG=1` (TEST34-36 also
`GT_IMGDUMP_DIR` and `GT_BINDLOG=0x74f5f10c`); copies the previous log to `logs\shad_log_<test>_prelaunch_<TS>.txt`;
moves `user\cache` to `cache_before_launch_<TS>`; restores the input cache and save A; opens `live_log_colors.ps1` on
the console capture. The user starts every run; you never launch the emulator or the game.

## 4. PR #5196: what is in it, what backs it, how to handle its review

**What it fixes** (the user's PR text describes these five):
1. `ASSERT(!props.is_block)` in `ImageInfo::UpdateSize` (main `image_info.cpp:184`; in our logs
   `image_info.cpp:184 lambda: Assertion Failed!`) stopped the emulator for block-compressed images in macro-tiled
   modes. GT7's BC7 1024x1024 tile-mode-16 texture hit it (test20a_8 and older).
2. Mips smaller than a macro tile: the size code dropped them to 1D (hidden inside `ImageSizeMacroTiled`, next to
   `// TODO: threshold check` at main `tile.h:338`), but `tiling.comp` decoded every mip with the macro formula. On
   GT7's texture mips 3-5 came out 1008/1024, 240/256 and 48/64 blocks wrong, part of each read from past the image's end.
3. Thick arrays padded each layer to the tile thickness instead of the total slice count once.
4. Tile mode 18 mapped to `Array3DTiledThin1` instead of `ArrayPrt3DTiledThin1` (the PS4's GB_TILE_MODE18 =
   0x9240032C = array mode 11).
5. 128-bit texels in display micro tiles used the old element order; SI/CI force the thin order ("128 bpp/thick
   tiling must be non-displayable", `SiLib::HwlSetupTileInfo`; Sony's library via GPCS4 has no 128 bpp display tiler).

**Per file:** `tile.h` `IsMacroTiledMip` (mip 0 stays macro, as addrlib, which calls
`EgBasedLib::ComputeSurfaceMipLevelTileMode` only for mipLevel > 0; a later mip stays macro only while its pitch and
height are at least one macro tile) and `ImageSizeMacroTiled` without the hidden downgrade; `image_info.cpp/.h`
`micro_tiled_mips` bitmask, slice count padded once, the assert gone; `tile_manager.cpp` passes the bitmask in
`TilingInfo`; `tiling.comp` micro formula with its own thickness (`min(thickness, 4)`) for each 1D mip, thin order for
128-bit display tiles; `tiling.cpp` tile mode 18.

**Deliberately not in it** (a reviewer may ask; the PR text says the extra rule "never fires with the PS4 tables"):
- AMD's extra thin-mode rule (pipe interleave > threshold1 or threshold2): it depends only on the tile mode, the
  element size and the sample count, never on the texture's size, and fires in 0 of the 440 combinations of the
  standard and Neo tables (`bc_checker\pr_evidence\thresh.exe`). The PR deletes main's `// TODO: threshold check`.
- Thick -> thin when a texture has fewer slices than the tile thickness: `CiLib::HwlDegradeThickTileMode` returns the
  mode unchanged on CI.
- The Neo-only alternative pipe setting, the one other difference from our tables among the 31 GB_TILE_MODE values.

**Evidence** (all local; section 5 for the files):
- CPU checker against addrlib, the same 333 cases throughout: fully matching 0 (main's code) -> 216 -> 252 -> 257 ->
  270 -> 298 -> 303 -> 333 as each part went in (`run5_current_hawaii.txt` ... `run14_t36_both_hawaii.txt`).
- GPU regression test (the shipped code on the GPU against addrlib: 387 cases, 4019 mips, 525,749,259 texels, both T#
  pitch setups): the fix 0 wrong; main 342 of 387 cases wrong, 73 of them ASSERT in UpdateSize, layout wrong in 2647
  mips, detiler in 1758, tiler in 2082 / 2070 (`logs\tiling_gpu_regression.txt`).
- In the game: the TEST34 dumps of the 16 BC7 textures (clean with the fix, 52 mips wrong under main's formula;
  `logs\test34_dumpcheck\`), the TEST35 bindlog (the Buddy shader's image 4 = dump 00), TEST36 r1 with no regression.
  GT7 (96 runs) and GoW (7 logs) never use tile mode 18 or a 128-bit display detiler.

**The PR text is the user's** (it names GT7 and quotes the numbers above). Read the current `body` through the API
before answering anything about it.

**When the PR gets a review comment or a CI failure:**
- Tell the user what was asked or what failed, with the facts (the code lines, the measurement, the CI log line). Never
  write on the upstream repo: no comments, replies, or title/description edits. The user replies, using your
  explanation as they choose.
- A code change is a new local commit, tested per the rules (TEST37 = TEST36 + that commit; rerun the checker and the
  GPU test if it touches tiling or sizes). Push to `mine/tiled-mip-layout` only when the user says so. Before that push,
  say in one line that the PR changes the moment it lands and that a force-push replaces its history; keep one commit
  (`--force-with-lease=refs/heads/tiled-mip-layout:<old head>`) unless the user wants otherwise.
- Fetch `origin/main` first; if it moved, `git merge-tree` the PR head against it.

**Reviewing the user's PR drafts** (they show a screenshot): re-read `feedback-shadps4-comments-cleanup-later.md` first.
Report only wrong facts, what a reviewer needs and cannot find, and typos. Keep it short. Give no instructions and no
ready-made sentences unless the user asks "what should I say". Never comment on the AI rule or on the user's own
disclosure line. Check every number against its source file before you answer (in this PR "1758" is the detiler's
count of mips, "2647" the layout's).

## 5. The tile checker and the GPU regression test (local)

In `C:\shadps4-gt7\GT7_upstream\builder_scripts\bc_checker\`:
- **CPU checker** `bc_checker.cpp`, `build.bat` (and `build18*.bat`): AMD addrlib from
  `externals/mesa-kosmickrisp/externals/mesa/src/amd/addrlib` (Sea Islands, the PS4's GB_ADDR_CONFIG, Hawaii
  revision, `allowLargeThickTile`) against the emulator's own tables and a port of `UpdateSize`, per mip and per texel.
  Run `bc_checker.exe -nobase -hawaii`. `bc_checker_pre_*.cpp` are old copies.
- **GPU test** `tiling_gpu_test.cpp` + `build_gpu_test.bat`: links the build's own `image_info.cpp.obj` and
  `tiling.cpp.obj` and the tiling SPIR-V headers the exe embeds, runs the detiler and the tiler on the GPU with
  `GetTilingPipeline`'s specialization constants, and checks every texel against addrlib. `tiling_gpu_test.exe` exit
  0 = all correct, ~135 s. **Run it only when no shadps4 runs** (PowerShell `Get-Process shadps4`).
  `build_gpu_test_main.bat` builds the same test against origin/main's code (`main_src\`, `main_src\SOURCE.txt`,
  `-DGT_TEST_MAIN_CODE`). Results `gpu_fixed_t36.txt`, `gpu_main_2338a06f.txt`; write-up `logs\tiling_gpu_regression.txt`.
- **`pr_evidence\`** (README.txt): `thresh.cpp`, `thresh.exe`, `buildthresh.bat` (0 of 440; rerun there 30 Sep:
  "threshold fires in 0 (alt tables: 0)"), `tiletable_cmp.py` + the GPCS4 sources (the 31 register values; the
  script's tiling paths point at `C:\shadps4-wt35`).
- **If a reviewer asks for the tester and the user agrees to publish it** (a new public repo on the user's account,
  which the user creates EMPTY in the browser; you push): clean it first. Licence GPL-2.0-or-later (it holds a copy of
  shadPS4's UpdateSize and builds against its source; addrlib is MIT and is compiled from the checkout, not copied).
  Remove the ~10 lines naming the game, our test labels, the `GT_TEST_MAIN_CODE` name and the Sony reference, plus the
  `-dump`/`-synth` mode (it reads dumps of our private `GT_IMGDUMP_DIR` instrument). One build script with the shadPS4
  checkout and build folder as settings; a README with the results. Rebuild and rerun against main and the fix, and
  push only if the numbers match.

## 6. The test line

| test | branch, commit | change | runs (auditor) |
|---|---|---|---|
| TEST33 | `test33-mip-tile-mode` 34e1d0da | the per-mip 1D layout | r1-r4: classes 2, 1, 2, 5 |
| TEST34 | `test34-imgdump` 76a35aac | + [test] `GT_IMGDUMP_DIR` | r1-r5: classes 2, 3, 4, 4, 6; the same 16 dumps in every run |
| TEST35 | `test35-main-2338a06f` 91ffbea6 | the stack replayed onto main 2338a06f, + thick slices, + [test] `GT_BINDLOG` | r1-r7: classes 12 (new), 2, 3, 2, 2, 1, 6 |
| **TEST36** | **`test36-main-2338a06f` 04558db8** | + tile mode 18 PRT and the 128-bit display thin order | r1: class 1, nothing new |

**TEST36** = origin/main 2338a06f + (oldest first): dc63ce6b BC allowed in macro-tiled modes (#5196) - 5ece2f75
Preload (= #5155) - d833bab4 T# format/swizzle check (local) - 6f358a7f, 52a43146, 20a20093, 0a34a472 [test] `GT_DIAG`
- 9dce3330 SnormNz returns no conversion (local) - 5f991d66 per-mip 1D (#5196) - 5a866c96 [test] `GT_IMGDUMP_DIR` -
0ca8528f thick slices (#5196) - 91ffbea6 [test] `GT_BINDLOG` - 04558db8 tile mode 18 + 128-bit display (#5196). The four
#5196 commits together have the PR's patch-id.

Next test: TEST37 = TEST36 + one commit. If main moved, replay the stack onto it with `replay_onto_main.sh` first (the
user's rule: the run build is current main plus every fix of ours, open PRs included). Tell the user before building,
and the auditor before the checkout switch and after the build.

## 7. Open crash classes and what comes next

`CRASH_MAP.md` has all 12 and the log lines each one needs. Endings on this line: 1 (a GPU fault writing to address 0;
a copy of 8 source layers into 48 destination layers comes 1-2 frames before it in every report), 2 (a GPU fault in a
64 KiB hole between two 8 MiB blocks; a zero-size track or untrack at 0x3f80000000 comes 0.05-0.10 s before it in 17 of
17 logs), 3 (PM4 type 0), 4 (Protect address 0), 5, 6 and 11 (game-thread crashes), 12 (the staging overrun).

**Class 12 watch:** if it recurs in TEST36, add a `[test]` line for every dedicated staging request: the requested
size, the buffer size, and what the ref is used for (the image or buffer, the copy regions with their offsets and
extents), as CRASH_MAP #12 asks. Read so far: every readback and tile copy fits its request under the new layout;
upstream #4816 (an open RFC) describes the same kind of fault.

**Order of work** (the RULES block):
1. #5196's review, whenever something comes.
2. TEST36 runs: the user launches, the auditor arms and audits.
3. Finish our local fixes before starting a new one:
   - the T# check (d833bab4): `IsValidGpuMapping` only tests < 1 TiB, so a T# at address 0 still gets an image and page
     tracking (maybe class 4), and the check does not test the tiling index (class 7: tiling index 29 read from float
     data in image #1 of fs 0x2a265dff);
   - SnormNz (9dce3330): the code is complete; no run has reached that draw since test25_gt7_4.

   Each needs the log line that proves it.
4. Then the next problem, in CRASH_MAP's suggested order: #2 (one log line at `TrackImage` / `UntrackImageTail` naming
   the zero-size image at 0x3f80000000), #4, #1, #7, then #3, #5, #6, #11, and #12.

## 8. Traps that cost time

- **`user\cache` moves at every launch**, to `cache_before_launch_<TS of the NEXT launch>`. Read the right folder.
- **Cache versions track only the format**, so a warm cache keeps old SPIR-V. Compare caches with
  `builder_scripts\spvcmp.sh`: pair blobs per shader hash by their set of SHA256s, ignore the `_<n>` index, count only
  blobs that are not in the input snapshot (fs 0x2a265dff differs between two runs of the same exe: noise).
- **With `sync: false` a missing Critical line proves nothing**: judge how a run ended from the exit code, the file
  times and the console capture.
- **A `CMakeLists.txt` change makes ninja re-run CMake** and can rebuild everything (TEST29: 2381 steps, ~13 min).
- **`git cherry` (patch-id) calls our copies of merged PRs "not in main"** when only the context differs: compare the
  +/- lines (`replay_onto_main.sh` prints this for each commit).
- **A single-commit PR's squash merge takes the COMMIT's title**, not the PR title.
- **Git Bash:** `/FI`-style flags turn into paths (use PowerShell for `Get-Process` and `Win32_Process`); write scripts
  with the Write tool, never inline Python or quoted heredocs with backslashes (a replacement silently did not land in
  this session); CR counts lie, use `git ls-files --eol`.
- **Shared report files can be rewritten by the other session**: read exit codes too.
- **The session scratchpad is temporary.** Anything that backs a claim in a PR or a handoff belongs under
  `GT7_upstream\builder_scripts\` or `logs\` (the 0-of-440 program lived only in the scratchpad until 30 Sep ~20:28).
- **The build has no `compile_commands.json`**: take the flags from `build.ninja` and `CMakeFiles\rules.ninja`. Its
  objects are COFF (no LTO), so a test can link the build's `.obj` files directly; unrelated unresolved symbols ->
  `/FORCE:UNRESOLVED`.
- **Emulator against addrlib: give both the same pitch.** A T# written by the game's library carries the aligned
  level-0 pitch, and on SI/CI addrlib derives the mip pitches from the base pitch (`SiLib::HwlComputeMipLevel`).
  Pitch = width for the emulator with a base pitch for addrlib produced 8 false BC1 256x1024 failures.

## 9. God of War (paused) and the rest

- GoW: three local branches with one commit each, not pushed: `tg-size-sgpr`, `ds-ordered-count`, `tsharp-dw1-mask`
  (memory `gow-fixes-for-pr.md`). None is in the GT7 test line. Since 1 Oct 16:13 GoW TEST1 1c6cff84 carries
  cherry-picks of all three (`C:\shadps4-gow\README.md`); GoT and GTA V TEST1 (7d09a8a8) do not.
- GT7 image problems are parked until the crashes are under control: `IMAGE_PROBLEMS_MAP.md`.
- Other worktrees: `C:\Users\Νίκος\Documents\GitHub\shadPS4` (`gt7-v0.18.0`, the old line), `C:\shadps4-gt7`
  (`gt7-main`; `GT7_upstream\` lives inside it), `C:\shadps4-pr5126` (prunable), and **`C:\shadps4-archive\shadps4-sync`
  (moved from `C:\shadps4-sync` on 1 Oct at the user's request): never touch its contents**.

## 10. Memory files (auto-memory; the index is loaded at start)

- `gt7-shadps4-lane.md`: the lane's state, newest first. `gt7-shadps4-auditor-handoff.md`: the auditor's role; its
  current state is at the top.
- PR text and draft reviews: `feedback-shadps4-comments-cleanup-later.md` (read before every review).
- The workflow: `feedback-lane-rules-in-claude-md.md`, `feedback-shadps4-pr-quality-method.md`,
  `feedback-shadps4-run-base-main-plus-fixes.md`, `feedback-shadps4-test-first-incremental.md`,
  `feedback-check-existing-branches-first.md`, `feedback-shadps4-general-fixes-final-build.md`,
  `feedback-shadps4-cpp-only.md`, `feedback-instrument-reads-like-the-emulator.md`,
  `feedback-verify-edit-on-disk-before-build.md`, `feedback-build-can-overlap-next-run.md`,
  `feedback-never-edit-a-running-script.md`, `feedback-arm-only-current-test.md`,
  `feedback-async-log-loses-the-crash-line.md`, `feedback-debugger-perturbs-fps.md`,
  `feedback-isa-fix-needs-a-game-that-uses-it.md`, `shadps4-upstream-no-shader-dumps.md`.
- `gow-fixes-for-pr.md`, `gt7-image-problems-map.md`, `shadps4-claude-notes-branch.md`, `greek-username-breaks-build-toolchains.md`.
