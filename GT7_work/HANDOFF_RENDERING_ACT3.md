# GT7 on shadPS4 - HANDOFF, ACT 3 (started 6 Sep 2026, 17:00)

> 8 Sep 22:19 update: read ROAD_RECOVERY_20260908.md first for the current GT7 lane.
> The working road is in TODAY'S 20:44-20:48 frames. Probe 305 disabled the readback
> switch through GT_FRAME_PROF; the detector is now independent. Build/tests passed;
> the user confirmed the road fixed at 22:24. Preserve this baseline; scenery corruption is next.

Read THIS file first. `HANDOFF_RENDERING_ACT2.md` (5361 lines) is history: every run 200-293 with
its verdict. Open it only when a section below points at it by name. `HANDOFF_DEVICE_LOST.md`
is older still (the PSN lane lives at its lines 100-130).

## Keyboard menu controls (6 Sep 2026, after the VS Code session)

User requested the SAME keyboard/controller mappings as the VS Code session; keep them.
`GT7_probe294.bat` now prints those controls before launching. The active shared profile
`%APPDATA%/shadPS4/input_config/default.ini` maps arrows to navigation, N/Num2 to Cross
(confirm), B/Num6 to Circle (back), Enter to Options, Space to Touchpad, V/Num4 to Square,
and C/Num8 to Triangle. WASD/IJKL are the left/right sticks. Controller bindings remain.
`Input.use_unified_input_config` is true, so this profile also applies to other games.
The temporary Enter/Backspace/Tab remap was reverted at the user's request; the input file
matches `default.ini.before_probe294_keyboard_20260906_225748.bak` byte for byte.
F8 reloads inputs. The game window must have keyboard focus.
User subsequently reported the original mappings do not work. Run log (ended 23:02) archived
as `logs/shad_log_run294_2026-09-06_2302_keyboard_unresponsive.txt`; the last autoshot shows
GT7's garbled error dialog. No emulator process remained to inspect. The log says zero physical
controllers at boot, which activates the virtual keyboard controller; no input parse warning.
Root cause is NOT established. Probe 294 now sets `GT_INPUT_TRACE=1`; `run_gt7.ps1` appends
`Input:debug` to its log filter so the next run records bindings and `Input found` messages.
No C++ changes, build, or game launch. Keep N/WASD mappings; read new input logs before a fix.

## 1. The lane in one paragraph

Gran Turismo 7 (CUSA24769) on our fork of shadPS4 v0.18.0 (branch `gt7-v0.18.0`). The game
boots, signs into a fake local PSN, shows "Offline Mode", reaches the World Map and drives a
race. What is broken, in the order the user feels it: (1) the **Single Race setup screen**
kills the run - six guest crashes at one instruction, one hang, one silent death (runs 286-293);
(2) **far scenery** is trash, far frames stay on screen over new ones, thumbnails are noise,
the 3D car is black; (3) **performance**: 4-11 fps in menus, 4-15 fps in a race, CPU-bound;
(4) the game cannot **save** (network unavailable). The user's standing order: fix the emulator
first; the offline/save problem later; and **after run 294 the user wants to switch to God of
War** on this emulator - keep every GT7 instrument behind its `GT_*` gate, remove nothing.

## 2. Ground rules (the user's directives - do not renegotiate)

- **Everything about shadPS4 is C++ inside the emulator**, gated by `GT_*` environment variables,
  logging `[tag]` lines. Greps and one-off reads in chat are fine; anything that runs twice
  becomes code. The python PSN server (`GT7_work/psn_local/shadnet_local_server.py`) predates
  this law and is tolerated, not extended.
- The conversation is in Greek; every repo deliverable (handoff, comments, commit messages, bat
  headers) is in English. Comments short and technical. Instruments and their comments stay
  while investigating; the upstream PR comes later from a clean branch (one commit per general
  fix, no `GT7_work`, no `GT_*` gates, no verifier, must not read as AI-written).
- **Never launch the game yourself.** The user launches `GT7_work\GT7_probeNNN.bat`. Then you
  read `%APPDATA%\shadPS4\log\shad_log.txt` (8.3: `C:/Users/3E30~1/AppData/Roaming/shadPS4/log/`),
  the autoshots in `...\shadPS4\screenshots\`, `guest_crash.dmp` (a minidump, registers only),
  and the stuck stacks in `GT7_work/logs/stuckstack_*.txt` (the user runs `GT7_work\STUCK.bat`;
  you may run `powershell -NoProfile -ExecutionPolicy Bypass -File GT7_work/stuckstack.ps1`
  yourself while the game is stuck).
- **Archive every run's log** into `GT7_work/logs/` (gitignored) with run number, cold/warm,
  date, time and outcome in the name, before the next launch. Check the `Revision` line at the
  top of the log against the exe you think produced it.
- **Do not build while a user launch is pending**: `run_gt7.ps1` runs the Build exe in place.
  Warn the user before a build that changes every shader's SPIR-V or the pipeline layout: the
  NVIDIA driver cache (GLCache ~920 MB) then recompiles every pipeline once (20-65 s stalls,
  1-3 fps for minutes) - that is not a regression.
- Do not touch LF/CRLF-only diffs (`git status` shows `flatten_extended_userdata_pass.cpp` as
  modified for that reason) and never `GT7_work/psn_local/server_log.txt`.
- The user's username is Greek: use the 8.3 paths (`C:\Users\3E30~1\...`, repo at
  `C:\Users\3E30~1\Documents\GitHub\shadPS4`, PowerShell reads `.ps1` files by ANSI path).

## 3. Environment and recipes

- Build: `ninja -C Build/x64-Clang-RelWithDebInfo shadps4 > GT7_work/build_runNNN.log 2>&1`
  from the repo root (clang-cl; a build takes 1-6 min; the exe is
  `Build/x64-Clang-RelWithDebInfo/shadps4.exe`, and the probe bat runs exactly that file).
  A new build = a new `BuildGeneration` = our pipeline cache is cold (`WarmUp: Preloaded 0`);
  the second launch of the same build preloads ~2800 pipelines (Main at 100% for ~1 min).
- Probe bats: `GT7_work/GT7_probeNNN.bat` (CRLF). Each header states what the previous run
  showed and what this build adds; the `set GT_*` block is the whole configuration; the last
  line calls `run_gt7.ps1 -Net` (starts the python PSN server, sets `GT_DEFER_EOP=1`,
  `GT_DEFER_RELEASEMEM=1`, `GT_BINDLESS_STUB=1`, `GT_STALL_DUMP=1`). New probe = copy the last
  one, rewrite the header, change only what the build adds.
- Logs have no timestamps: use `[fprof] t=Ns` (every 2 s), `[tprof]` (every 5 s) and line order.
  The log is spdlog ASYNC - since build 294 every exit path drains the queue; before it, a death
  by `quick_exit`/`terminate`/`int3` lost its last lines (run 293 ends mid-line).
- Eboot disassembly (offline): the eboot is a fake-signed SELF - 32-byte header, 10 segment
  headers of 32 bytes (flags, file_off, file_size, mem_size; id = flags>>20), ELF header at 0x160,
  phdr0 = text (vaddr 0) = SELF segment 1 at file offset 0x2cfd0; loaded at 0xb350000. For a
  text rva R: bytes at file offset 0x2cfd0+R; disassemble with the winlibs objdump
  (`objdump -D -b binary -m i386:x86-64 -M intel --adjust-vma 0x<guest>`), start the window
  ~0x200 before the target so the decoder resyncs. Script used once: scratchpad `ebootdis.py`.
- Online: hosts file pins `asset.gt7...`, `portal.gt7...`, `api.develop-stable.vegas...` to
  127.0.0.1 (`psn_local\hosts_redirect.ps1 -Undo` reverts). GT7's own portal traffic is raw TCP
  + sceSsl, and every sceSsl function is a stub (only Init/Term are ever called), so connects
  fail fast and the game runs in Offline Mode. NP webapi goes sceHttp2 -> Http v1 -> the python
  server on 127.0.0.1:31313. Parked by the user's decision ("emulator first").

## 4. What is established (do not re-derive)

- **Boot, World Map, race all work** (runs 284-286). The World Map deadlock was a stale DingDong
  offset on a remapped compute queue (fixed, run 285). The purple race screen was our own
  `GT_RT_FORCECLEAR`. `GT_RT_SCRUB=1` fixed the whitewash (run 282).
- **Warm-cache DEVICE LOST (runs 287-289) was our HEAL writing a perm-1 Info over program.info**;
  the 288 "Info DIFF" lines were static_vector garbage. The pipeline cache is not at fault.
  `GT_CACHE_VERIFY=2` verifies and heals; it reports a handful of heals per warm run.
- **Fast clear elimination is closed** (run 254): GT7 writes the CMask once, per-frame FCE is a
  no-op; `[fce]` fires only for the 1920x1088 main RT clear-to-black.
- **Mip tail**: a DynamicIndex storage image now has 16 fixed descriptor slots (run 290 caught
  9 mips in a 7-slot layout, `[mipbake] pinned`); `[mipbake]` has been silent since.
- **Push constants**: `NUM_PUSH_UD_REGS = 32` pipeline-wide (`PushData` 184 bytes; per-stage GCN
  `NUM_USER_DATA_REGS` stays 16, the flatten pass depends on it). The per-draw UD overflow that
  dropped a stage's constants (6 shaders, run 291) is gone (0 in 292) and the race frame got
  cleaner (no gantry/kerb repetition to the horizon), but the far trash, the stale far frames
  and the black car are unchanged - they are something else.
- **The Single Race setup screen defect** (green placeholder panels = a game-drawn placeholder
  for an image that never arrived, measured (65,215,65) shaded, not a clear):
  - six guest crashes at `eboot.bin+0x344789e` (runs 286 Options, 288, 289, 290, 291, 292 cold),
    always rsp 0x7ee88bed0, rdi 0x1020473ff8, r15 0x1020470000, rsi 1, rdx 3, rax
    0xdeadbeef54321abc, only rbx differs (0x10e3419d0, 0x10f83cd90, 0x10f81ce50, 0x10f80ce30,
    0x10fd28020 - all in the Free gap 0x82abc000..0x200000000, nothing mapped there, no map/unmap
    of that range in the last 1024 operations).
  - one hang (run 292 warm): GPU thread idle in `Liverpool::Process` (num_submits 0), `Job#0`
    at 100%, last packets two DingDongs on compute vqid 4 (offsets 140, 144), then nothing.
  - one silent death (run 293, below).
  - **Disassembled (6 Sep):** the crash is
    `e79789b mov rbx,[rdi]; e79789e mov rax,[rbx+0x1560]` followed by a `lock cmpxchg` ticket
    increment on `[rbx+0x1560]`: the game reads an object pointer out of a heap slot and the
    pointer is garbage. The hang is `cb4d710 mov esi,[rax]; cmp rdx,rsi; jne` - Job#0 polls a
    u32 label until it equals `[r15+0x110]` - and the instruction after the loop is
    `mov rbx,[r15+0x100]; lea rdi,[rbx+8]; mov esi,1; mov edx,3; call libc`, i.e. exactly the
    crashing call (rdi = rbx+8 = 0x1020473ff8). **Hang and crash are one code path**: the label
    never arrives, or it arrives and the object it guards holds garbage. The slot lies in Direct
    memory prot 0x33 (CPU+GPU RW) inside the heap-spanning cached buffer 0x101e310000
    (200-555 MB across runs) from which the CPU takes 512 KB readbacks all run long.
  - Two graphics shaders (0x6f9b4517, 0x810d8a67; dynrc window @170, "1 loaded loop bound
    capped at 16384") compile within ~1000 lines of the end in every run that reached this
    screen. A marker of the screen, not a cause.
  - Run 292's hang log has NO "metadata update skipped", no `BindResources` false, no
    `SKIP_EMPTY`: the "skipped dispatch" hypothesis has no evidence; `[loopguard]` caps here are
    graphics shaders.
- **Run 293 (build 16:13, cold) died without a guest crash** on the same screen at t=199 s: the
  log stops mid-line while `UpdatePageWatchers` registered a >=116 MB region of the heap buffer
  (a re-created merge; regions 0x102e400000.. in 4 MB steps), 14 s after `[buffergc] freed 23
  stale buffer(s) / 2043 MB` and `[graveyard] 23 corpses / 2043 MB waiting`. `[vram]` had sat
  at 5.3-5.4 GB (GC trigger 5289 MB) for most of the run. No Windows event = no unhandled
  exception seen by the OS: consistent with `Terminate()` (an uncaught C++ exception - vulkan-hpp
  throws on a failed allocation) and `quick_exit`. The reason was in the async log queue and is
  lost. Build 294 drains the queue on every exit path.
- **The merge that grows the heap buffer**: `CreateBuffer` -> `ResolveOverlaps` -> `JoinOverlap`
  copies every overlapping buffer into a new union buffer and deletes the old one into the
  graveyard (`DeleteBuffer` -> `pending_deaths`, erased only when all three timelines pass the
  tick). A V# that extends the 420 MB heap buffer by one page re-creates all 420 MB. That is
  the structural fix waiting if 294 confirms a memory death.
- **Performance** (`[fprof]`, run 290): Music Rally menu ~2700 draws/frame at 6 fps,
  **43 us per draw on the GPU thread** (bindtex 10.5, bindbuf 10, pipe 5, state 4.4, vtx 1.7),
  17k V# tail clamps per 2 s; Job#0 at 91-100% and `tm_ffb_eventHandleThread` (Thrustmaster
  force feedback, in our process) at 99% of a core in every run.
- **Far scenery / black car suspects still open**: the free-VMA T# of fs 0xe8b53da0, `[imgarray]`
  nulls, the far-LOD path, `[metaread]` stale registration (fs 0xa3fd67d5 sampling the CMask
  address as a 480x270 R11G11B10). None proven. ACT2 "RUN 290 VERDICT" items 3, 4 and 8 have
  the details.

## 5. Live instruments (all `GT_*`, all in the probe bat)

| tag | knob | what it says |
|---|---|---|
| `[acbwatch]` | `GT_ACB_WATCH=1` | when the GPU thread idles > 8 s within 60 s of a compute submit: the last 64 ASC WriteData/ReleaseMem labels with the value written AND the value in memory now, every submit with its dispatch count, then (build 294) the spinning `Job#` threads: rip, registers, and `[reg]` for every register that points at readable memory - `[rax]` is the label value, `rdx` the expected one |
| `guest crash:` | always | rip as module+offset, every register resolved into the guest VMA map, the map/unmap ring, the whole VMA list, (build 294) 64 bytes at rdi/rbx/r15/rsp, then a minidump |
| `[bufdl]` `[bufsync]` `[bufcopy ...]` | `GT_WATCH_VA=...,0x1020473ff8` `GT_WATCH_SIZE=...,0x8` | every readback / upload / DMA copy covering the crash slot, with `watched 0x1020473ff8: <guest now> -> <being written>` (budget 1024 per tag) |
| `[vawatch]` `[aewatch]` `[imgsrc]` | same watch list | GPU binds, texture uploads and image refresh sources touching a watched range |
| `[readtrace]` | `GT_READ_TRACE=6` | read faults serviced by a 512 KB download; 6 lines per 2 s window plus a summary - absence in the log means nothing |
| `[fprof]` `[clears]` `[bigidx]` | `GT_FRAME_PROF=1` | per 2 s: draws, dispatches, submits, us per draw broken down, drops, softclamps |
| `[tprof]` `[tprof2]` | `GT_THREAD_PROF=2` | per 5 s: CPU per thread; rip samples of the hottest guest threads |
| `[vram]` `[buffergc]` `[graveyard]` `[texgc]` | on | device memory, live buffers/images, corpses waiting, GC passes |
| `[cacheverify]` | `GT_CACHE_VERIFY=2` | warm launch: pipelines checked/differ/healed |
| `[mipbake]` `[imgarray]` `[metaread]` `[faultloop]` `[copylayers]` `[fce]` | on | the far-scenery hunt; see ACT2 RUN 290/291 verdicts |
| `[stall]` / stall dump | `GT_STALL_DUMP=1` | work journal when a timeline stops making progress |
| autoshots | `GT_AUTOSHOT=2` | a screenshot every ~2 s into the screenshots folder |

## 6. RUN 294 - the result: the corrupt bytes are NAMED, the writer is not yet

Run 294 crashed at the same instruction for the seventh time, and this time the instruments
said which bytes are wrong. Cold run, Single Race setup screen, 6 Sep 17:09. Log archived as
`logs/shad_log_run294_2026-09-06_1709_crash.txt`, minidump `logs/guest_crash_run294.dmp`.

`Unhandled Exception code 0xc0000005 at 0xf2c789e while reading 0x10fd14ac0`

| | runs 286 / 288 / 289 / 290 / 291 / 292 | run 294 |
|---|---|---|
| rip | eboot.bin+0x344789e | eboot.bin+0x344789e |
| rdi (the slot) | 0x1020473ff8 | 0x1020473ff8 |
| r15 | 0x1020470000 | 0x1020470000 |
| rbx (the object) | 0x10e3419d0 / 0x10f80ce30 / 0x10f81ce50 / 0x10fd28020 / 0x10f83cd90 / 0x10e3419d0 | 0x10fd13560 |

The eboot base moves per run (0xb350000 in the first disassembly, 0xbe80000 here); the
`eboot.bin+offset` form is what is comparable. What the code is (objdump, base 0xbe80000):

- **crash function eboot+0x3447880**: `mov rbx,[rdi]` / `mov rax,[rbx+0x1560]` /
  `lock cmpxchg [rbx+0x1560]` incrementing a 16-bit counter, with a backoff call when it
  fails - a ticket lock on the object `*rdi`. It only needs a valid object pointer at `[rdi]`.
- **its caller chain** (return addresses on the guest stack, all resolved): thread entry
  eboot+0x3b58fb0 -> event loop eboot+0x3b58fc0 (waits on an event queue, locks `obj+8`,
  walks a bitmask of pending channels) -> eboot+0x3b590c0 (a channel: pops items whose
  `+0x558` deadline has passed) -> eboot+0x3b59180 (dispatches one item, r15 = the item =
  0x1020470000, walking `{ptr,ptr}` pairs at `+0x528/+0x530/+0x538` under a global mutex at
  0x12f99728) -> the crash. **This is a timer/deadline dispatcher thread ("PCL Event"), not
  the Job#0 label poll** - the run-292 hang (eboot+0x17fd712) is a different thread whose
  object is at `r15+0xf8/+0x100/+0x110`; whether that r15 is also 0x1020470000 is not
  recorded (the stuckstack files hold Job#0's registers - check before assuming).

**The slot holds a 64-bit pointer stored as two dwords, and only the HIGH one is wrong.**
From `guest crash: bytes at rdi 0x1020473ff0`:

| address | low dword | high dword | reconstructs to | verdict |
|---|---|---|---|---|
| 0x1020473ff0 | 0x20473ff8 | 0x00000010 | 0x1020473ff8 | valid heap pointer - INTACT |
| 0x1020473ff8 | 0x0fd13560 | 0x00000001 | 0x10fd13560 | **free gap** - this is the crash |

0x10fd13560 lies between logiWheel.prx (ends 0x82abc000) and the first heap VMA
(0x200000000): mapped by nothing. The low dword 0x0fd13560 is a plausible pointer in TWO
readings - with high dword 0 it is eboot.bin+0x3e93560 inside the r-x segment
`0xbe80000+0x58dc000` (code/rodata; a lock target cannot live in a read-only page, which argues
against it), with high dword 0x10 - the same 0x10 the intact sibling carries - it is
0x100fd13560 inside the heap VMA `0x1000000000+0x20000000`. Either way the crash values
0x1 and 0xe4 are neither. **The low dword is right; the high dword is garbage.**

**All 219 watch samples agree.** `GT_WATCH_VA=0x1020473ff8` logged the slot 219 times and the
low 32 bits read 0x0fd13560 in every single one. Only the high dword moves, cycling through
0x00000000, 0x00000001, 0x000000e4 - frame after frame, for ~8000 log lines before the crash.

**Where the wrong values come from - and where they do NOT.** Read the sequence, not one line:
- the corrupt high dwords appear in `[bufsync] cur` (= guest RAM at upload time) at lines
  144177 (0xe4) and 148109 (0x01), and the first `[bufdl]` that touches the slot after boot is
  at 150720. So the values are in GUEST RAM before any readback ever carries them: **they are
  written on the CPU side**, either by the game's own code or by our command processor's
  WriteData/ReleaseMem label path (which writes into guest RAM directly, from the GPU thread,
  and looks exactly like a CPU write to every instrument we have);
- every `[bufdl]` value equals the most recent `[bufsync]` value before it (23 of 23) - the
  GPU never alters the slot; the readback only REPLAYS the last uploaded copy. That replay can
  still clobber a fresher CPU write (the classic stale-readback clobber), and the sequence
  shows it happening - but the value the crash read (high 0x1) landed AFTER the last replay
  (line 152165 wrote 0xe4, the crash two lines later saw 0x1), so the final wrong write was a
  CPU-side one too;
- 0xe4 is not random: the bytes at r15 read as `{data, small u32}` pairs with the u32s 0xe4,
  0x10, 0x6a. `{u32 lo, u32 tag}` is a plausible encoding the game uses elsewhere; the crash
  function expects a plain pointer.

**What run 294 ruled OUT.** No `[acbwatch]` line (nothing hung this run), and no allocation
ever failed: `[buffergc]` freed 2119 MB, `[graveyard]` held 20 corpses, `[vram]` peaked at
5863 MB against the 5289 MB trigger and came back to 3223 MB. Memory exhaustion is not what
killed run 294. Nor is a GPU shader writing the slot.

### The one instrument that decides it (build 295, GT7 lane, when it resumes)
A **hardware data watchpoint** on the 8 bytes at 0x1020473ff8 (the address is identical in
all seven runs, so it can be preset): DR0/DR7 armed on every thread of the process by a
sweeper (Toolhelp every 200 ms, `SetThreadContext` with `CONTEXT_DEBUG_REGISTERS` - the
Toolhelp/Suspend/GetThreadContext code already exists in `gt_thread_prof.cpp`), and
`EXCEPTION_SINGLE_STEP` handled in `signals.cpp`'s vectored handler: log tid, thread name,
the writer's rip as `eboot.bin+off` (guest) or `shadps4.exe!Symbol` (host, via dbghelp
`SymFromAddr` - dbghelp is already linked for the minidump), old -> new value, budget 4096.
`GT_HWWATCH=addr[/len],...` up to four. One run then names the writer of every 0xe4 and 0x01:
a guest rip means the game's own structure was disturbed upstream (look at what publishes
entries into this block - the label the poll site waits on); a `liverpool.cpp` rip means our
label write lands 4 bytes off or with the wrong width; a `buffer_cache.cpp` rip means the
replay clobber is the killer after all.

Cheap companions for the same build: add the rdi/rbx/r15 pages (+-0x4000) to
`WriteGuestCrashDump` so the 16 KB block is in the next minidump; make `[bufdl]`'s `cur` read
through the DMEM backing mirror (`AddressSpace::BackingBase()` + the VMA's phys offset) instead
of printing `unreadable` inside the fault handler - then a replay that changes the value shows
as `cur != new` on its own line.

### The two fixes it would point at
1. **Immediate write-back must refuse CPU-modified ranges** the way the deferred path already
   does (`DownloadBufferMemory`, buffer_cache.cpp ~1414-1571). Right if the watchpoint names
   the readback.
2. **A PM4 label write with the wrong address/width** (WriteData / ReleaseMem / EventWriteEop
   in liverpool.cpp ~1004, ~1565, ~1611). Right if the watchpoint names `liverpool.cpp`.
If the writer is guest code, neither: then look at what the label poll (eboot+0x17fd712)
consumes and whether our fence signalling lets it consume an entry before it is published -
the `GT_DEFER_EOP` family, which the -Net env already sets.

## 7. Then, in this order

1. **God of War** - the user's pivot after run 294 ("after this run we try to fix god of war"),
   and it is set up: `GT7_work\GOW_probe001.bat` (CUSA07408, base folder; the emulator overlays
   the 01.35 `-patch` folder itself and runs the patched eboot). It calls the existing
   `run_game.ps1` and sets NO `GT_*` gate on purpose - those are GT7 workarounds and would
   measure themselves. A stock 0.17.0 control sits at
   `Desktop\shadps4-win64-sdl-0.17.0\shadPS4.exe` to separate "God of War does not run yet" from
   "our fork broke it". Ghost of Tsushima (CUSA13323) is installed too. The game-agnostic
   fixes from this lane (async-log drain, guest-crash reporter with module+offset, stack scan,
   minidump) are in the binary and work for any title.
2. **The readback/label clobber** - section 6: build the hardware watchpoint, run once, read the
   writer's rip, apply the fix it names. The Single Race defect is a named 4 bytes now.
3. The structural memory fix if the merge is implicated (section 4, "The merge").
4. Far scenery trash / stale far frames / black car (section 4 suspects; ACT2 RUN 290 items).
5. Performance: 43 us per draw (bindtex/bindbuf dominate), Job#0 spin, the FFB thread.
6. Offline play + saving (section 3, Online) - the user wants it, but after the emulator.

## 8. Rules learned in this lane (the compressed list; ACT2 has the stories)

1. Read every column an instrument prints; measure a colour before naming it.
2. Cap logs per KEY (shader, page, target), never globally; a per-run cap hides every later
   offender and a per-window budget of 6 lines proves nothing by absence.
3. A new build is cold twice (our cache and the driver's); warn before shader-layout changes.
4. Check what the logger does at exit before trusting where a log ends (async queue).
5. Disassemble a recurring crash once: six reports became one sentence about the game's logic,
   and the hang's spin loop turned out to be the caller of that sentence.
6. A stack sample gives rip; the spinning thread's REGISTERS give the label and the value.
7. Bash heredocs with quotes break in this environment: write scripts with the Write tool.
8. Archive logs with PID/time immediately; the user relaunches fast.
9. Verify the exe timestamp against the log's `Revision` before reading a log as your build.
10. Reading guest memory from inside a fault handler needs a host-protection check first
    (`Common::GtHostReadable`): a tracked page re-faults into the same handler.
11. When two symptoms (crash, hang) share a screen, look for one code path before two causes.
12. An eboot offset computed by hand is worth checking twice (0x1fd712 was 0x17fd712).

## 9. Where things are

- Code touched by this lane, by theme: `src/video_core/amdgpu/liverpool.{h,cpp}` (ASC trace,
  acbwatch, deferral), `src/video_core/buffer_cache/buffer_cache.cpp` (readback, watch, GC,
  graveyard, merge), `src/video_core/page_manager.cpp`, `src/video_core/texture_cache/*`
  (mipbake, metaread, imgarray), `src/shader_recompiler/resource.h|info.h|backend/spirv/*`
  (push constants, mip slots), `src/video_core/renderer_vulkan/vk_pipeline_serialization.cpp`
  (cache, verify, heal), `src/core/signals.cpp` (crash context), `src/common/gt_thread_prof.*`
  (thread census, hot-thread dump, GtHostReadable), `src/common/logging/log.cpp` (async drain).
- Runs and verdicts: ACT2 sections `## RUN NNN VERDICT`; logs `GT7_work/logs/`.
- Memory (Claude): `gt7-shadps4-lane.md` in the memory directory (Greek, per-run bullets).

## 10. GOD OF WAR (CUSA07408) - run log

- **GOW run 001** (6 Sep 17:46, `GOW_probe001.bat`, bare build, no GT_ gates; log
  `logs/shad_log_gow001_2026-09-06_1746_crash.txt`): booted, loaded modules, SRT walkers ran,
  died at the FIRST compute shader compiled (cs 0x38c7b95b): `vector_alu.cpp:1284 V_CMP_U64:
  Assertion Failed!`. The translator only knew the thread-mask idiom (SGPR pair vs 0/-1).
- **Fix (commit 69ac5fa9, exe 6 Sep 19:18):** V_CMP_U64 keeps the idiom fast path, otherwise a
  real 64-bit compare via GetSrc64 + IR *64 compare opcodes; all 32 V_CMP[X]_*_{I64,U64} wired.
  GT7 unaffected (idiom path unchanged, no SPIR-V change for existing shaders).
- **Next:** `GOW_probe002.bat` once; grep order: `Assertion`, `Unhandled Exception`, `guest crash`,
  `UNREACHABLE|Unsupported|Unimplemented`, `DEVICE`, `Compiling`. Expect the next missing opcode.
- **GOW run 002** (19:21, `GOW_probe002.bat`; log `logs/shad_log_gow002_2026-09-06_1921_crash.txt`):
  V_CMP_U64 passed; 41 compute + 5 graphics pipelines compiled; the SAME shader (cs 0x38c7b95b)
  then hit `Unknown opcode DS_ORDERED_COUNT` -> `BuildASL: Shader translation has failed`.
- **Fix (commit after 69ac5fa9, exe 6 Sep ~19:35):** DS_ORDERED_COUNT = GDS atomic add on a
  dedicated counter (top of the 64 KB GDS, index offset0[3:2]), value from the address VGPR,
  pre-op value returned. Wave-launch ordering NOT emulated (possible visual ordering defect).
- **Next:** `GOW_probe003.bat` once. Same grep order. If the assert path keeps eating one run
  per opcode, consider logging ALL unknown opcodes of a shader before asserting.
- **GOW run 003** (19:25-19:29, `GOW_probe003.bat`; log
  `logs/shad_log_gow003_2026-09-06_1929_pcreset.txt`): **the PC rebooted.** Windows System log:
  Kernel-Power 41 + bugcheck `0x0000010E VIDEO_MEMORY_MANAGEMENT_INTERNAL (arg1 0x37)` at 19:30,
  minidump `C:\Windows\Minidump\090626-9546-01.dmp` (admin-only; no kernel debugger installed).
  That is the NVIDIA driver's VidMm dying inside the kernel, not a guest crash and not an
  emulator assert. Before it the game went further than ever: DS_ORDERED_COUNT passed, **90
  compute + 259 graphics pipelines**, real draws (`[bigdraw]` x4 with a colour target,
  `EmitImageWrite: Fallback for ImageWrite with LOD`, `Float64 denorm` warning), `[texgc]` at
  device 1002 -> 1728 MB. No `[vram]` line after gc_tick 0 (cadence was 600 submits).
  **The last 90 KB of the log are NUL**: the file had been extended by 22 x 4 KB blocks that
  were still in the OS page cache when the kernel died. What happened in the last seconds is
  not on disk. Nothing in the surviving 368 KB points at memory pressure (1.7 GB of 12 GB).
- **"Fullscreen" was a 1920x1080 window on a 1920x1080 monitor** (`GPU.full_screen=false`,
  `window_width/height=1920/1080` in config.json). `run_game.ps1` now writes a 1280x720 window
  (`-Fullscreen` switch to opt back in); internal render resolution untouched.
- **Fix (build after run 003):** (1) `LogFileSink::Sync()` = fflush + FlushFileBuffers, called
  by a `LogSync` jthread every second (`log.cpp StartDurableSync`, stopped in `Shutdown`) and
  from `Flush()`, so a bugcheck keeps the log to within one second. (2) `[vram]` heartbeat every
  120 submits (~2 s) instead of 600. No game-side code changed.
- **Next:** `GOW_probe004.bat` once. If it reboots again the log tail is now real: read the last
  `[vram]`/`[texgc]`/`[buffergc]` lines and whatever the last submit was doing. If VRAM is not
  it, suspects are driver-level: huge allocations, `VK_EXT_external_memory_host` (off - DMA is
  disabled), sparse/BDA use. A hard cap on device usage (aggressive GC below the 12 GB) is
  cheap if the tail shows a climb. Also ask the user what was on screen.
- **GOW run 004** (19:39-19:44, `GOW_probe004.bat`, build a6b85ea6; log
  `logs/shad_log_gow004_2026-09-06_1944_devicelost.txt`, vendor dump `logs/device_fault_gow004.bin`):
  **DEVICE LOST** caught by the emulator this time (nvlddmkm event 153 at 19:44 = driver reset a
  hung engine; run 003 was the same reset failing inside the kernel). The fsync'd log is complete
  (0 NUL bytes). `VK_EXT_device_fault`: 0 memory-access faults, 9 instruction pointers inside
  0x80 bytes = ONE compute shader parked = a hang. GPU checkpoints (VK_NV_device_diagnostic_
  checkpoints): graphics queue Top+Bottom at **journal seq 11766 = DispatchDirect cs 0xef28ab59,
  groups 54x1x1, threads 64, vgprs 17**; in-flight ticks 410..411. Progress before it: 100 cs +
  348 gfx pipelines, `[bigdraw]` into 8192x4096 (shadow atlas) and 1920x1080, VRAM 1585 MB.
- **The mechanism (systemic for GoW):** 38 shaders (35 cs + 3 fs, incl. 0xef28ab59, 0x2f8c4457
  dispatched next, and 0x38c7b95b from runs 001/002) compiled with `ReadConst has non-immediate
  offset`. With `direct_memory_access_enabled=false` and no `GT_DYNRC_WINDOW`, such a read gets
  flags 0 and `EmitReadConst` emits `flatbuf[0]` (emit_spirv_context_get_set.cpp:183) - a
  garbage constant for every dynamically indexed table. A loop bound from garbage = a dispatch
  that never retires. Same family as GT7's cs_0xda05e7f8 hunt (ACT2). Second symptom in the same
  log: **68 `Patched SRT walker` criticals** (walker 0x7dfaca4.., fault address 0x20027204..,
  30+ consecutive dwords) right after cs 0x5fe5af59 compiled - a walker following a bad table
  pointer; those loads read ZERO for the rest of the run.
- **Run 005 = the emulator's own switch, no code, no gate:** `run_game.ps1 -Dma -DumpShaders`
  (`GOW_probe005.bat`). DMA makes `EmitReadConst` take `read_const_dynamic` (BDA walk of guest
  memory at GPU time) for every non-immediate read. GT7 lane: DMA "boots and plays" (ACT2 run
  74; slow, and the per-draw tracker walk was later made incremental). `-DumpShaders` writes
  every shader to `shader/dumps` so `shader_look.ps1 ef28ab59` can show the loop afterwards.
  Fallbacks if DMA misbehaves: `GT_DYNRC_WINDOW=1` (dispatch-time 8 KiB window snapshot, one
  gate) or `GT_STUB_SHADERS=ef28ab59` to confirm the culprit by substitution.
- **GOW run 005** (19:45-19:51, `-Dma -DumpShaders`; log
  `logs/shad_log_gow005_2026-09-06_1951_devicelost.txt`): DEVICE LOST at the **same dispatch**
  (seq 11333 = cs 0xef28ab59 55x1x1, 9 IPs in 0x80 bytes, 0 memory faults). **Not a DMA verdict:**
  the persistent pipeline cache (`%APPDATA%/shadPS4/cache/CUSA07408`, filled by run 004 with DMA
  off) preloaded every module - the log has 2 `CompileModule` lines total and `shader/dumps` got
  nothing. `BuildGeneration()` (vk_pipeline_serialization.cpp) hashed version/scm/walker helper
  + 3 gates but NOT `direct_memory_access_enabled` nor GT_DYNRC_*/BINDLESS_*/LOOP_*/STUB. The
  GT7 launcher carried this as the "run-117 law" (wipe the cache on a compile-affecting flip);
  run_game.ps1 did not.
- **Fix (build after run 005):** `BuildGeneration()` mixes in `dma=0/1` and the name+value of 16
  compile-affecting GT_* gates. A flip now prunes the store at start ("written by a different
  build" line). Run 006 = `GOW_probe006.bat` (same `-Dma -DumpShaders`), which will really
  recompile under DMA and dump every shader (`shader_look.ps1 ef28ab59` afterwards).
- **GOW run 006** (19:59-20:01, `-Dma -DumpShaders`, build 2069d37c; log
  `logs/shad_log_gow006_2026-09-06_2001_exposure_screen_quit.txt`): cache pruned (449), 543
  modules compiled under DMA, **no device loss** - the game passed cs 0xef28ab59 and reached
  its first interactive screen (brightness/exposure) at ~7 fps (user), quit after 1:38. 16
  `[softclamp]` T# at 0x53xxxxxxxx (free VMA), 68 walker patches again, VRAM 2.5 GB.
  **The dump proves the mechanism** (`GT7_work/shaders/cs_0x00000000ef28ab59_0.spvasm`, UTF-16;
  trace script in the session scratchpad): inner loop `while (i < read_const_dynamic(SGPR0:1
  table, (i*16+2688)>>2 + 1))`, outer loop bound `read_const(table, 2857)`. Without DMA the
  inner bound was `flatbuf[0]`. 29 dynamic ReadConsts in the IR (flags=0x0), all off the
  SGPR0:1 base.
- **General fix (user: "fix the emulator as a console, not one game"; build after run 006):**
  a ReadConst with flags 0 (run-time offset, no window) now ALWAYS emits `read_const_dynamic`
  (emit_spirv_context_get_set.cpp), and `Info::uses_dynamic_reads` puts its shader into the
  selective-DMA club (shader_info_collection_pass.cpp keep-alive) so only those shaders carry
  the BDA pagetable/fault buffer and pay the per-dispatch sync. `ShaderBinaryVersion` 3 -> 4.
  GT7 unaffected in codegen (run 294: 0 unassigned dynamic reads, 2068 windowed) but its cache
  refills once. Run 007 = `GOW_probe007.bat` with the DMA setting back OFF; measures fps.
- **GOW run 007, first attempt (20:1x): the emulator never started.** `GOW_probe007.bat` passed
  `-Dma:$false` through `powershell -File`, which hands arguments over as strings; parameter
  binding failed ("Cannot convert System.String to SwitchParameter") before the exe was reached,
  and the log on disk was still run 006's. `run_game.ps1` now has `-NoDma` (and refuses
  `-Dma -NoDma`); the bat uses it. Proven with a bogus game name through the same `-File` path.
- **GOW run 007 (20:16-20:18, `GOW_probe007.bat`, DMA OFF, build 1cba6562; log
  `logs/shad_log_gow007_2026-09-06_2018.txt`): the general fix PASSED.** 458 stale modules pruned,
  112 cs + 349 gfx compiled fresh, **48** shaders with a run-time ReadConst offset (38 in run 004 -
  it got further), cs 0xef28ab59 compiled once and the dispatch that hung runs 004/005 retired.
  No DEVICE FAULT, clean exit after 2:27 (user quit: no controller, playing over Moonlight from a
  phone). Same background noise as before: 68 SRT-walker patches (cs 0x5fe5af59 table), 16
  `[softclamp]`, 5 `[faultloop]` WRITE breaks, VRAM 2.5 GB flat. fps NOT measured yet (the user
  had no pad to move past the exposure screen). Default keyboard map in
  `%APPDATA%/shadPS4/input_config/default.ini`: WASD left stick, IJKL right stick, arrows dpad,
  cross=N circle=B square=V triangle=C, L1/R1=Q/U, L2/R2=E/O, options=Enter, touchpad=Space.
- **Next:** run 007 again (same bat) with the keyboard map or Moonlight's on-screen gamepad,
  read the fps counter once compiles calm down, get into gameplay. Then the perf lever is
  `GT_DMA_DIRTY_LOG` -> default ON (verify stability), never global DMA.
- **USER LAW (6 Sep): the final build carries GENERAL fixes only.** Gates, hash lists and
  config flips are for bring-up; before a title is called done every working fix becomes
  default behaviour for every game or is removed. `GT7_work/GENERAL_FIX_AUDIT.md` classifies
  all 90 GT_* gates (19 FIX / 16 PERF / 20 EXPERIMENT / 6 HACK / 29 DIAG), lists the 17 the GT7
  launcher still depends on, and gives the order of work. GoW already runs gate-free.
- **GOW run 007 picture:** main menu at 15-16 fps, logo + text right, the whole background a
  bright blue/rainbow smear that MOVES (73% of pixels change in 3 s) - a live pass producing
  garbage, then blurred. Log silent while it draws. `logs/gow007_shot_b.png`, `_c.png`.
  Run 008 = `GOW_probe008.bat` (`-NoDma -RenderDoc`); I press F12 at the menu and walk the
  capture headlessly with `rdc/gow_frame.py` (one PNG per colour-target switch + listing).
- **GOW run 008 (20:42, `-NoDma -RenderDoc`): the picture is diagnosed to the instruction.**
  Capture `captures/CUSA07408_capture.rdc` (931 MB, F12 sent to the window from PowerShell),
  walked headlessly: `rdc/gow_frame.py` (24 PNGs + `out_gow008/frame.txt`), `gow_verts.py`,
  `gow_indirect.py`, `gow_cs.py`. Findings, each measured:
  1. Normal draws are fine (post-VS 0 wild verts). The scene is destroyed by the **indirect
     draws** (eid 407/677/687/697, 6272-6429): every `VkDrawIndexedIndirectCommand` carries
     `indexCount` 0x819xxx = **8.49 M indices for a 2.7 k-vertex mesh** (16.9% of post-VS verts
     off-screen, 104 non-finite). The args buffer (`0x1027e38000:0xf8000`, offset 14336, 189
     commands x 20 B) is written by dispatches 330/344/360 = **cs 0x38c7b95b** (the run-001/002
     shader: V_CMP_U64, DS_ORDERED_COUNT -> SharedAtomicIAdd32 on the GDS buffer, 77 run-time
     offset ReadConsts, so it binds the BDA page table + fault buffer) and nothing else touches it.
  2. Its input records come from the FIRST dispatch of the frame, eid 318 = **cs 0x5fe5af59**
     (236 groups, one 336-byte record each; identity proven by flatbuf slot set == IR flags).
     Its flatbuf snapshot AT GPU TIME has **slots 48-115 all zero** = the 68 dwords the SRT
     walker's second block copies; the shader reads 26 of them. Root cause: the walker's second
     root is `mov rdi,[rdi+0x1c]` = user SGPR **7:8** taken as a 64-bit pointer. SGPR 4-7 hold a
     V# (`15bfd080 01500010 000000ec 20027204`: base 0x1015bfd080, stride 336, 236 records), so
     the "pointer" is dword3 = 0x20027204 - the fault address of all 68 `Patched SRT walker`
     lines of run 007. The pass found that root because `BreadthFirstSearch(composite->Arg(0),
     GetUserData|ReadConst)` accepts ANY such node anywhere upstream: the real base is
     `CompositeConstructU32x2(Phi(ReadConstBuffer...), Phi(...))` - a pointer loaded from the
     record buffer, i.e. GPU-computed, never readable by the CPU walker.
  3. **Why run 008 logged no fault:** the walker runs for the first time INSIDE the compile
     (`info.RefreshFlatBuf()` at the end of the flatten pass), the signal handler patches the
     faulting loads to xor, and `RegisterShaderMeta` then serializes `walker_func`'s LIVE bytes
     -> the zeroed walker was in the disk cache, every warm run read zeros silently.
- **GENERAL FIX (build gow009, no gate):** (a) `ResolveStaticPointerBase()` replaces the BFS:
  a ReadConst is walker-static only if its base is `CompositeConstructU32x2(lo, hi)` with
  lo/hi adjacent dwords of one GetUserData pair or one static ReadConst pair (hi may carry the
  0xffff V# mask); anything else keeps flags 0 and `EmitReadConst` reads guest memory at GPU
  time (the run-006 mechanism, now covering run-time BASES as well as offsets; one INFO line
  per shader with the counts). The `ASSERT_MSG("ReadConst not from constant memory")` is gone.
  (b) `Info::srt_walker_code` snapshots the walker bytes at generation; `PersistentSrtInfo::
  Serialize/Deserialize` store/reload that, never the live code. (c) `ShaderBinaryVersion` 5,
  `ShaderMetaVersion` 7 - every cache refills (GT7 too). The signal-handler patch itself
  stays (process-local now, still CRITICAL in the log) - with (a) it should not fire; if it
  does, that shader's SRT holds a pointer the CPU cannot see and the right answer is the same
  GPU-time read, which needs a recompile path (open).
- **Run 009 = `GOW_probe009.bat`** (`-NoDma -RenderDoc`). Expect: 0 `Patched SRT walker`,
  `read guest memory at GPU time` lines incl. 0x5fe5af59, indirect draws with sane
  indexCounts, a dark forest behind the menu instead of the smear. Verify with the same
  capture walk (`gow_frame.py`, `gow_indirect.py -> RDC_EIDS` of the new indirect draws).
- **GOW run 009 (21:50, build aa003e5c): the fix is IN and the picture is UNCHANGED.** Log:
  0 `Patched SRT walker`, 573 compiles (cache refilled), 49 shaders / 3929 ReadConsts now read
  at GPU time (`0x5fe5af59: 74 (74 run-time base)`, `0x38c7b95b: 46 (run-time offset)`,
  `0xef28ab59: 30`; the old 48 "non-immediate" count was collapsed by skipDuplicate). New capture
  `captures/CUSA07408_capture.rdc` (1096 MB, 21:51), listing `rdc/out_gow009/frame.txt`: the
  indirect draws still carry garbage (`<7349058, 1>` at eid 457, `<7348932, 1>` at 1641/1651/
  1661) - a different garbage than run 008 (8491290), so the inputs changed and are still wrong.
  Shader names are visible in this capture (`cs_0x..._0`). **Next question: what does
  `read_const_dynamic` return for 0x5fe5af59's pointers?** It reads `bda_pagetable[addr >> 14]`
  and returns 0 with a fault-buffer mark when the page is unregistered (`DefineReadConst(true)`
  -> `EmitDwordMemoryRead`). Check in the capture: the Fault Buffer contents after the frame,
  and the pagetable entries for the record buffer 0x1015bfd080 / the pointers stored in the
  records. If pages are missing, the general fix is in the buffer cache: every guest mapping a
  DMA-club shader can reach must be in the pagetable, not only cached buffers (see
  `GT_BDA_IMPORT`, unified-memory stage 4). Alternative suspect: 0x38c7b95b's own 46 dynamic
  reads / its GDS ordered count (SharedAtomicIAdd32 on "GDS Buffer", all zero at eid 330).
- **Run 009 capture, answered (rdc/gow_bda.py, gow_gds.py, gow_fill.py, trace38c7.py):**
  BDA is fine - pagetable entries exist for the root, the records and every pointer tested,
  Fault Buffer 0 bits all frame. **The garbage is the GDS.** `cs 0x38c7b95b` stores
  `indexCount = 3*k*visible + BufferAtomicIAdd(#17 = GDS, 16320, 0)`... and the ONE non-zero
  dword in the 64 KB GDS is `gds[0xFF00] = 7348890` -> the draws ask for 7348932 indices.
  0xFF00 is `kOrderedCountBase`, the private counter our run-002 DS_ORDERED_COUNT translation
  used; it is never reset and grows every frame (+4794 over dispatch 410). The game resets its
  REAL counters with DMA_DATA->GDS (vkCmdFillBuffer GDS offsets 0, 8, 4, one before each of
  the three 0x38c7b95b dispatches). GCN decode of the shader (`cs_0x..38c7b95b_0.bin`): two
  DS_ORDERED_COUNT, `0xd8fe0300` (offset1 0x03 = wave release+done, ADD, index 0) and
  `0xd8fe1300` (offset1 bit4 = SWAP), M0 set per dispatch from vcc (`s_or_b32 m0, vcc_lo,
  vcc_hi`). So: counter address = M0 base + 4*index, the shader's second op is a swap.
- **GENERAL FIX (build gow010):** `DS_ORDERED_COUNT` -> GDS dword at `(M0 & 0xFFFF) + 4 *
  offset0[3:2]`, `offset1[4]` selects swap: new IR opcode `SharedAtomicSwap32` (OpAtomicExchange;
  GDS path via `BufferAtomicSwap` in resource_tracking, LDS path in shared_memory_to_storage,
  listed in microinstruction side effects + collection pass). Wave ordering still not
  reproduced. `ShaderBinaryVersion` 6. Run 010 = `GOW_probe010.bat`.
- **Run 010 (build 22:11, capture rdc/out_gow010, log logs/shad_log_gow010_*.txt):** the
  counter fix landed - indirect index counts 42..822 (was 7.3 M), 0 walker patches, no device
  fault. G-buffer (eid 1428) and normal pass (eid 2010) are CORRECT: Kratos, axe, bush, log.
  The picture is still an explosion because of the half-res FX pass (eid 6795-9095, ~230
  DrawIndexedIndirect of vs 0x9b0fd24c into 960x540): post-VS clip w NEGATIVE for most
  quads (`gow_verts.py`). The VS reads particle records (13 dwords) through a compacted
  (key,index) list in buffer 0x10161fc000, written by cs 0x5fe5af59 / 0x38c7b95b at slots
  allocated with DS_ORDERED_COUNT. Two faults in our translation, both measured:
  1. GCN at +0x2f88 (`gcndis.py`, scratchpad): `s_bfe_u32 vcc_lo, s7, 0xb0006` (bits [16:6] of
     s7) then `s_or_b32 m0, vcc_lo, vcc_hi<<16` with vcc_hi = 0/4/8 - the counter ADDRESS is
     M0[31:16] in BYTES (the three dwords the game clears), M0[15:0] is the wave's
     ORDERED_APPEND_TERM out of the **TG_SIZE SGPR** (COMPUTE_PGM_RSRC2.TG_SIZE_EN), which the
     prologue never provided -> `BitFieldUExtract(Undef, 6, 11)` in the SPIR-V; run 010 read
     the LOW half as the address.
  2. Order is load-bearing: waves whose record has flag bit 1 clear ADD (allocate), the one with
     it set SWAPS in 0 and stores `3*k*count + swapped_total` as the draw's index count. With
     unordered atomics the swap runs early, zeroes the counter, later waves allocate over
     earlier ones -> the list the VS walks is garbage -> quads behind the camera.
  Also measured, not chased: the lit image (0x216ce0000, eid 6522) has 1.69% NaN texels, R and B
  channels only, clustered on Kratos (`gow_nan.py`); the "checkerboard" in the PNG was
  RenderDoc's alpha rendering, not data. GDS is all zero at every sampled event (the game's
  counters end at 0 after the swap).
- **GENERAL FIX (build gow011, 7 Sep 00:39):** (a) `regs_shader.h` names `tg_size_enable`
  (RSRC2 bit 10) -> `ComputeRuntimeInfo::tg_size_enable`; the compute prologue writes the
  TG_SIZE SGPR `{first wave<<31 | launch index[16:6] | waves per group[5:0]}` where a wave is a
  subgroup of `profile.subgroup_size` lanes (32 on this NVIDIA) and the launch index is
  `WorkgroupIndex * WavesPerGroup + local wave` (`Translator::OrderedWaveIndex`). (b)
  `DS_ORDERED_COUNT` -> counter at `(M0 >> 16) + 4*index`; new IR `GdsOrderedCount` /
  `GdsOrderedSignal` (translator) -> `BufferOrderedCount` / `BufferOrderedSignal` (resource
  tracking, GDS binding). Backend: the lowest active lane (ballot FindLSB == lane id, Sirit has no
  Elect) spins on a TICKET dword at `Shader::GdsOrderedTicketOffset` (0x10000, the GDS buffer is
  64 KB + 4 KB now) until it equals the wave's launch index, does ONE atomic add/exchange, the
  result is broadcast (`OpGroupNonUniformBroadcastFirst`); every wave stores `launch index + 1`
  to the ticket at S_ENDPGM (`info.uses_ordered_count`, decided by a pre-scan of the
  instruction list in `TranslateProgram`, because an early S_ENDPGM precedes the DS op in
  program order; a wave with an empty exec mask branches over the DS op on hardware too,
  `s_cbranch_execz`). Rasterizer zeroes the ticket before every dispatch whose
  `uses_ordered_count` is set (DispatchDirect/Indirect). Release/acquire on the ticket orders
  the counter atomics. `ShaderBinaryVersion` 7, `ShaderMetaVersion` 8. Run 011 =
  `GOW_probe011.bat`. Not emulated: wave_release/wave_done bits (every wave releases at exit,
  so the tail after the DS op serialises), the 11-bit term wrap (the ticket compares full
  32-bit launch indices). Risk to watch: a spin that never ends = dispatch hang (GPU idle,
  window alive) - that would mean a wave ended without the signal.
- **Run 011 (build 00:39, log logs/shad_log_gow011_2026-09-07_0043.txt, guest_crash.dmp):**
  HOST crash, not guest: `0xc0000005 reading 0x20` inside nvoglv64.dll (stack: nvgpucomp64 ->
  nvoglv64, the driver's shader compiler) right after `Compiling compute pipeline
  0xfe3aa756ad1ee51d` for cs 0x38c7b95b - the first shader carrying DS_ORDERED_COUNT. The
  emulator's shader cache had already stored the module
  (`%APPDATA%/shadPS4/cache/CUSA07408/0x0000000038c7b95b_0.spv`, raw SPIR-V), so
  `spirv-val --target-env vulkan1.3` (Vulkan SDK 1.4.357) answered offline: `OpAtomicStore ...
  expected no more operands after 5 words, but stated word count is 6`. Cause in
  externals/sirit `atomic.cpp`: `OpId{spv::Op::OpAtomicStore}` - Sirit's `OpId` ALWAYS allocates
  a result id (`words[insert_index++] = ++*bound`), and `Reserve(5)` was one word short for the
  6 written, so the value operand landed in the vector's slack and the next `Reserve` zeroed it
  (words on disk: `hdr, bogus id, ptr, scope, semantics, 0`). NVIDIA has no validation in front
  of its compiler and dereferenced null. With the one instruction corrected by hand the whole
  module validates (exit 0) - the ticket loop / elected-lane selection are structurally sound.
  The other single-argument `OpId{}` uses in Sirit are type/debug declarations that DO carry a
  result id; OpAtomicStore was the only misuse. The crash-dump module scan is
  `GT7_work/tools/mdmods.py` (minidump ModuleListStream + stack return-address scan); the offline
  SPIR-V patch/scan is `GT7_work/tools/fixstore2.py`.
- **GENERAL FIX (build gow012):** externals/sirit `OpAtomicStore` emitted as
  `*code << spv::Op::OpAtomicStore << pointer << memory << semantics << value << EndOp{}` (no
  result id, 5 words) - the submodule is on the fork's local branch `gt7-local` (precedent:
  OpArrayLength, BallotFindLSB). The malformed cache entry was deleted (recompiles once); no
  cache version bump. Run 012 = `GOW_probe012.bat`. Lesson worth keeping: when a driver crashes
  in its compiler, the emulator's shader cache holds the exact module - run spirv-val on it
  before touching any emitter code.
- **Run 012 (build 00:53, log logs/shad_log_gow012_2026-09-07_0057.txt):** the Sirit fix held
  (cs 0x38c7b95b compiled), then DEVICE LOST on the master semaphore. The in-flight journal
  (vk_instance.cpp OLDEST-TICK) shows two dispatches of 0x38c7b95b still running (2x1x1 and
  105x1x1 groups of 64 threads = 4 and 210 waves): the ticket spin never ended, Windows reset
  the GPU. Cause is in the model, not the SPIR-V: the game's two DS_ORDERED_COUNT ops
  (`GT7_work/tools/dsord.py` on the .bin dump: +0x2fa0 add, +0x2fd0 swap) both carry
  offset1[1:0] = wave_release + wave_done, i.e. the hardware frees the wave's ordering slot AT
  the op. We freed it at S_ENDPGM with an unconditional store of launch+1 - and waves finish
  out of order, so an early-exiting wave jumped the ticket past its neighbours (or a slow tail
  moved it backwards) and every wave still waiting for its own number spun forever. Even 4
  waves deadlock that way.
- **GENERAL FIX (build gow013):** flags word on GdsOrderedCount/BufferOrderedCount
  (`IREmitter::OrderedCountSwap|OrderedCountRelease`, from offset1[4] and offset1[1:0]). With
  release set, the elected lane stores launch+1 right after its atomic - it holds the ticket at
  that moment, so the store is ordered by construction. A Private bool `ordered_released` per
  invocation (ballot-any = the wave released; SPIR-V 1.6 wants it in the entry-point interface,
  hence `DefineVariable`) stops a second releasing op from touching the ticket, and
  EmitBufferOrderedSignal at S_ENDPGM now releases ONLY a wave that never did, after spinning
  for its turn - so it can never move the ticket backwards either. Collection pass sets
  `uses_group_ballot` for the ordered ops (the ballot/broadcast capability was only present by
  luck before). `ShaderBinaryVersion` 8 - everything recompiles once. Residual risk, stated:
  forward progress. A wave spins for a lower-numbered wave that must be resident to release;
  NVIDIA launches groups in index order and this game's dispatches are hundreds of waves, so
  it holds here, but a dispatch larger than the GPU's residency could still starve. Run 013 =
  `GOW_probe013.bat`.
- **Run 013 (build 01:08, log logs/shad_log_gow013_2026-09-07_0110.txt):** host crash in the
  NVIDIA compiler again on cs 0x38c7b95b. spirv-val on the cached module: two structural
  mistakes of mine in the new release path, same block - (1) the release condition
  (`OpLogicalNot`) was emitted between `OpSelectionMerge` and its branch (the merge must
  directly precede the branch: compute the condition FIRST, then emit merge+branch), (2) the
  `ordered_released` store came before the merge block's `OpPhi` (phi must lead the block).
  Fixed in place; the module patched by hand with both moves validates (exit 0), so nothing
  else in the path is wrong. Rule for this backend: any emitter that opens blocks gets
  `spirv-val` on the cached `.spv` before the next run - the driver never says no, it crashes.
  Build gow014 (01:14), only the malformed cache entry deleted (version 8 cache stays). Run
  014 = `GOW_probe014.bat`.
- **Run 014 (build 01:12, two captures 01:14 -> rdc/out_gow014, log
  logs/shad_log_gow014_2026-09-07_0114.txt):** no crash, no device lost - the ordering ran to
  the end: GDS ticket 2 / 6 / 402 after the three 0x38c7b95b dispatches of 1 / 3 / 201 groups
  (64 threads = 2 subgroups each), counters at 0/4/8 read 0 after every dispatch (the swap
  wave resets them). New menu scene (red sky, mountain): the lit image at eid 7086 is
  CORRECT, the half-res FX pass (eid 7215-9529, 245 indirect draws of vs 0x9b0fd24c) is
  still full-screen streaks, the final frame a psychedelic wash. `gow_verts.py` on 7 particle
  draws: only the FIRST quad of each draw has data, every other vertex is (0,0,0.1,0) -
  while the culler DID count visible particles (`gow_bind.py`: its bind10 draw-args array
  holds indexCount 72/210/222/444 = 12/35/37/74 quads, instanceCount 1). So the compacted
  list is written at the wrong slots; the slot base is the ordered count's RETURN, and the
  pattern says every wave got 0. GCN facts (`GT7_work/tools/dsord.py`, gcndis): s7 = TG_SIZE
  (6 user SGPRs, s6 = TGID_X), the add value is `s3 * s20` = visible lanes (s_bcnt1 of a
  v_cmp mask) x indices per particle (3*s8, s8 = 12/6/2), swap path when `s79 = s80 & 2`
  (s80 from the emitter's constant buffer -> per dispatch), the return feeds
  `v_sad_u32 v1, vcc_lo, 0, v3` (base + s20*prefix) and `v3 / s20` (slot). Both ops carry
  release+done; LLVM's encoding confirms offset1 = release | done<<1 | shader_type<<2 |
  swap<<4, offset0 = index<<2. New scripts: `rdc/gow_bind.py` (bindings + dword dumps per
  event), `rdc/gow_scan.py` (whole-region non-zero runs).
- **Build gow015 (instrument + robustness):** `GT_ORDERED_TRACE=1` (env, read once at
  translation; toggling needs the cache entry dropped) makes the elected lane store
  `{value<<16 | result}` at GDS `0x10004 + 4*launch_index` (page cleared by the rasterizer:
  `GdsOrderedTicketPageSize` 4 KB), so `gow_gds.py` shows every wave's slot base after the
  dispatch. Plus `OpControlBarrier(Subgroup)` before the result broadcast: SPIR-V does not
  promise reconvergence at the merge, and the 31 non-elected lanes must not broadcast their
  phi zero before the elected lane leaves the spin. Run 015 = `GOW_probe015.bat` (sets the
  env). Read the trace with `rdrun14.sh gow_gds.py gds.txt RDC_EIDS=<dispatch eids>`: a
  monotone sequence of bases = the emulation is right and the bug is downstream; all zero =
  the return path.
- **Run 015 (build 01:34, capture 07:02 -> rdc/out_gow015, log
  logs/shad_log_gow015_2026-09-07_0702.txt):** no crash; same streaked frame. `rdc/gow_trace.py`
  (new: finds every dispatch of a shader hash, dumps the ticket page after each) reads the
  GT_ORDERED_TRACE slots: 388 waves, 26 did the op, and within each emitter the bases are exact
  (values 186,186 -> bases 0,186; the swap wave reads 372 and resets the counter; next emitter
  180,180,180 -> 0,180,360, swap 540 ...). So the DS_ORDERED_COUNT emulation is RIGHT, and only
  even launch indices (first subgroup of each 64-thread group) do the op because the game
  restricts it to lane 0 - also right. THE BUG IS THE RECOMPILER'S LANE MASKS: the culler does
  `v_cmp sdst=s12` (visible mask -> tracked as one per-lane bit, `SetThreadBitScalarReg`), then
  `s_bcnt1_i32_b32 vcc_hi, s12` / `vcc_lo, s13` (reads s12/s13 as DWORDS = a different SSA
  variable = stale loads: the SPIR-V bit-counts two OpPhi of buffer loads), then
  `v_mbcnt_hi v1, s13, 0` + `v_mbcnt_lo v1, s12, v1` for the per-lane prefix, which
  `V_MBCNT_U32_B32` translated as "return src1" = prefix 0 for every lane. Net effect: the
  count fed to the ordered count (and to the draw args) was popcount(garbage) x 6, and every
  visible particle of a wave wrote its record at base + 0 -> one quad per draw with data.
  The values 186/180/222 = 31/30/37 "visible" were never particle counts - they are bit
  counts of stale dwords, which is why they looked plausible.
- **Build gow016 (GENERAL FIX, cache 8 -> 9 = full recompile):** `Translator::LaneMask(bit)` =
  `Ballot(bit && exec)`; `SetThreadMask(reg, bit, pair)` writes the thread bit AND the ballot's
  low/high dword into the SGPR pair (high = 0 on a 32-wide subgroup). Used by `SetDst1`
  (v_cmp sdst, s_and_saveexec, s_*_b64 mask logic, s_mov_b64 from exec) - vcc gets the same
  treatment (`SetVcc` + `SetVccLo/Hi`) - and by `S_MOV` for `s_mov_b32 sN, exec_lo` (lo dword
  only). `GetSrc<U32/F32>(exec_lo|exec_hi)` and `GetSrc64(exec)` read the ballot dwords.
  `V_MBCNT_U32_B32` is exact: `popcount(mask & lanes_below) + src1` with the low/high dword
  split at lane 32 (`-1` gives the lane's rank, so the old lane-id idiom still holds). Info
  pass: `Ballot`/`BallotFindLsb` set `uses_group_ballot`. The ballots die in DCE when nothing
  reads the dwords, so shaders that only use masks as bits are unchanged in practice.
  Files: translate.h/.cpp, scalar_alu.cpp, vector_alu.cpp, shader_info_collection_pass.cpp,
  vk_pipeline_serialization.cpp. Run 016 = `GOW_probe016.bat` (GT_ORDERED_TRACE still on: the
  traced values should now be real visible counts x 6, and gow_verts.py should show every quad).
  Guard: `S_MOV_B64` SGPR->SGPR copies both views verbatim (it also moves sharps; a ballot of an
  undefined bit would clobber the descriptor). Residual risk to watch in other games: 64-bit
  scalar logic (`s_and/or/not/cselect_b64`) on a NON-mask pair now overwrites the dword view
  with the ballot too - previously the dwords stayed stale-but-original. Those ops were already
  flattened to bits, so the mask reading was the only one that ever worked.
- **Run 016 (build 07:20, log logs/shad_log_gow016_2026-09-07_0721.txt): host crash in OUR
  compiler,** `FindSharpSources: Unreachable ... pc=0xa30` in fs 0xfed5cec9 (the MIMG at
  0xa28, T# s[12:15], S# s[20:23]). That shader spills its SGPRs - sharps included - into
  lanes of v17 (`v_writelane`) and restores them with `v_readlane s12.., v17, <lane>`.
  `V_READLANE_B32` treats EVERY readlane into an even SGPR as a possible thread-mask restore
  and called `SetDst1`, which now materialised a ballot over the dword - the restored T#
  became `CompositeExtract(Ballot(undefined))` and the sharp walker (GetUserData/ReadConst/phi
  only) gave up. Same class of hazard reviewed everywhere `SetDst1` is used: `S_CSELECT_B64`
  between two SGPR pairs (selects sharps as often as masks) and `S_MOV_B64` from a constant.
  Build gow016b: readlane restores the BIT only (dword = the readlane result, as before);
  `S_CSELECT_B64` pair/pair selects both dwords and the bit, no ballot; `S_MOV_B64` from
  0/-1/literal writes the constant's dwords. Cache 9 -> 10 (the crashed run had cached
  version-9 modules). Rule for this scheme: `SetDst1` is for a VALUE THAT IS A MASK; a copy,
  select or restore of a pair that might be a sharp must move both views untouched.
- **Run 016 second try (build 07:28, capture 07:30 -> rdc/out_gow016, log
  logs/shad_log_gow016b_2026-09-07_0730.txt):** THE LANE-MASK FIX WORKS. The streaks are gone,
  the FX half-res pass is clean, the culler's traced values are real visible counts (1 x 6 this
  frame), the lit image (eid 6080) is correct. Then, ~30 s after the F12 capture, "Device lost
  during submit" with the in-flight tick holding a normal frame (culler dispatches 1/1/214
  groups included). Cause, structural: the `OpControlBarrier(Subgroup)` added in gow015 sits
  INSIDE the game's own `s_and_saveexec_b64 s14, ~s68` / `s_cbranch_execz` branch around the
  ordered count = a subset of the wave, and a barrier only part of a subgroup reaches hangs the
  GPU. It only became divergent now that s68 (a real per-lane mask) is right; run 015 got
  through because the garbage mask was uniform. REMOVED (build gow017, 07:40, only the culler's
  cache entry dropped): `OpGroupNonUniformBroadcastFirst` reads the lowest ACTIVE lane, which is
  the elected lane, which has its atomic result by then - the barrier bought nothing. Rule:
  never emit OpControlBarrier from an instruction that can sit under exec.
- **What the screen shows now (016b screenshot logs/gow016_shot.png; capture frame):** the menu
  scene in washed grey-blue with a checkerboard of light tiles and dark blobs where the embers
  should glow. Measured with `gow_img.py`: the full-res scene colour the tonemap reads,
  0x226c80000 (1920x1080 RGBA16F), is (0,0,0,1) at EVERY sampled eid (6100..8834). Its writers:
  cs 0x7463e726 via tile-classified vkCmdDispatchIndirect (21 / 0 / 0 / 0 groups - only a few
  tiles), then `vkCmdBeginRendering(C=Clear)` at eid 6230, then the particle draws (count 0
  this frame). So the tonemap composes black + the half-res chain (0x226380000: cs d127d058
  downsample -> 7605787f -> 77a8eb18) = a blurred, washed copy of the lit scene; the checker
  tiles are in that half-res chain or in the tonemap's own tile logic. Run 014's capture has the
  identical structure (7463e726 15/1288/0/19 groups, Clear at 7361, tonemap reads it), so this
  is NOT a regression of the mask fix - it was under the streaks all along. Open question for
  the next capture: what SHOULD fill 0x226c80000 - the 31559-group pass cs 0xf6282446 that reads
  the lit image (RenderDoc usage cannot see stores through SRT pointers, so a bindless write to
  it would be invisible in `gow_img.py`'s usage list), and whether the Clear at BeginRendering
  is the emulator's decision (a fast-clear/CMASK inference) wiping a buffer the game filled.
  `gow_bind.py` at eid 6142 (f6282446) and at 8834 (the tonemap's SRT: does it point at
  0x226c80000 at all?) is the next measurement, no game run needed.
- **gow018 (build 07:58, cache 10 -> 11, probe 018 written; probe 017 never ran - 018 contains
  its change):** the washed frame is NOT only the black scene colour. Reading the half-res chain
  on the run 016 capture: 0x226380000 already carries the checker tiles and the blown-white axe
  BEFORE the tonemap (gow_savetex.py at eid 8834). Its shaders (cs 7605787f, 77a8eb18, and the
  log-luminance pass f6282446) reduce across the wave with `ds_swizzle` in BITMASK mode - xor
  1/2/8/16 butterflies, i.e. a per-lane index - and `DS_SWIZZLE_B32` translated that as
  `ir.ReadLane(src, index)` = `OpGroupNonUniformBroadcast`, whose id operand must be UNIFORM.
  Undefined result on every neighbour exchange; NVIDIA returns whatever, hence tiles. Fix: new IR
  opcode `Shuffle` (U32, U32, U32) -> `OpGroupNonUniformShuffle` (Sirit gained the op,
  `uses_group_shuffle` adds capability GroupNonUniformShuffle). Second finding, same shaders:
  GCN combines the two 32-lane halves of a wave64 reduction with `v_readlane_b32 vcc, v, 32`;
  on a 32-wide subgroup lane 32 does not exist (undefined broadcast). `EmitReadLane` folds the
  lane with `subgroup_size - 1` when the subgroup is narrower than 64 ("wave32 model": the read
  sees this half again, which is the correct value for an already-reduced half). Both general.
  NOT yet addressed: the exposure produced by f6282446 under the wave32 model (its reduction now
  double-counts one half instead of adding the other - a factor 2 at worst, visible as
  brightness, not tiles), and the 0x226c80000 fast-clear question from run 016b. BISECT DONE
  (gow_savetex.py at eids 6560/8770/8790/8820, PNGs tex_eid*.png in rdc/out_gow016): 0x21a130000
  holds an unrelated silhouette image up to eid 8770 and the checkered half-res scene at 8790;
  the only dispatch between them is cs 0x7605787f (eid 8781), the shader with 12 `ds_swizzle`
  (xor 8 / 1 / 16 / 2 = a 2D neighbour exchange inside an 8x8 tile). 77a8eb18 (8813) then copies
  the checker into 0x226380000 (empty before 8813), the tonemap composes it. So the checker is
  born in exactly the instruction gow018 re-translates. d127d058 / 77a8eb18 / c6d0b871 contain
  no wave-exchange ops at all.
- **Run 018 (build 07:58 cache 11, screenshot logs/gow018_shot.png, capture -> rdc/out_gow018,
  log logs/shad_log_gow018_2026-09-07_0809.txt):** THE CHECKERBOARD IS GONE - the shuffle fix is
  confirmed on screen: bloom chain clean, axe no longer blown white, scene contrast back, menu
  text crisp. Ordered count still right (trace: 396/396 tickets, 3 emitters 114/6/60, add+swap
  bases 0 each = per-emitter reset). Still wrong: (1) the embers draw as sharp BLACK blobs, (2)
  vertical bands in the blurred background. Then "Device lost during submit" a few seconds after
  the F12 capture. HANG ANALYSIS: in BOTH 016b and 018 the last shader compiled before death is
  fs 0xbb876517 and the death follows 4-5 GC cycles (~10 s) later; run 015 (pre lane-mask fix)
  compiled the same shader and lived 34 cycles - so the hang is a path that only diverges now
  that masks are right (or the F12 capture itself; both runs died right after one). The in-flight
  dump names a whole frame (the culler is in it because every frame is), not a shader. The GPU
  checkpoints (`GT_GPU_CHECKPOINTS`, default on) and VK_EXT_device_fault were UNAVAILABLE in both
  death runs: RenderDoc hides the extensions ("Extension VK_NV_device_diagnostic_checkpoints
  unavailable" line 97 of both logs); GT7 run 294 without RenderDoc had device fault on. Hence
  probe 019 = same build, NO RenderDoc: a death names the checkpoint/shader, survival convicts the
  capture. BLACK BLOBS: the 166 full-res particle draws (fs ba7426d4 into 0x226c80000) all have
  count 0 in RenderDoc's decode (BDA-written args - decode unreliable); the embers are really drawn
  in the HALF-RES FX pass into 0x227c80000: eids 7510/7520/7530 (vs 9b0fd24c perms 4/5, fs
  040621e2 x2 / e2376d91) with 180/186/246 indices = the culler's 114+6+60 particles as quads. The
  blobs are already in the half-res image the tonemap reads (tex_eid009790_0x226380000_L0.png).
  fs 040621e2: two MIMG ops (op 1 = load, op 32 = sample: soft-particle depth + sprite), v_interp,
  colour*alpha -> pkrtz -> mrt0. An opaque black quad = colour 0 with alpha 1: either the sprite
  sample / interpolated colour is zero or the blend state we build is not the game's. Next
  measurement (capture only): pixel-stage texture bindings + blend state at eid 7510
  (gow_texbind.py), the VS's particle records (gow_bind RDC_N=64), 0x227c80000 before/after 7510.
- **Run 019 (same build, NO RenderDoc, warm cache; log logs/shad_log_gow019_2026-09-07_0834.txt):**
  VK_EXT_device_fault + VK_NV_device_diagnostic_checkpoints enabled (lines 96-99), NO device
  lost: the user sat in the menu, pressed New Game and closed it a few seconds into the load
  ("Cache dumped" = clean exit). New on the New Game path: one `[faultloop] WRITE fault at
  0x1009fafa58` handled by the page manager (forced RW), pre-existing `[softclamp] shader
  0xb15f7fbe T# 0x53b5000000 not mapped`. Two differences from the death runs at once (no
  RenderDoc, warm cache), so the trigger is not isolated yet - but every death so far has had
  RenderDoc attached and came after an F12. Ember-blob measurement on the 018 capture: blend at
  7510/7530 is premultiplied (One, InvSrcAlpha; alpha Zero, InvSrcAlpha), depth Greater no
  write; textures bound and non-zero (BC4 256x4096 flipbook, 1D-array LUT 256x1 x1024 layers,
  half-res depth); RenderDoc's replay of draw 7510 changed 0 texels of 0x227c80000 (black on
  black or alpha 0), so the FX pass is NOT proven to be the blob source. Next: pixel debug of
  the tonemap (eid 9782) at a blob pixel of its output (gow_pixdbg.py RDC_XY, ids ->
  bindings via spvmap.py: %240/%247 img106 b4, %260/%283 img130 b5, %292 img146 b6, %477 b8,
  %498 b9, %514 b10, %619 b11, %715 b12, %867 b13, %996 b14).
- **THE RACE (found on the 018 capture, no game run):** the tonemap's inputs, picked with
  RenderDoc's PickPixel (`gow_probe.py` at eid 9782): at a blob pixel the half-res input
  0x226380000 is (nan,nan,nan,1) - the blobs are NaN texels; at two neighbouring checker tiles
  the LIT image 0x216ce0000 already differs 2.3x in G/B and its alpha flips -65504/10000 per
  tile - the checker exists before any post pass. Then `gow_pickhist.py` (PickPixel per eid) on
  0x226380000: after cs 77a8eb18 (eid 9761) the SAME texel reads 0.1152, NaN, 0.0912 on
  consecutive eids with no write in between - and replaying eid 9761 itself 12 times gives 4
  different values (`pickhist_stability.txt`); at the sky texel the two values that alternate
  are exactly the two tile colours. 0x21a130000 (cs 7605787f's output) is two-valued the same
  way, and the lit image's sky draw (fs 084b0697, eid 7067) too. VERDICT: checker + blobs are
  one bug, a GPU race between passes. CAUSE: `Buffer::GetBarrier` (buffer.h) returns no barrier
  when the new access mask+stage equal the last ones, without asking whether the last access
  WROTE; the bind path asks for ShaderWrite on every RW binding, and every GoW post pass binds
  the one 154 MB scene buffer RW (gow_bind: all "RW") - so no compute pass in the chain ever got
  a buffer barrier against the previous one. `Image::GetBarriers` already had the `is_write`
  check; buffers did not. FIX gow020 (buffer.h): early-out only when the last access was
  read-only. General, host-side, no recompile. PROOF PLAN: probe 020 capture -> the stability
  test must give one value for 12 replays, and the checker/blobs must be gone on screen.
  Instruments left behind (all `GT7_work/rdc/`): `gow_probe.py` (all bound textures at points),
  `gow_pickhist.py` (texel per eid; repeat an eid to test replay determinism),
  `gow_pixdbg.py` (RenderDoc SPIR-V pixel debugger - returned no trace on this capture),
  `gow_texbind.py` (textures + blend/depth state), `spvmap.py` (scratchpad: sample id ->
  binding). ⚠ RenderDoc's A2B10G10R10 PNG export swaps channels - judge by picked values.
- **Run 020 (build 09:02 with the buffer write barrier, RenderDoc on; screenshot
  logs/gow020_shot.png, capture 13:16 -> rdc/out_gow020):** checker in the sky AND the black
  blobs are STILL THERE. So the RW->RW buffer barrier was necessary but is not the race that
  paints the frame. No device lost while the game sat in the menu after the capture (>3 min,
  49 GC cycles) - the first RenderDoc run to survive; the two deaths had a cold cache. Hunt
  continues on the 020 capture with `gow_racehunt.py` (double-replays every draw/dispatch and
  compares picked texels of its outputs: the EARLIEST racy action is the one to look at) and
  `gow_barriers.py` (prints the vkCmdPipelineBarrier2 contents recorded between two actions -
  what the emulator actually emitted). Candidates not yet excluded: hazards between two Image
  objects aliasing one guest address, storage writes followed by a differently-viewed read,
  the wave64-on-wave32 LDS/lockstep assumption inside one dispatch (a 64-thread group is two
  subgroups here; an exchange the game does without s_barrier because a wave is lockstep on
  GCN is a race on NVIDIA), and CPU-side parse-time EOP fences (GT_DEFER_EOP=1 makes them
  GPU-time) letting the game recycle memory early.
- **CORRECTION - run 020 did NOT contain the buffer barrier fix.** The gow020 edit script died
  on a quoting error (a lone backslash in a bash heredoc), the shell chain's `||` ran the build
  anyway, and the build was a no-op (45 steps, all resource/ipc objects; buffer.h untouched,
  commit e36a3b30 carries only the GT7_work files). Found because the run 020 capture shows NO
  vkCmdPipelineBarrier2 at all between consecutive skinning dispatches (`gow_barriers.py` at
  eid 752: only PushConstants / PushDescriptorSet / BindPipeline / Dispatch). Lesson recorded
  in memory: write edit scripts with the Write tool, verify the file on disk (grep) before
  building, and never chain `edit && guard || build`.
- **THE RACE, PINNED DOWN ON THE 020 CAPTURE (`gow_racehunt.py`, `gow_racein.py`,
  `gow_bufhist.py`, `gow_bufdiff.py`):** the earliest non-deterministic output is the skinned
  vertex range `Buffer 0x1026f38000 off 0x3f890f0 size 0xa6d88` (17085 vertices x 40 bytes),
  written in place (pos/normal RMW, 10-dword stride, stores at dwords 0-4) by a chain of
  skinning/blend-shape dispatches (cs 4cce254e at eid 672, 4939957c at 712/748...) with NO
  barrier between them in this build. Right after its writer (eid 748) the range is identical
  over 6 replays; one dispatch later it differs in 890-1067 dwords (whole 20-byte vertex
  records, tiny deltas ~1e-5 = one delta applied or not). The same pattern repeats for the
  next range (stable at 752, racy at 756). The G-buffer draws from eid 1493 inherit it (LSB
  jitter in normals/motion vectors), and everything downstream - lighting tiles, bloom, tonemap
  - inherits from there: the final image is racy at 4 of 6 probe points over 12 replays
  (`pickhist_stability_final.txt`). Fix = the RW->RW barrier in `Buffer::GetBarrier`
  (gow021, this time verified on disk: `grep was_write buffer.h`). Also learned: skinning
  shaders have LocalSize 64, no LDS, no subgroup ops, no atomics - nothing wave64-specific.
- **RUN 021 (build 15:25 = commit de43acad + a4c50a19, RenderDoc on; log
  `logs/shad_log_gow021_2026-09-07_1637.txt`, capture kept as
  `%APPDATA%/shadPS4/captures/gow021_1637.rdc`, analysis in `rdc/out_gow021`). THE BARRIER FIX
  WAS REALLY IN THE BINARY THIS TIME AND THE PICTURE DID NOT CHANGE.** Revision a4c50a19 in the
  log's own banner, 0 errors, 159 compiles (warm cache, no recompile). Checker and black blobs
  both still there.
- **AND THE RUN 020 RACE VERDICT ABOVE IS WRONG - the race is real but far too small to draw a
  blob.** `pick_spread.py` over the 020 12-replay report: the worst spread at any probe point is
  **0.1065**, four of six points move by <= 0.015, and **not one of the six ever reads near 0**,
  i.e. no probe point was ever ON an artifact. A black blob is the difference between 0.0 and
  ~0.4. So non-determinism was proven and then the visible defect was attributed to it without
  ever asking how big it was. The `Buffer::GetBarrier` fix stays - a write-blind early-out is a
  real bug - but it was never the cause. (Two replays of the same analysis on the same capture
  still report 1343 vs 1342 groups for one dispatch, so a small race remains.)
- **Screenshots cannot judge a build here.** `artifact_measure.py` (near-black fraction + 2x2
  alternation): 018 23.60%/1.30%, 020 14.14%/1.01%, 021 13.85%/0.96% - but **two shots of the
  SAME run three minutes apart give 13.85% and 10.00%**. The within-run spread swamps the
  between-build difference. Judge from the capture.
- **THE REAL SCENE COLOUR IS `0x216ce0000`, NOT `0x226c80000`** - the earlier note calling
  0x226c80000 "the full-res scene colour the tonemap reads" sent this hunt the wrong way for two
  sessions. `gow_targets.py` (new: every colour target's black%/NaN% in ONE capture load) at the
  tonemap: `0x216ce0000` 1920x1080 RGBA16F, **0.00% black, 3.32% NON-FINITE**, mean 0.1223;
  `0x217cd0000` 15.86% black / 0.37% non-finite; `0x226c80000` 100% black. The tonemap does read
  0x226c80000, and it really is wiped by an emulator `Clear` at BeginRendering after four compute
  passes wrote 4% of it (96.27% black before the clear, 100.00% after) - but it carries so little
  that this is a side issue, not the wash.
- **THE BLACK BLOBS ARE NaN IN THE LIT SCENE.** 3.32% of `0x216ce0000` is NaN/Inf, and NaN
  spreads through the blur passes, which is how 3.3% becomes the ~10% dark pixels on screen.
  `gow_stage.py` (new: black%/non-finite%/mean/max + PNG + a PGM mask of where the NaN is, per
  eid) across the lighting chain: **3.73% before ANY pass of this frame** (so it survives from
  frame to frame), the lighting passes ERASE some of it (3.70 -> 2.41 -> 1.84 -> 1.87%), and the
  last pass over the tile lists puts it back (**1.87% -> 3.32%** across eids 7325-7346).
- **The tile classification is NOT at fault**: the six indirect dispatch group counts over the
  scene sum to 4605+160+41+1343+22+26229 = **32400 = 240x135 = exactly the 8x8 tile grid of
  1920x1080**. Every tile is covered exactly once.
- **The checker is 32x32 TEXELS and it is already in the lit scene**, before any post pass
  (`runlen.py` on the exported render target: 32 px runs are a clear mode - 82 in x, 112 in y -
  against 1/2/3 px noise). Measured on the NATIVE export: the same measurement on a window
  screenshot is worthless because 1920 -> 1295 with filtering destroys the grid.
- **The NaN writer is `cs 0x42ba6f62`** (`gow_shaderid.py`, new - see the naming bug below). Its
  shape, from the GCN: `v_log` -> **ds_swizzle butterfly xor 1,2,4,8,16** -> `v_readlane_b32
  vcc_hi, v0, 32` -> add -> **x 1/64** -> image store. That is a mean over a GCN **wave64**. All
  ten ds_swizzles are BitMode (offset0=0x1f, offset1 = 0x4/0x8/0x10/0x20/0x40), which the gow018
  Shuffle fix already handles correctly. On a 32-wide subgroup the readlane of lane 32 folds onto
  lane 0, so the result is 2 x (own 32-lane sum) / 64 = the mean of 32 lanes instead of 64 -
  WRONG but FINITE, so this is not yet the NaN. The shader also has 8 `v_rcp_f32`, 7 `v_log_f32`,
  1 `v_rsq_f32` and 1 `v_sqrt_f32`; the log right before the reduction is guarded by
  `v_max_f32 v1, 0x358637bd, v1` (~1e-6), so that one cannot produce NaN. **Where the NaN is
  born is still open** - the mask that would show whether it sits on tile edges (a wave-level
  bug) or on geometry (a data bug) did not finish, see below.
- **A SEPARATE GENERAL BUG, FIXED: a shader loaded from the pipeline cache never got a name.**
  `SetObjectName` is called only in `PipelineCache::CompileModule`, so on a warm cache every
  shader in a capture is "Shader Module 468" instead of `cs_0x000000007605787f_0` - which is why
  `gow_find.py` returned no matches at all on this capture and every hash-based tool was blind.
  Fixed in `vk_pipeline_serialization.cpp::LoadPipelineStage` (verified on disk, NOT yet built:
  the game held the exe). Every game benefits.
- **A SECOND GENERAL DEFECT, MEASURED AND DELIBERATELY NOT FIXED:**
  `vk_compute_pipeline.cpp` asks for `requiredSubgroupSize = 64` whenever
  `IsSubgroupSize64Supported()`, but `profile.subgroup_size = instance.SubgroupSize()` is always
  the device's DEFAULT (32 on RDNA). So on an AMD RDNA card a compute shader is compiled for 32
  and runs at 64, and the gow018 `EmitReadLane` fold (`lane & (subgroup_size-1)`) would BREAK a
  reduction that used to work. There is no wave64 handling anywhere in the recompiler (`grep
  wave64 src/` = nothing) and the PS4 is GCN, i.e. every guest shader is wave64. This machine is
  NVIDIA at 32 everywhere, so the value is correct here and the change is untestable - it needs
  per-stage plumbing (graphics is not given 64) and an AMD card. Recorded, not attempted.
- **INSTRUMENT REPAIRS (all committed, they cost real time this session):** every `gow_*.py` now
  flushes per line and ends with `### RDC SCRIPT DONE`, and the runner waits for that MARKER -
  waiting for the report to stop growing declared victory 25 s in on a script that only flushes
  at the end, and truncated `find.txt` to its header. The runner also snapshots the qrenderdoc
  pids before launching and kills only new ones: the old `ps -W`/`$!` mapping missed, and one
  orphan holding **4.7 GB** starved the next analysis into crawling. `gow_targets.py` named its
  PNGs from the HEAD of the resource name, where every 1920x1080 target reads identically, so two
  targets overwrote one file - it uses the tail (the address) now.
- **NEVER OVERWRITE A SHELL SCRIPT THAT IS RUNNING.** Rewriting `rdrun21m.sh` while a background
  job was executing it made bash resume at a byte offset in the new text - `syntax error near
  unexpected token` - and killed the NaN-mask run that was 30 minutes in.
- **The game reached 20.1 GB** sitting at the menu for an hour with RenderDoc attached (5.35 ->
  8.84 -> 20.14 GB), which is what left 3.5 GB free and made every analysis thrash. Close it
  before analysing a capture.
- **NEXT, in order:** (1) finish the NaN mask on `gow021_1637.rdc` with the game closed
  (`gow_stage.py RDC_IMG=0x216ce0000 RDC_EIDS=7324,7347 RDC_MASK=1 RDC_STEP=4`) - if the NaN sits
  on tile/wave boundaries it is our cross-lane emulation, if it follows geometry it is an input;
  (2) build the shader-naming fix so the next capture is readable at all; (3) then hunt the NaN
  in `cs 0x42ba6f62` with a named capture.
- **FOUND IT (still on the run 021 capture, no new run needed): `ds_swizzle`'s QUAD mode was a
  broadcast and had to be a shuffle - the same bug run 018 fixed for its BITMASK mode and left
  half done.** The NaN mask is what says so. `gow_stage.py RDC_MASK=1` on `0x216ce0000` at eids
  7324 and 7347 writes a PGM of where the non-finite texels are, and it is not tiles and not
  lanes: it is **Kratos's silhouette** - head, shoulder, back, upper arm, hand - **with EVERY
  OTHER PIXEL poisoned at 7324 and SOLID at 7347**. A per-quad checkerboard is a broken quad
  instruction drawn at native resolution; `cs 0x42ba6f62` then reads neighbours and fills the
  gaps in (1.80% -> 3.33% of the frame non-finite), which is how it doubles the count without
  creating anything.
- **The counting that turns that into a fact:** `scan_quadbroadcast.py` walks every cached .spv
  and finds each `OpGroupNonUniformQuadBroadcast` and whether its Index operand is an
  `OpConstant`. **215 shaders use one; 3519 quad broadcasts in total; the index is computed
  per-lane in 3519 of 3519 and constant in none.** GCN quad mode packs four 2-bit selects in
  offset[7:0] and lane k of a quad reads lane sel[k], so the four lanes read four different
  sources - a permutation. SPIR-V leaves QuadBroadcast undefined unless the index is the same
  across the quad. Fix (`data_share.cpp`): absolute lane `(lane & ~3) | sel` through `ir.Shuffle`,
  which stays inside the quad and inside the subgroup at any subgroup size. **Cache version 12,
  so probe 022 recompiles every shader.** `data_share.cpp:317` was the only emitter of
  `IR::Opcode::QuadShuffle`, so that opcode and the `GroupNonUniformQuad` capability are now
  unused - left in place, they are upstream's own IR primitive, but worth a note before a PR.
- **Also built and committed: a shader restored from the pipeline cache now gets its name**
  (`vk_pipeline_serialization.cpp::LoadPipelineStage`). Until now only `CompileModule` called
  `SetObjectName`, so on a warm cache every shader in a capture was "Shader Module 468" and no
  hash-based tool worked - that is why `gow_find.py` came back empty on the 021 capture while
  the shaders it wanted were plainly running. General, every game.
- **Where the NaN is NOT coming from, measured at eid 7179 (before the lighting chain):** of
  every render target 1900+ wide, only the two HDR accumulation targets carry any non-finite
  texels - `0x216ce0000` 3.73%, `0x217cd0000` 0.37%. The 8192x4096 D32 depth, the 2048x1024
  R32F, and both R16G16F targets are **0.00%**. So nothing upstream feeds NaN in; it is born in
  the shading and then sticks, because these targets are read-modify-written every frame and a
  NaN pixel poisons itself forever.
- ⚠ **`python -m py_compile` every instrument after editing it.** Two mask runs (30+ minutes of
  waiting, one stuck qrenderdoc) produced nothing because a heredoc had eaten the backslashes in
  `f.write(b"P5\n...")` and `gow_stage.py` did not parse at all - qrenderdoc just sat there. The
  memory rule about writing edit scripts with the Write tool exists for exactly this and I broke
  it twice in one session. All 29 `gow_*.py` now compile.

## RUN 022 - THE QUAD FIX WAS REAL AND IT WAS NOT THE CAUSE, AND THE G-BUFFER KEEPS OLD FRAMES

The player's report after probe 022: *"it kept multiple old frames to new frames and it trashes
image. cratos visible but sky and tree not recognizible"*, and then, plainly, *"visually
everything was the same"*.

**The build was right, so that is not the explanation.** The log's own pipeline-cache line stamps
it `0.18.0 ... (2026-09-07 19:07:51)` - the second build, the one with the quad fix - and 683 of
the 775 cached .spv files were rewritten during the run, i.e. cache version 12 took effect and
every shader really was recompiled. (The revision string says `0bafd679`, one commit behind: the
generated scmRev is only refreshed when CMake re-runs, so judge the binary by the BUILD TIMESTAMP,
never by that hash.)

So `ds_swizzle`'s quad mode was undefined in all 3519 places, the fix is correct, and it changed
nothing on screen - the same shape as the barrier in run 021. Two proven bugs, neither of them
THIS bug. Both stay in; neither is worth re-running.

### What the run 021 capture says, measured

Because the picture did not change, that capture still represents what the player sees, so this
cost no run time at all.

- **The G-buffer is PERFECT.** `0x20d0a8000` (A2B10G10R10 normals) holds the whole scene in full
  detail - every branch, Kratos's face, the axe. Geometry, vertex work and the G-buffer pass are
  innocent, and that alone splits the frame in two: everything drawn by vertex/pixel shaders is
  right, everything computed afterwards is wrong.
- **The DEPTH buffer of that same frame holds ONLY KRATOS.** `0x20bc00000` is LINEAR view depth
  (1.13 .. 12000, not a normalised Z - classify "far" by the largest value present, not by 1.0):
  **17.83% of the frame is geometry, 82.17% sits at the far plane.** There is no forest in this
  frame.
- **And yet the normals target is full of forest.** Diffing it at eid 50 against eid 10020:
  **15.22% of it was rewritten, and 99.5% of those pixels lie exactly on Kratos's silhouette**;
  only 0.08% of the frame was written anywhere else. So this frame wrote the G-buffer ONLY where
  Kratos is, and the other 82% is a PREVIOUS frame still sitting in it. That is the player's "it
  kept multiple old frames to new frames", as a number rather than an impression.
- The final composite is one full-screen draw at eid 10020 into `0x224310000`, reading twelve
  textures - among them the lit scene `0x216ce0000`, the **100% black** `0x226c80000`, and
  `0x21a750000`, which spans only 0.41..0.62 (a flat wash). eid 10029 is then textbook **TAA**:
  current colour + motion vectors + history `0x224b08000` -> `0x225300000`.
- Brightened x6, the lit scene has **no forest at all** - fire and haze behind a pure-black
  Kratos, with a 32-pixel checkerboard in its alpha (run lengths 32/96/160, 76.6% agreement with
  a perfect 32-px checker).

### Ruled out by measurement, so nobody pays for them twice

- **The colour-grading LUT is innocent.** `gow_lut.py` (new) reads the 64x64x64 3D LUT the
  composite samples: diagonal ramps 0.02 -> 0.95, corners correct (red->red, white->white), full
  range, **0 of 63 steps backwards on every axis**. A collapsed LUT would have explained the wash
  perfectly, which is exactly why it had to be measured instead of argued about.
- **Intra-workgroup races are innocent.** The theory was that a guest workgroup of exactly one
  wave needs no barrier on real hardware and becomes a race when split across two host subgroups.
  `scan_wave64.py` (new): 23 compute shaders use shared memory in a 64-thread workgroup and **all
  23 already carry control barriers**. Dead.
- **All 118 `Shuffle`s are safe at subgroup 32.** `ir.Shuffle` is emitted only by `ds_swizzle`,
  and both its modes are bounded by construction - quad mode stays inside a 4-lane quad, bitmask
  mode is documented as "limited data sharing within 32 consecutive threads". So the two
  ds_swizzle fixes are correct AND wave-size-safe, and the wave64 exposure is much smaller than
  it first looked. Do not re-open it on the strength of the shuffle count.

### Real, measured, and still open

- **`scan_wave64.py`: 111 of 117 compute shaders declare a 64-thread workgroup** - one guest wave
  each - while this host reports `Physical device subgroup size 32`. 53 of them use cross-lane
  ops. The genuine exposure is **32 `readlane` broadcasts** (masked to lane 31 by
  `emit_spirv_warp.cpp`, so a WRONG lane rather than an out-of-range one) and **29 ballots**.
- ⚠⚠ **WRONG - CORRECTED IN RUN 023, see below. Left here so nobody re-derives it.**
  ~~Every guest 64-bit wave mask has a dead upper half.~~ The upper dword really is always zero, but that is CORRECT: shadPS4 models a guest wave64 as one 32-lane host subgroup, and a 32-lane wave has no lanes 32..63. The original note follows.
- **Every guest 64-bit wave mask has a dead upper half.** `Translator::SetThreadMask` builds it
  from `ir.Ballot(...)` and takes `CompositeExtract(mask, 1)` as lanes 32..63 - on a 32-lane
  subgroup that dword is **always zero**. So `s_bcnt1_i32_b64` can only ever count half a wave.
  Note the codebase is inconsistent with itself here: `WavesPerGroup()` already computes 2 waves
  per group from `profile.subgroup_size`, while this path still pretends the wave is 64 wide.
- **The bloom target `0x21a5b0000` (480x270) is 100% black** at the composite. Its two separable
  blur passes are the two odd workgroup sizes in the census - `tg=[480,1,1]` and `tg=[1,270,1]`.
- `0x226c80000` is cleared at eid 7405 and then every draw that should refill it asks for
  `<0, 1>` - zero indices. Suspicious, but a layer with genuinely nothing in it is legitimately
  black, so this is NOT yet a finding.

### ⚠ The menu is not a fair test of the complaint

The player started a NEW GAME; this capture is the MENU, and the menu genuinely has almost no
geometry (17.83%). "The forest is missing" may simply be true of the menu. Probe 023 asks for an
in-game capture for that reason - and with the run-022 naming fix in, every shader in it will
carry its hash, so a broken pass can finally be mapped to its .spv.

### Probe 023 - and it needs no new build

`GT_FRAME_PROF=1` turns on the frame profiler already in this fork; it logs a `[clears]` line
every few seconds listing each colour target as `addr:WxH:b<binds>/c<clears>/f<forced>`. If the
big targets come back `c0` after thousands of binds, the clear the game asks for is being dropped
on the way in and the stale frames follow from that. `GT_RT_FORCECLEAR` is the lever to test the
other direction. The cache is already at version 12, so nothing recompiles.

New instruments, all committed: `gow_lut.py` (is the grade LUT a ramp or a collapse),
`gow_depthmask.py` (what geometry does this frame really have - **linear depth, so "far" is the
largest value present**), `scan_wave64.py` (offline: workgroup sizes, cross-lane ops, LDS and
barriers, straight out of the cached .spv, no capture load).

⚠ **`gow_targets.py`'s PNG names were head-truncated before 95ba9eed** - every 1920x1080 target
reads identically at the head, so several overwrote one file. Any image under `out_gow021/` dated
before 19:02 may not be the target its name claims. The `targets.txt` numbers are fine.


## RUN 023 - THE CLEAR IS NOT BEING DROPPED, AND THE WAVE-MASK LEAD WAS MINE AND WAS WRONG

The player pressed F12 and the emulator died instantly. That is the third time (016b, 018, 023),
and it is always F12. But the run had already been logging for 271 seconds by then, so it answered
its question anyway - and the crash turned out to have an answer of its own sitting in a place
nobody had looked.

### The F12 crash is a GPU fault, not a timeout - and RenderDoc is why we could not see it

The Windows System event log, at the exact second the emulator died:

    nvlddmkm  Id 13   Graphics Exception: ESR 0x404000=0x80000002
    nvlddmkm  Id 13   Graphics Exception: ESR 0x4041b0=0xc00d
    nvlddmkm  Id 13   Graphics Exception: Class 0xc00d Subchannel 0x0 Mismatch
    nvlddmkm  Id 153  Error occurred on GPUID: b00

⚠ **There is no event 4101.** 4101 is the TDR entry - "display driver stopped responding and
has successfully recovered" - and its absence rules out the timeout theory that the numbers
otherwise support (the GPU is 96% busy: `busy=1922ms` in a 2.0 s window, 649 draws and 572
dispatches per frame, and `TdrDelay` is unset so the limit is the 2 s default). What actually
happened is a hardware *graphics exception*: the GPU was handed a command stream it could not
interpret. **Check the event log before theorising about a device loss** - it is free, it is
already recorded, and it distinguishes a fault from a timeout in one line.

⚠⚠ **And shadPS4 was blind to it because RenderDoc was attached.** The startup log says so
in as many words:

    Extension VK_EXT_device_fault unavailable.
    Extension VK_NV_device_diagnostic_checkpoints unavailable.
    Attached debugging tool: RenderDoc

Both extensions are present on this GPU. RenderDoc hides them, so every device-lost report in a
RenderDoc run ends with "the driver cannot say where or why" - which reads like a limitation of
the hardware and is a limitation of the instrument. This was already noted for run 018/019; it is
restated here because it is what makes the F12 crash unchaseable rather than merely annoying.

### THE CLEAR IS NOT BEING DROPPED - the question probe 023 existed for, answered

`GT_FRAME_PROF=1`, 132 samples over 271 s. Of the **19 colour render targets the game uses,
exactly ONE ever receives a clear** - `0x21a750000`, once per frame. The G-buffer `0x20d0a8000` is
bound **1458 times per two seconds and cleared zero times**.

And that is CORRECT. A deferred renderer does not clear its G-buffer; it overwrites it with opaque
geometry. So the emulator is not dropping anything - **the game never asks for the clear.** The
theory is dead, cleanly, and the stale 82% has to come from the draws instead.

### THE STRUCTURAL FINDING: depth is drawn DIRECTLY, colour is drawn ENTIRELY INDIRECTLY

    [bigidx] indirect draws: depth 0 (max_count 0)   colour 6747 (max_count 6747)
    [indargs] colour indirect: 6747 calls, args read 6747 (gpu-modified 6747, unmapped 0)

Every colour-target draw goes through GPU-driven indirect rendering and **not one depth draw
does**. That is worth writing down on its own, and it lines up with the run-021 measurement it was
not derived from: the depth buffer of that frame held only Kratos, while the G-buffer held a
forest that this frame did not write.

⚠ **`first-command index count zero 6747 max 0 sum 0` in that same line proves NOTHING**, and
the instrument's own comment says why: `TryReadIndirectArgs` memcpys the **CPU-side** copy and
stamps it `gpu_modified` precisely because a shader owns those bytes. A stale read of zero is the
expected reading, not a finding. `GT_INDARGS_GPU=N` is the switch that copies what the GPU really
consumes and reads it back when the tick completes - it exists, it has existed since run 264, and
it was not set. That is probe 024.

This also matches what the GT7 lane measured on the same emulator with the same instrument (runs
259-264): with thousands of colour indirect draws the scene was absent, and it appeared only in
the game's direct-draw mode. Two different games, same emulator, same shape.

### ⚠⚠⚠ THE WAVE-MASK LEAD WAS MINE, AND IT WAS WRONG

Run 022 recorded the always-zero upper dword of the guest wave mask as a defect, and this run
built two scanners to size it. They measured it accurately and the conclusion drawn from them was
wrong, so both halves are recorded.

`scan_wavemask.py` (new): of 775 cached shaders, **24 read `CompositeExtract(ballot, 1)`** - the
dword that is always zero at subgroup size 32 - four of them feeding `BitCount`. The two heaviest
users are `0x5fe5af59` (14 reads, workgroup 64x1x1, 14 ballots, 395 phi nodes) and `0x38c7b95b`
(5 reads, 2 of them bit counts), **which are exactly the two compute shaders this handoff already
names as the pair that writes the (key,index) list feeding the indirect draws**. That convergence
is real and is why the lead looked strong.

**But `SetThreadMask` is not a bug.** Reading the rest of the code rather than that one function:

    WavesPerGroup()    = threads / profile.subgroup_size      -> 2 for a 64-thread group
    LocalWaveIndex()   = flat_id >> log2(profile.subgroup_size)
    GetExec()          returns a per-invocation U1, not a 64-bit mask
    EmitReadLane()     "A GCN wave is 64 lanes; here it is one subgroup."

shadPS4 models **a guest wave64 as ONE 32-lane host subgroup**, consistently. Under that model a
wave has no lanes 32..63, so a zero upper dword is right, and `s_bcnt1_i32_b64` over `{ballot32,
0}` counts the whole 32-lane wave - not half of a 64-lane one. Ballots, popcounts, prefix sums and
per-wave compaction are all width-agnostic and survive the split untouched. The run-022 claim that
the codebase "is inconsistent with itself here" was the opposite of the truth.

**What genuinely does not survive** is an instruction naming a specific lane >= 32, because that
lane lives in the other subgroup. `scan_lane_const.py` (new) reads the lane operand of every
lane-addressed cross-lane op in all 775 shaders:

    constant lane  < 32 (in range)                     : 0
    constant lane >= 32 (folded to lane & 31 - WRONG)  : 3
    runtime lane        (undecidable offline)          : 3397

**Three** (⚠ **and that number did not survive the next run - see run 024 below: the shader cache was rewritten under the scan, and the current cache names no constant lane at all. Treat the figure as a snapshot, not a property of the game**), all in `0x59e1a66a_0.spv`, all `Broadcast lane 32`, and `EmitReadLane`'s fold onto the
same position in the lower half is the documented intent rather than an accident. The 3397 runtime
indices are almost entirely `ds_swizzle`, whose two modes are bounded inside 32 lanes by
construction (run 022). **So the wave64-on-wave32 exposure in this game is three instructions in
one shader, and it is not what is wrong.** Do not spend another session on it.

The lesson, and it is the same one this file keeps recording in different costumes: a defect found
by reading ONE function is a defect in a model that has not been read. The convergence on
`0x5fe5af59` still stands and is still where to look - it is the first dispatch of the frame and
it feeds the indirect draws - but the mechanism named in run 022 is not the mechanism.

### Probe 024 - no RenderDoc, nothing to press

`GT_INDARGS_GPU=64` with `GT_FRAME_PROF=1`, RenderDoc off so `VK_EXT_device_fault` and the
diagnostic checkpoints come back, and no F12 in the instructions. One yes/no question: do those
thousands of colour indirect draws carry geometry, or nothing? No new build - cache version 12
is already on disk.


## RUN 024 - THE BLACK BLOBS ARE A QUARTER-RESOLUTION FAULT, NOT A WAVE FAULT

Probe 024 ran clean (no RenderDoc, nothing to press) and the player photographed five states of
the game. Everything below is measured from that run's log and from the 1 GB capture the F12
crash had already finished writing in run 023.

### What the pictures say, and they are consistent

Kratos, Atreus, the axe, the log on his shoulder and the whole UI render **perfectly** in every
frame. The environment is missing and replaced by blocky noise over a pale blue-grey wash - except
during the falling-tree cinematic, where the forest IS there, in full texture detail, shattered
into rectangles. So the failure is not "geometry absent" and not "shading absent"; it is
selective, and the foreground survives it.

### The environment IS being submitted - which closes the door run 024 opened

`[bigidx]` over the whole 390 s run, every single window:

    colour[98130x28  93642x28]     depth[186006x56  139002x56  98130x28  93642x28]

i.e. roughly 64 000 triangles of colour geometry per frame, continuously, plus more on depth.
**The CPU never stops issuing the big environment draws.** That matters because the GT7 lane's
run-268 verdict - the one this measurement looked like it was reproducing - is precisely that GT7's
CPU DOES stop issuing them (occlusion culling reading a stale zero because GPU readbacks are
disabled). GT7's signature is absent here, so **the readback door is not God of War's door**, and
the per-game `readbacks_mode` override built to test it was removed again rather than left armed.

⚠ And the GT7 lane had already answered the other half: **the indirect draws are NOT the
environment.** They are small instanced props, and two thirds of them culled to nothing is normal
for a culled batch list. GoW's 66-94 % zero is the same distribution as GT7's 65-70 %. The
`GT_INDARGS_GPU` measurement was worth making and it is not a fault.

### THE BLACK BLOBS: 3.2 % NaN IN THE LIT SCENE, AND NOW WE KNOW ITS SHAPE

`0x216ce0000` (1920x1080 RGBA16F) is the lit scene, and it is the only full-res target carrying
non-finite values: **3.17 %** at the composite (3.32 % when this was first measured - reproduced).
`gow_stage.py` across the lighting chain: **1.75 % is already there before any pass of this
frame**, the lighting passes barely move it (1.74 / 1.85 / 1.87 %), and it reaches 3.17 % by the
composite. So it survives from frame to frame and something later roughly doubles it.

The open question in run 022 was whether it sits **on tile edges** (a wave-level fault, because a
guest wave64 is two 32-lane subgroups here) or **on geometry** (a data fault). `scan_nanmask.py`
(new) answers it from the mask `gow_stage.py` writes:

    tile  8 / 16 / 32 : x%tile and y%tile peak-to-flat 1.01 - 1.06     (flat = no lattice)
    half-tile split   : 49.7 % / 50.3 % / 49.9 %                       (50 % = no split)

**It is NOT a wave or tile lattice.** A 64-lane wave damaging half of each tile would put that
split nowhere near 50 %, and every modulo histogram would spike. So the wave64-on-wave32 story is
dead for the NaN, and with it the last reason to keep pulling that thread.

**What it IS**, from the same mask:

    horizontal runs : 4 px x3254, 8 px x1188        (of 6025 runs)
    vertical runs   : 4 px x3332, 8 px x1126
    run STARTS aligned mod 4 : {0: 5341, 1: 234, 2: 207, 3: 243}   -> 89 % start on a multiple of 4

**The NaN sits in 4x4 pixel blocks aligned to a 4x4 grid.** A 4x4 aligned block at 1920x1080 is
one texel of a **480x270** buffer. That is a quarter-resolution effect, not a per-pixel one.

⚠ **The modulo histograms cannot see this on their own** - aligned 4-px runs hit every x%4
value equally often and read as perfectly flat. It took measuring where the runs START. Any future
"is this damage structured?" test needs both.

### Where it lives, and the pass that never runs

`gow_targets.py` with `RDC_MAXTEX=400` (the default 40 keeps only the biggest textures and hides
every half- and quarter-res buffer - that is why earlier scans never saw them):

    0x226380000  960x540 RGBA16F   6.36 % non-finite    <- worst in the frame
    0x219cb0000  960x540 RGBA16F   4.43 %
    0x21a130000  960x540 RGBA16F   4.40 %
    0x216ce0000 1920x1080 RGBA16F  3.17 %               <- the lit scene, read by the composite
    0x21a5b0000  480x270           100 % black, 0 % NaN

The half-res buffers carry MORE NaN than the lit scene does, so the lit scene is downstream of
them, and `0x226380000` is read by the composite at eid 10000.

And `0x226380000` is touched exactly three times in the whole frame: read by the composite, one
plain dispatch at eid 9947 - and **eid 2290, `vkCmdDispatchIndirect(<0, 1, 1>)`, a dispatch with
ZERO workgroups, which therefore never runs and leaves the buffer holding whatever the previous
frame left in it.** `0x219cb0000` is not mentioned at all this frame: 4.43 % NaN, untouched,
carried forward.

**17 of the 47 indirect dispatches in this frame are dispatched with zero workgroups.** The six
lighting dispatches are NOT among them - they read 25941 + 4890 + 1342 + 161 + 46 + 20 = **32400 =
240x135, exactly the 8x8 tile grid of 1920x1080**, so tile classification is still correct and
still innocent, exactly as run 022 measured.

### What that leaves, stated honestly

A zero-workgroup dispatch is not automatically wrong - a pass with nothing to do legitimately
dispatches none. What makes these suspicious is the consequence: a buffer that is never refreshed
and is then READ, carrying non-finite values forward frame after frame. A game does not leave NaN
in a buffer it intends to reuse.

So the next question is the same one the indirect draws asked and it now has a sharper target:
**do those zero group counts come from the game, or from our emulation of the compute shader that
writes them?** `GT_INDARGS_GPU` reads draw arguments; the dispatch-argument equivalent does not
exist yet and is the instrument to build.

New: `scan_nanmask.py` (where NaN sits: modulo histograms, run lengths, run-start alignment and
vertical extent - the three together separate a lattice fault from a resolution fault from a data
fault).

⚠⚠ **THE REPO WAS SWITCHED TO `main` AND BACK MID-ANALYSIS, and the first explanation offered for it was wrong.** Two reports vanished out of `rdc/out_gow023/` while they were being read, a freshly written `GOW_probe025.bat` disappeared before it could be committed, and tracked files as unrelated as `equeue.cpp` and `out_gow016/frame.txt` all took the same new mtime. That was reported to the user as "a parallel session is working in this repo" on the strength of mtimes alone, and it was not true. `git reflog` had the answer and took one command:

    40da489b HEAD@{1}: checkout: moving from main to gt7-v0.18.0
    4cc54cda HEAD@{2}: checkout: moving from gt7-v0.18.0 to main
    40da489b HEAD@{3}: reset: moving to HEAD

A branch switch rewrites every tracked file that differs between the two branches, which is exactly the mtime pattern, and it carries off whatever was not committed. **When files in a git repo appear to change by themselves, read the reflog before naming a culprit** - and commit a deliverable the moment it is written rather than at the end of the cycle. Analyses write into the session scratchpad now, not into the repo.

- **Perf note for later:** `GT_DMA_DIRTY_LOG` (incremental DMA sync) is still default OFF and
  no launcher sets it; if the selective club is still slow, that is the lever - not global DMA.

## RUN 025 - A TORN IMAGE DESCRIPTOR REACHES A PATH WITH NO GUARD (10 Sep)

First God of War run on the current build - 38 commits it had never seen, and a COLD shader
cache, because the build identity is mixed into the cache key and every rebuild opens a fresh
generation. It died at the MAIN MENU at t=122s, before New Game was ever pressed.

    [softclamp] refusing to (un)track region 0xc4a0004000 - 0xc56a1cc000 (3233 MB, not fully
                GPU mapped - torn descriptor registration)
    Unhandled Exception 0xc0000005 at 0x7ffcfe9be770 while writing 0x20
    rax=0x0  rbx=0xc4a0004000  rdi=0xca1c8000

`mdmods.py` on the minidump puts the fault in **VCRUNTIME140.dll +0x1e770**, i.e. inside
memcpy/memmove, and the registers name the whole chain: `rbx` is the start of the refused
region and `rdi` is **exactly its size** (0xc56a1cc000 - 0xc4a0004000 = 0xca1c8000). A null
destination and a 3.2 GB length.

**Where the garbage comes from.** 0xc4a0004 and 0xc56a1cc appear on the guest stack as ordinary
pointers - `eboot.bin+0x210004` and `eboot.bin+0x2da1cc`. Something read two code pointers and
used them as a page range, so the region is a code pointer shifted twelve bits. Two smaller ones
of the same shape (`0xc010004000 - 0xc01020c000`) only warned, earlier in the same run; note
they both end in `004`, which is the tell.

**The guard worked and it is only half a guard.** `page_manager.cpp:608` refused the tracking -
that is the softclamp written after run 146, and its own comment describes this exact signature
("the page sweep then died writing a watcher entry (0xc0000005 at address 0x20)"). But refusing
to TRACK does not stop the caller: `texture_cache.cpp:1482` goes on to bring the image in, the
3233 MB allocation fails, and the copy writes to the null it got back. The missing guard is on
the upload side, and it would be a general fix - any game can present a torn descriptor.

**NOT YET ATTRIBUTABLE, and the honest reason.** This refusal has never fired in any of the 21
earlier GoW runs, nor in any of the ten recent GT7 runs - including 316 and 317, which already
carry the object-pool and coroutine-frame fixes. That is evidence against those two. But run 025
is also the ONLY cold-cache GoW run in the set, and a cold cache means thousands of shader
compilations and a completely different memory-churn profile. Both stories fit.

⚠ **RE-RUN BEFORE REBUILDING.** The cache is warm now. A rebuild makes it cold again and
destroys the one comparison that separates the two stories.

**The picture is unchanged**: at the menu the logo and text are clean and the background is
still broken into blocks (`logs/gow025_menu.png`). Whatever the 38 commits did, they did not fix
that. Evidence kept: `logs/shad_log_gow025_2026-09-10_0752_crash.txt`, `guest_crash_gow025.dmp`.

## RUN 026 - THE CRASH REPRODUCED WARM, AND THE OTHER HALF OF THE GUARD IS IN (10 Sep)

**Run 025's "maybe it was only the cold cache" is dead.** Run 026 ran with a WARM shader cache,
survived past 025's t=122s death (still healthy at t=208s), and then died at t~255s at the
**same guest address, with the same registers, in the same function**:

```
[softclamp] refusing to (un)track region 0xc4a0004000 - 0xc56a1cc000 (3233 MB, not fully GPU mapped)
Unhandled Exception 0xc0000005 at 0x7ffcfe9be770 while writing 0x20
rax=0x0  rbx=0xc4a0004000  rdi=0xca1c8000  r8=0xca1c7fe0  r9=0xffffffffffffffe0
```

`0xc56a1cc000 - 0xc4a0004000 == 0xca1c8000` exactly, so **rbx is the region start and rdi is its
size to the byte** - they are the caller's two non-volatile locals. `mdmods.py` on the new dump:
**VCRUNTIME140.dll +0x1e770**.

### The chain, every link measured rather than inferred

1. A torn descriptor registers an image at **0xc4a0004000, guest_size 0xca1c8000 (3233 MB)**.
   Both numbers are real `eboot.bin` code pointers shifted twelve bits - a pointer pair read as
   a page range. (`0xc56a1cc = eboot.bin+0x6a1cc`, and it is on the guest stack twice.)
2. `TextureCache::TrackImage` -> `UpdatePageWatchers` -> the run-146 softclamp **refuses**. Works.
3. Nothing stops the CALLER. `RefreshImage` (texture_cache.cpp:1391) asks
   `ObtainBufferForImage` for the same 3233 MB.
4. `StreamBuffer::Map` (buffer.cpp:379): `if (size > this->size_bytes) return {nullptr, 0};`
   The staging ring is **512 MB**. It returns null **exactly as documented**.
5. buffer_cache.cpp:2133, the next statement, passed that null to `CopySparseMemory` as its
   DESTINATION. `IsValidMapping` passes (no `CopySparseMemory from invalid` line in the log),
   the VMA is Free, so the loop reaches `std::memset(dest=nullptr, 0, copy_size)` - and that is
   the fault, writing dst+0x20.

### The fix (fc8e8b9f) - general, ungated

Five `Map` consumers already test this pointer (buffer_cache.cpp:1389/1524, vk_rasterizer.cpp
:3542/3745/3832). Four did not, and now do:

| site | before | after |
|---|---|---|
| `ObtainBufferForImage` | `CopySparseMemory(addr, null, size)` | refuses, returns `{nullptr, 0}`, logs the MB |
| `RefreshImage` | `in_buffer->GetBarrier(...)` on null | keeps the image, consumes `Dirty` so it is not retried every frame |
| `StreamBuffer::Copy` | memcpy/CopySparseMemory into null | skips, returns offset 0 |
| shared-memory bind | `std::memset(null, 0, lds_size)` | binds `VK_NULL_HANDLE` |

Not gated behind anything. Any title producing an oversized or torn descriptor reached the same
null and died on it.

### Also settled by these two runs

- **`[dispgpu]` closed its question.** Every window of both runs: `CPU non-zero but GPU zero 0`,
  `CPU zero but GPU non-zero 14-18`. The zero-workgroup dispatches are **the game's own**; no
  compute shader of ours writes those zeros. The instrument is removed from probe 027 - it costs
  a transfer plus a readback per dispatch for an answer already in hand.
- **Torn descriptors are chronic, not exceptional.** Both runs reject the same garbage T#
  addresses (`0x5302800000` 14x then 12x, plus `0xc010004000`, `0x4a130000400`, `0x490e0020400`).
  The binder's guard catches those. Run 025/026 was the one that found the path with no guard.
- **The picture is unchanged.** The menu still shows a clean logo and text over a background
  broken into blocks; the 38 commits did not touch the visual damage.

### NEXT

`GT7_work\GOW_probe027.bat` - **every shader recompiles on this build** (the pipeline cache mixes
the build identity into every record), so the first minutes are slow and the frame rate is
meaningless until it settles. Watch for `Refusing a N MB image upload at 0x...`: that line means
the guard caught what used to be fatal, and the game should carry on past it.

**STILL OPEN, and now the top of the list:** *why* a descriptor arrives with a code pointer where
its base address belongs. The guard stops the process dying; it does not stop the garbage being
produced, and the same garbage is the leading suspect for the blocky background.

### Traps paid for here

- **An idempotency check that matches unchanged text reports success and patches nothing.** The
  first patch script tested `new.strip().splitlines()[1]` - the second line of the REPLACEMENT,
  which for three of four patches was part of the untouched anchor. It printed `ALREADY` three
  times and wrote nothing. Grepping the four guard strings on disk is what caught it.
- **A Write-tool script can be CRLF while the sources are LF**, so every multi-line anchor misses
  and every single-line anchor hits - which reads exactly like a stale file. Normalise, or use
  the edit tool, which fails loudly instead.

## RUN 027 - THE GUARD HOLDS, AND GOD OF WAR REACHES GAMEPLAY (10 Sep)

First run on the null-Map guards (fc8e8b9f). **381 s, zero guest crashes, clean exit, and the
game got past the main menu into the opening scene** - which it had never done on this branch.

| | run 025 | run 026 | run 027 |
|---|---|---|---|
| shader cache | cold | warm | cold (rebuild) |
| died at | t=122 s | t=255 s | **did not die** |
| reached | main menu | main menu | **gameplay** |
| `Unhandled Exception` | 1 | 1 | **0** |
| ran for | 122 s | 255 s | **381 s** |

The guard fired on exactly the descriptor that used to be fatal, at t=13 s, and the process
carried on:

```
[softclamp] refusing to (un)track region 0xc4a0004000 - 0xc56a1cc000 (3233 MB, not fully GPU mapped)
Refusing a 3233 MB image upload at 0xc4a0004000: larger than the staging buffer
```

The page manager refused that region **twice** and the upload guard fired **once** - the second
refusal needed no upload because `RefreshImage` consumes `Dirty` on the refusal instead of
retrying it every frame. The `StreamBuffer::Copy` and shared-memory guards did not fire at all,
which is the honest state: they are the same class of defect, not the same occurrence.

### What the first gameplay frame says, and the menu could not

Geometry and lighting are CORRECT - Kratos' silhouette, the Leviathan axe with its blade and
haft, shoulders and head all read cleanly. What is destroyed is COLOUR AND TEXTURE CONTENT: a
uniform blue wash carrying the same square blocks as the menu background.

**So the damage is in the texture path, not in geometry or in the shaders that draw it.** Images
arrive in the right place with wrong or absent contents. That is a much narrower search than
"the picture is broken", and it points at the same torn descriptors the binder rejects all run.

### OPEN, and the new lead: a GPU-side fault

One `VK_EXT_device_fault` at ~t=35 s, survived, never repeated:

```
address[0] InstructionPointerFault: 0x20039a4d0
address[1] ReadInvalid:             0x49de00000   (precision 0x1000)
graphics queue checkpoint: journal seq 132583, shader 0xded513de
```

The GPU read unmapped memory. The journal for that batch is the interesting part:

```
ITS RENDER TARGETS: 678 draw(s) into 1920x1080, 1702 into 960x540, 1920 draw(s) into 8192x4096
```

**8192x4096 is not a render target this game has.** It is another torn descriptor, arriving
through a different door from the 3233 MB image - and 1920 draws went into it. Neither run 025
nor 026 recorded a device fault, but both died before reaching gameplay, so this is new
territory rather than a regression.

### NEXT, in order

1. **Root-cause the torn descriptors.** Two shapes are now measured: an image with a code
   pointer for a base address, and an 8192x4096 render target. The guards keep the process
   alive; nothing stops the garbage being produced, and it is the leading suspect for the
   texture damage.
2. **The 0x49de00000 ReadInvalid**, with `shader 0xded513de` named by the checkpoint.
3. The blue wash itself - now known to be a texture-content problem, not a geometry one.

## ⚠ CORRECTION TO RUNS 025-027: THE "POINTER PAIR" WAS AN ARTEFACT OF MY OWN READING

Those three sections say the torn image's address and size are *"both real eboot.bin code
pointers shifted twelve bits, a pointer pair read as a page range"*. **That is wrong**, and the
same sentence is in commit fc8e8b9f's message. Checked against run 026's own VMA dump:

```
eboot.bin executable segment: 0xc500000 + 0x1000000  ->  0xc500000 .. 0xd500000
0xc56a1cc   inside it   (eboot.bin+0x6a1cc, which is what the crash logger printed)
0xc4a0004   NOT inside it - it is below 0xc500000
```

So it is not a pair. And the twelve-bit shift is **the page manager's own**: `UpdatePageWatchers`
prints `page << PM_PAGE_BITS` and `page_end << PM_PAGE_BITS`, so a region at 0xc4a0004000 has
page number 0xc4a0004 **by definition** - every address of the form 0xXXXXXXX000 does. The value
on the guest stack is that local variable, and it lands inside eboot's numeric range only
because this title's eboot happens to be loaded around 0xc4b0000-0xc500000.

**What is actually established** is narrower and still worth having: an image is registered with
guest_address 0xc4a0004000 and guest_size 0xca1c8000 (3233 MB), reproducibly, at the same address
across three runs. Where its FIELDS come from is unknown - that is what probe 028 asks.

The null-Map guards are unaffected: they are correct whatever produced the size.

## PROBE 028 - THE PROVENANCE INSTRUMENT (10 Sep)

`GT_IMG_MAXMB` has existed since GT7's run 246 and has been **off by default** ever since. It
refuses an image whose TILED footprint exceeds the limit **at bind, before the texture cache
creates anything** - earlier and strictly safer than run 027's upload guard. It is turned on for
this run at 512 MB (a 4K render target is 33 MB, an 8K lightmap with mips about 358 MB, the
monster is 3233 MB), and its log line was extended with the two things it never printed:

- **provenance.** `ImageResource::GetSharp` has exactly two routes - the SRT snapshot in
  `flattened_ud_buf`, or `ReadGuestSharp` from a constant offset inside tracked buffer
  `[deref_buffer]`. The line now names which, and for the second one resolves the V# and prints
  **the guest address the descriptor was read from**.
- **the eight raw dwords**, so a plausible-but-wrong field set can be told from obvious garbage.

Those two answers need opposite fixes, which is the whole reason to measure before changing
anything: a sane source address holding garbage means a stale or unwritten guest table, while a
garbage source address means the V# pointing at it is the broken one and the search moves a
level up - to the SRT walker, where this lane has already fixed two bugs (runs 008/009 and 016a).

⚠ **A claim that 8192x4096 is a second torn shape is NOT supported and was mine.** The device
fault's journal reports 1920 draws into that target, and this project's own notes list 8K
lightmaps as legitimate. Treat it as unexplained, not as garbage, until something measures it.
