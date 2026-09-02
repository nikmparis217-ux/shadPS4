# HANDOFF ACT TWO (19 Aug, 00:00-02:30): FROM "BOOTS DEEP" TO "THE GAME IS PLAYABLE"

Continues HANDOFF_RENDERING.md (runs 42-55). This file covers runs 56-71.

**THE HEADLINE: GT7 now boots, walks its initial setup, loads MUSIC RALLY
(Alsace-Village, Porsche 356 Speedster) and THE USER DRIVES IT** - live HUD (song,
beat counter, miles, gear, mph), music, mouse-driven menus. The 3D world renders
(trees, hills, road, clouds). Remaining visual defects - big screen-space smears, a
solid-red track-preview RT, washed passes - all trace to the STUBBED bindless
shaders + null-bound torn descriptors = the "real bindless" job, unchanged as the
one big next thing.

## WHAT GOT FIXED, IN ORDER (each verified by the next run)

1. **stubs.cpp dedupe (upstream bug)**: GetStub burned one slot PER RESOLUTION, not
   per unique nid, and the linker does not log libc/Fios2 stub creation - so 8192
   (then 16384) slots exhausted SILENTLY and the update-check freeze polled a
   NAMELESS stub for a day. One slot per unique nid now; every stub call logs its
   name (aerolib CommonStub).

2. **The welcome freeze was sceDeviceServiceGetEventState** - the "Updat" thread
   polls device-firmware-update events forever on a zero-returning stub. NEW HLE
   library `src/core/libraries/device_service/` (4 nids: Initialize 84fDxStrG44,
   Terminate Uq8uW74rVpU, GetEventState 9ddRUOV8Q5A, QueryDeviceInfo_ UNMEa+5lrUA;
   returns invented NO_EVENT 0x80AC0004; registered in libs.cpp + CMakeLists +
   logging classes.h/log.cpp as Lib.DeviceService). NOTE: the game ALSO advances
   past the welcome with a button press - devsvc has logged 0 calls in later runs.
   Keep it; harmless and honest.

3. **Buffer GC saga - three lessons**:
   a) upstream BufferCache::RunGarbageCollector NEVER CALLED its clean_up lambda
      (defined, never invoked - the buffer GC never freed one buffer in shadPS4's
      history). Wired behind GT_BUFFER_GC=1.
   b) the FIRST GC pass crashed the parser thread: DownloadBufferMemory(async)'s
      deferred write_data captured LOCALS BY REFERENCE and DeferOperation ran it on
      a dead frame - latent forever because the GC's clean_up was its ONLY caller.
      Fixed with owning captures. Diagnosed by symbolizing run 57's minidump rip
      against exe+PDB: **shadps4.exe ImageBase is 0x700000000000** - every 0x7000...
      "guest" address all week was HOST code.
   c) **GT_BUFFER_GC IS OFF AND MUST STAY OFF until DeleteBuffer gates the erase on
      ALL THREE schedulers**: the deferred erase waits on the DRAW tick only, while
      present/flip cmdbufs may still reference the buffer. Runs 60-63 device-lost at
      the welcome zone naming a DIFFERENT innocent shader each time (draw 420x1,
      draw 6x1...); run 63 died at 5.4 GB which killed the memory-pressure theory.
      The A/B settled it: GC off (run 64) = no device lost, flips sailed past the
      death zone.

4. **The 2.62 GiB OOM was TAIL DESCRIPTORS, not garbage**: GT7 binds V#s sized
   "whatever remains to the end of a ~2.6 GiB heap" (561/564/584/586 MB at dozens of
   bases - classic engine practice, stable across draws). Mirroring the whole tail
   into a device buffer per bind IS the ErrorOutOfDeviceMemory of runs 55/56/64.
   Fix in Rasterizer::BindBuffers: clamp the BIND to the first 256 MB (TailBindCap;
   robustness zero-fills reads past it). WARNING: NULL-binding them instead (the
   first attempt, "torn size" cap) broke EVERY material - run 65's log flood of
   "torn size, null-bound" was THE LEGITIMATE HEAP being refused. Materials returned
   when the clamp replaced the null-bind.

5. **Torn descriptors reached FOUR new organs; each got a softclamp guard**:
   - page tracking REGISTERED at guest address 0 -> AddressSpace::Protect hit UB
     (--upper_bound(0)) / assert (run 66). Guards: Protect skips below the address
     space, and page_manager REFUSES (un)tracking of regions below 64 KiB (guest
     floor; no legitimate guest data lives there).
   - THE SNEAKIEST: a mapped-but-wrong tracked region can SPAN THE GUEST'S OWN CODE.
     Protect stripped EXECUTE off eboot's pages and a dozen threads collapsed at
     once with DEP faults that the wild-jump guard mislabeled "GUEST WILD JUMP at
     eboot+X" (runs 67/69 - and my Protect skip is what let the sweep continue past
     the old assert). Protect now NEVER strips EXECUTE from a page that has it
     (VirtualQueryEx first; legitimate game DATA is never executable, so the upgrade
     only ever touches bogus trackings). Blocked 20 sweeps in run 70.
   - torn S# (SAMPLER) with a garbage mip filter -> liverpool_to_vk MipFilter
     Unreachable (run 68, mid-race). Defaults to Linear with a [softclamp] log.
   - CopySparseMemory from address 0 (run 70, mid-race texture upload) -> zero-fill
     the destination + log instead of assert.

6. **GUEST WILD JUMP guard in signals.cpp**: an execute-AV (op==8, or fault==rip)
   skips the AV dispatch chain - Zydis decoding AT a garbage rip re-faulted INSIDE
   the handler and buried the real context (run 58) - and logs the ORIGINAL frame
   with the guest stack. WARNING: its message also fires on DEP faults from
   de-executed code pages (see 5): "many threads at once" = de-execute sweep, NOT a
   real wild jump. One thread = real (run 58 style: guest jumped to 0x54b3a9eb).

7. **GT_STUB_SHADERS env** (vk_pipeline_cache): comma-separated hex program hashes
   -> NO-OP module substitution. Shipping list: acec97cd,78bfb00e (two fs that
   "parked" the draw scheduler pre-GC-off; with the GC identified as the killer they
   may be INNOCENT - untested, try removing them).

8. **Resolution pinned 1080p** in AppData\Roaming\shadPS4\config.json
   (GPU/internal_screen_* and window_* = 1920x1080; the file has a UTF-8 BOM - read
   with utf-8-sig). GT7's own Display Settings still SHOWS "2K" - that is whatever
   sceVideoOut advertises; cosmetic so far.

9. Diagnostics added: OLDEST-TICK ENTRY prints draw counts (indices x instances);
   Instance::GetVmaStatistics (VMA-owned bytes/allocs census); aggressive-GC census
   log (dead code while the GC is off).

## RUN LEDGER 56-71 (short)
56 old-exe OOM repro | 57 GC freed 32 buffers then write_data UAF killed the parser |
58 real guest wild jump (0x54b3a9eb), masked by nested Zydis fault | 59 FIRST 3D
RENDER ("Welcome to GT7" over a real scene) + welcome freeze (Updat poll) | 60-63
device-losts at the welcome zone = GC cross-queue use-after-free (rotating innocent
shaders; 63 died at 5.4 GB) | 64 GC OFF: no devlost, OOM names a 2.62 GiB single
buffer | 65 null-bind cap broke materials BUT REACHED THE RACE (1143 compiles -
record) | 66 Protect(0) assert | 67 de-execute cascade | 68 RACE DRIVING with live
HUD, died torn-S# MipFilter | 69 old exe relaunched by accident, de-execute again |
70 exec-guard blocked 20 sweeps, died CopySparseMemory(0) | 71 IN FLIGHT: the world
renders, Music Rally menu fully functional, user driving.

## OPEN / NEXT (in perceived order of value)
- **REAL BINDLESS (descriptor indexing + GPU-time T#/V#/S# fetch)** - the one big
  job, a full session. Every remaining visual defect points at it: the 9-11 stubbed
  bindless cs/fs (post-FX smears across the scene, the solid-red track-preview RT),
  null-bound torn descriptors (one wrong draw each), and the windowed-dynrc
  approximation itself.
- Buffer GC re-enable = make DeleteBuffer's deferred erase wait on ALL THREE master
  semaphores (or N flips). Until then VRAM sits at ~5-8 GB, fine now that tail
  mirroring is capped at 256 MB per bind.
- sceVideoOut: advertise a 1080p display so GT7's own settings say 1080p, not 2K.
- TM_FFB / TmBluetooth guest threads (GT7's Thrustmaster wheel stack) crash
  occasionally on zeroed sceBluetoothHid* stub data (first-faulters of runs 67/69).
  If one recurs as the FIRST fault of a run: implement sceBluetoothHidInit -> a
  negative error so GT7 never spins the TM stack at all (lib libSceBluetoothHid;
  nids: Init tul3-GzejQc, RegisterCallback 4Ypfo9RIwfM, RegisterDevice 4FUZ+c52d2k).
- Try removing acec97cd/78bfb00e from GT_STUB_SHADERS (the GC was the likely killer).

## NEW TRAPS
- **llvm-symbolizer --obj=shadps4.exe <raw address> resolves ANY crash rip**
  (ImageBase 0x700000000000, PDB beside the exe). The fastest diagnosis in this
  repo now - it ended a three-wrong-theories night in one command.
- A "GUEST WILD JUMP at eboot.bin+X" on MANY threads at once is a de-execute sweep,
  not a jump.
- config.json has a UTF-8 BOM: json.load(..., encoding='utf-8-sig').
- Log-once caps matter: run 65's per-draw CRITICAL spam was its own I/O tax and
  drowned the monitors; the tail-clamp logs 32 then goes quiet.
- Monitor hygiene: a raw "BindBuffers" filter floods the context when a per-draw
  guard fires - dedupe in the monitor or filter tighter.
- Bash heredocs still break on apostrophes in prose; the Write tool is the reliable
  way to produce these handoffs.


---

# ACT THREE (19 Aug, 03:00-05:20): THE BINDLESS LOWERING GOES LIVE - runs 74-86

## THE HEADLINE

**8 of the 9 stubbed bindless shaders compiled and ran tonight** (run 83: only
cs_a95f906e left), the game DROVE Music Rally with world + HUD + minimap-route, and
every crash of the night was root-caused to a named defect with a fix or a bisect
switch. The night ended on a device fault that the bisect matrix says is NOT caused
by the new writes/images - it is either in the loads or predates the whole feature
(same family as HANDOFF_DEVICE_LOST.md).

## THE FEATURE SET (all in the tree, all built, all env-gated)

1. **GT_BINDLESS_LOWER=1 - SELECTIVE DMA.** An untrackable bindless ReadConstBuffer
   becomes a GPU-time BDA read stamped with SrtBindlessFlagBit (bit 30, srt.h).
   Global directMemoryAccess stays OFF: run 74 proved the global setting works but
   is unplayably slow (the rasterizer re-syncs ALL mapped ranges on the CPU for
   every draw whose stage has any ReadConst - the user's "CPU does everything, GPU
   nothing" observation was exactly right). Only shaders carrying the bit get the
   bda_pagetable + fault_buffer + read_const_dynamic machinery
   (info.uses_bindless_reads keeps it alive when the global setting is off).
   Files: srt.h, resource_tracking_pass.cpp (lowering sites),
   emit_spirv_context_get_set.cpp (EmitReadConst routes bit30 first),
   shader_info_collection_pass.cpp (classification + keep-alive), info.h.

2. **VMEM load lowering** (same gate): LoadBufferU32/x2/x3/x4 off a GPU-fetched V#
   -> address rebuilt at GPU time (stride = dw1[29:16] read LIVE from the V#), one
   ReadConst per dword. 17 fired in run 76.

3. **GT_BINDLESS_STORES (default 0 after run 86)**: StoreBufferU32/x2/x3/x4 -> new
   IR op WriteConst (opcodes.inc, ir_emitter, EmitWriteConst = conditional OpStore
   through get_bda_pointer; listed in MayHaveSideEffects or DCE eats it), and
   BufferAtomicIAdd32 -> ConstAtomicIAdd32 (OpAtomicIAdd through the same pointer).
   55 stores lowered in run 77; this is what unstubbed 5b72414a/80ee7815/aeea6ad8.

4. **GT_BINDLESS_IMG (default 0 after run 85)**: a T#/S# fetched from a TRACKED
   buffer at a CONSTANT offset ("ReadConstBuffer #binding, #index" - the pattern
   ALL four image-blocked shaders show) becomes a BIND-TIME GUEST DEREF:
   ImageResource/SamplerResource grew deref_buffer/deref_offset_dw and GetSharp
   reads the descriptor out of guest memory every time it runs (resource.h,
   ReadGuestSharp + junk-address guard). 26 fired in run 81; unstubbed 8b8ab9e1 +
   fs_29681a2f + (indirectly) 3e50e1.

5. **Precise abandon logging**: every has_bindless_sharp site now logs WHICH op and
   WHICH handle opcode blocked it. Never diagnose from dumps again - the dump is
   written at the FIRST failure and misrepresents everything after it.

6. **Hull shader clamp**: GetAttributeRegionKind (hull_shader_transform.cpp) logs +
   clamps count>2 instead of asserting - hs 0x27d2194a took the emulator down on
   the way into the race (run 76).

## THE SAFETY NET (all permanent, all earned by a named crash)

- **bda_pagetable zero-filled at construction** (buffer_cache.cpp ctor) - it was
  DeviceLocal uninitialized VRAM; junk V# chases read garbage "device addresses"
  and a GPU write through one = WriteInvalid device lost (run 77).
- **get_bda_pointer bounds-checks the page index** (spirv_emit_context.cpp) - an
  OOB OpAccessChain on a junk 40-bit+ address is undefined.
- **Fault-buffer filter** (fault_manager.cpp): faulted pages that are not mapped
  guest memory are ignored (junk chases recorded junk pages; FindBuffer on them
  crashed the CPU in ResolveOverlaps - run 78). Count clamped to MaxPageFaults too.
- **ResolveOverlaps refuses suspicious ranges + expand_begin underflow fixed**
  (begin < min_page wrapped and page_table read wild memory = the exact
  "reading 0xffffffffffffffff" of runs 78/81).
- **CreateBuffer junk-range substitution**: a junk base aligned down to 0 got a
  256 MB buffer created AND REGISTERED at guest 0, poisoning page_table + BDA
  pagetable for the whole low 256 MB (run 82 white-screen-and-stuck). Junk ranges
  now get an UNREGISTERED 1-page dummy and a CRITICAL log naming the range.
- **Barrier after uses_dma dispatches** (vk_rasterizer.cpp DispatchDirect) - BDA
  writes bypass every buffer-cache barrier. Kept even though it did not fix run 84.

## THE JUNK SIGNATURES (recognize them instantly)

- "junk range 0x0+0x10004000" and "0xffffffc000+0x10004000": base 0 / base -16K
  (40-bit wrap), size = GT_SOFT_CLAMP TailBindCap 256MB + one 16K page. Something
  produces V#s with base 0 or 0-minus-a-page that pass ClampRangeSize. UNSOLVED who.
- Device fault "InstructionPointerFault 0x20001xxxx + WriteInvalid 0x3fxxxxxxx":
  runs 83/84/86 - SAME with writes+images on, writes only, and loads only. The
  bisect therefore CLEARS stores/atomics/images of this fault. Suspects: the load
  lowering itself, or the pre-existing device-lost disease. NEXT EXPERIMENT: run
  with GT_BINDLESS_LOWER=0 entirely (one env flip) - if the fault persists, it
  predates tonight and the whole feature is exonerated; if it vanishes, it is in
  the loads (then suspect: unaligned base, or reads racing the ACB queue).

## RUN LEDGER (74-86)

74 global DMA retrial: BOOTS AND PLAYS (kills the old "DMA crashes boot" verdict),
   vs_2df86cf8 compiles, 109 lowerings - but unplayably slow (CPU-bound).
75 selective DMA: same result, fast. 7 stubs left.
76 +VMEM loads: 17 lowered, Music Rally reached, crashed on hull assert.
77 +stores/atomics build (hull clamped): 55 stores lowered, 3 shaders unstubbed,
   WriteInvalid device lost -> pagetable zero-init + bounds check.
78 CPU crash ResolveOverlaps (fault-buffer junk) -> filter.
79 stable, Music Rally, game-stuck later. 80 same, screenshots: world+HUD+driving.
81 +image derefs: 26 fired, 2 stubs left, CPU crash ResolveOverlaps (junk T#) ->
   deref address guard + underflow fix.
82 refusal caught 0x0+256MB live; pagetable got poisoned by the registered junk
   buffer -> white screen + stuck -> CreateBuffer dummy substitution.
83 1 STUB LEFT (only a95f906e). Device fault at boot (IP+WriteInvalid family).
84 +uses_dma barrier: same fault -> not an ordering hazard.
85 images OFF: boots past init (image derefs implicated in the BOOT crash),
   stuck in controller wizard (writes still on).
86 stores OFF too (loads only): SAME device fault family -> writes/images cleared.

## STATE OF THE SCRIPT

run_gt7.ps1 -Net sets: GT_BINDLESS_LOWER=1, GT_BINDLESS_IMG=0, GT_BINDLESS_STORES=0
(the conservative loads-only config). Flip the two zeros to re-enable; -Dma is the
global-DMA experiment (slow, works).

## NEXT MOVES, IN ORDER OF INFORMATION PER RUN

1. GT_BINDLESS_LOWER=0 run: does the IP+WriteInvalid fault predate the feature?
2. If it is the loads: check alignment (V# base not 4-aligned -> unaligned PSB
   OpLoad), and whether ACB-queue dispatches see the DRAW-queue-maintained
   pagetable (cross-queue coherence: the pagetable Fill/WriteDataBuffer record on
   the draw scheduler; a vqid dispatch may run on another queue with NO ordering).
3. The last stub, cs_a95f906e: ImageWrite through a fetched T# - needs
   GT_BINDLESS_IMG on, plus "deref T# valid-but-wrong at first bind" solved (its
   boot-time table is the suspected source of the run-83/84 boot faults; GetSharp
   re-reads per bind but the created IMAGE VIEW may not follow a changed T#).
4. The wizard/Music-Rally "stuck" states: the game polls something GPU-produced.
   Get a stuck run on loads-only config and read what GpuCommandProcessor last did.
5. The 0x0/0xffffffc000+TailBindCap junk V# producer: one-shot backtrace log in
   BindBuffers when base < 16K or > 2^40-32K, naming shader and pipeline.


---

# ACT FOUR (19 Aug, 17:30-19:40): THE FAULT FAMILY DIES, THE WORLD MAP OPENS - runs 87-99

## THE HEADLINE

**The IP+WriteInvalid device-fault family that ended Act 3 is DEAD** (root-caused from logs
alone, no bisect run needed), **GT7 loaded its WORLD MAP for the first time ever** (run 91:
full map, live clock, working UI, OFFLINE MODE banner - normal, Polyphony's own servers do
not exist locally), the old bisect verdicts against stores/images/the-two-fs were ALL
overturned and everything is re-enabled (2 stubs left), and the **pipeline cache is ON and
measured: run 95 did 0 shader compiles where run 90 did 958** - the in-play compile stutter
is gone on warm runs. Every crash 87-98 was root-caused and fixed same-session.

## THE MORNING POSTMORTEM THAT REPLACED THE BISECT

Act 3's Next Move #1 (GT_BINDLESS_LOWER=0 run) was answered WITHOUT a run: run 86's log has
ZERO "lowered to GPU-time" lines and none of the bindless hashes ever compiled - it already
WAS the feature-off run by accident, and it died with the byte-identical fault. Then the
chain was found in ALL THREE fatal runs (83/84/86), a few hundred lines before each death:

    [softclamp] shader 0x6421a7b6: V# base 0x24 size 1243 MB - tail descriptor...
    CreateBuffer: junk range 0x0+0x10004000 - substituting an unregistered dummy page

**cs_0x6421a7b6 binds a torn V# with base 0x24** -> passes the base!=0 entry guard -> tail
clamp -> CreateBuffer aligns down to 0 -> the 16 KiB dummy at cpu_addr 0x4000 ->
**Buffer::Offset(0x24 - 0x4000) is a u32 UNDERFLOW** -> a descriptor with offset ~4.29 GiB
and range 256 MiB on a 16 KiB buffer, is_written -> WriteInvalid. The write addresses
varied per run because VMA places the dummy differently; the IP was stable because it is
the NV shader-ISA zone. The run-83/84 "boot faults with images on" carried the same 0x24
signature - the whole "images are implicated" bisect verdict was this one bug.

## WHAT WENT IN (all built, all verified by the run after them)

1. **Guest floor/ceiling null-bind** (vk_rasterizer BindBuffers): V# base < 64 KiB or
   >= 2^40-64 KiB -> null-bound + budgeted log. Caught cs_6421a7b6 producing base
   0xffffffff20 live in run 88.
2. **Descriptor range clamp**: no buffer descriptor is ever emitted with offset/range
   outside its backing VkBuffer (robustness does NOT cover an out-of-range
   VkDescriptorBufferInfo). Covers every future torn case, not just 0x24.
3. **BDA registry + fault attribution** (new bda_registry.h; register in Buffer ctor,
   unregister in ~UniqueBuffer - whose move ops did NOT move bda_addr, fixed): the
   VK_EXT_device_fault handler now prints, for every memory fault, the nearest live
   buffers with guest ranges and deltas. First payoff run 95: "ReadInvalid 0x300100000 -
   contained by NO live buffer" in the log itself.
4. **GT_IMG_TRACE off** in run_gt7.ps1 (72,171 CRITICAL lines in run 86 alone).
5. **AddressSpace::Protect hardening**: (a) VirtualProtectEx failure = budgeted CRITICAL
   log + skip, never UNREACHABLE (run 87 died there on torn tracking at 0xff43bf1000);
   (b) THE BIG ONE - **the region-walk loop NEVER CHECKED regions.end() - an upstream
   bug**: a torn tracking near the top of the address space walks past the last region
   and dereferences end(). Run 87 crashed on it; run 92 SPUN FOREVER in it
   (GpuCommandProcessor pegged, game frozen mid-race, zero log lines - looked exactly
   like "the game is stuck"). Fixed with an end() check.
6. **PageManager::ClaimOrphanedProtection**: a tracked region that spans past the
   GPU-mapped area ("Tracking ... not fully GPU mapped") write-protects pages the
   rasterizer will never claim (Rasterizer::InvalidateMemory returns false on !IsMapped),
   and the guest then dies ON ITS OWN HEAP - runs 88/90, reproducibly: unhandled write AV
   at the LAST DWORD of the newest 2 MB direct-memory block, right at race start. Now: if
   WE restricted the page and the rasterizer declines the fault, restore RW and claim it.
   Watcher counts are deliberately left alone (zeroing trips "Not enough watchers" on
   unregister); a re-protect just faults+claims once more.
7. **MemoryManager::IsMappedMemory** (new): **IsValidMapping counts FREE VMAs as valid** -
   it only asks "is the range inside the vma_map". Run 94 proved it: a guard using it
   passed and the crash stayed. IsMappedMemory = FindVMA + IsMapped() + Contains(), used
   now by ReadGuestSharp, ClaimOrphanedProtection (an IsValidMapping claim on a free page
   = infinite fault loop) and the ACB guard.
8. **ReadGuestSharp maps-check**: runs 93/94 crashed the MAIN thread AT BOOT dereferencing
   a plausible-but-unmapped guest table - **the warm pipeline cache runs GetSharp before
   the game has mapped the table the V# points at**. Range guards were never enough.
9. **ACB span guard** (Liverpool::ProcessCompute): run 91 died reading a PM4 header at
   0xffffffffffffffff (garbage ring read offset -> wild span base). Unmapped span =
   CRITICAL log + drop the submission, parser lives.
10. **DynamicIndex mip-fallback CLAMP** (emit_spirv_image.cpp EmitImageWrite): the
    descriptor-array index comes from GPU-driven data; unclamped garbage (warm cache runs
    the shader before the game writes flatbuf) reads a DESCRIPTOR past the array = the
    deterministic **IP 0x2000f1330 + ReadInvalid 0x300100000** of runs 95/96/97. Proven by
    substitution in run 98 (stub da05e7f8 -> exactly that fault vanished; the OLD
    parked-IP hang family resurfaced instead, because da05e7f8 is the PRODUCER and its
    consumers hang unfed - so it must run, clamped). TextureDefinition grew num_bindings;
    OpUMin before the OpAccessChain.

## PIPELINE CACHE: ON, AND THE OLD VERDICT WAS CONTAMINATED TOO

"true made it die much earlier" dated from the device-lost era. Retried at the user's
fps/graphics pivot: the cache works, fills, and run 95 booted with **0 compiles vs 958**
in the equivalent cold run. Two real gotchas it introduced, both now handled:
- it runs GetSharp/shaders EARLIER than anything before it (the run-93/94 boot crash and
  the run-95/96 deterministic fault were both cache-exposed latencies of existing bugs);
- **a warm cache skips CompileModule entirely, so GT_STUB_SHADERS substitution tests DO
  NOT APPLY to cached pipelines** - run 97 "tested" a stub that never engaged (0
  substitutions in the log, fault unchanged - an INVALID test, not an acquittal). A
  substitution test needs pipeline_cache_enabled=false or a deleted cache folder, and the
  cache folder must be deleted after any stub/emitter change anyway or STALE modules keep
  running (we cleared it after the clamp fix so the fresh cache bakes clamped pipelines).

## RUN LEDGER 87-99 (short)

87 loads-only + fixes 1-4: 0 device faults in 290k lines (2.6x past every fatal run),
died Protect UNREACHABLE on torn tracking at 0xff43bf1000 | 88 stores+images back ON:
0 faults, 1396 compiles (record), boot+wizard clean - bisect verdict dead; died guest
write AV 0x205bffffc (orphaned protection) | 89 Vmm:info run: AV reproduced (same guest
stack), heap = serial 2 MB MapDirectMemory blocks; Vmm logging is itself an I/O tax the
user FELT as slowness - back off | 90 stubs emptied: acec97cd+78bfb00e compiled AND ran,
no scheduler park (the GC was the killer all along, confirmed); AV third repro ->
ClaimOrphanedProtection | 91 WORLD MAP FIRST TIME (2100+ compiles); died ProcessCompute
reading PM4 at -1 entering the circuits -> ACB guard | 92 pipeline cache ON (fills):
entered a race, "stuck" = Protect end() spin -> fixed | 93/94 boot crash in ReadGuestSharp
(cache-early deref; IsValidMapping trap) -> IsMappedMemory | 95 0 compiles (warm cache!),
first ATTRIBUTED fault: ReadInvalid 0x300100000 in no live buffer | 96 byte-identical
repro (deterministic) | 97 INVALID substitution test (warm cache skipped the stub) |
98 valid test: fault GONE with da05e7f8 stubbed, old hang family back (producer must run)
-> mip clamp | 99 IN FLIGHT: clamp live, cache rebuilding clean.

## OPEN / NEXT

- **Run 99 VERDICT: THE FIRST 100% CLEAN RUN IN PROJECT HISTORY.** Exit code 0 (user
  quit), 243,771 log lines, 0 device faults, 0 crashes, 0 asserts. The deterministic
  ReadInvalid 0x300100000 is GONE with da05e7f8 running normally (4 compiles) - the mip
  clamp is confirmed as the fix. The nets each caught one would-be crash live (1 orphan
  claim, 1 guest-floor null-bind). Cache refilled (1915 compiles) for instant next boots.
- **The visual defects the user pivoted to**: world-map bloom blobs over every POI, the
  solid-red track-preview RT, the big white screen-space smears in-race. All post-FX fed
  by the 2 remaining stubs (cs_a95f906e ImageWrite-through-fetched-T# with NON-constant
  index - needs real bindless; cs_3e50e1 re-stubbed since stores came back, find its
  abandon site) and by whatever windowed-dynrc feeds them. THE big job remains
  "real bindless" from Act 3.
- **THE PERF REPORT, now with symptoms (user, 19 Aug evening)**: "every next step it
  drops fps massively", sound drops IN LOCKSTEP with the fps (same bottleneck, not a
  separate bug), textures do not load properly, ~10 fps or less. The progressive shape
  points at the Buffer GC being OFF: nothing is EVER freed, VRAM climbs 5-8+ GB (run 91
  hit 7.6 GB early), and past the 4070 Super's 12 GB the driver pages to system RAM =
  massive drop at each new content step. PLAN: (1) periodic VMA-stats log
  (Instance::GetVmaStatistics exists) to correlate the next slowdown with a NUMBER;
  (2) the known GC prerequisite - DeleteBuffer's deferred erase must gate on ALL THREE
  master semaphores - then GT_BUFFER_GC=1; (3) if still slow, narrow the per-submit DMA
  re-sync to dirty ranges (run-74 slowness at smaller scale, more shaders carry uses_dma
  now that stores/images are back); (4) texture loading is the bindless/stub work.
- **cs_0x6421a7b6 is the junk-V# producer** (bases 0x24, 0xffffffff20, 0x47007c01f,
  0x7c3e1f93de, 0x803e01ccef across runs) - it reads its V# table from GPU-produced data
  our windowed-dynrc approximation fills wrongly/late. The guards make it harmless; real
  bindless makes it correct.
- Buffer GC still OFF (Act 2 item unchanged). VRAM 5-8 GB is fine post-TailBindCap.
- The guest write AV mechanism (orphaned protections) is CLAIMED now, not prevented: the
  tail-clamped 256 MB binds still register page tracking over partially-unmapped ranges.
  Preventing the registration for the unmapped part would be cleaner - not urgent.

## NEW TRAPS (beyond the starred ones above)

- **tasklist //FI can silently miss a process in Git Bash** while netstat shows it
  LISTENING - verify with netstat/Get-Process before declaring a server dead (the
  "offline mode because python died" misdiagnosis cost one loop; python3.12 was alive,
  and OFFLINE MODE is the NORMAL state of this setup anyway).
- **A crash that reproduces at a different km/line count is still the same crash**:
  match on the guest STACK (runs 88/90 shared return addresses).
- **PowerShell Set-Location rejects 8.3 short paths** that direct invocation
  (ampersand + quoted path) accepts - skip cd, use absolute paths in commands.
- Bash double-quoted strings eat PowerShell $-vars before PowerShell sees them - use the
  PowerShell tool for anything carrying $variables. Bash heredocs choke on long prose
  (both attempts at THIS handoff died mid-quote) - Write tool + cat append is the way.


---

# ACT FIVE (19 Aug, 20:00-21:30): THE GC GOES LIVE, AND THE DIALOG HAD A KEY - runs 100-107

## THE HEADLINE

**The buffer GC is ON for the first time in this project's history** (behind a new
all-timelines death gate - the Act 2 3c prerequisite is built), the user's perf complaint
("every next step drops fps massively, sound drops with it, ~10 fps") is instrumented with
a periodic [vram] line, and the recurring textless error dialog that preceded most crashes
traced all the way down to **an EMPTY TrophyKeySet.ReleaseTrophyKey in keys.json**:
ExtractTrophies fails at every boot ("Trophy decryption key is not specified", trp.cpp:47),
sceNpTrophyRegisterContext then reports "Could not find trophy files", and GT7 raises its
error dialog every session - the crash lives in whatever the game does after the user
confirms it. USER ACTIONS PENDING: fill the trophy key (user must source it - it is Sony
key material and is NOT written anywhere in this repo), and install NVIDIA Nsight Graphics
(user agreed) to open device_fault.bin if the fault survives the key.

## THE GC RE-ENABLE (the biggest FPS lever, now shipped)

- **BufferCache::ProcessPendingDeaths** (buffer_cache.cpp/.h): DeleteBuffer no longer
  erases via scheduler.DeferOperation gated on the DRAW tick alone - each death is queued
  with Instance::SnapshotTimelines() (CurrentTick of draw+present+flip) and erased only
  when Instance::AllTimelinesPast() says every timeline passed it (or any timeline is
  lost, when ticks stop being guarantees anyway). Drained per submit from
  Rasterizer::OnSubmit - same thread as every DeleteBuffer caller, no locks.
- ⚠⚠ **DO NOT re-queue from inside a DeferOperation callback**: PopPendingOperations runs
  callbacks WHILE HOLDING pending_ops_mutex (vk_scheduler.cpp:129-133) and DeferOperation
  takes the same mutex - instant deadlock. That is why the graveyard is a plain vector
  drained from OnSubmit instead.
- ⚠ The gate snapshots CurrentTick, and KnownGpuTick maxes at CurrentTick-1 until the NEXT
  submit on that scheduler - so deaths only drain while presentation is live. During
  active play present/flip tick every frame; deaths pile up only when presentation idles
  (documented in the header comment). Watched via "pending deaths N" in the [vram] line -
  observed 0-13, draining fine.
- **GT_BUFFER_GC semantics flipped: unset = ON, '0' = off.** ⚠ texture_cache.cpp had a
  PRESENCE-based `pressure_mode = getenv("GT_BUFFER_GC") != nullptr` that would have
  INVERTED under the new default - aligned to the same unset=on rule. When flipping any
  env default, grep for every OTHER reader of that env first.
- **Periodic [vram] telemetry** (every ~600 gc ticks): device MB, VMA MB, alloc count,
  pending deaths, GC trigger. The user's progressive-slowdown claim now has a number to
  correlate against. ⚠ NOT yet observed under load - every run since died early (the
  dialog crash); the long-session FPS verdict is still owed.

## THE 0x300100000 HUNT - the full A/B ledger (know it before re-litigating)

Deterministic pair "InstructionPointerFault 0x2000xxxxx + ReadInvalid 0x300100000",
attributed by the BDA registry to NO live buffer, appearing in warm-cache runs at the
error-dialog phase. Everything tried, one line each:

| experiment | run | verdict |
|---|---|---|
| DynamicIndex mip clamp (EmitImageWrite OpUMin) | 99 | killed the FIRST site - run 99 was the first 100% clean run ever (exit 0, 243k lines) |
| buffer GC on | 100 | fault returned at a NEW IP (0x20012ea30) - GC irrelevant |
| texture GC off (new GT_TEX_GC gate, unset=on) | 101 | fault survived - image deletion innocent |
| GPU-assisted validation | 103 | fault DID NOT REPRODUCE under instrumentation (consistent with an OOB access the layer's bounds-checking absorbs); crashed later INSIDE the layer/driver (null read in a system DLL) |
| SynchronizeBuffer/DownloadBufferMemory window clamps | 104 | 0 clamps hit in normal play - the GpuAV copy findings are real but not THIS fault |
| skip-empty-dynrc dispatches (Info::HasAllZeroDynrcWindow) | 105 | 0 skips - the all-zero-window theory is dead for this fault |
| devsvc module fix (see below) | 106 | HLE finally binds; dialog AND fault persisted |

Still standing: the substitution proof (run 98: stub cs_da05e7f8 -> exactly this fault
vanished, and the old parked-IP hang family returned because its consumers starve - the
producer must run). The fault is in da05e7f8's work or its consumers' inputs. **Next
instrument is Nsight on device_fault.bin (2.1 MB, rewritten at every fault), which names
the shader + SASS offset directly.** The user is installing it.

## GPU-ASSISTED VALIDATION: how to run it, and what it found

- ⚠⚠ **-GpuAV with a WARM pipeline cache hard-aborts at boot** (exit 255, ~267 log lines,
  no crash record): instrumenting the entire preload at once. run_gt7.ps1 now sets
  pipeline_cache_enabled = (-not $wantGpu). GpuAV runs compile what they touch.
- The 91-finding catalog from run 103 (all real, all still open as visual-defect leads):
  20x VUID-vkCmdDraw-magFilter-04553 (LINEAR sampler on R8_UINT view),
  20x VUID-vkCmdCopyBuffer-dstOffset-00114 + 2x size-00116 (9-region copy whose region[8]
  starts EXACTLY at the end of a 32 MiB dst buffer, writing 4 MiB past it - and 32 MiB is
  precisely the size of GT7's SaveDataMemory memory.dat; the sync/download clamps went in
  for it, 0 hits in normal runs so far),
  20x VUID-VkDrawIndexedIndirectCommand-firstInstance-00554,
  20x VUID-StandaloneSpirv-OpEntryPoint-09658,
  4x vkCmdCopyImage-srcImage-01548, 2x vkCmdDraw-None-09600 (frame image layout
  GENERAL vs SHADER_READ_ONLY - presenter layout bug).

## THE DEVSVC ONE-WORD BUG (fixed, and the Act 2 mystery solved)

`LIB_FUNCTION(..., "libSceDeviceService", 1, "libSceDeviceService", ...)` never bound:
GT7 imports the lib with **module libSceMbus** ("Linker: Stub resolved 9ddRUOV8Q5A ...
(lib: libSceDeviceService, mod: libSceMbus)"), so all four nids fell through to the
zero-returning CommonStub for 40+ runs - THAT is why "devsvc has logged 0 calls in later
runs" (Act 2 #2). Module name fixed to libSceMbus; run 106 shows real calls returning
NO_EVENT. ⚠ When registering a new HLE lib, grep the log for "Stub resolved <nid>" - it
prints the EXACT lib/module pair the game asked for.

## THE DIALOG ROOT CAUSE CHAIN (the evidence trail, in order)

1. User: "when no text is showed here the game crashes ... after I press X" + screenshot
   of a grey dialog with a warning triangle and EMPTY text.
2. Run 107 with **Lib.SaveData:debug** (⚠ the whole SaveData HLE logs at DEBUG - at the
   default *:info filter the subsystem is INVISIBLE; the filter now keeps it raised):
   SaveData is HEALTHY (Mount2/SetParam/SaveIcon/Umount clean, GetSaveDataMemory2 reads).
   memory.dat frozen since Aug 13 = no save point reached, not a write failure (the
   PersistMemory 10-retry + MsgDialog failure path in save_memory.cpp:48 exists and is
   worth knowing, but did not fire).
3. The real errors, present at EVERY boot: `ExtractTrophies: Couldn't extract trophy
   file trophy00.trp` (emulator.cpp:241) <- `Trophy decryption key is not specified`
   (trp.cpp:47) <- **keys.json TrophyKeySet.ReleaseTrophyKey is ""**. Then at dialog
   time: `sceNpTrophyRegisterContext: Could not find trophy files` +
   `GetTrophyUnlockState: Failed to open trophy XML` + libSceMsgDialog loads.
4. The trophy00.trp exists in the game (sce_sys/trophy/, 2.1 MB); only the key is missing.
   The user fills it (32 hex chars into "ReleaseTrophyKey", emulator closed); the key is
   NOT recorded in this repo.

## RUN LEDGER 100-107 (short)

100 GC on: fault @ new IP | 101 tex-GC off: fault stays | 102 GpuAV + warm cache: abort
at preload -> cache auto-off under -GpuAV | 103 GpuAV proper: 91 findings, fault absent
under instrumentation, died inside the layer | 104 copy clamps: fault stays, 0 clamps hit
| 105 skip-empty-dynrc: fault stays, 0 skips | 106 devsvc bound: dialog+fault stay, run
went 61k lines | 107 SaveData:debug: save healthy, TROPHY chain found, fault at 24.7k.

## NEXT MOVES, IN ORDER

1. **User fills ReleaseTrophyKey** -> run 108: does the dialog vanish? does the fault
   (which lives in the post-dialog flow) go with it?
2. **User installs Nsight Graphics** -> open device_fault.bin from any surviving fault
   (rename to .nv-gpudmp if the file picker insists) -> the shader is named directly.
3. **The long FPS session** the user originally asked for: [vram] curve with the GC live,
   "does each next step still drop fps". Sound drops WITH fps (same bottleneck) - no
   separate audio hunt until fps is settled.
4. The GpuAV catalog's layout/filter/firstInstance findings = visual-defect leads.
5. Real bindless - unchanged, still the big one.

## NEW TRAPS

- ⚠ **A warm pipeline cache invalidates GT_STUB_SHADERS substitution tests** (Act 4 note,
  restated because it cost run 97): CompileModule never runs for cached pipelines. Tests
  need cache off or a deleted cache folder - and after ANY emitter change, delete the
  cache folder anyway or stale modules keep executing (done after the mip clamp).
- ⚠ The "Cached permutation N of fs_X conflicts with index M, skipping preload" console
  flood on boot = the serialized cache was written by several different binaries across
  one day. Harmless (those entries recompile) but a wiped cache after a binary change is
  cleaner.
- ⚠ Lib.SaveData logs entirely at DEBUG - any save investigation needs the filter raised
  or the subsystem is a blank page.
- ⚠ tasklist //FI missed a LIVE python3.12 while netstat showed it LISTENING - check
  netstat/Get-Process before declaring a helper dead. And OFFLINE MODE is the NORMAL
  banner for this setup (local PSN signs in; Polyphony's own servers do not exist).
- ⚠ PowerShell Set-Location rejects 8.3 short paths that &-invocation accepts; and bash
  double-quoted strings eat $vars meant for PowerShell - use the PowerShell tool.
- ⚠ Long here-docs to bash get truncated mid-quote (two failures at the same line count);
  handoffs go through the Write tool + cat append.

---

# ACT SIX (19 Aug, 21:15-22:10): PINNED TO v.0.18.0, THE DUMP READS ITSELF, AND TWO CLAIMS RETRACTED

## THE BASE IS A RELEASE NOW, NOT A COMMIT OFF main

Branch **`gt7-v0.18.0`**. Act 1-5 work was UNCOMMITTED (63 files, 4141 lines, only a stale
`gt7_fixes.patch` from 17 Aug) - it is commit `e5c2634f` now, then `aca58f36` merges the upstream
tag **v.0.18.0** (18 Aug), then `37db1a0f` adds the checkpoints below. The merge was clean: the tag
is 2 commits past the old base and touches 3 files (CMakeLists version, flake.nix,
`np_trophy.cpp` = upstream #4865 platinum-popup fix), none of them ours. Exe reports
`FileVersion 0.18.0.0`, `v.0.18.0-2-gaca58f36`. Backups anyway:
`patchwork/gt7_local_20260819_2115.patch` + `backup_device_service_20260819/` +
`backup_bda_registry_20260819.h`.

## ⚠⚠ THE FAULT DUMP DOES NOT NEED THE NSIGHT GUI - AND IT NAMED THE SHADER

`GT7_work/read_fault.ps1` runs Nsight's CLI (`nv-aftermath-format.exe`, present in
`host/windows-desktop-nomad-x64/`, has `--json` too). Run 107's dump, in one command:

    Page fault: Graphics / GPC, Read, "Failed to translate the virtual address", 0x300100000
    Shader infos:   hash 0xcbf4c546448d37f4, type Compute, size 37.00 KiB
    Faulted Warps:  Shader GPU PC Address: compute_01 @ 0x00000030

⚠ **THE 56-BYTE TRAP:** `device_fault.bin` is the RAW VK_EXT_device_fault vendor blob, so it opens
with a `VkDeviceFaultVendorBinaryHeaderVersionOneEXT` (its first u32 IS `headerSize`; 56 here).
Until those bytes are stripped AND the copy is renamed `.nv-gpudmp`, the tool answers only
"is not a valid nv-gpudmp file". The script reads headerSize from the file rather than assuming 56.

**PC 0x30 means the shader dies on its FIRST memory access.** And `cs_0xda05e7f8` was dispatched at
seq 141442/141443/141445 - the last submitted work before the fault, out of 16 distinct compute
shaders in the run - which is the same shader run 98 proved by substitution. The BDA registry says
the address is 11.5 GB past the nearest live buffer and 3.3 GB before the next: not an overrun, a
completely dead device pointer.

## GPU CHECKPOINTS (so the next dump names OUR shader, not "compute_01")

`VK_NV_device_diagnostic_checkpoints`, enabled in `Instance` (`diagnostic_checkpoints`), stamped
from **`RecordGpuWork`** - the one function every draw, dispatch and detile already calls, and it
holds `payload.cmdbuf`, so all six call sites are covered in one place. Marker =
`(journal seq << 32) | (u32)primary_hash`, opaque to the driver, never dereferenced. Every call
site records the work IMMEDIATELY BEFORE the command itself, so the last marker a queue reached
names the work it was about to run. `Instance::LogQueueCheckpoints()` reads them back per queue in
`LogDeviceFaultInfo` and prints seq + shader hash. **`GT_GPU_CHECKPOINTS=0` turns it off** - one
extra command per draw and GT7 records ~6900 draws a frame, so an fps measurement can exclude it.

## ⚠⚠⚠ TWO ACT-5 CLAIMS RETRACTED - THE TROPHY KEY WAS NEVER THE DIALOG

Act 5 said the textless dialog traces to the empty `ReleaseTrophyKey`. **It does not.** Read the
returns, not the log lines:

- `sceNpTrophyRegisterContext` logs "Could not find trophy files" and then returns **ORBIS_OK** -
  the comment at `np_trophy.cpp:846` says so outright ("Stub success here to prevent issues
  specific to missing a trophy key"). Run 107 line 7208: "Context 1 registered".
- `sceNpTrophyGetTrophyUnlockState` with no XML: `*count = 0; return ORBIS_OK` (line 771-775).
- **`libSceMsgDialog` is only ever LOADED** (run 107 line 2139, `loadModule`), ~5000 lines before
  any trophy call. There is no `sceMsgDialogOpen` in the whole run. So the grey warning box is
  **GT7 drawing its own dialog**, not a system dialog.
- The FONTS half of the shadPS4 quickstart is equally unnecessary here: shadPS4 **bundles Noto
  including `NotoSansCJK-Regular.jp.ttc`** (`font_internal.cpp:120-125`), run 107 logs
  "SystemFonts: using bundled Noto fallback for set type=0x180724C4" and **0 FONT_OPEN_FAILED**,
  then `created_primary_face` / `sysfonts_driver_open_ok`. GT7 also loads its own 28 KB font 103x
  via `sceFontOpenFontMemory`.

Both halves of that guide need a jailbroken console anyway (FTP into `/system/vsh`), which this
one is not, so neither was ever available - and neither is needed.

## THE TROPHY SET WITHOUT THE KEY (`make_trophy_xml.py`)

**The TRP ENTRY TABLE IS CLEARTEXT and the icons are unencrypted** (flag 0; only the 23 `*.ESFM`
definition files carry flag 3). So `trophy00.trp` answers the only question that mattered:
**GT7 has 54 trophies** (`ICON0.PNG` + `TROP000..TROP053.PNG`), and all 54 icons extract with no
key at all. npCommId comes out of `npbind.dat`: **NPWR27618_00**.

Written (paths taken from the code, not guessed):
`trophy/NPWR27618_00/Xml/TROP.XML` (54 nodes, id 0 = platinum, all locked),
`trophy/NPWR27618_00/Icons/TROP*.PNG` (54 real icons),
`home/1000/trophy/NPWR27618_00.xml` (same document = the unlock state).
Names/descriptions are placeholders and say so in the file. `gid="0"` throughout, so upstream
#4865's platinum counter cannot fire a spurious popup.

**RUN 108 IS THE EXPERIMENT:** if the textless dialog goes away, the game was reacting to zero
trophies and no key was ever needed. If it stays, the trophy path is exonerated for good and the
dialog belongs to whatever GT7 does with its own UI - stop spending runs on it either way.

## NEXT

1. Run 108 on this base: dialog gone or not; grep `GPU CHECKPOINTS` if anything dies.
2. The long fps session with the GC live (`[vram]` curve) - still owed, still the user's own
   top complaint.
3. Real bindless - unchanged, still the big one.

---

# ACT SEVEN (19 Aug, 21:15-23:30): THE MISSING DIALOG TEXT WAS THE PIPELINE CACHE - runs 108-114

## THE HEADLINE

**The textless error dialog is FIXED, and it was never trophies, never fonts, never the GCs and
never a shader.** The serialized pipeline cache was handing this binary shader modules built by
OTHER binaries, and one of them drew the dialog frame, its icon and its button and not the glyphs.
Every record now carries the BUILD identity, so a rebuild opens a fresh generation automatically
(commit 091057db). Also this act: the base moved to release **v.0.18.0**, the fault dump reads
itself from the command line with no Nsight GUI, GPU checkpoints named a faulting shader for the
first time in this project, and GT7 has a working 54-trophy set with no Sony key.

## HOW THE TEXT BUG WAS FOUND, INCLUDING THE TWO WRONG TURNS

The user said it plainly - "the last chat changed something and now the intro connection errors
have no text" - and the timeline of MY first theory fitted beautifully: the previous session turned
the buffer GC on at run 100, and `GT_BUFFER_GC` also flips the texture cache into pressure mode
(`ticks_to_destroy` 160 -> 16, `num_deletions` 40 -> 1024). Glyphs live in a texture. Run 110 with
`GT_BUFFER_GC=0 GT_TEX_GC=0`: **text still missing. Theory dead.**

Second wrong turn, and the useful one: run 111 flipped `GT_BINDLESS_IMG=0` and **the text came
back** - but that run also had a WIPED CACHE, because a bindless A/B is invalid against a warm
cache (the run script says exactly that in its own comments). Two variables, one result. Run 112
kept `IMG=1` and stubbed only `fs_0x29681a2f`, cold cache: **text again**. Run 113 then went back to
a COMPLETELY DEFAULT configuration - IMG on, no stubs, both GCs on, checkpoints on - with the
offending cache deliberately restored and the fix in: **text, and the game continued.**

| run | config | cache | text |
|---|---|---|---|
| 110 | GCs off | warm | no |
| 111 | IMG=0 | cold | YES |
| 112 | IMG=1 + stub fs_29681a2f | cold | YES |
| 113 | everything default, fix in | the offending one, restored | **YES** |

WARNING **A/B ONE VARIABLE. I did not, twice.** The first run that showed text changed the cache
AND a feature flag; the shader theory it produced (a post-FX pass painting over the dialog) was
plausible, named a real shader, and was wrong.

## THE FIX (vk_pipeline_serialization.cpp)

The three hand-bumped constants (`ShaderBinaryVersion`, `ShaderMetaVersion`, `PipelineKeyVersion`)
describe the FILE FORMAT only. The SPIR-V a shader compiles to changes whenever the recompiler
changes, and nobody bumps a number after an emitter edit - so a store filled across a day of builds
mixes generations. Every record is now written as
`format_version XOR FNV-1a(g_version, g_scm_rev, g_scm_date)`; `g_scm_date` is regenerated on every
build, so any rebuild invalidates the store while same-build caches still preload (the warm
"0 compiles" win is untouched). A foreign store is reported ONCE:

    The pipeline cache was written by a different build of the emulator - ignoring it and
    refilling. This build is 0.18.0 37db1a0f1c

WARNING WARNING **THE OLD SYMPTOM READ AS BOOKKEEPING NOISE.** `Cached permutation N of fs_X
conflicts with index M, skipping preload` IS the sound of a mixed store, and this very file
described it as "harmless (those entries recompile)". It is not harmless: the entries that DO load
are the danger, and they load silently. Run 113: **0 conflict lines**, 182 recompiles, text correct.

## GPU CHECKPOINTS: THE FIRST TIME A DEVICE LOSS NAMED OUR SHADER

`VK_NV_device_diagnostic_checkpoints`, stamped from `RecordGpuWork` (every draw, dispatch and
detile already calls it, and it holds `payload.cmdbuf`, so one place covers all six sites) with
`(journal seq << 32) | shader hash`, read back per queue in `LogDeviceFaultInfo`.
`GT_GPU_CHECKPOINTS=0` turns it off - one extra command per draw and GT7 records ~6900 a frame.
Run 113:

    graphics queue at TopOfPipe:    journal seq 1052047, shader 0xa343d9e2
    graphics queue at BottomOfPipe: journal seq 1052047, shader 0xa343d9e2
    [seq 1052047] SUBMITTED Draw fs_0xa343d9e2 + vs_0x4cfa13d0, 4 vertices, RT 1920x1080

Same seq at both ends of the pipe = the GPU stopped exactly there. The marker is emitted BEFORE the
command it describes, so the named work is what was running.

## READING THE VENDOR DUMP WITHOUT THE NSIGHT GUI (read_fault.ps1)

`nv-aftermath-format.exe` (in Nsight Graphics 2026.3.1, `host/windows-desktop-nomad-x64`, and it
has `--json`) parses `device_fault.bin` from the command line. WARNING **the 56-byte trap:** the
file is the RAW VK_EXT_device_fault vendor blob and opens with a
`VkDeviceFaultVendorBinaryHeaderVersionOneEXT` whose first u32 IS `headerSize`. Until those bytes
are stripped and the copy renamed `.nv-gpudmp`, the tool only says "is not a valid nv-gpudmp file".
The script reads headerSize out of the file rather than assuming 56.

What it gave on three different faults:

| run | fault | dump says |
|---|---|---|
| 107 / 109 | IP 0x20012ea30 + **Read** 0x300100000 | Compute, hash 0xcbf4c546448d37f4, 37 KiB, compute_01 @ 0x30 |
| 113 | IP 0x200016100 + **Write** 0x20005000 | **hash N/A, Compute, 512 B**, @ 0x100, engine reset |

WARNING WARNING **"Shader hash: N/A" with a 512-byte compute shader is NOT a game shader** - it is
a driver-internal transfer kernel (fill / copy / clear). So the WriteInvalid family is a MEMORY
TRANSFER WE ISSUE writing somewhere unmapped, not GT7 shader code. Consistent across runs
111/112/113: 0x20001000, 0x20002000, 0x20005000 - all page-aligned, all low.
Ruled out by reading the code instead of patching it: the BDA pagetable `Fill` cannot overrun,
because `CACHING_NUMPAGES = 2^26` times 8 bytes = 512 MB, which covers the whole 40-bit guest space.
The right instrument is `-GpuAV`, which previously caught a 9-region copy writing 4 MiB past a
32 MiB destination (VUID-vkCmdCopyBuffer-dstOffset-00114).

## THE TROPHY SET, WITHOUT THE SONY KEY (make_trophy_xml.py)

WARNING WARNING **The TRP ENTRY TABLE IS CLEARTEXT and the icons are unencrypted (flag 0)** - only
the 23 `*.ESFM` definition files carry flag 3. So `trophy00.trp` itself answers the only question
that mattered: **GT7 has 54 trophies** (`ICON0.PNG` plus `TROP000..TROP053.PNG`), and all 54 icons
extract with no key. npCommId out of `npbind.dat`: **NPWR27618_00**. Written:
`trophy/NPWR27618_00/Xml/TROP.XML` plus **`TROPCONF.XML`** (emulator.cpp:257 copies THAT name, not
TROP.XML, into every user folder - three errors per boot until it exists), `Icons/TROP*.PNG`, and
`home/<user>/trophy/NPWR27618_00.xml` for every user under `home/`. Result, run 109 onward:

    sceNpTrophyRegisterContext: Context 1 registered      (no "Could not find trophy files")
    sceNpTrophyGetTrophyUnlockState: called                (no "Failed to open trophy XML")

WARNING **AND IT WAS NEVER THE DIALOG.** Act 5's chain was inferred from log lines, not from
returns: `RegisterContext` logs the error and returns **ORBIS_OK** (the comment at np_trophy.cpp:846
says so outright), `GetTrophyUnlockState` returns `*count = 0; ORBIS_OK`, and **`sceMsgDialogOpen`
is never called in any run** - `libSceMsgDialog` only ever appears as a `loadModule` line about
5000 lines earlier. The grey box is GT7 drawing its own dialog.

WARNING The FONTS half of the shadPS4 quickstart is equally unnecessary here: shadPS4 bundles Noto
including `NotoSansCJK-Regular.jp.ttc` (font_internal.cpp:120-125), the fallback fires
("SystemFonts: using bundled Noto fallback"), **0 FONT_OPEN_FAILED**, and the missing "PS4 system
fonts" are Sony's proprietary SST family. Both halves of that guide need a jailbroken console
anyway (FTP into /system/vsh), which this one is not.

## RESOLUTION: IT IS ALREADY 1080p (measured, against the user's report of "2K")

    sceVideoOutSetBufferAttribute: A2R10G10B10Srgb, width = 1920, height = 1080
    RegisterBuffers: bufferNum = 3, width = 1920, height = 1080
    journal: render target 1920x1080x1 for the fullscreen passes

The "2K" inside GT7's own display settings is the label `sceVideoOut` advertises - cosmetic, and
still the open item it was in Act 2. It does not change what is rendered.

## RUN LEDGER 108-114

108 first run on v.0.18.0 plus checkpoints: STALLED before the intro video (5957 lines, poll loop,
no crash, log frozen 2.5 min while the process burned CPU) - the known "stuck" family, and it did
not recur | 109 checkpoints off: 20226 lines, trophy chain CLEAN, fault byte-identical to 107, so
neither the checkpoints nor the trophy files touch it | 110 plus both GCs off: text still missing,
GC theory dead, same fault | 111 IMG=0 plus cold cache: **text back**, 114503 lines (longest ever),
5 shaders no-op, new Write 0x20001000 family | 112 IMG=1 plus stub fs_29681a2f plus cold cache: text
back again, so the cache and not the shader | 113 DEFAULT config plus the offending cache restored
plus the fix: **text correct, the game continued**, and the checkpoints named the faulting draw |
114 IN FLIGHT: -GpuAV for the out-of-bounds transfer.

## NEW TRAPS

- WARNING WARNING **run_gt7.ps1 overwrote every env A/B.** It set `GT_BINDLESS_*` and
  `GT_STUB_SHADERS` unconditionally, so a variable set in the parent shell was silently replaced -
  the same family as the vkvalidation bug documented at the top of that file. There is a
  `Set-GtDefault` helper now: **a value already set in the parent shell wins.** Verified live before
  trusting it.
- WARNING **A stub or emitter A/B still needs the cache cleared WITHIN one build.** The new
  generation stamp only separates DIFFERENT builds; `CompileModule` is still skipped for anything
  already cached by this same binary.
- WARNING **Bash heredocs in this environment eat backslash escapes.** A python patch script
  written with a newline escape inside a heredoc arrived with a REAL newline inside the string
  literal and produced "SyntaxError: unterminated string literal" - twice, in two different
  scripts. Use `chr(10)`, and keep backslashes out of heredoc prose entirely. (And the older note
  stands: apostrophes in prose break them too - this section was written with the Write tool.)
- WARNING **Mixed line endings**: these sources are CRLF. A patch built with LF-joined anchors does
  not match; read the file, count CRLF against LF, and join with what is actually there.
- WARNING A long or `-Sound` run leaves the process alive after the report is written; judge by the
  report and the log, not by the wrapper exit code (3 = the emulator died, 0 = the user quit).

## NEXT

1. Finish the `-GpuAV` run: name the transfer that writes to 0x2000x000.
2. The long fps session with the GC live - still owed, still the user's own top complaint. The
   `[vram]` line works (device 1111 -> 1200 MB, pending deaths 0-13).
3. `sceVideoOut` advertising 1080p so GT7's settings screen stops saying 2K (cosmetic).
4. Real bindless - unchanged, still the big one.

---

# ACT EIGHT (20 Aug): THE RUN-116 ROOT CAUSE, AND REAL BINDLESS SHIPS - built, awaiting run 117

## RUNS 115-116 (19 Aug, 23:00-23:30 - never written down until now)

Act 7's -GpuAV lead paid off WITHOUT the GpuAV run: the "Write 0x2000x000 / shader hash N/A /
512-byte driver copy kernel" family of runs 111-115 was root-caused by reading the code the
VUIDs pointed at, and fixed (commit 7e42ca56):

- SynchronizeBuffer: the memory tracker hands back whole dirty words, so upload regions
  reached PAST the destination VkBuffer (the GpuAV dstOffset-00114 regions marching
  32/36/40/44 MiB into a 32 MiB buffer). Clamped, with a budgeted [copyclamp] log.
- DownloadBufferMemory: download_buffer is a FIXED 32 MB window and StreamBuffer::Map returns
  {nullptr, 0} when asked for more - NOTHING checked the result; the copies went to the
  driver anyway and write_data would then have dereferenced nullptr. Oversized requests get a
  temporary buffer + synchronous readback now (what the upload path already did).
- WARNING: THE FIX IS COMMITTED BUT UNVERIFIED. Run 116 ran it and the Write family did not
  recur, but [copyclamp] fired 0 times - the warm cache never reproduced the trigger (115 was
  the COLD run, 484 compiles; 116 warm, 0 compiles). Absence of the trigger is not proof of
  the cure. Verification rides on the next cold run (117).

Run 116 then died with the OLD ReadInvalid 0x300100000 - bit-identical to runs 95/96/97/107/
109, 11.5 GB past the nearest live buffer, and the GPU checkpoints named cs_0xda05e7f8
DIRECTLY (seq 510629, both pipe ends) - the first time the checkpoint machinery of commit
37db1a0f closed its own loop. The shader is a cubemap mip-chain generator (9 single
dispatches, 16x16x6 down to 1x1x6). It survived the run-99 OpUMin clamp, with ZERO
softclamp/null-bind lines. The journal reached 510,640 submissions - 4.3x run 115 - so the
warm cache executes the full per-frame workload and still died at the same wall.

## THE RUN-116 ROOT CAUSE (verified in code, fixed in commit 878400ab)

**The descriptor-set layout is rebuilt from a LIVE guest read during warm-cache PRELOADING.**
vk_compute_pipeline.cpp:41 guards buffers ("preloading ? AmdGpu::Buffer{} : ...") but line 51
called image.NumBindings() UNCONDITIONALLY - and NumBindings -> GetSharp re-reads the T# out
of guest memory. At preload the mip-generator's T# is not written yet -> zeroed sharp ->
layout descriptorCount = 1, while the serialized SPIR-V module carries TypeArray(image, 9) +
OpUMin(lod, 8). At bind time the T# is live again -> BindTextures wrote 9 descriptors into a
1-slot binding. Explains every property at once: warm-cache-only, survives the clamp (its
bound is the compile-time 9), zero softclamp lines, ReadInvalid on a descriptor-shaped
address.

The fix: **ImageResource.num_bindings_baked**, set in PatchImageSharp off the same T# the
module compiles against, persisted with the meta (ShaderMetaVersion 3 -> 4). Set layouts
(compute + graphics), the SPIR-V array size and BindTextures all use the baked count now;
specialization keeps reading the live count (that is the new-permutation signal). Divergence
live-vs-baked = a budgeted **[mipbake]** CRITICAL (the run-116 mechanism made visible, never
fatal) + slots past the live mip chain duplicate the last real level.

Also in 878400ab, each earned separately:
- **Today's mip array was formally invalid Vulkan all along**: shaderSampledImageArray-
  DynamicIndexing / shaderStorageImageArrayDynamicIndexing were never enabled while the array
  is indexed by a runtime LOD. Enabled, plus the two image NonUniformIndexing VK1.2 features.
- BindTextures' null-bind paths emitted 1 descriptor where the layout expected N - a
  PRE-EXISTING layout/bind divergence for null-bound mip arrays. null_bind_all() now.
- EmitImageRead's "Unsupported ImageRead with Lod" UNREACHABLE -> the same clamped access
  chain as the write side + a CRITICAL report (an UNREACHABLE in a user run costs the run).
- The [vram] line gained **temp_downloads N**: every oversized download is a full GPU stall
  (scheduler.Finish), and buffer-GC eviction routes through that path - the FPS session needs
  the number. (It also had shared LogCopyClamp's 16-line budget - recurrences went silent.)

## REAL BINDLESS = THE WINDOWED IMAGE DESCRIPTOR ARRAY (commit 9a5fb597, GT_BINDLESS_IMGARRAY)

The measured scope, from the IR dumps (shader/dumps/cs_*.bindless.irprogram.txt): the two
remaining stubs are ONE pattern - an image handle that is ReadConstBuffer with a
RUNTIME-COMPUTED dword index (both abandons at resource_tracking_pass.cpp "not lowerable
(handle op ReadConstBuffer)"):
- **cs_a95f906e** (ImageWrite x2 sites): T#s in tracked buffer #0, 144-byte records, index =
  WorkgroupId.z, second T# at record+32. The index varies PER WORKGROUP - no CPU-time value
  exists, a GPU-side descriptor array is mandatory.
- **cs_3e50e1** (ImageSampleRaw): dense 32-byte-stride T# table in buffer #2, index
  GPU-computed. Its SAMPLER is immediate-offset and was already covered by the deref path.
(The old note "cs_3e50e1 re-stubbed since stores came back, find its abandon site" was wrong -
it is the same image abandon as a95f906e, verified in run 99's log.)

The implementation (all env-gated, GT_BINDLESS_IMGARRAY=N, 0/absent = the stub fallback
exactly as before):
- resource_tracking_pass: a LINEAR-FORM WALK on the runtime index (peel immediate adds ->
  base, one immediate mul/shl -> stride, residual = the index value - its own composition is
  irrelevant, the shader clamps whatever arrives; unwrap an SRL-by-2 to know bytes vs dwords).
  Restricted to ImageSampleRaw/ImageWrite; everything else keeps the abandon. Windowed +
  mip-fallback rejected (both want the array dimension). The handle becomes
  CompositeConstruct(packed bindings, index) - opcodes.inc always declared it Opaque.
- WARNING TRAP: **ImageSampleRaw NEVER reaches SPIR-V** - PatchImageSampleArgs (pass 2)
  rewrites it into Sample*/Gather/Read and passes the handle Value through automatically, BUT
  pass 2's own ".U32()" handle extractions (PatchImageArgs + PatchImageSampleArgs) needed the
  unpack, and NINE emitters changed signature u32 -> const IR::Value& (the Arg<> dispatcher
  passes IR::Value through).
- SPIR-V: TypeArray(image, N), OpUMin(index, N-1), NonUniform decorations on the access
  chain/load/sampled-image, SPV_EXT_descriptor_indexing +
  Sampled/StorageImageArrayNonUniformIndexing capabilities (the index is not dynamically
  uniform - WorkgroupId.z varies per workgroup).
- BindTextures: each slot is its OWN T#, read fresh from the guest table per bind and guarded
  INDIVIDUALLY (unmapped/invalid/type-mismatch-vs-slot-0 -> that slot null-binds, reads zeros
  via robustness2 nullDescriptor, self-heals next bind; budgeted [imgarray] log). One dead
  slot must not kill the window - the table may be half-written this frame.
- **Info::AddBindings counted 1 binding per image - a REAL PRE-EXISTING BUG** for any reused-
  permutation graphics pipeline with a mip array in a non-final stage (later stages'
  descriptors landed on wrong bindings). Sums NumBindingsBaked now.
- Window capped at 32 (the rasterizer's per-draw image tables are static_vectors of 64 TOTAL
  bindings; image_infos also holds samplers).

## THE SESSION'S BINARY AND THE RUN PLAN (117-120)

ONE binary for everything: HEAD ffb29a40 (exe 20 Aug 17:55:17, 72,197,120 bytes). The
pipeline-cache generation now includes this commit, so the old store is rejected
automatically - run 117 is cold with no manual wipe. run_gt7.ps1 -Net defaults
GT_BINDLESS_IMGARRAY='0' until the 118 verdict (one variable per run).

| run | cache | variable | verdict criterion |
|---|---|---|---|
| 117 | cold (auto: new generation) | baseline of the fixes | 116's menu path, no fault; [copyclamp] behavior through cold-load traffic (= the Stage-0 verification); note any [mipbake] |
| 118 | WARM (plain relaunch, change nothing) | the preload path that killed 116 | no ReadInvalid 0x300100000. [mipbake] lines + no fault = mechanism confirmed AND fixed. Fault with 0 [mipbake] = theory dead -> GpuAV warm run |
| 119 | WIPED + script default -> '16' | the windowed arrays | "lowered to a windowed descriptor array" x3 sites, zero NO-OP lines for the two hashes; USER checks: post-FX smears gone (3e50e1), track preview no longer solid red (a95f906e). On a new fault: 119b with IMGARRAY=0 attributes it |
| 120 | warm | the LONG FPS session | protocol: boot -> menu idle 2 min -> race A 3 laps -> menu 1 min -> race A AGAIN (re-entry) -> race B on a DIFFERENT track (fresh streaming) -> menu 2 min -> quit. Grep [vram] (device/VMA MB, pending deaths, temp_downloads), [buffergc], [mipbake], [imgarray], Compiling. Decision tree in the session plan: device climbs+VMA climbs = our caches (texture GC next - WARNING DeleteImage defers on the DRAW timeline only, no all-timelines gate, a latent image UAF if pushed hard); device climbs+VMA flat = driver objects (correlate Compiling); device flat+fps steps down = pending_deaths / temp_downloads / the uses_dma per-draw re-sync tax (A/B: IMGARRAY=0); sound fine+fps drops = GPU-bound, frame capture next session |

## NEW TRAPS (beyond the restated ones)

- WARNING **The build-identity line cannot tell apart two binaries built from the same
  commit** (g_scm_date is the COMMIT date, not build time - runs 115 and 116 printed the same
  identity across the fix). Proving which binary a run used takes a marker that MOVED: the
  [vram] log line's file:line shifted 1024 -> 1055 across the fix, which is unforgeable.
- WARNING **A fix whose trigger did not fire is not verified.** [copyclamp]=0 in run 116 means
  the paths were never entered; the same trap as run 104's "0 clamps hit".
- AmdGpu::Image::Null has Address()==0, so per-slot junk-guard checks reduce to Address()!=0.
- The a95f906e T# is read dword-by-dword (4x ReadConstBuffer into SGPRs) but the IMAGE HANDLE
  is the FIRST dword's ReadConstBuffer - the deref/window machinery keys off that one
  instruction's (buffer, offset) and memcpys the whole sharp from guest memory.

---

# ACT NINE (20 Aug, 18:00-19:00): THE 22 GB WAS THE GRAVEYARD - runs 117-123

## THE HEADLINE

**The OOM death spiral is DEAD** (commit cbda7834): three runs OOMed at ~22 GB on a 12 GB card
and the attribution instrumentation convicted neither cache - **16 of the 22 GB were 4495 dead
buffers stuck in pending_deaths**, held by TWO independent faults in the all-timelines death
gate. With both fixed, run 122 reached **682,172 GPU submissions - 4.8x the previous record** -
and the USER FELT it: "the game launches a bit faster, is faster to respond". Then
GT_BINDLESS_IMGARRAY went live (run 123): **zero bindless stubs remain in GT7** - and the user's
verdict is the honest next frontier: **"nothing in the textures and 3d rendering changed"**,
because the descriptor FETCH is now correct while the DATA in the guest tables is still
wrong/late (measured: `[imgarray] 15/16 window slots null-bound`).

## THE GRAVEYARD, MECHANISM BY MECHANISM (runs 117-121)

Run plan context: 117 was CROSS-CONTAMINATED before it started - a plain (no -Net) run had
filled the fresh-generation pipeline cache with bindless-OFF modules, and **the build-identity
stamp cannot tell env configs apart**, so the cache was set aside
(cache_pre_run117_plainrun_contaminated). Trap for every future A/B: an env flip needs a wipe
even across a same-binary relaunch.

- **Run 117** (cold): guest wild jump 0x5452a982 on Job#40 - SAME GUEST STACK as run 89
  (eboot+0x70e9e00/+0x70c2d98/+0x3a4680b), the recurring "job worker consumes wrong GPU data"
  family. Intermittent; filed, not fixed. r9 held two packed -5.0f - float data over a pointer.
- **Run 118** (warm): OOM on a 1 MB alloc at 22.3 GB VMA / 10,715 allocs, buffer GC freeing
  ~0 MB. The census could not say WHOSE the memory was -> instrumentation: live buffer/image
  counters in Register/Unregister (NOT total_used_memory, which the GC OVERWRITES with
  GetDeviceMemoryUsage every pass), [vram]/census breakdowns, a [texgc] line for the
  until-then-SILENT image GC, an OOM census at the buffer.cpp assert.
  Also: the "[copyclamp] range X does not fit buffer X - dropped" line was the TEMP-DOWNLOAD
  path misusing LogCopyClamp - nothing was dropped; it has its own [tempdl] message now.
- **Run 119** (instrumented): OOM again, and the census named it - buffers 1.9 GB, images
  0.9 GB, pools 1.25 GB, **pending deaths 4495 = the rest (16 GB)**. The arithmetic closed
  alloc-for-alloc.
- **FAULT 1 - THE STALE CACHE**: IsFree() reads a CACHED gpu_tick that only its own Scheduler's
  activity refreshes; ProcessPendingDeaths runs on the draw thread and read present/flip values
  seconds stale. Fix: Instance::RefreshTimelines() - one vkGetSemaphoreCounterValue per timeline
  per drain pass (Refresh is a forward-only CAS, safe cross-thread; NEVER per corpse - a
  4000-deep graveyard would cost 12k queries per submit).
- **Run 120**: fault 1 fixed, boot phase held 0 corpses - then the NEW [graveyard] alarm named
  **FAULT 2 - FLIP STARVATION**: "oldest held by timeline 2 (flip): gate 622 known 621 current
  622". The gate stored every scheduler's RECORDING tick, and the flip scheduler does not
  submit during a streaming phase - no refresh can signal a tick that was never submitted.
  1112 corpses / 6.6 GB piled; OOM again.
- **FAULT 2 FIX** (verified against vk_presenter.cpp BEFORE weakening the gate): present/flip
  recording sessions are begin-record-Flush within ONE function and touch ONLY frame/swapchain
  images (plus ImGui's own pools) - never a cache buffer. SnapshotTimelines(recording_owner):
  the caller's own scheduler gates at its RECORDING tick (its open cmdbuf accumulates buffer
  references), everyone else at their last SUBMITTED tick. ⚠ IF ANYONE EVER RECORDS A CACHE
  BUFFER ON PRESENT/FLIP this breaks silently - tripwire is the run-60-63 signature plus a
  VUID-vkDestroyBuffer naming a present/flip cmdbuf in the ownership dump.
- **Run 121 verdict**: pending deaths 7 / 0 MB at the phase that used to hold gigabytes; VRAM
  plateaued ~5 GB. The [graveyard] alarm still fired once for timeline 0 (draw) holding
  4.9 GB across one submit window - tail-descriptor churn killing ~19x256 MB buffers at once;
  transient by design, drains on the next submit, left as-is.
- Run 121 then died ONE FRONTIER FURTHER: hs 0xcbf710ef stores a patch constant through a
  RUNTIME address (the same shader the run-76 tess clamp already documents as wrong,
  count=18) - the ASSERT_MSG at hull_shader_transform.cpp:496 cost the run. Now: drop the
  store with a CRITICAL. Patch data on that shader was documented-wrong either way.

## RUN 122: THE DEEPEST RUN EVER, AND WHO HUNG IT

682k submissions, 65k log lines, 11.7 GB device with NO OOM (the graveyard stayed drained;
[texgc] showed the unfreeable-tiled population is real but small - 50-62 skips). Died as a
GPU HANG (no bad memory access) with the checkpoints naming **cs_0x6421a7b6 at both pipe
ends** - the documented junk-V# producer whose note has read "real bindless makes it correct"
since Act 4. Every road converged on GT_BINDLESS_IMGARRAY.

## RUN 123: ZERO STUBS - AND THE HONEST VERDICT

IMGARRAY=16 live (default in run_gt7.ps1 now; cache wipe came free - commit cbda7834 changed
the generation). Both lowerings fired exactly as the Act 8 IR analysis predicted:
a95f906e "windowed descriptor array (buffer 0 base 0/32 stride 144 window 16)", 3e50e1
"(buffer 2 base 0 stride 32 window 16) pc=0x344". **First session in project history with
zero NO-OP shader substitutions.**

- **USER VERDICT: "nothing in the textures and 3d rendering changed"** - map still red, sun
  blinding, geometry/colors landing in the wrong place, slow on track, sound still cracking
  (fps-locked, not separate). Launch/menu responsiveness improved (the VRAM fix).
- **WHY, measured**: `[imgarray] shader 0xa95f906e: 15/16 window slots null-bound (table at
  buffer 0 base 0/32 stride 144)` - the mechanism ran and was fed ONE valid T# out of 16. The
  guest tables the windows read are unwritten (or wrongly placed) at bind time. THE REMAINING
  DEFECT IS THE DATA, NOT THE FETCH: the producer chain (windowed-dynrc approximation feeding
  da05e7f8 / 6421a7b6 / the a95f906e tables) still produces wrong/late values. That is the
  same disease behind the run-117/89 guest wild jumps and the run-122 hang.
- Run 123 died as a HOST crash (0xc0000005 at exe+0xad559d, GpuCommandProcessor) at the END of
  a LATER 3e50e1 permutation compile that used the bind-time DEREF path (constant offsets
  pc=0x3c4..0x4ac) - reading 0x104ddf24ae0 where r8 held 0x103ddf24ae0: **exactly 2^40 apart**,
  the guest-space wrap signature on a host pointer. Symbolize exe+0xad559d against the PDB
  (llvm-symbolizer --obj=shadps4.exe; takes minutes on the 400 MB PDB). This family only
  compiles with IMGARRAY on, so IMGARRAY=0 is the stability rollback until it is fixed.

## STATE OF THE TREE

Commit **cbda7834** on gt7-v0.18.0 = instrumentation + both graveyard fixes + hull drop +
tempdl message. The IMGARRAY=16 default is only in run_gt7.ps1 (uncommitted, like all of
GT7_work). Logs archived: run117..run123_* in GT7_work/logs.

## RUN 124 POSTSCRIPT (20 Aug 19:20 - 21 Aug 00:50)

- **The run-123 host crash WAS symbolized and fixed** (the raw-address recipe works; passing
  the module OFFSET instead hangs the symbolizer for 10+ minutes producing nothing):
  `Shader::Info::ReadUdSharp` (info.h:177) via `BufferResource::GetSharp` - an UNCHECKED
  `flattened_ud_buf[sharp_idx]` host read, and **rcx held 0x40000000 = SrtBindlessFlagBit**:
  a bindless-lowered buffer carries the flag IN its index field (its sharp only exists at GPU
  time), and ReadGuestSharp's GetSharp(info) call on such a buffer dereferenced gigabytes past
  the host vector. Fixed with a bounds check in ReadUdSharp returning a zeroed sharp
  (uncommitted, on top of cbda7834). ⚠ UNVERIFIED BY TRIGGER: run 124 never re-reached that
  permutation (0 compiles all run - warm cache + the user idled at the menus). Same trap as
  [copyclamp]=0: absence of the trigger is not proof of the cure.
- **Run 124 = the longest-lived session in project history**: 720k+ log lines over ~90 min
  (mostly menu-idle), VRAM rock-stable at 1.1 GB, graveyard 0 the whole time, 0 GPU faults.
  The graveyard fixes are load-bearing.
- **It died on resume-of-play as a NEW named family**: host crash on thread SDLAudioP23,
  `SDL_GetAtomicInt` (externals/sdl3 SDL_atomic.c:299) reading through pointer **0x11** -
  SDL's audio device thread touching a garbage stream/device atomic. sdl_audio_out.cpp
  destroys/recreates streams on format changes and port teardown while SDL's device thread
  walks its bound streams; one occurrence in ~125 runs. Registers carried 960 samples /
  3840 bytes - mid-callback. Dump: logs/run124_sdl_audio_crash.dmp (host stack inside - the
  next occurrence wants SDL_GetAtomicInt's CALLER symbolized out of it). Possibly the same
  lifecycle behind the user's sound crackle; do not patch vendored SDL - find the shadPS4-side
  destroy race if it recurs.

## NEXT, IN ORDER OF VALUE

1. **Verify the ReadUdSharp guard by trigger**: reach deep content with IMGARRAY=16 and a
   cache state that recompiles the 3e50e1 deref permutation (wipe or new generation), grep
   for the crash NOT happening where run 123 died.
2. **THE DATA PROBLEM** - the real remaining rendering job, now precisely scoped: the guest
   descriptor tables and producer outputs are wrong/late (15/16 null slots is the measurement).
   Instruments that exist: [imgarray] logs (budgeted - raise to see if later binds self-heal),
   GT_IMG_TRACE, the journal. The suspects: windowed-dynrc replaces real ReadConst semantics
   for the producers; their compute outputs feed everything the user sees as wrong (red map,
   sun-blind exposure, misplaced geometry).
3. On-track slowness + sound crackle: fps-locked pair. With VRAM fixed, the next lever is the
   uses_dma per-draw re-sync (Act 4 plan item 3) and a frame capture. The SDL audio crash
   above is a second thread to pull on the sound story.
4. The Job-thread wild-jump family (117/89): expected to shrink as the data problem shrinks.
5. Commit the ReadUdSharp guard (currently dirty on cbda7834).

# ACT 10 (runs 139-158, Aug 25): THE WASH HAS A NAME - AN UNWRITTEN 3D LUT

The user's standing priority ("fix the washing first") is now root-caused end to end. The
proof came from RenderDoc, not from another stub experiment - install it once, keep it.

## THE FINDING (capture CUSA24769_capture.rdc, run 158, welcome scene, white frame)

- The scene HDR is HEALTHY: main 1920x1080 R11G11B10 target max 456, min 0 (eid 9362-10898).
  The bloom pyramid is healthy (max 76 -> 4 across the chain). Nothing carries 33k nits.
- The white is made by ONE draw: **eid 12464, fs_0xae20a0bc** (the output transform).
  In: scene (sane). Out: R10G10B10A2 with **min 0.72/0.90/0.93** - every pixel near-white.
- Its inputs (RenderDoc GetMinMax + saved PNGs, out3/):
  - scene + bloom: sane;
  - 8192x1 R32F 1D curve (ResourceId::26076): 0..1, plausible;
  - **64x64x64 R16G16B16A16F 3D grading LUT (ResourceId::26055, guest 0x101e400000):
    R=1.0 EVERYWHERE (min=max=1), G max 9e-05, B 0..1. GARBAGE.** LUT[black]=white IS the
    flood; no exposure system is involved at all.
- **GetUsage(26055): the LUT is NEVER WRITTEN in the frame - only read at 12464.** Same for
  26076. They are persistent textures whose bake never landed. The content signature
  (R=1, G~0) is uninitialized VRAM - THE SAME SIGNATURE AS THE RED TRACK MAP (a95f906e's
  unwritten output). One disease, two symptoms: **compute passes that write persistent
  textures through windowed image-descriptor tables lose their writes** (15/16 slots
  null-bound at record time - the measured [imgarray] line), so map, LUT and friends stay
  VRAM garbage for the session.
- The good/white oscillation seen in runs 153-155 = frames where the sane path vs the
  garbage-LUT path wins (double-buffered LUTs / partial writes), not adaptation.

## REFUTED THIS SESSION, each by measurement
- tonemapper cbuffer scalar (GT_EXPO_TRACE: dw10=2.5 constant, 1265 samples);
- GPU->CPU readbacks (Relaxed mode: wash unchanged, 105 MB synchronous downloads = 1 FPS);
- the three cbuffer white switches (GT_CB_TRACE: 935c6eac dw408=0 with a 1648-byte V#,
  11a81f15 dw80=0, e8b53da0 dw91=1 i.e. clamp ENABLED, dw13=1, dw75=33329.3 - a sky
  intensity, sane once the LUT was found);
- Inf/NaN at ImageWrite (GT_IMGWRITE_SCRUB: on, unchanged);
- env-probe prefilters and the froxel fog (stubbed both: white persists, though probe stubs
  gave the first-ever near-correct frames - they contribute, they are not the cause);
- cs_6421a7b6 as exposure (it is frustum culling + LOD; its OOB was an unclamped store
  index off a stale SRT record).

## NEW MACHINERY (all committed on gt7-v0.18.0)
- d80bbd70 netctl offline honesty; eb6e8c47 OOM step-down (image+buffer); 03f9e194 +
  a8d28372 recompiler parentless-IR guards; c5512fda page-tracker softclamp + 2^28 extent;
  ccb75be9 GT_EXPO_TRACE; de386f8d **GT_STORE_CLAMP** (OpArrayLength clamp on every buffer
  store/atomic - Sirit gained OpArrayLength; supersedes stubbing 6421a7b6) + GT_CB_TRACE
  (hash:dw,dw;... V# dwords, f-prefix = flatbuf slots); ab6f541e f-slots; 5ef34143
  GT_IMGWRITE_SCRUB.
- Stability: with GT_STORE_CLAMP=1 (+ the 4 stubs) runs 151-155 all ended by the user's
  hand - zero device losts. Unstubbed run 157 device-lost again; the stable set for play is
  GT_STUB_SHADERS=da05e7f8,7c3468f9,935c6eac,11a81f15.

## THE RENDERDOC WORKFLOW (works, keep)
- Install RenderDoc (registry key is how shadPS4 finds the dll); config.json
  "renderdoc_enabled": true; **F12 captures in-game**; .rdc lands in
  AppData/Roaming/shadPS4/captures/<game>/.
- qrenderdoc --python NEVER ran our scripts (first-run dialogs, then silent) - the working
  path is the **Interactive Python Shell inside qrenderdoc** (user pastes one exec() line;
  scripts + one-liners in GT7_work/rdc/ and the scratchpad). GOTCHAS: os.environ.get's
  default arg evaluates __file__ EAGERLY (NameError in exec context); RenderDoc 1.45's
  GetReadOnlyResources returns UsedDescriptor (.descriptor.resource), not the old
  BoundResourceArray; shadPS4 debug-names shaders "fs_0x<hash>_0" - the bridge back to our
  dumps; renderdoccmd thumb gives instant frame identification.
- Analysis scripts: analyze2 (frame sweep: markers, 24 checkpoints, GetMinMax + PNG per
  target), analyze3/4 (draw-window walk + per-draw fragment descriptors), analyze5
  (GetUsage per resource). Results in scratchpad rdc/out*/analysis*.txt.

## NEXT, IN ORDER OF VALUE
1. **Make windowed STORAGE-image writes land.** The LUT/map bake writes through the
   windowed image array whose slots are null at record time (a95f906e measured 15/16 null,
   only slot 0 valid, table VA ring-buffers per dispatch - the late-probe re-read the
   RECYCLED previous table, so "late 0/15" does not disprove the race). Fix direction:
   allocate the imgarray descriptor sets with UPDATE_AFTER_BIND and re-walk the guest table
   just before vkQueueSubmit, updating slots that became valid; or GPU-time T# fetch. Verify
   with the same RenderDoc loop: after the fix, GetUsage(the 64^3 LUT) must show a CS write,
   its content must span 0..1 in all channels, and the final draw's min must drop to ~0.
2. Re-capture a GOOD frame (runs 153-155 showed them with probes stubbed) and diff the LUT
   content/usage against the white frame - confirms the double-buffer oscillation theory.
3. The stable-play set until then: GT_STORE_CLAMP=1 + the 4 stubs. The probes/fog stubs also
   currently hide geometry; un-stub them the moment (1) makes their descriptors reliable.
4. TdrDelay registry bump (needs the user at the UAC + reboot) - still pending.
5. The sporadic GUEST WILD JUMP family (run 156's guest minidump kept) - unattributed.

---

# ACT 11 (25 Aug): GT_IMGARRAY_SYNC - the table readback is BUILT, runs 159+ are the verdict

Act 10's Next Move #1 said "UPDATE_AFTER_BIND + re-walk the guest table just before
vkQueueSubmit". THAT DESIGN WAS REFUTED BEFORE A LINE WAS WRITTEN, by the coherence model:
guest memory is never imported into Vulkan (no VK_EXT_external_memory_host anywhere), every
cached buffer is a VMA device-local COPY, and buffer->guest writeback is opt-in only
(DownloadBufferMemory -> TryWriteBacking). So if the T# table is GPU-written - and the
producer sits EARLIER IN THE SAME command buffer as the bake - then at submit time (a) the
GPU has not executed the producer yet, and (b) even after execution the bytes never reach
guest RAM on their own. A pre-submit guest-RAM re-walk reads the same zeros as record time,
guaranteed. (UAB also cannot reach push-descriptor pipelines at all: ePushDescriptorKHR is
mutually exclusive with eUpdateAfterBindPool, and vkCmdPushDescriptorSetKHR bakes at record
time. Filed under "only if the Stage 0 discriminator ever says cpudirty=1 gpumod=0", which
no current evidence predicts - WaitRegMem blocks the parse on both streams, so a properly
fenced CPU write is already visible at record time, and the measured nulls are addr0 zeros,
not stale T#s.)

## WHAT WENT IN (commits 8d81f531 + 6e9fc401; run_gt7.ps1 + GT7_imgsync.bat uncommitted)

1. **Stage 0 discriminator (8d81f531)**: the [imgarray] line now ends with
   `binds N reg B gpumod B cpudirty B` for the table region. reg 1 = a registered cache
   buffer covers it (the readback can reach the data); gpumod 1 = a GPU wrote it through a
   TRACKED binding; gpumod 0 does NOT clear the GPU (BDA stores mark nothing - the
   gpu_modified_ranges are only fed by CopyBuffer and ObtainBuffer(is_written)); reg 0 =
   the producer stored to an UNREGISTERED page and the value was DROPPED by the fault path
   (the fault buffer only creates buffers afterwards) - then the fix is pre-registration,
   not any sync. Queries run only inside the budgeted print block.

2. **GT_IMGARRAY_SYNC (6e9fc401)**: Rasterizer::SyncWindowedImageTables, called from
   DispatchDirect and DispatchIndirect BEFORE BindResources (record time - views, uploads,
   barriers all legal; GT_SPLIT_DISPATCH proved mid-parse flushes safe). When a windowed
   write-window's slots read mostly null (>= 2): resolve the covering cache buffer through
   the RAW page table, record barrier + vkCmdCopyBuffer(table -> download stream buffer),
   then per mode:
   - **mode 2 (proof)**: scheduler.Finish() - this SUBMITS the producer already recorded in
     the same cmdbuf and waits - then TryWriteBacking the ~2.3 KB back into guest RAM; the
     UNCHANGED BindTextures slot loop then reads real T#s and creates real views. Expect
     single-digit fps (~3-5 bake dispatches/frame measured in run 153); ONE verification
     run only. GT7_work/GT7_imgsync.bat is the one-click launcher.
   - **mode 1 (playable)**: record the copy WITHOUT waiting; DeferOperation lands the
     payload in a memo keyed by table VA; the NEXT occurrence of the same VA injects it
     via TryWriteBacking before the pre-scan. One-frame-late, correct for frame-stable T#s
     of persistent LUT targets (the game ring-buffers a small VA set - 0x2xx33e58 recurs).
   - **mode 3**: mode-2 mechanics on READ windows too (would retire GT_IMGARRAY_FB0).
   - GT_IMGARRAY_SYNC_MAX (default 64) caps the syncs per run; a per-shader fail-streak
     latch turns the sync off after 4 fruitless attempts with a CRITICAL naming it.

## THE TRAPS THE IMPLEMENTATION DODGED (each would have silently faked a verdict)

- **ObtainBuffer would read the WRONG buffer twice over**: its read-only <=16K path
  returns a STREAM-buffer copy of guest RAM (the very zeros being diagnosed), and its
  SynchronizeBuffer uploads CPU-dirty words OVER the GPU-written slots (tracker granularity
  is whole words; slot 0 IS CPU-written, same page). Hence the raw page_table resolve
  (the ObtainBufferForImage pattern) with NO synchronize.
- **A copy inside dynamic rendering is invalid** - scheduler.EndRendering() first, like
  every other copy site.
- **DownloadBufferMemory records no pre-copy barrier** and BDA writes bypass every
  buffer-cache barrier - one global AllCommands/MemoryWrite -> Transfer/TransferRead
  barrier before the copy.
- **TryWriteBacking ASSERTS on IsValidMapping** - the helper pre-checks IsMappedMemory and
  a 0x10000 floor on the table base (a V# carrying SrtBindlessFlagBit reads back zeroed,
  so table_va would compute as 0+base).
- **No tracker mutation on writeback**: marking the range CPU-modified would upload the
  snapshot back OVER newer GPU data on the next synchronize.
- Record-time only, no emitter/meta change -> **env flips need NO pipeline-cache wipe**.
  But the two commits DO change the cache generation, so run 159 is a cold run (full
  recompile, slow first boot - expected, not a regression).

## RUN PLAN (159+), predictions filed BEFORE the runs

| run | launcher | variable | prediction | verdict criterion |
|---|---|---|---|---|
| 159 | GT7_PSN.bat | new build, SYNC off | a95f906e tables: reg 1 (gpumod uncertain - BDA writes do not mark) | the [imgarray] tail names the writer; binds gives the dispatch rate |
| 160 | GT7_imgsync.bat | GT_IMGARRAY_SYNC=2 | [imgsync] valid 1/16 -> 16/16 | transition present; USER: track preview no longer solid red, wash reduced; wait-us per sync logged |
| 161 | GT7_imgsync.bat + F12 | RenderDoc capture | GetUsage(64^3 LUT) gains a CS write | LUT spans 0..1 all channels; fs_ae20a0bc output min ~0; capture 2-3 frames (oscillation) |
| 162 | set GT_IMGARRAY_SYNC=1 | async memo | same visuals at playable fps | [imgsync] inj lines; fps delta from [vram]/journal |
| 163+ | - | =3 read windows; then un-stub ladder one per run; then GT_IMGWRITE_SCRUB=0; then GT_DYNRC_GPU=1 (warning: uses_dma per-draw re-sync tax, the run-74 family) | probes/fog stop hiding geometry | zero device losts per run |

Pre-declared outcomes for 160 - ALL THREE ARE INFORMATION: (a) slots fill -> root cause
confirmed AND fixed; (b) dl 1 but valid unchanged -> plumbing bug in OUR path (check the
[imgsync] line's reg/gpumod bits first); (c) readback zeros with reg 1 -> the producer
never wrote (a STUBBED producer would do this - the stable-set stubs include da05e7f8, a
proven producer; un-stub A/B before concluding "theory dead") or the value died on an
unregistered page (then reg would be 0 - pre-registration is the fix).

## ADDENDUM (25 Aug, 21:30): "it dont run" - config.json HAD GROWN TO 2.14 GB

The user's first attempt at run 159 failed before the emulator even started. Cause chain,
measured: `Get-Content $cfg -Raw` in run_gt7.ps1 died with **OutOfMemoryException** because
config.json was **2,143,719,269 bytes**. Inside it: the `install_dirs` path
`C:\Users\<Greek username>\Desktop\shadps4-win64-sdl-0.17.0\ps4games` (plus its `\DLC`
sibling) had been re-encoded slightly worse by SOME writer on every run since ~Aug 17
(6.6 KB -> 379 KB Aug 21 -> 976 MB Aug 24 -> 2.14 GB Aug 25) - classic UTF-8/codepage
mojibake compounding, roughly x1.4-2 per cycle, FIVE generations of the same string stacked
up as separate install_dirs entries. The structure stayed valid JSON throughout, which is
why every run kept working until the file crossed PowerShell's string limit.

**Repaired** (scratchpad fix_config.py + fix_config2.py): byte-level surgery replaced the
mangled spans, then a JSON pass deduped install_dirs. config.json is now **3.4 KB, valid,
pure ASCII** - the paths use the 8.3 form (`C:\Users\3E30~1\...`), so no mis-decoding
writer can ever compound them again (the loop is starved, even though the WRITER WAS NEVER
IDENTIFIED - run_gt7.ps1 reads BOM-aware and writes -Encoding UTF8, and PS ConvertTo-Json
escapes non-ASCII, so the script alone cannot compound; prime suspects remain the
emulator's own config round-trip and the QtLauncher). renderdoc_enabled=true and the
1080p pins survived the repair.

- **Tripwire added to run_gt7.ps1**: config.json > 5 MB -> refuse to run, loudly, naming
  this addendum. Catches cycle #1 of any recurrence instead of cycle #30 killing the tools.
- ⚠ Two corpses kept as evidence, deletable once run 160 verifies:
  `config.json.corrupt_20260825` (2.1 GB) and `config.json.pre_run148_readbacks` (976 MB),
  both in %APPDATA%\shadPS4.
- ⚠ TRAP for every tool here: a 2 GB config also means the EMULATOR was parsing 2 GB of
  JSON at every boot for days - any "slow boot" measurements from Aug 22-25 carry that tax.
- ⚠ TRAP: when run_gt7.ps1's Get-Content OOMs, `$j` is null, every property write errors,
  and the script STILL prints its summary and launches - the config the emulator then reads
  is whatever was on disk. The tripwire now stops that path up front.

## ACT 11 VERDICT (25 Aug, night): the null-slot theory is DEAD - measured, twice over

Runs 159/160 + dims instrumentation + three RenderDoc captures of ONE PAUSED frame settled
Act 11's original theory and replaced it with a measured mechanism:

1. **cs_a95f906e dispatches 1x1x1.** WorkgroupId.z is always 0, so slots 1-15 of its windowed
   T# table are NEVER ADDRESSED - the measured "15/16 null-bound" is BENIGN for this shader.
   GT_IMGARRAY_SYNC mode 2 confirmed independently: 18 sync attempts, valid 1/16 -> 1/16
   always, even with dl 1 (GPU drained, cached buffer downloaded) - nobody writes those slots
   anywhere. The machinery stays (env-gated, off) for future windowed shaders with real dims.
2. **Slot 0 is a 4x4 RGBA16F 2D texture at 0x101e32a700 - NOT the 64^3 LUT.** The bake that
   works is not the bake that is missing.
3. **The 64^3 grading LUT (guest 0x101e400000) is never written by anything in any captured
   frame** (GetUsage: one PS_Resource read at the output transform, zero writes; content
   byte-identical garbage across captures: min(1 0 0 0) max(1 9e-05 1 1)).
4. **The paused-frame pulsing the user photographed is NOT shader compilation.** Three
   captures of the same paused scene: every small input identical (LUT, 8192x1 curve, 4x4s,
   1x1 R8=0, exposure RGBA16F target = all zeros), scene HDR input identical - and the
   transform's output min oscillates 0.005 -> 0.054 -> 0.42. With identical texture inputs
   the only remaining variable is BUFFER data: the game animates a per-frame LUT blend
   weight (adaptation/crossfade - normal game behavior), and every nonzero weight blends in
   garbage. One defect (unwritten LUT), three symptoms (wash, pulsing, red map).

### Step 2 shipped (commit after this note): identity LUT + writer hunt

- **GT_LUT_IDENT=1** (TextureCache::RefreshImage): any 64x64x64 R16G16B16A16Sfloat volume's
  FIRST upload is replaced with an identity LUT (value = coordinate, alpha 1). lerp(x, LUT[c],
  w) with identity == x for any w -> wash, pulsing and red map all collapse to no-ops. One-shot
  per image (bool on Image), skipped while GpuDirty, so real content - CPU-written or GPU-
  propagated - always wins over identity. Launcher: **GT7_lutident.bat** (also arms the
  watches below at the Act 10 LUT address).
- **[lut3d]** logs EVERY bind of a 64^3 volume T# (img/imgwin paths), and every 64x64
  (depth or layers >= 64) COLOR TARGET - a 3D LUT can be baked as an RT, slice per draw.
- **[vawatch]** (GT_WATCH_VA/GT_WATCH_SIZE, hex) logs every buffer bind, fill and copy
  overlapping the watched range, plus any image T# whose base falls inside it. This answers
  "does ANYTHING touch the LUT range across a whole session" - RenderDoc can only see one
  frame, and the LUT bake (if it exists) runs at load time, not per frame.
- **GT_INVAL_IMG_ON_SSBO=1**: today only FORMATTED buffer writes call
  InvalidateMemoryFromGPU. If [vawatch] shows a plain SSBO WRITE covering the LUT, this env
  is the fix candidate: it extends the GpuDirty marking to plain SSBO writes (exact
  base-address match only, so it cannot storm unrelated images).

### Read of the next log, pre-declared
- `[lutident] seeded` present + wash gone -> mechanism PROVEN end to end; ship the env as
  default and keep hunting the real writer at leisure.
- `[lutident]` present + wash STILL pulses -> the transform's LUT is not (only) this image -
  check [lut3d] for other 64^3 binds, and the blend weight theory needs the analyze7 byteOffset
  re-run (script fixed to dump at each binding's byteOffset - offset 0 of a ring buffer was
  dumped the first time and compared unrelated frames).
- `[vawatch] ... WRITE` lines -> the writer exists and its domain (buf/buf-fmt/fill/copy-dst/
  rt/img WRITE) names the missing propagation path directly.
- No [vawatch] WRITE in a whole boot->race session -> the baker never runs at all: suspect the
  un-stub ladder (da05e7f8 / 7c3468f9 / 935c6eac / 11a81f15) or an HLE'd path, one per run.

# ACT 12 (26-27 Aug, runs 166-182): BOOT SOLVED, THEORY BURIED, THE REAL CLOBBER NAMED

## The boot-stall arc (runs 166-179, briefly - the commits carry the detail)
"Stuck in INITIALIZING" was OUR OWN diagnostic: hashing every GpuDirty refresh of every
image at boot. Fixed in two steps - the baseline hash is recorded once per image
(9f4f63f4), then scoped to the grading-LUT shape only (f9d50092). GT7 now boots reliably
to the welcome screen and into Music Rally. Run numbering note: 166-179 collided with a
parallel session's numbers; today's runs are 180/181/182.

## Run 180: the 17 GB memcpy - minidump forensics became an instrument
Music Rally crash, vcruntime memcpy asked for 0x3FFFFFFD0 bytes (= u32(-12) dwords * 4).
**GT7_work/rdc/parse_crash_dump.py** (new): parses shadPS4's own WriteGuestCrashDump
minidump, names the module at rip, walks the crashing thread's stack against the
fixed-base exe. Three-way match proved the ACB ring-wrap stitch in ProcessCompute
resumed a "partial" packet whose buffered header declared 4 dwords while 16 were
buffered - a TORN ring read (the run-72 disease) the stitch arithmetic trusted blindly.
Fix: **636ed9de** - the buffered prefix must be type-3, bigger than tmp_dwords, and fit
tmp_packet, or it is dropped ([softclamp] ACB stitch); a packet straddling 3+
submissions APPENDS instead of re-buffering from index 0; the split-branch copy clamps
to the 1024-dw buffer. Survived run 181 and the whole 20-minute run 182 with zero
stitch softclamps.
- TRAP for the next reader: the crash dump in %APPDATA% is OVERWRITTEN by the next
  crash - archive it immediately (GT7_work/logs/run180_guest_crash.dmp). And when a
  later session finds a dump with a familiar signature, CHECK ITS MTIME against the
  fix's build time before declaring the fix holed - today's 19:44 dump turned out to be
  run 180's own file, predating the 19:59 fix by 15 minutes (md5-identical to the
  archive). Also: symbolizing an old run's addresses against a RELINKED exe gives
  plausible wrong lines - the thread-list stack descriptor can be empty (rva 0); the
  real stack lives in the MemoryList stream (signals.cpp captures 128 KB around rsp).

## Runs 181-182: the theory is dead twice over, and the pulse has a mechanism
Run 181 (stitch-fix binary): boots clean, welcome scene renders (broken colors), 3
RenderDoc captures + 1 from run 180. All four analyzed (out7/run181/):
- **THE PULSE IS AUTO-EXPOSURE HUNTING UPSTREAM OF THE OUTPUT TRANSFORM.** Across ~1 s
  captures of a STATIC screen the transform's scene input max swings 13.1 -> 2.6 ->
  0.85 and its CB dw087 swings 0 -> 23.89 -> -0.08. The transform passes through what
  it is fed; the oscillator is in the exposure chain before it. Suspects: the all-zeros
  1920x1080 RGBA16F input at 0x100ee50000, the 1x1 R8 zero at 0x1000e33200, and
  cs_da05e7f8 (the NaN-factory probe producer, bursts user-correlated with wash).
- **The imgarray null-slot theory is DEAD, anatomically and empirically.**
  cs_0xa95f906e's IR: record index = WorkgroupId.z * 144, dispatches are 1x1x1 -> only
  record 0 is ever read; 15/16 null slots are BY CONSTRUCTION. Run 182 (mode 2 proof):
  GPU flush + wait + readback of the table STILL found it null ("theory dead" latch
  after 4 barren syncs, sync #33 with dl 1 reg 1). GT_IMGARRAY_SYNC stays default 0.
- **The complete clobber model.** The LUT at 0x101e400000 is baked ONCE at load by
  cs_0xf04a69f0 (one [lut3d] WRITE bind), then only read. Its guest pages sit in the
  busy 0x101e3xxxxx heap; neighboring GPU buffer writes keep re-flagging them GpuDirty,
  and RefreshImage's GpuDirty path reuploaded the stale guest copy (uninitialized VRAM)
  over the baked content - no hash, no log, which is also what ate the GT_LUT_IDENT
  seed. Fixed in **c66b0d04**: the LUT shape hashes on EVERY refresh; unchanged guest
  bytes on GpuDirty = collateral invalidation = skip (logged "[hashbase] ... GPU-dirty").
  Also **608292d3**: GT_STORE_CLAMP joins the pipeline-cache ABI (flipping it could
  replay unclamped modules), GT_LUT_DUMP_INTERVAL, launcher defaults (SPLIT_DISPATCH 64,
  STORE_CLAMP 1 everywhere).
- Run 182 also proved the game PLAYS: full Music Rally race, car renders near-perfect,
  track pulses everywhere (user report). Log: run182_imgsync_proof_theorydead_race_pulse.txt.

## NEXT (run 183+), pre-declared
1. **GT7_lutident.bat on the c66b0d04 binary** = identity seed + the closed clobber
   door. Predict: [lutident] seeds, cs_f04a69f0 bakes, later GpuDirty refreshes log
   "[hashbase] skipped unchanged GPU-dirty reupload" and the bake SURVIVES -> wash and
   red panel fixed and STAYING fixed into the race. The pulse likely remains (separate
   root). If wash persists: grep [lut3d]/[vawatch] - a second writer or a second LUT.
2. **The pulse**: 3 captures PAUSED IN THE RACE (F12 x3, ~1 s apart), analyze7 each,
   then trace the exposure chain upstream - which pass produces the scene-brightness
   swing, what does it read (the zeros at 0x100ee50000? da05e7f8's NaN probes?).
3. renderdoc_enabled is still true in config - turn it off for an honest FPS run once
   the visuals are settled. Parked: the pre-existing device-lost family; the all-zeros
   0x100ee50000 producer; the 1x1 R8 zero.

# ACT 13 (29-30 Aug, runs 183-198): THE 018256C0 HANG DIES, THE CACHE LOADER LIED, AND THE FPS DECAY HAS A MECHANISM

## The cs_0x018256c0 arc (runs 187-197) - fixed, with two refuted theories on the record
Device-fault dumps repeatedly isolated a deterministic GPU timeout to this 8x8 light-volume
shader. What survived: **GT_18256C0_GUARD** (vk_rasterizer.cpp) clamps the two signed flatbuf
record counts at [52]/[53] to their V# capacities, on the transient flatbuf copy only. Runs
193-197: 17/17 dispatches clean, no clamp ever fired with real data.
- REFUTED 1: "the two scalars live at flatbuf [66]/[67]". After GT_DYNRC_WINDOW those slots are
  dynamic-window PAYLOAD - writing them actively corrupted the table and produced the giant
  black/grey triangles (runs 189/190). The real scalars are at **f2114/f2115** and the CPU
  walker captures them valid (block 86-165, extent 32).
- REFUTED 2: "the reads must become GPU-time BDA reads" (the stale-descriptor theory). The BDA
  override made the dispatch HANG (runs 191/192); the experiment was removed entirely, not
  disabled. Static SRT reads of f2114/f2115 are correct.

## The crash journal was off by one command buffer (fixed, 45bd4e36)
The per-submit walk used [prev_end, seq_end), which named the PREVIOUS cmdbuf's final entry and
omitted this one's. Run 197's "cs_0x935c6eac hung" verdict was this artifact - the GPU
checkpoint showed that buffer completed; the innocent shader nearly got a stub. Now the walk is
(prev_end, seq_end], every payload's cmdbuf handle is verified (a global journal interleaves
schedulers), and unreadable vs foreign entries are reported separately. ⚠ A present/flip
scheduler's census is a COPY of draw work - never read it as independent evidence (the dump
says so inline now).

## The shader cache rejected its own entries (fixed, 84143d09)
"Cached permutation ... conflicts ... skipping preload", hundreds per boot: the loader saw the
same specialization stored under a different HISTORICAL index and threw the whole pipeline away.
70 of 73 "conflicts" were byte-identical SPIR-V (same SHA-256). Restore by the exact stored
slot: **684 recompiles/boot -> 40, 1,236 pipelines preload.** The 1-second black-checkerboard
delay survived a genuinely warm run (0 compiles), which acquitted compilation and convicted...

## ...the BDA fault system: first-read-zero is the checkerboard AND the red map
A DMA shader's first read of an unregistered page returns zeros; ProcessFaultBuffer's readback
lands a tick later; FindBuffer creates the buffer; the NEXT consumer sees data. Repeating
consumers (the settings checkerboards) recover in ~1 s; **one-shot producers (the track MAP)
run exactly once, on zeros, and stay red forever.** Run 198: 2,026 fault registrations. The
latency scales with frame time, so the perf fix below shrinks it; the one-shot loss needs
pre-registration or replay and is NOT yet fixed.

## GT_SPLIT_DISPATCH law, amended by run 198
N=64 and N=8 both leave enough parse-to-execute lag for the NVIDIA watchdog (TDR in nvlddmkm,
crash follows the batch boundary, not a shader - runs 196/197). N=1 passed the same wall - but
⚠ run 198 device-lost EVEN AT N=1, ~7 minutes in, during the CPU-saturation phase: the hung
tick was on the PRESENT scheduler with ordinary scene work in flight. With frames at 300+ ms
and the CPU starved, present itself can starve past the watchdog. The lighter queue-pacing
replacement is still the right next move if TDR persists after the perf fix.

## RUN 198'S HEADLINE: the FPS decay has a mechanism, and it is ours (fixed, e2fec48f)
Warm cache, watches off, split=1: FPS still decayed 10->3 as the scene loaded, CPU pinned at
11-12 cores, GPU at 21%/210 MHz. The cost: **every draw whose pipeline uses DMA walked every
mapped range and visited every cached buffer** (vk_rasterizer BindResources' uses_dma block) -
a no-op tracker scan of ~3,000 buffers, per DMA draw, growing with scene residency. Upstream
main has the identical block; there is no newer upstream solution to adopt.
**GT_DMA_DIRTY_LOG=1** (default off, rtshape.bat opts in): every transition INTO CPU-dirty
already flows through BufferCache (InvalidateMemory, ReadMemory write-back, GC spill,
CreateBuffer - whose fresh tracker regions are BORN all-dirty via RegionManager's cpu.Fill(),
with no Mark call anywhere), so those four sites append to a RangeSet and the DMA pass consumes
only what changed since the last one. First DMA draw full-walks as the seed. Producers mark the
tracker BEFORE logging so a consumed entry can never race ahead of its own dirt.
- ⚠ Also measured in run 198's graveyard: **4,023 buffers freed by the GC** against 2,026
  fault-created ones - the buffer population CHURNS. Every GC spill + refault is a full
  re-upload cycle. If perf is still poor after the dirty log, this churn is the next suspect
  (raise GC thresholds or pin fault-created buffers).

## RUN 199 (pre-declared, before the run)
GT7_rtshape.bat now sets GT_DMA_DIRTY_LOG=1. Predictions: [dmasync] "armed" appears once, the
consumption lines report small range counts; the 12->3 decay flattens (the per-draw cost no
longer grows with residency); audio stutter eases (same CPU); the checkerboard delay SHRINKS
with frame time but does not vanish; the red map is UNCHANGED (one-shot, needs replay); wash
and pulse UNCHANGED (separate roots, Act 12). If the decay persists with [dmasync] consuming
near-zero ranges, the remaining cost is elsewhere (measure again - do not guess); if TDR hits
at split=1 again, implement queue pacing next. A/B switch: GT_DMA_DIRTY_LOG=0 restores the full
walk in the same binary.

# ACT 14 (1-2 Sep, runs 239-247): THE CRASH STACK DRAINS - FOUR MECHANISMS, EACH KILLED BY MEASUREMENT

Act 13 ended with the game dying somewhere in the main-game race flow every session. Act 14 is
nine runs that each died FURTHER ALONG in a NEW, rarer mechanism, until run 247 reached the
furthest point this project has ever reached: **main menu -> World Circuits -> car select -> INTO
A RACE, still running, with ZERO device faults across a 93 MB log.**

Every mechanism traced to the same family - the game hands the GPU garbage data (stale flatbuf
snapshots, torn descriptors, unfed tables) and the emulator obeyed it literally. The four fixes
are four places where a garbage NUMBER is now clamped to something a GPU can survive.

## The wrap-guard arc closes (runs 239-242, commits 9c4647f6 / 42abb59e)

`GT_LOOP_WRAP_GUARD` rewrites `INotEqual`-terminated loop exits into ordered compares, so a
counter that steps PAST its sentinel exits instead of wrapping 4 billion times. It had one gate:
only rewrite a compare that feeds nothing but branch conditions.

**That gate refused its own target shader TWICE, and each refusal cost a blind run.**
- Run 239: `hs_0x3827418d`'s comparison feeds a `LogicalAnd`. The gate accepted only
  `ConditionRef`/`LogicalNot`.
- Run 241: widening to `LogicalAnd` was still not enough - the `LogicalAnd` ALSO feeds the
  next-iteration bool phi (`%206 = OpPhi(true, %489)` at hs_3827418d.spvasm:1208). phi -> and ->
  phi is a real cycle in this game's loop idiom.

Final gate: an iterative worklist following ConditionRef/LogicalNot/LogicalAnd/LogicalOr/**Phi**
with a visited set and a size cap of 64. Result: **962 shaders / 1746 rewrites** - the do-while
with phi condition plumbing is GT7's NORMAL loop shape, not an exotic case.

- ⚠ ⚠  **The real fix was the NEAR-MISS LOG, not the gate.** Any stepping-phi `INotEqual` the gate
  refuses now logs WHICH user opcode refused it (`refused_by`). Two runs were spent asking a
  question a log line answers for free. Run 242 then reported exactly 1 near-miss, correctly
  refused (a compare feeding `SelectU1` is a value use, not a branch condition).
- Run 242 was the longest session in days: Music Rally menu, a race, car-select browsing.

## GT_LOOP_BOUND_CAP: the OTHER infinite loop (runs 243-244, commit 01621bd2)

Run 242 then hung at race load after car pick - `cs_0xc3d5603f`, DispatchDirect 1x1x1 x 64
threads, two IPs parked in one shader, **no bad memory access, 0 wrap rewrites, 0 near-misses**.
Not a wrap loop. The mechanism, measured in its SPIR-V pulled out of the pipeline cache
(`GT7_work/shaders/cs_c3d5603f.spvasm` - `spirv-dis` on the cached .spv, no run needed):

```
%102 = load(srt_flatbuf[16])        ; a record count the CPU SRT walker snapshotted
%107 = (%102 + 63) >> 6             ; from guest memory
while (counter < %107) { ... }      ; counter steps +1
```

Zeros EXIT INSTANTLY - this is the opposite of the wrap family. Garbage (float bits, leftover
pointers) makes `%107` tens of millions, and one 64-thread group looping an SSBO-touching body
tens of millions of times is a TDR by definition.

`GT_LOOP_BOUND_CAP=N` wraps any LOADED loop bound in `UMin/SMin(bound, N)` right before the
compare. Immediate bounds are never touched (a compile-time constant is the game's real intent);
signed compares use signed min so negative garbage keeps exiting instantly. **425 distinct
shaders / 704 compiles carry caps** - as widespread as the 962-shader wrap census implied.

- Run 243: the cap worked, the race loaded and was driven.
- ⚠ ⚠  **1,048,576 was too generous and the user felt it**: "the image would get stuck for a
  couple of seconds but behind the game was still counting time". A garbage bound that used to
  hang now GRINDS a million iterations. Legit per-invocation trip counts here are THOUSANDS
  (cs_0x018256c0's own per-shader guard used 1024). Lowered to **16384** - env-only, no rebuild,
  because the binary reads it at runtime.

## The dead-buffer ring ACQUITTED its own theory (run 245, commit 535896cc)

Runs 243+244 both died to a `WriteInvalid` a few dozen KB PAST THE END of the same multi-GB
cache buffer at guest `0x1000dfc000` - whose SIZE DIFFERED per run (3.28 GB vs 2.44 GB). That is
the game's streaming heap, which the cache keeps replacing with bigger generations as it grows
(17.3 GB working set at death). Prime suspect: a stale write through the BDA of an
already-replaced generation.

The instrument: `UnregisterBdaRange` keeps a ring of the last 64 dead ranges, and
`DescribeBdaAddressForFault` checks it - one log line to convict or acquit.

**Verdict: ZERO "DEAD buffer CONTAINS the fault" lines. The theory was wrong.** The write really
does land past the end of the LIVE generation. A cheap instrument that kills your own hypothesis
in one run is worth more than a clever fix built on it.

## ⚠ ⚠ ⚠  RUN 245'S REAL ANSWER: a T# whose TILED FOOTPRINT is gigabytes (run 246, commit 43d48395)

The same log named the true culprit with exact address arithmetic. Seconds before the fault:

```
[detile] DetileImage REFUSED: extent 256x256x1 layers 1857 ... guest_size 0xbd840000 addr 0x100b460000
[softclamp] refusing to (un)track region 0x100b460000 - 0x10c8ca0000 (3032 MB, torn descriptor)
...
address[0] WriteInvalid: 0x7724b7000
    nearest-below buffer: bda [0x6aa600000, 0x7724a4000) guest 0x1000dfc000 - fault is 0x13000 past it
```

`0x1000dfc000 + 0xc7ea4000 = 0x10c8ca0000` - **the monster T#'s guest_size ends EXACTLY at the
heap buffer's end, and the device died writing 76 KB past that end.**

**Why every existing guard missed it, and this is the transferable part:**
`sharp_extent_sane` counts TEXELS. That T# is 2^26.9 texels with 1857 <= 2048 layers - it
**passes**. The 3.18 GB lives in the pitch/slice padding of the TILED layout, which only
`ImageInfo::guest_size` can see - and guest_size exists only after ImageDesc construction, past
every tsharp-level check. Detile refused it and the page tracker refused it, but **the Image was
still created, registered and synchronized**. Two guards firing on the same object is not the
same as the object being stopped.

`GT_IMG_MAXMB=N`: in `BindTextures` - the same place the V# softclamp null-binds garbage V#s -
any constructed desc whose `guest_size` exceeds N MiB is refused BEFORE `FindImage` can create
anything. The slot's `image_id` stays null and the emit pass already writes `VK_NULL_HANDLE` for
null ids, so a refused slot is an ordinary null binding. No Image means no registration, no
multi-GB synchronize, no write past the heap. Both bind paths (windowed slots and plain T#s)
share one lambda. Largest legitimate GT7 resource seen is ~256 MB; the cap ships at 512.

**Run 247 verdict, measured:**
```
maxmb fires:        2      <- and BOTH on shader 0x3e50e1, the known bindless offender
detile refused:     0      <- the image never exists now, so detile never sees it
torn registration:  0      <- nor does the page tracker
device faults:      0      across a 93 MB log
  T# 0x1001800000  128x128 x 1857 layers tile_mode 13 -> 0xb9482000 (3.1 GB)
  T# 0x100b460000  256x256 x  385 layers tile_mode  0 -> 0x8a5c0000 (2.3 GB)
```
The second is the SAME ADDRESS that killed run 245. **The downstream guards going silent is the
proof the fix landed upstream of them**, and the game reached further than it ever has:
main menu -> World Circuits -> car select -> into a race, still running.

## stuckstack.ps1: the measurement runs 244 and 246 died without (commit e1c05e67)

Both ended as a SILENT hang - process alive, log growing on service noise only, no fault, no
TDR, and both were killed before anyone captured a stack. Run 246's post-mortem refuted its own
first theory twice: the last renderer line was "Compiling graphics pipeline 0x4898b31b...", which
reads as "the driver compiler is stuck" - but the pipeline's `g_*.key` record exists on disk with
the SAME SECOND's mtime as the shader's .spv, so the ctor returned and `RegisterPipelineData`
ran. The shader itself is 867 lines of plain arithmetic with **zero loops**.

`GT7_work/stuckstack.ps1` + `STUCK.bat` walk every thread of the LIVE process with dbghelp
`StackWalk64` (symbols from the build's own RelWithDebInfo PDB), print per-thread CPU over a 3 s
window, wait reason, and full stacks for shadPS4-named or CPU-hot threads. Threads are suspended
only for the microseconds of one context read.

**It paid for itself on its first use.** Run 247's "stuck" was captured live and named in one
line:
```
tid 26292  shadPS4:GpuCommandProcessor   cpu+3281ms/3s  Running
    nvgpucomp64.dll  ... (15 frames of NVIDIA's shader compiler)
    nvoglv64.dll     vkGetInstanceProcAddr+...
    shadps4.exe      Vulkan::GraphicsPipeline::GraphicsPipeline+0x5922
    shadps4.exe      Vulkan::PipelineCache::GetGraphicsPipeline+0x383
    shadps4.exe      Vulkan::Rasterizer::Draw+0x4f6
```
**Not a hang - the NVIDIA driver compiling a pipeline at 100% CPU, synchronously, inside Draw.**
The game was never stuck; it was compiling. 3,666 graphics pipelines / 4,571 modules in that
session. A "stuck" that is really a compile storm and a "stuck" that is really a deadlock need
opposite fixes, and nothing in the project could tell them apart before this.

- ⚠  SYMBOL_INFOW offsets are the documented x64 layout (MaxNameLen at 80, Name at 84). The first
  draft had them off by 4 and returned empty names for every frame - which looks exactly like
  "symbols are not loading".

## Uncharted 2 (CUSA03281): the dump is incomplete, the emulator is fine

Run as a cross-check on the current binary. Booted clean, 55 shaders, the intro video decoded
and finished, then black at 1 FPS. The log names it:
`open: /app0/u2data/build/main/effect1/menu.bin failed, file does not exist` - and the `effect1`
folder is **absent from the dump entirely** (4,412 files / 24.1 GB, no menu.bin anywhere). The
game waits forever for a file that was never installed.

Useful anyway: **4.5 minutes, zero faults, and our guards behaved correctly on a different
game** - 3 loop bounds capped harmlessly, 0 wrap rewrites (U2 does not use GT7's do-while
idiom), 0 false positives from GT_IMG_MAXMB. Filed in OTHER_GAMES.md territory: needs a complete
dump before it can be judged.

## THE STATE AFTER ACT 14

**Fixed and verified:** the wrap hang (962 shaders), the loaded-bound TDR (425 shaders), the
gigabyte-T# WriteInvalid (2 fires, 0 faults). **Refuted and on the record:** the stale-write
theory, "the compiler is stuck", "sharp_extent_sane covers monster textures".

**What the user sees, and what is next.** The crash front has drained enough that the DATA front
is now the whole complaint, exactly as the user directed after run 241 ("we fix the hard
whitewash and teselations then we check for other crashes"):
1. **Whitewash / exposure pulse** - "like a huge sun passes in front of the screen", not constant.
2. **Textures do not build** - washed white ground, half-drawn HUD, letters flying outside their
   boxes.
3. **MAGENTA GARBAGE** at car select (new, photographed run 247): magenta shards over the car
   preview at 3 FPS. Magenta is this project's uninitialized-data colour; same family.
4. **FPS**: 3-28 in menus, 13-18 in race. Run 247 shows 3,666 pipeline compiles - and the
   stuckstack proves compilation is SYNCHRONOUS inside Draw. **Async pipeline compilation is now
   a measured, named target, not a guess.**

All four are the SAME ROOT the crash arc kept circling: first-read-zeros / garbage snapshots.
The named structural direction remains **pre-registering BDA pages at descriptor-walk time**
(the CPU SRT walker already sees every T#/V# address before submit) instead of on first GPU
fault - `info.h`'s own comment says the honest answer would be GPU-time reads.

## RUN 248 (pre-declared)
Env unchanged from probe 246. Metrics: (1) does the race COMPLETE now that the monster T# is
gated - the first end-to-end race of the arc; (2) `grep "exceeds GT_IMG_MAXMB"` - does it stay
at ~2 per session or climb; (3) the magenta at car select - capture it with GT_IMG_TRACE on the
car-preview shader if it recurs; (4) compile count per session, as the baseline for whether
async pipeline compilation is worth building.
