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

## RUN 248 (pre-declared, rewritten 2 Sep 21:00 - the run is now the TESS A/B, `GT7_probe248.bat`)

The user's call after run 247: "tessellations not painting correctly map and car, low fps probably
caused by the same problem". Both were MEASURED off run 247's log before anything was built, and
they are two different mechanisms:

**Tessellation (this run's target).** `hull_shader_transform.cpp:GetAttributeRegionKind` decides
which LDS region an access touches by COUNTING how many times a tess constant reaches its address
(0/1/2 = input CP / output CP / patch const). GT7's hull shaders reach **4..28 - all even - on 311
of the 547 hs shaders compiled**; the count is clamped to PatchConst, the address is runtime, and
the store is DROPPED (`patch-const store at a RUNTIME address - dropped`: 2122 lines, the SAME 311
shaders, 1:1 with the clamps). Those stores are the tessellated surfaces. origin/main (ae1539d3,
2 Sep) still ASSERTs at that spot - nothing to borrow. Built for this run:
- the walker keeps THREE 10-bit hit counters (NumPatch / HsOutputBase / PatchConstBase) in the
  flags word; the legacy count is `np + ob + 2*pc`, so every already-handled shader is untouched;
- `GT_TESS_DUMP=N` prints, per tess shader, a census of every LDS access's (np, ob, pc) pattern +
  the driver's tess constants, and the ADDRESS EXPRESSION (before the constants fold to 0) of up
  to N over-count accesses - the data for a real classifier whichever way the A/B goes;
- `GT_TESS_REGION=clamp|presence|outcp`: what an over-count becomes. Run 248 uses **presence**
  (PatchConstBase reached the address -> PatchConst, else OutputCP): a visual change is then only
  possible where the address provably did NOT carry PatchConstBase, i.e. it is trustworthy.
  ⚠ If the dump says pc>0 everywhere, the picture will NOT change and the real fix is dynamic
  patch-constant indexing (the pass's own comment: "turn those into a single vec4 array").

**FPS (separate front, untouched).** `[fprof]` over 911 windows: GpuCommandProcessor **91% busy**,
pipeline compile **31% of busy** (586 s in 76 storm windows, one of 100 s), bindbuf+bindtex 28%.
The disk pipeline cache is invalidated by EVERY rebuild ("written by a different build") so each
probe run recompiles ~4300 pipelines. The cheap lever is a cache that survives a rebuild (opt-in);
the structural one is async pipeline compilation.

⚠ **THE LOG WAS CAPPED AT 100 MiB.** `config.json` `Log.size_limit` = 104857600 and
`LogFileSink::sink_it_` drops every non-critical line past it. Run 247's log ends at ~41 min with
the race still running - the "did the race complete" metric could never have been read off it.
`run_gt7.ps1` now writes size_limit = 1 GiB. ⚠ The live `shad_log.txt` at 20:38 was NOT ours: the
user ran the stock "v0.18.0 - UltraPersona" build on GT7 (crash 0xc0000005, 9 pipelines) - check
the Revision line before reading any log as a run of this fork. Run 247's log is archived as
`logs/run247_maxmb_race.txt`.

Metrics (also in the probe header): (1) car body panels + track surface drawn where run 247 had
garbage/nothing; (2) `grep "tess-constant multiple"` now carries `np= ob= pc=` + the region
chosen, `grep "patch-const store at a RUNTIME"` = how many are left; (3) `grep "\[tessdump\]"`;
(4) `exceeds GT_IMG_MAXMB` ~2, faults 0, compile count; (5) log size past 100 MiB.

## RUN 248 VERDICT (2 Sep, 21:00-21:17, `logs/run248_tess_presence.txt`) - the A/B refuted itself, and that was the point

Read live off the log during the race. The 311 clamped hull shaders are explained to the last bit:

- **Every over-count access is `np=N ob=0 pc=0`** (N = 4/8/14/16/18/20/26/28 over 310 of 486
  distinct hs) - never HsOutputBase, never PatchConstBase. There are exactly **6 per quad shader
  and 4 per triangle shader**, i.e. the redundant tess-factor writes into the PatchConst region
  that the pass header describes. The dumped address (hs 0x13c00e74):
  ```
  PatchIdInVgt*96 + 24*ReadLane(WriteLane(...WriteLane(Undef, NumPatch, 0)..., 0)*22
                  +    ReadLane(same chain, 0)*704 + k*16        k = 0..5
  ```
  = skip NumPatch input patches + skip NumPatch output patches = the textbook patch-constant
  address the count model scores **2**. It scored 18 because GT7's compiler **broadcasts NumPatch
  into a VGPR with a chain of nine v_writelane** (odd lanes carry another scalar) and reads lane
  0 back: every link is a use of the constant AND flows into the next, so the walker reached the
  address once per link, times the two multiplications. **N = 2 x {2,4,7,8,9,10,13,14} links.**
  That is why every count in run 247 was even.
- **`presence` was WRONG.** pc=0 everywhere, so it classified all 6 stores as output-CP writes
  and emitted them as `SetTcsGenericAttribute(attr = k, comp 0)`: tess factors written over
  component 0 of output attributes 0..5 of every control point. If the car bodies looked
  different from run 247, that is why. A trustworthy A/B is one whose failure is legible - this
  one failed and said exactly how.
- **Every domain-shader LDS read in the whole run is `(np=0, ob=1, pc=0)`** = output control
  points. **No DS reads patch constants.** So the 2122 stores run 247 dropped were dead data and
  **the 311-shader clamp was never the cause of the mis-painted tessellation.** The picture
  question is still open (see run 249).
- Why they were dropped at all: `ConstantPropagationPass` knows nothing about lane ops, so after
  NumPatch -> 0 the zero never got through the ReadLane, the address stayed runtime, and the
  patch-const store hit the "RUNTIME address - dropped" branch.
- Main-game race reached again (Trial Mountain, 20 cars): 0 faults, 1 GT_IMG_MAXMB fire, 4788
  graphics pipelines. The race screen: **2 FPS**, pipe ~45% of the frame in those windows, a
  pink/white wash over the whole scene (the Act 10 LUT/exposure front), rivals as magenta shards.

**THE FIX - `GT_TESS_LANEFIX` (default ON, `=0` restores 247/248), commit below:**
(a) the walker visits a WriteLane/ReadLane node at most once per walk, so a broadcast chain is one
path per ReadLane (genuine two-term addresses are IMuls, not lane nodes, and still count 2);
(b) after the zeroing, `ReadLane(chain, k)` is folded to the immediate written into lane k, so the
address becomes `k*16` and the store is emitted as a real `SetPatch`. Expected: 0 clamps, 0 drops.

## RUN 249 (pre-declared) - `GT7_probe249.bat`
Env = probe 248 with `GT_TESS_LANEFIX=1`, `GT_TESS_REGION=clamp`, `GT_TESS_DUMP=2` (which now also
prints ONE address per (opcode, shape) per shader - the domain-shader `(0,1,0)` reads and the HS
`(0,0,0)` reads / `(1,0,0)` writes are the data for the open picture question), and the launcher's
new `-RenderDoc` switch (`run_gt7.ps1` writes `renderdoc_enabled`; it was false, which is why the
F12 the user pressed in run 248 wrote nothing). Metrics: (1) `tess-constant multiple` 0 (was 376),
`patch-const store at a RUNTIME` 0, `[tesslane]` one line per folded shader; (2) picture vs run
247 - expected UNCHANGED, because the fixed stores were dead; (3) the `(shape)` dump lines;
(4) MAXMB ~2, faults 0, compile count, log past 100 MiB; (5) the F12 capture(s) in
`captures\CUSA24769\` - which draw paints the yellow striped road and what T#s its pixel shader has
bound, same for a magenta car. **The tess A/B and the colour question are now two separate
instruments in one run.**

## RUN 249 VERDICT (2 Sep 21:21-21:29, `logs/run249_lanefix.txt`) - the fix holds, and the yellow is not tessellation

- **GT_TESS_LANEFIX works:** 209 hs compiles / 163 distinct, **0 `tess-constant multiple`** (376 in
  run 248), **0 `patch-const store at a RUNTIME address`** (2122 in run 247), 164 `[tesslane]` folds
  on 121 shaders, 0 faults, 0 exceptions. 995 `(shape)` dump lines. Every domain-shader read is
  `HsOutputBase + cp*hs_cp_stride + attr_off` with cp in range (e.g. `IAdd(IMul(0xa0,3),
  HsOutputBase)+0x68` = cp 3, attr 6.2 at stride 160) - the LDS addressing model is sound for GT7.
- **THE USER NAMED THE YELLOW:** it is GT7's driving-line helper for beginners, and the stripes are
  its draws from PREVIOUS frames still on screen - "it keeps textures from older frames and draws
  them again". So the road problem is PERSISTENCE of old render-target content (a target the game
  expects cleared/replaced and we do not clear/replace), not geometry. ⚠ The existing clobber
  doors (`GT_RT_NOCLOBBER`, `GT_GPUWRITE_NOCLOBBER`) guard the OPPOSITE direction (guest RAM erasing
  GPU-rendered content) and say nothing about this. The run-249 screenshot at the Music Rally shows
  a grey road with ONE thin yellow trail on the left, where run 248 showed the whole road in
  yellow/black shards - under `presence` the tess-factor writes were landing in the ROAD's control
  points, so the road IS tessellated and the 248 picture was our own corruption, not the game's.
- **F12 wrote nothing in 248 and 249** because the launcher's first `-RenderDoc` wrote a TOP-LEVEL
  `renderdoc_enabled` key; the real one is `Vulkan.renderdoc_enabled` (nested, like every other
  setting). Fixed in b86cd564, with a read-back line (`RenderDoc = True`) in the launch window.
  The emulator logs it at boot as `Vulkan rdocEnable: <bool>` - check that line, not the config.
- Still open, in order: (1) the driving-line persistence - RenderDoc capture with the stripes on
  screen: does the overlay's target already carry them at frame start, is a clear issued that we
  skip, which draw paints them; (2) rivals as magenta shards (uninitialized data family) - same
  capture at car select; (3) the pink/white wash (Act 10 LUT/exposure); (4) FPS (sync compile).

## RUN 250 VERDICT (2 Sep, two RenderDoc captures, Music Rally) - the ground's colour pass is not in the frame

Both F12 captures (`captures/CUSA24769_capture.rdc`, `_2.rdc`, 1.5 GB each) show the Music Rally
with the yellow carpet on the road. Analysed HEADLESSLY with `qrenderdoc --python` (the scripts
open the capture themselves and exit before the UI; ~1 min per run):

    GT7_work/rdc/analyze18_persist.py    which targets are drawn onto without a clear + PRE/POST PNGs
    GT7_work/rdc/analyze19_pixhist.py    draw census of the scene pass + pixel history per pixel
    GT7_work/rdc/analyze20_geometry.py   who wrote the DEPTH at the ground pixels + post-tess geometry
    GT7_work/rdc/analyze21_indirect.py   provenance of the indirect-draw arguments and vertex data
    reports: GT7_work/rdc/out_persist/cap1_*.txt, PNGs in out_persist/cap1/

What the frame says (capture 1, HDR scene target ResourceId 21737 = `0x1005000000`, R11G11B10):
- The target starts the frame holding the PREVIOUS frame in full, carpet included (there is no
  clear of it anywhere in the frame; 38 of the 48 colour targets are drawn onto without a clear,
  which is normal for a game that relies on overdraw). After all 322 scene draws, PRE vs POST
  differ only at the gantry, a few tree edges and ONE thin dashed yellow line (mse 104).
- PIXEL HISTORY at seven road/ground pixels: the only fragments this frame are the sky quad
  (eid 6444, depthTestFailed against a depth of 0.0016..0.0027), a fullscreen identity pass
  (6570) and a discarding post pass (7544). NO ground colour fragment at all, passing or failing.
  The yellow at those pixels is inherited from earlier frames - the user's reading was right.
- The DEPTH at those pixels was written by eid 3118, a depth-only prepass draw of 235,272 indices
  (vs module 6504, no colour target, func Greater), whose post-VS positions are a normal mesh
  (55,675 verts, 62% inside NDC). The depth buffer IS cleared every frame (eid 3099). So the
  ground is rasterised in the prepass and never shaded: the colour pass has no draw with anything
  like that index count (its largest is 10,092), and the whole colour pass carries ~110k indices
  against 440 depth draws.
- The 24 `vkCmdDrawIndexedIndirect` draws with the prepass signature (depth func Equal) are NOT the
  ground: they read their 20-byte records from one 78 MB buffer (`0x202a00000`) that IS written by
  GPU shaders in the frame, in triples of which one LOD slot is live with 44 instances - the
  `<0, 0>` records are unselected LOD slots, by design. Eid 5899's all-zero post-VS positions are
  one of those (its vertex buffers hold real data, so that one is a separate, smaller question).
- The 4 tessellated colour draws (5388..5406, 48 quad patches each) emit 2112 vertices each that
  ALL land inside one sub-pixel region (x 27.4..27.7, y 7.5..8.9, w 177 - NDC ~(0.155, 0.045)):
  the patches collapse to a point. Whatever they are (the car?), they cannot paint anything.

Conclusion: the yellow road is a SYMPTOM. The ground's colour draws either never reach Vulkan
(dropped inside the emulator) or are never issued by the game. Three doors drop a draw with no
trace in a capture and none of them was counted: `FilterDraw` (6 reasons, TRACE-level logs only),
a null pipeline from `RefreshGraphicsKey` (stage not enabled / no program / no binary info /
unsupported stage combo - the "no binary info" line is budgeted and did not fire in run 250) and
`BindResources` returning false. Run 250's log has 0 compile failures and 0 monster-image
refusals, so the remaining doors are the silent ones.

### Traps this round
- A `vkCmdDrawIndexedIndirect(1) => <0, 0>` is not an empty-buffer bug by itself: GT7 writes a
  record per LOD slot and leaves the unselected ones at zero.
- `PipeState` has no depth accessor in RenderDoc 1.45's python (`GetDepthState` does not exist);
  read `controller.GetVulkanPipelineState().depthStencil`.
- `SDObject` has no `AsUInt64`/`AsResourceId` here; read the POD union `obj.data.basic.u/.id`,
  and match `obj.type.basetype` by NAME (`SDBasic.ResourceId` is not an attribute either).
- `config.json` is written WITH a UTF-8 BOM (PowerShell); `json.load` needs `utf-8-sig`.
- A single frame cannot separate "repainted identically" from "never repainted" when the camera is
  still: pixel history can, because it lists every fragment whether or not it changed the pixel.

## RUN 251 (pre-declared) - count the silent drops

`GT7_probe251.bat` = probe 249 without the tess dump and without RenderDoc, on a binary whose
`[fprof]` line ends with `drops: tess N fce N fmask N resolve N primnone N dscopy N pipeline N
bind N` (per 2 s window) and which logs the first 24 pipeline-null / bind-false draws as
`[drawdrop] <door>: stage_enable=.. color_mode=.. prim=.. ps=.. vs=.. hs=.. gs=.. ls=.. es=..`.
Verdict rules: a non-zero `pipeline`/`bind`/`primnone`/`fmask`/`resolve` column during the race
names the door the ground falls through; all-zero columns mean the game never issues the draws
and the search moves to the GPU-driven pipeline that decides them (predication, conditional
dispatch, or a compute shader that writes the draw list). Run: `GT7_work\GT7_probe251.bat`, play
the Music Rally ~1 min, close normally; then `grep "drops:" shad_log.txt` and `grep drawdrop`.

## LAUNCHER PACKAGE (2 Sep) - "shadps4 0.18.1"

`Desktop\shadPS4 0.18.1 - GT7 dev - 2026-09-02\` holds `shadps4-core.exe` (this fork's build) and
`shadps4 0.18.1.exe`, a wrapper (`GT7_work/launcher_wrapper/shadps4_gt7_wrapper.cpp`, built by
`build_wrapper.bat`). The Qt launcher starts one exe with no environment and every GT_ knob is
OFF when unset, so the wrapper applies the probe-249 knob set and starts the local PSN stub
server ONLY when the game argument names CUSA24769 / "Gran Turismo", then runs the core with the
launcher's own command line. Registered in `%APPDATA%\shadPS4QtLauncher\versions.json` as
name "0.18.1", codename GT7dev (backup `versions.json.bak_20260902`). `GT_PROFILE=0/1` forces
the profile, `GT_PSN_SERVER=` (empty) disables the stub. Refresh the core there after each build
that is meant for play.

## RUN 251 VERDICT (2 Sep) - no counted door drops the ground, and the tess draws were misread

Log `GT7_work/logs/run251_drawdrop.txt` (Revision 06fa2d71-dirty = the census build, 228 s, 108
`[fprof]` windows, Music Rally reached). Summed over the run:

    drops: tess 0  fce 2917  fmask 0  resolve 3117  primnone 0  dscopy 0  pipeline 0  bind 0
    [drawdrop] lines: 0        compile failures: 0        device lost: 0

`fce` and `resolve` are exactly ONE per submit (36 / 36 in 36 submits at t=222 s) - the shape of a
legitimate fast-clear-eliminate + resolve pair, issued once a frame. The census cannot yet prove
they are screen quads rather than a 235k-index ground mesh routed through the wrong colour-control
mode (no index count was logged), so run 252 logs the first 32 of each with `num_indices`, MRT0/1
addresses, `fast_clear` and whether the FCE actually cleared anything (`EliminateFastClear` only
clears when the target's CMASK is tracked as cleared - otherwise it is a silent no-op, and that is
also the mechanism by which a fast-cleared HDR target would keep last frame's pixels).

**Correction to the run-250 reading of the four tessellated draws** [5388, 5394, 5400, 5406]: they
do not collapse. Their post-tessellation output has w = 177..181 (about 180 m from the camera) and
spans 0.3 x 1.4 m in view - four small distant upright objects (posts or people), 48 quad patches
each, drawn where they belong. The all-zero `VSOut` positions only mean the LS stage writes no
`gl_Position`. So the tessellation lane stays closed and the ground is not hiding there either.

What else the log says, none of it per-frame and so none of it the ground: 380
`Bindless sharp access detected ... handing to the bindless lowering` (recompiler, informational),
76 `Unexpected metadata read by a shader (texture)` (a shader sampling a CMASK/HTILE address -
GT7 reading its own metadata; rare), 32 `[clear] comp_swap-sensitive clear color` (fmt 6), 203
`[softclamp]` criticals, 0 `Unimplemented IT_SET_PREDICATION`, 0 `unhandled IT_COPY_DATA`.

### Where a GPU decision is still taken on the CPU

Every draw door the rasterizer owns now reads zero, so the parser (`liverpool.cpp`) was audited
for places that read GPU-PRODUCED data on the CPU at parse time - i.e. before the GPU has run the
shader that produces it:

| packet | how it is handled | verdict |
|---|---|---|
| `DrawIndexIndirectCountMulti` | `vkCmdDrawIndexedIndirectCount` with the count buffer | GPU-side, fine |
| `DmaData` memory->memory | `rasterizer->CopyBuffer` (GPU copy) | fine |
| `WaitRegMem`, `Rewind`, `MemSemaphore` | spin on the CPU until the GPU writes | fine (they wait) |
| `SetPredication` | stub | never issued by GT7 (0 warnings) |
| `CopyData` | unhandled | never issued (0 warnings) |
| **`CondExec`** | **`*cond_exec->Address() == false` - a 1-byte CPU read at parse time, no log, no count** | **the open door** |

On the console the CP evaluates COND_EXEC when it REACHES the packet, after every earlier packet -
including a culling compute pass and its fence - has executed. This parser runs ahead of the GPU
and reads guest memory NOW: last frame's answer, or nothing at all if the writer's buffer lives in
a device-local copy the buffer cache never downloads for a raw pointer read. A GPU-driven engine
that guards each road segment's colour draw with COND_EXEC (a CP-level test, cheaper than an
indirect draw) would lose every guarded draw this way, with no trace in any log or capture - while
the depth prepass, which PRODUCES the occlusion data, is drawn unconditionally. That is exactly the
run-250 picture: ground depth present, ground colour absent. Two further details worth knowing:
the read is one BYTE where the CP tests a 32-bit dword (a non-zero dword with a zero low byte is
"run" on hardware and "skip" here), and the ACB parser has no CondExec case at all (an unknown
opcode there is an assert, so the game does not use it on compute).

## RUN 252 (pre-declared) - the COND_EXEC census and the GT_CONDEXEC knob

`GT7_probe252.bat` = probe 251 + `GT_CONDEXEC=2`, on the binary of `build_run252.log` (BUILD EXIT
0, shadps4.exe 2 Sep 23:20:20; also deployed as the launcher's `shadps4-core.exe`), whose `[fprof]`
line now ends with

    ... | condexec: seen N skip N bytediff N forced N | fce cleared N

and which logs the first 48 COND_EXEC packets (then one in 4096) as
`[condexec] #n: addr= dword= byte_false= -> SKIP|run exec_count= guarded: opcode= words= indices=
region registered= gpu_modified=` and the first 32 FCE / resolve draws as `[filterdraw]`.
`GT_CONDEXEC`: 0 (default, what the launcher core runs) = the byte read as before; 1 = the dword
the CP reads; 2 = never skip (diagnostic - if the road surface appears, the door is found;
over-drawing culled objects only costs time); 3 = drain the GPU (`Finish` + `ReadMemory`) and read
the dword = the value the CP would have seen, very slow (`GT7_probe253.bat`).

Verdict rules: `seen 0` in every window = GT7 does not use COND_EXEC on the graphics ring and the
search moves to the GPU-generated draw list itself (which draws does the game issue at all: compare
the prepass ground draw's index/vertex buffers against every colour-pass draw in the capture).
`seen > 0` with `skip` close to `seen` and the road surface visible under mode 2 = door found; the
proper fix is then to evaluate the condition on the GPU (`VK_EXT_conditional_rendering` around the
guarded block, or the buffer-cache download before the read), not to force execution.
`bytediff > 0` = the one-byte read is a second, independent bug. `[condexec]` lines with
`gpu_modified=1` name the device-local-copy case directly. Mode 2 can also hang: a guarded block
may contain a `WaitRegMem` on a value only produced when the condition holds - if the game freezes
with `[gpuwait]` lines, that is what happened, and mode 1 or 3 is the follow-up.

Trap paid for here: the checkout is CRLF, so a python patch whose patterns are written with `\n`
matches nothing - convert the patterns, do not force the match.

### Run 252, attempt 1 (2 Sep 23:24): crashed in the menu at t=42 s, before any COND_EXEC

Log `GT7_work/logs/run252_condexec_crash.txt` (Revision 0f43f014-dirty = this build). The game
never reached the race: 19 `[fprof]` windows, all `condexec: seen 0`, and the `[condexec] GT_CONDEXEC
mode` line was never printed - it is logged lazily on the first packet, so **not one COND_EXEC was
parsed before the crash and mode 2 never acted**. The crash itself is a guest one:

    [Debug] <Critical> (Job#10) SignalHandler: GUEST WILD JUMP: execution at unmapped/NX 0x54aca982
    ... guest crash minidump WRITTEN: %APPDATA%\shadPS4\log\guest_crash.dmp

**Known class, not new**: the log archive holds ten earlier `GUEST WILD JUMP` crashes on other
job threads (Job#0/26/33/40/43/56, Netwk), and the jump targets cluster - 0x54aca982 today,
0x5452a982, 0x5441b6b7, 0x550eb0ba, 0x5748957e before - which reads like the same corrupted
pointer/return address each time (a guest data word landing where code should be). Intermittent,
menu-phase, independent of any GT_ knob touched today. The 17 `[cshang]` watchdog lines before
it (cs 0x18256c0, groups 4x4x6) are the usual boot-time count (run 251 had 32 over its whole
run). Re-run the same probe; nothing in the binary needs to change for that.

### What the 32 `[filterdraw]` lines already said (menu phase)

Every FCE draw is `num_indices=4 prim=5` (a screen quad - so the once-per-frame FCE of run 251 is
NOT a mis-routed ground mesh; that possibility is closed) on **`mrt0=0x1005000000` = the HDR scene
target itself** (capture 1's ResourceId 21737), `fast_clear=1`, `cmask=0x10057f8000`, and `acted`
ALTERNATES true/false: #0 true, #1 false, #2 true ... In the windows: `fce 6 / cleared 3`,
`fce 114 / cleared 17`. So GT7 fast-clears its HDR target through CMASK every frame, and the
emulator turns that into a real clear only when `IsMetaCleared` happens to be set - about half the
time in the menu, and in the run-250 race frame **never** (the capture shows no clear of 21737 at
all). That is the second half of the yellow-carpet symptom: the missing ground draws leave old
pixels, and the missed fast clear is what lets them survive frame after frame instead of becoming
the clear colour. It is a separate bug from the missing draws (a correct clear would show a black
or sky-coloured road, not a grey one) and it wants its own look: which path the game uses to write
the CMASK (a CS write through `BindBuffers` -> `ClearMeta` is the only one tracked; a `DmaData`
fill to the CMASK address, if that is what alternates with it, is not). The per-window
`fce N ... fce cleared M` pair quantifies it at race time without any new code.

## RUN 252 VERDICT (2 Sep 23:33) - GT7 never issues COND_EXEC; the HDR fast clear is never honoured

Log `GT7_work/logs/run252_condexec.txt`, 227 s, race reached (38k draws per window), no crash.

    condexec: seen 0 skip 0 bytediff 0 forced 0      in ALL 107 windows
    fce == submits (one per frame), fce cleared 0    in EVERY race window (20 clears total, all at t=32 s in the menu)
    resolve: 4-index quads on mrt0 0x100a150000 -> mrt1 0x100a0b0000 (the 500x320 UI panel), never the scene

So: **COND_EXEC is not used by this game on the graphics ring** (the mode line was never even
printed - the knob had nothing to act on, which is why "everything still loads the same" was the
correct report). The CondExec door is closed permanently. The emulator now has NO counted or
uncounted door left through which a draw disappears: `Draw()`/`DrawIndirect()` return only at
FilterDraw / null pipeline / BindResources (all counted, all zero), the parser's draw handlers have
no skip conditions, and every GPU-produced decision packet is either GPU-side
(`DrawIndexIndirectCountMulti`), waited for, or unused. **The ground's colour draws are never
issued by the game.**

And the persistence half is now a measured fact: the HDR target's per-frame fast clear (CMASK
0x10057f8000, `fast_clear=1`) is recognised **zero** times during the race, so `EliminateFastClear`
is a no-op every frame and the target carries the previous frame forward. Tracking only recognises
an exact-base `FillBuffer` (CP DMA fill) or an xor-free compute write whose V# base IS the CMASK
base (`IsComputeMetaClear`); a write starting below the base, a PS write, a `CopyBuffer`, or a
shader with an address xor all go unseen.

### What the capture says about the missing draws (analyze22/23/24)

`analyze22_pairing.py` (by Vulkan resource id) and `analyze23_guestpair.py` (by guest address,
parsed from shadPS4's `Buffer 0x<base>:0x<size>` names) both have a blind spot: most colour-pass
index/vertex bindings come from **resource 228, the 64 MB stream buffer**, which has no guest
address in its name and is one Vulkan buffer for hundreds of unrelated meshes. Pairing by identity
therefore under-counts partners badly (218 / 196 of 223 "unmatched") - and "depth-only" also lumped
shadow-map draws in with the main prepass. `analyze24_contentpair.py` pairs by CONTENT (md5 of the
first 128 bytes of the index data / vertex buffer 0) and restricts the prepass to depth target 22725;
its report is `out_persist/cap1_contentpair.txt`. What is already solid without it:
- the ground draw eid 3118 (235,272 indices, vs 6504, ib guest 0xf4241221a0, vb 0xf424068180):
  **no colour draw shares its index or vertex memory through ANY buffer** - the only Vulkan buffer
  covering that guest range (169630) is used by exactly two draws, both depth-only (3118, 3125).
- the HDR target has **no compute writer** and no copy into it: its non-draw usages are barriers and
  two PS_Resource reads (eids 6570, 7666 - the post passes). Nothing composites the ground in later.
- the GPU-driven part of the frame: dispatches 2181-2287 (cs 464/248/412/420/336) write the indirect
  args buffer (110460) BEFORE the prepass and two of them read a render target (`readsRT`, cs 248 and
  420 - the previous frame's depth/HiZ, i.e. occlusion culling); 512-thread `cs 340` at eid 7183 and
  cs 268/440/452/380/332/556 after the scene write it again (the UI/next-frame lists).
  Eight dispatches per frame (cs 436, groups 1x1x1, 12 RW bindings) and the `cs 448` family write
  the 240 MB `buf101860`. The largest colour-pass draw is 10,092 indices (eid 6143); there is no
  draw of ground size anywhere in the colour pass, direct or indirect.

## RUN 254 (pre-declared) - who writes the CMASK, and the FCE forced

`GT7_probe254.bat` = probe 252 without `GT_CONDEXEC`, plus `GT_WATCH_VA=10057f8000
GT_WATCH_SIZE=40000` (the existing `[vawatch]` probe: every shader V# bind of any stage with its
WRITE flag, every fill and every copy touching the CMASK range - the path the clear tracking must
learn) and `GT_FCE_FORCE=1` (an FCE on a `fast_clear` target clears even when the CMASK write was
not tracked; `[fce]` logs the first 8, `fce cleared N forced M` counts them). Binary
`build_run254.log` (BUILD EXIT 0, exe 2 Sep 23:45:55, also the launcher core). Its `[fprof]` line
also gained per-window softclamp counts `softclamp: floor align tail untail maptail unmapped offpast
range` - the seven null-bind/clamp decisions in BindBuffers whose logs are capped at 32-64 lines
per process, so their race-time RATE had never been measured (242 lines in run 252 say nothing).

Verdict rules: `[vawatch] ... WRITE` lines name the writer (a `fill` = CP DMA at an offset the
exact-base match missed; `buf shader X WRITE` = a compute or pixel shader; `copy-dst` = untracked
entirely). If the road turns a flat colour under `GT_FCE_FORCE`, the persistence mechanism is
confirmed and the proper fix is range-aware CMASK-clear detection on that path; if the yellow
survives even then, the pixels are being carried by something other than the un-cleared target
(e.g. a temporal pass reading last frame's HDR).

## RUN 254 VERDICT (2 Sep 23:55) - the scene goes BLACK, the CMASK is written once, and 94% of the prepass has no colour draw

Log `GT7_work/logs/run254_fceforce_vawatch.txt` (Revision 9291333f-dirty = the run-254 build).
The user's report and screenshots: "now there is only black screen no image" - the Music Rally
menu draws its UI, the 3D car preview is black except a few cyan specular streaks, and the race is
black with the dialogue box on top. That is the EXPECTED outcome of `GT_FCE_FORCE=1` and it is a
measurement, not a regression: with the HDR target really cleared every frame, everything that is
not repainted shows the clear colour instead of last frame - and what is not repainted is **the
whole 3D scene**: road, terrain, and the car body. The yellow carpet and the black screen are the
same defect wearing two colours. Do not play with probe 254; the launcher core has the knob off.

- `fce N cleared N forced N` in every race window: every FCE was forced, none was tracked.
- **`[vawatch] buf-fmt shader 0xaaa36b0e: 0x10057f8000+0x5000 WRITE` - ONCE in the whole run.**
  The CMASK (0x5000 bytes = exactly a 1920x1080 CMASK) is written one time, by a formatted buffer
  store, at target creation. GT7 does NOT fast-clear the HDR target per frame; on the console the
  per-frame FCE is a no-op too and the engine relies on repainting every pixel. So the "missed
  fast clear" is not a bug and `GT_FCE_FORCE` is not a fix - it only changes the fill colour.
  (The other 182 `[vawatch]` lines are image READS at 0x1005800000 = a neighbouring resource inside
  the too-wide 0x40000 window, not the CMASK.)
- `softclamp: tail ~10-13k, maptail ~10-13k` per 2 s window in the race = ~300 tail-descriptor
  binds PER FRAME clamped to their mapped prefix (`TailBindCap` 256 MB). Legitimate engine practice
  (V#s sized "to the end of the heap"); a read past the mapped prefix would fault on the console
  too, so this is probably benign - but it is now a measured rate instead of a capped log.
  `align 14-17`, `floor 0-2`, `untail 0-7` per window; `unmapped/offpast/range` 0.

### analyze24 (content pairing, `out_persist/cap1_contentpair.txt`) - it is the whole opaque scene

Pairing prepass and colour draws by the md5 of their first 128 bytes of index / vertex data (blind
to buffer identity, so the stream buffer no longer hides partners), main prepass = depth 22725 only
(the other 104 depth-only draws are a shadow map, target 55832):

    main prepass 118 draws, 382,200 indices
    matched by content: 76 (56 by index data, 20 by vertex data - the props/trees/helpers)
    UNMATCHED: 42 draws, 360,927 indices = 94% of the prepass
      eid 3118 235,272 (ground)   eid 3132 74,862 (terrain)   eid 3125 21,387 (vs 6504 all three)
      ~30 draws of 120..1,920 indices with vs 3694 / 3095 / 8091, FOUR vertex streams each = the car
    HDR draws with no prepass partner: 244 of 322 (109,615 indices) - sky, transparents, helpers

So it is not "the ground's draws are missing": **no opaque scene object has a colour-pass draw.**
Those 118 prepass draws DO carry a fragment shader (the ground's is fs 6503) while binding no colour
attachment. A depth-only pass has no use for a pixel shader unless it alpha-tests - or unless it
writes its outputs ITSELF through storage images/buffers: a G-buffer / visibility pass. That fits
every fact collected since run 250: no colour draws for the opaque scene by design; at ground
pixels the only HDR writers are the sky (depth-failed), eid 6570 (a full-screen pass that READS the
HDR target and wrote back exactly what it read - what a deferred lighting pass degenerates to when
its G-buffer inputs are empty) and eid 7544 (discard); the whole scene black once the target is
cleared. `analyze25_gbuffer.py` tests it directly: the prepass fragment shaders' declared and bound
read-write resources, who else uses them, and what eid 6570 / 7544 read. If the prepass FS writes
a BUFFER that 6570 reads as an IMAGE at the same guest address, the suspect is the buffer->image
aliasing sync (`BindBuffers`: only FORMATTED writes call `InvalidateMemoryFromGPU`; plain SSBO
stores leave a sampled image stale unless `GT_INVAL_IMG_ON_SSBO=1`) - the same class of bug the
Act-11 LUT hunt found. If it writes storage IMAGES, the suspects are the 11 `EmitImageWrite:
Fallback for ImageWrite with LOD` shaders and the `[imgarray] N/16 null` bindless arrays.

### analyze25 (`out_persist/cap1_gbuffer.txt`): the G-buffer hypothesis is REFUTED

All 15 fragment shaders of the main prepass declare **no read-write resources and no colour
outputs**; 14 of them sample exactly one texture (alpha test for foliage/fences), the ground's
fs 6503 has only a constant block. It is a genuine depth-only prepass. Pass 6570 is not a lighting
pass either: it reads the 1x1 R8 exposure state (0x1000e33200), the depth buffer, the HDR target
itself and two 80x32x40 R11G11B10 volumes (froxel fog), and writes 21737 + 55213 - a volumetric-fog
composite, whose identity output at ground pixels just means "no fog there". Pass 7544 is a
depth-tested alpha blend of a 720x540 RGBA16F (particles/haze). **So nothing in the frame paints
the opaque scene, and nothing was supposed to compose it later: the game really does not issue the
colour draws.** Three mechanisms can produce that from the game's side: (A) CPU-side culling from a
GPU readback the emulator answers wrongly, (B) draw packets written INTO the command buffer by the
GPU (NOP placeholders patched by compute) that this parser reads before they exist, (C) the game
withholding materials it considers not resident.

### (A) has a concrete defect behind it: the ZPASS_DONE event type is ignored

`liverpool.cpp`, `case PM4ItOpcode::EventWrite`: occlusion queries are FAKED (the parser has no
pixel counters) by writing a monotonically rising value with the valid bit into the results block -
but **only when `event_type == PixelPipeStatDump` (57)**. Gnm's `writeOcclusionQuery` emits
`event_type = ZPASS_DONE (21)`, `event_index = ZPASS_DONE (1)`, BEGIN aimed at results+0 and END at
results+8. For that packet the handler does nothing: the results block keeps the zeros the game
pre-filled, `end - begin = 0` for every object, and a CPU-side occlusion cull skips the colour draw
of everything it queried - while the depth prepass, which IS the query pass, is drawn in full. That
is precisely the measured shape: prepass complete, colour pass holding only the objects that are
not query-culled (sky, transparents, GPU-driven props, helpers), the opaque scene absent, black once
the target is cleared. The DEBUG line "Encountered EventWrite" is filtered out of the log, which is
why five runs of census never saw it.

## RUN 255 (pre-declared) - fake the ZPASS_DONE results for every event type, and count events

`GT7_probe255.bat` = the probe-252 environment (no CondExec knob, no FCE forcing, no address
watch) with `GT_ZPASS_FAKE=1`, which is also the new DEFAULT (`=0` restores the old
PIXEL_PIPE_STAT_DUMP-only gate). The binary (`build_run255.log`) writes the rising fake counters
for every `event_index == ZPASS_DONE` packet, logs the first 16 as
`[zpass] #n: event_type= addr= pairs= game had X / Y there, writing counter Z`, and prints an
EVENT_WRITE census per 2 s window as `[pm4ev] event_write per window: t<type>/i<index>=count`.
Verdict rules: `t21/i1` present per frame AND the road/terrain/car appear (in whatever shading
state - exposure and LUT are separate fronts) = mechanism confirmed; the honest follow-up is then
real occlusion queries (`VK_QUERY_TYPE_OCCLUSION` around the queried draws, results copied into the
game's block) so the counts are true rather than "always visible", which also removes the LOD /
coverage side effects a 50M-pixel fake can have. `t21/i1` absent = GT7 does not use ZPASS_DONE
queries here, hypothesis (A) via queries dies, and the next census is the NOP one for (B): NOP
packets by dword count per window (a patched draw placeholder is a NOP of exactly a draw packet's
size, hundreds per frame) plus REWIND counts.

## RUN 255 VERDICT (3 Sep 00:14) - THE SCENE APPEARED, and the ZPASS fake had nothing to do with it

Log `GT7_work/logs/run255_zpass_fake.txt`, 231 s, no crash. The user's screenshots: the Music
Rally menu with a (very over-exposed) 3D background, and the race with **road, grass, trees, sky,
the driving line and the opponent BMW 3.0 CSL all drawn** - the first time since the yellow carpet
was reported. Remaining defects on those frames: flat yellow blocks and white plates on the verges /
terrain (placeholder-looking materials), the lower half of one frame dithered and cut by a
horizontal seam (a near-terrain LOD or reconstruction artifact), and the exposure blowing the menu
scene to white.

**But the fix that shipped in this build did not fire.** `[zpass]` lines: **0**. The `[pm4ev]`
census over 91 windows holds only cache-flush events: `t44/i7` (FlushAndInvDbMeta), `t46/i7`
(FlushAndInvCbMeta), `t49/i7` (FlushAndInvCbPixelData) - **not one ZPASS_DONE (t21/i1) and not one
PIXEL_PIPE_STAT_DUMP (t57/i1)**. GT7 does not use occlusion queries on the graphics ring, and
`GT_ZPASS_FAKE` is inert for this game (harmless, left at default 1). Hypothesis (A)-via-queries is
dead; the section above that presented it as "the missing scene" was wrong and is corrected here.

### Three runs, one code path, three pictures: it is a race

| run | binary state | env difference | picture |
|---|---|---|---|
| 252 | census build | GT_CONDEXEC=2 (inert: 0 CondExec packets) | yellow carpet |
| 254 | + softclamp counters, FCE force | GT_FCE_FORCE=1 (only changes the fill colour) | black |
| 255 | + ZPASS fake (inert), event census | GT_ZPASS_FAKE=1 (inert) | **scene drawn** |

Draws per submit (1000-1500), pipeline compiles (1774-2195, cold cache in all three - each was a
fresh build) and busy times are alike across the three; `diff` of the probe .bat files shows only
the inert knobs. ⚠ And `run_gt7.ps1 -Net` **sets knobs of its own on top of every probe .bat**:
`GT_DEFER_EOP=1`, `GT_DEFER_RELEASEMEM=1`, `GT_BINDLESS_STUB=1`, `GT_STALL_DUMP=1`,
`GT_SOFT_CLAMP=1`, `GT_DISPATCH_BARRIER=0`, `Set-GtDefault GT_SPLIT_DISPATCH 64` (the .bat's 1
wins), `GT_STORE_CLAMP 1`, `GT_DYNRC_WINDOW 1` - so honest fences were ON in all of these runs (the
`[softclamp]` lines prove the block ran), and the launcher wrapper's 34-knob profile is MISSING
those (a launcher launch is a different configuration from a probe .bat; fix the wrapper before
comparing the two). Whether the game issues the opaque scene's colour draws therefore varies run to
run with NO configuration change: **a run-time race inside the emulator decides it.**

What the race is about is not yet measured. Facts that bound it:
- `[faulthist]`: **17,350 faults, all writes, 0 reads** - the game's CPU never faults reading
  GPU-written memory. GPU->CPU data reaches it through directly imported memory (BDA/direct import)
  with whatever timing the GPU happens to have; a device-local copy (stream buffer, `RecordTable`
  paths) is never downloaded for it, and a BDA store to an unregistered page is dropped
  ("the value is gone", `RecordTableRegionCopy`'s own comment).
- `ClampRangeSize` merges adjacent mapped VMAs, so the ~300/frame tail-descriptor clamps are
  not cut at mapping seams; probably benign.
- No shader was stubbed in run 255 (`substituting a NO-OP module`: 0), so the yellow/white terrain
  is not the bindless stub; texture/material streaming state is the open suspect for it.
- No guest TTY output exists to read the game's own view.

## RUN 256 (pre-declared) - the picture as a number

`GT7_probe256.bat` = probe 255's environment on a binary whose `[fprof]` line ends with
`bigdraw: depth N colour N | middraw: depth N colour N` (draws of >= 50k indices and 10k..50k per
window, split by whether a colour target is bound via `color_target_mask.GetMask(cb)`), and which
logs the first big colour draws as `[bigdraw] #n: N indices with a colour target (mrt0 fmt) ps= vs=`.
The yellow carpet is `big colour 0` with `big depth > 0`; the run-255 picture is `big colour >= 1`
per frame. The user reports the picture, the log reports the count, and the two together say
whether the race is decided once per run or flickers per frame - which is what decides where to
instrument next (a per-run decision points at initialisation / streaming state; a per-frame one at
the GPU->CPU readback timing of a specific buffer).

## RUN 256 VERDICT (3 Sep 00:26-00:29) - big colour draws were issued all race long; WHICH ones is the open question

Log: `GT7_work/logs/run256_bigdraw.txt` (its Revision line says `01fa2cdf-dirty`: the bigdraw binary
was built before its own commit f8b781d5, and the `[bigdraw]` lines prove it is that build). Normal
exit, no crash, 61 windows, race from t=44 s. The user reported only "game closed" - **the picture
for this run is not known yet** and has been asked for.

What the count says:
- first race window (t=44 s): `bigdraw: depth 8 colour 0 | middraw: depth 620 colour 0` - a prepass
  with no colour pass at all, for one window;
- from t=47 s on, EVERY window: `bigdraw colour` 31-141 against `fce` drops 29-49 (one FCE draw per
  frame, so about **1-4 big colour draws PER FRAME**); `bigdraw depth` swings 4-208 (the prepass list
  changes with the camera);
- the sampled `[bigdraw]` lines name them: menu 164961 / 81543 indices on RGBA8 targets
  0x10c42.../0x10c52...; 75000 x4 on 0x100a0b0000 (R11G11B10, NOT the HDR target); and into the HDR
  target 0x1005000000: #1024 = 51924 (ps 0x1034745700), #2048 = 77784 (ps 0x103f1df300),
  #3072 = 57780 (ps 0x10496c9200). **None of them is the ground (235272) or the terrain
  (74862 / 21387).** Three samples out of ~3600 - not a verdict about the ground either way.
- Capture 1 (a yellow-carpet frame, `rdc/out_persist/cap1_contentpair.txt`): the LARGEST colour draw
  into the HDR target was **10092 indices**. Run 256 therefore issued >= 50k-index colour draws that
  the capture-1 frame did not have, every frame of the race.
- Per-window draw statistics of runs 252 (yellow) / 254 (FCE-forced black) / 255 (scene) / 256 are
  INDISTINGUISHABLE: 35-50k draws per window, `fce` ~30-45, `resolve` = `fce` after the first ~15 s
  of the race, 0 faults, no stalls. The draw COUNT cannot tell a yellow run from a scene run - 1-4
  draws in ~1000 per frame is inside the noise. Only the bigdraw/bigidx census can, and it exists
  only from run 256 on: the "three pictures, same statistics" claim of the RUN 255 verdict is now
  confirmed by numbers for the statistics half and STILL UNMEASURED for the picture half of run 252.
- A caution on the story so far: "yellow leftovers on the road" (run 252, no screenshots) and
  "road / grass / trees / sky + yellow blocks + white terrain plates" (run 255, screenshots) may be
  ONE picture described twice. If run 257 shows the ground drawn in colour (235272 inside
  `colour[...]`) while the yellow blocks persist, the blocks are texture-TILE content (streaming /
  virtual-texture cache), not missing draws - and the "race" would be a race in what the tiles
  contain, not in whether the ground is drawn.

## RUN 257 (pre-declared) - the index counts themselves

Build 3 Sep 00:38:52 (`bigidx` string present), commit 587202c9, launcher core refreshed.
`GT7_probe257.bat` = probe 256's environment. `vk_rasterizer.cpp`: `GtBigIdx` / `GtBigIdxTable`
(12 distinct index counts per class per window + an overflow counter); every `[fprof]` window is
followed by
`[bigidx] t=NNs depth[235272x37 74862x36 ...] colour[51924x35 ...] | indirect draws: depth N (max_count N) colour N (max_count N)`
(`GtNoteBigIdx` in `Draw()` for draws >= 50k indices, `GtBigIdxString` sorts by count;
`DrawIndirect()` counts its calls and their `max_count` by colour-target presence - an indirect colour
pass would draw the ground with counts the CPU never sees).
Read it as: `235272` inside `colour[...]` = the ground IS drawn in colour by a direct draw and the
yellow is a texture/tile problem; `colour[...]` holding only other counts with `indirect draws:
colour > 0` = a possible indirect colour pass (RenderDoc can pair it by index-buffer resource);
neither = the ground's colour pass is absent in that window. Compare the count with the user's
picture of the SAME run.

## THE LAUNCHER WRAPPER NOW MATCHES A PROBE (3 Sep, commit 587202c9)

`kGt7Profile[]` grew from 34 to 53 knobs: `GT_DISPATCH_BARRIER=0 GT_DEFER_EOP=1
GT_DEFER_RELEASEMEM=1 GT_BINDLESS_STUB=1 GT_SOFT_CLAMP=1 GT_STORE_CLAMP=1 GT_DYNRC_GPU=0
GT_DYNRC_WINDOW=1 GT_BINDLESS_LOWER=1 GT_BINDLESS_IMG=1 GT_BINDLESS_STORES=1 GT_BINDLESS_IMGARRAY=16
GT_IMGARRAY_SYNC=0 GT_IMGARRAY_SYNC_MAX=64 GT_INVAL_IMG_ON_SSBO=0 GT_LUT_DUMP=0 GT_IMGWRITE_SCRUB=1
GT_RT_SCRUB=92126594 GT_HASH_BASELINE=1` - everything `run_gt7.ps1 -Net` writes with `$env:` or
`Set-GtDefault` in its `-Net`/`-Offline` block (lines 268-481; `GT_STUB_SHADERS=''` means "unset" and
is not replicated; `GT_SPLIT_DISPATCH` stays 1, the .bat's value, which wins over the script's
default 64). Rebuilt with `build_wrapper.bat` (172544 bytes, was 171520) and installed as
`Desktop\shadPS4 0.18.1 - GT7 dev - 2026-09-02\shadps4 0.18.1.exe`. NOT replicated: the config-file
writes `run_gt7.ps1` does (log filter, `direct_memory_access_enabled`, the signed-in network flags,
the PSN user) - a launcher start reads whatever the last probe left in `%APPDATA%\shadPS4\config`.
So a launcher launch now differs from a probe only by that config file and by the probe's log
archiving.

## RUN 257 VERDICT (3 Sep 00:45-00:49) - the ground is in the depth prepass every frame and in NO colour pass, ever

Log: `GT7_work/logs/run257_bigidx.txt` (Revision `f8b781d5-dirty` = the bigidx build before its
commit 587202c9; 87 `[bigidx]` lines). Normal exit, race from t=44 s to ~t=218 s. The user again
reported only "game closed"; the picture is still unknown and has been asked for a second time.

**Direct draws, per window, index count x times drawn:**
- The GROUND FAMILY is in `depth[...]` once per frame whenever the camera has it (t=82-98: `235272x35
  74862x35` against `fce 35`; its camera-dependent siblings `224580 213885 192498/192495 149718/149721
  139023/139026 117639 106941/106944 96249 64164/64167 53469/53472` come and go) and **never once in
  `colour[...]`** - not in 87 windows, not with ANY colour target.
- The colour pass into the HDR target 0x1005000000 IS running, on OTHER meshes: `98304` ~2x per
  frame in both `depth[]` and `colour[]` with equal counts (ps 0x10496c9200, mrt0 0x1005000000 fmt 6
  - the `[bigdraw]` samples #1024..#7168 are all this draw), `66060` / `57780` with the same ps, and
  dozens of 50k-98k objects that appear in both lists with identical counts for a few frames each
  (ordinary prepass + colour pairs: `72360x11 78660x11 72900x7 ...`). Colour-ONLY counts (no
  prepass) exist too: `77784` (up to 41x per window = once per frame in some windows), `85926x36`,
  `52764 65871 163196 58656 60096 92160 69216` - transparent or decal-class draws.
- `indirect draws: depth N colour N` are nearly equal every window (hundreds to ~6000 per window):
  the GPU-driven props are drawn by the same indirect calls in both passes. Their index counts are
  GPU-side; the ground COULD hide there only if its colour pass were indirect while its prepass is a
  direct 235272 draw - possible, unproven, and NOT what capture 1 showed (RenderDoc reads the args:
  the largest colour draw into the HDR target there was 10092 indices, direct or indirect).
- Pre-race and post-race windows show a `74859` depth draw paired with a `75000` colour draw into
  0x100a0b0000 (fmt 6, NOT the HDR target) - a different object family (menu/loading scene); do not
  confuse it with the race's `74862`, which has no colour partner.

**What this settles and what it does not.** Whether the game issues the ground's colour draw is
NOT a per-frame race in this environment: it is absent in every window of a 3-minute race. Run 256
and run 257 are consistent with each other; capture 1 (run 250) additionally lacked the 98304 /
77784 / 5xxxx-9xxxx colour draws that 256/257 have, so run 250's frame had LESS of the world in
colour than these runs do - which is what "yellow carpet" versus "scene with yellow blocks" would
look like. What the user SEES in 257 is the missing half of the comparison.

**Open candidates for the mechanism (unchanged, now sharper):** the game's CPU decides the colour
draw list from something the GPU produced, and that something reaches the CPU as zeros here.
`config.json` for these runs: `readbacks_mode 0`, `readback_linear_images_enabled false`,
`direct_memory_access_enabled false` (the .bat's GT_DIRECT_IMPORT/GT_BDA_IMPORT are the fork's own
import knobs, not upstream DMA). The Act-11 readback hunt (runs 185/186, `[dlimg]`/`[dlskip]`,
Relaxed mode) was aimed at the exposure wash - "wash unchanged, 105 MB synchronous downloads =
1 FPS" - and was never judged against the ground's colour pass, because the ground's absence was
not known then. Run 257 shows 0 `[dlimg]`, 0 `[dlskip]`, 0 NO-OP shader substitutions.

## RUN 258 (pre-declared) - a RenderDoc capture of THIS environment

`GT7_probe258.bat` = probe 257's environment + `-RenderDoc` (`Vulkan.renderdoc_enabled`, F12 in
game; RenderDoc found through its registry key; earlier captures live in
`%APPDATA%\shadPS4\captures\CUSA24769_capture*.rdc`, capture 1/2 = run 250, 3/4 = 27 Aug). The user
presses F12 during the race with the road in view. Analysis, headless, on the pattern of
`rdc/analyze22-25`: (1) every draw whose index-buffer or vertex-buffer RESOURCE matches the
235272-index prepass draw, with its colour targets - the ground's colour pass by resource identity,
direct or indirect; (2) what `98304` (ps 0x10496c9200) and `77784` are, from their vertex data /
targets / shaders - the world's colour pass is carried by them; (3) the HDR target's draw list
against capture 1's 322 draws. This decides between "the ground's colour draw is never issued"
(mechanism hunt: GPU->CPU data) and "it is issued under an index count / path the census cannot
see" (pairing bug in the census).

## RUN 258 VERDICT (3 Sep 18:18) - EVERY RENDERDOC CAPTURE IS OF A DIFFERENT EMULATOR: no BDA import

Log: `GT7_work/logs/run258_rdc.txt`; four captures in `%APPDATA%\shadPS4\captures\`
(`CUSA24769_capture.rdc`, `_2`, `_3`, `_4`, 3 Sep 18:18-18:19 - **they overwrote run 250's capture 1/2
and the 27 Aug 3/4**; run 250's analyses survive in `rdc/out_persist/cap1_*.txt`). Headless analysis
`rdc/analyze26_groundpair.py` -> `out_persist/c258_<n>_groundpair.txt` (resource-identity pairing
of the ground draw, post-VS clip bounds of the big colour draws, HDR draw list).

**The user's report changed the picture, and then the log explained it.** The yellow lines are the
game's own beginner racing-line assist - correctly drawn, not a defect, and not "old pixels". The
defect is the ROAD UNDER IT: "if I turn the line off I cannot see even the first corner". So
"yellow carpet" = racing line over an undrawn road, and the census was measuring the right thing.

**What the log says, run 258 (RenderDoc attached) against run 257 (none):**

    run 257:  [bdaimport] ACTIVE: 8448 MiB guest backing imported in 9 chunk(s)
              [directimport] ACTIVE ... ~20k queries / ~2.5k hits per window
              98304-index draws (ps 0x10496c9200, HDR target) in 73 of 87 windows, depth AND colour
    run 258:  Extension VK_EXT_external_memory_host unavailable.
              [bdaimport] disabled: VK_EXT_external_memory_host is unavailable
              [directimport] 0 queries ... every window
              98304-index draws in 0 of 39 windows; colour[] holds only the 164961/81543 pair
              (menu/HUD car), 77784 in 7 windows and the 51924/58656/65610/101382/128700 group in 6

RenderDoc's Vulkan layer does not expose `VK_EXT_external_memory_host`, so `InitializeBdaBacking`
returns false and BOTH `GT_BDA_IMPORT` and `GT_DIRECT_IMPORT` are silently off for the whole run.
Capture 1 (run 250) was taken the same way. **So every RenderDoc frame ever analysed in this
project shows the emulator WITHOUT the only path by which a GPU-written value reaches the game's
CPU** (a BDA store into imported guest RAM; a store to an unregistered page "took the fault path
and the value is gone", `RecordTableRegionCopy`). That is why capture 1's largest colour draw into
the HDR target was 10092 indices, and why run 258's census has no 98304 either.

**Reading of the 98304 family.** 98304 = 0x18000 = 16384 quads, i.e. 128x128 patches; drawn ~2x
per frame in both the prepass and the colour pass with the same count, sharing ps 0x10496c9200 with
66060 and 57780; present in EVERY race window of runs 256/257 and in none of 258 / capture 1. The
best reading: **this is the terrain/road colour geometry, issued by the CPU from a list that depends
on GPU-produced data** (culling / LOD / virtual-texture feedback), which only exists when BDA import
is on. The 235272 / 74862 family that IS in the prepass every frame and never in colour is then
another mesh - an occluder / shadow / collision-class ground drawn for depth only - and its
"missing colour pass" was a red herring: it never had one to miss.
⚠ The run-257 windows WITHOUT 98304 (t=72-76 and the like) also have `indirect draws: depth 0
colour 0` and only the menu pair in depth[] - camera cuts / non-race views, not a race in the
colour pass. **In run 257 no race window lacked the terrain patches.** The "per-run race" of the
RUN 255 verdict is therefore unconfirmed; what is confirmed is RenderDoc vs no RenderDoc.

**What the user must now confirm (asked):** in a probe WITHOUT `-RenderDoc` (257) the road is
drawn under the racing line; in 258 it is not. If yes, the road is solved in the played
configuration and the remaining fronts are the exposure flashes, the white terrain plates and the
horizontal seam - all of which can only be studied WITHOUT RenderDoc, i.e. with in-emulator
instruments (`[bigidx]`-style censuses, `HighResShot`-class screenshots from the game itself), never
with a capture. ⚠ **Do not use a RenderDoc capture to reason about anything that depends on GPU->CPU
data in this project again** unless the capture is taken with BDA import proven ACTIVE in that run's
log (`grep bdaimport shad_log.txt`).

**Open follow-ups:** (a) name what 98304 is from the played configuration - e.g. dump the first
vertices/bounds of that draw from inside the rasterizer under a `GT_DRAWDUMP_IDX=98304` knob, or
compare `[bigidx]` against the user's screenshot of the same run; (b) if the road still flickers in
normal runs, the race is inside the BDA-import readback timing (`[directimport]` hits vs the game's
polling) and the honest-fence knobs are the lever; (c) analyze26 reports on the four run-258
captures, when they finish, still identify 77784 / the 51924-group / the menu pair and give the HDR
draw list of the no-import configuration for the record.

### The four run-258 captures, analysed (`rdc/out_persist/c258_1..4_groundpair.txt`, analyze26)

All four are frames of the no-BDA-import emulator, and all four agree with the census:
- **Not one draw of >= 50k indices with a colour target in captures 1-3; exactly one in capture 4**
  (below). The 1080p HDR target (`59040`, R11G11B10) receives 219-396 draws of 70k-124k indices in
  captures 1-3 and 323 draws / 575k in capture 4 - never the terrain patches.
- **The ground family is depth-only by RESOURCE identity, not only by index count**: captures 2 and
  3 hold `224580`+`74862` and `149718`+`74862` (vs 4200) in the 1080p prepass, both drawn from ONE
  buffer (`184564`, offsets 783656 / 933380 / 1492128) that **no draw with a colour target ever
  binds** (2-4 sharers, all depth-only). Post-VS: the 74862 patch sits at w 765-1614 (0.8-1.6 km
  away, just under the horizon), the 224580 mesh spans w -177..1497 with 4 % of its vertices
  behind the camera and ndc x out to -3287 - a track-wide far-field mesh. **This family is the
  distant ground / occluder, not the road under the car.** Its lack of a colour pass is by design.
- **`77784` is the player's own car**: capture 4's single big colour draw (fs 6385, vs 1510, no
  prepass, both 1080p targets), post-VS w 4.5-5.5 m, lower-left of the screen (ndc x -0.95..-0.68,
  y -0.36..-0.08), textures = the 1024^2 shadow map, a **7424x7424 D16** depth atlas, 256^2 R11G11B10
  (reflection), BC7 sets. That is why it appears in `colour[]` once per frame in some windows and
  not others: camera dependent, and never a road.
- Capture 4 also carries 11 HDR draws of 10k-50k indices (40932 / 23760 / 20220 / 19728 / 17010,
  fs ids 257k+ = late-compiled) totalling 203k - the 51924/58656/65610/101382/128700-class objects
  the census saw in 6 windows of run 258; cars / roadside props, not terrain.
- ⚠ analyze26 picks the MAIN prepass as the depth-only target with the most indices and the HDR
  target as the colour target with the most draws; in captures 1 and 4 that chose the 1024^2 shadow
  map and (capture 1) the 256^2 reflection face. The conclusions above do not depend on that choice
  (the BIG COLOUR list scans every colour target), but read those two headers with care.

So the captures close the loop: **without BDA import the emulator draws the far ground, the cars,
the props and the racing line, and no near terrain at all.** The near terrain (the 98304-index
patches) exists only where BDA import is on, and can only be studied there - from inside the
emulator.

## THE ROAD FLICKERS WITHOUT RENDERDOC TOO (3 Sep, user report after run 258) - and two pictures

The decisive question was answered, and not the way the run-258 verdict hoped: **"the road is not
drawn or shown closely most of the time of the race. It draws for a second sometimes but disappears
again immediately - cannot even take a screenshot."** So in the played configuration (BDA import
ACTIVE, 98304 patches issued twice a frame in EVERY race window of runs 256/257) the road is still
missing nearly all the time. Two consequences:
- **The 98304 draws are not "the road being drawn".** They are issued every frame while the road is
  visible for about a second per many seconds. Either they are the terrain patches drawn with the
  wrong CONTENT (see the pictures below - this is the reading now), or they are something else.
- **A per-window draw census cannot see this defect at all.** Runs 256-258 measured what is ISSUED;
  the defect is in what the issued draws PRODUCE. The instrument has to be the picture.

**Two screenshots the user had already taken (2 Sep 21:23, `%APPDATA%\shadPS4\screenshots\
CUSA24769_20260902_2123{12_485,16_582}_game_00000{0,1}.png`, Music Rally, ~0.25-0.30 miles in)
say what "the road is not drawn" looks like:**
- 21:23:16 - the road IS geometry: a curving ribbon of **flat-shaded, translucent rectangular
  plates**, each one a uniform tint graded orange near the car to white at the horizon, the sky
  showing THROUGH them at the far end; the verges are the same plates, blown out to white; trees,
  sky, clouds, HUD, the helicopter all correct. No asphalt texture anywhere - not even a wrong one.
- 21:23:12 - the whole frame washed to near white (the exposure flash), the same plates visible
  where the wash is thinner, orange chevron-like marks on them (the racing-line / arrow decals).
So the road is drawn as **untextured terrain patches**: the geometry pass runs, the SURFACE CONTENT
is missing. A uniform per-patch tint with a distance gradient is exactly what a streamed /
virtual-textured terrain shows when its tiles never arrive (the fallback tile, or the page table
pointing at nothing) - and "the road appears for a second and vanishes" is what tiles arriving and
being evicted again looks like. GT7's terrain feedback (which tiles the GPU wanted) is GPU->CPU
data, i.e. it lives on the BDA-import path this project has been circling for a week. That is the
hypothesis to test; it is not yet measured.

## RUN 259 (pre-declared) - the emulator photographs itself, and the indirect args are read

Build 3 Sep 18:55 (commit 0380589f), same binary installed as the launcher core.
`GT7_probe259.bat` = probe 257's environment + `GT_AUTOSHOT=2`, no RenderDoc.

- **`GT_AUTOSHOT=<s>`** (`vk_presenter.cpp`, `PrepareFrame`): every N seconds it queues a GAME-ONLY
  screenshot through the existing `VideoCore::RequestScreenshot` machinery (the guest's own output
  image, copied before FSR/PP), and logs `[autoshot] #n t=..s requested` on the SAME clock as
  `[fprof]` / `[bigidx]` (`GtFrameProfSeconds()`, new, exported from `vk_rasterizer.cpp` - it had to
  move OUT of the anonymous namespace; the first build failed to link). The `Saved screenshot: <png>`
  line that follows names the file. 2 s = one frame per profile window, ~90 PNGs for a 3-minute race,
  each readable as an image. This removes "cannot take a screenshot" from the loop entirely.
- **`[indargs]`** (`vk_rasterizer.cpp`, per window, only when colour-target indirect draws exist):
  `N calls, args read R (gpu-modified G, unmapped U), first-command index count zero Z max M sum S |
  count-buffer calls C: word zero Cz, gpu-modified Cg, sum Cs` - the same guest-memory read the GPU
  work journal already performs (`TryReadIndirectArgs`), so no new stall. If the terrain's colour
  pass were indirect and its arguments were sometimes filled and sometimes zero, this is where it
  would show. A `gpu-modified` stamp means the value read is STALE by the cache's own admission.

**How to read run 259:** lay each `[autoshot]` PNG beside the `[bigidx]` / `[indargs]` window of the
same `t=`; find the frames where the road is textured (the user says they exist, ~1 s at a time) and
diff their census against the frames where it is plates. If the census is identical in both, the
defect is downstream of every draw count - in the CONTENT the draws sample - and the next
instrument is a texture-side one (which images the 98304 draw's pipeline samples, and whether those
images were ever written this run).

## RUN 259 VERDICT (3 Sep 19:04-19:08) - 84 self-taken frames against the census

Log `GT7_work/logs/run259_autoshot.txt`, PNGs `%APPDATA%\shadPS4\screenshots\CUSA24769_20260903_19*_game_0000NN.png`
(NN = the `[autoshot] #NN` number; contact sheets were built with PIL at 320x180, 42 per sheet -
the whole run is readable in two images). BDA import ACTIVE, `-Net`, no RenderDoc. Race t=106-183
in the Music Rally (the user changed cameras during it).

**What the frames show.**
- Chase camera (most frames, e.g. #47 t=129): the road is a ribbon of flat plates, orange near
  the car grading to white far away, translucent at the horizon; the verges blown to white; a
  huge white glow where the car is; trees, sky, HUD correct. Same look as the 2 Sep shots.
- Other cameras (#40 t=114, #66-68 t=169-173): the ENTIRE ground is ONE flat pale grey surface
  (no plates), with the racing-line dashes and kerbs on it; in #66 the FAR road carries a dark
  asphalt look with parked cars along it while the near ground is flat grey. Cockpit (#59-65):
  interior correct, exterior washed white. These are the frames the user calls "the road appears
  for a second" - it is a different camera, not a different state: the ground is still untextured,
  merely a uniform colour instead of tinted plates.
- Exposure flashes: #36-39 (t=106-112, the start) and #52-58 (t=139-152) fully washed to white.
**So the near road surface is NEVER textured in this run.** The far road is (low-resolution
content resident, high-resolution never arriving - the streamed-texture signature).

**What the census says about the same windows.**
- **98304 is absent from the whole run** - not one window, against EVERY race window of runs
  256/257 in the identical environment. Whether 256/257 had a textured road is unknown (the user
  reported only "game closed" both times). The "per-run race" is therefore back on the table, and
  98304 is the thing that races. Do not build on "98304 = the road" or "98304 = not the road"
  until a run has both a picture and 98304 in the same window.
- The "textured-looking" windows (t=113/115, 168-174) have NO big direct draws except the menu
  pair and indirect draws only - they are the camera cuts; the chase windows have the 74862 /
  64164 / 53472 depth family and the 51924+77784(+85926) colour pair (the player's car and its
  parts). Neither pattern draws a textured near road.
- **`[indargs]`: every colour-target indirect draw in every window - 24 to 5971 per window,
  ~50k calls over the race - has a first-command index count that reads ZERO from guest memory,
  and every one is stamped gpu-modified. Zero unmapped, zero count-buffer calls.** The GPU writes
  the arguments into cached Vulkan buffers and nothing ever writes them back to the game's RAM;
  the CPU-visible copy is stale zeros for the entire session. The indirect draws themselves are
  fine (the GPU reads the real arguments), but it proves the general fact: **with readbacks_mode
  = 0 (Disabled, in every probe so far) no GPU-written buffer content reaches the CPU except
  through the BDA-import path.** A streamed terrain texture is driven by exactly such a read
  (the GPU's tile-feedback buffer), and the far-textured / near-untextured picture is what a
  feedback loop that never closes looks like.

**Why runs 185/186 did not settle this.** They used RELAXED mode, and Relaxed only downloads a
GPU-modified region ahead of a guest WRITE (`MemoryTracker::InvalidateRegion`); a guest READ of
GPU data still sees the stale copy. Only PRECISE mode read-protects GPU-modified pages
(`RegionManager::ChangeRegionState` -> `UpdateProtection<enable, true>`, `page_manager` read fault
-> `ReadMemory`). So the readback hunt never fed a buffer the game only reads, and it was judged on
the exposure wash anyway.

## RUN 260 (pre-declared) - PRECISE readbacks, photographed

`GT7_probe260.bat` = probe 259 + `run_gt7.ps1 -Readbacks 2` (new switch: writes
`GPU.readbacks_mode`; default 0 and written EVERY run so a 2 cannot linger into the next probe).
Expected: very low FPS (Precise faults on every CPU read of GPU-written pages). The question is
binary and the autoshot answers it regardless of frame rate: **does the near road ever get asphalt
on it with the CPU able to read GPU data?** Yes -> the road is a readback problem and the work is
making the feedback path cheap (direct-import / BDA for the feedback buffer, or a targeted
readback). No -> the content is lost GPU-side (the tile cache / indirection texture never written -
the `[imgarray]` class of loss already proven for the LUT and the track map) and the texture-side
instrument is next: which images the terrain pipeline samples and whether they were ever written.

## DISK CLEANUP (3 Sep, user: "delete unnecessary stuff that eats space from our work")

Deleted (~8 GB, all of it this lane's own scratch, nothing of the game or the code):
- the four run-258 RenderDoc captures (`%APPDATA%\shadPS4\captures\CUSA24769_capture*.rdc`, 5.6 GB) -
  analysed, reports in `rdc/out_persist/c258_*`, and of the no-BDA-import class that cannot answer
  anything about GPU->CPU data anyway. **There is no .rdc on disk any more.**
- `GT7_work/rdc/capture4.zip` (1.1 GB, 28 Aug, an exported capture with 6405 files) - referenced by
  no handoff.
- nine `%APPDATA%\shadPS4\cache_pre_*` / `cache_run112` directories (1.4 GB) - shader-cache
  snapshots from the A/B experiments of runs 112-193. The live `cache` (1.1 GB) is untouched.
Compressed, not deleted: **every `GT7_work/logs/*.txt` older than run 255 is now `.txt.gz`**
(235 files, 2504 MB -> 186 MB). The handoffs still name them as `logs/runNNN_x.txt`; read one with
`zcat` / `gzip -dk` (Git Bash) or 7-Zip. Runs 255-259 stay plain text.

## RUN 260 VERDICT (3 Sep 19:27) - PRECISE readbacks kill the guest before the race

Log `GT7_work/logs/run260_precise_crash.txt` (`GPU readbacksMode: 2` confirmed at boot, 38 autoshots,
last at t=81.6 s). At t~82 s, still in the menus / loading (the race started at t=106 in run 259):

    SignalHandler: GUEST WILD JUMP: execution at unmapped/NX 0x54b4aad2
    guest crash minidump WRITTEN: %APPDATA%\shadPS4\log\guest_crash.dmp

A wild jump is a corrupted function pointer / vtable: the game read bytes that were not its own.
Precise mode read-protects every GPU-modified page and services the read fault with `ReadMemory`,
which downloads the GPU's copy of that page OVER the guest's - and a page the CPU also writes
(game state next to a GPU-written buffer in the same 4 KiB) loses the CPU's newer bytes. Global
precise readbacks are therefore not a usable experiment on GT7; **the door to "let the CPU read
GPU data" has to be targeted, not global.** `-Readbacks` stays in run_gt7.ps1 (default 0, written
every run - config.json was left at 2 by this run and the next probe resets it).

## THE COURSE DATA SAYS THE ROAD IS STREAMED (3 Sep, from `F:\GT7_UNPACKED`, the Blender lane's unpack)

The user pointed at the unpacked game. `crs/` holds 40 circuits (`cNNN` real, `pNNN` other), and
**every circuit carries a `tex_stream` file - 100 MB (c024) to 2021 MB (c247)** - next to `pack`
(geometry, 1.2 GB on c024), `grass_tex.img`, `probe_gbuffers_*.img`, `tree.mdl`. A per-circuit
texture STREAM is the on-disk form of a virtual/streamed texture: tiles are read on demand, driven
by what the GPU reports it needs. That is the mechanism run 259's picture pointed at (far road
textured from resident low-resolution content, near road never) and it is now a fact about the
data rather than an inference from a render.
- The Music Rally the user has been racing is event `1000825` (`EventCode test_mission_musicrally`,
  `BGMPlaylistName music_rally`) on **`CourseLabel eifel_01`**. Which `crs/cNNN` folder that label
  maps to is NOT found yet - the label appears in `game_parameter/gp/*.json` and two `.adc` scripts,
  not in any course folder's `pack_s` / `envptr` / `maxsizes`. Not needed for the next step.
- The game reads everything through `/app0/contents/gt*.vol` containers, so file-open logging
  cannot show WHICH course data is read; the instrument has to be on the GPU side.
- ⚠ The Blender lane's headline (GT7_BLENDER.md 3.3: "there are no albedo textures") is about CAR
  materials, which are parametric. Courses are the opposite case - a 2 GB stream of surface tiles.

## RUN 261 (pre-declared) - `GT_IMG_CENSUS=1`: are the streamed tiles ever uploaded?

Build 3 Sep 19:36 (commit aaa29f3e), installed as the launcher core. `GT7_probe261.bat` = probe 259
+ `GT_IMG_CENSUS=1` (readbacks back to 0).
- `[imgnew] t=..s <addr>+<size> WxHxD mips N layers N <format>` once per image >= 1 MiB when the
  texture cache REGISTERS it (`TextureCache::RegisterImage` -> `Image::GtCensusRegistered`).
- `[imgup] t=..s N images touched (U uploads, C copies) | <addr>:WxHxDmM:<fmt>:upU/cpC ...` every
  2 s on the [fprof] clock: the images >= 256 KiB that received a CPU->GPU upload (`Image::Upload`,
  the guest-RAM-is-dirty path) or a buffer->image copy (`Image::CopyImageWithBuffer`, the GPU-side
  path) in the window, most-touched first, 14 shown.
Read beside the `[autoshot]` frames. **A large atlas that exists ([imgnew]) and is never in
[imgup] during the race = tiles never arrive** (the feedback loop never closes; the fix is a
targeted readback of the feedback buffer, or serving it through the BDA/direct-import path).
**An atlas refreshed every window under a flat road = the tiles arrive and the fault is on the
sampling side** (indirection texture / page table / the [imgarray] class of lost writes).

## RUN 261 VERDICT (3 Sep 20:04-20:10) - the streamed-texture machinery is THERE and is NEVER FED

Log `GT7_work/logs/run261_imgcensus.txt`; 179 autoshots (`..._20260903_20*_game_0000NN.png`), contact
sheets `run261_sheet_0..4.png` in the session scratchpad (rebuild with the PIL snippet: 42 per sheet
at 320x180, labelled `#N t=..s` from the `[autoshot]` lines). Race t=202-370. Readbacks 0.

**The picture, this run.** The ground under and around the car is **near-BLACK** in the chase camera
(run 259: pale grey/orange plates - same environment, same binary apart from the census), with the
yellow racing-line plates on it; in five frames (t=257-265, 294, 314) the whole ground is **solid
RED**; the exposure flashes are as before. Three different "ground colours" across two runs with no
code change in the render path = **the terrain shader is sampling UNINITIALISED memory**: whatever
happened to be in the VRAM the tile cache landed in (black / pale / R=1-red - the same
uninitialised-VRAM signature this project measured on the grading LUT and the red track map).

**What the census says.** 345 images >= 1 MiB were registered; the circuit's own set arrives at
t=185-198 while loading, and among it the streamed-texture machinery, by shape:

    0x109dd42800  128x128  L488  Bc7Srgb    8 MB   <- tile cache: albedo (sRGB)
    0x109d5a2800  128x128  L488  Bc7Unorm   8 MB   <- tile cache: normal / material
    0x109e4e2800  128x128  L488  Bc6HUfloat 8 MB   <- tile cache: HDR (height / emissive)
    0x109ecc2800  128x128  L488  R8Uint     8 MB   <- tile cache: id / mask
    0x10a9b89400  128x128  L1024 m8 R11G11B10  86 MB, 0x10a6a1c100 64x64 L2048 m7 (44 MB),
    0x1002800000  64x64 L1536, 0x1001800000 128x128 L256, 0x10a961c100 32x32 L1386 (probe / light arrays)
    0x10bd200000  1024x1024 L4 R32Sfloat 16 MB    <- the indirection / page table, plausibly
    0x2900000000  7424x7424 D16 105 MB, 0x2920000000 4096x4096 D16  <- shadow atlases (the 77784 car's)

Four parallel 488-layer arrays of 128x128 tiles in albedo/normal/HDR/id formats is a textbook
virtual-texture tile cache, and `tex_stream` on disk is what feeds it.

**And in 85 race windows (80 of them uncapped) NOT ONE of those images received a CPU->GPU upload
(`Image::Upload`) or a buffer->image copy (`Image::CopyImageWithBuffer`).** Zero. The uploads that
DO run every window (440-700 per window, ~10 per frame) are all **render targets being re-uploaded
from guest RAM** - `0x100a0b0000` (sub-views 480x270 / 720x540 of the 1920x2160 post-process
atlas), `0x100b460000` 256x256 D32S8, `0x100a0c8000` the 1080p HDR target: exactly the `[rtclobber]`
class (`GT_RT_NOCLOBBER=0` in every probe), which is a separate defect (the exposure wash suspect)
and is now measured at ~10 clobbers per frame.

**What is NOT yet excluded.** Two ways of filling an image were not counted by v1: an image->image
copy (`CopyImage` / `CopyMip` / `CopyRect`) and a shader writing it (storage image / render target,
`TextureCache::MarkGpuWritten`). BC7/BC6H arrays cannot be storage images, so for the four tile
caches the only remaining candidate is an image->image copy from a staging image. Run 262 counts
both and prints the arrays on their own uncapped `[imgarr]` line.

## RUN 262 (pre-declared) - census v2

Build 3 Sep 20:14 (commit ca20621f), launcher core updated. `GT7_probe262.bat` = probe 261.
`[imgup]` rows now read `upU/cpC/stS`; `[imgarr] t=..s arrays touched: <addr>:WxHLnmM:<fmt>:up/cp/st`
lists every image with >= 64 layers touched in the window, never capped.
- arrays still at 0/0/0 all race -> **the tiles never reach the GPU at all**; the fault is upstream
  (the game never asks: feedback never read, or never issues the copies because a GPU-side flag it
  polls reads zero) - the BDA-import / targeted-readback line.
- `cp` or `st` > 0 on the tile caches while the road stays black -> the tiles arrive and the fault is
  in how the terrain SAMPLES them (indirection table `0x10bd200000`, or the `[imgarray]` class of
  lost writes on the 1024-layer R11G11B10 array).

## RUN 262 VERDICT (3 Sep 20:17-20:23) - nothing feeds the tile caches, and the ground is never WRITTEN

Log `GT7_work/logs/run262_imgcensus2.txt` (Revision 720f5f7c = the census-v2 build), 103 autoshots,
contact sheets `run262_sheet_0..2.png` in the session scratchpad. The user went straight into the
race this time: race t=90-235.

**The tile caches: 0 uploads / 0 image->image copies / 0 shader writes, all race.** The four
128x128 L488 arrays (0x109dd42800 Bc7Srgb, 0x109d5a2800 Bc7, 0x109e4e2800 Bc6H, 0x109ecc2800 R8)
registered at t=68 and never appeared on a single `[imgarr]` line afterwards (101 of 104 windows
`arrays touched: none`). The R11G11B10 probe arrays DID take shader writes - once, at t=69-71 while
loading (0x10a6a1c100 L2048: 2951 stores, 0x10a9b89400 L1024: 1248) - so the instrument sees stores
when they happen. Every path by which content can reach an image has now been counted, and none is
taken: **the streamed road tiles never reach the GPU.**

The `copies` column that reads ~200 per race window is all `0x100a0b0000` (the 720x540 / 31x64
sub-views of the 1920x2160 post-process atlas: `up324/cp187` per window) plus `0x100b460000`
(256x256 D32S8, `up24-33`) - the `[rtclobber]` class, ~10 per frame, unchanged. The `[rtclobber]`
tag itself printed 0 lines because it only logs when `GT_RT_NOCLOBBER != 0`; the census sees it
anyway.

**The user's own description of what they see changed the question.** «the game keeps old frames
and tries to show new frames with the old ones still existing on screen ... the frames after a few
seconds get replaced by other old frames». Frames #66-#69 (t=170-176, `..._202136_612_game_000066`
.. `000069`) show it exactly: the SAME Golf GTI drawn a dozen times, each copy smaller and further
along the road (a fixed trackside camera the car is driving away from: the biggest copy is the
oldest). **The copies exist ONLY over the black ground - never over the sky, the trees or the
barriers, which are redrawn every frame.** A pixel that still shows last frame's car is a pixel
nothing wrote this frame. So:
- the black / pale-grey / red "ground" of runs 259-262 is not a terrain shader sampling garbage - it
  is the HDR scene target's UNWRITTEN content (whatever VRAM held when the image was created, never
  cleared, never overdrawn);
- the yellow racing-line plates and the cars are drawn ON it, which is why they look right;
- the far road looked "textured" because distant geometry IS drawn there (another mesh), not because
  a low-resolution tile arrived.
And it fits the earlier finding without contradiction: if the road is drawn by the colour indirect
draws whose arguments the CPU reads as zero (run 259), the tiles that would texture it are never
requested, because the pass that would request them never runs. One root, three symptoms
(missing road, missing tiles, ghost frames).

**HDR was OFF in every run** (user asked): `config.json` `hdr_allowed: false`, so
`sceVideoOutGetDeviceCapabilityInfo` reports no BT2020_PQ and the game runs SDR. Not a factor.
(`sceSystemServiceGetHdrToneMapLuminance` is a STUB returning OK with no value; harmless while SDR.)

Cosmetic census bug fixed for 263: `[imgup]` appended ` +more` once per HIDDEN row (27 times in a
busy window) instead of once.

## RUN 263 (pre-declared) - `[clears]` census + `GT_RT_FORCECLEAR=0x1005000000`

`GT7_probe263.bat` = probe 262 + `GT_RT_FORCECLEAR=0x1005000000` (the 1920x1080 R11G11B10 HDR scene
target, ~11k shader writes per window, the same address in runs 261 and 262).
- `[clears] t=..s colour attachments bound N (game clears M) | depth clears D | compute image
  clears C | rt(binds/clears/forced): <addr>:WxH:bB/cC/fF ...` every 2 s: does the game ever CLEAR
  its scene target (CMASK fast clear, FCE, or compute clear), and how many passes bind it per frame.
- `GT_RT_FORCECLEAR`: the FIRST render pass binding the listed target in each presented frame gets
  loadOp CLEAR to MAGENTA (1,0,1); `[forceclear]` logs the first four and then one in 1024. Frame =
  presenter flip counter (`GtNotePresentFrame` in `PrepareFrame`).
- **Magenta ground** -> proven: the ground is never written; the ghosts are uncleared memory; the
  road pass is missing (back to the indirect-args / GPU-decision line). Also a mitigation of the
  ghosting the user sees, though not a fix.
- **Ground still black/pale** -> the ground IS written that colour by a shader, and the ghosts come
  from a later stage (post-process history / the clobbered 0x100a0b0000 atlas).
- **Everything magenta / scene broken** -> the target is drawn in several passes and the first one
  is not the scene's start; use `GT_RT_FORCECLEAR=1` for all 1080p targets or pick another address
  from the `[clears]` table.

## RUN 263 VERDICT (3 Sep 20:37-20:47) - the scene is drawn ONLY in direct-draw mode; the indirect mode draws NOTHING

Log `GT7_work/logs/run263_forceclear.txt` (Revision 6848a2ef = the clears/forceclear build), 271
autoshots, contact sheets `run263_sheet_0..6.png` in the session scratchpad. User report: «the
image now does not keep older frames; picture turned purple on the textures that were not showing
on every frame; a lot of image trash flicker (huge black shapes); the game behind the image runs at
60 fps but the emulator only reads 15-20 fps».

**Ghosts gone, ground magenta: the ground is never written.** Proven. And it is much more than the
road: in most race frames the ENTIRE lower half and large parts of the sky are magenta; only the
trees, the cars, the yellow racing-line plates and the HUD are drawn on top. Frame #99 (t=209,
`..._204051_807_game_000099`) is magenta edge to edge except the HUD - not one tree, no sky.

**The game never clears its scene target.** `[clears]`: `0x1005000000` (1920x1080 R11G11B10, the
HDR scene, 6-12k shader writes per window) shows `c0` in every window but one (`c6` at t=228); its
~30 game clears per window are the 256x256 mip chain and the post-process sub-views, and compute
image clears are 0 all race. Depth clears ~130 per window (4-5 per frame). So the black / pale /
red ground of runs 259-262 and the receding car copies were the target's own stale content, exactly
as run 262 inferred. The forced clear ran 25-40 times per window = the 15-20 fps the user sees.

**THE CORRELATION THAT NAMES THE FAULT.** The `[indargs]` colour-indirect call count per window
swings between 3 and 5830, and the frames follow it inversely:

    t=209-211  indirect 3922-4154   bigidx colour = 164961x3 81543x3 only (the car)   -> frame #99: EVERYTHING magenta
    t=219      indirect 3           bigidx colour = 98304x81 + 8 more big draws         -> frames #103-106: sky, trees, GREY ground
    t=248-254  indirect 54-78       98304x5..27 + many 50-97k draws                    -> frames #118-125 (race restart): grey ground
    t=381-385  indirect 108-144                                                         -> frames #182-183: grey ground, some red
    t=100-207  indirect 1400-4154   98304 x60-111 (2-4 per frame) + the car            -> magenta ground, sky/trees drawn

Two rendering modes, then: a DIRECT one (race start, camera cuts) in which the scene appears - a
flat GREY ground, no textures, i.e. the same untextured look as the far road ever had - and a
GPU-DRIVEN one with thousands of indirect draws per window in which the scene is ABSENT. At the
peak (t=209) even the trees and the sky go with it, so the indirect path is carrying the whole
opaque world, not only terrain. The indirect draws render nothing. `98304 = 128*128*6` (a 128x128
quad grid, drawn 2-4 times per frame with a colour target) is the one big direct draw that survives
in indirect mode; it is not the road (frame #99 has no 98304 in its window and no ground, frame #43
has 98304x66 and a magenta ground).

The "huge black shapes" the user sees (frames #72, #93, #205, #207) are big dark polygons that come
and go - most likely the same indirect path drawing something with wrong arguments in some frames;
not measured yet.

**Frame rate.** [fprof] `busy=1938ms of 2000` - the GpuCommandProcessor thread is saturated,
20-33 submits per 2 s window = 10-16 presented fps while the game logic runs at 60. A separate
front; do not chase it before the scene draws.

## RUN 264 (pre-declared) - `GT_INDARGS_GPU=200`: the bytes the GPU reads

`GT7_probe264.bat` = probe 263 + `GT_INDARGS_GPU=200`. For up to 200 colour indirect draws per
window, `BufferCache::CaptureTableRegion` records a transfer copy of the argument bytes (first
<=8 commands) and the count-buffer word right before the draw, read back when the tick completes.
`[indgpu] t=..s GPU-side indirect args: requested R (refused U), captured C | first cmd index zero
Z | all cmds zero A | inst zero I | index max X sum S | count word: captured .. zero .. sum .. | CPU
zero but GPU non-zero D`, plus up to 3 `[indgpu] example` lines per window with cmd0 decoded.
- **Z ~ C (GPU reads zero too)** -> the GPU-side culling/compaction compute writes zero counts: the
  fault is upstream of the draw (a compute shader that culls everything - wrong HiZ/depth input,
  a miscompiled compaction, a COND_EXEC decision, or a feedback value it never receives). Next
  instrument: which dispatch writes the args buffer and what it reads.
- **Z ~ 0 with X in the tens of thousands (GPU has real counts) while the scene stays magenta** ->
  the arguments are fine and the DRAW fails: vertex/instance fetch for indirect (the comment in
  DrawIndirect says SGPR UD indices and fetch-shader results are ignored - a per-draw constant
  indexed by draw id would read draw 0's data for every command), or the count-buffer path
  (`drawIndexedIndirectCount` with a count word that reads 0).
- `refused` high -> the args buffer is not a registered buffer at capture time; move the capture
  after ObtainBuffer (it already is) or capture through the obtained buffer directly.

## RUN 264 VERDICT (3 Sep 20:58-21:04, device lost at t~282) - the indirect draws are NOT the environment

Log `GT7_work/logs/run264_indgpu_crash.txt` (Revision 4017a9a0 = HEAD at build time; the build
carries the GT_INDARGS_GPU patch, 79 `[indgpu]` windows prove it). Crashed mid-race: `Device lost
during submit` at t~282 with the `VK_EXT_device_fault` journal dump. Device loss has a long history
in this project (run258, 245, 244, ...); the capture's 200 renderpass breaks per window are a
suspect but not proven - the same failure exists without it.

**What the GPU reads as indirect arguments (200 samples per window, 79 windows, 0 refused):**

    first cmd index count zero  131-139 of 200   (65-70 %)  - and "all cmds zero" is the same number
    non-zero                      61-69 of 200   index max 1260-1464, sum 18-40k per 200 draws
    instance count zero            0
    count-buffer draws             0             (no drawIndirectCount in this game)
    examples: count=132 inst=180 | count=1179 inst=34 | count=978 inst=33 firstInst=33
    CPU read of the same word:     always 0     -> "CPU zero but GPU non-zero" = every non-zero one

So the GPU-driven path draws SMALL INSTANCED MESHES (a 132-index quad set x180, 1179-index props
x34 - vegetation / props / crowd), two thirds of them culled to nothing by the GPU compaction,
which is normal for a culled batch list. The largest indirect draw in 15 800 samples is 1464
indices. **Nothing here is a terrain patch or a sky dome.** The indirect path is not what fails
to draw the environment; it is simply the only thing left drawing when the environment is gone.

**Nor is anything dropped on the way to Vulkan.** `[fprof]` in every race window: `drops: tess 0
fmask 0 primnone 0 dscopy 0 pipeline 0 bind 0` (fce/resolve are the legitimate once-per-frame
pair) and **`condexec: seen 0`** - GT7 never uses COND_EXEC, so the parser takes no GPU-produced
decision. `bigdraw colour` stays non-zero in the magenta windows (the 98304 grid and the car).

**Therefore: the CPU stops issuing the environment draws.** In steady state the big direct draws
of terrain/buildings (50-97k indices, seen at t=213-228 and 244-262 while the ground was grey) are
absent from the command stream altogether, and they reappear on every camera cut and at the race
restart, for a second or two. That is the exact signature of CPU-side occlusion culling driven by
a GPU-written visibility/query result: on a cut there is no history, so everything is drawn; then
the game reads the result - and with readbacks OFF every GPU-written word the CPU reads is a stale
zero, "nothing visible", so it draws nothing. Trees survive because they go through the GPU-side
instanced path. Consistent with everything since run 259 (indirect args read zero on the CPU,
tile requests never issued, the whole world absent at t=209).

## RUN 265 (pre-declared) - `GT_READBACKS_ONRACE=2`: PRECISE readbacks switched on inside the race

`GT7_probe265.bat` = probe 263 + `GT_READBACKS_ONRACE=2` (GT_INDARGS_GPU off - device-lost
suspect and its question is answered). The process starts with readbacks 0; `GtFrameProf::Flush`
flips `EmulatorSettings.SetReadbacksMode(2)` (both the global and the game-specific layer) the first
time three consecutive windows carry >500 colour indirect draws, and logs `[readbacks] t=..s
switched`. Precise mode read-protects GPU-modified pages and services the read fault with
`ReadMemory(addr, 8)` -> a 512 KB window download of the GPU-modified ranges. Run 260 died in the
menus at t=82 s with this mode from process start; whether it can serve the RACE is the question.
- **Ground turns grey (drawn) and stays so, sky/trees/buildings present in every frame after the
  switch** -> the door is found: the environment is gated on a GPU->CPU readback. Then find WHICH
  word (the fault histogram `GT_FAULT_HIST=1` is on: `[faulthist]` read buckets name the pages)
  and serve that region cheaply instead of global precise mode. If the tile caches also start
  taking uploads (`[imgarr]`), the road textures follow for free.
- **Guest wild jump again** -> precise mode's page-granular download clobbers CPU data the game
  wrote after the GPU pass (mixed-ownership pages). Next: log the faulting read addresses and the
  downloaded ranges around the crash time; serve only the tracked GPU ranges of the faulting page.
- **No change** -> the CPU decision does not come from memory the GPU wrote through a tracked
  binding (BDA/direct-import writes are invisible to the tracker) - move to `GT_FAULT_WIDE` /
  the BDA-import journal.

## RUN 265 VERDICT (3 Sep 21:12, twice, assert at t=49 s) - the run-time switch itself was unsafe

Log `GT7_work/logs/run265_readbacks_onrace_watchers.txt` (Revision 649544b6 = HEAD at build time,
the build carries the GT_READBACKS_ONRACE patch: the `[readbacks]` line proves it). The user ran it
twice; both died "when trying to enter the race". The log ends 13 lines after:

    [readbacks] t=49s switched GPU readbacks mode 0 -> 2 (race steady state detected: 2805 colour indirect draws this window)
    ...
    page_manager.cpp:193 AddDelta: Assertion Failed!  Not enough watchers

Line 193 is the READ-watcher branch (`num_read_watchers : 1`). Deterministic, and entirely ours:
- In Disabled mode `RegionManager::ChangeRegionState<GPU, true>` sets the `gpu` bits and never calls
  `UpdateProtection<_, true>` (that call is gated on `== Precise`), so `readable` stays all-ones for
  every page the GPU has already written - it is only kept equal to `~gpu` while Precise is on.
- After the flip, the first `ForEachModifiedRange<GPU, clear>` (gated on `!= Disabled`) runs
  `UpdateProtection<false, true>` whose mask is `~gpu ^ readable`. With `readable` stale that mask
  covers the pages that were just cleared AND every still-GPU-modified page that was never
  protected, all with track=false -> `AddDelta<-1, true>` on a page holding 0 read watchers.
- The switch fired at t=49 (windows t=45/47/49: 1353 / 2201 / 2805 colour indirect draws) - the
  pre-race sequence is already in the GPU-driven mode, so the trigger is fine; the mechanics of the
  flip were not. The 3-window rule did what it was asked.

Nothing about the readback QUESTION was answered: the guest never reached a frame with Precise
readbacks in effect. (Note that Relaxed mode has the same shape of hazard on a run-time flip -
it too only maintains `readable` from the clear side.)

## RUN 266 (pre-declared) - same probe, the switch made safe: resync the read protection FIRST

Build 21:18 (`GT7_probe266.bat` = probe 265, no env change). `GtFrameProf::Flush` now only ARMS
the switch (`readbacks_pending_mode`); the rasterizer performs it right after Flush on the same
thread: `BufferCache::ResyncReadProtection()` -> `MemoryTracker::ResyncReadProtection()` walks the
whole manager pool (the DecayHotPins pattern) and, under each manager's lock, calls
`RegionManager::ResyncReadProtection()` = `UpdateProtection<true, true>()` when `gpu.Any()`. At
that moment `readable` is all-ones, so the mask is exactly the gpu bits and +1 is right for every
page; afterwards `readable == ~gpu` and the later clears remove exactly the watchers that were
added. Only THEN `SetReadbacksMode(2)` (global + game layer). `[readbacks] t=..s switched GPU
readbacks mode 0 -> 2 after read-protecting the GPU-modified pages of N regions`.
The verdict tree is run 265's, unchanged:
- **Ground turns grey (drawn) and stays so after the switch** -> the environment is gated on a
  GPU->CPU readback; find WHICH word (`[faulthist]` read buckets) and serve it cheaply.
- **Guest wild jump / crash later in the race** -> precise mode's page-granular download clobbers
  CPU data on mixed-ownership pages (run 260's failure, now inside the race) - log the faulting read
  addresses and the downloaded ranges around the crash.
- **No change** -> the CPU decision is not fed through a tracked binding (BDA/direct-import writes
  are invisible to the tracker) - move to `GT_FAULT_WIDE` / the BDA-import journal.
- **"Not enough watchers" again** -> a second path maintains `readable` that the resync does not
  cover; the log line's region count says whether the resync ran at all.

## RUN 266 VERDICT (3 Sep 21:20, assert at t=60 s) - the resync itself asked for a WRITE-ONLY page

Log `GT7_work/logs/run266_resync_writeonly.txt` (Revision 2a803a48 = HEAD at build time; the
build carries the resync: the assert is inside it). No `[readbacks]` line at all - the switch was
armed at t=60 (windows 56/58/60 over 500 colour indirect draws) and the process died inside
`ResyncReadProtection` before the log line that followed it:

    page_manager.cpp:332 Protect: Assertion Failed!
    Attempted to protect region as write-only which is not a valid permission

Mechanism, and it is the mirror image of run 265's: the write watchers follow `cpu` (a CPU-dirty
page is writeable - no watcher), the read watchers follow `gpu`. A page with **cpu=1 AND gpu=1**
therefore gets `Perms() = Write` once it is read-protected, and Windows has no write-only page.
In PRECISE mode the two bits never coexist: `InvalidateRegion` sees a GPU-modified page and
downloads it BEFORE it lets the CPU dirty it. In DISABLED mode that download is skipped, so after
50 s of racing thousands of pages carry both bits - and the resync walked straight into them.

Nothing about the readback question was answered (no frame ran with Precise on). Two runs, two
different asserts, both in the plumbing of a run-time mode flip that the emulator was never
designed to do - the mode is read at every use, but the STATE (readable / gpu / cpu bits) was
built under the old mode's invariants.

## RUN 267 (pre-declared) - the CPU copy wins on a page that is dirty on both sides

Build 21:24 (`GT7_probe267.bat` = probe 266, no env change). `RegionManager::ResyncReadProtection`
now computes `both = gpu & cpu`, counts those pages, and clears them out of `gpu` before
`UpdateProtection<true, true>()`: the CPU copy is what the next bind uploads anyway, so dropping
the recorded GPU write is exactly what Disabled mode had been doing for that page all along. Then
the remaining gpu pages (cpu clean = write-watched) get their read watcher -> `Perms() = None`,
valid. Two `[readbacks]` lines now: one BEFORE the resync (run 266 left no trace of having
started) and one after, `... read-protecting the GPU-modified pages of N regions (M CPU-dirty
pages kept the CPU copy and dropped their GPU-modified bit)`.
Verdict tree unchanged from run 265 (ground grey = door found / wild jump = mixed-page clobber /
no change = untracked writes / a third assert = another invariant of the flip).

## RUN 267 VERDICT (3 Sep 21:26, assert at t=61 s) - a RACE between the resync and a guest write fault

Log `GT7_work/logs/run267_resync_race.txt` (Revision 077b4890 = HEAD at build time; the build has
the CPU-wins patch - the pre-resync `[readbacks]` line proves it). The first `[readbacks]` line
printed (`t=61s race steady state detected ... resyncing read protection, then switching to mode
2`), the second never did, and 9 log lines later:

    (Job#0) page_manager.cpp:332 Protect: Assertion Failed!  write-only ...

**Job#0 is a GUEST thread**, not the GPU thread. So the resync itself passed its own hazard; what
died was a CPU write fault that landed while the walk was still in progress and the mode still
Disabled: `InvalidateRegion` took the Disabled path (no download - that gate is `!= Disabled`),
`ChangeRegionState<CPU, true>` dropped the page's WRITE watcher, and the page - which the walk had
just given a READ watcher - was left write-only. Ordering the two steps the other way round has
the mirror hazard (run 265's), because every one of these paths assumes `readable` already equals
the target and applies one delta sign to the whole mask.

Three runs, three asserts, one defect: **the read protection is maintained by one-directional
deltas that assume it already matches the GPU-modified bits**, which is only true when Precise has
been on since process start. A run-time switch cannot be made safe by ORDERING under that design.

## RUN 268 (pre-declared) - self-healing read protection; the mode flips FIRST

Build 21:31 (`GT7_probe268.bat` = probe 267, no env change). `RegionManager::UpdateProtection<_,
true>` now derives the target from the bits every time - **a page is unreadable iff gpu && !cpu**
(the CPU copy is what the next bind uploads, so a CPU-dirty page is never read-protected) - and
hands the tracker two passes: `add = readable & ~want` (+1) and `rem = want & ~readable` (-1). The
template `track` is ignored for reads. In steady Precise operation one of the two sets is always
empty, so nothing changes there. `ChangeRegionState<CPU, _>` and the upload walk refresh the read
side too, in the order that never passes through write-only (dirty: read watcher off, THEN write
watcher off; clean: write watcher on, THEN read watcher on). Read-side calls are gated on
`== Precise` everywhere now (the upload-walk one was `!= Disabled`: in Relaxed mode nothing ever
ADDS a read watcher, so that call could only have removed watchers that were never there).
The rasterizer flips the mode first and then runs the eager pass (still needed: a region's
GPU-written pages would otherwise stay unprotected until its next GPU-side change, and a stale
CPU read of them would not fault). Verdict tree unchanged from run 265.

## RUN 268 VERDICT (3 Sep 21:33-21:38, no crash) - THE DOOR IS FOUND: with readbacks alive the environment is DRAWN

Log `GT7_work/logs/run268_readbacks_live.txt` (Revision 5095b17f = HEAD at build time; the build
carries the self-healing read protection - the two `[readbacks]` lines prove it), 104 autoshots,
contact sheets `run268_sheet_0..2.png` in the session scratchpad. User: «game closed. the game
runs much slower, the image got dramatically worse by whitewash». This run happened to be a
fresh-profile flow (display setup, controller selection, assist presets, then Music Rally), so the
switch fired at **t=55 s in the menus** (windows 51/53/55 over 500 colour indirect draws: the
intro sequences are GPU-driven too):

    [readbacks] t=55s race steady state detected (3862 colour indirect draws in the last window) - resyncing ...
    [readbacks] t=55s switched GPU readbacks mode 0 -> 2; eager pass read-protected the GPU-modified pages of 153 regions
                (169 CPU-dirty pages kept the CPU copy and dropped their GPU-modified bit)

and the process ran another 200 s of menus + a full Music Rally race with Precise on and did NOT
crash - the self-healing form ended the assert series (run 260 died at t=82 s with Precise from
process start; whether that was the same class is now moot).

**1. The CPU reads REAL indirect arguments now.** `[indargs]` before the switch: `first-command
index count zero == calls` in every window (100 % zero since run 259). After: `3570 calls ...
index count zero 2100 max 1464 sum 939690`, `1837 calls ... zero 1194 ... sum 384486` - the same
~60 % zero / 40 % small-instanced distribution the GPU-side capture measured in run 264, seen
from the CPU. `gpu-modified 0` on every line: the download cleared the tracker bits, i.e. the
data really was fetched.

**2. The big environment draws are back in EVERY window.** `[bigidx] colour` in the GPU-driven
windows used to hold only the car (164961/81543) and the 98304 grid. After the switch: t=175
`51924x8 77784x8 96120x6 90180x4 ...`, t=181 `51924x18 77784x18 ... +26 other`, t=199
`51924x21 77784x21 ...`, t=239 `77784x42 98304x42 51924x21 52764x13 ...`. And the colour
indirect count now swings freely (8 at t=249, 114 at t=189, 3792 at t=173) instead of sitting at
3000-5800 - the game's own culling has a live answer to work with.

**3. The screenshots show the world.** Frames #83 (t=213), #91 (t=230), #93 (t=234), #100
(t=248): grey asphalt with lane markings, guardrails, trees, mountains, sky - the first drawn
ground since run 259. Magenta (the forced clear = unwritten) is reduced to the sky in a few
frames. The user's «whitewash» is real too: most race frames are blown out to white around a
bloomed car (#72-#79, #84-#90), with the HUD intact - an EXPOSURE failure, not missing geometry
(#100 shows the same scene correctly exposed, dark).

**4. The two costs, measured.**
- **Faults.** Before the switch 100-1500 faults per 2 s window, all writes. After: **20 000 -
  61 000 WRITE faults per window** plus 200-520 READ faults (`[faulthist] 60835 faults (60797 wr,
  38 rd)` right at the switch, then ~30-50k/window). In Precise a CPU write to a GPU-modified
  page downloads the page first (`InvalidateRegion` -> flush), so each of those is a synchronous
  512 KB-window download on a guest thread: that is the «much slower». Top write buckets are the
  0x2xxxxxxxxx guest heap (0x204700000, 0x201700000, 0x201d00000, 0x203500000, ...) and
  0x101bb00000 - mixed-ownership pages ping-ponging between CPU and GPU every frame.
- **The read door itself is small**: 200-500 read faults per window, and **one bucket carries
  80 % of them: `0xe40e500000-0xe40e600000` (1716 of ~2000 aggregated), then a cluster at
  0x202a00000-0x203600000 and 0x204000000-0x204500000.** That is the word (or words) the game's
  culling waits for - the cheap targeted serve the plan called for lives there.
- Submits per window 10-32 (5-16 fps presented) - the same range as before the switch in the
  race; `busy` 1300-2750 ms of 2000 (GpuCommandProcessor still saturated). The extra time is on
  the GUEST threads (the write-flush downloads), which the [fprof] line cannot see.

**5. The tile caches are still not fed**: `[imgarr]` shows `none` in every race window - the
road is drawn but untextured (flat grey asphalt with painted lines). Separate follow-up, same
family: the streaming decision may sit behind another read.

**Not answered here:** why the exposure blows out. Two candidates, opposite fixes: (a) the
exposure/luminance readback is now served but with WRONG bytes (a partial or stale download) -
the read trace will show the value; (b) the scene is now drawn and the exposure math is right but
some other input (an HDR/luminance histogram written through an untracked BDA/direct-import path)
is still stale. Frame #100 (correct exposure) says it oscillates rather than being pinned.

## RUN 269 (pre-declared) - `GT_READ_TRACE=6`: what the guest reads back, and what it costs

Build 21:46 (`GT7_probe269.bat` = probe 268 + `GT_READ_TRACE=6`). `BufferCache::ReadMemory` (both
the read-fault path and the write-flush path land there) now keeps a per-2 s census and logs:
- `[readtrace] t=..s summary: read faults N (X ms total, max Y ms, Z downloaded nothing) |
  write-flush faults M (...)` - `downloaded nothing` = the page was still GPU-modified after the
  download, i.e. the tracker said GPU but `gpu_modified_ranges` had no range there (the guest then
  reads whatever it had; a refault storm would show up here too).
- up to 6 `[readtrace] t=..s read fault <addr> (+off into buffer <base> size <n>) window <w>+<len>
  <ms> downloaded | u32 .. .. .. .. | f32 .. .. .. ..` - the 16 bytes at the faulting address AFTER
  the download, i.e. exactly what the guest is about to read.
Verdicts:
- `0xe40e500000` reads come back as small integers / bitmasks -> visibility results; as floats in
  a sane range -> exposure/luminance. Either way the address + buffer base name the producer, and
  the next step is to serve THAT buffer (download it once per frame after the producing dispatch,
  or read-protect only its pages) instead of global Precise.
- summary `write-flush ms` close to the 2 s window -> the write faults ARE the slowdown; the fix is
  to stop downloading on CPU writes for pages the CPU is about to overwrite anyway (Relaxed-style
  for writes, Precise for reads).
- many `downloaded nothing` -> the tracker and the interval set disagree; the guest reads stale
  data there and the read protection is refaulting for nothing.

## RUN 269 VERDICT (3 Sep 21:47-21:50, no crash) - the READS are the slowdown, and this is what the CPU reads

Log `GT7_work/logs/run269_readtrace.txt` (Revision 6d6907cc = HEAD at build time; the build has
GT_READ_TRACE - the summaries prove it), 65 autoshots (`run269_sheet_0..1.png`). Same fresh-profile
flow as run 268 (display setup -> Music Rally), switch at t=60 s (150 regions, 28 dual pages), no
crash. Frames: whitewash throughout the race, environment drawn in several (#43 t=101 with the
GoPro banner and kerbs, #49, #52-53, #57-58 trees and road).

**1. The write faults were a red herring.** `[readtrace] summary` per 2 s window, whole race:
`write-flush faults 6-177 (5-100 ms)`. Run 268's 20-60k write faults were cheap invalidations of
pages the GPU had NOT modified (no download); the downloads-before-CPU-write are two orders of
magnitude fewer. **The read faults are the cost: 200-530 per window, 300-800 ms of synchronous
download per 2 s window, max 30-175 ms for a single fault, 0 "downloaded nothing".** That is
15-40 % of the game's render thread spent inside our fault handler - the «much slower».

**2. What the CPU reads back - it is a GPU-driven scene structure, not one word.** Every logged
read (all `downloaded`, so the bytes are the freshly copied GPU data):
- into the **97 MB heap buffer `0x202800000`** (size 0x60a0000, reads spread over 0x202a..0x2045 =
  27 MB): `00380010 000002c1 20077fac` / `00400010 00000e9d 20051fac` = **resource descriptors**
  (V#/T# word patterns), `39d3b42f 390e128b bb8df9df 0` = `(0.0004, 0.00014, -0.0043, 0)` and
  `3f800000 0 b2b40000 0` = **float vectors / transform rows**, `04409f00 00080002 00010000
  20027204` = more descriptors;
- `0x1014de8c00/8d00/8f00`: `(0x21,1,1,0)`, `(0x0,1,1,0)`, `(0x96,1,1,0)`, `(0x500,1,1,0)` =
  **counts in (x,1,1) form - dispatch-indirect args / visible-object counters**, read every frame;
- `0x1000fffd80`: `0x164, 0x19a, 0x1b6, 0x1d4` monotonically increasing = a **GPU frame/fence
  counter**; `0x10201d2c00`: `7,7,7,1`; `0x10200002a0`: `1,0,0,0` = flags;
- the **`0xe40e5xxxxx` 16 KB buffers** (the range that took 80 % of run 268's reads, 872 of ~2100
  here): `0e5b7bc0 000000e4 0e5b7c00 000000e4`, `1ef605a0 000000f4`, `11bca508 000000e4` = **64-bit
  POINTERS into 0xe4.../0xf4...** - GPU-written linked-list / node structures the CPU walks;
- `0xec03cc8004`: f32 **308.3** twice (`439a2c04`) and `0xec03cc8090`: a pointer `0x0ff6e760 e4`.
So the game's culling/scene update reads descriptors, counters, transforms and pointer chains the
GPU produced - the "occlusion result" is a whole GPU-driven scene graph. No single word to serve.
The exposure value was not identified (308.3 at 0xec03cc8004 is the only lone float; unproven).

**3. Why each fault is so expensive.** A read fault = `SendCommand<true>` to the GPU thread (which
is 65-100 % busy - queueing latency) + a 512 KB-window download restricted to the tracker's
GPU-modified ranges + a wait for the GPU. 300 faults x ~1.2 ms mean, with the reads into the heap
buffer scattered over 27 MB so each window serves few of them. Two levers, to be MEASURED before
choosing: a bigger window (fewer round trips, more bytes each) and/or an async prefetch of the
windows that faulted last frame at submit time (no guest-side round trip at all; hazard: the
async write-back's UnmarkRegionAsGpuModified would also clear a NEWER GPU write on the same page,
so it must only unmark what it copied).

## RUN 270 (pre-declared) - read-trace v2 + `GT_READ_WINDOW=2048`

Build 21:55 (`GT7_probe270.bat` = probe 269 + `GT_READ_WINDOW=2048`). `DownloadBufferMemory` now
returns the bytes it copied; the summary gains `guest wall` (fault wall time measured on the
guest thread, beside the GPU-thread download time - the difference is the queue wait behind the
GpuCommandProcessor), `distinct windows`, `MB copied`, and the window size. The window is 2 MB in
this run (upstream's 512 KB otherwise; `GT_READ_WINDOW=<KB>`).
- read faults per window fall ~4x and total ms fall -> the window is the lever; the next step is
  a per-buffer window (whole heap buffer's GPU-modified set on one fault) or the prefetch.
- faults fall but ms do not (MB copied balloons) -> the copy itself is the cost; prefetch instead.
- `guest wall` >> `download` -> the queue wait dominates: only the prefetch (or a dedicated
  download queue) can fix it; window size is irrelevant.

## RUN 270 VERDICT (3 Sep 21:57-22:00, no crash) - the window is NOT the lever: ~13 windows re-fault EVERY frame

Log `GT7_work/logs/run270_readwindow2048.txt` (Revision dc7766dc = HEAD at build time; the
2048 KB window in the summaries proves the build has trace v2), 65 autoshots
(`run270_sheet_0..1.png`). Same fresh-profile flow, switch at t=51 s (152 regions, 34 dual pages),
no crash. User: «the road was built ... the image is mostly white ... but the road showed
correctly on the last screenshots». Confirmed: #45-#53 and #58-#60 (t=102-142) show the
motorway - asphalt with lane markings, guardrails, kerbs, trees - under a white bloom centred on
the screen; #50 and #58 are nearly correctly exposed.

**1. The fault count did not move.** 250-520 read faults per 2 s window with a 2 MB window,
against 200-530 with 512 KB in run 269. Over the whole race only **12-25 DISTINCT windows** per
2 s window. So a frame's reads are not scattered islands a wider window would merge: they are the
SAME windows every frame - the GPU rewrites them each frame, each rewrite re-arms the read
protection, and the CPU faults on them again. At ~25 fps, 13-20 windows x 25 frames = the
300-500 faults measured. Census of the 312 logged faults: `0x1014ddc000` (64 KB, the (N,1,1)
counters) 55, `0x1000ffc000` (the frame counter + `(0,1,1,0)` at +0x3f00; a 233 MB buffer) 59,
`0xec03cc8000` (16 KB; a pointer at +0x90 read every frame, f32 309.4/309.5 at +0x34/+0x64) 38,
`0x1020000000` 20, then ~12 different 16 KB `0xe40e5xxxxx`/`0xf429xxxxxx` pointer buffers and six
2 MB windows of the heap buffer `0x20289c000` (0x2032/0x2034/0x2036/0x203c/0x2040/0x2044).

**2. The bytes ballooned, the time did not fall.** 30-130 MB copied per 2 s (2 MB windows,
restricted to the GPU-modified ranges inside them), download time 200-660 ms per 2 s (run 269:
300-800), max per fault 6-30 ms in the race (with 80-220 ms spikes at t=61-63 and t=123-129 that
coincide with `pipe` compile stalls in [fprof]: 3.8 s and 9.1 s of pipeline creation in two
windows - unrelated to readbacks). `guest wall` is only **1.1-1.3x download** (e.g. 663.8 ms
download / 826.5 ms guest wall at t=71), so the queue wait behind the GpuCommandProcessor is
15-30 % of the cost; the rest is the synchronous download itself, i.e. `scheduler.Finish()` - a
full GPU drain per fault. **Verdict per the run-270 tree: neither "faults fall 4x" nor "queue
wait dominates" - the copy (the drain) IS the cost, and the window cannot reduce the count.**
Frame rate unchanged: 13-35 submits per 2 s window (6-17 fps), `busy` 1250-1750 ms of 2000.

**3. What follows.** Prefetch: record the download of every window that faulted in the last few
frames into the frame's OWN command buffer right before it is flushed (`Rasterizer::Flush`), write
it back when that tick completes (DeferOperation), and have the fault path pop completed
deferred ops first - a served window then costs one SendCommand round trip and no drain. The
guest waits for the same GPU work anyway (it reads GPU results) before it asks.

## RUN 271 (pre-declared) - `GT_READ_PREFETCH=12`: serve the readback windows before the guest asks

Build 22:10 (`GT7_probe271.bat` = probe 269 + `GT_READ_PREFETCH=12`; the window is back to
512 KB so 13-20 windows fit a 12 MB budget of window bytes - the 32 MB `download_buffer` ring
must not be exhausted or `DownloadBufferMemory` falls to a temporary buffer + synchronous drain
on the GPU thread, `[tempdl]`).
- `BufferCache::PrefetchReadbacks()` (called from `Rasterizer::Flush` before `scheduler.Flush`):
  for every window the guest faulted on within the last 8 flushes, `DownloadBufferMemory<true>`
  into the current command buffer; entries remember the tick.
- `ReadMemory`'s lambda first `scheduler.PopPendingOperations()` (lands completed write-backs;
  a covered window then downloads nothing and returns without `Finish`), records the window, and
  if the download copied nothing while the page is still GPU-modified and a prefetch of that
  window is in flight, `scheduler.Wait(tick)` + pop instead of letting the guest refault in a loop
  (the in-flight prefetch already subtracted the range from `gpu_modified_ranges`).
- The async write-back (also used by the buffer GC) now skips, per copied range, anything the
  GPU re-marked since the copy was recorded (`gpu_modified_ranges.Intersects`: stale bytes, and
  unmarking would drop the read protection over the newer write for good) and anything the CPU
  modified since (its write fault downloaded first, then marked it), unmarks only what it wrote,
  and does the whole-window unmark only when nothing in the window was skipped or re-marked.
- New lines: `[prefetch] t=..s N windows recorded (X MB), T tracked, S skipped by the 12 MB
  budget, E evicted, U unregistered | write-back: W ranges written, ST skipped stale, C skipped
  CPU-modified`; the `[readtrace] summary` ends with `prefetch: N read faults served, M waited on
  an in-flight prefetch`.
Verdicts:
- `served` close to the read-fault count and `download ms` collapses (tens of ms per 2 s) ->
  the drain is gone; judge the fps by submits per window, then attack the whitewash.
- faults still download (`served` small) -> the guest reads BEFORE the frame's tick completes
  (results read mid-frame, or the pop never runs in time): move the prefetch earlier (after the
  producing dispatch) or drive the pop from the fault path with the tick wait.
- `waited` large -> the guest reads results of the SAME frame right after submit: the wait is
  then the game's own latency, not ours; compare `guest wall` with before.
- `skipped stale` large -> the windows are rewritten faster than one frame; the write-back must
  be reissued per producing dispatch, not per flush.
- `[tempdl]` lines -> the ring is exhausted; lower `GT_READ_PREFETCH` or the window.

## RUN 271 VERDICT (3 Sep 22:14-22:17, HUNG at t=137 s) - the prefetch's write-back read a recycled staging region

Log `GT7_work/logs/run271_prefetch_hang.txt` (Revision e45d556d = HEAD at build time; the
`[prefetch]` lines prove the build), stuck stacks `logs/stuckstack_20260903_221659.txt` (the user
ran stuckstack while it hung, then closed the game). Switch at t=102 s (152 regions), race from
~t=110, hang at t=137.

**1. What the stacks say.** `shadPS4:GpuCommandProcessor` 0 ms CPU in
`BufferCache::ReadMemory::lambda -> DownloadBufferMemory<0> -> Scheduler::Finish -> Scheduler::Wait
-> MasterSemaphore::Wait -> NtGdiDdDDIWaitForSynchronizationObjectFromCpu` - a read fault's
synchronous download waiting for a GPU that never finished. `Job#0` 100 % in guest code
(`cd71512/cd71515`, a spin on a word the GPU never wrote), everything else waiting. No assert,
no device loss, no TDR. The `[readtrace]` summaries ran to t=136 with the prefetch alive
(`23-47 read faults served, 0-4 waited` per window - only ~5 % of the 400-520 faults, see 3).

**2. The last thing the GPU thread recorded before the block:**

    [readtrace] t=136.1s read fault 0x202b16f80 (+0x316f80 into buffer 0x202800000 ...) window 0x202b00000+0x80000 1.81 ms downloaded
    RecordGpuWork: HUGE DrawIndexedIndirect on fs_0x000000004bb6fd35: 919838150 vertices x 15 instances x 1 command(s)

An indirect draw with GARBAGE arguments (919 million vertices), **the first `HUGE Draw` line in
runs 268-271** (0 / 0 / 0 / 1). A GPU chewing 13.8 billion fragment invocations is a hang that
never TDRs, and the fence the fault handler waits on is behind it. `[cshang]` counts are the same
as the previous runs (32 vs 34-53), so the 0x18256c0 guard is not involved.

**3. Where the garbage came from - a lifetime bug in the async download path.**
`DownloadBufferMemory<true>` stages its copy in `download_buffer`, a 32 MB `StreamBuffer` ring.
A ring region becomes reusable the moment the TICK it was committed under completes
(`WaitPendingOperations`), but the deferred op that READS the region runs at the next
`PopPendingOperations` - on the GPU thread, up to a frame later. With 5-9 MB of prefetch plus
15-25 MB of synchronous downloads per frame the ring wraps every 2-3 frames, so a late pop reads
a region already refilled by a newer download and writes THOSE bytes into guest memory at the
OLD address. Indirect-draw arguments on that page then go to the GPU as garbage. The same path
has served the buffer GC's `clean_up` since upstream - latent because the GC's ops are popped at
the very next OnSubmit.

A second, theoretical hole was closed in the same pass (it did not fire here, the served
counts were too low): two prefetches of one window in flight both `Subtract` the range from
`gpu_modified_ranges`, so the FIRST op sees no newer mark, unmarks the page, and the guest reads
frame N's bytes unprotected while frame N+1's bytes wait behind a pop that only the GPU thread
performs - if the guest spins on that word and submits nothing, nobody pops: a deadlock with the
GPU thread IDLE (the opposite signature of the one seen).

**4. What the run did prove.** No assert in the read-protection machinery with prefetch on, the
`served` path works (23-47 per window were answered without a drain), `skipped stale` and
`skipped CPU-modified` stayed at 0 (so the write-back hazard checks are not what limits it), and
the environment was drawn as in run 270. Served is ~5 % because the guest reads a window's
results right after its own fence, typically after the next frame's producing dispatch has
already been RECORDED (which re-marks the range): the op then skips as stale and the fault drains
as before. Raising that share means landing the write-back BEFORE the next frame's mark - a
per-dispatch prefetch or a priority (own-thread) write-back - and is the next lever once the
hang is gone.

## RUN 272 (pre-declared) - the prefetch with its own staging ring, one in flight per window

Build 22:24 (`GT7_probe272.bat` = probe 271, same env: `GT_READ_PREFETCH=12`, 512 KB window).
- `BufferCache::prefetch_slots[4]`: one `MemoryUsage::Download` buffer per flush (budget x 2 -
  copies are 64-byte aligned so the staging bytes can exceed the window sum), `used` reset per
  flush, `pending` = deferred ops still to run against it. `DownloadBufferMemory<true>` stages
  in the active slot when recording a prefetch (`prefetch_slot != nullptr`), falls back to the
  ring only if the copy does not fit (`ring_fallback`), and the op decrements `pending`.
- `PrefetchReadbacks()` pops completed ops FIRST, refuses the flush when the slot's ops have
  not run (`slot busy`, i.e. the GPU is 4 flushes behind), and skips any window whose previous
  prefetch tick is not free (`skipped in flight`).
- `[prefetch]` line: `... {} skipped in flight, {} evicted, {} unregistered, {} flushes skipped
  (slot busy), {} copies fell back to the ring | write-back: ...`.
Verdicts:
- no hang, no `HUGE Draw`, `[prefetch]` shows `0 copies fell back to the ring` -> the staging
  lifetime was the cause; the prefetch is safe to keep and the served share is the next job.
- hang again with a `HUGE Draw` -> a second corruption path; check `ring_fallback` (a copy that
  went through the ring) first, then whether the garbage page is one a write-back touched
  (`GtLogBufEvent("bufdl")` under GT_BUF_EVENTS).
- `slot busy` or `skipped in flight` dominate -> the GPU runs more than a frame behind the
  recording; the prefetch then needs the priority (own-thread) write-back to land in time.
- served share unchanged (~5 %) -> expected; the re-mark-before-pop ordering is the limit, see 4.

## RUN 272 VERDICT (3 Sep 22:27-22:32, STUCK at t=172 s) - no corruption; a refault storm on one page

Log `GT7_work/logs/run272_prefetch_refault_storm.txt` (Revision 3a7f528a = HEAD at build time; the
new `[prefetch]` fields prove the build), stuck stacks `logs/stuckstack_20260903_223137.txt`, 53
autoshots (`run272_sheet_0..1.png`). Switch at t=110 s, race from ~t=112, stuck at t=172. User:
«the image is still the same whitewash but the road and other textures and assets fully build.
cant see anything from the blinding light».

**1. The staging fix held.** `0 copies fell back to the ring`, `0 flushes skipped (slot busy)`,
`0 skipped in flight`, **0 `HUGE Draw`** in 60 s of racing (run 271 produced one within 27 s).
40-58 windows recorded per 2 s (9-11 MB), 40-88 ranges written back, 0 skipped stale, 0 skipped
CPU-modified. Served share unchanged: 8-51 of 200-540 read faults per window (~5-10 %), download
time 200-830 ms per 2 s - as predicted, the prefetch as built does not lower the drain count.

**2. The hang is a different one.** The summary at t=172 reads `read faults 70968 ... 70606
downloaded nothing`, then every window `~800 000 read faults, 0.01 ms each, 1 distinct window
(0xec03cc8000), 0.0 MB copied, all downloaded nothing`. The second stuckstack:
`GpuCommandProcessor 3219 ms/3 s Running` in `KiUserExceptionDispatcher <- CopySparseMemory <-
UploadCopies <- SynchronizeBufferSpan <- SynchronizeBuffer <- SynchronizeBuffersInRange <-
ConsumeDmaDirtyLog`. The GPU thread itself faulted READING page `0xec03ccb000` during an upload;
`SendCommand` runs the fault handler inline on the GPU thread; the handler found nothing in
`gpu_modified_ranges`, left the page read-protected, the instruction retried, faulted again -
400 000 times a second, for ever. `Job#0` meanwhile spun in guest code. Not a GPU hang, not a
deadlock: a page that can never be satisfied.

**3. How the page got there - my per-copy unmark.** Run 271's deferred write-back unmarks only
the ranges it copied and does the whole-window unmark only when nothing in the window was
re-marked. A tracker page whose GPU bit is set but which has no range in `gpu_modified_ranges`
(upstream's "download found nothing" case) is never copied, so never unmarked per copy - and one
re-marked range elsewhere in the window (the `+0x90` pointer the game reads every frame) vetoed
the whole-window unmark. Upstream's synchronous path always unmarked the whole window, so the
disagreement healed itself there. `0xec03cc8000` is exactly the buffer where that happens: one
page rewritten every frame, another page marked once and never again.

**4. The picture (user + sheets).** Frames #45 (t=156) and #48 (t=162): road with lane
markings, kerbs, guardrails, trackside buildings and trees all built and textured; the CAR is a
blinding white blob with a bloom that whites out most of the frame; magenta (forced clear =
unwritten) remains in sky/water areas. The whitewash therefore sits on the car's own shading
(or the light that hits it), not on the environment - a value the CPU now reads back (or fails
to: a histogram written through an untracked path downloads as stale zeros -> "pitch dark" ->
maximum exposure) is the standing hypothesis; unproven, and the next front after the hang.

## RUN 273 (pre-declared) - no page may stay protected with nothing to download

Build 22:35 (`GT7_probe273.bat` = probe 272, same env).
- Deferred write-back: unmark the window **page by page** - every 4 KB page with no range left in
  `gpu_modified_ranges` and not CPU-modified loses its GPU bit, whatever its neighbours do.
- Fault path: `copied == 0` and the page still GPU-modified -> wait on an in-flight prefetch if
  there is one; if it is STILL GPU-modified afterwards, `UnmarkRegionAsGpuModified(device_addr,
  size)` (nothing to download = RAM already holds the answer). Counted as `healed` in the summary
  (`{}/{} read/write faults healed`), for both read and write faults, prefetch on or off.
Verdicts:
- no hang, `healed` small (tens per window at most) -> the storm class is closed; measure the
  served share and the fps, then the whitewash.
- `healed` in the thousands -> the tracker/range-set disagreement is systematic somewhere else
  (the heal hides it); log the healed addresses.
- hang again with `downloaded nothing` in the storm -> the heal did not reach that path (a fault
  outside ReadMemory?); stuckstack names it.
- hang with a `HUGE Draw` -> back to corruption; check `ring_fallback`.

## RUN 273 VERDICT (3 Sep 22:37-22:41, NO HANG, race run to the end) - the storm class is closed, and the exposure hypothesis is dead

Log `GT7_work/logs/run273_prefetch_heal.txt` (Revision 562257de = HEAD at build time, one commit
behind 91bbbb65; the `healed` field in the summaries proves the build), 70 autoshots
(`run273_sheet_0..1.png`). Switch at t=79 s, race t=~82-147 (Music Rally, lost on time - the game
ended it, not a hang), "THAT'S A SHAME" at t=148, menu at t=150. User: «game did not crash this
time until race was lost due to time».

**1. Readbacks: stable.** 0 `HUGE Draw`, 0 ring fallback, 0 slot busy, 0 skipped in flight, 0
skipped stale, 1 skipped CPU-modified. **`healed` = 0/0 in every window but one (0/1 at t=141)**, and
`downloaded nothing` = **0 in every window** (run 272 had 70 606 in the storm window and a handful
before). So the page-by-page unmark is doing the work and the heal is the safety net it was meant to
be: the storm class is closed. Verdict tree branch: "no hang, `healed` small".

**2. The cost did not move - as predicted.** 240-660 read faults per 2 s, 250-770 ms of download
per 2 s, 15-46 distinct windows, served 2-50 per window (~5-10 %), waited 0-3. 40-80 windows
recorded per 2 s (3-15 MB), 25-159 ranges written back. Frame rate 10-36 submits per 2 s,
`busy` 1200-1900 ms. The census of faulted windows is the run-270 set: `0x1014ddc000` 35,
`0x1000f80000` 32, `0xec03cc8000` 25, `0x1000ffc000` 13, `0x1020000000` 12, then the `0x2032..0x2058`
heap windows. The lever for the served share is still landing the write-back before the next
frame's mark (per-dispatch prefetch or a priority own-thread write-back).

**3. The whitewash, read off the frames - and it refutes the exposure hypothesis.**
- **#60 (t=133)**: dark dusk scene, correctly exposed - dark asphalt with lane markings, guardrail,
  trees, a bus shelter, a normal HUD - under a **magenta sky** (forced clear = the sky is never
  written) with a **white streak** across it and two white blobs at the far left. No car in frame.
- **#65 (t=143), #66 (t=146)**: same correctly exposed dark environment (trees, guardrail, kerb,
  a street lamp), with a **giant white ball plus halo** at the lower centre / lower right - where
  the car sits in the chase camera - and the halo washing the right half of the frame.
- **#57 (t=127)**: the ball dead centre, magenta patches on the far hills, HUD intact.
Frame stats (mean luma / % clipped): #57 125 / 2 %, #60 89 / 1 %, #65 111 / 3 %, #66 118 / 6 %.
**An auto-exposure driven to maximum by a stale histogram would have blown the trees out along with
the car. It did not: the environment is correct in the same frame the ball is white.** So the wash
is a LOCAL emitter - a small region carrying an enormous HDR value - spread over the frame by the
bloom chain, not a global gain. Standing suspects, in order: (a) the car's material reading an
UNWRITTEN reflection source (the sky itself is unwritten - the same missing pass would leave the
car's environment reflection as garbage; run 270's `[imgnew]` shows the 256^2 x6 B10G11R11 cube
faces `0x10b10b5f00` / `0x10b07ca600` that could be it), (b) the sun/light-shaft pass (#60's streak
lies across the magenta, so it is an additive pass drawn after the sky failed), (c) headlight/lens
sprites at night (Music Rally runs at dusk; #65's ball has a lens-flare shape). All three produce
"a few pixels of huge value + bloom"; none produces "the whole frame at a high gain". The
run-268-#100 observation (one frame correctly exposed) fits (a)-(c) too: the emitter is off-screen
or the stale source is momentarily right.

**4. Also in this run.** The 64^3 RGBA16F LUT at `0x101e400000` is written once (cs 0xf04a69f0) and
read 118 times, `0x101e600000` 9 times - the grading path runs. `[imgarr] none` in every race
window (tile caches still not fed - but the road IS textured, so the texturing comes from another
path). The "1x1 R8 exposure state" at `0x1000e33200` named in the analyze25 notes is in fact a
**1x1 x 449-layer R8Unorm array** (`[imgnew] 0x1000e33200+0x40e500 1x1x1 mips 1 layers 449`) -
449 one-byte values, per-object/per-material flags rather than one exposure - its name in that
note is a guess and should not be built on.

## RUN 274 (pre-declared) - `GT_HDR_PROBE=1`: measure the HDR target, do not guess at the wash

Build 22:53 (`GT7_probe274.bat` = probe 273 + `GT_HDR_PROBE=1 GT_HDR_PROBE_S=3`).
`Rasterizer::MaybeProbeHdr` (called in `BeginRendering` for each colour attachment, BEFORE its
attachment transit): every 3 s, at the first bind of each matching colour target in a presented
frame - so the bytes are the PREVIOUS frame's final content, before this frame's clear/first write
- download mip 0 / layer 0 through the download ring, `scheduler.Finish()`, decode
`B10G11R11UfloatPack32` / `R16G16B16A16Sfloat`, and log
`[hdrprobe] t=..s frame N va 0x.. WxH fmt: max L=.. at (x,y) rgb=(..) | inf N nan N >1e3 N >1e2 N
>10 N >1 N of N px | mean L .. | grid r0/r1/../r5` (12x6 cells, each the cell max as a log10
digit: `.`<1, `1`<10, `2`<100, `3`<1e3, `4`<1e4 ..., `I` = INF seen, `N` = NaN seen). `1` = every
float colour target from 480x270 up (the 1920x1080 HDR targets `0x1005000000` / `0x100a0c8000`,
the 960x540 RGBA16F bloom inputs, the 480x270 B10G11R11 downsample); at most 6 images per tick,
images over 16 MB skipped. A comma list of hex addresses restricts it.
Verdicts:
- HDR target: `max L` in the 1e3-1e5 range on a few hundred pixels (`>1e3` small, `>1` normal),
  `mean L` sane, INF 0, and the grid's hot cell where the car / the streak is in the matching
  autoshot -> **local emitter confirmed, finite**: next is WHICH DRAW writes those pixels - a
  per-draw probe on the hot cell (bind the HDR target, download the cell after each colour draw in
  a budgeted frame) or the cube faces' own probe (add `0x10b10b5f00,0x10b07ca600` to the list).
- INF / NaN present in the HDR target -> a shader producing INF (a division by an unwritten zero,
  e.g. a missing exposure/normalisation constant) - then the bloom spreads INF; find the first
  target in the chain that carries it (the 960x540 / 480x270 probes say whether it enters at the
  scene or in the downsample).
- `mean L` itself high (tens+) and `>1` most of the frame -> the environment is bright too and the
  frames lied about exposure (the tonemapper is hiding it) - back to the exposure path.
- The bloom targets hot while the HDR target is not -> the bloom/downsample pass itself is the
  emitter (reads an unwritten mip / wrong source).
- No `[hdrprobe]` line at all -> the targets are not bound as colour attachments (written by
  compute) - probe by address list instead, taken from `[imgnew]`.

## RUN 274 VERDICT (3 Sep 22:55-23:00, two races, no hang) - the sky band is SATURATED: 65024 in the HDR target, ground under 10

Log `GT7_work/logs/run274_hdrprobe.txt` (Revision 91bbbb65; 310 `[hdrprobe]` lines prove the
build), 86 autoshots (`run274_sheet_0..2.png`). Switch at t=132 s, race 1 t=~134-190 (lost on
time, "THAT'S A SHAME" ~t=196), race 2 t=~204-280. Readbacks stable again: `healed` 0/0 (0/1 twice),
`downloaded nothing` 0, 0 HUGE Draw, served 2-70 per window, fps 10-36 submits per 2 s.

**1. The measurement.** Per target, first bind of a frame every 3 s (= the previous frame's final
content):
- **`0x1005000000` and `0x1006bc8000`, 1920x1080 B10G11R11 (the HDR scene target, ping-pong):**
  `max L = 6.502e4 rgb=(65024 65024 64512)` = **the largest finite value of the 11-bit / 10-bit
  ufloat, i.e. SATURATED**, in 40 of 48 race frames. INF 0, NaN 0. `>1e3` = 2 000 - 750 000 pixels
  (0.1 % - 36 % of the frame); the 12x6 grid shows it as a **horizontal band across rows 1-2**
  (y 180-540, the sky/horizon strip) e.g. `............/555555555555/555555555555/......1...../
  ............/............`, with rows 3-5 (the road, the car) at `.` (<1) or `1` (<10) and
  `mean L` 60-23 000. Menu / transition frames read a clean magenta clear (`(1,0,1)` everywhere =
  nothing written) or a sane 1-2.6. **So the "car as a white ball" reading of run 273 was the
  bloom's SHAPE, not its source: the source is the sky band.**
- **`0x100a2f0000` / `0x100a810000`, 480x270 B10G11R11 (bloom downsample):** the same band at
  `1.13e4` max (the downsample's weights), `>1e3` 5 000 - 50 000 of 129 600. **`0x1015200000` /
  `0x1014e00000` 480x540 x2:** `3.5e4` / `2.6e4` in the top rows. The chain propagates the band
  intact - it is not the bloom pass inventing it.
- **`0x10085f0000` / `0x1007600000`, 1920x1080 RGBA16F:** `rgb=(30..200, 65504, 65504)` in the
  sky rows, `100-1000` on the ground, NaN patches - NOT colour: G/B read as a distance clamped to
  fp16 max for the sky and hundreds of metres on the road (a depth/velocity/normal buffer). The
  `1` matcher takes any float colour target; these are noise for this question, ignore them.
- `0x100a0b0000` (1920x2160 RGBA16F, 31 MB) skipped by the ring cap; `0x100b440000` 960x540
  RGBA16F always 0; `0x100a0c8000` bound once at t=125, empty.

**2. What that rules out and what it leaves.** The environment IS correctly exposed (run 273's
frames, and here the ground rows read 1-10 while the band reads 65024): not an exposure/histogram
fault. Not INF or NaN: a finite, clamped value - GT7's sky shader either computes something
enormous and clamps to fp16 max (65504 -> stored as 65024/64512), or a stage in the chain does.
The band is where the SKY / distant horizon draws, and the sky is also the thing that is sometimes
NOT drawn at all (magenta in run 273's #60). One pass, two failure modes. The value it should hold
is a few units (a dusk sky through a pre-exposure). Suspects: the sky/atmosphere draw reading an
unwritten or garbage input (a sky LUT / transmittance volume / equirect map - `[imgnew]` shows
1024x512 and 1024x256 B10G11R11 at `0x100d810000` / `0x100a540000`, the 256^2 x6 cube faces at
`0x10b10b5f00` / `0x10b07ca600`), or a sun-intensity constant read through a readback that comes
back stale/garbage. The frame-0 grid of the same targets (t=130-134, before the switch) reads a
clean 0.98 max - the saturation begins with the race scene, not with the readback switch.

## RUN 275 (pre-declared) - `GT_HDR_DRAWPROBE`: the draw that writes the band

Build 23:09 (`GT7_probe275.bat` = probe 274 + `GT_HDR_DRAWPROBE=0x1006bc8000,0x1005000000
GT_HDR_DRAWPROBE_S=20`). Armed by `MaybeProbeHdr` at the first bind of a watched target in a
frame (once per 20 s); then `Rasterizer::MaybeDrawProbe` (after every `cmdbuf.draw*` in `Draw`
and `DrawIndirect`) - when colour attachment 0 is that target - downloads a 24x12 lattice of it
(288 texels, one `Finish` per draw, one frame only) and logs every draw that changed a sample:
`[drawprobe] frame F draw #k direct|indirect N x M: ps 0x.. changed C samples, hot H (new X),
max L=.. | T#s: 0xaddr:WxH[xL]fDFMT[W] ... | <12 rows of 24 chars>`; the pixel shader's T#s are
collected in `BindTextures` (`GtDrawProbeNoteImage`) and cleared per draw in `BindResources`.
Frame end: `[drawprobe] frame F summary ... first draw to make a sample >= 1000: #k ps 0x..`.
Verdicts:
- one draw (or a few, same ps) turns the sky rows hot with a dozen T#s -> the sky pass; its T#
  list names the inputs; next is probing THOSE images (`GT_HDR_PROBE=<their addresses>` works
  only if they are colour attachments - add a BindTextures-side probe for sampled images if not)
  and reading the shader (`GT_DUMP_SHADERS` / the rdc shader dump for that hash).
- the band arrives with a full-screen draw that reads the HDR target itself (a composite /
  light-shaft / fog pass) -> the emitter is that pass's OTHER input; its T# list says which.
- the band is already hot at draw #0 (the first draw into a target that was cleared) -> the
  clear itself, or a copy/blit into the target before any draw (`[clear]` / DMA lines).
- no `[drawprobe]` lines despite `armed` -> `cb_descs[0]` is not the watched target for those
  draws (the sky drawn into the other ping-pong buffer that frame) - both are in the list, the
  arm picks whichever binds first; widen to "any watched target" if it keeps missing.

## RUN 275 VERDICT (3 Sep 23:13-23:16, Music Rally, chase camera, no hang) - NO DRAW WRITES THE SKY; the saturated seeds are SMALL geometry draws; the band is not a draw

Log `GT7_work/logs/run275_drawprobe.txt` (Revision a057dee2 - the 23:09 build preceded commit
2c3e7ec2; 131 `[drawprobe]` lines prove the build), 60 autoshots (`run275_sheet_0..1.png`).
Switch at t=53 s (steady state detected early: the user went straight to Music Rally), scene
t=~55-135. Readbacks stable: `healed` 0, `downloaded nothing` 0. The user then pressed "return to
the main game" and it STUCK - not investigated (their call: colours first); the log ends with a
clean shutdown after they closed it.

Five armed frames: 2009 (t=45, menu, 164 draws), **2136** (t=65.8, 3 draws into `0x1006bc8000`),
**2299** (t=88.1, 493 draws into `0x1005000000`), **2517** (t=109.3, 2 draws), **2691** (t=130.6,
1245 draws). What they measured:

**1. THE SKY IS NEVER DRAWN BY A GRAPHICS DRAW INTO THE HDR TARGET.** In frame 2299 the lattice's
rows 0-2 (y < 270) read `1` = the magenta clear `(1,0,1)` after draw #0 and are STILL `1` after the
last draw that changes anything (#452 of 493); frame 2691's rows 0-6 (y < 630) likewise. Screenshot
#37 (t=89) shows exactly that: a magenta sky with white blobs. And #20 (t=48, the pre-race 3D
scene, BEFORE the readback switch) already has a magenta sky - the missing sky is not a readback
symptom, it predates the switch. So the sky is either a compute pass that is not running (or
writing nothing) or a pass into a target that is not one of the two watched ping-pong buffers.

**2. THE SATURATED PIXELS THAT COME FROM DRAWS ARE A FEW SMALL GEOMETRY DRAWS AT THE HORIZON, NOT A
SKY PASS.** Frame 2299: first hot sample at **#327 ps 0x55ee56bf (870 vertices)**, then #329 (same
ps, 732), **#331 ps 0x453b8531 (5040)**, **#450 and #451 ps 0x59a23308 (924 each, 6 new hot samples
each - lattice rows 4-5, columns 0-7 = left of the horizon, y 300-500)**, **#452 ps 0xac6429fe
(408)** -> 15 of 288 samples at 65024 when the draws are over. Their T#s: three 2048x512 BC7 maps
(a long thin object - barrier / signboard / fence) or 128x128 + 256x256 BC7 + two 80x32 f6 maps,
plus the scene's shared lighting set (shadow array 1024x1024x4 R32 `0x100da10000`, the 7424x7424
16-bit `0x2900000000`, probe arrays 64x64x2048 / 128x128x256 / 64x64x1536 f6, a 128x128 f12 LUT,
a 30x17x16 f11 volume). **Nothing in those T# lists is unique to the hot draws** - #167 / #197 / #317
bind the same probe arrays and stay under 3.2 - so whatever differs is a CONSTANT (material /
emissive intensity) or the shader itself. Hence `GT_DUMP_HASHES` in run 276.
Frame 2691: no draw reaches 65024; the hottest is **#1192 ps 0x86c1cee3 (768 vertices, reads
`0x1006bc8000` - the OTHER HDR target - as a T#: glass refraction/reflection of the PREVIOUS frame)**
at 4.25e4, and #1207 paints over it -> the final lattice has 0 hot samples. The lattice max before
that was 560 (#22 ps 0x3ce63407 at 260, the track draws #115 / #136 at 504 / 560).

**3. THE WIDE BAND IN THE FINAL FRAME IS NOT MADE BY ANY DRAW.** The last changing draw leaves 15 hot
samples (2299) or 0 (2691), while `[hdrprobe]` of the neighbouring frames reads 100 k - 1 M pixels
of 65024 across the top rows. Something AFTER the last draw writes it: a compute pass writing the
target in place (bloom composite) or a copy. Frames 2136 and 2517 (3 and 2 draws into the target,
full-screen: ps 0x4d8a5765 with one 256x384 BC3 T#, 12 vertices; ps 0x93d12532 with no T#s, 3
vertices) show the target being reused as a post-process ping-pong, and their output already
carries hot samples at the sky rows plus `3` (100-1000) over the car - the car's body is itself very
bright, which is the white ball of the screenshots.

**4. Instrument notes.** Draw #0's `changed 288` was an artifact (`prev` came from the previous
probe 20 s earlier); `max L=1` everywhere after it says the target had been CLEARED to (1,0,1)
before the first draw. Run 276 takes a baseline from the arm-time download. `ps 0xf335b5c7` (1188
vertices) and `0x1185ec50` (3408, also the track's ps in 2691) are simply the first geometry draws.

## RUN 276 (pre-declared) - the lattice after every compute DISPATCH + GT_DUMP_HASHES

Build 23:29 (`GT7_probe276.bat` = 275 + `GT_DUMP_HASHES=55ee56bf,453b8531,59a23308,ac6429fe,
4d8a5765,93d12532,86c1cee3,f335b5c7,1185ec50`). Same `GT_HDR_DRAWPROBE` frame, but:
- `Rasterizer::MaybeDispatchProbe` (after every `cmdbuf.dispatch*`) samples the lattice of the
  watched target after EVERY dispatch of the probed frame and logs each one that changed a sample
  OR bound the target (as a T# or through a V# aliasing its memory): `[drawprobe] frame F op S
  dispatch #k direct|indirect XxYxZ: cs 0x.. changed C samples, hot H (new X), max L=.. [BINDS
  TARGET] | T#s:.. | V#s on target: 0xva+size[W] (n V#s) | rows`. `op S` is one counter shared with
  the draws, so the frame reads in order. The target's image is found at arm time
  (`FindImageFromRange`) and refreshed from `cb_descs[0]` on the first draw.
- baseline: `[drawprobe] frame F baseline (previous frame's final content): hot .., max L | rows`,
  taken from the hdrprobe download at arm time, so op 0's `changed` is honest.
- summary now carries both halves: `N dispatches (M changed it, first to make a sample >= 1000:
  #k cs 0x..)`.
- `GT_DUMP_HASHES` (vk_pipeline_cache.cpp `IsForcedDumpShader`): `fs_0x..._0.bin` (GCN),
  `fs_0x....forced.irprogram.txt` + `.forced.asl.txt` (IR), `fs_0x..._0.spv` in
  `%APPDATA%\shadPS4\shader\dumps` for the named hashes only.
- Expect a longer hitch per probe frame (a Finish per dispatch too: ~100-300 dispatches).
Verdicts:
- a dispatch turns the top rows from `1` (magenta) into sky values -> the sky IS compute and it
  runs; its T#s name the inputs (LUTs / cube maps) - probe those next. If the top rows are still
  `1` at the summary -> the sky pass is NOT issued (or writes elsewhere): grep the log for
  `substituting a NO-OP module` (a bindless-stubbed cs) and for the cs hashes of the frame.
- a dispatch with `BINDS TARGET` (written T# or aliasing V#) turns the 15 seeds into the band ->
  in-place bloom composite; its OTHER inputs are the bloom chain, and the seeds are the small
  draws -> read `fs_0x55ee56bf.forced.irprogram.txt` etc. for what can produce 6.5e4 (an exp2 /
  pow of a constant, a texture sampled as the wrong format, a missing clamp).
- no dispatch changes the lattice yet the next hdrprobe shows the band -> a copy/blit (DMA) or a
  draw into the OTHER ping-pong buffer; then watch both targets in one frame.
- the forced dumps are the second product of the run regardless of the lattice: they exist only if
  the shaders compile this process (they did in run 275 - `Compiling fs shader 0x55ee56bf` is in
  the log), so check the dumps folder first.

## RUN 276 VERDICT (3 Sep 23:32-23:35, Music Rally, chase camera) - NO DISPATCH TOUCHES THE TARGET; the 65024 is the GAME'S OWN clamp(x*const, 0, 65000); the sky IS drawn in some frames

Log `GT7_work/logs/run276_dispprobe.txt` (Revision 2c3e7ec2; 115 `[drawprobe]` lines), 68 autoshots
(`run276_sheet_0..1.png`). Switch at t=52 s. Six armed frames on `0x1005000000` (1988 menu, 2144,
2259, 2453, 2640, 2715), each with a baseline and a summary. The user closed normally after the
rally ("THAT'S A SHAME" at t=152) and reports: **"the sky and the clouds ARE drawn, I could see them
normally in some frames"** - true, and measured: #45 (t=105) and #48 (t=111) show real clouds and a
blue sky beside magenta patches; the hdrprobe grids of the same stretch read `.` (dark, < 1) in the
top rows where other frames read `1` (the magenta clear). The sky pass exists and runs SOMETIMES.
Run 275's "never drawn" was true of the two frames it probed and of the cb0 draws only (see 2 below).

**1. NOT ONE COMPUTE DISPATCH CHANGES THE TARGET OR EVEN BINDS IT.** 65 / 73 / 67 / 10 / 80 / 351
dispatches per probed frame, `0 changed it` every time, and zero `BINDS TARGET` lines - no CS binds
`0x1005000000` as a T# and no V# aliases its memory. So GT7's post chain on this target is PIXEL
shaders, and whatever writes the band after the last cb0 draw is a DRAW the probe did not see.
The obvious hole: `MaybeDrawProbe` matched `cb_descs[0]` only, and **every dumped hot pixel shader
exports RenderTarget0 AND RenderTarget1** (`SetAttribute RenderTarget1, ..` x2 then `RenderTarget0`
x4) - GT7 renders the scene as an MRT pair, and for the passes where the HDR buffer is cb1 (with
the RGBA16F velocity/normal buffer `0x10085f0000` / `0x1007600000` in cb0) the probe was blind.
That is also why run 275 counted "493 draws into it" out of thousands: it counted only the passes
that happen to put it in cb0. Run 277 matches any slot.

**2. THE 65024 IS THE GAME'S OWN CLAMP.** All four hot shaders (`fs_0x59a23308 / 55ee56bf /
453b8531 / ac6429fe.forced.irprogram.txt`, 4000-4400 IR lines each, 20-22 image samples, 96-138
`ReadConst`, no bindless stub - `substituting a NO-OP module` appears 0 times in the run) end
identically:
```
%4263 = FPMul32 %2272, %4260        ; %2272 = ReadConst #297 of the SGPR0:1 constant block
%4266 = FPMul32 %2271, %4259        ; %2271 = ReadConst #296
%4269 = FPMul32 %2273, %4258        ; %2273 = ReadConst #298
%4270 = FPMedTri32 #65000, %4263, #0   ; clamp(x, 0, 65000)  <- 65000 -> 65024 in ufloat11
SetAttribute RenderTarget0, %4272/%4270/%4271, #0..#2 ; alpha #3 = %2435 (1 + something)
```
So the pixel value is `lit_colour * (c296, c297, c298)` clamped to 65000 - the format's largest
finite value (65024) is simply the nearest ufloat11 to 65000. A pixel at 65024 therefore means the
PRODUCT was >= 65000: either the lit colour is enormous or the three constants are (a per-channel
scale from the constant block - a pre-exposure / emissive multiplier is exactly what sits there in
an HDR pipeline, and a pre-exposure is exactly what a CPU computes FROM A GPU READBACK of the
luminance histogram; the wash starts at the readback switch, t=52-53, first 65024 at t=53.8).
Run 277 reads dwords #296..#298 from the constant block of every changed draw so a hot draw and a
sane one in the same frame can be compared - that is the measurement that separates "the
constants are garbage" from "the lit colour is garbage".

**3. The rest of the frame reads sane.** Frame 2715: 795 draws, lattice max 432 before the first
hot (draw #540 ps 0x63c5ff3, 300 vertices, a 4096x4096 16-bit T# at `0x2920000000` + three
1024x256 BC7). Frame 2259 (44 cb0 draws): op 0 is a 3-vertex full-screen ps 0x4861092c with no T#s
that changes 122 samples - a post pass writing the HDR target with the scene from elsewhere -
and then ps 0x59a23308 (924 vertices, the same small object as run 275's #450/#451) adds 5 hot
samples at rows 4-5, columns 0-2. Frame 2453 (18 cb0 draws): a full-screen ps 0x6bfea272 with one
1024x128 BC3 T# (a lens / UI strip) - the target in its post-process role again.

**4. Instrument notes.** The baseline lattice agrees with the hdrprobe census of the same download
(hot spots the 12x6 cell-max sees are single texels the 24x12 lattice misses - expected). In run 276
`ProbeLattice` failing (ring exhausted) returned silently; `1` in the rows is ambiguous between the
magenta clear and a sky of L 1..10 - run 277 prints `m` for (r>0.9, g<0.02, b>0.9).

## RUN 277 (pre-declared) - any colour slot, `m`, constants #296..298, FINAL lattice

Build 23:44 (`GT7_probe277.bat` = 276, same env). Changes in `Rasterizer::MaybeDrawProbe`:
- the target is matched in **any** `cb_descs[0..7]`; the line carries `cb<slot>`.
- per logged draw: `cb <va> #296..298 = r g b (hex hex hex)` read from guest memory at the PS
  user-data SGPR0:1 pointer + 296*4 (`memory->IsMappedMemory` first; `unmapped` if not).
- `m` = magenta clear in every lattice (draws, dispatches, baseline, FINAL).
- `[drawprobe] frame F FINAL (read at frame F+1's first bind): changed .. since the last probed op,
  hot .. (new ..), max L | rows` - a forced hdrprobe tick of the probed target at the next frame.
Verdicts:
- draws now appear with `cb1` (or higher) and the sky rows turn from `m` to values in one of them
  -> the sky pass found, its ps and T#s named. If the sky rows are still `m` at FINAL in a frame
  whose screenshot shows a sky -> the sky is composited from a different buffer by the post pass
  (then the "other" HDR target is the one to watch in the same frame).
- hot draws carry constants like 1e3..1e6 (or INF) while sane draws in the same frame carry ~1
  -> the multiplier is the fault; it is CPU-written, so the next question is what the game
  computes it from (a readback - `[readtrace]` windows touching that constant block's page).
- hot and sane draws carry the SAME sane constants -> the lit colour itself is enormous -> the
  fault is inside the shading (a light / probe / shadow input) - then dump the inputs of one hot
  draw (T# addresses are in the line) and read `ImageSample` usage in the IR.
- FINAL shows the band where the last logged op did not -> a writer between them: a draw whose
  slot was still missed (log every cb slot's address per draw), or a copy.

## RUN 277 VERDICT (3 Sep 23:47-23:50, Music Rally, chase camera, no hang) - the target is ALWAYS cb0, the multiplier is TINY, the sky dome is a draw that is sometimes not there

Log `GT7_work/logs/run277_anyslot.txt` (Revision 386f56ea = HEAD at build time; the 153 `[drawprobe]`
lines with `cb0:` / `FINAL` / `m` prove the build), 61 autoshots (`run277_sheet_0..1.png`). Five
probed frames: 1997 (t=45, pre-race), 2127 (t=66), 2274 (t=87), 2482 (t=109), 2657 (t=130).
Readback switch 0 -> 2 at t=52; `healed` 0; readbacks steady.

**1. The MRT theory of run 276 is REFUTED.** 0 of the logged draws bound the target in cb1..cb7 -
every one says `cb0`. RenderTarget1 of the hot shaders is the RGBA16F aux buffer, not the HDR
target. And the "band arrives after the last cb0 draw" reading of run 275 did not reproduce: all
five `FINAL` lattices report `changed 0 samples since the last probed op` - nothing writes the
target between its last probed draw and the next frame's first bind.

**2. The multiplier is SANE, so the lit colour is what is enormous.** Constants `#296..#298` (per
channel, one value) read at the hot draws: `0x59a23308` -> **3.07e-05 3.07e-05 3.07e-05** (frame
2274) / 1.846e-04 (frame 2127); `0xac6429fe`, `0xfedb7904` -> 3.07e-05; `0x55ee56bf` -> 0 1.744 1.
The block base is verified in all three IR dumps (`%129/%130`, `%124/%125`, `%133/%134` are
`GetUserData SGPR0/SGPR1`), so the pointer was right. A pre-exposure of 3e-5 is what a dusk scene
in physical units needs (the ground rows read 1-10 after it). For the product to clamp at 65000 the
lit colour must be **>= 65000 / 3.07e-5 = 2.1e9, or INF**. Verdict branch 3 of the pre-declaration:
the fault is inside the shading inputs, not in the CPU-written multiplier.

**3. The hot shaders are NOT glare sprites - they are fully lit small geometry.** `0x59a23308` IR:
4462 lines, 23 image ops of which **8 `ImageSampleDrefExplicitLod`** (shadow cascades: T#s
`1024x1024x4 R32` and `7424x7424 R16`), the light LUT arrays (`64x64x2048`, `128x128x256`,
`64x64x1536` B10G11R11, `30x17x16` RG32 froxels), three BC7 material textures, **pull-model
interpolation** (`BaryCoordSmoothSample` + `GetAttribute Param3/5/6/7, comp, vertex` with manual
FPSub/FPFma - a rarely exercised recompiler path), `SampleIndex`; RT0 = `clamp(#296..298 x lit)`,
RT1 = two components through `FPRecip32`. The lit colour is `%4260 = Phi(%4255, %3828)`, a chain
that was not traced. Draw sizes 924 / 870 / 408 / 384 vertices, 1 instance. The IR dump carries
`<type error: F32x2 != F32x4>` annotations on the `ImageSampleImplicitLod` coordinates - very
likely the dumper's validator, not checked.

**4. Hot samples live in the horizon band and only in SOME frames.** Frame 2274: `#313 0x55ee56bf`
(2 new), `#327 0xfedb7904` (1), `#420/#421 0x59a23308` (9+1), `#422 0xac6429fe` (2) -> 15 hot of 288,
rows 2-5 (y 190-500); frame 2127: `#5 0x59a23308` (4) - the 6th op of the frame. Frames 2482 and
2657 had **no hot draw at all** and their FINAL max L was 46 and 244: clean frames exist inside the
wash, while the hdrprobe at the same seconds still shows 65024 in the other ping-pong buffer.
Screens #41-#43 (t=96-101) show the real scene for a moment: a **dusk/night track**, dark sky, lit
signs, the car wrapped in a white glare ball, magenta patches on the verges.

**5. THE SKY IS A DRAW THAT IS SOMETIMES MISSING.** `ps 0xf335b5c7`, `direct1188 x1`, **op 0** -
the first draw of the frame - changes 273-279 of the 288 samples to L <= 1: the sky dome. It is
there in frames 2482 and 2657 (both have `.` sky rows and no horizon `m`) and **absent in frames
2127 and 2274**, whose baseline is all-`m`, whose first touched op is `#15 0xf7758837` (the
44880-vertex road) and whose FINAL keeps `m` holes exactly in the horizon band (rows 2-6) - the
same band the hot samples sit in. The late full-screen passes `#416 0x46f246cd` (4 vertices,
changed 87) and `#417 0x4861092c` (3 vertices, changed 55) fill rows 0-1 (upper sky) but not the
horizon: the horizon is where geometry SHOULD stand and is not drawn. The probe logs only draws
that touch the lattice, so "absent" here means "did not change a sample" - skipped, zero-count or
degenerate cannot be told apart yet. Screens #20 (t=48) and #22 (t=52) show the forest with a
magenta sky patch BEFORE the wash; #23 (t=55) is the first washed frame - coincident with the
readback switch (t=52) AND a scene load (30 `[imgnew]` at t=53), so not separable here, and the
wash predates the readback machinery anyway (the "exposure pulse" of Act 1).

**6. Dynamic resolution is real and benign:** `0x1006bc8000 1750x984` at t=130.1, and frame 2657's
FINAL has `m` down the right column (x >= 1840) and along the bottom row - the game renders a
sub-rectangle of the 1920x1080 target. Border `m` is not a missing draw.

## RUN 278 (pre-declared) - STUB the five hot shaders; watch the sky dome's every draw

Build 00:02 (`GT7_probe278.bat` = probe 277 + `GT_STUB_SHADERS=59a23308,55ee56bf,ac6429fe,
fedb7904,453b8531` + `GT_HDR_DRAWPROBE_PS=f335b5c7,46f246cd,4861092c`). The stub list answers "are
these five the only source of the saturation?" by removal (the pipeline cache is cold here - the
`Compiling fs shader` lines of run 277 prove CompileModule runs, so the substitution applies).
Instrument (`vk_rasterizer.cpp`): a watched pixel shader is logged on EVERY draw into the target,
touched or not (`changed 0 samples (watched ps)`), and so are the first 12 draws of a probed frame
(`(head)`); every logged draw now carries `vs <hash>` and a **constant-block scan** of the PS block
(512 dwords) and the VS block (256): `nonfinite N, |v|>1e4 H`, the first 8 anomalies as
`#i=v(hex)`, dwords `#0..3` and `#296..298`. The summary ends with `watched: ps X: N draws (M
touched)`. Verdicts:
- hdrprobe race frames drop to max L < 10 and the screens are readable -> the five are the sole
  source; the screens show what geometry went missing with them. Next: trace `%4260` in the
  0x59a23308 IR to the input that can be 2e9/INF (a normalize of a zero vector, a roughness
  divide, a LUT texel) and dump that input on a hot draw.
- 65024 persists -> other writers; the probe names them, they get the same treatment.
- `watched: ps 0xf335b5c7: 0 draws` in a frame with horizon `m` -> the game SKIPPED the sky draw
  (a CPU decision; readback / visibility data is the suspect). `1 draw (0 touched)` with 1188
  vertices -> drawn but degenerate or off screen -> its `vs-cb` scan (the matrix) is the suspect.
  `indirect x0` -> a GPU-written indirect count of zero.
- a constant anomaly present on the hot draws of a shader and absent on its sane draws -> that
  dword is the fault, and the question becomes who writes it.

## RUN 278 VERDICT (4 Sep 00:08-00:11, Music Rally, chase camera, no hang) - the five stubbed shaders were NOT the only source; the car body and a full-screen copy carry the band; the performance did not change

Log `GT7_work/logs/run278_stub5.txt` (Revision 7999b2d0; 6 `GT_STUB_SHADERS - substituting` lines =
the five hashes + one permutation, 174 `[drawprobe]` lines), 67 autoshots (`run278_sheet_0..1.png`).
User: "more image info through the race, more drawn stuff, less whitewash - but the performance is so
low I cannot keep up with the timer; the pre-race screen was still very glitchy."

**1. The stubs applied and the 65024 stayed.** hdrprobe race frames: `>1e3` up to **811 540 /
815 140 pixels** (t=64) in the two HDR buffers, 65024 in most ticks to t=142. So the five lit
shaders were one set of writers among several. New writers named:
- **`ps 0x97b39964`, `indirect1 x0 cb0`** (frame 2693 #533): an INDIRECT draw, 13 new hot samples
  in rows 6-7 (y 540-630) - exactly where the car sits in the chase camera. Its T#s: two
  `1024x2048` BC7 (a livery), plus the SAME lighting inputs every hot draw of run 277 had:
  `0x1000e7b800` 128x128 f12, `0x1001800000` 128x128x256 f6, `0x1002800000` 64x64x1536 f6,
  the `30x17x16` f11 froxel grid (at a CPU-side 0x2.. address that changes every frame), the shadow
  maps `0x100da10000` 1024x1024x4 R32 and `0x2900000000` 7424x7424 R16. **The car body.** The
  screens agree: with the five stubbed the track, trees, signs and a clouded sky are readable in
  #46-#63 and the car is a white glowing mass.
- **`ps 0x4861092c`, `direct3 x1 cb1`** (frame 2320 #0): the full-screen triangle, first op of the
  frame, into `0x1006bc8000` **in slot 1**, 287 changed / **124 new hot** - a copy or composite that
  carries the band from one HDR buffer into the other. Its ps user data is not a pointer
  (`0x1c70000010b18d97`), so its constants are addressed differently. The rest of that frame's
  first draws are `direct4 x1 cb1` post-processing quads (ps d6c07331 / 4d8a5765 / f1ddc7f7 /
  146827c5 / a3fd67d5) with the target in cb1 and no change to it.
- The stubbed shaders drew real geometry: the **magenta patches on the grass and verges** in the
  race screens are the ground pieces those five shaders used to draw (0x55ee56bf reads three
  2048x512 BC7 = terrain strips).

**2. The constant-block scan found nothing usable as such.** PS blocks: `nonfinite 0` everywhere;
the `|v|>1e4` entries are the same bit patterns in every frame (`0x701fc07f`, `0x70000000`,
`0x773fdcff` = packed fields, not floats). VS blocks at `0x10..` addresses carry descriptor words.
Comparing hot against sane draws of one shader needs the SAME shader in both states in one frame,
which this run did not produce. Keep the scan, do not read its raw counts as evidence.

**3. The sky question is an artifact of which buffer the probe armed on.** `watched: ps
0xf335b5c7: 0 draws` in frames 2066, 2223, 2320 and `1 draw (touched)` in 2516, 2693. But the frames
without it are frames where the probed buffer was NOT the scene target: 2223 (1073 draws into
`0x1005000000`, **20 touched**, FINAL almost all `m`, opening sequence `0x12e89e9c` x6 with 54-1176
vertices = the same sequence as the pre-race menu frame 2066) and 2320 (armed on `0x1006bc8000`,
op 0 = the full-screen copy, then post quads). Frames 2516/2693 open with `0x3ebc1bd7 3528` /
`0xb2d26667 7416..10740` vertices = scene geometry, and the sky dome at op 0. **The two HDR buffers
swap roles between frames; the probe arms on whichever binds first.** Run 277's "sky missing in
2127/2274" needs re-reading in that light (2274 did carry the 44880-vertex road, so it is not
fully explained - park it; the colours are the user's priority).

**4. Performance is unchanged by the stubs, and was already this low.** `[fprof]` submits per 2 s
window, t=60-130: run 277 **12-29**, run 278 **10-28**; draws per window 25-37 k in both; the 2-4 s
`pipe` spikes (pipeline creation) at the same moments. 5-14 submits/s is the race's frame rate on
this build, and the music-rally timer runs in real time - the user's "cannot keep up" is that. The
drawprobe's own 20 s hitch is the 1073-Finish frame. Not a regression; not fixed either.

## RUN 279 (pre-declared) - `GT_HDR_TEXPROBE=1`: census the inputs the saturating draws share

Build 00:21 (`GT7_probe279.bat` = probe 278 with `GT_STUB_SHADERS=` EMPTY + `GT_HDR_TEXPROBE=1`).
`Rasterizer::TexProbe(va, why)` (vk_rasterizer.cpp): when a probed-frame draw creates NEW hot
samples, every T# its pixel shader sampled (up to 10 per frame, once per address) is downloaded
WHOLE - in <= 8 MB slice chunks (layers, or depth slices for a 3D image) so the download ring is
never over-asked - decoded (B10G11R11, R16/RG16/RGBA16 sfloat, R32/RG32/RGBA32 sfloat; block
compressed = "skipped", cannot hold INF) and censused:
`[texprobe] frame F draw #k ps X: T# va WxHxS fmt: max V at (x,y) slice s ch c | inf N nan N >1e3 N
>1e2 N zero N of T values | mean | most >1e3 in slice s (n texels)`. The sampled addresses are
remembered for the whole run, and any later dispatch whose compute stage WRITES one of them logs
`[texprobe] frame F op S dispatch #k: cs X WRITES hot input va WxHxL fL | all T#s:...` (its producer;
the LUTs are computed every frame, so the next probed frame catches it). Stubs are off so the hot
draws are frequent. Verdicts:
- a LUT / probe array / froxel texture shows `inf` or `>1e3` texels (the light arrays should hold
  radiance in the same pre-exposed units as the scene, i.e. < 100) -> the input is the fault; the
  producer line names the compute shader; then dump ITS inputs and IR (`GT_DUMP_HASHES`).
- every sampled float image is sane (max < 100, no INF/NaN) -> the fault is in the pixel shader
  math or in a vertex attribute -> bisect the `%4260` chain of 0x59a23308 (pull-model
  interpolation and the `<type error>` image ops are the first suspects) with a recompiler-side
  debug export.
- the shadow maps read INF/garbage -> a depth-format decode or a stale shadow pass; the 8 Dref
  lookups would return 0/1 in either case and cannot make 2e9 on their own, so treat it as a
  side finding.
- no `[texprobe]` census lines although hot draws are logged -> the T#s are not in the texture
  cache under that address (bindless / BDA path) - then read them from guest memory instead.

## RUN 279 VERDICT (4 Sep 00:25-00:28, Music Rally + a longer stay in the intro) - THE CENSUS FOUND THE CARRIER: the 64x64x2048 light-probe array holds 65024 texels, static, written by compute at level load

Log `GT7_work/logs/run279_texprobe.txt` (Revision a6a8acb8; 30 `[texprobe]` lines), 76 autoshots
(`run279_sheet_0..1.png`). Stubs off (0 `substituting`). User: "worse - more whitewash and worse
performance." Measured: hdrprobe race-window mean of `>1e3` pixels 65 162 (run 278, five shaders
stubbed) -> 79 961 (run 279, nothing stubbed): the five shaders were back, so more hot draws - the
expected difference, not a regression. Submits per 2 s window 8-29 in both runs.

**1. Three hot draws, three censuses of the SAME inputs, the SAME answer every time.** Frame 2450
`#748 0x55ee56bf`, frame 2580 `#6 0x59a23308`, frame 2792 `#78 0x59a23308`. Every float image they
sample:

    0x10a6a1c100  64x64x2048 B10G11R11  max 65024 at (43,26) slice 985 | inf 0 nan 0 >1e3 28 >1e2 86
                                         zero 25 123 578 of 25 165 824 | mean 0.016 | 25 of the 28 in slice 985
    0x1002800000  64x64x1536 B10G11R11  max 1040 at (31,31) slice 22  | >1e3 156 >1e2 1260 | 91 % zero | mean 0.145
    0x1001800000  128x128x256 B10G11R11 max 102  at (63,92) slice 9   | >1e3 0 | 82 % zero | mean 0.178
    0x1000e7b800  128x128x2 RGBA16F (3D) max 2.25 | clean
    0x2900000000 7424x7424 D16, 0x100da10000 1024x1024x4 D32S8 = the shadow maps (not decoded); the
    30x17x16 froxel grid is R32G32Uint (light indices, not colour); the rest are BC7 materials.

Identical numbers in all three frames (t=91, 112, 133) - **the content is static**, so the 65024
is not a per-frame race. It is the ufloat11 MAXIMUM: whatever produced those 28 texels was >= 65024
or INF and got clamped by the encoder. In a probe array whose own sibling (`0x1002800000`, 256
cubemaps of 64x64) tops out at 1040 with its brightest texel dead centre of a face - a sun disc,
clamped by the game to about 1000 - 65024 is out of family.

**2. Why 28 texels wash a whole car.** The saturating shaders read `clamp(lit x 3.07e-5, 0, 65000)`,
so lit >= 2.1e9. A probe texel of 65024 alone is not that. Multiply it by the specular lobe of a
smooth surface (GGX D = 1 / (pi a^2): a = 0.005 -> 1.3e4; a = 0.001 -> 3e5) and it is - which is
why the CAR (mirror paint) is a white mass in every frame, why the stubbed trackside pieces were
hot (the terrain strips are glossy/wet in this scene), and why frames whose reflection vector misses
slice 985 come out clean. Two candidate faults, and the probe array decides between them:
(a) the array's hot texels should not exist (the compute pass that fills it wrote INF/huge, e.g. a
pre-exposure or normalisation constant it read from memory was 1 instead of 3e-5, or an input probe
capture was itself saturated); (b) the texels are legitimate and the SURFACE is wrong (roughness
decoded as 0 everywhere, making every material a mirror). (a) is favoured: the sibling array clamps
its sun at ~1000, and a roughness fault would not leave the ground rows at 1-10.

**3. Who writes it, and when.** `[imgnew] t=46s 0x10a6a1c100+0x2c00000 64x64x1 mips 7 layers 2048
B10G11R11` (45 MB, 7 mips); `[imgarr] t=46s ... up1/cp0/st308` then `t=48s ... up0/cp0/st3514`: one
CPU upload and **3 822 storage-image writes by COMPUTE shaders during the level load**, never again.
That is why run 279's producer check (armed only inside probed frames, all after t=91) logged
nothing: the writer ran once, 45 s before the first probe. The sibling `0x1002800000` (1536 layers,
1 mip) was registered at t=47 the same way.

**4. Not resolved here, noted:** the intro scene (user's screenshot, t=52-54) shows two large BLACK
wedges across the frame - clipped/culled geometry of a different kind (a sky or terrain triangle);
and the sky dome `f335b5c7` again drew only in the frames whose probed buffer was the scene target.

## RUN 280 (pre-declared) - `GT_HDR_TEXWATCH`: the compute shader that fills the probe array, and what it writes

Build 00:34 (`GT7_probe280.bat` = probe 279 + `GT_HDR_TEXWATCH=0x10a6a1c100,0x1002800000`).
`Rasterizer::MaybeProducerProbe` runs at EVERY dispatch (both `DispatchDirect` and
`DispatchIndirect`, before `MaybeDispatchProbe`, no frame gate): the watch list seeds the hot-input
set at the first dispatch; any dispatch whose compute stage binds a watched image as WRITTEN logs
`[texprobe] t=..s frame F producer #N of va: direct|indirect dispatch XxYxZ cs HASH writes WxHxL fD |
T#s:... | n V#s` for the first 40 writes and every 500th, and runs `TexProbe` on the array right
after the 1st and every 500th write (`after producer #N (cs HASH)`), so the value the writer leaves
behind is read before anything else touches it. Verdicts:
- the first producer census already shows 65024 in slice 985 -> the compute shader writes it; its
  hash is in the line -> `GT_DUMP_HASHES` it next run, read its inputs (its T#s are in the line: a
  source probe capture? an equirect sky? the array's own mip 0?) and its constants.
- the early censuses are sane and the 65024 appears at a later count -> a specific pass (a mip
  generation, a later re-light) introduces it; the producer number brackets it.
- the census is sane after the last write and 65024 only at the first hot draw -> something other
  than compute wrote it (a draw with the array as an attachment, or a CPU upload): grep `[imgup]`
  for `up1` on that address and add a colour-attachment watch.
- no producer lines at all -> the writes go through a path `GtDrawProbeNoteImage` does not see
  (bindless / BDA image store) - then use the `[imgarr]` counter's own hook to attribute them.

## RUN 280 VERDICT (4 Sep 00:38-00:41, Music Rally, chase camera, no hang) - THE CLOBBER DOOR: the array's garbage tracks WHEN its single CPU upload lands

Log `GT7_work/logs/run280_texwatch.txt` (Revision 5f93b625; 32 `[texprobe]` lines, 2 of them
`producer #`). User: "performance even worse, blind light even worse." Both are true and both are
explained below.

**1. The same array, the same scene, twenty times more garbage.** Censused at three hot draws
(t=146.9 / 168.0 / 189.2, frames 2137 / 2331 / 2494 - all identical to each other):

    0x10a6a1c100  64x64x2048 B10G11R11, 7 mips
    run 279:  max 65024 at (43,26) slice 985 | >1e3     28 | >1e2     86 | mean  0.016 | 25 hot in slice 985
    run 280:  max 65024 at (43,26) slice 985 | >1e3  68838 | >1e2  70828 | mean 12.05  | 12284 hot in slice 57

Slice 57 has **12 284 of its 12 288 values above 1000** - a whole 64x64 slice of nothing but huge
numbers. That is not lighting. The max and its position are byte-identical between the two runs
(so part of the content is deterministic), while the POPULATION differs by a factor of 2 400. The
sibling arrays are unchanged in both runs: `0x1002800000` max 1040, `0x1001800000` max 102,
`0x1000e7b800` max 2.25. And the hdrprobe agrees with the user's eye: race-window mean of `>1e3`
pixels **79 961 (run 279) -> 160 499 (run 280)**.

**2. What decides it: WHEN the single CPU upload lands.** `[imgarr]` reports this array exactly
twice per session - one window with an upload, one without:

    run 279:  t=46s  up1/cp0/st308      then  t=48s  up0/cp0/st3514
    run 280:  t=101s up1/cp0/st1911     then  t=103s up0/cp0/st1911

`up1` = **one upload from guest RAM per session**; `stN` = the compute storage writes that fill it.
In run 279 the upload landed at the level load and the game's compute pass kept writing over it
(308 -> 3822 writes), leaving 28 hot values. In run 280 the upload landed at t=101, **inside the
race**, after those writes - and every census afterwards (t >= 146) reads the garbage. **The upload
is the clobber door, and the wash's severity is simply how much of it the game happened to
overwrite.** That is also the answer to a question open since Act 1: why the whitewash varies from
session to session with no code change.

**3. The producer is still unnamed, and the reason matters.** Only 2 producer lines fired, both for
`0x10b18d9700` (80x32x40 B10G11R11, cs `0xe3dae865`, dispatch 10x4x40) - an unrelated small volume
a hot draw sampled, and it is CLEAN (max 0.6562, 0 values over 100). Nothing was logged writing the
probe array although `[imgarr]` counts 1 911 storage writes to it, so those writes do not pass
through the per-descriptor bind loop `GtDrawProbeNoteImage` hooks: GT7 reaches these arrays through
the **bindless image-array path** (`GT_BINDLESS_IMGARRAY=16`, the windowed T# tables this project
already built machinery for). Naming the compute shader needs a hook there - and the fix below does
not depend on it.

**4. Performance.** Race submits per 2 s window **11-29**, the same band as runs 278 (10-28) and
279 (8-29); the intro ran 85-121. What the user felt is the instrument, not the game: the per-draw
lattice probe does a `scheduler.Finish()` per draw on frames with up to 1 073 draws into the target,
and `GT_HDR_TEXPROBE` downloads 33 MB + 18 MB + 12 MB per hot draw. Both are off or rare in run 281.

## RUN 281 (pre-declared) - `GT_IMGZERO=1`: refuse that upload. THE FIX ATTEMPT

Build 18:47 (`GT7_probe281.bat` = probe 280 + `GT_IMGZERO=1`, `GT_HDR_DRAWPROBE=` EMPTY,
`GT_WATCH_VA=0x10a6a1c100 GT_WATCH_SIZE=0x2c00000`). In `TextureCache::RefreshImage`
(texture_cache.cpp, right before `RENDERER_TRACE`), an image shaped like the probe array
(64x64, B10G11R11, `layers >= 512`, **`levels >= 2`**, not a volume) is **cleared to zero instead of
being uploaded from guest RAM**, then marked GpuModified with its mip-hash baseline recorded and the
dirt consumed - the same shape of argument as `GT_LUT_IDENT`'s identity seed: guest RAM is never the
truth for an image only compute ever writes. The `levels >= 2` term is what leaves the HEALTHY
one-mip sibling alone. The log line reports what the refused bytes held (`the refused bytes held N
of M texels above 1e3, K non-zero, max V`), decoded from guest RAM on the CPU - so the claim is
proven from the bytes themselves, with no GPU download. The per-draw probe is off so the game is
playable and the picture is the measurement.

⚠ This is a WORKAROUND, not the upstream fix. The real question it raises: if GT7 fills this array
purely on the GPU, shadPS4 should never upload it at all - the general rule (`a dirty image is
re-uploaded from guest memory, no questions asked`) is what needs narrowing, and this is the third
image class to hit it after the grading LUT and the render targets.

Verdicts:
- the blinding light collapses (hdrprobe race `>1e3` falls from ~1e5 to ~1e3 or less) and the scene
  is readable -> the upload was the whole mechanism. Then: make it precise (clear ONCE, then consume
  the dirt without clearing, so a mid-race refresh cannot erase what compute has written), and take
  the same question to the sibling arrays.
- the wash stays -> either the zeros are being clobbered again by a refresh the predicate misses
  (the `[aewatch] upload 0x10a6a1c100 ... dw:` lines now print for every upload of that range - read
  them), or the array is not the only carrier.
- reflections go dark / the car turns matte and `[imgzero] #N` is a large number -> the clear is
  firing on every refresh and erasing compute content; that is the "clear once" change above.
- only `[imgzero] NOT zeroing ... GPU content pending` appears -> the uploading refresh is
  `gpu_only` after all, so the door is the orphan-GpuDirty one and `GT_GPUWRITE_NOCLOBBER=1` (already
  implemented, currently 0) is the flip to try instead.

## RUN 281 VERDICT (4 Sep 18:58-19:01, Music Rally, HUNG at t~136 s) - THE FIX FAILED AND ITS OWN LOG LINE SAYS WHY; THE REAL FINGERPRINT IS **NaN**, AND IT IS THE SKY

Log `GT7_work/logs/run281_imgzero.txt` (Revision ee1aad08 = HEAD at build time, so the 18:47 build
predates commit 62f3e5ef - correct for this run), stuck dump
`logs/stuckstack_20260904_185949.txt`, 36 screenshots at 18:58-18:59. User: "game stuck i run stuck
bat and multiple screenshot where drawn."

### 1. GT_IMGZERO worked mechanically and changed nothing, because the upload it blocked was EMPTY

It fired exactly once, and the line it printed is the whole verdict:

    [imgzero] #1 zeroed probe array 0x10a6a1c100 64x64x2048 7 mip(s) instead of uploading guest RAM
    (maybe-CPU dirty) | the refused bytes held 0 of 8388608 texels above 1e3, 0 non-zero, max 0

**All zero.** Eight million texels, not one of them non-zero. So the run-280 story - "the array's
garbage comes from a single CPU upload of uninitialised guest RAM, and the wash's severity tracks
when that upload lands" - is refuted by the very instrument built to exploit it. The 65024s that
run 279's census really did find in that image cannot have arrived from guest memory; they can only
have come from the ~1900-3800 compute storage writes `[imgarr]` counts. **The CPU upload path is
exonerated and that lane is closed.**

The saturation is unchanged. Measured the same way in every run - the two B10G11R11 scene targets
only, 1920x1080 in ALL FIVE runs (checked, because an absolute pixel count across runs of different
resolution would have been meaningless), one row per `[hdrprobe]` tick:

    run      ticks  SAT  clean  mid   max L      hot px per SATURATED tick (of 2073600)
    277        64    47    15     2   6.502e+04  avg 76131 = 3.67%   worst 1050802
    278        72    51    16     5   6.502e+04  avg 71775 = 3.46%   worst  815140
    279        81    59    20     2   6.502e+04  avg 77542 = 3.74%   worst 1279808
    280        64    53    10     1   6.502e+04  avg 96081 = 4.63%   worst 1275750
    281        26    14    12     0   6.502e+04  avg 70781 = 3.41%   worst  260062

Same 65024 maximum, same 3.4-4.6% hot fraction. The one number that moved - 14 of 26 ticks
saturated against 47-59 of 64-81 - is on a quarter of the sample and a session that spent
proportionally more time in menus, so **treat the whitewash as UNCHANGED**. (A parallel
time-matched slice put run 281 at 53.8% against a 47.1% pooled baseline, i.e. slightly WORSE. The
two framings disagree on the sign of a small change; neither shows an improvement, and that is the
only claim worth making.) ⚠ The run-280 verdict's "race-window mean of >1e3 pixels 79 961 ->
160 499" is a differently-sliced statistic from the table above; the direction agrees, the
magnitudes do not, and the table is the one to reproduce because its extraction is stated.

### 2. THE FINGERPRINT WAS IN THE LOG ALL ALONG: NaN, in exactly two targets

Every `[hdrprobe]` line has ended with `inf N nan N` since the probe was written, and no session had
ever read the second number. Pooled over runs 277-281:

    va             res        format     ticks  w/ NaN   worst NaN px
    0x10085f0000   1920x1080  RGBA16F      76      45     2073600  <- THE ENTIRE FRAME
    0x1007600000   1920x1080  RGBA16F      81      47     2039133
    0x1005000000   1920x1080  B10G11R11   164       0           0
    0x1006bc8000   1920x1080  B10G11R11   143       0           0
    ... 15 more targets, 600+ ticks .....................         0

**Two full-resolution RGBA16F targets are NaN in ~58% of the ticks that measured them. No other
target in the project has ever contained a single NaN.** Present in every run since 277, at a
comparable per-tick rate (8.6 / 10.5 / 11.2 / 8.9 / 12.3% of all ticks), so it is long-standing and
no recent change caused it. Run 279 has a tick where all 2 073 600 pixels are NaN **and the reported
maximum is -1** - a negative luminance, which is what max-tracking returns when every comparison
against NaN is false.

Three more properties of those two targets that the 65024 story never explained:

- they reach **6.55e+04 = 65504, the fp16 MAXIMUM** - a *different* number from the 65024 the search
  has been chasing (the ufloat11 maximum) and from the 65000 the game's own shaders clamp to. Two
  formats each pinned at *their own* ceiling is the signature of a value that is astronomically
  large or infinite, not of a game clamp;
- they carry **negative** components (`rgb=(6.55e+04 0.3765 -0.1187)`);
- they saturate in frames where the B10G11R11 scene target is perfectly clean: frame 2132 scene
  max L **0.9766** while `0x1007600000` reads 65504 with 21 931 NaN; frame 2231 scene max L **1**
  while `0x10085f0000` reads 65504 with 409 262 NaN. **So the saturation does not propagate from the
  scene target. It has its own source.**

### 3. AND IT IS THE SKY - which joins up three findings that never met

The 12x6 frame grid says where. Pooled over all five runs, 92 ticks that contain NaN, counting
`N` cells per grid row:

    row 1 (TOP)     184 cells  11.6%
    row 2           377 cells  23.8%
    row 3           511 cells  32.3%   <-- 78.7% of all NaN is in rows 2-4
    row 4           358 cells  22.6%
    row 5            95 cells   6.0%
    row 6 (BOTTOM)   57 cells   3.6%

The NaN sits in the upper half and the horizon band, with ordinary scene values (`2`/`3` = 10-1000)
underneath. A typical grid, frame 2255:

    NNNNNNNNNNNN
    NNNNNNNNNNNN
    5NN5NNNNNNN2
    22255NN52222
    333322223333
    333333333333

That is the sky. And it closes the loop on three earlier findings that were each recorded and never
joined together: **run 275 "NO DRAW WRITES THE SKY"**, **run 277 "the sky dome is a draw that is
sometimes not there"**, and this run's own screenshots, in which the sky is the game's **magenta
clear** (measured at RGB 210,0,172) in 2 of 14 race frames and part-magenta in 3 more. ⚠ The clear
colour is (210,0,172) after tonemapping, NOT (255,0,255) - a magenta test written as `b > 200`
reports 0.0% on a frame that is 96% magenta, which it did here first time round.

**ONE defect, three symptoms.** The sky region is never properly written; it holds either the
magenta clear or NaN; bloom then averages that region into the whole frame (measured: the 480x270
and 960x540 bloom mips run to 1.1e4 with means of 235-7050, and one fp16 composite reaches a
**full-frame mean of 6490**), and the tonemapper maps the result to white. The light-probe array's
65024s are the same defect seen from a third side - the probe bake integrates that sky. **This is
why stubbing the five hot pixel shaders (run 278) and zeroing the probe array (run 281) both changed
nothing: both were downstream of it.**

Screenshot census, 36 frames, per region (magenta = the measured clear colour, white = blown):

    #20 t=98.4   WHITEWASH  sky 100.0% white         ground 77.8% white
    #21 t=100.4  mixed      sky   7.8% magenta       ground 31.8% magenta   trees+road drawn
    #23 t=104.5  mixed      sky  10.6% magenta       ground 25.6% magenta
    #24 t=107.7  WHITEWASH  sky  93.4% white         ground 70.8% white
    #28 t=120.0  MAGENTA    sky  75.6% magenta       ground 95.7% magenta   HUD only
    #30 t=124.2  MAGENTA    sky  74.2% magenta       ground 77.7% magenta
    #31-35       WHITEWASH  sky  59-73% white        ground 69-89% white    car driving, HUD perfect

⚠ **The road, the grass and the HUD render CORRECTLY.** Frame #29 (`zoom281_29.png`) shows grey
asphalt with a white line, a green verge, and a crisp readable HUD, with the wash radiating from
discrete point sources at the horizon and magenta sky to the left. The renderer is not broken; a
region of it is poisoned.

### 4. THE HANG IS A SELF-DEADLOCK - diagnosed completely, PRE-EXISTING, and fixed in the run-282 build

`stuckstack_20260904_185949.txt`, pid 8432, **WS 14.8 GB**: `tid 11932 shadPS4:GpuCommandProcessor
cpu+ 3219ms/3s Running` - 107% of one core, **spinning**, top frame `Common::SpinLock::lock+0x45`.
Every other thread is idle in a wait, and **no other thread appears anywhere in
SpinLock/MemoryTracker/BufferCache**, so it is a SELF-deadlock, not a cycle. The stack is the whole
diagnosis, read bottom-up:

    Liverpool::Process -> ProcessCompute -> Rasterizer::DispatchDirect -> BindResources
      -> BindBuffers -> BufferCache::ObtainBuffer -> SynchronizeBuffer -> SynchronizeBufferSpan
      -> UploadCopies -> MemoryManager::CopySparseMemory
      -> [ntdll KiUserExceptionDispatcher]            <-- guest page fault, delivered INLINE
      -> Core::SignalHandler -> DispatchAccessViolation -> PageManager::GuestFaultSignalHandler
      -> Rasterizer::ReadMemory -> BufferCache::ReadMemory -> DownloadBufferMemory
      -> MemoryTracker::IteratePages<0, lambda at memory_tracker.h:207>
      -> Common::SpinLock::lock                       <-- SPINS FOR EVER

`MemoryTracker::ForEachUploadRange` takes each spanned `RegionManager`'s **non-recursive** spin lock
in its first pass and, **when `is_written`, deliberately does not release it** until a second pass
*after* `on_upload()` (memory_tracker.h:184-199). `on_upload()` is where `UploadCopies` runs
`CopySparseMemory` over guest memory. A read-protected page in that range faults inline on the same
thread, and the handler re-enters the tracker through `ForEachDownloadRange`
(memory_tracker.h:207), whose `scoped_lock` takes the lock this thread already holds. Regions are
4 MB and the locked set covers the copy's source, so the faulting page's manager is necessarily
among them.

**Not a regression from GT_IMGZERO**, on four independent grounds: no `texture_cache` frame appears
on the stack; HEAD 62f3e5ef touched no file on it (`grep buffer_cache|memory_tracker|page_manager|
rasterizer` in that commit: no match); `[imgzero]` fired once at t~95 s, **41 s and ~261 frames
before** the hang; and the identical stack site at identical offsets is already in
`stuckstack_20260903_223137.txt`, from before the change existed. The pattern is **upstream**
(commit 2d1a2982, "buffer_cache: Bring back upload batching and temporary buffer #3211"). Its
precondition is the read protection the readbacks arm mid-race (`readbacks mode 0 -> 2`, which every
run since 271 does exactly once); run 281 took **hundreds of READ faults per 2 s window for 31 s**
(~1.3% of all faults) before one landed inside the critical section.

⚠ **Distinguish it from run 271's hang by the CPU column, not the stack shape.** Run 271 sat in
`DownloadBufferMemory -> Scheduler::Finish -> MasterSemaphore::Wait` at **0 ms/3 s** - waiting on a
GPU fence. This one burns **3219 ms/3 s**. Same function, opposite mechanism, opposite fix. A useful
second discriminator is the log's orphan tail (lines after the last `GpuCommandProcessor` line):
run 271 16 568, run 281 **5 737**, non-hanging runs 9-64.

### 5. Two instrument faults worth fixing

- **`GT_HDR_TEXPROBE=1` and `GT_HDR_TEXWATCH` produced ZERO lines.** Not "the array is clean" -
  the producer probe walks `g_drawprobe.cs_images`, which `GtDrawProbeNoteImage` fills only when
  `g_drawprobe.active_frame != 0`, i.e. only inside a frame the **per-draw probe** armed. Turning
  `GT_HDR_DRAWPROBE` off to make the game playable turned the texture census's eyes off with it.
  A one-line fix (let the noting run when `GtTexProbeEnabled()`, clearing per dispatch) would
  restore it - and even then it would still miss these arrays, which arrive through the bindless
  image-array path the run-280 verdict names.
- **`-run=`-style argument shadowing, again**: nothing new here, but the `[imgarray]` null-slot
  census still fires 23 lines on two shaders (`0x3e50e1` 5/16 null over 1280 binds, `0xa95f906e`
  15/16 over 512), with `late 0/15` and `late 0/5` - the nulls never fill in. **Do not resurrect the
  null-slot theory**: the ACT 11 VERDICT killed it by measurement (cs_a95f906e dispatches 1x1x1, so
  slots 1-15 are never addressed; 18 GT_IMGARRAY_SYNC attempts moved valid 1/16 -> 1/16).

### 6. ADVERSARIAL AUDIT OF THIS VERY VERDICT - five corrections, and the fix was already in the tree

Six agents were pointed at the logs and the source and told to REFUTE the verdict above, not confirm
it. Eleven refutation verdicts came back. **Five overturned something written above**, so it is
corrected here rather than silently edited - the wrong version is what a future session would
otherwise re-derive.

**(a) "Every other thread is idle in a wait" is FALSE.** `grep -- '--- tid' | grep -v 'Wait/'` over
all 275 thread records returns **four** Running threads, three of them burning a full core:

    tid 15140  Job#37                       cpu+ 3406ms/3s  Running   <- HIGHEST of all
    tid 29624  tm_ffb_eventHandleThread     cpu+ 3359ms/3s  Running
    tid 11932  shadPS4:GpuCommandProcessor  cpu+ 3219ms/3s  Running   <- only THIRD
    tid 28800  SceSndzAudioOutMain          cpu+  453ms/3s  Running

The self-deadlock claim survives - **no other thread appears anywhere in
SpinLock/MemoryTracker/BufferCache**, which is the load-bearing observation - but "everything else is
idle" is not what the dump says. `Job#37` at 100% is guest code spinning on a word the GPU will never
write (run 271's own signature), i.e. a CONSEQUENCE.

**(b) The zero census covered MIP 0 ONLY - 75% of the array, not all of it.** The refused upload is
`0x2c00000` = 46 137 344 bytes over all 7 mips (`[imgnew] t=95s 0x10a6a1c100+0x2c00000 ... mips 7
layers 2048`), while the scan reads `mips_layout[0]` bounded by `min(mip0_size/4, 8u<<20)` =
8 388 608 texels = 33 554 432 bytes. **Mips 1-6 were never scanned.** One refuter did independently
derive that mip 0 carries ZERO tiling padding (tile mode 13 -> `ImageSizeMicroTiled`, micro extent
8x8, logged pitch 64 -> `mip0_size` exactly 33 554 432), so 8 388 608 is exactly 64x64x2048 and lands
*on* the cap rather than being truncated by it. So the honest claim is: **mip 0, 75% of the array's
texels, was entirely zero.** The conclusion (the CPU upload is not the carrier) still holds, because
mip 0 is where the census found the 65024s.

**(c) `Common::SpinLock` is NOT used in the rasterizer, and this codebase ALREADY HAS a recursive
lock.** `src/common/spin_lock.h` is a bare `std::atomic_flag` - `while (lck.test_and_set(acquire))
ThreadPause();`, no owner, no count - so re-entry self-deadlocks; that part is confirmed. But it
appears only at `buffer_cache/region_manager.h:26` and in `page_manager.cpp`; the rasterizer's
`mapped_ranges_mutex` is a `Common::SharedFirstMutex`. **And `common/recursive_lock.h` exists**, with
`thread_local std::unordered_map<void*, RecursiveLockState>` owner tracking and a recursion count,
used at `vk_rasterizer.cpp:2133/:4898/:4942`. ⚠ **So a cleaner fix than the thread_local guard
probably exists**: give `RegionManager::lock` recursion awareness, or use the existing facility.
The guard shipped because it is the minimal change that provably removes the hang; the better fix is
a follow-up, and the `[reentry]` counter is what will justify it.

**(d) The saturation table's framing is misleading, though its numbers reproduce.** A time-matched
window (the first 38.7 s from each run's own first HDR-target probe, since the runs' first probes are
at t=45.0/46.2/48.3/103.1/97.4 so absolute time is unusable; both HDR VAs, every row 1920x1080)
gives the SAT rate as **277 57.1% / 278 50.0% / 279 33.3% / 280 59.3% / 281 53.8%, pooled baseline
50.0%**. Run 281 is **mid-range, and the HIGHEST of all five for `0x1005000000` alone (61.5%)**. The
"14 of 26 against 47-59 of 64-81" framing above compares windows of different length and should not
be read as an improvement. **The defensible claim is: no detectable change, and the run cannot
support a verdict on the hypothesis either way** - which is a stronger statement of the same result.

**(e) The `st` counters are per-2-second windows that RESET** (`image.cpp:151-155` ends `MaybeFlush()`
with `window.clear(); total_uploads = total_copies = total_stores = 0;`), so the run-280 verdict's
`st1911 -> st1911` and this run's `st2416 -> st1406` are not comparable as quoted. **Summed, they are
3822 in every one of runs 277-281** - identical - as are 1248/462/138 for the three sibling arrays,
and **only 4 of the 29 arrays `[imgarr]` reports have `st > 0`**, all four multi-layer B10G11R11.
⚠ And `st` counts **write-capable bindings (MarkGpuWritten events), not texel writes**, and they are
not established to be compute. Calling them "compute storage writes" throughout this file is an
overstatement.

### 7. ⚠⚠⚠ THE MECHANISM AND THE FIX WERE ALREADY IN THIS TREE, WRITTEN DOWN, AND SWITCHED HALF ON

The audit's most valuable finding is not a correction. `src/shader_recompiler/backend/spirv/
emit_spirv_image.cpp:376-381`, in this project's own hand, months of runs ago:

    // GT_IMGWRITE_SCRUB: contain Inf/NaN at the storage-image write boundary. A poisoned
    // light probe or bloom mip floods the whole frame white (the ramp over 2-3 s is the
    // probe filling face by face), and the dump analysis found a concrete NaN factory:
    // cs_da05e7f8 normalizes sample directions read from a dynrc window that can be all
    // zero at record time - normalize(0) = Inf/NaN, accumulated and written per mip. This
    // turns NaN into 0 and clamps to the fp16 range, so one bad dispatch's write cannot
    // permanently poison a persistent target.

**`normalize(0) = NaN`, in a compute shader, accumulated and written per mip into the light probe.**
That is the NaN this verdict measured, the white flood it describes, and even the 2-3 s ramp - all
diagnosed already. `cs_da05e7f8` is the same shader runs 46/47/95-98 wrestled with (it is the
PRODUCER whose stub removed the `ReadInvalid 0x300100000` fault). And there are TWO containment
switches for it:

    GT_IMGWRITE_SCRUB   storage-image writes (OpImageWrite)  ON by default (run_gt7.ps1:466)
    GT_RT_SCRUB         fragment render-target outputs       ON but SCOPED TO ONE HASH, 92126594

`emit_spirv_context_get_set.cpp:52` states it plainly: **"GT_RT_SCRUB=1 enables poisoned
render-target containment for every fragment shader. A comma-separated hexadecimal hash list limits
it to named shaders."** It has been limited to one - GT7's foliage shader `fs_92126594`, "measured
writing exactly 65000 to 10 563 pixels in one draw". **So the storage path has been guarded all
along and the FRAGMENT path into the two NaN-carrying RGBA16F colour attachments has been
essentially unguarded**, which is exactly consistent with what runs 277-281 measured.

**(f) And GT_ZERO_VRAM had already zeroed the array at construction.** `image.cpp:175-179`:
"GT_ZERO_VRAM: unset/1 = every clearable color image starts ZEROED". It is unset in every probe
.bat, therefore ON. **Run 281's clear-to-zero was a second zeroing of an already-zero image** - a
no-op twice over, and knowable from the tree before the fix was written. ⚠ Check for an existing
switch before building a new one; this is the second time (`GT_GPUWRITE_NOCLOBBER`,
`GT_LUT_IDENT`, `GT_RT_FORCECLEAR` and now `GT_ZERO_VRAM`/`GT_RT_SCRUB` are all pre-built doors).

### 8. Two more findings from the audit worth keeping

- **The largest single saturation event in the whole dataset is a draw that binds NO TEXTURES AT
  ALL.** That refutes every texture-based story for the wash on its own, including the probe-array
  one this run was built to test.
- **The shaders write the array as 231 layers where the cache allocated 2048.** 1817 layers are
  therefore never written by anything - they hold whatever construction left, which `GT_ZERO_VRAM`
  makes zero. A layer-count mismatch between what the guest addresses and what the emulator
  allocates is its own bug and has not been chased.
- **Performance: run 281 is the first honest number since 277** - race phase **14.53 fps against
  8.33 / 8.77** in runs 279/280 - though on frames carrying **31% fewer draws**, so it is not a clean
  2x. The per-draw probe really was most of what the user felt in runs 278-280.

## RUN 282 (pre-declared) - the deadlock guard, and `GT_RT_SCRUB=1`: the containment that exists, finally applied to every shader

Build 19:19. Two changes, and the second one is a **fix attempt, not a measurement** - the user has
asked for the colours three runs running.

**A. The deadlock (a blocker fix, always on, not env-gated).** New header
`src/video_core/buffer_cache/tracker_reentry.h`: `VideoCore::TrackerReentry` is a thread_local depth
counter (a counter, not a flag - the window nests across a multi-buffer span walk) with its
definitions in `page_manager.cpp`. `MemoryTracker::ForEachUploadRange` arms `TrackerReentry::Scope`
for its whole body, and `PageManager::GuestFaultSignalHandler` **refuses to call into the rasterizer
while `TrackerReentry::Inside()`**, returning false so the fault falls through unclaimed instead of
self-deadlocking, and logging

    [reentry] refused a READ|WRITE fault at 0x... from inside the buffer cache's upload window -
    servicing it would self-deadlock on the region lock (N refused so far)

first 8 then 1 in 1024. A rare stale read is strictly better than a permanent 100%-CPU hang, and the
counter is what will justify the better fix - which, per audit item (c), is probably to give
`RegionManager::lock` the recursion awareness `common/recursive_lock.h` already implements, or to
pre-touch the copy source before the locks are taken so no fault can occur inside the window at all.
Both change behaviour, so neither is in this run.

**B. `GT_RT_SCRUB=1`.** Was not in the .bat at all - `run_gt7.ps1:473` sets it to the single hash
`92126594` through `Set-GtDefault`, which only assigns when the variable is UNSET (`run_gt7.ps1:38`),
so writing it in the .bat wins. At `1` the emitter contains poisoned outputs for **every** fragment
shader: NaN becomes 0 and everything is clamped to +-65504 at the colour-output boundary, while
ordinary finite HDR is untouched. This is the one path the measurements say is unguarded, and it is a
one-value change to machinery that already shipped.

The per-draw probe stays **OFF** (`GT_HDR_DRAWPROBE=` empty): a scrubbed NaN cannot be traced back to
its producer, so pointing the probe at the fp16 targets in the same run would cancel this experiment.
Naming the individual shader is run 283's job **and only if this run fails**. `GT_IMGZERO=0`,
`GT_HDR_TEXPROBE=0`, `GT_HDR_TEXWATCH=`, `GT_HDR_DRAWPROBE_PS=` all cleared.

Verdicts, pre-declared:
- **the wash collapses and the scene is readable** -> the mechanism is proven end to end and this is
  a shipping fix. Then NARROW it: run 283 with the per-draw probe on the fp16 targets names the
  offending shader, and `GT_RT_SCRUB=<that hash>` restores full precision everywhere else.
- **the picture goes DARK or DULL instead of white** -> that is still a WIN and means the same thing:
  the scrub is on the right path and is now removing real signal along with the NaN. Then the
  surgical version above is required rather than optional.
- **nothing changes at all** -> the NaN does not arrive through a fragment shader's colour output.
  Then it is a COPY, a RESOLVE, a CLEAR or a compute write to those targets: `GT_CLEAR_RAW=1` and
  `GT_RESOLVE_SWAP=1` are both on and are the first suspects, and run 252's finding that "GT7 never
  issues COND_EXEC, so the HDR fast clear is never honoured" is the second. Run 283 then aims the
  per-draw probe at `0x1007600000,0x10085f0000` (**no new code needed**: `ProbeLattice` already
  decodes `eR16G16B16A16Sfloat` at vk_rasterizer.cpp:3635 and already prints `N` for NaN) and reads
  whether the lattice is already `N` at the arm-time baseline - which would mean nothing writes that
  region at all.
- **`[reentry]` lines appear** -> the deadlock class is real and was being hit; the count sizes the
  proper fix. **No `[reentry]` line and no hang** -> it is rarer than one run, and the guard costs
  one thread_local increment while we wait.
- **it hangs anyway** -> new stuck dump, and compare the TOP FRAME: `SpinLock::lock` means the guard
  has a hole (another lock-holding window - `ForEachDownloadRange` itself, or `ForEachModifiedRange`),
  `MasterSemaphore::Wait` at 0 ms/3 s means it is run 271's mechanism instead. ⚠ Judge by the CPU
  column, not the stack shape.

## RUN 282 VERDICT (5 Sep 17:07-17:15, Music Rally x2 -> World Map, CRASHED at t~514 s) - THE WHITEWASH IS FIXED; the crash was the guard's fallback; the lag is shader compilation

Log `GT7_work/logs/run282_rtscrub.txt` (198 534 lines; Revision 62f3e5ef = HEAD at build time, so
the 19:19 build carries the re-entrancy guard and predates commits 24736eea/62048c89 - correct for
this run). Four stuck dumps `logs/stuckstack_20260905_170839 / 170858 / 170948 / 171351.txt`,
`guest_crash.dmp` written at 17:15, 131 screenshots `CUSA24769_20260905_17*`. User: *"game
crashed. this run was visually the best we had so far. more detail on everything. all items are
built eventually and shown. no blinding light it became purple instead. i had a lot worse lag
experience less fps and the game got stuck in multiple places... the game crashed trying to enter
the race events on the main game."* Every clause of that is confirmed below, with a number.

### 1. THE WHITEWASH IS FIXED - `GT_RT_SCRUB=1`, one env value, and the NaN is gone everywhere

The census that found the fingerprint in run 281 now reads clean on **every** target:

    va             res        fmt          ticks  w/NaN  maxNaN    maxL        (run 281 w/NaN)
    0x1005000000   1920x1080  B10G11R11      83      0       0   6.093e+04
    0x1006bc8000   1920x1080  B10G11R11      82      0       0   5.99e+04
    0x10085f0000   1920x1080  RGBA16F        50      0       0   1.702e+04    (45 of 76)
    0x1007600000   1920x1080  RGBA16F        35      0       0   5.99e+04     (47 of 81)
    0x100a2f0000   480x270    B10G11R11      65      0       0   97           (bloom mip; was 1.1e4)
    ... 12 more targets ...............................  0       0

Scene-target ticks with max L > 1e4: **19 of 165 (11.5%)** against 54-83% in runs 277-281 - and
those 19 carry **28-410 hot pixels each (0.00-0.02% of 2 073 600)** where every earlier run carried
70 000-96 000 per saturated tick. A few hundred pixels at 1e4-6e4 is a sun disc, which is correct
HDR content. The bloom chain is sane (max 0-97, was 1.1e4).

**The pictures agree, by the same census as run 281** (384x216, white = r>244 g>240 b>235, magenta
= the measured clear (210,0,172) band), race frames only:

                blown-white   magenta   WHITEWASH  MAGENTA  mixed  clean   mean brightness
    run 281  16 frames   44.0%    13.7%       9         2       3      2      172
    run 282  63 frames    2.0%    14.9%       0        14      16     33       63

**Blown white 44% -> 2%, WHITEWASH-class frames 9 of 16 -> 0 of 63, clean frames 2 -> 33.** The
magenta fraction is UNCHANGED (13.7 -> 14.9%): that is the HDR clear colour where the sky dome is
not drawn, the pre-existing defect runs 275/277 measured, which the white used to hide and which is
now the top visual defect. It is a different bug from the one just fixed (see 5).

What the frames show (contact sheets `sheet282_0..3.png`): the intro flyover with correct mountains;
the cockpit with dashboard, gauges and wheel; **two full Music Rally races** in chase cam - asphalt,
yellow centre line, kerbs, grass, trees, barriers, advertising boards, grandstands, an opponent Mini
Cooper - the "THAT'S A SHAME" result card; the *"Do you wish to begin Gran Turismo 7?"* dialog; and
then **the World Map of the main game, rendered correctly** (sunset, mountains, lake, buildings,
the *"You are currently offline"* tooltip) - the furthest this project has ever got with a correct
picture. In frames #92-#93 the sky IS drawn (blue, clouds), so the sky dome sometimes exists,
exactly as run 277 said.

⚠ Honest wording: `GT_RT_SCRUB` is CONTAINMENT. It zeroes NaN and clamps to +-65504 at every
fragment shader's colour output; it does not touch the shader that produces the NaN
(`cs_da05e7f8`'s `normalize(0)` on an unwritten dynrc window, per this tree's own comment at
emit_spirv_image.cpp:376). The white is gone because the poison no longer reaches the targets. The
purple is what was underneath: a sky region nothing writes.

### 2. THE CRASH - the guard's return-false fallback, exactly the pre-declared risk

    198519  [reentry] refused a READ fault at 0x280800000 from inside the buffer cache's upload
            window - servicing it would self-deadlock on the region lock (1 refused so far)
    198521  Unhandled Exception code 0xc0000005 at 0x7ff90ea4c177 while reading 0x280800000

Same address, two lines apart, at t~513.8 s during the fade from the World Map into the race
events (screenshot #130). `Core::SignalDispatch::DispatchAccessViolation` (signals.cpp:425) walks
the handlers and returns false when none claims the fault; the caller treats that as fatal. **So
"return false" converted run 281's permanent deadlock into run 282's crash.** The guard fired
exactly once in 514 s, which is also the measurement of how often the deadlock hazard actually
bites: about once per session, late, under load (the copy was 4 MB - r8=rdi=r14=0x400000 in the
crash context, r9=0x280c00000 = the copy's end).

### 3. THE LAG - shader compilation, and the four "stucks" are not the deadlock

Frame rate from `[hdrprobe]` frame numbers: **0.5-8.9 fps through most of the race, 13.8 at
t=409** (run 281: ~14.5 in its race with the per-draw probe off). Lines matching `/compil/i`:
**17 894 against 6 982** in run 281 (2.6x). `GT_RT_SCRUB=1` changes the generated code of every
fragment shader (vk_pipeline_serialization.cpp:69 folds it into the cache key), so every fragment
shader compiled afresh.

The four stuck dumps, GpuCommandProcessor top frame and CPU column:

    17:08:39  AmdGpu::Liverpool::ProcessCompute<1>        3344 ms/3 s  Running     WS 12.9 GB
    17:08:58  nvgpucomp64.dll (NVIDIA shader compiler)    3172 ms/3 s  Running     WS 13.2 GB
    17:09:48  NtGdiDdDDIWaitForSynchronizationObjectFromCpu (nvoglv64)  2734 ms  Wait/Executive  14.3 GB
    17:13:51  nvgpucomp64.dll                             3188 ms/3 s  Running     WS 17.8 GB

**None is `Common::SpinLock` - the run-281 deadlock did not recur.** Two are the render thread
inside the driver's shader compiler (a stall, not a hang - the game recovered and the screenshots
continue), one is a GPU wait, one is the command processor working. ⚠ Judge by the CPU column:
3000+ ms/3 s is working or spinning, ~0 is waiting; the third dump's 2734 ms in a Wait state means
it was mostly working and was caught at the moment it waited. Working set grew 12.9 -> 17.8 GB in
five minutes. `Job#0` (guest) and `tm_ffb_eventHandleThread` (wheel driver) run at ~3300-3500 ms in
every dump - consequences of a slow render thread, not causes.

### 4. THE FIX IN THE RUN-283 BUILD - prevent the fault, and survive it

Both, belt and braces, in `page_manager.cpp` and `buffer_cache/buffer_cache.cpp`:

- **PRE-TOUCH** (`GT_UPLOAD_PRETOUCH`, default on): in `BufferCache::SynchronizeBufferSpan`, before
  `ForEachUploadRange` takes the region locks on the `is_written` path, read one byte per page of
  `[max(device_addr, buffer_start), min(device_addr+size, buffer_limit))`. A read-protected page
  then faults OUTSIDE the lock window and the normal handler services it properly - downloads the
  GPU data into guest RAM and unprotects the page - so the copy inside the window reads FRESH bytes
  and cannot fault. An unprotected page costs one load. Logs `[pretouch] N span(s) pre-touched, M
  pages` on the first span and every 4096th.
- **THE FALLBACK**: if a fault still lands inside the window, the guard now drops the read
  protection on that one page directly through `Core::Memory::Instance()->GetAddressSpace().
  ProtectGpuTracked(page, 4 KB, ReadWrite)` (the same call `PageManager::Protect` makes, no tracker
  lock anywhere on that path) and **returns true**, so the faulting memcpy retries and reads guest
  RAM as it stands. The tracker still believes the page is protected; `UpdateProtection` is
  self-healing per page (region_manager.h:87). One possibly-stale page read, counted in the
  `[reentry]` line, instead of a crash. The pre-touch should hold that count at zero; the count is
  how we will know.

### 5. What is NOT fixed, in order

1. **The sky dome** - magenta clear in 14 of 63 race frames, wedge-shaped in several (#90, #94,
   #96, #105: the magenta cuts diagonally into road and trees), fully drawn in others (#92-#93).
   A wedge means part of a mesh is clipped or culled, not that the draw is skipped. This is now the
   top visual defect and the next hunt; runs 275/277 hold what is known about the sky draw.
2. **The NaN producer** is contained, not cured. `cs_da05e7f8` still divides by zero on an
   unwritten dynrc window at record time; the scrub hides the result. Curing it means the window's
   producer (Acts 10-11's unwritten-table problem) - a separate, older thread.
3. **Performance.** Whether the compile storm is one-time (the pipeline cache persists the
   scrubbed variants) or per-process is what run 283's frame-rate timeline will say. If the cost is
   per-pixel and permanent, the scrub must be narrowed to the shader(s) that actually emit NaN -
   which needs one run with the scrub OFF and the per-draw probe on `0x1007600000,0x10085f0000` to
   name them. Not this run: the picture depends on the scrub being on.
4. The audit findings from the six-agent pass on this verdict follow in the next section.

## RUN 283 (pre-declared) - same picture, no crash

Build 17:27. `GT7_probe283.bat` = probe 282's env unchanged (`GT_RT_SCRUB=1`, per-draw probe
OFF) + the two code changes above. Route: Music Rally, then YES to "begin Gran Turismo 7", then the
race events from the World Map - the exact place it crashed.

Verdicts, pre-declared:
- **no crash, `[reentry]` count 0, `[pretouch]` lines present** -> the deadlock class is closed for
  good: the fault is now serviced where it belongs. Then the lane moves to the sky dome.
- **no crash, `[reentry]` count > 0** -> the pre-touch missed a path (a page re-protected between
  touch and copy, or a second lock-holding window); the fallback held. Read the addresses.
- **crash again at a DIFFERENT address with no `[reentry]` line** -> unrelated; get the stack.
- **frame rate recovers over the session** (fps rising as compile lines stop) -> the storm is
  one-time and `GT_RT_SCRUB=1` can ship. **Flat and low with compiles finished** -> per-pixel cost;
  schedule the narrowing run.
- **the magenta stays exactly as in run 282** -> expected; it is the next bug, not a regression.

## RUN 283 VERDICT (5 Sep 22:08 and 22:13, TWO launches, both FROZE ON THE BOOT "INITIALIZING..." SCREEN) - the pre-touch reads pages the copy never would, and the fault handler cannot make them readable

Build 17:27 (log Revision 62048c89 = the commit before b5ea93e6, as a build made before its commit
always shows). Env = `GT7_probe283.bat` (GT_RT_SCRUB=1, GT_READ_TRACE=6, GT_READ_PREFETCH=12,
readbacks armed on race only). User: *"stuck"* -> `stuckstack_20260905_221006.txt` -> *"crashed"*
-> relaunched -> stuck again at the same place. Neither launch reached the title screen.

⚠ **The first launch's log is LOST**: the user had already relaunched when I re-archived, and my
second copy of `shad_log.txt` overwrote the first archive with the relaunch's log. What survives
of launch 1 is the stuck dump plus the numbers I had already extracted (quoted below verbatim).
Launch 2 is `GT7_work/logs/run283b_relaunch.txt` (33 641 lines, complete). Lesson for the lane:
archive under a name that includes the PID or the launch time, never a per-run name, because the
user relaunches faster than I read.

### 1. What both launches did, measured

    launch 1 (pid 23044, started 22:08:07)      launch 2 (pid 23672, t0 ~ 22:13:42)
    black-point calibration screen 22:09:44     legal text 22:14:11
    GT logo spinner 22:09:48                    GT logo spinner 22:14:13
    INITIALIZING bars 22:09:50 .. 22:09:54      INITIALIZING bars 22:14:17 .. 22:14:21
    last [hdrprobe] t=98.1s frame 2459 (59 fps)  [fprof] t=39s 4484 draws, drawing normally
    first [readtrace] summary t=109s             first [readtrace] summary t=43s
    -> first read fault of the RUN at ~t=107     -> first read fault of the RUN at ~t=41
    892 274 read faults in the first 2 s,        819 853 read faults in the first 2 s,
    770k-870k per 2 s until t=175 (log end)      797 782 in the next
    1 distinct window of 512 KB, 0.0 MB copied,  same
    0 healed, 0 "downloaded nothing", ALL "served"
    [pretouch] span 1 = 0x280800000+0x7f8000     [pretouch] 1 line
      (2040 pages - THE run-282 crash address)
    [pretouch] span 4096, 37 639 pages total
    [reentry] 0 lines                            [reentry] 0 lines
    stuck dump 22:10:06, WS 12.4 GB              (no dump taken)
    died between 22:10:42 and 22:14, no          still alive when the user asked for this
    guest_crash.dmp (the 17:15 one is run 282's) handoff

Launch 2 pins the moment: `[fprof] t=39s` is a normal frame (4484 draws, 236 dispatches), then at
`t=41s` the game registers four 32x128x64-layer and one 256x256x6 B10G11R11 images (light-probe
shaped) and compiles two detiler pipelines, and the very NEXT read fault of the run is the storm.
The `[readtrace]` summary prints 2 s after the first read fault of the run, so "first summary at
t=43 with 819 853 faults" means the first read fault this process ever took was at ~t=41 and it
never stopped faulting. **The same thing at the same screen in two launches: deterministic.**

### 2. The stuck dump: a livelock, not the deadlock and not the crash

`stuckstack_20260905_221006.txt`: `shadPS4:GpuCommandProcessor 3312 ms/3 s Running`; every other
thread `0 ms Wait` (Main 47 ms, PresentThread 31 ms, SDLTimer 469 ms). `[tprof2]` shows the guest
Jobs (#0, #1, #35) at fixed PCs - spinning on the GPU. **No `Common::SpinLock` anywhere** (run 281's
signature) and **no `[reentry]` line / no unhandled exception** (run 282's). The GPU thread's stack,
top down, is the SAME four frames repeated seven times:

    NtContinue / RtlCaptureContext2 / KiUserExceptionDispatcher
    VideoCore::BufferCache::ReadMemory::<lambda_13>::operator()+0x65f     <- same offset, every level
    VideoCore::BufferCache::ReadMemory+0x157
    Vulkan::Rasterizer::ReadMemory+0x30
    VideoCore::PageManager::Impl::GuestFaultSignalHandler+0x1b0
    Core::SignalDispatch::DispatchAccessViolation+0x32 / Core::SignalHandler+0x43f
    KiUserExceptionDispatcher
    VideoCore::BufferCache::ReadMemory::<lambda_13>::operator()+0x65f
    ... (x7; the dump is cut before the base frames, so what the GPU thread was doing UNDER the
         handlers is not in it)

The fault handler is servicing a READ fault, and the code it runs to service it faults again at the
same instruction, seven levels deep, and the innermost level then retries for ever: ~400 000 faults
per second, ~2.5 us each (kernel exception round trip), the handler itself 0.16 us ("128 ms guest
wall" per 2 s). 30 million faults over 77 s in launch 1. Bounded depth, so no stack overflow -
until something else ended the process (the crash record is in the lost log).

### 3. The mechanism, from the code (buffer_cache.cpp:1099-1235, page_manager.cpp:357-415)

**a. What the counters say the handler found.** `ReadMemory`'s lambda: `DownloadBufferMemory<false>`
over the 512 KB window found NOTHING (`0.0 MB copied`); then `copied == 0 &&
IsRegionGpuModified(device_addr, 8)` was FALSE (else the run-273 heal would have fired: `0 healed`);
so it took the `served` branch (`892 274 read faults served`) and returned. `Rasterizer::ReadMemory`
returns true whenever `IsMapped(addr)` - so the fault was CLAIMED, the faulting instruction retried,
and **the page was exactly as unreadable as before**. That is the whole livelock: **"claimed" did
not mean "the retry can succeed".** The tracker's GPU-modified granularity is the 4 KB page
(TRACKER_PAGE_BITS = 12), so "clean at these 8 bytes" IS "clean for the page": the buffer cache is
not the one keeping that page unreadable.

**b. Who is.** `GPU readbacksMode: 0` at boot (run283b line 15). Read protection by the readbacks
exists only in mode 2, which this env arms at RACE START: run 282's first read fault of the whole
session is at `t=125.0s`, the exact second of `[readbacks] switched GPU readbacks mode 0 -> 2`.
`PageState.num_read_watchers` is requested only by the buffer cache for readbacks (page_manager.cpp
:172-176). At t=41 of a boot **nothing in the emulator read-protects a page** - so a READ fault at
t=41 can only come from the guest mapping's OWN permission: memory the game mapped GPU-only, with no
CPU read (shadPS4 applies the guest's CPU prot to the host pages). `IsMapped` says "GPU-mapped", so
the handler claims it; no readback exists to service it; the page stays unreadable; retry; for ever.
⚠ This is the inference that fits every measurement; the direct proof - the VMA prot at the storm
address - is missing because the `[readtrace]` summary does not print the address (see e).

**c. Why the GPU thread read such a page at all: MY PRE-TOUCH.** `SynchronizeBufferSpan`'s pre-touch
(b5ea93e6) reads one byte of EVERY page in `[max(device_addr, buffer_start), min(device_addr+size,
buffer_limit))`. The real copy (`ForEachUploadRange` -> `UploadCopies`) memcpys only the tracker's
CPU-MODIFIED ranges - ranges the CPU wrote, hence CPU-readable by construction. A written-upload span
over a buffer that overlaps a GPU-only mapping therefore contains pages the copy never reads and the
pre-touch reads anyway. The invariant "the upload path only ever reads pages the CPU could write"
held for the whole project until this commit. Run 282 (no pre-touch) passed this screen; run 283
froze at it twice. The guard's fallback - the other code change - never ran (0 `[reentry]`).

**d. Why seven nested levels and no per-fault log line.** Inside the lambda's trace block, after
`++tr.logged` and BEFORE its `LOG_INFO`, sits a diagnostic `std::memcpy(w, device_addr, 16)` gated
on `!nodl` with the comment *"the download dropped this page's read watcher, so the guest address is
readable from here"*. When the page is unreadable for a reason that is not a read watcher, that
memcpy re-faults INSIDE the fault handler: nested handler, nested lambda, nested memcpy - one level
per budgeted line (`GT_READ_TRACE=6`; the dump shows seven lambda frames, reconcile the one-off by
disassembling +0x65f or by re-running with `GT_READ_TRACE=1` and expecting depth <= 2). Every level
stops between its `++logged` and its `LOG_INFO`, which is why **the per-fault line never printed in
either launch while the summary (printed from the innermost level's `tr.Flush`) did.** With the
budget spent, the innermost level takes `served`, returns true, and the level above retries its
memcpy: the steady state in the dump. Remove the memcpy and the loop is still there, just one level
deep - the recursion is an amplifier, not the cause.

**e. Instrument gaps this exposed.** The summary line names no address (`1 distinct windows` but not
which); the per-fault line cannot print in exactly the case that matters; `[faulthist]` prints only
from the frame loop, which the storm never returns to. The `served` counter's name asserts a success
that was not measured.

### 4. Where this leaves runs 281 -> 283

    run 281  GPU thread reads a read-protected page INSIDE the upload lock window  -> deadlock
    run 282  same, guard returns false                                            -> crash (once, t=514)
    run 283  pre-touch reads EVERY page of the span, one is CPU-unreadable        -> livelock at boot

The guard's unprotect-and-claim fallback (b5ea93e6, page_manager.cpp) is still the right answer to
281/282 and has never been exercised. The pre-touch is a wrong answer to the same problem and must
not ship as written. Its kill switch exists: `GT_UPLOAD_PRETOUCH=0`.

## RUN 284 (pre-declared, .bat READY) - run 283's build with the pre-touch OFF

`GT7_work/GT7_probe284.bat` = probe 283 + `set GT_UPLOAD_PRETOUCH=0` (new REM header explains the
storm). NO rebuild: the fallback stays, the pre-touch is off, GT_RT_SCRUB=1 stays. Route: boot ->
Music Rally -> YES to "begin Gran Turismo 7" -> race events from the World Map.

Verdicts:
- **boots past INITIALIZING, plays like run 282, `[reentry]` count >= 1, no crash** -> the fallback
  works; the 281/282 class is closed and the count says how often it bites (282: once in 514 s).
- **`[reentry]` 0 over a long session** -> also fine; the in-window fault is rarer than 282 suggested.
- **crash again at the `[reentry]` address** -> the unprotect did not take (ProtectGpuTracked in
  "parallel" mode takes only a shared lock on the address-space mutex; check what mode is live).
- **frozen at INITIALIZING with the pre-touch off** -> the storm is NOT the pre-touch; the only
  other change is the fallback and it logs, so read `[reentry]`; then suspect the environment
  (launch 1 showed the black-point CALIBRATION screen, which appears on a fresh save).
- **purple sky, fps** -> unchanged expectations from the run-283 tree.

## RUN 284 VERDICT (5 Sep 22:34-22:42, ONE launch, 480 s, closed by the user) - the boot passes with the pre-touch off, and the guard's fallback is cheap

Build 17:27 (Revision 62048c89 in the log), env `GT7_probe284.bat` (= 283 + `GT_UPLOAD_PRETOUCH=0`).
Log archived FIRST this time: `GT7_work/logs/shad_log_run284_2026-09-05_2242.txt` (245 369 lines,
24 MB; the folder is gitignored now). Screenshots: `%APPDATA%\shadPS4\screenshots\CUSA24769_20260905_2234*`
to `_2242*`, 155 autoshots at a 2 s cadence.

### 1. What it did, measured

    t=6..30 s     legal text, GT logo, INITIALIZING bars                  -> PASSED (run 283 froze here, twice)
    t~60 s        Music Rally / world-map card: magenta where the sky dome would be (autoshot 28)
    t~206 s       A RACE: Porsche 356 on a public-road course, road, markings, trees, Armco, HUD all
                  drawn; sky and far ground MAGENTA (autoshot 100) = GT_RT_SCRUB's clear colour, expected
    t=303..311 s  black -> GT logo spinner (race exit / load)
    t=305..312 s  [reentry] 1 .. 12 288  <- ALL of them, in these 7 s
    t=334->395 s  autoshot gap 61 s: 501 CompileModule + 288 GetGraphicsPipeline + 533 LoopWrapGuard
    t=405->446 s  autoshot gap 41 s: same picture (shader compilation), 0 [reentry] in either gap
    t~395..462 s  event select, car select (autoshots 140, 154) - menus fine
    end           user closed it: save-backup thread stopping, no exception, no dump, no stuckstack

`[pretouch]` 0 lines (the env took: the code logs on span 1 when enabled). `[readtrace]` summaries
every 2 s from t=55 to t=479 - the readbacks were live (mode 2, on race) and the read fault path
behaved: 32..596 read faults per 2 s, 0.1-24 MB copied, max 7-119 ms, no storm.

### 2. The fallback, exercised for the first time: 12 288 faults, 7 seconds, no cost

The `[reentry]` lines (logged 1..8 then every 1024th) show what the path is for:
`0x281800000, 0x281801000, 0x281802000, ...` - consecutive 4 KB pages, one fault each, marching
through `0x280800000..0x281fff000` (~24 MB) and later `0x101d134000` / `0x1015262000` /
`0x1015823000`. That is `UploadCopies` memcpy-ing a written upload span whose pages the readbacks
had read-protected, faulting once per page, each fault unprotecting its page and letting the copy
go on. The same period's summary: `write-flush faults 297, 161.7 MB copied` at t=305 and
`51.4 MB` at t=311 - a race unload/load flushing a lot of GPU-written memory. The autoshots at
t=303.5 / 305.5 / 307.5 / 309.5 / 311.5 kept their 2 s cadence, so 12 288 exception round trips
cost under a frame's worth of time spread over 7 s. **Verdict: the 281/282 class is closed.** The
deadlock (281) cannot recur because the handler never re-enters the tracker from inside the
window; the crash (282) cannot recur because the fault is claimed; and the cost of claiming it
the cheap way is measured and negligible.

What the fallback does NOT guarantee, stated plainly: the copy reads guest RAM "as it stands" for
that page, and if the GPU had written it since the last download the uploaded bytes are stale.
Nothing in run 284's picture shows that (the race rendered), but it is a possibility the design
accepts, not one it rules out.

### 3. The two stalls are shader compilation, not faults

Between autoshot #139 (t=333.7) and #140 (t=394.9) the log holds 501 `CompileModule`, 288
`GetGraphicsPipeline`, 533 `LoopWrapGuardPass`, 204 `GenerateSrtProgram`, 105
`TessellationPreprocess` - and zero `[reentry]`, no read-fault storm. Same for 405 -> 446 s. These
are the compile storms the run-282 verdict predicted from GT_RT_SCRUB changing every fragment
shader, and they are the next performance item, not a fault problem.

### 4. Where this leaves runs 281 -> 284

    run 281  GPU thread reads a read-protected page INSIDE the upload lock window  -> deadlock
    run 282  same, guard returns false                                            -> crash (once, t=514)
    run 283  pre-touch reads EVERY page of the span, one is CPU-unreadable        -> livelock at boot
    run 284  pre-touch off, guard unprotects-and-claims                           -> 12 288 claims, plays

## RUN 285 (pre-declared, .bat READY, build 6 Sep 09:01) - the run-284 configuration on a build that deletes the pre-touch and cannot livelock a fault

`GT7_work/GT7_probe285.bat` = probe 284 minus the `GT_UPLOAD_PRETOUCH` line (the env is no longer
read). Same route as 284. Four code changes, one build:

1. **Pre-touch DELETED** (`BufferCache::SynchronizeBufferSpan`). Only `UploadCopies` reads guest
   RAM now, and only the tracker's CPU-modified ranges - the invariant run 283 broke is back.
2. **`[faultloop]`** in `PageManager::Impl::GuestFaultSignalHandler` (page_manager.cpp): a
   thread_local streak `{page, count, breaks, start}`. 32 consecutive faults on ONE page inside
   2 ms (32 genuine downloads cannot complete that fast - each is a GPU-queue round trip), or
   4096 however slow (run 272: 800k per 2 s), means the handler keeps claiming a fault that does
   not make the page accessible. `BreakFaultLoop` then logs the address, the guest's own VMA
   protection (new lock-free `MemoryManager::MappedProtAt`), the tracker's page perms and read
   watchers, the thread name and whether it is inside the upload window, and BREAKS the loop:
   if the mapping grants the CPU that access -> `ProtectGpuTracked(page, RW)` and claim; if it
   does not, or the same page was already forced RW once and is back -> **return false**, i.e. a
   crash dump that names the address. Deliberate: a wild read the guest mapping forbids has no
   correct "success", and for the GPU thread the address names OUR bug (run 283 would have died
   in 80 us with the VMA prot in the log instead of spinning for 77 s with nothing).
   ⚠ `Impl::Protect` (address_space.cpp:514) applies exactly the flags it is handed and never
   consults the VMA - so "unprotect" always succeeds at the OS level and can still leave a
   GPU-only page unreadable. That is why the breaker reads the VMA, not the page manager.
   ⚠ clang: a `static inline thread_local` member of a nested aggregate may not use default
   member initializers while `Impl` is incomplete ("default member initializer for 'page' needed
   within definition of enclosing class") - `FaultStreak` has none; `{}` zeroes it.
3. **The diagnostic 16-byte memcpy is out of the read-fault handler** (buffer_cache.cpp ~1183).
   It dereferenced the faulting address from inside the handler; the per-fault line now prints
   `copied / gpu_modified / nothing_to_do / waited / healed` instead of a hex sample.
4. **`[readtrace]` summary prints `hottest window <addr>: N read faults`**, and the counter that
   was called `served` is `nothing_to_do` - it measures the absence of work, not a success.

Verdicts, pre-declared:
- **plays like 284, `[reentry]` in the thousands during race loads, `[faultloop]` ABSENT** ->
  clean. Lane moves to the magenta sky (RUN 282 VERDICT 5.1), then the compile storm.
- **`[faultloop]` present, game continues** -> a real loop existed in 284 too and was invisible
  (a page that refaulted slowly); read the line: VMA prot + perms say whose protection it was.
- **crash** -> the last `[faultloop]` line names the address and says "REFUSING". If VMA prot has
  no CpuRead: the copy read a GPU-only mapping - find the upload span (the `[reentry]` addresses
  just before it) and ask why the tracker had a CPU-dirty range there. If VMA prot HAS CpuRead and
  it still refaulted after a forced RW: the protection is not ours and not the guest's - suspect
  the address-space region table (`Impl::Protect`'s `regions.upper_bound` skip).
- **frozen with no `[faultloop]`** -> not a fault loop (the breaker fires in 2 ms); stuckstack.
- **`[reentry]` count 0 for a whole session** -> also fine; the path is load-dependent.

## RUN 285 VERDICT (6 Sep 11:10-11:3x, build 09:01, one launch) - it plays, the sky draws, and it deadlocks entering the World Map on a stale DingDong offset

Env `GT7_probe285.bat`. Log archived with PID: `GT7_work/logs/shad_log_run285_2026-09-06_1110_pid10236.txt`
(319 307 lines). Stack dump of the hang: `GT7_work/logs/stuckstack_20260906_112207.txt`. Revision
9b25d1bd-dirty = this build (a build made before its commit shows the previous hash).

### 1. What it did

    t=0..55 s     "INITIALIZING" - 55 s of it, see 3
    t~206..330 s  Music Rally, TWO races driven by the user. AUTOSHOT 142 (11:16:58): blue sky WITH
                  CLOUDS, road, trees, signs, Armco, HUD - no magenta anywhere in that frame.
                  Autoshot 100: the same course with magenta on the distant backdrop. User: the image
                  "trashes" every frame in different places, and the magenta moves around the map.
    t~409 s       entered the main game; World Map loading screen (autoshot 160, 11:17:34) - and
                  that is the LAST frame ever presented. Process alive, 3.4 cores busy, no frames.

`[reentry]` 22 logged lines (counter in the thousands) during the race loads - the expected
pattern from run 284. `[pretouch]` 0. `[faultloop]` fired TWICE, both benign, see 2.

### 2. The two `[faultloop]` lines, read

    WRITE fault at 0x10a2bcf440, 32 times in 0.079 ms, thread SceLibc_Thr: VMA prot 0x33 (CPU RW +
    GPU RW), tracker perms 0x3 (= the page manager already believed the page RW), 0 read watchers,
    not inside the upload window -> forced RW and claimed. The game went on.

The page manager's cached state said RW while the OS page was write-protected: an OS protection
that is not ours and not the guest's mapping. The forced RW agrees with the tracker's own state,
so it is the right repair - but it names a real inconsistency (GT_FAST_PROTECT's shared-lock
parallel protect racing an overlapping range is the first suspect). Without the breaker this
thread would have spun for ever.

    READ fault at 0x0, 32 times in 1.084 ms, thread Job#0: VMA prot 0 (mapped false) -> REFUSED.

And the game went on - because `return false` on a GUEST thread is not a crash: `Core::SignalHandler`
walks `access_violation_handlers` (page_manager, cpu_patches, the SRT walker) and the next one
took it; there is no "Unhandled Exception" line anywhere after it. So the 32 faults were 32
refusals of the OLD code path too, retried by whoever handles them, and the null read resolves
itself within ~2 ms (another thread fills the pointer). The `[faultloop]` text said "crash dump
with this address" and was wrong for guest threads; fixed in this commit.

### 3. The 55 s of "INITIALIZING" is the pipeline cache, and it grows with every build

The eleven 5 s `[tprof]` windows sit EXACTLY between "The pipeline cache was written by a
different build" and "Preloaded 0 pipelines / 14501 stale pipelines were found". `WarmUp` reads
every `.key` blob in `%APPDATA%\shadPS4\cache\CUSA24769\` (36 356 files, 1179 MB: 14549 keys,
10903 spv, 10903 meta), finds each one written by another build, discards it - and leaves the
file for the next launch. Run 284 read 14 325 of them in under 5 s and this run read 14 501 in
55 s, so the cost is dominated by the filesystem's mood (Defender scanning files a NEW exe
opens is the likely variable), but the WORK is ours: 14 501 files nobody will ever use again.
`SDL_joystick 100%` in those windows is SDL's device-notification thread in its GetMessage loop
during the same period; it vanishes once the game runs and is not the cause.

### 4. THE DEADLOCK, measured to the number

Stack dump: `GpuCommandProcessor` in `Liverpool::Process -> Common::CondvarWait` (idle: no
submits, no commands), `Rendr` and `Job#0` `Running` at guest PCs (spinning), everything else in
waits. After the hang the guest issued 6 DingDongs in 3.5 minutes - it is waiting on the GPU.
The GPU thread's last lines before sleeping:

    208442  (Rendr) sceGnmMapComputeQueue: ASC pipe 5 queue 2 mapped to vqueue 7
    208443  (Rendr) sceGnmMapComputeQueue: ASC pipe 0 queue 3 mapped to vqueue 6
    208444  (Rendr) sceGnmDingDong: vqid 7, offset_dw 4        <- FIRST DingDong of the new queue
    208445  (Rendr) sceGnmDingDong: vqid 6, offset_dw 4
    208496  (Gpu)   [softclamp] ACB stitch: buffered header 0xaaaaaaaf declares 10924 dw ...
    208671  (Rendr) sceGnmMapComputeQueue: ASC pipe 1 queue 3 mapped to vqueue 10
    208674  (Rendr) sceGnmDingDong: vqid 10, offset_dw 4
    208675  (Gpu)   [softclamp] ACB stitch: buffered header 0x1fe000 declares 33 dw against 4 dw
            ... nothing more from the GPU thread, ever.

The last DingDong on vqid 7 BEFORE the remap was `offset_dw 92`; on vqid 10, `offset_dw 252`.
`sceGnmDingDong` keeps a per-slot table `asc_next_offs_dw[vqid]` and `sceGnmMapComputeQueue`
never reset it (only the guest-visible `*read_addr`). `SlotVector::insert` hands a freed slot
straight back. So the first DingDong of a REMAPPED queue saw `offs_dw = 92, next = 4`, i.e.
`next < offs_dw && next != 0` = "the submission wrapped the ring" - and submitted
`[92, ring_size)` of the NEW ring: memory the game had never written. `0xaaaaaaaa` is exactly
the fill of such memory; in run 284 the same two remaps produced `0xf4f4f4f4` and `0x1028d780`
(lines 176150-176432 of that log) and the game survived them. Garbage parsed as PM4 leaves
`*read_addr` wherever the parse stopped; the guest spins until the read pointer reaches the
value it expects; it never does. **Run 284's ACB stitch lines were this bug too, and were read
as harmless torn-ring noise.** ⚠ `sceGnmUnmapComputeQueue` logged nothing, which is why a slot
reappearing looked like the game mapping the same vqueue twice.

Fix (this commit): `sceGnmMapComputeQueue` zeroes `asc_next_offs_dw[slot]` and the slot's stitch
buffer `tmp_dwords`; `sceGnmUnmapComputeQueue` zeroes the offset too, bounds-checks, and LOGS.
The stitch softclamp prints the vqueue, submission size and read pointer so the next one can be
read without a log archaeology session.

### 5. What is still unexplained, honestly
- the per-frame "trashing" and the roaming magenta. The candidates, in order: the `[reentry]`
  fallback uploads STALE guest RAM for every page it claims (12k pages per race load - the design
  accepts it, and it is exactly the kind of thing that shows as garbage that differs frame to
  frame); the garbage ACB submissions of 4 (compute dispatches from unwritten memory, now gone);
  GT_RT_SCRUB clearing targets the game expected to persist. Measure before choosing: correlate
  the trashed frames with the `[reentry]` timestamps in run 286's log.
- the `[faultloop]` WRITE case: who write-protected a page the page manager thought was RW.

## RUN 286 (pre-declared, .bat READY, build 6 Sep 11:32) - the remap fix, the cache prune, and the World Map again

`GT7_work/GT7_probe286.bat` = probe 285 (env identical). Route: boot -> Music Rally -> a race ->
main game -> WORLD MAP -> a race from the World Map (the place run 285 died).

Verdicts, pre-declared:
- **first launch prunes** (`Pipeline cache: pruned N stale .key blob(s)`), the second launch
  starts in seconds -> the 55 s is closed. (The 10903 orphaned .spv/.meta stay: 1.1 GB of disk,
  not read at startup; a later prune can pair them to surviving keys.)
- **`vqueue N unmapped` lines appear, and NO `ACB stitch` line follows a `mapped to vqueue`
  line; the World Map loads and a race starts from it** -> the deadlock class is closed.
- **`ACB stitch` still fires right after a remap** -> read its new fields: if `this submission`
  is huge (thousands of dw) and `read ptr` is near the old offset, the reset did not take (a
  second offset table?); if it is small, it is a genuine torn ring and a different bug.
- **deadlock again at the World Map with no stitch line** -> stuckstack; the last
  GpuCommandProcessor line names the packet; the guest's spin PC (`guest:eda65a7` in 285) is the
  wait to identify.
- **`[faultloop]` lines** -> read them; a WRITE case with tracker perms RW is the GT_FAST_PROTECT
  suspicion above, and `GT_FAST_PROTECT=0` is the A/B.
- **image trashing** -> note WHEN (race load, or steady state) and hold it against `[reentry]`.

## RUN 286 VERDICT (6 Sep 11:41:06-11:45:24, build 11:32, PID 19820) - the fixes hold, the World Map loads, the magenta is OUR forced clear, the race is CPU-bound, and the game crashes in the Options menu

Log: `GT7_work/logs/shad_log_run286_2026-09-06_1141_pid19820.txt` (168 751 lines). Minidump:
`GT7_work/logs/guest_crash_run286_2026-09-06_1145.dmp`. Revision prints 3f5712c4-dirty (the build
predates commit 354fc324).

### 1. The pre-declared verdicts
- **prune:** `Pipeline cache: pruned 14549 stale key blob(s) (0 kept)` on this launch; the user was
  racing by t=100 s. Closed.
- **remap / World Map:** 14 `mapped to vqueue`, 8 `vqueue N unmapped (last DingDong offset ...)`
  lines, **0 `ACB stitch`**, and **autoshot 92 (t=200.9 s) is a clean World Map** - sunset, the
  pavilions, the "You are currently offline" tooltip, no corruption. The place run 285 died in
  renders. The deadlock class is closed.
- **`[faultloop]` 4x:** three READ 0x0 refusals on Job threads (game went on), one WRITE at
  **0x10a2bcf440 forced RW - the SAME address as run 285**, VMA prot 0x33, tracker RW. Deterministic:
  something other than the page manager write-protects that page every run. Still open.
- **`[reentry]` 22 lines at t=190-232 s** = entering the main game after the Music Rally, not during
  the race (285 had them at the World Map entry). Consistent: the fallback fires on scene loads only.

### 2. THE ROAMING MAGENTA IS `GT_RT_FORCECLEAR=0x1005000000` - our own run-263 experiment
Every probe since 263 carries `set GT_RT_FORCECLEAR=0x1005000000`. `GtForceClearTargets()` clears
that target - **the game's main 1920x1080 B10G11R11 HDR colour buffer - to MAGENTA (1,0,1) once per
presented frame**, by the first render pass that binds it. Proof in both logs: `[forceclear] #0..
0x1005000000 1920x1080 B10G11R11UfloatPack32 cleared to magenta (frame N)` and every race-window
`[clears]` line reads `0x1005000000:1920x1080:bNNNN/c0/fK` with **K == "game clears" == one per
frame**. Autoshot 70 of this run (t=120 s, Music Rally): the ENTIRE sky is magenta; autoshot 142 of
run 285 (blue sky) is a frame where the sky pass happened to repaint it. Whatever the game does not
repaint in a given frame shows magenta - hence "purple in different places, not just the sky".
`GT_RT_SCRUB=1` is not it (it replaces NaN/Inf/>=65000 outputs with 0, i.e. black).
**Fix: blank the variable** (probe 287). No build.

### 3. THE FPS, measured ([fprof] + [clears], both runs)
    menus      ~60 game frames/s, ~20 draws/frame, GPU thread ~40 % busy
    race        4-15 game frames/s ("game clears" per 2 s window = 8..29), 2 000-3 500 draws/frame,
                GPU thread 65-90 % busy: draw ~1.0-1.4 s per 2 s window (pipeline lookup 150-500 ms,
                bindbuf 250-300, bindtex 250-350, state ~150), dispatch 200-300 ms, dma 50-150 ms
    plus        [faulthist] ~26 000 guest WRITE faults per 2 s window, [protprof] ~300 ms of page
                protects per window (22 000 "other" protects)
That is ~45 us of emulator CPU per draw on ONE thread: **the race is CPU-bound in the command
processor, not GPU-bound**. "60 fps in the menus, drops the moment the track renders" is exactly
this curve. The user calls it "a few fps drops"; the log says 4-15 fps. Next work item, and a real
one: the per-draw bill (bind/pipeline/state) and the write-fault storm.

### 4. THE "TRASHING" IS REAL IN 2D TOO
Autoshot 111 (the crash frame, Options menu): a pure-GREEN horizontal band across the screen, a
second strip of it shifted right, the UI behind it intact. Not magenta, not ours (nothing in the
probe clears to green), not a race-only effect. Stale/garbage image data reaching a 2D composite.
Suspects, unranked: the `[reentry]` fallback's stale uploads (22 pages this run at t=190-232 s),
the buffer cache's `[readtrace]` downloads (587 read faults, 182 MB copied in the last window
before the crash), `drops: fce N resolve N` (one FCE and one resolve draw dropped per frame - FCE
is by design a no-op for us; the resolve drop wants checking). Run 287 removes the magenta so the
autoshots show ONLY this.

### 5. THE CRASH (new class)
    Unhandled Exception code 0xc0000005 at 0xe7a789e while reading 0x10e342f30
    guest crash: rip 0xe7a789e = eboot.bin+0x344789e   rbx=0x10e3419d0 (+0x1560 = the read)
    thread "PCL Event"; stack: libc.prx+0x4db4a, eboot.bin+0x3b592ac/+0x3b59112/+0x3b59052
rax=0xdeadbeef54321abc is shadPS4's own `g_stack_chk_guard` constant (kernel.cpp:45) - noise.
"Unhandled" means NO access_violation_handler claimed it: the page at 0x10e342000 is either
unmapped (a game-side use-after-free that a real PS4 would also crash on - unlikely in the Options
menu) or **mapped but protected by something that is not the page manager** - the same open
question as the deterministic `[faultloop]` WRITE at 0x10a2bcf440. First move for whoever picks it
up: open the minidump (3 extra memory ranges) and check the VMA at 0x10e342f30; then grep the log
for the last mapping that covered 0x10e3xxxxxx (the Debug log did not print one).

## RUN 287 (pre-declared, .bat READY, same build 11:32) - probe 286 minus the forced clear

`GT7_work/GT7_probe287.bat` = 286 with `set GT_RT_FORCECLEAR=` (blank). Nothing else changes.
- **no magenta anywhere** -> the roaming purple is closed; anything still wrong in the frame is the
  section-4 trashing and is now photographable on its own.
- **trashing timing:** ask the user WHEN (scene load vs steady driving vs menus) and hold the
  autoshots against `[reentry]` (loads) and `[readtrace]` windows.
- **crash again in a menu:** archive log + `guest_crash.dmp` with the time; compare the faulting
  address class (0x10e3... direct memory) and the thread. Twice = a lead.
- **fps:** unchanged by this probe; do not read a change into it.

## RUN 287 VERDICT (6 Sep 11:55-11:56, build 11:32, first WARM launch) - DEVICE LOST at t=58 s, and the user names the variable: "letters fly around whenever the same build runs a second time"

Log: `GT7_work/logs/shad_log_run287_2026-09-06_1155_devicelost.txt`, vendor dump
`GT7_work/logs/device_fault_run287_2026-09-06_1156.bin`. `[forceclear]` 0 (the magenta is gone by
construction). What the run was: the FIRST launch of build 11:32 with a warm pipeline cache -
**`Preloaded 2745 pipelines`, 10 compiles (all tile_manager detilers) against 6221 in cold run 286.**
Autoshot 25 (t=52 s): black screen with the piano keys (the Music Rally intro). Then:

    ==== DEVICE FAULT (8 address record(s), 0 vendor record(s)) ====   NO bad memory access -
    8 instruction pointers inside 0x250 bytes = ONE shader, 8 invocations parked = a HANG
    last work: DispatchDirect cs_0xef4a0dc6, 1 group x 512 threads, LDS 8192 B (a cached module:
    run 286 compiled it, run 287 did not - no "Compiling cs shader 0xef4a0dc6" line)

**The user's observation is the finding**: cold launches of this binary play (285, 286); the warm
launch hangs in the intro, and in earlier builds the warm launches showed glyphs flying around or
missing. The cache is the variable. Measured so far:
- **the store is intact**: 24 560 files, 0 zero-length, 0 truncated, every `.spv` carries the SPIR-V
  magic, `.spv` == `.meta` count (10907), 2745 keys. Not a bytes-on-disk problem.
- **what a warm run reads back is smaller than what a cold run computes.** `Info::Serialize` writes
  `sizeof(InfoPersistent)` + flattened_ud_buf + dynrc_windows + srt_info; everything in `Info`
  outside `InfoPersistent` (has_bindless_sharp, readconst_types, uses_window_reads, loads/stores,
  fs_interpolation, gs_copy_data, shared_types, ...) comes back ZERO. Read through: none of those is
  read by video_core at draw time except `has_bindless_sharp`, and that one is consistent (a stubbed
  shader stores a no-op `.spv` beside cleared lists). So the missing fields are NOT proven guilty.
- the "[mipbake] live mip bindings 1 != baked 9" lines are identical (16, one shader) in cold and
  warm runs - not a warm-cache signal, ignore them here.
- run 287 had **0 `[softclamp]`, 0 `[imgarray]`, 0 `[loopguard]`** lines where the cold run's first
  60 s had 97 / 12 / 209 (the last is compile-time and expected to vanish; the first two are RUNTIME
  bind-time diagnostics and their absence says the warm run bound differently - or reached less).
- `src/shader_recompiler/info.h` and `flatten_extended_userdata_pass.cpp` show as modified but the
  diff is line endings only; the other lane's edits are not in play.

**What is NOT known: whether a preloaded module (SPIR-V + Info + spec) equals what the same guest
code compiles to now.** That is a byte comparison the emulator can make itself, so it does - see
RUN 288.

## RUN 288 (pre-declared, .bat READY, build 6 Sep 12:11) - GT_CACHE_VERIFY=2: compare every preloaded module with a fresh compile, and heal on mismatch

Code (this commit): `PipelineCache::VerifyPreloadedModule` / `RetirePreloadedPipelines`
(`vk_pipeline_cache.cpp`), `Program::Module::{preloaded,verified}` (`vk_pipeline_cache.h`),
`preloaded_*_keys` recorded in `LoadGraphicsPipeline` / `LoadComputePipeline`
(`vk_pipeline_serialization.cpp`). The first time a draw asks `GetProgram` for a module that came off
the disk, the module is recompiled from the LIVE guest code (`TranslateProgram` + `EmitSPIRV`,
nothing written to the store) and compared with the cached one: SPIR-V dword by dword, the
`InfoPersistent` bytes the meta memcpy'd (plus the resource-list sizes and the scalar flags named
separately, so a padding-byte false alarm is recognisable), and `StageSpecialization ==` both ways.
`GT_CACHE_VERIFY=1` logs; `=2` (probe 288) also swaps the fresh module in on the first SPIR-V
mismatch and retires every pipeline WarmUp built (moved to `retired_*`, never destroyed - a command
buffer in flight may still hold them), so the live state rebuilds them with verified modules and
the run doubles as the fix test. One `[cacheverify]` line per 256 clean checks proves it is alive.

`GT7_work/GT7_probe288.bat` = 287 + `set GT_CACHE_VERIFY=2`. Verdicts, pre-declared:
- **`spv DIFF` lines** -> the named shader(s) are the flying glyphs / the hang; the first dword
  index says where. With mode 2 the run should then look like a cold run. Next: diff a fresh and a
  cached `.spv` of that hash (`GT_DUMP_HASHES`) and find which recompiler input was not in the key.
- **only `SAME ... 0 differ` and still broken** -> the modules are identical; the fault is in how a
  preloaded PIPELINE is built from `GraphicsPipeline::SerializationSupport` (vertex input,
  multisampling) - verify that struct the same way next.
- **`persistent info DIFF` with `spv SAME`** -> the meta, not the module: a field the passes set
  that the memcpy does not carry the same way; the byte offset maps to the field.
- **no `[cacheverify]` line** -> nothing preloaded (check `Preloaded N pipelines`) - the cache was
  pruned or the build generation changed; run it twice.
- **device lost again with `0 differ`** -> the hang is not the module bytes; look at what
  cs_0xef4a0dc6 READS (a descriptor table filled by another cached shader) before its dispatch.

## NEW CHAT - START HERE (written 6 Sep, ~12:40)

**State.** HEAD = this commit. Installed exe = build 6 Sep 12:11 (GT_CACHE_VERIFY in). The cold
launch of build 11:32 plays (run 286: fast boot, Music Rally, main game, World Map, then a guest
crash in the Options menu at t=258 s - RUN 286 VERDICT 5). The WARM launch of the same build hangs
the GPU in the intro (run 287) and is the user's "letters fly around on the second launch".

**Do first, no build:** the user runs `GT7_probe288.bat` TWICE if needed (the first launch after a
new build is cold - it prunes and refills; the SECOND is the warm one this probe exists for; the
log's `Preloaded N pipelines` line says which you have). Archive each log as
`GT7_work/logs/shad_log_run288<a|b>_<date>_<HHMM>.txt`. Grep in this order: `Preloaded`,
`[cacheverify]` (every `DIFF` line is a finding), `retired`, `DEVICE FAULT`, `Unhandled Exception`,
`[faultloop]`, `[reentry]`. Ask the user whether letters still fly.

**Then, in this order:** (a) whatever `[cacheverify]` names (RUN 288 verdicts); (b) the 2D trashing
of RUN 286 VERDICT 4 if it survives a verified cache; (c) the Options-menu guest crash and the
deterministic `[faultloop]` WRITE at 0x10a2bcf440 (`GT_FAST_PROTECT=0` is the A/B); (d) performance
(RUN 286 VERDICT 3: ~45 us per draw on one thread, 26k write faults per 2 s).

**Rules this run adds.** (viii) "Only on the second launch" is a complete bug report: the variable
is the cache, and the test is cold vs warm of the SAME binary. (ix) Verify a cache by recomputing
what it stores and comparing bytes - not by reading the serializer and reasoning about which field
might matter; the emulator can do that comparison itself, in C++, behind an env gate. (x) The user
wants every tool for this lane in C++ inside the emulator (6 Sep) - no analysis scripts as
deliverables; grep/awk in the chat is fine, anything that will run again becomes code.

**Files.** `GT7_work/logs/shad_log_run287_2026-09-06_1155_devicelost.txt`,
`GT7_work/logs/device_fault_run287_2026-09-06_1156.bin`, `GT7_work/GT7_probe288.bat`,
`GT7_work/build_run288.log`; run 286: `shad_log_run286_2026-09-06_1141_pid19820.txt`,
`guest_crash_run286_2026-09-06_1145.dmp`. Not in this commit: `src/shader_recompiler/info.h` /
`flatten_extended_userdata_pass.cpp` (line-ending-only diffs from another lane),
`GT7_work/psn_local/server_log.txt`.

## RUN 288 VERDICT (6 Sep, cold 12:14-12:25 + warm 12:35-12:44, build 12:11)

**Cold launch** (`logs/shad_log_run288_2026-09-06_1225_pid10068_guestcrash.txt`): "Preloaded 0
pipelines, 2745 stale" - the new build changed the cache generation, 6245 compiles, no
`[cacheverify]` line (nothing to verify). No magenta (GT_RT_FORCECLEAR blank stays). World Map
clean. The user's "old frames kept and drawn with new ones, mostly far away" is real: autoshot 107
shows a stale far-scenery band with HUD fragments on the horizon, 077 a green motion trail across
the sky; car select (262) has the centre car undrawn and two thumbnails as noise / another image.
Race 22 fps, car select 39 fps. 1743 `Coercing copy source layers A and destination layers B`
(971 x 1-vs-8, 770 x 6-vs-8) - a copy that fills min(A,B) layers leaves the rest of the destination
with OLD contents: candidate for the far-frame ghosting, `[copylayers]` (build 12:46) names the
images. Ended by a **guest crash when changing track: the SAME instruction as run 286**
(eboot.bin+0x344789e, thread PCL Event, read of rbx+0x1560, identical stack). Deterministic. Dump
`logs/guest_crash_run288_2026-09-06_1225.dmp`. Build 12:46 prints the guest VMA under the fault
address and under every register (grep `guest vma`).

**Warm launch** (`logs/shad_log_run288warm_2026-09-06_1244_pid8772_devicelost.txt`,
`device_fault_run288warm_2026-09-06_1244.bin`): Preloaded 3611, 28 compiles. **Letters fly again**
(user screenshots: dialog glyphs garbled, race HUD text missing at 7 fps), GPU stuck in
`Scheduler::Finish` (stuckstack 12:37), unstuck, then **DEVICE LOST at t=484 s** like 287.
**`[cacheverify]`: 2056 checked, 2056 DIFFER, every one "spv SAME, spec SAME, persistent info DIFF"**
at bytes 0 / 32 / 64 / 192 / 224 / 320 / 2344. By the struct (InfoPersistent starts with the four
static_vectors, storage first; BufferResource is 32 B: sharp_idx @0, used_types @4, inline_cbuf
@8, buffer_type @24, instance_attrib @28, is_written @29, is_formatted @30) those are
`buffers[0..10].sharp_idx` and the images list - a hand derivation, so build 12:46 logs the layout
measured (`[cacheverify] layout:`). Verdict per the pre-declared table: **the SPIR-V on disk is
right; the Info the meta carries is not.** sharp_idx is the index the CPU uses at bind time to
fetch the V#/T# out of the flattened user data - a stale one binds the wrong buffer or texture to a
byte-identical module, which is what flying glyphs and undrawn cars look like.
Open question the field dump answers next: is the diff REAL (cached sharp indices point at the
wrong flattened slots) or BENIGN (both layouts self-consistent, e.g. an address-ordered container
in the flatten pass numbering resources differently per process)? The HEAL settles it either way.
Also: `Info::Serialize` memcpy's `sizeof(InfoPersistent)` including padding bytes - a byte diff
inside an entry is not evidence until the named fields differ; the dump compares fields.

## RUN 289 (pre-declared, build 6 Sep 12:46, `GT7_probe289.bat`, run TWICE)

Build adds: `[cacheverify]` field-by-field dump (buffers/images/samplers + scalars + flatbuf and
walker sizes), the measured layout line, **HEAL in mode 2** (Info differs -> program gets the fresh
Info, WarmUp pipelines retired once, module kept when SPIR-V identical), `[copylayers]` (image.cpp),
guest-VMA lines in the crash report (signals.cpp + `MemoryManager::VMAAt`), `GT7_probe289.bat`.
- Launch 1 = cold (refills the cache). Launch 2 = warm = the test.
- Warm plays like cold (letters still, no device lost) + `HEAL` lines -> cached Info is the culprit;
  the field dump names it; real fix = serialize/deserialize that field correctly (or rebuild it on
  load) instead of healing per run.
- Warm still breaks WITH HEAL lines -> the fault is elsewhere in what WarmUp rebuilds
  (GraphicsPipelineKey / SerializationSupport); verify those the same way.
- Field dump shows only padding / benign renumbering AND heal changes nothing -> the Info diff was
  noise; back to the pipeline keys.
- `[copylayers]` names the 8-layer destination of the 1-vs-8 / 6-vs-8 copies -> that is the
  stale-far-frame path; fix = size the copy from the guest's real layer count.
- Guest crash again -> `guest vma` lines say Free / mapped-with-prot / outside-map.

## RUN 289 VERDICT (6 Sep, cold 12:51-12:57 guest crash + warm 13:05 DEVICE LOST x2, build 12:46)

### 1. Cold launch (`shad_log_run289cold_2026-09-06_1257_guestcrash.txt`, `guest_crash_run289cold_*.dmp`)
No magenta. Far scenery blurred and late ("close textures drawn, far ones fly over and are blur"),
race intro 3-9 fps, race 22 fps; car select: no colour/light on the 3D car, thumbnails trashed on
the right. All of it COLD, so none of it is the pipeline cache. Third identical guest crash
(eboot+0x344789e, thread "PCL Event", read of rbx+0x1560); the new `guest vma` lines put the fault
address and rbx in a **Free** VMA (0x82abc000+0x17d544000, host MEM_RESERVE) = the game reads memory
it unmapped, or a mapping our kernel never made. `[copylayers]` named the 1-vs-8 / 6-vs-8 copies:
a 256x256 9-mip B10G11R11 8-layer environment cubemap filled face by face - not the far-scenery
ghost. Candidate eliminated.

### 2. Warm launch (`shad_log_run289warm_2026-09-06_1305_devicelost_mipbake.txt`, `device_fault_run289warm_*.bin`)
Preloaded 3626. HEAL fired on the first verified module (cs 0xaaa36b0e) and retired all 3506+120
WarmUp pipelines, so pipelines were rebuilt live; modules stayed cached. The user reached the
Settings screen ("chessboard") and the GPU died there, twice in a row (only the second log
survives - the file is overwritten per launch).

**The DIFFs were noise, and HEAL turned one of them into the crash.**
- Every "persistent info DIFF at byte 0 / 32 / 64 / 72 / 80 / 1032" came with "NO entries differ by
  field": those bytes are the unused tail of a `static_vector` (storage past `size()` is whatever
  the constructing frame left there). The byte compare was measuring uninitialised memory. **The
  cached Info equals a fresh compile field for field. The cache is not what makes the letters fly.**
- The one real field diff: cs **0xda05e7f8** (cubemap mip-gen, dispatches 16x16x6 -> 1x1x6) perm 1,
  `images[1] cached baked 9 | fresh baked 1`. Perms >= 1 are compiled against a THROWAWAY Info
  (`GetProgram`: `new_info`) while the pipeline layout and BindTextures read the program's Info =
  perm 0's. Perm 1 existed because its spec (`num_bindings` = live mip count) was 1; its module is
  `TypeArray(image, 1)`. HEAL copied perm 1's Info over the program's -> layout shrank from 9 slots
  to 1 -> the next 9-mip T# matched perm 0's spec -> perm 0's module (`TypeArray 9`, `OpUMin(lod,8)`)
  ran under a 1-slot layout -> read past the descriptor set. Device fault: checkpoint at seq 24016 =
  the first `DispatchDirect cs_0xda05e7f8` (16x16x6), `InstructionPointerFault 0x200164d30`,
  `ReadInvalid 0x300100000` (in no buffer), `[mipbake] live mip bindings 9 != baked 1` three lines
  earlier. Cold logs (288, 289) only ever show the harmless direction `live 1 != baked 9`.
- Corollary, independent of the cache: **a COLD run has the same hole** whenever a perm is compiled
  while the T# has MORE mips than perm 0 saw - its module (and every binding number after that
  image) outgrows the layout. Never observed cold so far, but it is one T# order away.

### 3. Fixes in this commit (build 6 Sep 13:20)
- `PinBakedMipCounts` (vk_pipeline_cache.cpp): a perm's `num_bindings_baked` is pinned to the
  program layout's before its SPIR-V is emitted - in `CompileModule` (new `layout_info` parameter,
  passed from `GetProgram`) and in the verifier's fresh compile. `[mipbake] ... pinned` (CRITICAL)
  = the perm wanted MORE slots than the layout (those mips collapse into the last slot instead of a
  fault); `raised` (INFO) = it wanted fewer.
- Verifier: Info compared BY FIELD; the byte diff is reported, never acted on. Info compared only
  at perm 0 (perm > 0 has no comparable Info). HEAL never lowers a baked mip count (max of both).
  A clean warm run now prints `N checked, 0 differ` in the periodic line.
- `[mipbake]` at bind time says which direction the mismatch is.
- Linked for the first time (commit 72cd1c33): `[faultloop] ... | owner`, `[metaread]`,
  `guest crash: map ring`.
- Comments trimmed to the technical minimum; the story lives here. The user intends an upstream PR
  later and wants code that reads like the project's own (rule xi).

## RUN 290 (pre-declared, build 6 Sep 13:20, `GT7_probe290.bat`, run TWICE, Settings both times)
- Warm survives the Settings screen and `[cacheverify]` reads `0 differ` -> the crash was HEAL's and
  the cache Info is clean; if the letters STILL fly warm, the fault is in what WarmUp builds besides
  Info (GraphicsPipelineKey / SerializationSupport / the preloaded modules' binding numbering) -
  verify those the same way (recompute and compare in C++).
- Warm survives AND letters stay put -> 287/288's flying letters were the retired-pipeline path or
  the cache generation; compare with 288 warm before believing it.
- `[mipbake] ... pinned` appears -> the cold hole of verdict 2 is real; the proper fix is to grow
  the program's count and rebuild that program's pipelines, not to clamp.
- `[faultloop] ... | owner`: "buffer cache registered true" or an image on the page -> a cache owns
  the forced-RW page and CPU writes there go unseen (stale GPU data = candidate for the far-scenery
  ghost and the trashed thumbnails); "gpu-mapped false / registered false / 0 images" -> orphaned
  protection, the claim path is the bug.
- `[metaread]`: the shader and T# that read a CMask/FMask/HTile as a texture (~1 per frame) - the
  candidate for the blurred far layer.
- Guest crash again -> `guest crash: map ring` names the unmap (or the missing map) of the Free VMA.

## NEW CHAT - START HERE (written 6 Sep, ~13:40) - supersedes the 12:40 one above

**State.** HEAD = this commit, installed exe = build 6 Sep 13:20 (probe 290). The user runs
`GT7_probe290.bat` twice; the second launch is the test. Grep in this order: `Preloaded`,
`[cacheverify]` (the periodic line's `differ` count), `HEAL`, `[mipbake]`, `DEVICE FAULT`,
`Unhandled Exception`, `[faultloop]`, `[metaread]`, `map ring`. Archive both logs with PID/time
into `GT7_work/logs/` (the file is overwritten per launch - copy it before the next one).

**Then, in this order:** (a) RUN 290 verdicts above; (b) the far-scenery ghost / black car /
thumbnails - present COLD, so start from `[faultloop] owner` and `[metaread]`, not the cache;
(c) the eboot+0x344789e guest crash via `map ring`; (d) performance (intro 3-9 fps, race 22 fps,
GpuCommandProcessor CPU-bound).

**Rules this run adds.** (xi) Code comments stay short and technical; run numbers, user quotes and
narrative go in this handoff. The user will open an upstream PR from a clean branch later and wants
the code to read like shadPS4's own. (xii) A verifier must compare FIELDS it can name; a memcmp over
a struct with variable-size members compares garbage. (xiii) Before healing from a "fresh" compile,
ask whether the fresh object is even the same object the cache stored (here: perm 0's Info vs a
perm's throwaway Info).

## RUN 290 VERDICT (6 Sep 13:20-13:29, build 13:20, ONE cold launch, guest crash on the Single Race setup screen)

Log `shad_log_run290cold_2026-09-06_1329_guestcrash.txt`, dump `guest_crash_run290cold_*.dmp`,
autoshots 13:24-13:28 (`CUSA24769_20260906_132418..132858`). Preloaded 0 (new build) - the warm
launch never happened because the cold one crashed; the warm cache test is still owed.

### 1. What the user saw, and what the autoshots confirm
- Music Rally menu 4-6 fps with black wedges over the scenery, overexposed stands, cyan squiggles
  top-right that are a garbled glyph (000055/000067) - "letters fly" in a COLD run. The Display
  Settings scene (000022) renders perfectly, so the far scenery CAN be right.
- Car select (000072): the 3D car black, Roadster/MINI thumbnails noise. Then the World Map
  (000103) perfect, then the Single Race setup screen (000112-000129) with GREEN card panels and
  green block logos. Measured pixel (65,215,65)..(77,238,77): shaded, so the GAME draws it (a
  placeholder for an image that never arrived), not a raw clear. 2 s after the car was picked:
  guest crash #4, same instruction as 286/288/289.

### 2. `[mipbake]` pinned FIRED - the cold hole is real, and it is a far-mip corruption
cs **0x2a0cfcd2** perm 2 compiled off an 8-mip T# and perm 3 off a 9-mip T#, against a program
layout of **7** slots (images[3]). Before the pin those modules indexed past the descriptor set;
with the pin their mips past slot 7 collapse into slot 7. Either way the two SMALLEST mips of
whatever that shader produces are wrong, and small mips are exactly what distant surfaces sample:
"close textures drawn, far ones blur and trash" is what a broken mip tail looks like. The old
`live != baked` log had a global cap of 16 lines, all eaten by da05e7f8, so this shader was never
seen before. **Fix in this commit:** `ImageResource::kDynamicMipSlots = 16` - a DynamicIndex
storage image always has 16 descriptor slots (the T# mip fields are 4 bits wide), in the SPIR-V
array, the set layout and the bind loop; `LiveMipCount(tsharp)` is the only live quantity and
only drives the duplicate-last-level clamp. The specialization no longer splits perms by mip count.
`ShaderMetaVersion` 5 -> 6.

### 3. `[faultloop] owner`: orphaned watchers, not owned pages
Every forced-RW page in the 0x201... region: `tracker perms 0x1, write watchers 1, buffer cache
registered false, images on the page 0`. Write watchers come from the texture cache alone
(TrackImage), so a watcher with no image on the page is a LEAK (an image re-based after tracking,
or a Head/Tail untrack that no longer matches the tracked range), not a cache that still owns the
page - the stale-GPU-data hypothesis for these pages is refuted. Cost: 32 faults + one forced RW
per page, once. This commit adds a scan of every TRACKED image (slot_images, not the page table)
to the `[faultloop]` line: `TRACKED image ... watches a..b` names the leaker, `tracked images
covering it 0` proves the leak. 0x10a2bcf440 (SceLibc_Thr) is a different animal: `tracker perms
0x3` (RW) but the host page not writable = tracker/host desync, GT_FAST_PROTECT territory.

### 4. `[metaread]`: fs 0xa3fd67d5 samples the CMask address 0x100a2f0000 as a 480x270 R11G11B10
Once per run in this instrument's terms, about once per frame in run 288's count. Either the game
reads its own CMask (no engine does that for a float 480x270) or the registration outlived its
render target and the memory now holds a bloom/DoF quarter-res buffer. This commit records who
registered each meta (RT address, size, tick) and prints the age in the line.

### 5. The crash, fourth time, with the ring
`rbx 0x10fd28020 -> Free 0x82abc000+0x17d544000`; run 289 had rbx 0x10f81ce50 in the same gap.
The 128-entry ring (last 8 shown) held only Direct maps/unmaps at 0xf417400000 - nothing near
rbx. So it is not a use-after-unmap of the last few operations. `rax = 0xdeadbeef54321abc` every
time (a fill pattern or canary), `rdi/r15` in Direct 0x1020400000 prot 0x33, return address
`libc.prx+0x4db4a` = a libc routine calling back into eboot (comparator / callback style). This
commit: ring 1024 deep with asked/granted address, return code and VMA name; `UnmapMemory`
refusals recorded; the whole VMA map printed at the crash (`guest crash: vma ...`) so the Free
gap can be placed between its neighbours; matches on the GRANTED range too.

### 6. FCE draws dropped without a clear - 50-60 per second on the green screen
`drops: fce 76-116` per 2 s window with `fce cleared 0`: `EliminateFastClear` finds the CMask not
tracked as cleared and the draw is dropped with NO clear. On real hardware the FCE writes the
clear colour into every tile the CMask marks cleared; we keep the old pixels. On a screen whose
cards are drawn onto fast-cleared offscreen targets that is stale content; on a target the game
never draws into it is whatever was there. This commit logs per target which FCE is dropped and
the game's clear colour (`[fce] mrt ... clear (r,g,b,a): N dropped`) - if a target's clear is the
green above, the panels are OUR missing clear after all.

### 7. Performance, measured ([fprof])
Music Rally menu: 31990 draws / 2 s = about 2700 draws per frame at 6 fps, `draw 1226 ms` of a
1391 ms busy window = **about 43 us per draw** (bindtex 10.5 us, bindbuf 10, pipe 5, state 4.4,
vtx 1.7), plus 17k V# tail clamps per window (`softclamp tail 17406 maptail 17406` - one mapping
walk each). Race setup screen: 40-48k draws / 2 s, 2400-3400 dispatches. The GPU thread is the
frame; the guest Job#0 runs at 91% and `tm_ffb_eventHandleThread` (Thrustmaster force feedback,
inside our process) spins at 99% of a core. The trash does not cause the fps; the per-draw cost does.

### 8. `[copylayers]`, read again
The min-coercion happens on THREE paths and the log did not say which: `CopyImage` (whole image,
base layer 0), `CopyMip` (a single-mip image into mip/slice of a larger one - the destination
slice IS applied, so "layers 1..7 keep their OLD contents" was wrong for that path) and `CopyMrt`.
This commit names the path and the destination layer range. The cubemap faces (256x256, 9 mips,
8 layers, B10G11R11) go through CopyMip with a slice, i.e. probably correctly; the black car is
not explained by this and the log will now say so.

## RUN 291 (pre-declared, build 6 Sep 14:09, `GT7_probe291.bat`, run TWICE)
- `[mipbake]` silent all run -> the 16-slot design holds. Far scenery sharper / less trash -> the
  broken mip tail was (part of) it; unchanged -> the far trash is elsewhere (metaread / fce).
- `[cacheverify] ... 0 differ` warm AND letters fly warm -> the cache Info is clean; what WarmUp
  rebuilds besides Info is next (GraphicsPipelineKey / SerializationSupport / binding numbers).
- Warm plays like cold -> 287/288's flying letters were the module/pipeline path we since
  replaced; confirm on a second warm run before believing it.
- `[fce] ... clear` close to (0.25, 0.85, 0.25, 1) on a target the size of a card -> the green
  panels are our dropped FCE; fix = treat an FCE on a fast_clear target whose CMask we cannot
  track as the clear it is (GT_FCE_FORCE=1 exists as the A/B), or track the CMask write path the
  game uses.
- `[metaread] ... registered by RT 0x... WxH at tick T (N ticks ago)`: a large age with the RT
  gone -> stale registration; erase metas when the address is re-used by a texture.
- `[faultloop] ... TRACKED image ...` -> the leaker is named; `tracked images covering it 0` ->
  leak without a live owner; look at TrackImage/UntrackImageHead/Tail against images whose
  guest_address changed after tracking (texture_cache.cpp:847 rebases info.guest_address).
- Crash again -> `guest crash: vma` lines place the Free gap; `map ring ... got 0x... rc` shows
  whether the game asked for that range and was given another, or was refused.

## NEW CHAT - START HERE (written 6 Sep, ~14:00) - supersedes the 13:40 one above

**State.** HEAD = this commit, installed exe = build 6 Sep 14:09 (probe 291). The user runs
`GT7_probe291.bat` twice; both logs matter (cold = far scenery / green panels / crash instruments,
warm = the cache). Grep order: `Preloaded`, `[mipbake]`, `[cacheverify]`, `[fce]`, `[metaread]`,
`[faultloop]`, `[copylayers]`, `DEVICE FAULT`, `Unhandled Exception`, `guest crash: vma`,
`guest crash: map ring`. Archive each log with PID/time into `GT7_work/logs/` before the next launch.

**Then, in this order:** (a) RUN 291 verdicts above; (b) the green panels via `[fce]`; (c) the far
scenery via `[metaread]` plus whatever remains after the 16-slot fix; (d) the crash via the VMA
dump; (e) performance (verdict 7: 43 us per draw).

**Rules this run adds.** (xiv) A per-run log cap hides every later offender: cap per KEY (shader,
page, target), never globally. (xv) Measure a colour before naming it: (65,215,65) shaded is a
game-drawn placeholder, (0,255,0) flat would be a clear. (xvi) When an instrument says "min of
two counts", make it say WHICH path and WHERE the copied part lands - the same number meant
"correct" on one path and "stale" on another.

## RUN 291 VERDICT (6 Sep 14:13-14:18, build 14:09, ONE cold launch, guest crash on car select)

Log `shad_log_run291cold_2026-09-06_1418_guestcrash.txt`, dump `guest_crash_run291cold_*.dmp`,
autoshots 000071-000120. Preloaded 0. The warm launch is still owed (the cold one crashed first).

1. **`[mipbake]` silent all run.** The 16-slot design holds. The far trash did not change, so the
   broken mip tail was at most part of it.
2. **`[fce]`: ONE target, the 1920x1088 main RT, clear black / 0.1 grey.** That is run 254's
   per-frame no-op FCE (GT7 writes the CMask once at creation; the console never clears it either).
   Not the green panels, not the stale far pixels. FCE is closed.
3. **`user-data push overflow (slot 16)` on six shaders** (0xdbbb8a3c, 0xd9b26049, 0xebf4dd53,
   0xe7592758, 0x5ce51c50, 0xc0a6b0be; the log cap is 16 lines so the rate is unknown). The
   pipeline's stages together want more than the 16 push-constant UD slots PushData carried; the
   last stage's remaining UD regs were dropped and that draw ran with garbage constants, every time
   that pipeline drew. Garbage constants on a vertex stage = the red/white cone hanging from the top
   of the Music Rally frame (000071-000079) and the gantry / kerbs repeated to the horizon (000101):
   geometry with wrong transforms. **Fix in this commit:** `NUM_PUSH_UD_REGS = 32` (PushData 184
   bytes, `static_assert <= 256`), the SPIR-V AuxData block has eight `ud_regsN` members and the
   `buf_offsets` members moved to offset 144; the GCN per-stage `NUM_USER_DATA_REGS` stays 16 (the
   flatten pass's dst offset depends on it). `vk_instance.cpp` logs CRITICAL if the device offers
   fewer push bytes than PushData needs.
4. **`[metaread]`**: 0x100a2f0000 was registered as the CMask of RT 0x100a0b0000 512x512 sixteen
   ticks before fs 0xa3fd67d5 sampled it as a 480x270 texture. Stale registration, once per run;
   low priority (erase metas when a texture lands on the address).
5. **`[faultloop]`**: `tracked images covering it 0` - the orphan watcher has no live owner.
6. **Crash #5**: eboot+0x344789e, rbx 0x10f83cd90 in the Free gap 0x82abc000+0x17d544000. The three
   rbx values (0x10f81ce50, 0x10fd28020, 0x10f83cd90) all sit within 5 MB of each other in that gap.
   The 1024 ring held only 0xf417... anon map/unmap churn (6629 operations total). The VMA map is in
   the log (378 lines) - the gap's neighbours are the eboot segments below and 0x200000000 above.
7. Also seen, uncapped rate unknown: fs 0xe8b53da0 binds a T# at 0x2920000000 in a free VMA (16
   logs); `[imgarray]` 15/16 null for shader 0xa95f906e and 5/16 for 0x3e50e1 (addr 0 entries).
8. `[copylayers]`: every entry is CopyMip into slice N of the 256x256/128x128 cubemap - correct path.

## RUN 292 (pre-declared, build 6 Sep 14:27, `GT7_probe292.bat`, run TWICE)
- "push overflow" absent and the cones / repeated far geometry gone -> verdict 3 was the far trash.
- Still there -> next suspects: the free-VMA T# of 0xe8b53da0 (null texture on a far draw), the
  `[imgarray]` nulls, or the far-LOD instanced path.
- Warm: letters fly? `[cacheverify]` differ count.

## NEW CHAT - START HERE (written 6 Sep, ~14:30) - supersedes the 14:00 one
HEAD = this commit, installed exe = build 14:27 (probe 292). User runs `GT7_probe292.bat` twice.
Grep order: `push overflow`, `Preloaded`, `[mipbake]`, `[cacheverify]`, `FAILS IsMappedMemory`,
`[imgarray]`, `[metaread]`, `[faultloop]`, `DEVICE FAULT`, `Unhandled Exception`, `guest crash: vma`.
Archive logs into `GT7_work/logs/` with PID/time before the next launch.
Rule (xvii): a per-process log cap on a per-DRAW defect hides its rate - when the cap is hit, add
the count to the `[fprof]` window line before drawing conclusions from "16 so far".

## RUN 292 VERDICT (6 Sep 15:41-15:50, build 14:27, ONE cold launch, guest crash #6 same rip)
Logs `shad_log_run292cold_2026-09-06_1550_end.txt`, stuckstacks 154203/154806/154928.
- **"push overflow": 0 lines.** The 32-slot PushData holds.
- **The user saw 1-3 fps and minute-long loads.** All three stuck dumps have the GPU thread inside
  `nvgpucomp64.dll` under `vkCreateGraphicsPipelines` (GraphicsPipeline ctor); `[fprof]` windows
  with `pipe` 21 s, 29 s, 38 s, 45 s, 65 s. The NVIDIA GLCache (920 MB) was rewritten during this
  run and NOT touched during run 291: every shader's SPIR-V changed (new push block), so the driver
  compiled every pipeline from scratch for the first time since run ~252. One-time cost; a second
  launch is served from the driver cache. Pipeline creation is synchronous on the GPU thread, which
  is why the game "sticks" - the process was never deadlocked.
- **Autoshot 000059 (race, 15:44:47) is CLEANER than 291's 000101:** no gantry / kerb repetition to
  the horizon, pit buildings and banners coherent. The black fence panels remain. Judge for real on
  the warm run (the cold frames were taken at 1-3 fps mid-compile).
- Crash #6: eboot+0x344789e reading 0x10e342f30 (same routine, different rbx). Not related to this
  build.
- NEXT: warm launch of probe 292 (no rebuild!). Then far scenery / black panels / car colour.

## RUN 292 WARM (6 Sep 15:57-16:05, build 14:27) - HANG on the Single Race setup screen
Log `shad_log_run292warm_2026-09-06_1610_stuck.txt`, stack `stuckstack_20260906_160332.txt`.
- WarmUp preloaded 2766 pipelines (Main at 100% for ~1 min = that). `[cacheverify]` 3073 checked,
  63 differ, ONE HEAL (cs 0x6421a7b6 perm 6, spv DIFF at dw 3), no DEVICE LOST.
- User: 4-11 fps Music Rally, image unchanged, stale far frames unchanged. So the 32-slot push fix
  removed the UD overflow but is NOT the far trash. `[mipbake]` silent.
- HANG at the Single Race setup screen (autoshot 000126 = green panels, the 289-291 crash screen):
  `GpuCommandProcessor` idle in `Liverpool::Process` CondvarWait (num_submits 0), `Job#0` and
  `tm_ffb_eventHandleThread` at 100%, everything else waiting. Last GPU-side packets: DingDong vqid 4
  offsets 140 and 144 (monotonic 100..144 before - not the 285 remap bug), SubmitDone, nothing
  after. Job#0 polls something the compute queue should have produced. Hypotheses, none proven:
  (a) a dispatch skipped (IsComputeMetaClear "metadata update skipped", HLE, empty-dynrc skip,
  BindResources false); (b) a ReleaseMem/WriteData fence lost or overwritten; (c) a compute shader
  with a loop capped at 16384 (`[loopguard]`) never finishing its work/flag.
- Same screen, three outcomes (crash x3, hang x1) + green placeholder images = one defect: the
  compute work that produces this screen's images does not complete as the game expects.
- Build 16:13 = `GT_ACB_WATCH` (Liverpool: ring of ASC WriteData/ReleaseMem labels + per-submit
  dispatch counts, dumped with the current memory values when the GPU idles > 8 s after ASC work).
  `GT7_probe293.bat` = 292 + that knob. Run once, go to the Single Race screen and wait.

## CONTINUED IN `HANDOFF_RENDERING_ACT3.md` (6 Sep 17:00)
Run 293's verdict, the eboot disassembly of the crash/hang path, run 294's instruments and the
new "start here" live in ACT3 - a short, self-contained file. This file stays as history.
