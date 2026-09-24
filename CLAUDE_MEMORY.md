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
  numbers continue the global series (last used: 358, run 24 Sep).
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
36. **A clean observer only speaks for the stretch of the run it saw.** Run 356's fontwatch
    counters were zero for every anomaly, and the first reading was "the font HLE is cleared".
    But 356 died at t=185 s on a different fault, while crash D struck 354/355 at t=368/364 s:
    the observer never reached the crash it was built for. Before reading a clean instrument as
    a verdict, compare where the run ended with where the target fault strikes (the Rendr font
    bursts: 84 in 354, 98 in 355, 22 in 356).
37. **A parser's own dump can prove the memory moved under it.** The PM4 type-0 header in the
    last two dwords looked deliberate (its count fits the space exactly - the review's reading)
    or unwritten (mine). Neither: the live copy in the report shows dword 0, which the parser had
    already accepted as a header, no longer parsing as one. Before theorising about a bad
    packet, compare what the parser ALREADY consumed with what the memory holds now.
38. **Inferred a scene from a burst shape while the game was naming its scenes** (357, 358).
    The "300-400 then 34" Rendr burst was read as "Dealership -> Main Map", and 357 went into
    the notes as two transitions without a crash. The game prints every scene change itself
    (`__AUTOMATION__ EVENT_ROOT`, with its own wall clock): 357's two were Dealer -> Map WITHOUT a
    purchase and Cafe -> Map, and 358's one was Cafe -> Map. The same shape belongs to several
    scenes. Read the game's scene log before counting a transition, and match the CRASHING
    run's whole sequence, not its last burst.
39. **Took a device feature as "supported" because a warning did not appear** (24 Sep, f64 notes).
    The emitter's float-control warnings are `std::call_once`, so their absence says nothing about
    a given shader; the notes claimed DenormPreserve 64 support that vulkaninfo denies. Read the
    device's properties (vulkaninfo) before any claim about what the host can do.
40. **Wrote tests for an encoding the ISA does not have** (25 Sep). The VOP3 form of V_TRUNC_F64
    looked natural (LLVM-style e64), the decoder aborted on it, and the Sea Islands VOP3 map lists
    407-415 as reserved. Check the ISA's opcode map for every encoding before testing or adding it.

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

**CORRECTION (24 Sep): the `65b03b2f` row above says "unpushed" - wrong by then.** Upstream
`bc028b7c` "video_core: commit the emulated-LDS allocation taken from the stream buffer (#5070)",
authored by the user on 23 Sep, is the identical one-line change (diffed). The PR was submitted
and merged; `pr-lds-stream-commit` is redundant now and was left untouched.

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
**Run 356 result (24 Sep): crash D was NOT reached.** The process ended at t=185 s on the GFX
parser's own `UNREACHABLE_MSG("Unimplemented PM4 type 0")` in `ProcessGraphics` - a host
exception, so no `guest_crash.dmp` and no fontwatch dump. Fontwatch was clean for those 185 s
(0 of every anomaly; the four quad calls ~2500 each, 0 errors; 4 threads, 0 dropped), which
says nothing about the crash itself. Log: `logs/shad_log_run356_2026-09-24_fontwatch_b1cd966e.txt`.
**The PM4 type-0 death is recurring and was never parked**: runs 309, 313, 320, 351, 353, 356
and five `shad_log_prev_*` logs. All 8 recorded `[badpacket] CORRUPTION POINT`s are the LAST
TWO dwords of the submitted DCB (slot 0, depth 0) - `dword 2 of 4` five times, also 14 of 16
and 264 of 266 - in two shapes: `0x00000000` then a zero, or `0x00000002` (type 0, base 2,
count 0) then a non-zero dword. In every case the header's own count consumes exactly the two
dwords left. `4720205e` (fence order) fixed 309's variant only.
**It is not a packet, and not a truncation.** `DescribeGfxSubmit`'s AT PARSE side is a
`GtSafeCopy` taken at REPORT time, and in all 5 reports that carry a dump (320, 351, 353, 356,
`prev_2026-09-14_2314`) the buffer's dword 0 - which the parser had already accepted as the
first header - now reads `0x00000000` or `0x00000001`, not PM4. The memory under the parser was
rewritten while it was still inside it, 57-107 ms (114-128 ticks) after the submit; 356's buffer
now holds a small struct (`00000001 00000242 00000004 00000000 01400068 ...`) and zeros. The
type-0 "packet" is what the rewritten tail looks like, so its register (base 0 or 2) and value
mean nothing. The ACB tolerance is our own run-72 `[softclamp]` (`e5c2634f`); upstream `4621b6a1`
hits UNREACHABLE on type 0 in CE, GFX and ACB alike. Open for after 357: why the guest rewrites
(or unmaps - the run 332 note in `DescribeGfxSubmit`) an IB our CP is still parsing.
**Run 357 is built** (`GT7_probe357_dcbskip.bat` = 356 + `GT_DCB_SOFTSKIP=1`; watcher
`scratchpad/watch357.sh`). The user asked to stub the crashing point to make progress and look
at the cause afterwards. The stub skips a non-type-2/3 GFX DCB header the way the ACB
`[softclamp]` path (run 72) already does - type 0 by `type0.NumWords() + 1`, anything else by one
dword, clamped to what remains - instead of UNREACHABLE; the first 4 keep the full
`[badpacket]` report. The register write the packet carries is not applied. Gate off = the
parser is unchanged, so the other lane running this binary is unaffected. GT_FONTWATCH stays
armed so 357 can catch crash D at ~365 s.
357 must answer this and only this (the user's review, 24 Sep): how many `[dcbskip]` before
Dealership -> Main Map, and when the first came relative to that transition (the lines carry
no clock: use log position against the Rendr font bursts and the nearest `t=`; the running
count is exact to 64, then sampled every 1024th); whether crash D was reached and, if so, RIP /
write address / return address / rsp / r15 / thread; the Rendr fontwatch ring just before it;
every font lifecycle event. After the first skip the GPU stream is no longer faithful, so
nothing after it says anything about PM4 or graphics state. No upstream fix, and the
soft-skip never becomes default behaviour.
**Run 357 result (24 Sep): crash D did NOT fire, and the run lasted ~65 min.** Log:
`logs/shad_log_run357_2026-09-24_dcbskip_b1cd966e.txt` (299 MB), dump `run357_fontwatch_crash.txt`,
minidump `run357_guest_crash.dmp`. 4 `[dcbskip]`, all at t~175-205 s: 3 x `dword 264 of 266` in
submission #14900 (three 266-dword IBs 0x480 apart) and 1 x `dword 2 of 4` in #15822; none after.
The scene pattern that preceded crash D in 354/355 - a Rendr font burst of 300-400 followed
within seconds by a burst of exactly 34 - occurred TWICE (t~898, t~3122) with no crash
(`scratchpad/run357_timeline.py` finds it; 354 and 355 each have it once, at the crash).
Fontwatch over 3848 s: 0 of every anomaly, 62 threads, 0 dropped; lifecycle = 1 CreateRenderer
(t=0), 50 Bind, 48 Open, and NO Destroy/Unbind/Close/MemoryTerm/DestroyLibrary at all. The run
ended on the parked PCL Event fault loop (`eboot+0x3b590e0` reading 0x1000fffd80 after two
BreakFaultLoop READ streaks of 6.2 and 5.5 min), so the dump holds THAT crash, not crash D; its
Rendr ring is quads + GetKerning on a valid font and the one renderer. Not a fix: versus 355
two things changed (GT_FONTWATCH on every Rendr font call, GT_DCB_SOFTSKIP acting 4 times ~12 min
before the first window) and 2/2 vs 0/2 is a small sample. The dump header still says "run 356
armed" - the string is hard-coded in `gt_font_watch.cpp`.
**Corrected by the game's own scene log (read after 358):** the two "windows" were NOT the
crash-D scene. t~898 = Dealer -> Map WITHOUT a purchase, t~3122 = Cafe -> Map. 357's one
purchase (08:28) showed ONE `CollectorsLevelDialog` (no achievement) and the map then showed a
Pavilion notifier with no 34-burst. So 357 never reached the crash-D sequence; it says nothing about fontwatch
or the soft-skip either way (lesson 38).
**Source fact for the PM4 look (not yet tested):** `ProcessGraphics`'s IndirectBuffer case
recurses into the child and then resumes the PARENT whatever the `chain` bit says (upstream
`4621b6a1` identical). On AMD's CP a CHAIN=1 IB is a jump, not a call. If so, the parser reads the
parent's trailing dwords after the whole chain returns - 57-107 ms late, after the game has
reused the chunk - which fits the 266- and 16-dword shapes (2 dwords after a 4-dword slot). The
4-dword shape (`dword 2 of 4`) is NOT explained by it.
**Run 358 is built** - a controlled ablation of 357 (`GT7_probe358_dcbskip_nofw.bat`: clears
`GT_FONTWATCH`, which 356/357 set without setlocal, sets `GT_DCB_SOFTSKIP=1`, calls the 355 bat
unchanged; same binary as 357, the fontwatch code inert). Watcher `scratchpad/watch358.sh`
prints `MARK hh:mm:ss | log byte N` every 30 s so the user's transition times map onto the log,
archives `fontwatch_crash.txt` only if newer than the run (357's file is still in the folder),
and files a PCL Event crash separately. The user's rules for reading it: Dealership -> Main Map
at least twice; per transition the time, whether the characteristic Rendr burst appears,
whether crash D occurs, and every soft-skip before it; never judge by elapsed runtime. If crash
D returns: the exact 354/355/358 signature comparison. If it does not after >= 2 CONFIRMED
transitions: evidence that the soft-skip may alter upstream state - NOT proof that PM4 type-0
caused crash D. No PM4 fix.
**Run 358 result (24 Sep): crash D did not fire, and the run cannot answer the ablation.**
Log `logs/shad_log_run358_2026-09-24_dcbskip_nofw_replay_hang_b1cd966e.txt` (99.9 MB). 0
`[dcbskip]`, 0 bad packets, 0 `[fontwatch]` lines, no guest crash, no PCL Event, no PM4 death.
The stub never acted, so up to every transition the parser ran unmodified. The binaries' own
logged line numbers (355 vs 358) moved only in `font.cpp`, `font_internal.cpp` and
`liverpool.cpp`; `texture_cache.cpp` has 14 identical sites and 0 moved, so the texture code
is 355's - the user's "we worked on the textures" cannot explain the difference either.
**THE CRASH-D SCENE, from the game's scene log:** in 354 AND 355 the last scenes are an
`UsedCarDealerProject` purchase (`GTCreditPurchaseDialogRoot`, `CarDeliveryService_TopRoot`)
with SEVEN `CollectorsLevelDialog` + `CollectorsLevelAchievementDialog` pairs (seven level-ups by
the dialog names), back to the dealer `TopRoot`, `MapViewProject::MapViewRoot`,
then the 338/342-call burst, then the 34-call burst, then crash D 3 lines later (22:39:23 /
23:41:14). In 357 and 358 the purchase showed 0 and 1 achievement dialogs and the map showed
`PavilionNotifierRoot` with NO 34-burst (358: 18:16:08.9, burst 306, no crash, 0 soft-skips
before it). The 34-burst after a map entry also appears in other contexts (Cafe -> Map
18:17:52.6: 352 then 34, then the Pavilion notifier; the map re-entry at 18:17:05) without a
crash. 358 had ONE confirmed Dealer -> Map (the user's rule asks for >= 2) and without the
seven-level condition. What reproduces crash D is therefore most likely the SAME purchase
(a car whose purchase jumps the Collector level several times) - a save-state question for
the user. 354 and 355 both showed exactly seven, which suggests that purchase was never saved
(the crash came first).
**358 ended in a NEW freeze, not a crash:** entering the post-race Replay screen
(`RaceCommon_ReplayRoot`, 18:22:50.9, then `replay_a.dat` read twice) the last five frames took
0.27-1.1 s each, almost all WaitRegMem on gfx and asc, then no frame, no scene and no GPU work
for 27 min; 0 `[gpuwait]` samples, 0 BreakFaultLoop; only Netwk polling and
`sndz_stream_task_service` event-flag waits. The user closed it at 18:50:19. Filed apart in
`logs/hang_postrace_replay/run358_replay_hang.txt` with the scene log, the frame timings and
everything the guest logged after the last frame.
**The PCL Event crash has its own folder**: `logs/pcl_event_0x1000fffd80/` (357's report with
every `[faultloop]` line, the 357 and 349b minidumps). It has recurred in 349b, 351b and 357.

`PatchImageSampleArgs` UNREACHABLE at Lago Maggiore (347; the user said not to
investigate it); `sceJpegDecDecode` rejecting `jpeg_mem_size=0` (our jpegdec; garbled loading
thumbnails); `resource_patching_pass.cpp:471` "Thread ID buffer addressing is not supported
outside of compute" (344); the Single Race deadline dispatcher reading a signalled label as a
pointer; 1.71 (`CUSA24767`) in general, until the offline chat makes it boot.

**Uncommitted instruments in `gt7-main`** (strip before any PR): `[dcbskip]` (run 357, a STUB not
an observer: `GtDcbSoftSkipOn()` after `NextPacket` in `liverpool.cpp`, its call at the top of the
`Liverpool` constructor, and the skip block in front of the `switch (type)` of `ProcessGraphics`);
`[fontwatch]` (run 356:
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

**MERGE WITH UPSTREAM 19700eba (24 Sep evening) - READ THIS BEFORE TOUCHING THE BUFFER CACHE.**
`gt7-main` = merge `4e0b250f` (parents: checkpoint `ed3a4ba5` "runs 351-358 observers and the
[dcbskip] stub", upstream `19700eba`). Pre-merge state kept as branch `gt7-pre-upstream-5047`
(= `ed3a4ba5`). The full per-hunk table is `GT7_upstream/MERGE_upstream_19700eba.md` (untracked).
The user chose UPSTREAM-FIRST: upstream's sparse-arena buffer manager (#5047), `buffer.*`,
`memory_tracker.h` and `region_manager.h` are taken whole; lab code built on the old manager is
DROPPED, not transplanted. Gates that no longer exist (setting them does nothing): GT_BDA_IMPORT,
GT_DIRECT_IMPORT, GT_BIND_SKIP, GT_TEXEL_MEMO, GT_STREAM_MEMO, GT_DMA_DIRTY_LOG, GT_FAULT_WIDE,
GT_HOT_PIN, GT_IMGARRAY_SYNC, GT_INDARGS_GPU, GT_DISPGPU, GT_READBACKS_ONRACE, GT_READ_PREFETCH,
GT_READ_TRACE/WINDOW, GT_CSIN_HASH ([csin]), GT_CSOUT_CAPTURE ([csout]), GT_INVAL_IMG_ON_SSBO
(superseded: upstream c8fcf4d7 invalidates images after EVERY written storage buffer). Also gone:
[indargs-anomaly], the buffer profilers, the writer ring, readback history in [ibchain]/[badpacket],
the buffer-side GT_SOFT_CLAMP null-binds and clamps, the buffer OOM step-down (the image one stays).
Kept: [ldsring], [badpacket]/[ibchain], [dcbskip], [fontwatch], [tsharp], all [cube*], GT_18256C0_GUARD,
GT_WATCH_VA notes, the run-281 TrackerReentry guard, BDA registry, IsFaultAddressValid, [protprof]/
[faulthist] (re-hosted in the [fprof] window). Shader cache formats bumped to 14/9.
- LESSON: the build proving it compiles found NONE of the semantic losses. A census of `getenv("GT_*")`
  and `"[tag]"` strings before vs after the merge found three probes my BindBuffers rewrite had
  dropped by accident (GT_18256C0_GUARD - set to 1 by the 317 chain -, the GT_WATCH_VA bind note,
  the [fprof] obtain scope) and one feed that lived in the removed code (`g_gt_imgsrc_last` for
  [cubelife]). Run that census after every merge, before the commit.
- Readbacks: nothing switches them on at race start any more, and `run_gt7.ps1` defaults to 0, so a
  race may show the run-264 symptom again (environment draws culled on stale readbacks). Expected.
- [fprof] fields that are now structurally 0 (their writers were in the dropped code): bufgc, deaths,
  clamp, findbuf, bufscan, bufemit, softclamp[6..7] (softclamp[0..5] are live again since
  `f540244b`). Never read the dead ones as measurements.
**Run 359 (24 Sep 21:18) died at t=65s on `vk::Result=ErrorOutOfDeviceMemory`** (vk_platform.h:66,
`Vulkan::Check(allocateMemory)` in the new arena's `EnsureResident`): 9.70 GiB committed in 1571
allocations on the 12 GiB RTX 4070 SUPER, 9.4 GiB of it in THREE single commits of tail descriptors
over memory that is not GPU-mapped (0xe3de80000 3417 MiB, 0x470070000 2283 MiB, 0xc73dfb0000
3704 MiB). Cause: MY merge dropped the buffer-side GT_SOFT_CLAMP scan (256 MB tail cap + GPU-mapped
prefix, torn-V# null-binds, guest floor) together with the old buffer cache; run 358's log shows it
catching the very same 3417 MB descriptor. Restored in `f540244b` on the new BindBuffers and
BindVertexBuffers (30 of 33 pre-merge [softclamp] messages back; the 3 left out check per-buffer
backing sizes the arena does not have). Log: `logs/shad_log_run359_upstream_merge_vkcheck_crash.txt`.
Run 359 was NOT a clean-upstream baseline (reviewer, correctly): it changed two things at once -
new upstream AND fewer lab guards - and still ran 117 GT_* gates' worth of lab code.
- LESSON: "dropped with the old buffer manager" must be checked feature by feature. The guard lived in
  the binding scan and was not tied to the old manager at all; the string census could not see the
  loss because the guard's strings left with it. The run found it in 65 seconds.

**DIRECTION CHANGE (24 Sep ~21:40, user): "remove GT_* and we start from error one for general fix",
and "keep it saved tho so we have a backup to play the game whenever / have the gt code ready for use".**
- CLEAN LINE = the local branch `main` (pure upstream, 0 GT_* gates; fast-forwarded 7a8caf12 ->
  19700eba) in worktree `C:\shadps4-clean` with its own Build folder. Build:
  `GT7_upstream\build_clean.bat` (= build.bat with `cd /d C:\shadps4-clean`). Run:
  `GT7_upstream\GT7_clean_run01.bat` - clears every GT_* variable, runs `run_gt7.ps1 -WhatIfOnly`
  (same config.json as the lab runs: log filter, 1 GiB log, validation off, pipeline cache on,
  readbacks 0, network off; -WhatIfOnly exits before the script's GT_* section), then starts the clean
  exe on the same eboot. Same save and user dir (%APPDATA%\shadPS4 - upstream uses it whenever the
  cwd has no `user` folder). Watcher: `scratchpad/watch_clean.sh` + `watch_clean.awk` (scenes, the
  first occurrence of every Critical/Error stem, fatal lines with 6 continuation lines; archives the
  log at exit as `logs/shad_log_<RUN>_at_exit_*.txt`).
- METHOD from here: the first error of pure upstream -> root cause -> ONE general fix on its own
  branch off `main` (no GT_*, no game names, no investigation comments, no trailer) -> the next error.
- LAB = PLAY BACKUP, kept intact: `gt7-main` `f540244b`, tag `gt7-lab-backup-20260924`, exe copy
  `GT7_upstream/backup_exe/shadps4_lab_f540244b.exe`; play with `GT7_probe359_upstream_merge.bat`
  (NOT run yet since the restore). Last PROVEN playable state: branch `gt7-pre-upstream-5047`
  (runs 355-358; needs its own build to get an exe).
- Clean-worktree submodules: `git submodule update --reference <lab module dir>` failed for most of
  the 45; plain network clones worked. The lab worktree's module repos live under
  `Documents/GitHub/shadPS4/.git/worktrees/shadps4-gt7/modules`, not under C:/shadps4-gt7/.git.
- Clean build 1 (24 Sep 22:01): `NINJA_EXIT=0`, exe 69,622,784 bytes, tree `19700eba`, no local edits.

**Clean run 01 on 1.00 (24 Sep 22:10) - PARKED, the user switched to 1.71 before it was analysed.**
Access violation `0xc0000005 at 0xc3faac6` = eboot+0x101aac6 (eboot loaded at 0xb3e0000) at t=17 s,
BootProject::TopRootWindow, on the thread that had just made 19 `sceSaveDataGetSaveDataMemory2`
calls. Log: `logs/shad_log_clean01_at_exit_221026.txt`. Not a clean A/B against the lab: the save
itself changed too - run 359 made 42 `sceSaveDataSetSaveDataMemory2` calls before its OOM, and the
lab passed this point on the save 358 had left (359 read it 20 times and went on). The save-data HLE
is identical in `main` and `gt7-main` (empty diff). Copies of that save and config:
`backup_exe/save_CUSA24769_pre_clean01_20260924_2205`, `backup_exe/config_lab_pre_clean01_*.json`.

**GAME SWITCH (24 Sep ~23:00, user): "we work with 1.71 from now on".** CUSA24767 v01.71,
`ps4games\CUSA24767` (8.3 alias `CUSA24~2`; `CUSA24~1` is 1.00). Run as installed: eboot SHA256
`8101d76a...f4a3f2fd` (the owner's two local-save patches P1/P2, online sign-in sites removed;
`eboot.bin.orig` = `65f75f6b...`) and `app_param_0.sfo` with automation (`d7319018...`). The game
files belong to the offline lane (`C:\GT7_offline\REPORT_171.md`) - never modify them.
- PRIVATE PROFILE for the clean line: `C:\shadps4-clean-run\user` = shadPS4's portable user dir
  (`current_path()/user`, path_util.cpp:90). Copies (24 Sep 23:0x) of config.json, users.json,
  keys.json, input_config, trophy, home/1000/{trophy,inputs}, home/1000/savedata/CUSA24767,
  download/CUSA24767. Cache and shader dirs start EMPTY. Why: (1) a clean run never touches the real
  1.71 save; (2) the other lane's runs use %APPDATA%\shadPS4 and its log; (3) on the SHARED profile
  the clean build ran with NO pipeline cache at all: clean01 log line 109 `WarmUp: Pipeline cache
  profile has unexpected size (60 != 64). Ignoring the cache`, then `Close: Cache dumped` - upstream
  meets the lab's profile blob, drops the whole cache and closes it, so it neither reads nor writes
  (measured: 0 files in cache/CUSA24769 newer than 21:21). The lab's blobs use the same names but
  other versions (lab ShaderBinaryVersion 14 / ShaderMetaVersion 9 XOR BuildGeneration(); upstream
  5 / 5), so the two caches can never share a directory. And upstream has NO build identity in its
  cache key: after a fix that changes codegen, a clean rebuild replays its own stale modules - clear
  `C:\shadps4-clean-run\user\cache` after any recompiler change.
- Launcher `GT7_upstream\GT7_clean171_run01.bat`: clears GT_*, refuses if any shadps4.exe runs,
  `cd /d C:\shadps4-clean-run`, starts the clean exe on the 1.71 eboot, pauses at exit.
- Watcher `scratchpad/watch_clean171.sh` (+ `watch_clean.awk`): only the CLEAN exe counts (`ps -W`
  shows full Windows paths, so a lab shadps4.exe is ignored); at exit archives the private log AND the
  game's own `download/CUSA24767/APP_DATA/logs/archived.log` as `logs/shad_log_<RUN>_at_exit_*` and
  `logs/game_log_<RUN>_at_exit_*`.
- **clean171_01 (22:27, pure upstream):** first fatal = cs 0x1c0f802e, `LogMissingOpcode V_MIN_F64`
  + `V_TRUNC_F64`, then `recompiler.cpp:48 Shader translation has failed` (log line 54825-54829).
  Both opcodes are one indivisible test (same shader, one sticky `translation_failed` flag).
- **clean171_02 (22:53, 19700eba + uncommitted +17 lines: V_MIN_F64 -> FPMin, V_TRUNC_F64 -> FPTrunc,
  exe `backup_exe/shadps4_clean_19700eba_f64_trunc_min_test.exe`):** single variable vs run 01 (same
  eboot/sfo hashes, byte-identical config, profile rebuilt from unchanged sources, empty cache; run
  01's profile kept as `C:\shadps4-clean-run\user_after_clean171_01`). 0x1c0f802e translated,
  pipeline created, spirv-val (vulkan1.3) passes on it and on all 218 cached shaders; SPIR-V from
  the pipeline cache blob (raw SPIR-V), no dump. Only that shader uses f64 FMin/Trunc. NEXT
  BLOCKER, not fixed: fs 0x74f5f10c, `vector_interpolation.cpp:103 V_INTERP_MOV_F32` ASSERT
  (`attr.is_flat || inst.src[0].code == 2`) after PlayGo BuddyWindowRoot. Full analysis:
  `GT7_upstream/patches_clean/f64_trunc_min_NOTES.md`. NOT committed, NOT a PR (user: "first
  testing then if clean we pr").
- **Semantics, checked against the official specs (copies in `GT7_upstream/docs/`: AMD Sea Islands ISA
  Rev 1.3 pdf + txt, GLSL.std.450.html, Vulkan-Docs spirvenv.adoc; SPV_KHR_float_controls2 online):
  passing the assert is NOT correct semantics.** (1) GLSL.std.450 ext insts (Trunc, FMin, NMin) are
  NOT covered by SignedZeroInfNanPreserve; Vulkan assumes NSZ/NotInf/NotNaN for them unless
  SPV_KHR_float_controls2 is used (upstream uses it nowhere; this GPU exposes it). So +-0/+-Inf/NaN
  through the new TRUNC and MIN are not guaranteed. (2) FMin's NaN result is implementation-
  dependent; its "-0 compares less than +0" matches AMD's min(-0,+0)=min(+0,-0)=-0. (3) AMD does not
  publish the F64 min NaN rule ("see the SP Numeric spec"); the F32 entry gives minNum + IEEE-mode
  sNaN quieting. (4) AMD: an F64 literal is the HIGH dword -> upstream GetSrc64<F64> (literal in
  the low dword) is wrong for VOP1/VOP2/VOPC F64 literals; VOP3 takes no literal on GFX7.
  (5) IEEE_MODE and DX10_CLAMP are not decoded (unnamed `u32 : 4` in ShaderProgram::settings);
  fp64 denorm flush is unsupported on the RTX 4070 SUPER. Options A (exact core-op lowering in the
  handlers) / B (float_controls2) / C (mode plumbing) - awaiting the user's decision.
- **Option A done (25 Sep ~00:00), user/reviewer: "A as the base, no PR, nothing on
  V_INTERP_MOV_F32".** Two LOCAL commits in `C:\shadps4-clean`, nothing pushed:
  `pr-f64-literal` 2c692b70 (GetSrc64: 32-bit literal = HIGH dword of a 64-bit float operand, by
  template type or `operand.type == ScalarType::Float64`; runner enables shaderFloat64 when
  supported) and `pr-f64-trunc-min` 65fa8e0c on top (V_TRUNC_F64 / V_MIN_F64 on the BIT PATTERN with
  64-bit integer IR ops: no Float64 capability, no float control involved; V_MIN_F64 flushes both
  operands to a signed zero unless `runtime_info.props.fp_denorm_mode16_64 == InOutAllow`;
  NaN operand -> other operand (the V_MIN_F32 rule); omod/clamp via `SetDstF64Bits` -> shared float
  path). Patches + table + all evidence: `GT7_upstream/patches_clean/0001-*.patch`, `0002-*.patch`,
  `f64_trunc_min_NOTES.md`. **PR ON HOLD: AMD publishes no F64 NaN rule.**
- Upstream HAS a GPU unit-test harness: `tests/gcn` (GTest; `TranslateToSpirv(raw u64 insts)` runs
  the real decoder+translator+passes+SPIR-V backend, `gcn_test::Runner` executes it with Vulkan
  shader objects; inputs = 4 u32 push constants mirrored to s0-s3/v0-v3, output = v0). Build:
  `GT7_upstream\build_clean_tests.bat` (Debug, `Build\x64-Clang-Debug-tests`, validation layer on;
  needs `-Wno-character-conversion` for googletest 1.17 + clang 22). Baseline main: 51 pass,
  `bitcmp1_b64_bit32` aborts (pre-existing) - run with `--gtest_filter=-GcnTest.bitcmp1_b64_bit32`.
  After the two commits: 62 pass; a local 1500-pair x 4-mode random run (GPU vs CPU reference) gave
  0 mismatches; spirv-val passes on the dumped modules. Result tests go here, not into game runs.
- **V_TRUNC_F64 is VOP1-ONLY on Sea Islands** (VOP3 map: "407 - 415 reserved"; upstream's VOP3
  format entries 407-415 are empty, the decoder asserts). So TRUNC never has abs/neg/omod/clamp -
  matches this shader, whose TRUNC operand is a separate `v_add_f64 0, -x`.
- WRONG in the first notes, corrected: "mode 3 would have produced DenormPreserve 64 (supported)" -
  vulkaninfo says shaderDenormPreserveFloat64 = false AND shaderDenormFlushToZeroFloat64 = false on
  this GPU. The emitter's "not supported" warnings are `std::call_once`: their ABSENCE near a shader
  proves nothing. Mode 0 of 0x1c0f802e stands on the whole-run log instead (only the "flushing" once-
  warning appears; the non-once "Unknown Float16/64 denorm mode" never does).
- Pre-existing upstream bugs seen (not fixed): F64 ops whose double operands are all constants and
  whose result is not a double register (e.g. `v_cvt_i32_f64 v0, 1.0`) abort in sirit
  (`result_type.value != 0`, stream.h:36) because F64 types exist only with Pack/UnpackDouble2x32;
  VOP3 format entries 401-404 (V_CVT_F32_UBYTE0-3) have Undefined types; the test runner does not
  enable storageBuffer8/16BitAccess (validation errors on every test).
- **clean171_03 (25 Sep 00:12, commit 2 exe SHA256 27be7d2d...,
  `backup_exe/shadps4_clean_65fa8e0c_f64_trunc_min_bits.exe`; fresh profile, empty cache; run 02's
  profile kept as `C:\shadps4-clean-run\user_after_clean171_02`):** 0 LogMissingOpcode, 0x1c0f802e
  translated (log 37952/37960, same pipeline 0x4459a7d1b9af63b0), its blob (80,048 B) and all 218
  cached shaders pass spirv-val; its f64 FMin/Trunc are gone (FMax 1 + Fma 3 left), the integer
  lowering with the mode-0 flush is in; distinct error set identical to run 02 (76); same next
  blocker fs 0x74f5f10c V_INTERP_MOV_F32 (line 41700). Log `logs/shad_log_clean171_03_at_exit_001307.txt`.
- Upstream CONTRIBUTING "A.I. Rules": AI use must be disclosed; descriptions AND COMMENTS must be
  human-written. The comments and commit messages in 2c692b70/65fa8e0c are drafts for the user.
- Known 1.71 facts from earlier runs (lab binary): `SurfaceFormat` assertion data_format=16 (5_6_5) +
  num_format=12 (Ubint) at ~3 min (21 Sep); the offline lane says the emulator dies in ~4 of 5 1.71
  runs within minutes (renderer), and that sceNpAuth* stubs made a polling storm when the online
  sign-in sites were patched (those sites are removed in the current eboot).

---

## 6. Environment and tooling facts

- Active game (since 24 Sep ~23:00, user): `CUSA24767 v01.71` on the clean line, private profile
  `C:\shadps4-clean-run\user`. `CUSA24769 v01.00` is parked (a fresh profile reached Music Rally and
  the Café on the lab build, but not Single Race).
- `run_gt7.ps1` applies defaults with `Set-GtDefault`, and a value already in the environment wins.
  So a wrapper `set GT_X=...` then `call` works end to end; this was verified.
- Watcher: `RUN=NNN bash GT7_upstream/watch_run.sh`, or a per-run copy in the scratchpad with the
  run's tags added to `KEYS`. Re-arm mid-run with `WATCH_RESUME=1`.
- A 25-45 s heartbeat loss with `netctl`/`np_manager` spam is a loading screen. A GPU stall is
  established only by `[gpuwait]`. 358's lasted 27 min with 0 `[gpuwait]` and never recovered:
  the guest itself stopped (post-race Replay screen), which is neither.
- **The game names its own scenes.** With `automation` in APP_ARGS the Rendr thread's TTY carries
  `[stderr] [hh:mm:ss.mmm] [INFO] [__AUTOMATION__] MRenderContext.cpp:3974: EVENT_ROOT
  <Project>::<Root>` (and `FOCUS` lines) with the guest's wall clock. `grep -a EVENT_ROOT` gives
  the whole scene history of a run: dealer visits, purchases, collector levels, map entries,
  races, replays. Use it to confirm a transition before counting it.
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
