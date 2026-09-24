# Claude's working memory for the shadPS4 / GT7 lane

This branch (`claude` on the fork, remote `mine`) is Claude's own notebook for this lane. The
user set it up on 23 Sep 2026: "this is your personal branch for anything you need to remember
for next sessions, old fixes, old mistakes to not repeat". It holds notes only, no source, and it
is an orphan history unrelated to `gt7-main`.

- **Read this file first** in any new session on `C:\shadps4-gt7`:
  `git -C /c/shadps4-gt7 show claude:CLAUDE_MEMORY.md`.
- The detail behind every line here lives in the other files on this branch (`GT7_upstream/README.md`
  = the state on 22 Sep, `GT7_work/HANDOFF_RENDERING_ACT3.md` = the long run history).
- **Append, do not rewrite.** When a lesson, a proven fix, or a refuted hypothesis appears, add it
  here and commit on top of `claude` (recipe at the end). Correct a wrong entry by marking it wrong
  and saying why, rather than deleting it, so it does not get re-derived.
- The fork is **public**. The user chose this knowingly. Push to `mine` only, never to `origin`
  (shadps4-emu upstream). Another session (the 1.71 / offline chat) also commits here: fetch
  first and build on the current tip.

---

## 1. Standing rules (the user's, not negotiable)

- Reply to the user in **Greek**; everything written into the repo in **English**.
- **Never launch the emulator or the game.** The user starts and closes every run. Claude
  prepares the wrapper bat, arms a watcher, and reads the log.
- **Archive `%APPDATA%\shadPS4\log\shad_log.txt` into `GT7_upstream/logs/` before every launch and
  the moment a run exits, before any analysis.** The emulator truncates that one file on start,
  and another chat shares it.
- Never build or commit in `C:\shadps4-sync`. Never edit `GT7_work/GOW_probe*.bat` or
  `GT7_work/psn_local/server_log.txt`. `gt7-v0.18.0` is reference only.
- Build with `GT7_upstream\build.bat` and read **`NINJA_EXIT`**, not the shell exit code.
- Use the 8.3 path `C:\Users\3E30~1\...` for any toolchain. The Greek username breaks CMake/MSVC.
- **One variable per run**, through a wrapper bat that `call`s the unchanged previous probe. Run
  numbers continue the global series (last used: 356, built 24 Sep, not yet run).
- **Strictly one problem at a time.** When the user said "no. we strictly fix one problem", that
  meant: do not propose side investigations while a target is open.
- A fix enters only when the **PS4 semantics are explained and the emulator is shown wrong**.
  Root cause, not symptom. "The game gets further" is not a fix.
- **One general fix per PR branch.** PR-ready means: no comments narrating the investigation, no
  `GT_*` gate, no game named in the code, no shader-hash or address special case, and **no
  Co-Authored-By or "generated with" trailer anywhere** ("they dont want ai"). The shadPS4
  CONTRIBUTING rules also say AI use must be disclosed and PR text must be human-written: Claude
  supplies factual notes, the user writes the prose.
- Instruments live in C++ behind `GT_*` env vars and stay in our tree; they are stripped from PR
  branches. Emulator tooling is never python/ps1 (ad-hoc log greps in the chat are fine).
- Report under **ROOT CAUSE / EVIDENCE / CHANGE / VALIDATION / REMAINING ISSUE / DIFF REVIEW**,
  with MEASURED, SOURCE and INFERENCE kept apart.
- Investigation constraints the user states for a target are binding for that target. Current
  examples: "Do not patch/suppress the error. Do not add fallback behavior. We want the first
  invalid state that causes it." and, for the texture-cache work, "Do not change TextureCache
  behavior. Do not prevent FreeImage. Do not change MipOf/SliceOf. Do not suppress
  SanitizeCopyLayers."
- When the user specifies an instrument's report layout, build exactly that. A broader patch
  than asked was rejected once (run 353's first draft); do not repeat it.

---

## 2. Mistakes already made. Do not repeat them.

Each line is an incident that cost a run, a build, or the user's time.

1. **Analysed before archiving the log** (run 336, 18 Sep). The next launch truncated a 117 MB log,
   the only OFF control. First tool call after "closed/crashed" is the `cp`.
2. **Two variables changed between a good and a bad run, and only one was blamed** (309 vs 310:
   warm pipeline cache AND the fence-order commit 4720205e). Four runs were spent on the cache.
   Before writing "X causes Y" from two runs, tabulate every difference: build, env, cache state
   (`Preloaded N` line), game data, dump version (`Game id` line), route.
3. **A fatal detector killed the run it was meant to observe** (311a, 16 s after boot). It counted
   `CHAIN=1` indirect buffers as nesting; the bit field was one line below the one being read. New
   instruments that can stop a run ship log-only first; read every bit field of a packet before
   defining "impossible".
4. **A verifier used its own rule instead of the runtime's** (312: 230 "spec DIFF" modules with
   identical SPIR-V). The emulator's `operator==` is deliberately asymmetric. Copy the deciding
   line of code into the instrument, and ask "which output byte changes if this is true?"
5. **Magnitude was never compared with the symptom** (GoW run 020). A proven race of 0.1065 was
   credited with black blobs that need ~0.4, and no probe even sampled a blob.
6. **Read log-line counts as frequencies.** Budgeted lines (`[softclamp]` 32/64, the logger itself
   dropping ~95% of `SanitizeCopyLayers` warnings) lie. Use the counters (`[fprof]`,
   `[copylayers] #N`).
7. **Edited a shell script while a background job was executing it.** Bash reads by byte offset,
   so the running copy died. Write a new file under a new name.
8. **Built without verifying the edit reached disk.** A broken heredoc plus `a && b || build` ran a
   no-op build, and a whole run was judged on a binary without the fix. Write edit scripts with the
   Write tool, grep the new text on disk, and make the build conditional on the edit.
9. **Heredocs with quotes break in the Bash tool.** Any script longer than 3 lines, or containing
   quotes, is written to the scratchpad with Write and then run.
10. **PowerShell 5.1 `Get-Content`/`Set-Content` corrupts UTF-8 on the READ** (CP1253). Use the Edit
    tool, or .NET with UTF8 on both ends. Several repo files are CRLF (e.g. `liverpool_to_vk.*`);
    normalise, patch, restore, and check.
11. **Git Bash rewrites `/FI`-style flags into paths.** `tasklist /FI ...` fails silently and
    `| grep -c` then reports 0, which reads as "process not running". Use `Get-Process`, and confirm
    a negative with a second signal.
12. **"Intermittent" was written as "random/race"** (340). The user rejected it: a state-dependent
    bug looks identical. If it does not reproduce, follow the one captured submission upstream, or
    run the cross-game matrix (GT7 / GoW 2018 / Ghost of Tsushima). Do not keep squeezing GT7.
13. **A monitor's silence meant two things** (340). The GPU stopped while netctl spam kept the log
    growing. Name every quiet state: `GUEST FRAME HEARTBEAT STOPPED` (no SubmitFlip) is not
    `GPU TIMELINE STOPPED` (only `[gpuwait]` plus a frozen fresh driver tick).
14. **A guard read one half of a packed field that is written 16 bits at a time**
    (`SetFlags<u16>` leaves the upper half stale). The first "fix" nulled a real image. Grep every
    reader of a packed field, and fix the WRITE before trusting a bit.
15. **Called a zero a bug without reading the model** (GoW: `CompositeExtract(ballot, 1) == 0`).
    shadPS4 models a guest wave64 as one 32-lane subgroup, so the zero is correct. Before calling
    something wrong, find the other places that share the assumption.
16. **A metric derived from speed "explained" why the speed was zero** (the same shape appears in
    any ratio). Read how a number is computed before building on it.
17. **Blamed the merge for a new dump's crash** (1.71's `5_6_5+Ubint`). Read the log's `Game id` and
    `App Version` before judging any log. Two dumps share the `CUSA24~*` 8.3 aliases; select with
    `GT_GAME=<full path>\eboot.bin`.
18. **A scripted merge left 9 compile errors over 3 builds** (b1cd966e). After the scripted conflict
    resolution, census the old identifiers across the whole tree (`->member` as well as `.member`),
    check duplicates in auto-merged files, and run the first build with `ninja -k 0`.
19. **Trusted `last_crumb.txt` "DIED"**. `DeathCrumb::Finish(true)` is not reached on a normal exit,
    and the crumb records the render thread's phase, not the crashing thread's.
20. **An arming-free null result** (351). A run whose instrument never fires proves nothing until
    the log shows the instrument was armed. Every observer now prints one `... observer ARMED
    (GT_X=...)` line at start.
21. **A one-shot trigger would have fired on the wrong object** (353 draft, caught before the run).
    A donor at 0x100b170000 is freed inside the same range before the canonical image, so the trigger
    was narrowed to `levels > 1 && layers > 1`. Before arming a one-shot, list every object that
    could match first.
22. **Assumed OLD cells held last frame's data** for a freshly created image. A new image has no last
    frame; OLD there means uninitialised.
23. **Proposed a live-memory search for the 1.71 index key.** The safety system stopped it twice
    (21 Sep). Never propose or rebuild it again, in any wording. If a dump cannot be read, stay on
    1.00 and tell the user.
24. **`sleep` in the foreground Bash tool is blocked.** Check immediately, or use a background
    watcher with notification.
25. **`C:\shadps4-gt7\.git` is a pointer file** (linked worktree of `Documents\GitHub\shadPS4`), so a
    temp index under `.git/` fails. Put it in the scratchpad. `git status` with a stale
    `GIT_INDEX_FILE` shows everything as `D`/`??`, which is an artifact and not damage.
26. **Read an unmarked cell as "not counted", not "not written"** (352b, corrected by 354). The
    `[cubetrace]` grid had no mark for render-target writes through a subresource view or for
    in-place storage writes, so its "66 OLD cells" were cells the GPU had written that frame.
    Before a grid can say "never written", list every mechanism that writes the resource and
    check that each one has a mark.
27. **A write hook on `MarkGpuWritten` is blind to storage writes into separate images.**
    `ResetBindings` calls it only for `is_target || force_general`; a compute dispatch that writes
    a separate storage image sets neither. In 354 the 48 donors show "0 GPU writes before the
    copy" although each was bound as storage by the mip-generation dispatch. The BIND row is the
    evidence of the write, not the WRITE row.
28. **Remembering only the last bound view of an image under-marks multi-mip dispatches.** GT7's
    mip generation binds 2 mips (1+2) or 6 mips (3..8) of the same image per dispatch, so the
    victim grid marked only mip 2 and mip 8 as W and left mips 1 and 3-7 showing an older G. Record
    every bound view of the dispatch, not a per-image last view.
29. **A `grep -q $'\r'` line-ending check in the Bash tool reported LF for CRLF files** (run 355
    build). `texture_cache.cpp`, `texture_cache.h` and `image.cpp` ARE CRLF; the Edit tool keeps
    CRLF, but a python patch with `\n` anchors matches nothing. Count bytes instead
    (`b.count(b'\r\n')` in python, or `file x`), and patch scripts normalise to LF, patch, restore.
30. **`#include <vk_mem_alloc.h>` must come AFTER the project headers** (after
    `vk_instance.h`/`vk_scheduler.h`), exactly as `image.cpp` does. Placed among the system includes
    it pulls in plain vulkan.h without the project's platform/beta defines, and vulkan_enums.hpp
    fails with 20 "undeclared identifier ..._AMDX / _NV" errors that look unrelated to the edit.
31. **Run 355's `[cubegpu]` compared each capture with the previous capture of ANY shape.** From
    the post-race phase on, GT7 builds THREE cubes at 0x100b1b0000 per frame: q1 256x256 m9, and on
    q0 a 64x64 m7 / 128x128 m8 that alternate frame by frame. Every comparison then read "NOT
    comparable (different size)" and no per-cell line was printed for 110 s of the run. Compare with
    the previous capture of the same (queue, levels, width) key.
32. **A per-cell detail budget (64 cycles) was spent in the first 8 s of the race**, where every
    frame changes 36-54 cells because the camera moves, and the later static-scene changes (1-3
    cells) got only a grid line with no texel counts. Budget the big changes and always detail
    the small ones - in a static scene the small change is the finding.
33. **`rax = 0xDEADBEEF54321ABC` in a guest crash is shadPS4's own `__stack_chk_guard`**
    (`kernel.cpp:45`, the stack canary a prologue loads into rax), not a poison pointer.

34. **Crash D: never disassemble, inspect or instrument `eboot.bin`.** The first answer to the
    RUN 356 spec (24 Sep) was stopped by a safety check while it headed into the guest's own code.
    The user then limited crash D to the shadPS4 side: our HLE code, our logs, our state. Do not
    propose guest-code tracing for it again in any wording.
35. **The archived logs cannot show font handles or return codes.** `Lib.Font` runs at `info`
    (config.json filter `*:info ...`) and every parameter line in font.cpp is `LOG_DEBUG`. And 12
    of the 48 font functions GT7 imports log nothing at info - among them
    `sceFontGetCharGlyphMetrics`, `sceFontGetKerning`, `sceFontDestroyRenderer`,
    `sceFontMemoryTerm`, `sceFontCharacterRefersTextNext` - so the call order read off the log is
    incomplete.
    The only thing the log proves is failure: every error path of the audited calls logs at error.

---

## 3. Fixes that are proven and must stay

| commit | what | evidence |
|---|---|---|
| `65b03b2f` (branch `pr-lds-stream-commit`, worktree `C:\shadps4-pr-lds`, on upstream `37cacc59`, **unpushed**) | `lds_buffer.Commit();` after the memset in `BindBuffers`' `SharedMemory` branch. `StreamBuffer::Map` without `Commit` left the emulated-LDS region unreserved, and the next small stream copy landed inside it, so the LDS dispatch overwrote it on the GPU. | 345: 2 corrupt indirect-arg tables in 56k plus device lost. After the fix, 264,551 tables with 0 events (346-349), 77,519 of them with the diagnostic barrier off. All 4 events hit records 1/17, which is exactly the predicted `A+16 mod 64` overlap. Still pending before the PR: a Vulkan validation run, GoW/GoT regression. |
| `4720205e` | Deferred EOP/EOS/ReleaseMem fences complete in order (`FenceWaitTick`). | 309: >3000 `[fenceorder]` and a type-0 death. 310: 0, and Single Race setup survived for the first time. The user said to leave it untouched. |
| `387baa06` | `MappedPrefixAt` returns `it->upper() - addr`. It had required the mapping to *start* at the descriptor base. | This was our own bug: it null-bound 22026 of 22026 tail descriptors per 2 s window. |
| `1cba6562` | GoW: flags-0 ReadConst goes to read_const_dynamic always, plus selective per-shader DMA. | This replaced "turn DMA on for this game" and is the model for a general fix. |
| `e991e369` | On a guest wild jump, log the 24 bytes ending at the innermost return address (the `call` instruction itself). | This is general and ungated. |
| `2b7cf784` | `abandon()` fix for the PushUd crash that our own instrument introduced. | — |
| `SetFlags<u32>` for the SRT window flags | Write the whole packed field, then guard on the bit. | Run 050. |

Earlier upstream-style branches: `pr-general-fixes` (6 fixes) and `pr-descriptor-dword-mask`.

---

## 4. Hypotheses refuted. Do not retry them.

- A warm pipeline cache causes the lost UI text. Refuted: 315 had no preload and lost the text
  progressively, and `GT_INFO_PERM0` (314) changed nothing.
- The priority runner starves on a stale `KnownGpuTick`. Refuted: `MasterSemaphore::Wait` blocks on
  a real `waitSemaphores`. What stays suspect is the single strict-FIFO `PriorityPendingOpsThread`.
- "54 nested IndirectBuffers = garbage". Wrong: these are chained IBs (`CHAIN=1`), implemented
  recursively.
- 230 cache modules differ (312). Wrong: identical SPIR-V, and the instrument used the wrong rule.
- The "black polygon" is missing barriers. It is flat grey untextured geometry (measured in the
  pixels). There were 0 T# null-binds and 0 shader stubs in those runs.
- The GT7 stall is a shader loop. The chain producer CS -> RAM -> stream -> draw was intact; the
  corruption was the LDS overlap above.
- **Texture-cache target (351-353):** the "half-built cube" theory is dead. All 48 donor copies
  precede the first consumer return (352b). An out-of-range SliceOf layer write is refuted: the max
  destination layer is 5 of 8. The killer is not one of the 48 donors (353).
- Bc6+Ubint comes from a V# or a color buffer. Impossible: only a T# has room for dfmt 40 / nfmt 12.

---

## 5. Open targets, with their exact state (23 Sep 2026)

**A. Visual mutation in a static paused replay (the current target).** Shadows and textures
change every frame. The recurring error is `SanitizeCopyLayers` at ~48 per frame (true rate from
the `[copylayers] #N` counter) on the canonical image at **0x100b1b0000**: 256x256, 9 mips, 8 layers
(6 real plus 2 pow2 padding), B10G11R11, array_mode 2, tile 13, pitch 256. It is not stable: it is
rebuilt from 48 donors every frame and then **freed by `ResolveOverlapImpl`'s right-overlap
"chance overlap" branch**, so its uid changes each frame. Frames 2052/2053 served it 239/250 times
with only the 6 mip0 cells written.
Run 353 (`GT_CUBEKILL`) identified the killer: a **RenderTarget 960x540 R16G16Sfloat at
0x100b200000 + 0x240000**, tile 14, array_mode 4, pitch 1024. `IsCompatible` is 1 (both are 32-bit).
MipOf returns -1 at the `array_mode 4 vs 2` gate; mip0 is also not slice-aligned (0x50000 % 0x40000)
and has no pitch match. SliceOf is never reached. `safe_to_delete` is 1 (86 ticks > 32). The killer
is not in the donor family and is not a mip0 face; 0x100b440000 is the RT's end.
**Verdict: decision-tree branch 3.** This is a legal alias of a genuinely different resource, so
MipOf is right. What remains unproven is whether the texture cache's single-owner eviction is
wrong here. The emulator is wrong only if the cube and the RT are **alive at the same time**
(`cube ... RT ... cube` within one frame); eviction is correct if they are sequential
(`cube cube | RT RT`).
**Next step, awaiting the user's go:** run 354 with an instrument that answers exactly that
ordering question. Do not build it without the user's approval.

**RUN 354 RESULT (23 Sep; `GT_CUBELIFE`, log `logs/shad_log_run354_2026-09-23_cubelife_b1cd966e.txt`,
window frames 4299..4302, 2973 rows, 0 suppressed). Verdict: CASE B.**
- The cube's WHOLE range [0x100b1b0000, 0x100b45c000) is reused every cycle by four contiguous
  post-process render targets: 48x1080 RG16F @0x100b170000, 48x27 RG16F @0x100b1f8000, 960x540
  RG16F @0x100b200000 (the killer), 960x540 RGBA16F @0x100b440000. This is PS4 transient-memory
  aliasing, so on PS4 the cube cannot survive the cycle either, and the game rebuilds it completely
  every cycle.
- Healthy regime (frames 4299-4300, canonical uid 0x9f alive since frame 3778): the game writes the
  canonical IN PLACE. mip0 faces come from 209 render-target draws through a subresource view;
  cs 0x2673a048 reads face N of mip0 and writes mips 1-2 of layer N, and cs 0xc28178a3 reads mip 2
  and writes mips 3-8. Consumers cs 0x7c3468f9 / 0x7fbc7859 / 0xda05e7f8 sample view mip 0+9 layer
  0+6 (11x per cycle); fs 0x698cf958 samples each face of mip0.
- From frame 4300 on, every cycle runs: last use of the cube -> the RT request finds
  `safe_to_delete` = 1 -> FREE (3 of 3 decisions FREE, 0 KEEP) -> the 4 aliases are created, each
  GUEST-uploaded and written once -> the next cycle's face and mip requests kill the aliases as
  chance overlaps -> a 256x256x6 face array plus 48 single-mip donors are created, each
  GUEST-uploaded and then GPU-written (169-170 RT draws for the faces; a storage bind by the
  mip-generation dispatch for every donor) -> the canonical is recreated by ExpandImage (GUEST all
  9 mips x 8 layers "from cached", then SRC face array -> mip0 layers 0-5, then 48 DONOR ->
  mips 1-8 layers 0-5) -> 11 uses -> FREE.
- At the first use of each recreated canonical (0x495, 0x4e5): 0 of 72 cells were never written.
  All 54 real cells hold this cycle's GPU output (S 6 + D 48). The 18 cells of layers 6-7 (pow2
  padding) hold GUEST bytes and are never sampled (the consumer view is layer 0+6).
- Case C is excluded: no use of a canonical after an alias bind or write, and each canonical's
  last-use tick (34107 / 34242 / 34404) was already known complete (done 34160 / 34324 / 34445)
  when the alias was requested.
- The Case D mechanism exists but its effect is confined to the padding. The guest hash of the
  overlap is 1413d82a92a10bf1 at every alias create, every first write and every cube upload across
  3 cycles, so no GPU write of either image ever reaches guest memory (0 downloads: the RTs are
  tiled). Only the 18 padding cells, 4 of which lie in the overlap, keep those bytes.
- So the 48 `SanitizeCopyLayers` warnings per frame are the per-cycle rebuild, and the copy itself
  is correct (1 donor layer into 1 slice). The cube eviction is NOT shown to cause the visual
  mutation. What 354 cannot see is GPU CONTENT: whether the rebuilt cube's bytes are identical from
  cycle to cycle in a static scene. Proposed next step (not built, awaiting the user): a per-cell
  GPU content hash of the canonical at its first use over 3-4 cycles.

**RUN 355 (built 23 Sep 23:22, `GT_CUBEGPU=0x100b1b0000`, wrapper `GT7_probe355_cubegpu.bat` = 354 +
that one variable; awaiting the user's launch).** The user's spec: capture the actual VkImage of the
canonical at the first consumer use after the rebuild, real cells only (mips 0-8 x layers 0-5, 54
cells), ONE image->buffer copy per cycle with a region per cell, hash host-side (whole + per cell),
compare cycle to cycle in the frozen replay; per changed cell log mip, layer, previous/current hash,
producer class (mip0 SRC/face array, mips 1-2 cs 0x2673a048, mips 3-8 cs 0xc28178a3). Decision:
A same hashes + flicker = cube cleared; B different + flicker = trace the changed cells' producer;
**C capture on and the flicker disappears = barrier-sensitive, stop and redirect to
producer->consumer sync; never read the disappearance as success**; D different but flicker gone =
investigate the barrier effect. Report headings: RESULT / VISUAL BEHAVIOR WITH CAPTURE / WHOLE-CUBE
HASHES / PER-CELL DIFFERENCES / PRODUCER CLASS OF CHANGED CELLS / PERTURBATION ASSESSMENT / ONE NEXT
STEP.
Implementation (`[cubegpu]` in `texture_cache.cpp`): trigger = FindTexture right after UpdateImage,
texture binding of a class-C image through view base 0/0, all mips, exactly 6 layers, first per
(uid, presented frame). `EndRendering`, `image.Transit(TransferSrc, TransferRead, view range)`, one
`copyImageToBuffer` with 54 regions into one of 8 own VMA host-visible buffers (not the shared
download stream buffer), a transfer->host buffer barrier, `DeferOperation` (not the priority queue,
which signals guest fences) hands it to a detached worker that invalidates, XXH3-hashes, diffs
against the previous cycle (differing texels, max decoded B10G11R11 delta, non-finite texels) and
logs. Producer uid/VA per cell come from `GtCgNoteSrc/NoteDonor` at the cubelife SRC/DONOR sites.
It runs EVERY cycle for the whole run on purpose, so the user can watch the flicker while it is on.
Watcher: `scratchpad/watch355.sh`.
**Run 355 RAN (23 Sep, log `logs/shad_log_run355_2026-09-23_cubegpu_b1cd966e.txt`, crash at
t=363.7 s, see D).** 4993 cycles captured, 0 missed (buffers never all in flight). MEASURED:
- A static menu scene gives a bit-identical cube for hundreds of frames: hash `bc6e2fc9b790ee56`
  for 360 frames at t=33-39 (long-lived uid 0xa5, built S1+D53), again at t=171, 327 and 360. The
  SAME hash also comes out of cubes rebuilt from scratch every frame through the eviction path
  (t=172.7-173.0: 4 new uids, S6+D48; t=361.2: 8 new uids). So the rebuild (SRC + 48 DONOR copies)
  is bit-exact and deterministic: it reproduces the in-place cube to the bit.
- The race (t=52-158) and the post-race phase (t=183-292, three cubes per frame: q1 256 m9 plus q0
  64 m7 / 128 m8 alternating, all rebuilt every frame) change almost every frame (q1: 833 distinct
  hashes in 1748 frames, runs of identical frames up to 15, A-B-A returns only 41).
- In the menu, when the long-lived cube changes, ONLY mip0 cells change (layers 1,3,5, or 1,5, or
  0) and mips 1-8 stay bit-identical; t=331-336 alternates between two such versions
  (`302ef27b` <-> `9895f17b`, 3 cells apart). Whether that is a real stale mip chain or a
  sub-LSB change the box filter absorbs is unknown: the detail budget was gone (lesson 32).
- NOT established: where the user's frozen replay was in this run, and whether the flicker stayed
  visible with the capture on. Asked the user; the A/B/C/D decision waits on that answer.

**B. `SurfaceFormat` assert with Bc6(40)+Ubint(12)** (348, loading the Menu Book race after the
Café). The source is proven to be T#-only, via the flatbuf path. It did not reproduce in
351/351b/352/352b/353; the `[tsharp]` observer (`GT_TSHARP_PROV=1`) stayed armed and never fired.
It is state-dependent. A third impossible pair appeared on 1.71: 52/11.

**C. PCL Event fault loop** (349b). The guest polls 0x1000fffd80 on a GPU-tracked page. After a
second 4096-fault streak, `BreakFaultLoop` refuses the fault and the guest dies at
`eboot+0x3b590e0`. This predates the merge (346 already had the first streak). Fix direction: a
page that has left a fault loop is not re-protected. Never special-case the address.

**D. Parked:** a NEW crash class, run 354 at ~t=377 s: guest "Rendr" thread,
`0xc0000005 at eboot.bin+0x92f700 while writing 0x2b4`, reached through a virtual call
`call [rax+0x440]` whose return address is eboot.bin+0x1f9331b. It came after a 45 s guest
heartbeat loss with netctl spam. Minidump `logs/run354_guest_crash.dmp`; not chased.
**Reproduced in run 355** at t=363.7 s: `0xc0000005 at eboot.bin+0x92f72f while writing 0x2a6`,
Rendr thread again, rcx=rdx=rsi=0 (a null base), rsp+0x38 holds 0x0e1f331b (the same caller as
354), and it happens right after `sceFontSetScalePixel/SetEffectWeight/SetEffectSlant/
RebindRenderer` calls with text "...Test Car Name 3 Lines..." in memory at r15 - i.e. inside the
guest's font/text layout. Both runs crashed at the same point of the flow: Music Rally done, back
in the menu, entering the next scene. Minidump `logs/run355_guest_crash.dmp`. Still parked.
**Crash D, HLE-side audit (24 Sep, no run).** 354 and 355 are NOT the same instruction: 354 faults
at `eboot+0x92f700` writing 0x2b4, 355 at `eboot+0x92f72f` writing 0x2a6. They share the return
address `eboot+0x1f9331b`, rsp `0x7e930b8e0`, r15 `0xe40c1f6cc8` and zero rcx/rdx/rsi, so they are
one crash family. The four calls in front of it (`sceFontSetScalePixel`, `SetEffectWeight`,
`SetEffectSlant`, `RebindRenderer`) are clean by source: no output parameters, they write only
non-pointer fields inside the 0x100-byte font object (+0x04 lock, +0x48..+0x63 style, +0x68..+0x8F
cached copy, +0x94, +0x9C lock), and they never touch the renderer binding. Every one of the
9288/9556 calls per run returned OK: no error line exists, and error lines do reach this log (the
four `OpenFontSet` NO_SUPPORT_FONTSET for set type 0x190724C3 at startup prove it). The Rendr thread
makes one `sceFontMemoryInit` and then only those four calls, never a render call. Both runs end
the same way: a burst of 338/342 four-call groups, then one of 34, then the crash 3 log lines
after the last `RebindRenderer`. A 34-group burst also happens earlier in both runs without a
crash. Contract problems found next door, none proven to be on the crash path:
- `sceFontGetKerning` never validates the handle; `GetState()` creates host state for any value,
  it returns ORBIS_OK, and it calls `FT_Set_Char_Size` on a shared face without the font lock;
- `sceFontDestroyRenderer` frees the renderer without unbinding the fonts bound to it and without
  clearing its magic, so `RebindRenderer`'s 0x0F07 check can pass on freed memory;
- `sceFontOpenFontMemory` returns ORBIS_OK when FreeType fails to create the face.
The next step proposed is a bounded HLE-only observer (per-thread ring of font calls, dumped by the
crash handler), not built yet.
**Run 356 is built** (`GT7_probe356_fontwatch.bat` = 355 + `GT_FONTWATCH=1`; watcher
`scratchpad/watch356.sh`). The user's two safeguards, both kept: (1) the observer never
dereferences a guest pointer - every read is `ReadProcessMemory`, which cannot fault, so it cannot
enter the emulator's fault handler either; an unreadable pointer is classed by `VirtualQuery` as unmapped or
committed-but-protected; (2) the crash dump is frozen rings of fixed POD entries written with a
hand-rolled formatter and `WriteFile` to `log/fontwatch_crash.txt`, opened at arm time, AFTER the
existing report and minidump - no lock, no allocation, no CRT formatting. Why not the logger: it is
spdlog with `dup_filter_sink_mt` (a mutex) and fmt (allocations). The wrapped bodies keep their
names inside `GtFwImpl`, so `__func__` - and every existing log line - is unchanged.
Decisive readings the user named: stale renderer accepted after DestroyRenderer; GetKerning creating
FontState for an invalid handle; OpenFontMemory OK without a face; or all HLE font state valid up to
the crash - which moves the search away from the font HLE.

`PatchImageSampleArgs` UNREACHABLE at Lago Maggiore (347; the user said not to
investigate it); `sceJpegDecDecode` rejecting `jpeg_mem_size=0` (our jpegdec; garbled loading
thumbnails); `resource_patching_pass.cpp:471` "Thread ID buffer addressing is not supported
outside of compute" (344); the Single Race deadline dispatcher reading a signalled label as a
pointer; 1.71 (`CUSA24767`) in general, until the offline chat makes it boot.

**Uncommitted instruments in `gt7-main`** (strip before any PR): `[fontwatch]` (run 356:
`src/core/libraries/font/gt_font_watch.{h,cpp}` + its two CMakeLists lines, the 15 wrappers at the
end of `font.cpp` with each wrapped body moved into `namespace GtFwImpl`, `GtFwStateExists` in
`font_internal.*`, and one `GtFontWatch::OnGuestCrash(pExp)` after each `WriteGuestCrashDump` in
`signals.cpp`); `[tsharp]` in `vk_rasterizer.cpp`
plus `SurfaceFormatSupported()` in `liverpool_to_vk.*` (diagnostic only); `[cubetrace]`,
`[cubekill]`, `[cubelife]` (run 354) and `[cubegpu]` (run 355, `GtCg*`) in `texture_cache.cpp`, with `GtLifeNoteWrite` called from
`MarkGpuWritten` in `texture_cache.h` and `g_gt_imgsrc_last` in `gt_va_watch.h` + `buffer_cache.cpp`; `GtBindCtx` in `gt_va_watch.h`; `GtPresentFrame()`. The
wrappers are `GT7_probe351_tsharp_prov.bat`, `352_cubetrace.bat`, `353_cubekill.bat` and
`354_cubelife.bat` (= 353 + `GT_CUBELIFE=0x100b1b0000+0x2ac000`) and `355_cubegpu.bat` (= 354 +
`GT_CUBEGPU=0x100b1b0000`). The logs
are in `GT7_upstream/logs/shad_log_run35x_*`.

---

## 6. Environment and tooling facts

- Active game: `CUSA24769 v01.00`. `CUSA24767 v01.71` is parked. A fresh profile reaches Music
  Rally and the Café, but not Single Race.
- `run_gt7.ps1` applies defaults with `Set-GtDefault`, and a value already in the environment wins.
  So a wrapper `set GT_X=...` then `call` works end to end; this was verified.
- Watcher: `RUN=NNN bash GT7_upstream/watch_run.sh`, or a per-run copy in the scratchpad with the
  run's tags added to `KEYS`. Re-arm mid-run with `WATCH_RESUME=1`.
- A 25-45 s heartbeat loss with `netctl`/`np_manager` spam is a loading screen. A GPU stall is
  established only by `[gpuwait]`.
- The texture cache code that matters: `ResolveOverlapImpl(image_info, binding, cache_image_id,
  merged_image_id)`; `ImageInfo::MipOf` gates (IsCompatible, array_mode, levels == 1, mip search with
  in-range / slice-aligned / pitch match, dims, type); `SanitizeCopyLayers` = min(src, dst) layers;
  `NumLayers()` pads to pow2 (6 -> 8). `IsCompatible` compares only bit width, so R16G16Sfloat and
  B10G11R11 pass it.
- `SharpFetch<T>::Fetch`: per dword, `load_mask` bit set selects `flatbuf[offsets[i]]`, otherwise
  `immediates[i]`. dword1 holds dfmt [25:20] and nfmt [29:26].
- The Unreal project at `C:\GTNikos` is a different lane. Its huge CLAUDE.md is not this lane's
  rules; `C:\shadps4-gt7\CLAUDE.md` is.

---

## 7. How to add to this branch without touching `gt7-main`

```sh
cd /c/shadps4-gt7
git fetch mine claude && git update-ref refs/heads/claude FETCH_HEAD   # only if mine is ahead
export GIT_INDEX_FILE=<scratchpad>/claude-notes.index                   # never under .git/
git read-tree claude
b=$(git hash-object -w --path=CLAUDE_MEMORY.md <scratchpad>/CLAUDE_MEMORY.md)
git update-index --add --cacheinfo "100644,$b,CLAUDE_MEMORY.md"
C=$(git commit-tree "$(git write-tree)" -p claude -m "<what changed>")   # no trailer
git update-ref refs/heads/claude "$C"; unset GIT_INDEX_FILE
git push mine refs/heads/claude:refs/heads/claude
```
