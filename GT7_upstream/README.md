# GT7 on upstream - the lane that fixes causes instead of stubbing them

Started 11 Sep 2026. Everything this lane needs is in this folder; nothing outside it belongs
to it.

## STATE ON 22 SEP 2026 - READ THIS FIRST

The sections after this one describe the lane as it stood on 10-11 Sep. They are still right
about the rules, the build and the traps, and out of date about GT7's state. What happened since:

### The result: one general fix, PR-ready

`StreamBuffer::Map` without `Commit` in the `BufferType::SharedMemory` branch of
`Rasterizer::BindBuffers` (`vk_rasterizer.cpp`). Map selects a ring region and waits for it to be
free; Commit reserves it (flush on non-coherent memory, cursor advance, completion watch). Without
Commit the next `Copy` on the same 64 MB stream ring (small read-only guest buffers taken through
`ObtainBuffer`) reused the bytes backing a compute shader's emulated LDS. GT7 runs a 64 KiB-LDS
compute shader every frame next to the compute shader that builds indirect-draw argument tables
from stream-copied inputs: records came out absurd (indexCount above 2^24, at indices 1 mod 16),
the huge indirect draws stalled the GPU for seconds and ended in device loss; distant objects
showed "flying" colours. Full write-up, PR title and description: `PR_lds_stream_commit_notes.md`.

| where | what |
|---|---|
| `C:\shadps4-pr-lds`, branch `pr-lds-stream-commit` | ONE commit `65b03b2f` on upstream `main` `37cacc59`: diff +1 line `lds_buffer.Commit();`, no comment, no `GT_`, no trailer. **Not pushed.** `git -C C:\shadps4-pr-lds push -u mine pr-lds-stream-commit`, then open the PR against `shadps4-emu/shadPS4` `main`. |
| `C:\shadps4-gt7`, branch `gt7-main` | `b1cd966e` = our fork merged with upstream `4621b6a1` (21 Sep). Carries the same fix (`4ca72e6c`) plus the run-341..346 observers, default ON: `[csin]` (hash 0x6179cfdd), `[csout]` capture, `[ldsring]`. They are instruments, not fixes: strip them or default them off before anything else leaves this tree. 170 distinct `GT_*` identifiers in `src` today. |
| `C:\shadps4-pr`, branch `pr-descriptor-dword-mask` | older PR worktree from a previous session: 9 dirty files and an 89-file diff against today's upstream. Review before use; this session did not touch it. |

### Evidence (all CUSA24769 v01.00, probe `GT7_probe317_offline.bat`)

| run | date | binary | tables of cs 0x6179cfdd | events | ended by |
|---|---|---|---|---|---|
| 345 | 20 Sep | observers, without the line | 56,037 | 2 absurd + device lost at 817 s | device lost |
| 346 | 21 Sep | same binary + `Commit()` | 152,011 | 0 | closed by hand, 1,337 s |
| 347 | 21 Sep | merged b1cd966e, capture on | 35,021 | 0 | `resource_patching_pass.cpp` UNREACHABLE (parked 1) |
| 348 | 22 Sep | b1cd966e, `GT_CSOUT_CAPTURE=0` | 7,508 | 0 | `SurfaceFormat` assert (parked 2) |
| 349a | 22 Sep | same | 32,502 | 0 | closed by hand |
| 349b | 22 Sep | same | 37,509 | 0 | guest crash from the fault loop (parked 3) |

264,551 tables after the fix, 0 events; 77,519 of them with the diagnostic post-dispatch GPU copy
and its global barrier off. The owner closed testing on 22 Sep with the 100k capture-off target not
reached. Not done: Vulkan validation run, GoW 2018 / Ghost of Tsushima regression, a standalone
reproducer, a local build of the PR worktree (its submodules are empty; the identical line is built
and run in gt7-main). Logs: `logs/shad_log_run34[5-9]*.txt`; minidump `logs/run349b_guest_crash.dmp`.

### Parked issues - each classified, none investigated, none is the LDS mechanism

1. **`resource_patching_pass.cpp` `PatchImageSampleArgs` UNREACHABLE**: the image-coordinate
   `switch(view_type)` has no case for Cube / Color2DMsaaArray / Invalid. Hit while compiling a
   permutation of vs `0x1aecf752` during the Autodrome Lago Maggiore load. Code byte-identical in
   4ca72e6c / upstream / merged: input-driven, not a merge regression.
2. **`liverpool_to_vk.cpp:794 SurfaceFormat` assert** with `num_format=12` (Ubint) and a data
   format it never pairs with: `40` (Bc6) in 1.00 while loading the Menu Book race after the Cafe
   (run 348), `16` (5_6_5) at boot of the 1.71 dump. Table and lookup are identical across the three
   trees and Bc6 pairs only with Unorm/Snorm in hardware, so something that is not a descriptor
   reaches `SurfaceFormat()`. Not dump-specific, not merge.
3. **Guest thread `PCL Event` polls `0x1000fffd80`**, a GPU-tracked page under precise readbacks
   (`GT_READBACKS_ONRACE=2`), at about 20 Hz; every read is a fault. Our `BreakFaultLoop`
   (`page_manager.cpp:636`, SignalImpl) forces the page RW after 4,096 consecutive faults; when
   the streak restarts it REFUSES and the guest dies (`0xC0000005` at `eboot.bin+0x3b590e0`, run
   349b, t=434 s). The first streak already exists in 346 (pre-merge, 564 s) and in 349a: pre-existing,
   time-dependent, our code. Fix direction: a page that left a fault loop must not be read-protected
   again, or readback without re-protect for poll patterns; never the address.

Also seen, not chased: `sceJpegDecDecode` rejects `jpeg_mem_size=0` (garbled loading thumbnails,
zero successful decodes in any run); striped garbage in the sky at race intros (the known
wrong-texture class).

### Game dumps and the other chat

- `CUSA24769 v01.00` is this lane's game. `CUSA24767 v01.71` (arrived 21 Sep) is parked until the
  offline-patch chat (`C:\GT7_offline`, probes `GT7_probe348_171.bat`..`350_171`, `run_gt7_171.ps1`)
  makes it boot. Both dumps live under `CUSA24~*` 8.3 aliases: select explicitly with
  `GT_GAME=<full path>\eboot.bin`, and read the log's `Game id` line before judging any log.
- Probe numbers 348-350 were also used by the 1.71 chat. Continue this lane at **351**.
- The other chat launches the emulator on a hidden desktop and shares the one live log. Archive
  before every launch; a watcher must print the `Game id` to tell the runs apart.
- The save was fresh on 22 Sep (20,000 Cr, Collector Level 1) where 21 Sep showed Level 5. Whether
  progress persists is the offline-save chat's question. A fresh profile cannot reach Single Race /
  Northern Isle; Music Rally is always available and drives the same producer and LDS shaders at
  85-100 tables per second.

### Protocol that proved itself

- **One variable per run, through a wrapper bat.** `GT7_probe348_csout_off.bat` sets
  `GT_CSOUT_CAPTURE=0` and `call`s the unchanged probe 317. `run_gt7.ps1` applies defaults with
  `Set-GtDefault` (a value already in the environment wins) and launches with `& $exe`, so the
  variable reaches the emulator; verified end to end (bat -> call -> ps1 -> grandchild) before the run.
- **Archive the live log the moment the emulator exits, before any grep**, as
  `logs/shad_log_runNNN_<date>_<what>.txt`. `logs/last_exit.txt` has the exit code.
- **Watch, do not poll.** `RUN=351 bash GT7_upstream/watch_run.sh` (Git Bash) tails the log and
  prints only decisive lines: absurd args, `[ldsring] OVERLAP`, gpuwait, device lost, faults, a
  census every ~5k tables, milestones at 100k / 150k, `EMULATOR EXITED`. Re-arm mid-run with
  `WATCH_RESUME=1`. `python GT7_upstream/run_stats.py <archived log>` scans an archive for every
  criterion and prints max indexCount / instanceCount and the LDS ledger summary.
- With capture off, the draw-side absurd check, the readback's own ABSURD / RAM!=GPU checks,
  `[ldsring]` and `[csin]` stay active; only the "IDENTICAL to the post-producer copy" comparison
  disappears. In-log proof that capture was off: census `landed 0 failed N` and four
  `not recorded: GT_CSOUT_CAPTURE=0` lines.
- The autoshots (`GT_AUTOSHOT=15`, `%APPDATA%\shadPS4\screenshots`) reconstruct a run's route
  afterwards. A 25-45 s heartbeat loss with `netctl` / `np_manager` spam is a loading screen, not a
  GPU stall; a GPU stall is established only by `[gpuwait]`.
- An upstream merge is done by script, then a census of the old identifiers (`->member` too) and a
  first build with `ninja -k 0`; the last merge left 9 compile errors in 5 files that way.

## Why this folder exists

`GT7_work/` in the old tree holds ~300 probe bats from two games and a year of bring-up. You
cannot find today's file in it. This lane keeps one folder, a handful of files, and the probe
numbering continues the global GT7 series so an old run can still be looked up by number.

## What this lane is

| | |
|---|---|
| tree | `C:\shadps4-gt7` (a git worktree of the same repo) |
| branch | `gt7-main`, branched from `7cff046f` = our fork **merged with the latest upstream main** |
| build | `C:\shadps4-gt7\Build\x64-Clang-RelWithDebInfo\shadps4.exe`, built by `build.bat` |
| runner | `run_gt7.ps1` in this folder - our own copy, pointed at our own build |
| probes | `GT7_probeNNN.bat` here, continuing the global numbering |
| logs | `logs/` here |

The goal: GT7 gets from boot to where it is now **without the workarounds**. Every gate that
stands in for a real fix is replaced by the fix, or removed.

## What must not be touched

- **`C:\shadps4-sync` is a live God of War lane.** It builds its own exe and writes its own
  probes. Do not build there, do not commit there, do not edit `GT7_work/GOW_probe*.bat`.
- **`gt7-v0.18.0` in `C:\Users\<user>\Documents\GitHub\shadPS4` is kept for reference.** It
  carries a year of fixes that are not all on this branch. Compare against it before concluding
  something is missing upstream; do not delete or rewrite it.
- `GT7_work/psn_local/server_log.txt` - never.

## The rule for anything that is a general fix

A general fix is written **PR-ready from the start**: clean code, **no comments** narrating the
investigation, no `GT_*` gate, no game named anywhere in it. The reasoning goes in this file,
not in the source. A gate is allowed only while a thing is being measured, and it either becomes
default behaviour or it is deleted before the title is called done.

## Build

```
GT7_upstream\build.bat
```

Configures on the first run, then builds. It calls `vcvars64.bat` itself - the resource compiler
needs the SDK INCLUDE that only vcvars sets, and without it ninja stops on freetype's `ftver.rc`
in the externals, nowhere near our code.

**Read `NINJA_EXIT`, not the shell's.** Piping ninja through anything reports the pipe's status:
a failed build has come back as exit 0 with the error scrolled away.

A new build is a new `BuildGeneration`, so the pipeline cache starts cold: the first launch
recompiles and stalls for 20-65 s at a time. That is not a regression.

## Run

The user launches the probe bat. Never launch the game from here.

Afterwards read:

- `%APPDATA%\shadPS4\log\shad_log.txt` (8.3: `C:\Users\3E30~1\AppData\Roaming\shadPS4\log\`)
- `%APPDATA%\shadPS4\log\fatal.txt` - written when the emulator itself dies
- `%APPDATA%\shadPS4\log\guest_crash.dmp`
- the autoshots in `%APPDATA%\shadPS4\screenshots\`

Archive the log into `logs/` with the run number and outcome before the next launch.

## Where GT7 actually stands on this code

Measured from the 10 Sep 23:17 run, which was this same merged tree (14 MB log):

- **It boots, reaches the World Map and drives a race.** Frame periods 22-53 ms in the normal
  windows; `[framewait]` attributes 87-94 % of the long frames to **pipeline compilation**, not
  to any wait. The frame rate problem is a compile problem.
- **It dies at ~298 s** with an access violation at `rip 0x700000dcbcdb`, reading `0x102e9cdeb08`,
  on our own `GpuCommandProcessor` thread. `shadps4.exe` is linked at a fixed base
  (`/BASE:0x700000000000`, `/DYNAMICBASE:NO`), so that rip is **`shadps4.exe+0xdcbcdb`** - an
  emulator bug, not a guest one. The report printed a bare pointer, so it read as a guest
  address for a day. Fixed: see "Fixes on this branch" below.
- **No shader is stubbed.** 1988 modules compiled, zero no-op substitutions - `has_bindless_sharp`
  never fires for GT7 on this code. The shader-stub era is over for this title.
- **34 HLE functions are stubbed**, all network / gesture / screenshot, none on a crash path.

The older wall is still there: seven guest crashes at `eboot.bin+0x344789e` on the **Single Race
setup screen**, narrowed to four bytes - the high dword of a pointer at `0x1020473ff8`, which
cycles through `0x00000000`, `0x00000001`, `0x000000e4` while the low dword is correct in all
219 samples. See `GT7_work/HANDOFF_RENDERING_ACT3.md` section 6 for the whole derivation.

## Fixes on this branch

**General fix - PR-ready, no gate, no comments, no game named:** a fault whose rip is in no guest
module is resolved against the host modules instead of printed as a bare number. The report line
now carries `EMULATOR code: shadps4.exe+0xdcbcdb = <function> (<file>:<line>)`, and `fatal.txt`
gets the symbolised stack with inlined frames. `signals.cpp` gained `DescribeHostAddress`;
`death_crumb` exposes `ReportFatal` so the existing stack writer can be reached from the handler.

**Instrument - gated, `GT_HWWATCH`, strip before any PR:** a hardware data watchpoint.

```
GT_HWWATCH=0x1020473ff8/8[,addr/len...]     up to four, length 1/2/4/8, address aligned to it
```

`src/common/gt_hw_watch.{h,cpp}`. A sweeper arms DR0-DR3 + DR7 on every thread of the process
every 200 ms, including threads created later, and re-arms all of them every 10 s - a debug
register is per thread and anything that clears it would disarm the watch silently, which reads
exactly like "nobody wrote it". The trap arrives as `EXCEPTION_SINGLE_STEP`; `signals.cpp` claims
it before anything else and continues execution. Each write logs

```
[hwwatch] 0x1020473ff8: <old> -> <new> written by eboot.bin+0x... | thread 1234 'name' | trap N
```

The writer is named through a callback installed from `core/`, because only that side can resolve
a guest module - a raw rip drifts a few MiB every run and is not comparable; `eboot.bin+0x...` is.

Why hardware and not a software guard: the bytes live in a page the guest reads and writes
constantly, so page protection traps thousands of times a frame. A debug register traps on those
eight bytes only, only on a write, and reports the writer's rip - the one thing no instrument in
this lane could say. Seven crashes were narrowed to four bytes without ever naming a writer.

## The gates, and which of them are stubs

`GENERAL_FIX_AUDIT.md` in the old tree classifies all 90. What GT7 actually runs with today:

**Real fixes, gated only because they were once experiments** - these become default:
`GT_DEFER_EOP`, `GT_DEFER_RELEASEMEM`, `GT_STORE_CLAMP`, `GT_SOFT_CLAMP`, `GT_DYNRC_WINDOW`,
`GT_BINDLESS_LOWER`, `GT_BINDLESS_IMGARRAY=16`, `GT_HASH_BASELINE`, `GT_LOOP_WRAP_GUARD`,
`GT_VERTICAL_ALIAS`, `GT_CLEAR_RAW`, `GT_RESOLVE_SWAP`, `GT_TESS_LANEFIX`.

**Stubs - each one hides a bug that is still unfixed.** The value that really turns each off was
read out of the code, because `set VAR=0` is not off for a gate that only tests existence:

| gate | off | what it hides |
|---|---|---|
| `GT_RT_SCRUB` | `0` | fragment shaders whose colour output is non-finite. `=1` scrubs **every** shader, `=<hash,...>` only the named ones. Find why they produce inf. |
| `GT_18256C0_GUARD` | `0` | shader `0x018256c0` indexing a flatbuf past its end |
| `GT_IMGWRITE_SCRUB` | `0` | `normalize(0)` in a compute shader poisoning a persistent image |
| `GT_ZPASS_FAKE` | `0` | occlusion queries: a rising fake result is written for every `ZPASS_DONE`. Default is **on** |
| `GT_STUB_SHADERS` | empty | a named program replaced by a no-op. Never a fix |
| `GT_IMGZERO` | `0` | one image shape seeded with zeros |
| `GT_LUT_IDENT` | `0` | a 64^3 grading LUT the game never wrote |

`run_gt7.ps1` in this folder no longer forces any gate unconditionally: every one goes through
`Set-GtDefault`, so **the probe bat is the whole configuration**. Note the consequence - `set
VAR=` in the bat deletes the variable, and the runner then applies its default. To turn a gate
off, set it to its off value from the table, not to empty.

## Traps this lane has already paid for

- A commandlet-style "it ran, so it worked" reading of a build: **compare the exe's timestamp**.
  A build can report success having compiled nothing.
- `git worktree add` does not populate submodules, and `externals/sirit` carries a commit that
  is **not on the public sirit remote** - it has to be fetched from the sibling clone. `git
  submodule update --init --recursive` alone fails there with "not our ref".
- The log has no timestamps. Use `[fprof] t=Ns`, `[framewait]`, and line order.
- The user's Windows account name is Greek. Use the 8.3 form `C:\Users\3E30~1\...` in anything
  PowerShell reads from a file, and keep this tree's own path ASCII.
