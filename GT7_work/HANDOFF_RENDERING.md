# HANDOFF: GT7 rendering/FPS lane (18 Aug, evening) - the walls fell; continues the afternoon file
# ⚠ CONTINUED: HANDOFF_RENDERING_ACT2.md (runs 56-71, 19 Aug) - THE GAME IS PLAYABLE now
# (Music Rally drives with live HUD); read that file first, this one for background.

Same repo/build/run rules (8.3 paths, build.bat + BUILD EXIT 0 **and** the exe timestamp, user runs
GT7_work\GT7_PSN.bat, Claude reads shad_log.txt; logs in GT7_work\logs\runNN_*). Run ledger
continues from 41; this file covers runs 42-55.

## STATE AT HANDOFF: run 55 reached 650 compiles, 0 crashes of the old kinds, died on VRAM OOM

Every previous ceiling is behind us: the 195-wall, the bindless assert at 203, V_INTERP at 205,
BCn macro-tiled at 206, the bindless vs/fs pair at 250. The FWRKR boot crash is DEAD (root-caused,
fixed): 10/10 clean boots. The new frontier is ErrorOutOfDeviceMemory at ~650 compiles (see OPEN).

## THE TWO ROOT CAUSES OF THE DAY

### 1. The FWRKR boot crash was a FILE-SHARING bug (fixed ungated, host_fs.cpp)
The guest opens /app0/contents/gt.idx from two threads; IOFile's default share flag is
ShareReadOnly (_SH_DENYWR) and HostFile never overrode it, so the overlapping open failed EACCES
("permission denied" on a file that is right there), GT7's content provider stayed NULL, and its
File WoRKeR thread crashed dereferencing it. ~50-70% because it is a race between the two opens.
PROOF CHAIN, all measured:
- new guest-crash forensics (signals.cpp): module+offset (eboot.bin+0x3a2273d), registers
  (rax=0xDEADBEEF54321ABC = our own g_stack_chk_guard, so the crash is right after a prologue),
  stack return addresses, and guest_crash.dmp (parse with python struct + pip capstone: the code
  is `mov rdi,[r14+0x58]; mov rax,[rdi]; call [rax+0x18]` followed by FNV-1a of a name = a
  service lookup on a null registry);
- every crash log carries `gt.idx ... permission denied` right before the crash; gt.idx opens
  fine standalone (1.5 MB plain file);
- FIX: HostFile opens ShareReadWrite (POSIX has no sharing restrictions at all). After: 1 open,
  0 failures, 10/10 clean boots.
- io_file.cpp logs `_doserrno` on open failure now: 32 = SHARING VIOLATION (another handle),
  5 = ACCESS DENIED (ACLs). Bare errno conflates them; that conflation cost a day.

WARNING: the env-matrix conclusions that predated this fix were CONTAMINATED - "DEFER_EOP crashes
boots 6/8" and "DMA crashes boots 4/4" were the file race wearing different timing. Honest fences
are back ON in -Net. DMA deserves a retrial (never re-tried after the fix).

### 2. The 195-wall was TORN GPU-DRIVEN DESCRIPTORS; the answer is SURVIVAL, not prevention
GT7's GPU-driven stream writes descriptor tables (V#/T#) the emulator reads at parse/bind time;
sometimes the game has not finished writing them. ONE disease, FOUR symptoms, all now handled:

| symptom | where it killed | now |
|---|---|---|
| unmapped base (0x24, 0xff4397d675...) | ClampRangeSize assert (run 49) | [softclamp] null-bind, run continues |
| mapped-but-misaligned base | BindBuffers adjust%4 assert (runs 19/35/50) | [softclamp] null-bind, run continues |
| gt.idx sharing race | FWRKR boot crash | fixed at the root |
| plausible-but-wrong T# | GPU park = the 195 wall | absorbed by the guards; no park since run 50 |

GT_SOFT_CLAMP=1 (-Net sets it): memory.cpp ClampRangeSize returns 0 + logs instead of asserting;
BindBuffers/BindTextures validate V#/T# bases (IsValidMapping) and alignment, null-bind loudly;
buffer_cache vertex ranges skip-with-log. The victim is nearly always cs_0x6421a7b6 (the audio
counter) - dozens of saves per run, all harmless.

EXONERATIONS - do not re-litigate: the wall was NOT the producers' data (GT_DYNRC_WINDOW
diagnostics measured REAL live tables: ~1600/2048 nonzero, changing per dispatch), NOT eager
fences (run 47: honest fences, identical hang), NOT dispatch dims (the live stall dump caught the
parked dispatch: DispatchDirect 4x4x6 / 8x8x1 - textbook cubemap prefilter), NOT indirect args
(DispatchDirect, guest_addr 0), NOT the bindless stub (0 stubs fired pre-death, 3 runs).

## WHAT GOT BUILT (working tree; env-gated unless noted)
1. Guest crash forensics (signals.cpp): module+offset, registers, stack walk, guest_crash.dmp
   with guest memory ranges. GT_NO_GUEST_DUMP=1 disables the dump.
2. GT_DYNRC_WINDOW=2048 (flatten pass + info.h + emit_spirv): dynamic-offset ReadConst reads a
   bulk-copied window of its base pointer inside the flatbuf, index clamped. Now feeds DOZENS of
   shaders incl. fs materials (windows @147..@250). RefreshFlatBuf logs the first 4 dispatches
   per shader: nonzero count + first index ("ALL ZERO" would mean GPU-written tables; never seen).
3. GT_STALL_DUMP=1 (vk_scheduler + vk_instance): completed tick frozen more than 700 ms with more
   than 256 submits piled up -> dump the work journal LIVE while the rings still hold the hung
   tick; prints OLDEST-TICK ENTRY with dims/threads/guest_addr. SubmitHistory ring 512 -> 16384.
   This is the instrument that NAMED the hung dispatch after three blind post-mortems.
4. GT_IMG_TRACE=1: per-dispatch image bindings of the three producers, joined to the stall dump
   by journal seq.
5. GT_SOFT_CLAMP=1: the survival net (see above).
6. GT_BINDLESS_STUB=1 extended: NOOP_FRAGMENT_SPV (32 words) + NOOP_VERTEX_SPV (67 words,
   Position=(0,0,0,1) -> degenerate -> the draw vanishes) beside the compute stub; all
   spirv-val'd. GT7 sends bindless vs+fs PAIRS (one material) so the empty interface matches.
7. Recompiler/texture fixes: V_INTERP_MOV_F32 assert relaxed (P10/P20 on non-flat attrs is
   handled by the barycentric path; the 4070 has the extension); image_info allows BCn +
   macro-tiled sizing (block units already flow through the same math as linear/micro).
8. host_fs ShareReadWrite + io_file _doserrno logging (ungated correctness, PosixSocket class).
9. buffer.cpp OOM assert now logs the REQUESTED SIZE (the run-56 discriminator, see OPEN).

## RUN LEDGER 42-55
| run | what | outcome |
|---|---|---|
| 42-44 | windows armed | 3x identical device lost @195, fault span byte-identical (0x890) |
| 45 | boot | FWRKR crash WITH forensics -> gt.idx file-race root cause |
| 46 | share fix | boot clean; stall dump NAMES the hung work: cs_0xda05e7f8 |
| 47 | honest fences | still stalls on da05e7f8 -> fences exonerated |
| 48 | dims in dump | DispatchDirect 4x4x6 = NORMAL -> garbage-args theory dead |
| 49 | img trace | died EARLIER, on CPU: ClampRangeSize 0x24 = torn descriptor caught red-handed |
| 50 | softclamp v1 | died at BindBuffers adjust%4 = the misaligned sibling |
| 51 | softclamp v2 | WALL BROKEN: 205 compiles, survived 2 torn V#s, died at V_INTERP |
| 52 | V_INTERP fix | 206, survived 0x24 live, died at BCn macro-tiled sizing |
| 53 | BCn fix | 250 compiles + 54 flips, died at bindless FRAGMENT |
| 54 | frag stub | frag stub worked, died at bindless VERTEX |
| 55 | vert stub | 650 compiles, 9 stubs, ~50 softclamp saves, died: VRAM OOM (buffer Create) |

## OPEN / NEXT
- **VRAM OOM at ~650 compiles** (ErrorOutOfDeviceMemory, 4070 12 GB, process 8.4 GB). The GC
  exists and is budget-aware (VK_EXT_memory_budget present) but runs only per guest frame
  (Rasterizer::OnSubmit from liverpool submit_done); GT7's streaming allocates thousands of
  buffers between frames. buffer.cpp now logs the requested size: a few-MB request means GC
  pacing (fix: trigger GC from allocation pressure, or purge + retry on OOM), a multi-GB request
  means a torn V#'s garbage SIZE slipped past the base guards (fix: sanity-cap sizes at bind).
  Run 56 decides which.
- **Real bindless** is the honest fix for the stubs AND the softclamp class: GT7 materials fetch
  T#s from the same GPU-written record tables (the fs windows prove it). Descriptor indexing +
  GPU-time fetch = a full session. Until then: stubs (missing meshes/materials) + null binds
  (one wrong draw) are the price of staying alive.
- DMA retrial now that the boot is clean (the 4/4 boot-crash verdict was contaminated).
- Diagnostics (imgtrace, stall dump, dynrc logs, softclamp spam from 0x6421a7b6) cost log I/O -
  gate them tighter before any "playable" build.
- The -Net env block in run_gt7.ps1 is the source of truth: SPLIT=1, DEFER_EOP=1,
  DEFER_RELEASEMEM=1, BINDLESS_STUB=1, STALL_DUMP=1, IMG_TRACE=1, SOFT_CLAMP=1, DYNRC_WINDOW
  default 2048, DMA off.

## NEW TRAPS (older files' traps still hold)
- A background-task notification saying "completed (exit 0)" is the SHELL's code - the build
  inside printed BUILD EXIT 1. Judge by the log tail + exe timestamp, always.
- `cmd //c build.bat` does not inherit a bash cd - use the absolute 8.3 path.
- Piping a build through `tail -4` eats the error line forever - capture full output to a file.
- boost static_vector has no .full() - use size() < capacity().
- Windows python wants C:\ paths; /c/... throws FileNotFoundError.
- llvm-objdump 22 cannot disassemble raw bytes and llvm-mc is not shipped; pip capstone is the
  fastest minidump-to-instructions route.
- ASSERT_MSG's message prints on the line AFTER "Assertion Failed!" - grep -A2.
- An imgtrace block whose per-image lines are missing NAMES the victim: the fatal image died
  mid-loop between header and img line.
