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
- **Division of labour for a PR (user, 26 Sep): "i do the pr you just make the branch. always
  remember the rules of main no ai does writing or pushing" / "you will push to our fork not to
  main".** Claude makes the branch from `origin/main` with ONE commit whose message is the TITLE
  ONLY (a body pre-fills the PR description with AI text), pushes it to `mine` only, never to
  `origin`, and hands over facts (branch, hash, diff, tests, measurements). No drafted PR
  description, GitHub comment or maintainer reply. Before a PR: test GT7 + GoW + GoT.
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
41. **Reported the emulator's own default as the guest's register value** (25 Sep, asked for "the
    real per-shader MODE bits"). The cache census said 83 compute shaders = FLOAT_MODE 0x00 and the
    report called that the per-shader value; the user then called the flush finding strong. It was
    zero by definition: `BuildRuntimeInfo`'s Compute case never reads FLOAT_MODE (Initialize
    memsets it, ComputeProgram::settings has no such fields). The cache meta and the emitter's
    warnings both read that same internal value, so they "confirmed" each other. Before calling a
    stored value a measurement of the guest, find the line of code that copies it FROM the guest.
43. **Searched upstream only after the analysis** (25 Sep, V_INTERP_MOV_F32; 42 is in section 5).
    The ISA / CIK register / Mesa research was done before finding that upstream PR #5087 already
    implemented the fix (open, maintainer-reviewed); it was merged the same evening as `23356292`.
    The next blocker's assert turned out to be open issue #5018 as well. First step for any blocker:
    `git fetch origin`, then search open AND merged PRs plus issues for the assert text or the
    function name. With `gh` logged out, `https://api.github.com/search/issues?q=<text>+repo:shadps4-emu/shadPS4`
    works unauthenticated.
44. **Ran Git Bash `sed -i` on a CRLF launcher** (25 Sep, run 09 .bat). It stripped every CR and the
    patterns with backslashes silently did not match, so only one of five edits landed and the file
    became LF. Restored from a copy made first. Edit CRLF .bat files with the Edit tool (it keeps
    CRLF), or write them new and run `unix2dos`; always check `tr -cd '\r' < f | wc -c` = line count.
45. **Drafted an upstream reply that asked a maintainer for a shader dump** (PR #5114, 26 Sep). The
    user posted it; StevenMiller123: "No, we do not allow any shader dump sharing." Never ask for
    or offer a dump upstream; ask for the game and the instruction, give snippets / tests / refs.
46. **Opened an ISA-derived fix as a game fix without checking the game uses it** (PR #5114). The
    body said it "fixes incorrect values"; `scratchpad/f64lit_scan.exe` (GCN2 length walker over
    the `*.bin` dumps, 0 desyncs) later found 0 F64 literals in all 267 GT7 shaders. Scan the
    dumps for the touched encoding BEFORE a PR and state the count.
47. **Handed the user a finished PR description in prose** (26 Sep, trunc-min-f64), and a commit
    body that GitHub would have copied into the PR. The user: "no ai does writing or pushing". Facts
    only, title-only commit, push to `mine` only (section 1).
48. **Trusted a gtest total without the exit code.** On any base with #5034, upstream's own
    `GcnTest.bitcmp1_b64_bit32` dies with 0x80000003 (UNREACHABLE in UConvert) and the run stops at
    test 53 with no `[  PASSED  ]` line, so our two new tests at the end of the file never ran.
    Read the exit code and the `[  PASSED  ] N` summary; when upstream crashes, run the rest with
    `--gtest_filter=-<crasher>` and our tests by name, and say so.
49. **Blamed a log setting for a boot crash on a 3-vs-0 count, before listing every difference**
    (26 Sep, TEST6). `"flush_level": "info"` was the only CONFIG difference from TEST5, so three
    early deaths with it against none in six without it read as a timing effect (the peer and I both
    said so to the user). Run 3 with `""` died identically. The real difference was STATE: the TEST6
    profile had been copied from a run that died seconds after writing its save. The count also
    lumped together crashes with different codes and addresses (TEST4 run 4's 0xc0000096 elsewhere).
    Diff the whole profile against the last known-good starting state, file by file, before
    believing any count.
50. **Called a nonsense descriptor a wrong sharp location without asking whether the draw uses it**
    (26 Sep, TEST8). fs 0x2a265dff's S# decoded as floats, so the note said "wrong flattened
    offsets" and "handling value 3 would only hide it". The offsets were right: the shader samples
    only inside `if (flatbuf[50] != 0)` and every draw had 0 there, so the slot held other data.
    shadPS4 converts every declared descriptor on every draw, used or not. Before blaming tracking,
    read the stage's cached SPIR-V (`spirv-dis` / `spirv-cross` from `C:\VulkanSDK` on
    `cache/<serial>/0x<pgm hash>_<perm>.spv`) for the control flow around the sample, and the flat
    buffer snapshot in its `.meta` (named `HashCombine(pgm_hash, perm_idx)`; tail = u64 count + the
    dwords, then PersistentSrtInfo {walker ptr, size, bufsize} + the x86 walker, which decodes by
    hand) for the value that decides it. Neither needs a run.

---

## 3. Fixes that are proven and must stay

| commit | what | evidence |
|---|---|---|
| `65b03b2f` (branch `pr-lds-stream-commit`) = **UPSTREAM since 23 Sep: PR #5070, `bc028b7c`, in main 19700eba** (`vk_rasterizer.cpp:767`; the worktree `C:\shadps4-pr-lds` no longer exists) | `lds_buffer.Commit();` after the memset in `BindBuffers`' `SharedMemory` branch. `StreamBuffer::Map` without `Commit` left the emulated-LDS region unreserved, and the next small stream copy landed inside it, so the LDS dispatch overwrote it on the GPU. | 345: 2 corrupt indirect-arg tables in 56k plus device lost. After the fix, 264,551 tables with 0 events (346-349), 77,519 of them with the diagnostic barrier off. All 4 events hit records 1/17, which is exactly the predicted `A+16 mod 64` overlap. Still pending before the PR: a Vulkan validation run, GoW/GoT regression. |
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
- `"flush_level": "info"` causes TEST6's early boot deaths. Refuted by TEST6 run 3 (`""`, identical
  death); the cause was the copied save state (section 5, TEST6).
- The 16 flatten `Phi` / `VisitPointer` errors of fs 0xf10530e6 kill the emulator. Refuted by TEST6
  run 4: every recompiler pass finishes; the death is in EmitSPIRV (undefined `sample_index`).
- The mip filter 3 S# of fs 0x2a265dff is fetched from the wrong place (TEST8 note, 26 Sep 22:40), or
  it is a genuine gfx8 POINT_ANISO_ADJ. Both refuted 26 Sep ~23:20: offsets 40-43 are the right
  dwords, but the only samples on that sampler are behind `if (flatbuf[50] != 0)` and flatbuf[50] is 0
  in every snapshot, so the slot holds the draw's other data (five stops, five different values).
  The fix is to survive a garbage S#, not to fetch it differently (section 5, 23:20).

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
- **Series v2 (25 Sep ~00:45, reviewer: move the Float64 test to the commit that uses it, fix the
  runner's feature mismatch or list the VUIDs, measure IEEE_MODE/DX10_CLAMP with a run).** Local,
  nothing pushed; v1 kept as tags `f64-v1-literal` / `f64-v1-trunc-min`, patches regenerated
  (`patches_clean/0001-0003`, v1 in `superseded_v1/`):
  `pr-gcn-test-features` 57ab6276 (runner enables storageBuffer8/16BitAccess) ->
  `pr-f64-literal` 0dd36386 (`if constexpr (is_float)` only + shaderFloat64 + floor test) ->
  `pr-f64-trunc-min` 84e32311 (TRUNC/MIN + `|| operand.type == ScalarType::Float64`). The src tree
  of 84e32311 is byte-identical to 65fa8e0c. No upstream GetSrc64<U64> caller reads a Float64
  operand (grep), so the operand-type test had no user in the literal commit.
  Tests, validation layer on, no repeat limit (`VK_LAYER_DUPLICATE_MESSAGE_LIMIT=100000`): main 51
  pass / 98 errors (49 creations x 2, only VUID 08740); runner commit 51 / 0; literal 52 / 0;
  TRUNC/MIN 62 / 0 (0 warnings everywhere; loader log shows the layer inserted). Negative controls:
  floor literal test fails with upstream translate.cpp; trunc_f64_literal fails without the
  operand-type test (floor still passes).
- **CORRECTION (mistake 41): the compute FLOAT_MODE is never read by the emulator.** The Compute
  case of `BuildRuntimeInfo` sets no fp_* props after the memset, and ComputeProgram::settings has
  no FLOAT_MODE fields, so all compute shaders translate as RNE/flush/flush. "83 compute = 0x00" and
  "0x1c0f802e is mode 0" were that default. Graphics (0xC0) is real. Separate general-fix candidate.
- **clean171_04 PREPARED, not run:** `instr-pgm-modes` 7e70405b (= 84e32311 + `[pgmmode]` log of raw
  PGM_RSRC1/RSRC2 per program under GT_PGMMODE_LOG, before the cache lookup), exe SHA256 3a19e9a8...
  in the RelWithDebInfo folder (copy `backup_exe/shadps4_clean_7e70405b_pgmmode_instr.exe`),
  launcher `GT7_clean171_run04_pgmmode.bat`, warm cache of run 03, profile snapshot
  `user_after_clean171_03`, watcher `RUN=clean171_04 bash scratchpad/watch_clean171.sh` in the
  background. Do not rebuild the RelWithDebInfo folder before the run.
- Static fact for the mode question: 0x1c0f802e has no f64 output modifier (14 FClamp, all f32), so
  DX10_CLAMP cannot touch its V_MIN_F64/V_TRUNC_F64.
- **clean171_04 (25 Sep 06:52:08-06:52:48):** 50 programs logged (21 cs, 29 graphics), ALL with
  FLOAT_MODE 0xC0 / DX10_CLAMP 1 / IEEE_MODE 0; all 21 compute get runtime denorm64 0 against
  register 3 (the compute defect is live). 0x1c0f802e/0x2b96ae5c NOT reached: the run died at the
  first SDRSettingRoot with `vk_presenter.cpp:1113 Device lost during waiting for a frame` (new;
  run 03 passed that screen); in run 03 they ran after PlayGo EventSelectRoot. User screenshot: NO
  TEXT on the StartUpSetting screens. No dumped system fonts in either profile, but GT7 opens ~48
  own fonts via OpenFontMemory + 4 sets on the Noto fallback; metrics fail only for U+254B; 161
  RenderCharGlyphImageHorizontal. Where the glyphs are lost is not established (not one of the 3
  parked font defects). Logs `logs/shad_log_clean171_04_at_exit_065248.txt` + game log.
- **clean171_04b = an UNWATCHED relaunch (06:52:58-06:53:34), archived by hand afterwards**
  (`logs/shad_log_clean171_04b_unwatched_at_exit_065334.txt`): same path, same death at the first
  SDRSettingRoot. Runs 03 (EMPTY cache, 219 compiles) passed that screen; 04/04b (warm, "WarmUp:
  Preloaded 186 pipelines", 0 compiles) died there - the clean line's first warm-cache runs. The
  lab's two upstream preload defects (info from the first record read; half-loaded state on early
  return) are the suspect, not shown. LESSON: a watcher stops at the first exit, so a relaunch is
  unarchived - re-arm the watcher right after every exit.
- **clean171_05 PREPARED** = 04 with an EMPTY cache only: `GT7_clean171_run05_pgmmode_coldcache.bat`,
  profile rebuilt from `user_after_clean171_03` minus cache/log (post-04b profile kept as
  `user_after_clean171_04b`), watcher `RUN=clean171_05` in the background.
- **clean171_05 (25 Sep 08:11:40-08:13:06): NO device lost with the empty cache** - SDRSettingRoot
  passed twice (13 s + 6 s inside), then ResultRoot, PlayGo, EventSelectRoot, BuddyWindowRoot, end at
  the known fs 0x74f5f10c V_INTERP_MOV_F32 assert (line 64888). Cache A/B now: warm 04/04b died,
  cold 03/05 passed; 04 -> 05 changed only the cache. **The fp64 shaders were measured**:
  0x2b96ae5c (rsrc1 0x002c0089) and 0x1c0f802e (rsrc1 0x002c00cd) = FLOAT_MODE 0xC0, DX10_CLAMP 1,
  IEEE_MODE 0, runtime denorm64 0 against register 3. All 187 programs (62 cs) the same modes; all
  62 compute mismatch. Error stems: nothing new against run 03. Closes NOTES section 9 item 2; item 3
  becomes a prerequisite (compute FLOAT_MODE fix before commit 3 is exact in this shader); item 1
  (F64 NaN rule) and 4 (omod) stay open. Text: log cannot show it (462 glyph renders, 03: 454) -
  asked the user. Logs `logs/shad_log_clean171_05_at_exit_081306.txt` + game log; profile snapshot
  `user_after_clean171_05`. CORRECTION on the way: `fp_denorm_mode16_64` also drives the fp16 half of
  `SetupDenormFlushMode` (emit_spirv.cpp:481-512) - it is not only commit 3's input.
- **clean171_06 PREPARED** = 05 with its WARM cache (built by the same exe):
  `GT7_clean171_run06_pgmmode_warmcache.bat` (refuses to start without
  `cache\CUSA24767\0x000000001c0f802e_0.spv`), profile untouched since 05, watcher
  `RUN=clean171_06` in the background.
- **clean171_06 (25 Sep 08:27:59-08:28:41): warm cache (run 05's, same exe, `Preloaded 185`, no
  stale/conflict warning) -> device lost at the first SDRSettingRoot again.** Warm 3/3 died, cold
  2/2 passed. NEW EVIDENCE: the Windows System log has nvlddmkm **Event 153 (GPU reset) twice in
  every warm run, the first within the second the SDR page opens** (06:52:43, 06:53:31, 08:28:34),
  and none in runs 03/05. User: "in the lab tests we had the same problem and we somehow found and
  fixed it" -> checked: the lab's device lost was the LDS Commit bug = upstream now (#5070); the
  lab's text loss was its own GT_STREAM_MEMO (never upstream); `4720205e` fixes the lab's own
  GT_DEFER_EOP deferral (upstream signals EOP/EOS at parse time). None applies to the clean line.
  Upstream preload defects found by reading (NOTES section 15), none yet shown to be the hang:
  (1) `LoadShaderMeta` overwrites `fetch_shader` for every stage, so a GS pipeline keeps the GS's
  empty value - GT7's es 0x72d3a762 (3 vertex inputs) + gs 0x227b3323 draw with no vertex input
  when preloaded (live path keeps only a stage that has data, vk_pipeline_cache.cpp:521); (2) the
  abandoned-record leftovers (lab 2b7cf784, not upstream; did not fire); (3) preloaded SRT walkers
  are outside the fault handler's range and the handler is only registered by a live compile
  (latent, 0 patches ever); (4) dangling `spec.info` for a program's second record (latent);
  (5) `runtime_infos` never filled by the preload but read for `clip_distance_emulation`.
- **clean171_07 PREPARED** = 06 + the LunarG Crash Diagnostic Layer only
  (`GT7_clean171_run07_crashdiag_warmcache.bat`, `config_run07_crashdiag.json` = live config with
  `vkcrash_diagnostic_enabled` true, swapped in and restored by the launcher; the layer runs with
  sync_after_commands). Hang reproduces -> the dump names the command; no hang -> a sync race.
  Watcher `RUN=clean171_07`; copy the layer's dump out of `user\log` by hand after the exit.
- **clean171_07 (08:51-08:53): ROOT CAUSE of the warm-cache GPU hang.** The Crash Diagnostic Layer
  loaded (dump went to its DEFAULT `%USERPROFILE%\cdl\<stamp>\cdl_dump.yaml` - shadPS4's layer
  settings did not reach it: `output_path ""`, `sync_after_commands false`; archived as
  `logs/cdl_dump_clean171_07_085141.yaml`). Last started, never completed: `vkCmdDispatch 4x4x6` on
  `Compute Pipeline cs_0x490b6362`; DeviceFaultInfo: Invalid Read at GPU VA 0x100000. That shader has
  4 cached permutations whose DynamicIndex storage-image mip array is 9 / 1 / 7 / 8 bindings (sampler
  at binding 11 / 3 / 9 / 10). `NumBindings` reads the mip count from `info.flattened_ud_buf` and both
  pipeline kinds size their descriptor layout with it; the live path refreshes that buffer before
  building a pipeline, but `LoadPipelineStage` keeps the establishing record's snapshot and drops every
  later record's, so 3 of the 4 preloaded pipelines got a layout for another permutation. FIX UNDER
  TEST: branch `test-preload-udsnapshot` (7e70405b + `0db8c566`, one line: adopt the record's
  flattened_ud_buf in the existing-program branch); exe 930a1b2a...6197 (backup_exe copy).
  User: "still no font". Text is separate: no font files in the lab profile either; the upstream
  dynamic-ReadConst gap (lab 1cba6562) hits only compute shaders in run 05.
- **clean171_08 PREPARED** = run 06 + the fixed exe only (`GT7_clean171_run08_preloadfix_warmcache.bat`,
  profile restored from `user_after_clean171_05` = run 06's start; after-07 kept). New watcher
  `scratchpad/watch_clean171_shots.sh` (`RUN=clean171_08`) also saves screenshots (3 s after each
  scene + every 10 s) to `logs/shots_clean171_08/` - the user asked for a screenshot after run 07 had
  already exited.
- **clean171_08 (25 Sep 16:17-16:20): the preload fix holds.** Warm cache (`Preloaded 185`), SDR
  opened twice with no device lost, PlayGo, BuddyWindowRoot, end at the known V_INTERP_MOV_F32 assert
  (the cold runs' path); NO nvlddmkm 153 in the System log. User: "the letters still dont show but the
  game progressed". The watcher quit after 5 s (one failed `ps -W` poll ended the loop, 1 screenshot,
  20 KB log) - full log archived by hand (`logs/shad_log_clean171_08_full_162112.txt`); the v2 watcher
  (`scratchpad/watch_clean171_v2.sh`) needs 4 failed polls in a row. Profile `user_after_clean171_08`.
- **F64 PR split (user instruction 25 Sep evening; NOTES section 17)**, branches on upstream main
  e4ca3496: `tests-gcn-storage-buffer-access` 88b44339 PUSHED (validation errors 98 -> 0);
  `f64-literal-high-dword` 11d8b765 PUSHED (new comments removed; test fails without the fix);
  `compute-float-mode` 69818cd1 LOCAL until the GT7 check (names FLOAT_MODE of COMPUTE_PGM_RSRC1 as u64
  fields, BuildRuntimeInfo copies them); `f64-trunc-min` 228bf562 LOCAL and not for a PR (F64 NaN rule
  unpublished, IEEE_MODE and DX10_CLAMP not decoded, omod via float path, needs compute-float-mode).
  Drafts in `patches_clean/pr_drafts/`. Not fixed, own PRs later: compute num_allocated_vgprs is
  `num_vgprs * 4` (graphics `+1`), signed 64-bit literals are zero-extended (ISA: sign-extend).
- **clean171_09 PREPARED** = run 08 + the compute fix: `GT7_clean171_run09_computefloat_warmcache.bat`,
  exe 9098734f... = `test-compute-float-mode` 6d36f830 (0db8c566 + 69818cd1), backup
  `shadps4_clean_6d36f830_computefloat_test.exe`, profile = run 08's end, watcher v2 `RUN=clean171_09`.
- **V_INTERP_MOV_F32 blocker: FIXED UPSTREAM by #5087, merged 25 Sep as `23356292`** (w1naenator,
  reviewed by raphaelthegreat; byte-identical to the squash of PR head be76844d tested here). Root
  cause: upstream treated MOV P10/P20 as raw vertex reads and allowed them only on flat inputs; per the
  Sea Islands ISA 10.3.2 and the CIK SPI_PS_INPUT_CNTL description, LDS holds P0, P1-P0, P2-P0 unless
  passthrough (OFFSET[5] AND FLAT_SHADE) - RADV relies on the same rule. Unit tests: 53/53 on the PR head
  (only the known VUID 08740 lines); negative control (PR tests + main's code, local branch
  `negctl-pr5087-tests-on-main` d231f390) crashes both new tests. Gaps left in #5087, code reading only:
  a default-valued input (OFFSET[5] without FLAT_SHADE) still makes MOV read an undeclared per-vertex
  input; with neither AMD explicit nor KHR barycentric a non-flat P10/P20 still asserts.
- **clean171_10 (25 Sep 23:14-23:15, cold, capture exe `b17b3fcb` = F64 series + `GT_INTERP_LOG`
  instrument, branch `instr-interp-capture`, never for a PR):** fs 0x74f5f10c off 0x0bd8 raw 0xc81e1e00
  = `V_INTERP_MOV_F32 v7, P10, attr7.z` (0x0bd4 = MOV v18, P0, attr7.z). SPI_PS_INPUT_CNTL_7 = 0x7
  (smooth, not default, not passthrough), num_interp 8, ps_input_ena 0x2b03; profile khr_bary=1
  manual=1 amd_explicit=0 (RTX 4070 SUPER). The shader MOVs P0/P10/P20 of attr7.xyz, adds P0 back
  (V_ADD_F32 at 0x0be0/0x0bf0/0x0c24-0x0c30), interpolates z itself with (1-I-J, I, J) from the
  PERSP_CENTER VGPRs (V_MAD_F32 0x0be8/0x0bf4) and converts the x/y vertex values to int: it needs the
  hardware deltas. Dump byte offsets equal the instrument's `off=`.
- **clean171_11 (23:27-23:28, cold, exe `8e358395` = run 10 + #5087; the window title still reads
  b17b3fcb - stale scm_rev - the #5087 assert string inside the binary is the proof):** fs 0x74f5f10c
  translates 65/65 VINTRP (run 10: 20), the IR has exactly 6 FPSub32 on Param7 (vertex1/2 - vertex0),
  SPIR-V 109064 bytes, pipeline 0x1a2b6d556d681efe compiled. **Next blocker: `image_info.cpp:185`
  `ASSERT(!props.is_block)`** (line 184 on upstream 41f2a428), macro-tiled branch of
  `ImageInfo::UpdateSize`, 23:28:08 at PlayGo BuddyWindowRoot, in BindTextures of fs 0x74f5f10c (the
  log shows BindBuffers' clamp for that stage right before; the fs samples 20 images): a BC texture in
  a macro-tiled array mode, never supported - the assert predates #5001, which only turned the other
  macro modes' UNREACHABLE into this assert. Upstream issue #5018 (The Swapper CUSA00315, same assert,
  open since 13 Sep, no PR). The same fs logs 16 SRT-walker failures ("Unexpected instruction for
  offset computation, Phi") but no "Sharp source was not flatenned", so they did not place the T#. A
  V# with num_records 0xFFFFFFFF was clamped (handled). NOT started: the first step is a capture of
  the T# fields (dfmt/nfmt, tile mode, array mode, size, pitch, levels, address) at the assert.
- Dependency, explicit: on plain main GT7 stops earlier at cs 0x1c0f802e (Unknown opcode V_MIN_F64 /
  V_TRUNC_F64 -> EmitControlFlowGraph assert, clean171_01), so every run that reaches fs 0x74f5f10c
  carries the local F64 series (57ab6276/0dd36386/84e32311); #5087 itself does not depend on it.
- Profiles now: `user` = end of run 11; `user_after_clean171_10`; `user_before_clean171_10` = run 09's
  precondition (run 09 never ran). Launchers `GT7_clean171_run10_interpcapture_coldcache.bat` and
  `GT7_clean171_run11_pr5087_coldcache.bat`; watcher `scratchpad/watch_interp.sh` (RUN and EXE from env).
- Mistake 42 (25 Sep): notes commit c8e77542 was pushed EMPTY - the Edit and `commit_mem.sh` were
  sent in one parallel batch, the Edit failed (file not read in this context) and the commit still
  ran. Never batch a commit with the edit it depends on; check `git diff --stat` before the push.
- Upstream CONTRIBUTING "A.I. Rules": AI use must be disclosed; descriptions AND COMMENTS must be
  human-written. The comments and commit messages in 57ab6276/0dd36386/84e32311 are drafts for the user.
- Known 1.71 facts from earlier runs (lab binary): `SurfaceFormat` assertion data_format=16 (5_6_5) +
  num_format=12 (Ubint) at ~3 min (21 Sep); the offline lane says the emulator dies in ~4 of 5 1.71
  runs within minutes (renderer), and that sceNpAuth* stubs made a polling storm when the online
  sign-in sites were patched (those sites are removed in the current eboot).
- **Synced with upstream main 41f2a428 (25 Sep 23:30-23:50; user: "first synch our code with main").**
  +11 upstream commits since 19700eba: #5087 (V_INTERP P10/P20), #5100 (buffer cache memory tracker
  rework + batched uploads), #5106 (logger), #5110 (image validation), #5113 (vk_scheduler on_submit
  before EndSession), #5111, #5104, #5102, #5097, #5094, #5078. No submodule change; the only file
  overlap with our stack is tests/gcn (#5087 appended tests); every patch re-applied with the same
  +/- lines (checked per branch). Local `main` = 41f2a428. `f64-literal-high-dword` = 466af2b1 (the
  user's two GitHub "Sync fork" merges; our patch unchanged). `tests-gcn-storage-buffer-access` =
  70f538ab (merge of origin/main) PUSHED as a fast-forward. `compute-float-mode` rebased = 5db8d018
  LOCAL. `f64-trunc-min` rebased onto the literal branch = 474ccb01 LOCAL. Run stack
  `test-compute-float-mode-41f2a428` 68d953be = main + the six commits of run 09's exe (1f29476d
  runner, b1735da2 literal, e93c2ff8 TRUNC/MIN, 292710f4 GT_PGMMODE_LOG, 2e767aab preload, 68d953be
  compute); exe SHA256 2b675f8c..., backup `shadps4_clean_68d953be_synced_computefloat_test.exe`.
- gcn tests on 41f2a428 (Debug + validation layer; `bitcmp1_b64_bit32` excluded, still exit 3 on
  main): main 53 passed / 98 errors; runner 53/0; literal 54/102; runner+literal 54/0; literal branch
  with main's translate.cpp FAILS the new test (negative control); compute 53/98; TRUNC/MIN + runner
  64/0; run stack 64/0.
- **PR #5114 "Fix F64 literal operand decoding"** (opened by the user 25 Sep 20:08Z from
  `f64-literal-high-dword`, head 466af2b1; CI 10 checks green, 1 skipped). 20:40Z DanielSvoboda
  (Member): "In GTA V, the brightness gets really intense with this PR" (main vs PR screenshots, PR
  overexposed). Not reproducible here: the user does not have GTA V. What the change can touch: only a
  32-bit literal read through GetSrc64<IR::F64>, i.e. VOP1 V_CVT_I32_F64, V_CVT_F32_F64, V_FLOOR_F64,
  V_RCP_F64, V_FREXP_EXP_I32_F64, V_FREXP_MANT_F64, V_FRACT_F64 and VOPC V_CMP_*_F64 (the VOP3 F64
  ops cannot take a literal on GCN2). Before the fix such a literal read as the denormal
  0x00000000_LLLLLLLL, effectively 0.0. Second source for the rule: LLVM
  AMDGPUDisassembler::decodeLiteralConstant shifts the literal left by 32 for OPERAND_REG_IMM_FP64,
  and AMDGPUAsmParser warns "Low 32-bits will be set to zero". Open: which main build the maintainer
  compared (the PR build carries 41f2a428 with #5100/#5110/#5113), and which GTA V shader has an F64
  literal (ask for a shader dump). No known GTA V brightness issue upstream (search, 25 Sep).
- **clean171_12 PREPARED, not launched:** `GT7_clean171_run12_synced_computefloat_warmcache.bat`, the
  68d953be backup exe, profile `user` = end of run 11 (copied first to `user_after_clean171_11`),
  GT_PGMMODE_LOG=1. Expected: no V_INTERP assert, then image_info.cpp:184 at BuddyWindowRoot. Check:
  compute [pgmmode] lines runtime == register (denorm64=3), no GPU reset, whether the letters show.
  Watcher `scratchpad/watch_clean171_v3.sh` (EXE from env) armed with RUN=clean171_12 and that exe's
  path; the v2 watcher (RUN=clean171_09) was stopped. The run 09 launcher now runs its own backup exe
  (the Build dir holds 68d953be now) and its "already running" guard matches any shadps4* image.
- Two sessions share C:\shadps4-clean: this one (F64 / compute / preload; Build/x64-Clang-RelWithDebInfo
  and Build/x64-Clang-Debug-tests) and the V_INTERP / image_info one (Build/x64-Clang-RelWithDebInfo-interp).
  Checkout handover by SendMessage. The peer's next cold capture run is to be clean171_13.
- **clean171_12 (25 Sep 23:57-23:59, WARM, exe 68d953be = main 41f2a428 + runner/literal/TRUNC-MIN +
  GT_PGMMODE_LOG + preload fix + compute FLOAT_MODE):** `WarmUp: Preloaded 184 pipelines`; SDR twice,
  PlayGo EventSelect, BuddyWindowRoot (= the Music Rally screen GT7 offers while PlayGo installs; the
  user saw it drawn, album art and the logo, UI text still MISSING - #5100 did not bring the letters
  back). Ends at `image_info.cpp:184` (the logger rework prints the function as "lambda") = run 11's
  blocker, as expected. **compute-float-mode VALIDATED:** 63/63 cs programs runtime_info == register
  (round 0/0, denorm32 0, denorm64 3; run 05 before the fix: 62/62 got 0); fs 75, vs 48, gs 2, es 1
  also equal. System log: 0 nvlddmkm/Display events 23:56-00:01 (no GPU reset). Error set vs runs
  11/08: only the image_info assert and two pad stubs (scePadInit, scePadSetTiltCorrectionState -
  newly reached code). Logs `logs/shad_log_clean171_12_at_exit_235917.txt` + game log, 28 shots in
  `logs/shots_clean171_12`, profile `user_after_clean171_12`. `compute-float-mode` 5db8d018 PUSHED to
  mine (clang-format clean), draft filled; no PR opened. Watcher re-armed as RUN=clean171_12_rerun
  on the same exe path.
- **PR #5114 thread, 21:03-21:12Z:** the user posted the technical paragraph (with a dump request
  that StevenMiller123 refused: no shader dump sharing upstream). Steven then asked which game this
  fixes and for small shader snippets, and said changing GetSrc64 would mishandle "genuine 64-bit
  literals (if those exist)". Facts for the answer: (1) GT7 1.71 has **0** F64 literals in 267
  dumped shaders (run 11; run 10: 0 in 262) - VOP1/VOPC double sources are 21 V_CVT_F32_F64, 1
  V_RCP_F64, 1 V_TRUNC_F64, all registers; the fix came from the ISA while adding TRUNC/MIN F64,
  not from a bad value in a game. (2) GCN2 has no 64-bit literal: one dword after a 32-bit encoding,
  VOP3 takes none; decode.cpp reads it with one `readu32()` (lines 420/431, only when the encoding is
  4 bytes, line 133) into `u32 InstOperand::code` (instruction.h:90). Draft reply for the user
  offers to close the PR.
- **26 Sep ~18:10 - V_TRUNC_F64 / V_MIN_F64 as its own PR, and a 3-game test before it.** GT7's crash
  on plain main (cs 0x1c0f802e "Unknown opcode V_MIN_F64 / V_TRUNC_F64") is fixed by these two
  alone; #5114 does not touch it. Branch `trunc-min-f64` = **6487aba7** on origin/main **c6b24ec1**,
  pushed to `mine`, title-only commit (same tree as ce445dd1); 5 files +63: dispatch + V_TRUNC_F64
  (FPTrunc) + V_MIN_F64 (FPMin) like V_FLOOR_F64 / V_MAX_F64, runner enables shaderFloat64 when the
  device has it (same lines as #5114), tests `trunc_f64` / `min_f64` (skip without shaderFloat64).
  clang-format 19 (VS-bundled, CI's version) leaves every added line unchanged; CI only lints
  `src/`, and the pre-existing `tests/gcn` files are not clang-format clean. Old local
  `trunc-min-f64-7e0c8111` (f71592ec) = the never-launched run 14 exe.
  **Test build:** local `test-3games-c6b24ec1` **e9125614** = c6b24ec1 + mine/f64-literal-high-dword
  (e591fedd, #5114 with the user's main merge) + compute-float-mode + tests-gcn-storage-buffer-access
  + trunc-min-f64 (one test-file conflict, both sides kept). gcn: 56/56 without the crasher, 0
  validation errors, `floor_f64_literal_is_high_dword` / `trunc_f64` / `min_f64` OK. Exe SHA256
  63ceefa6...01001e55 as `backup_exe/shadps4_test3_e9125614_{gt7,gow,got}.exe` (one copy per game so
  each watcher knows its game); launchers `GT7_upstream/TEST3_{GT7,GOW,GOT}_e9125614.bat` (CRLF);
  profiles `C:\shadps4-test3-{gt7,gow,got}\user`, all COLD (#5112 changed the cache layout without a
  version bump, peer's static finding): gt7 = copy of run 14's profile; gow (CUSA07411) / got
  (CUSA13323) = the clean config with the general log filter, the lab saves, dump_shaders ON.
  Watchers v4 RUN=test3_gt7/gow/got. #4999/#4996 (closed, not merged) are not in it.
  **Upstream bug 1 (#5034, 98bc3205, 24 Sep):** S_BITCMP0/1_B64 -> `ir.UConvert(32, U64)`; UConvert
  has no U64->U32 case -> UNREACHABLE "Conversion from U64 to 32 bits". Its own test crashes on
  c6b24ec1 and on fc5d2cc2 (so not #5112); CI runs `ctest -E 'GcnTest'`. Found with a local-only
  stderr fallback in log.cpp VLog (reverted). `scratchpad/bitcmp_scan.exe`: 0 S_BITCMP*_B64 in 1519
  dumped shaders (GT7 1.00/1.71, GoW, GoT), so it blocks none of our games.
  **Upstream bug 2 (#5112, suspected, static only):** EmitPrologue `!fetch_data` became
  `!fetch_data.Empty()` (Empty() = size == 0), i.e. inverted, for the vertex and the instance offset;
  a VS whose fetch shader takes the offset from the base-vertex SGPR now subtracts BaseVertex and the
  ASSERT_MSG branch is unreachable. Suspect first if geometry breaks on a c6b24ec1+ build.
  **F64 literals (#5114):** `f64lit_scan` 0 in 1131 dumps (GoW 520 shaders, GT7); new
  `scratchpad/f64const_scan.exe` over the pipeline caches (a pre-fix literal = f64 OpConstant with
  high word 0, low word non-zero; checked on a synthetic control): GoW 1860 modules and GoT 28 carry
  no f64 constant at all, GT7 1.71/1.00 one module each with two ordinary doubles. GoT evidence is
  thin; the TEST3 GoW/GoT runs dump every shader for a rescan.
- **26 Sep ~18:50 - the 3-game test is clean for trunc-min-f64.** TEST3 GT7 (18:18-18:20): cs
  0x1c0f802e translates (0 "Unknown opcode"), then `SignalHandler: Unhandled Exception code
  0xc0000005 at 0x700000affb65` (thread Job#33@@Job#063) BEFORE BuddyWindowRoot. A/B **TEST3b** =
  local `test-3games-bitexact-c6b24ec1` c227b3c7 (the TEST3 tree with the bit-exact e93c2ff8
  TRUNC/MIN; exe SHA256 8c381f52...cc85; the scm_rev string only refreshed after a CMake
  reconfigure): BuddyWindowRoot 18:36:06, then `image_info.cpp:184` `ASSERT(!props.is_block)`, the
  end of runs 12/13. **TEST3r** = the TEST3 binary again (`shadps4_test3r_e9125614_gt7.exe`), fresh
  copy of `C:\shadps4-clean-run14\user` (`diff -rq` identical, 0 cache files): BuddyWindowRoot
  18:47:27 -> `image_info.cpp:184`. So the 0xc0000005 came in 1 of 2 runs of the PR exe and is not
  the PR (user: "random crash"). The address is host memory; not a module trampoline (those sit in
  guest memory right after each module, module.cpp:133) and not a #5109 NID stub (each is its own
  page-aligned `Xbyak::CodeGenerator(32, AutoGrow)`, 22 bytes; the fault is 0xb65 into its page).
  If it comes back: archive, compare RIP and thread. New `scratchpad/f64op_scan.exe` (the bitcmp
  walker; control cs 0x1c0f802e = 1 VOP1 V_TRUNC_F64 + 1 VOP3 V_MIN_F64): GoW 0 in 51 and GoT 0 in
  75 TEST3 dumps; in the 1080 older APPDATA dumps only GT7 1.00's copy of the same shader (cs
  0xa911a841, CUSA24769); 0 desyncs. The PR's code never runs in GoW/GoT: GoW's stop is
  `DS_ORDERED_COUNT` (known upstream gap), GoT's silent exit is unexplained and not this PR. The PR
  decision is the user's.
- **26 Sep ~20:20 - TEST4 / TEST5: the image_info.cpp:184 assert is stale; the next stop is fs
  0xf10530e6.** TEST4 = local `test-bcmacro-a099dce8` 8bc5639f (TEST3r tree + merge of a099dce8 +
  ONE commit deleting `ASSERT(!props.is_block)` in `ImageInfo::UpdateSize`; exe SHA256
  6ad1b223...10c0, PDB kept in `backup_exe\pdb_test4_8bc5639f`). Cold run 1: no Critical at all,
  `Creating tiling pipeline ThinThinPrt_128 detiler` (the BC7 1024^2 texture of fs 0x74f5f10c goes
  through the macro detiler), 7 more draws, then `Compiling fs shader 0xf10530e6` + its 16
  `ComputeOffset ... Phi` / `VisitPointer: Failed to compute offset for SRT walker` (line 613, the
  balanced `continue` path), and the process dies with **0xC0000409** (-1073740791) before the next
  shader compile starts. It is not an assert: the recompiler has no `throw` at all, every failure
  there is an ASSERT that logs and flushes. TEST5 (below) reproduced it twice at the same point, so
  3 of 3 runs that reach this shader die there: all 16 Phi pairs are logged, no `:597` (the
  unbalanced PushPtr failure path), and no other GpuCommandProcessor line follows before the end
  (the second TEST5 console, pasted by the user, shows the same). The BC7 image itself was never on
  screen (no frame).
  **The log file loses up to 4 KB at a crash**: the logger is a synchronous spdlog logger with
  `flush_on` unset (`"flush_level": ""`), so the file is written in 4096-byte blocks (942x4096 and
  1042x4096 exactly). The console sink is unbuffered: `scratchpad/conread.exe <pid> <out>` (new,
  read-only AttachConsole + ReadConsoleOutputCharacter) read the launcher's console after the exit
  and showed the last lines (Job#7 font calls) and the exit code. No WER dump or event either:
  `emulator.cpp:75` sets `SEM_NOGPFAULTERRORBOX`. The exe is not CETCOMPAT. The lab (runs 341-348)
  handled this shader with a dynrc window for the 16 unresolved offsets and loop_wrap_guard; upstream
  has neither, so a TDR may follow even once the host death is fixed.
  Warm runs 2 and 3 of TEST4 and the TEST3r exe on its own warm profile all died at
  `StartUpSettingProject::SDRSettingRoot` with "Device lost during waiting for a frame" and nvlddmkm
  event 153: the old preload bug (clean171_04/04b/06), because our fix 2e767aab/0db8c566 was NOT in
  the TEST3/TEST4 tree. **TEST5** = `test5-preload-bcmacro` f13bf337 = 8bc5639f + cherry-pick of
  2e767aab (exe SHA256 d36f00d8...4a41, PDB in `backup_exe\pdb_test5_f13bf337`) on an exact copy of
  the runs-2/3 warm profile: past SDRSettingRoot with 0 device lost and 0 GPU events, to
  BuddyWindowRoot, then the same 0xC0000409 after fs 0xf10530e6. So the preload fix works on this
  tree. Cold run 4 of TEST4 (flush_level "info") died earlier, at PlayGoProject::TopRootWindow:
  `Unhandled Exception code 0xc0000096 at 0xdb4443d` (privileged instruction, Job#8, eboot+0x26e443d)
  - the same phase as TEST3's 0xc0000005; 2 of the 5 cold runs of this tree died there, 0 of 6
  earlier cold clean171 runs (not significant yet). Guest code is not looked at (rule 34).
  Logs `shad_log_test4_gt7{,_2,_3,_4}_at_exit_*`, `shad_log_test3r_gt7_2_at_exit_195422.txt`,
  `shad_log_test5_gt7_at_exit_201902.txt`, `console_test5_gt7_at_exit.txt`.
- **26 Sep ~21:50 - TEST6: the 0xC0000409 at fs 0xf10530e6 is Sirit's `std::abort()` on an
  undefined SPIR-V id; `sample_index` is never defined when an earlier barycentric input already
  created `bary_coord`.** TEST6 = local `test6-passtrace` d4461c4e = TEST5 + ONE instrument commit
  (`GT_PASSTRACE=<hash>` logs and flushes one line per compile step of that one program; exe SHA256
  001ca2d9...14a2, PDB in `backup_exe\pdb_test6_d4461c4e`), with `scratchpad/crashcatch.exe`
  attached from the PlayGo event list. Runs 1-3 died at boot (below); run 4, with the save
  restored, reached Music Rally. Last trace line: `CompileModule: TranslateProgram returned,
  emitting SPIR-V` - every recompiler pass finished, so the 16 flatten Phi lines are not the cause.
  crashcatch: second-chance 0xC0000409 on `shadPS4:GpuCommandProcessor`, FAST_FAIL code 7 (abort);
  stack `ucrtbase!abort` <- `Sirit::Module::OpLoad` (memory.cpp:23) <- `EmitGetAttribute`
  (emit_spirv_context_get_set.cpp:152) <- `EmitSPIRV` <- `CompileModule:634` <- `GetProgram:672` <-
  `RefreshGraphicsStages` <- `Rasterizer::Draw`. Sirit's `Stream::operator<<(Id)` (stream.h:158-161)
  calls `std::abort()` with no message on id 0. Line 152 is the non-AMD `BaryCoordSmoothSample`
  path, `OpInterpolateAtSample(F32[3], bary_coord, OpLoad(U32[1], sample_index))`. In
  `spirv_emit_context.cpp:411-419` `sample_index` is defined only inside `else if
  (supports_fragment_shader_barycentric && !ValidId(bary_coord))`, so an earlier BaryCoordSmooth /
  PullModel / SmoothCentroid load leaves it 0 (unless SampleIndex itself is loaded). RTX 4070 SUPER:
  `VK_KHR_fragment_shader_barycentric` enabled (`vk_instance.cpp:302` sets the profile flag from it),
  `VK_AMD_shader_explicit_vertex_parameter` unavailable. Upstream bug from #4401 (ff62c995, 19 Aug),
  unchanged on origin/main 41c0fca5; the peer confirmed it independently. The capability side is
  right (`emit_spirv.cpp:336-342`) and PullModel's frag_coord is defined on its own. Not proven
  directly: which other barycentric input fs 0xf10530e6 loads (no dump of that shader, no cdb for the
  minidump `logs\crashcatch_test6\crash_c0000409_tid7844.dmp`). **TEST7** = `test7-sampleindex`
  738d4095 = TEST6 + ONE fix commit (on the KHR path, define `bary_coord` and `sample_index`
  independently; clang-format clean), profile `C:\shadps4-test7-gt7\user` = the TEST6 profile at
  save state A, launcher `TEST7_GT7_738d4095_sampleindex.bat`; exe
  `backup_exe\shadps4_test7_738d4095_gt7.exe` SHA256 1a4ccfac...3615, PDB in
  `backup_exe\pdb_test7_738d4095`; same `GT_PASSTRACE=0xf10530e6` and the same crashcatch trigger as
  TEST6 run 4 (out `logs\crashcatch_test7`).
  **TEST7 run 1 (22:10:54-22:12:25): the fix works.** The passtrace of fs 0xf10530e6 now goes on:
  `EmitSPIRV returned, 28362 words` -> `CompileSPV returned` -> `CompileModule done` -> `GetProgram:
  program registered`; pipeline 0xa7aab6555cdf326b built; Music Rally started (game log `start vehicle
  ... ON START` at 22:11:58, then BuddyDummyRoot / BuddyWindowRoot). 26 s later a NEW, different
  stop: `liverpool_to_vk.cpp:394 MipFilter: Unreachable code!` (crashcatch: first-chance 0x80000003 on
  GpuCommandProcessor, `assert_fail_impl` <- `LiverpoolToVK::MipFilter` <- `Sampler::Sampler`
  (sampler.cpp:46) <- `TextureCache::GetSampler` <- `Rasterizer::BindTextures` (vk_rasterizer.cpp:957)
  <- `Draw`; exit code 0x80000003; dump `logs\crashcatch_test7\crash_80000003_tid29440.dmp`), right
  after `Compiling fs shader 0x2a265dff (permutation)` and `Compiling graphics pipeline
  0xce66d4cfbb5f7539`. `mip_filter` is `BitField<26, 2>` with only None/Point/Linear, and the fields
  evaluated before it (two `Filter`, `BorderColor`) cover all their 2-bit values, so the S# had
  mip_filter == 3 (GNM defines 0-2 only; MIP is the one S# field a random value can trip, 1 in 4).
  Not new: the 13-14 Sep builds and the other lane's 21-22 Sep builds logged `[softclamp] invalid S#
  mip filter 3 - defaulting to Linear` 55-93 times per run and ran on. Open: genuine S# data or a
  wrongly fetched one. The sampler comes through `sharp_fetch.Fetch(flattened_ud_buf)`. #5129
  (41c0fca5, the only commit between a099dce8 and main) stops `ConstructSharpFetch` turning an
  Invalid sharp into SingleLoad, but this run logged `Sharp source was not flatenned` only for cs
  0xad74a520 (x32) and cs 0x40d317f7 (x8), not for fs 0x2a265dff. Logs
  `shad_log_test7_gt7_at_exit_221238.txt`, `game_log_test7_gt7_at_exit_221238.txt`, report
  `crashcatch_test7\crashcatch_report_run1.txt` (6918 first-chance 0xc0000005 while attached, the
  normal kind; TEST6 run 4 had 4120).
  The run wrote a new save (DRFILEIV.dat 22:11:19, memory.dat 22:11:50 + backup 22:11:53; md5
  ad61697f / 62b3eef5 against state A's aec8a874 / ca8ecb83) = "state E", copied to
  `C:\shadps4-test7-gt7\stateE_backup_after_test7_run1`, plus 826 cache files (628 -> 1454). So the
  TEST7 profile is no longer state A; the next run starts from a fresh copy of
  `user_warm_after_runs1to3`. Mesa's AMD register DB (`src/amd/registers/gfx*.json`):
  SQ_TEX_MIP_FILTER is NONE/POINT/LINEAR on gfx7; gfx8 and gfx9 add 3 = POINT_ANISO_ADJ (this profile
  runs with neo_mode false). Per the peer: gt7-main softclamped it to Linear as a "torn GPU-driven
  S#" (e5c2634f, never proven), and GitHub has 0 upstream issues/PRs for it.
- **26 Sep ~22:40 - TEST8: the mip filter 3 S# is not a sampler; it is shader constants read at the
  sampler's flattened offsets.** [WRONG CONCLUSION, see the 26 Sep ~23:20 entry and mistake 50: the
  location is right; the draw never samples, so the slot holds unrelated data.] TEST8 = local `test8-main41c0` a3eb4339 = TEST7 merged with main
  41c0fca5 (3ffa23e7, so + #5129) + ONE log-only instrument commit (`GT_SAMPLERDUMP=1`: in
  `Rasterizer::BindTextures`, a stage whose fetched S# has mip_filter > 2 logs every sampler's dwords,
  decoded fields and SharpFetch, then flushes); exe `backup_exe\shadps4_test8_a3eb4339_gt7.exe` SHA256
  0a3dd1ea...8a02, PDB `backup_exe\pdb_test8_a3eb4339`, profile `C:\shadps4-test8-gt7\user` = fresh
  copy of state A; built and set up by the peer. Run 1 (22:38:36-22:39:54) stopped at the same
  `MipFilter: Unreachable code!` (22:39:53), right after `Compiling fs shader 0x2a265dff (permutation)`
  and pipeline 0xfa76150f7858eb39, so #5129 does not fix it. `[samplerdump] stage 0x2a265dff: 1
  sampler(s), flatbuf 51 dwords`; `#0 dw 3f540000 3c192437 3e5ca3b2 3acbd902 | summary 0 (SingleLoad)
  mask 0xf off 40 41 42 43`, no immediates. Those four dwords are floats (0.828, 0.0093, 0.216,
  0.0016) and the decoded fields are nonsense (min_lod 1079 > max_lod 402, lod_bias 9138, border_ptr
  2306). So handling value 3 (the old softclamp) would only hide a wrong sharp location; the question
  is why this permutation's sampler resolves to flatbuf dwords 40-43. The run wrote a new save
  (DRFILEIV 22:39:00, memory.dat 22:39:23; md5 4c0ade4e / ca8df9ab) and cache 628 -> 1434, so this
  profile is not state A any more either (no backup copy: the user stopped it). Logs
  `shad_log_test8_gt7_at_exit_224006.txt`, `game_log_test8_gt7_at_exit_224006.txt`,
  `crashcatch_test8\crashcatch_report_run1.txt` + `crash_80000003_tid31980.dmp`.
- **26 Sep ~22:50 - the sample_index fix is on a PR branch (made and pushed by the peer; the user
  opens and writes the PR).** `bary-smooth-sample-index` 12d41c22 on origin/main 41c0fca5, pushed
  only to `mine`: one title-only commit "shader_recompiler: Define SampleId for BaryCoordSmoothSample
  on the KHR path", author and committer the fork identity, diff = spirv_emit_context.cpp +5/-3, blob
  95853db7 = the 738d4095 blob that ran in TEST7 and TEST8 (checked read-only here). clang-format
  clean; no upstream issue or PR for this bug (only #4401 matches "sample_index"; the open barycentric
  PR #4863 does not touch the file). Regression argument (peer): `sample_index` for
  IR::Attribute::SampleIndex is defined earlier (line 368) and both `!ValidId` guards stay, so every
  shader that compiled before emits identical SPIR-V; only shaders that used to abort change. Open,
  for the user: the three-game check. GT7 on main + this fix alone stops earlier, at
  image_info.cpp:184; GoW on main stops at DS_ORDERED_COUNT. TEST3's GoT death (log cut at 184320
  bytes, no assert) has the same silent fast-fail signature, so a GoT run on this branch could tell.
  **The boot deaths of TEST6 runs 1-3 were the save, not the build.** All three:
  `BootProject::TopRootWindow`, thread Updat, guest 0xc0000005 at the same eboot-relative address,
  each right after one ADHOC `nil object cannot be used in '(nil).np'` line
  (gt7/network/Environment.swift:12, init_network.ad:33) that is in none of the other 10 clean
  archives. Profile diff against TEST5 run 1's starting state
  (`C:\shadps4-test4-gt7\user_warm_after_runs1to3`, "state A"): only `APP_DATA/logs/archived.log` and
  the saves `DRFILEIV.dat` + `sce_sdmemory/memory.dat` (+ backup), written by TEST5 run 2 between
  20:25:00 and 20:25:32, seconds before its own 0xC0000409 ("state C"). `temp/` differs too, but
  shadPS4 wipes it on every boot (`emulator.cpp:604-608`). Run 4 with state A booted. State C is kept
  in `C:\shadps4-test6-gt7\stateC_backup_after_test5_run2`, run 4's save in
  `...\stateD_backup_after_test6_run4`; the TEST5 profile still holds state C. Why the game dies on
  state C is a separate, parked question (guest side, rule 34).
  Logs `shad_log_test6_gt7{,_2,_3,_4}_at_exit_*` (run 2 archived by the peer), crashcatch reports in
  `logs\crashcatch_test6`. `APP_DATA/logs/archived.log` is the game's own log of the last run that got
  far enough to write it: `game_log_test6_gt7{,_3}_at_exit_*` are TEST5 run 2's.
  Upstream main moved to 41c0fca5 "Fix ConstructSharpFetch (#5129)": it moves `summary =
  SingleLoad` inside the `!= Invalid` block, the #5112 bug the peer had reported. A PR branch for the
  sample_index fix starts from 41c0fca5.
- **26 Sep ~23:20 - root cause of the MipFilter stop: the S# is read correctly, the sampler is UNUSED
  in that draw, and its slot holds whatever the draw put there. MaxAniso is the second assert on the
  same path.** The user ran TEST7 run 2 (23:11:43-23:12:47, from the state E save) and TEST8 run 2
  (23:12:57-23:13:55, from TEST8 run 1's save); both booted and started Music Rally, so neither run-1
  save is a boot killer. TEST7 run 2 stopped at `resource.h:494 MaxAniso: Unreachable code!`
  (crashcatch 0x80000003, `Sampler::Sampler+0xa41` sampler.cpp:17 <- `GetSampler` <- `BindTextures`
  vk_rasterizer.cpp:957; `crashcatch_test7\crashcatch_report_run2.txt` + `crash_80000003_tid24928.dmp`)
  right after `Compiling fs shader 0x2a265dff (permutation)`. sampler.cpp:14-18 (identical in 738d4095
  and a3eb4339, as is resource.h) call `MaxAniso()` only when the mag or min filter is AnisoPoint /
  AnisoLinear. TEST8 run 2 stopped at MipFilter again; samplerdump `#0 dw bf3c1a20 3ee5c348 3f000000
  3f800000` (-0.735, 0.449, 0.5, 1.0), same SingleLoad off 40-43, max_aniso 5 but mag 0 / min 0 (so
  MaxAniso was skipped), mip 3. It never compiled 0x2a265dff (both permutations came from run 1's
  cache) and still died: the permutation compile is not a precondition, it is what the first garbage
  draw looks like on a cold cache. Logs `shad_log_test{7,8}_gt7_2_at_exit_{231258,231408}.txt`,
  `game_log_...`, `shadps4log_...`; profile copies `shad_log_moved_after_test{7,8}_run2.txt`; both runs
  wrote new saves (not backed up) and more cache files.
  The peer's analysis (read-only, TEST7/TEST8 caches): the perm-0 meta's walker has ONE root s[0:1] = P
  copying P[0..34] into flatbuf[16..50], so offsets 40-43 = P[24..27], a plain direct load; in the
  cached 0x2a265dff_0/_1.spv both `OpImageSampleImplicitLod` on fs_samp0 sit inside `if (flatbuf[50]
  != 0)` (P[34]); every snapshot has flatbuf[50] = 0, and P[8..27] is a union (V#, T#s, floats or zeros
  by draw). shadPS4 builds a VkSampler for every declared S# at every draw, so the garbage reaches
  `LiverpoolToVK::MipFilter` / `Sampler::MaxAniso` and their default UNREACHABLE. Checked here,
  byte-exact: TEST8 `cache\CUSA24767\0x000002a32c9f9266.meta` (22:39:52) holds flatbuf[0..50] at byte
  7441 with [40..43] = 3f540000 3c192437 3e5ca3b2 3acbd902 = the run-1 samplerdump, [48..49] = 0x780 /
  0x438 (1920x1080) and [50] = 0; TEST7 `...9263.meta` (23:12:45, the MaxAniso draw's new permutation)
  has [40..43] = 3eaaaaab 3eaaaaab 3eaaaaab 00000000 = (1/3, 1/3, 1/3, 0) -> max_aniso 5, mag 2, min 2,
  mip 3, degamma 0 - and [50] = 0. Five stops, five different values at the same four dwords (TEST7 r1
  MipFilter, TEST8 r1 MipFilter, TEST7 r2 MaxAniso, TEST8 r2 MipFilter). Degamma 0 in 9263 means that
  permutation key was changed by some other field of the union, not by degamma as first thought.
  Fix (peer, local, NOT pushed): `mip-filter-point-aniso-adj` 9c91a45c on origin/main 41c0fca5, one
  title-only commit "video_core: Handle unknown sampler mip filter and aniso ratio values", +8/-1:
  `MipFilter::PointAnisoAdj = 3` warns and falls through to Point; `MaxAniso()`'s default warns and
  returns 16.0f. TEST9 = `test9-mipfilter` 531a5a70 = a3eb4339 + that commit, fresh state-A profile
  `C:\shadps4-test9-gt7`, `GT_SAMPLERDUMP` unset (the draw survives now, so it would fire every draw).
- **26 Sep ~23:30 - TEST9 built and set up (the peer, i.e. gtnikos-cc), waiting for the user's run.**
  Forced-reconfigure build of 531a5a70: CMAKE_EXIT=0, NINJA_EXIT=0, scm_rev `test9-mipfilter` /
  `v.0.18.0-172-g531a5a70`, both warning strings present in the binary. Exe
  `backup_exe\shadps4_test9_531a5a70_gt7.exe` SHA256 99cb1259...50bf9, PDB
  `backup_exe\pdb_test9_531a5a70` (167a6533...9f4d). Launcher
  `GT7_upstream\TEST9_GT7_531a5a70_samplerfields.bat` (CRLF) = TEST8's with the exe and rundir swapped and
  `GT_SAMPLERDUMP` removed (`GT_PASSTRACE=0xf10530e6` kept). Profile `C:\shadps4-test9-gt7\user` = fresh
  copy of state A (diff -rq identical, 628 cache files, flush_level "", neo_mode false). What to read
  after the run: "Unimplemented mip filter" / "Unimplemented anisotropy ratio" lines, one per NEW
  garbage S# (the sampler cache is keyed by the raw S#), then whether Music Rally renders and runs.
  Same class, still open and not observed: (a) the custom border colour read in sampler.cpp:27-43 when
  dword3[31:30] == 3 and the device supports custom border colours (the 4070 SUPER does). It reads
  `(ta_bc_base.base_addr << 8)[border_color_ptr]` with a garbage 12-bit index. If GT7 never writes
  TA_BC_BASE, that is a host 0xC0000005 inside `Sampler::Sampler` with NO assert, so recognise that
  signature. All five garbage S#s so far had type 0. (b) garbage min_lod > max_lod violates the
  Vulkan rule maxLod >= minLod. (c) `LiverpoolToVK::FilterMode` has UNREACHABLE on 3 but no callers. The
  fix style follows #5058 (BrushXor, Stephen Miller, 20 Sep) and #1007 (clamp modes). Every S# with
  mip 0-2 and ratio 0-4 takes exactly the old code path, so nothing that worked can change. GitHub
  search found no upstream issue or PR about MipFilter / mip filter.
- **26 Sep ~23:40 - TEST9: the mip/aniso fix holds, and every launch now dies at signature (a), the
  custom border colour read with TA_BC_BASE = 0. PR branch pushed (user's decision).** The user
  launched TEST9 three times (23:30:36-23:31:55, ~23:32:00-~23:32:55, 23:33:3x-23:34:06). All three:
  host 0xC0000005 at `Sampler::Sampler+0x164` (sampler.cpp:27, the custom_color lambda) <- `GetSampler`
  <- `BindTextures` (vk_rasterizer.cpp:1014), no assert. Launch 1 read 0x7d10: the draw that compiled
  0x2a265dff permutation meta `...9263` (23:31:54) carried S# 43e5f818 42e77c4c c3a8e169 c14c77d1
  (459.0, 115.7, -337.8, -12.8) = border_type 3, ptr 2001, and 2001*16 = 0x7d10 exactly. Launch 3 read
  0x400 (ptr 64); the permutations came from the cache and its 4.3 MB log has 0 fix warnings (its first
  garbage S# already had type 3). Launch 2's log was LOST: the user relaunched within the watcher's
  exit check (`running()` = 4 misses 2 s apart, then 2 s, then the copy), so the new launch truncated
  shad_log.txt first; its snapshots show both fixed paths ran without an assert: `...9262` (23:32:53,
  S# 3f700000 bf700000 3f700000 3f800000, mip 3) with the process alive a second later, and `...9261`
  (23:32:54, S# 437ebeb8 c0975c17 c327ddb8 c1202352: aniso 7 with mag AnisoPoint, border_type 3, ptr 850
  -> 0x3520 expected, unmeasured). All 7 TEST9 snapshots (9261-9267) have flatbuf[50] = 0. Launch 1's
  9263 has a valid aniso ratio (4) and mip (0), so this border read was reachable in TEST7/TEST8 too;
  the fix did not create it. No direct "Unimplemented ..." warning line exists in any saved log (launch
  2's is gone), so the evidence that the fixed paths ran is the snapshots plus the process surviving.
  Artifacts: `crashcatch_test9\crashcatch_report_run1.txt` + `crash_c0000005_tid4752.dmp`,
  `crashcatch_report_launch3.txt` + `crash_c0000005_tid28460.dmp`, `shad_log_test9_gt7_2_at_exit_233419.txt`
  (= launch 3), `shad_log_test9_launch2_first80KB_copied_233207.txt` (the start of launch 2 only; the
  watcher had named it launch 1's exit log), profile copy `shad_log_moved_after_test9_launch3.txt`;
  watcher + crashcatch re-armed as RUN=test9_gt7_4.
  User's decision: a PR for the mip/aniso fix if it is clean; the peer reviews and fixes the border
  crash. Checks, then push: origin/main still 41c0fca5; MipFilter / MaxAniso have no other users than
  liverpool_to_vk.cpp:385-397 and sampler.cpp:18/50 (shader_recompiler/resource.h:189/200 only assign
  AnisoRatio::One); clang-format 22 clean with `src/.clang-format` (the CI uses 19); 0 whitespace
  errors. `mip-filter-point-aniso-adj` 9c91a45c pushed to `mine` only (origin has no such branch).
  Precedents checked on GitHub: #1007 "vulkan: Use closest available equivalent to missing clamp
  modes." (merged 2024-09-22, +10/-0) and #5058 "Render.Vulkan: Stub logic op 0x5a" (merged
  2026-09-20, +5/-0). The peer found that gt7-main already guards this read (mapped-entry check,
  black otherwise) and is writing the clean version; its TEST10 bat archives shad_log.txt itself before
  launching.

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
- `scratchpad/crashcatch.exe <image> <log> <trigger> <out dir> <pdb dir>` (26 Sep): attach-only
  debugger (DebugActiveProcess, KillOnExit off). It waits for <trigger> in the log, passes every
  first-chance exception back, and on a fast fail or any second-chance exception writes the
  exception record (with the FAST_FAIL code name), a symbolized StackWalk64 of the faulting thread,
  every thread's top frames and a minidump into `<out dir>\crashcatch_report.txt`. It exits when the
  process ends, so re-arm it after every run like the watcher, and move an old `shad_log.txt` that
  contains the trigger out of the way first or it attaches during boot. Validated on
  `ffail_test.exe` (codes 2 and 7). A 0xC0000409 cannot be caught in-process, and
  `emulator.cpp:75` (`SEM_NOGPFAULTERRORBOX`) leaves no WER dump; this is the only way to see it.

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
