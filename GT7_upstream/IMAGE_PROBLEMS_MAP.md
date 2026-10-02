# GT7 1.71 image problems: what to chase

29 Sep 2026, watcher/auditor. **Parked.** The order is the user's: make the game stop crashing first, then take
these one at a time.

The crash work also comes first for the images' own sake. The first test for the missing road (row 1) is Precise
readbacks from boot, which adds a full GPU drain for every read fault and killed the lab's run 260. On a build that
already crashes often, a new crash could not be told apart from the old ones.

- Evidence, with line numbers, for every row: `logs\lab_rendering_patches_review.txt`. The letter in each heading
  is its section there. Row 7 also rests on the "Side finding" of `REPORT_PR5165_PR5166.md` (lines 205-224).
- Photos of the current state: `logs\user_photos_test27_gt7_1\01_flyover_text.png`, `03_black_shapes_text.png`,
  `04_field_streaks_text.png`.
- The lab ran GT7 **1.00** (CUSA24769) on v0.18.0. The current line runs **1.71** (CUSA24767) on upstream main.
  Re-measure a row on 1.71 before acting on it.
- Code lines are at upstream e518a651, the TEST25 base.

## The setting behind most of the photos

Every current run logs `GPU readbacksMode: 0`, `GPU readbackLinearImages: false` and
`GPU directMemoryAccess: false` (log lines 16-18; profile `C:\shadps4-test19-gt7\user\config.json` lines 20, 34,
35). The profile stays that way so TEST25/26/27/27b remain comparable.

- **Readbacks 0.** GT7's CPU decides which scenery draws to issue from data the GPU wrote: indirect args, counters,
  descriptors, pointer chains. It reads zeros, so road, terrain and buildings are never drawn. Trees survive because
  they go through the GPU-driven instanced path.
- **DMA off.** A constant read whose offset is only known at run time returns flatbuf dword 0.

## The map

| # | What you see | Cause | Lab patch, verdict | Chase next |
|---|---|---|---|---|
| 1 | road, terrain, buildings missing | readbacks 0 | `GT_READBACKS_ONRACE`, temporary | run (a) |
| 2 | distant road and terrain; near-road detail | not found | none | after row 1 draws |
| 3 | red minimap | not found (two lab theories) | LUT hash and identity LUT, not fixed | runs (a) and (b) |
| 4 | wrong material values | DMA off | `GT_DYNRC_WINDOW`, temporary | run (b) |
| 5 | whitewash | NaN from one compute shader | `GT_RT_SCRUB`, temporary | does it happen on 1.71 |
| 6 | corrupted far mips | mip-slot count | 16 fixed slots, a real defect | nothing: fixed in our builds |
| 7 | wrong letters | two texture-cache paths miss CPU writes | none | the fix, then count the reports (the report's TEST28) |

Not an image problem: the lab's 32-push-slot patch belongs to the info.h:183 crash. It is on the crash list (last
section).

## 1. Road, terrain and buildings missing (A)

- **Seen:** road, terrain and buildings black or sky-coloured; long green/yellow streaks across the fields. Trees,
  flowers, spectators, sky and the HUD are drawn (photos 01, 03, 04).
- **Cause (lab runs 259-268):** the environment colour draws are never issued, because the CPU reads the GPU-written
  data as zeros. The ground is in the depth prepass and in no colour pass. The scene target is never cleared, so
  unwritten pixels keep old content. With Precise readbacks the environment is drawn (run 268).
- **Lab patch, temporary:** `GT_READBACKS_ONRACE` (53fb40e0 and five follow-ups) switches Precise on at run time,
  after three 2 s windows with more than 500 colour indirect draws.
  - The trigger is a GT7 draw count; on 8 Sep it stopped firing when `GT_FRAME_PROF` was turned off.
  - It exists because Precise from boot killed the guest at t=82 s in run 260. That cause was never found.
  - Its tracker changes repair states that only a run-time flip creates; upstream reads the mode once.
  - It relied on the lab-only `GT_BDA_IMPORT`, an 8448 MiB host-memory import that upstream does not have.
  - Cost: 200-530 read faults per 2 s, each a full GPU drain; 15-40 % of the render thread.
- **Touches:** the readback mode is read once into const members: `region_manager.h:30`, `memory_tracker.h:23` and
  `:158`.
- **Chase next:** run (a). Does the road draw, does the guest live past the menus, what does it cost. If the guest
  dies, that death is the thing to chase: the lab never explained it, and upstream's memory tracker has been
  reworked since (#5100, in e518a651).

## 2. Distant road and terrain, near-road detail (B)

- **Seen in the lab after its road fix:** missing distant road, grey holes in distant terrain, green/yellow strips.
- **What the lab found:** a streamed-texture tile cache (four 128x128 arrays of 488 layers in BC7 sRGB, BC7, BC6H
  and R8Uint, plus a 1024x1024 R32F table with 4 mips), inferred to be fed from a per-circuit tex_stream file. In
  every lab race window it received 0 uploads, 0 copies and 0 shader writes, with readbacks off and on. The road
  texture the lab did see came from another path, never identified. One contributor to the strips is the direct
  draw vs 0xc07f0762 / ps 0x66b12a5c, not root-caused.
- **The user's recollection** from the lab, "far textures are mips, near ones are T# with more detail": not in the
  notes. They record the cache and that it was never fed.
- **Lab patch:** none. **Touches:** not known.
- **Chase next:** only once row 1 draws. Count the uploads, copies and shader writes into those arrays on 1.71
  (needs a `GT_*` log line from the builder); that is also where the recollection above gets checked.

## 3. Red minimap (C)

- **Reference:** on a PS4 the minimap is a white outline on a transparent background (GT7_DEBUG_NOTES.md 105-109).
- **Lab theories, in order:**
  1. Act 12: the grading LUT is overwritten by RefreshImage's GpuDirty re-upload of stale guest RAM.
  2. Act 13, later: the map is a one-shot producer that ran once on zeros through the DMA fault path (the first read
     of an unregistered page returns 0). The notes say it "needs pre-registration or replay and is NOT yet fixed",
     and no later note records the map fixed.
- **Lab patches:** the `lut_shaped` hash (c66b0d04 / f9d50092) covers one texture shape, 64x64x64
  R16G16B16A16F: temporary (the general version stalled the boot, 9f4f63f4). `GT_LUT_IDENT` is a hack by the lab's
  own audit.
- **Touches, the same clobber class upstream:**
  - `ObtainBufferForImage` copies from guest RAM unless the buffer tracker marks the range GPU-written
    (`buffer_cache.cpp:194-203`). Shader and render-target writes to an image never set that mark.
  - `RefreshImage` re-uploads every mip whose guest hash changed (`texture_cache.cpp:733-741`), and every mip when
    GpuDirty (`:723`).
  - With readbacks 0 guest RAM never holds GPU-produced texels, so any refresh of a GPU-produced image uploads stale
    bytes over it.
- **Fix direction:** a refresh must not replace GPU-produced texels with guest bytes the CPU did not write.
- **Chase next:** look at the minimap in runs (a) and (b).

## 4. Wrong material values with DMA off (D)

- **Seen:** not tied to a photo yet.
- **Cause:** a ReadConst whose offset the flatten pass cannot resolve keeps Flags 0 and marks the shader as needing
  DMA (`shader_info_collection_pass.cpp:154-158`). With DMA off the shader is built without it (`:179-182`), and the
  read becomes a load of flatbuf dword 0 (`emit_spirv_context_get_set.cpp:60-69`). GT7's material shaders use these
  reads: the lab's window fed dozens of shaders, fragment materials included.
- **Lab patch, temporary:** `GT_DYNRC_WINDOW`, a CPU snapshot taken at walk time, wrong for GPU-written tables by
  the lab's own reading.
- **The general mechanism** is upstream DMA (BDA page table and fault buffer). It has the first-read-zero behaviour
  of row 3's second theory.
- **Chase next:** run (b). The log then names every shader with such a read ("Enabling DMA for shader ...").

## 5. Whitewash (E)

- **Lab:** NaN from cs 0xda05e7f8 (normalize(0) on an unwritten window). `GT_RT_SCRUB` zeroes NaN and clamps every
  fragment output. The lab calls it containment: temporary, and the producer was never fixed.
- **Touches:** not traced to emulator code.
- **Chase next:** does cs 0xda05e7f8 run on 1.71, and is the washed-out left half (next section) this.

## 6. Corrupted far mips (F): done

- cs 0x2a0cfcd2 was compiled for 7 mip slots while its T# carried 8-9 (lab run 290). Upstream takes the slot count
  from the T# (`resource.h:168-173`) into the specialization key (`specialization.h:144`). In the current line the
  mismatch came from preload building every permutation from one user-data snapshot.
- **Fixed** by 745d7716 "Preload: build a pipeline from its own permutation's flattened user data", in every test
  build from TEST19b on, so in all of TEST25-27b. HANDOFF.md lists the same commit title as f13bf337 = 0db8c566.
- The lab found the far scenery unchanged after its own version of this fix, so it is not the cause of row 2.

## 7. Wrong letters (H): two texture-cache paths

- **Seen:** letters wrong, and different on every run. Example from the rebuilt pr5165 run 2: "Press the OPTIONS
  Cuttor while drivir g to Crir g up the Pause Mer u" (`logs\test27b_rebuild_run_2_audit.txt` line 3).
- **Measured** by the 27b stale-image check. It hashes an image's whole guest range at upload and again later, and
  reports images whose memory changed while the texture cache still considered them clean: **76 reports over the
  13 TEST27b runs** (`REPORT_PR5165_PR5166.md` 205-224). 69 of them are R8Unorm images 64 texels wide (16-36 rows);
  the rest are 4 R8G8B8A8Unorm 32x32, 2 R32G32Uint 4x4 and 1 BC7 340x340. One report falls on the same screen as a
  wrong-glyph dialog in the user's photo.
- Both paths below are branches of `TextureCache::InvalidateMemory` (`texture_cache.cpp:125-154`). That they miss
  CPU writes is measured; that this is what draws the wrong letters is very likely, not proven.
- **Fix direction (the report's, not tested):** compare the whole image instead of its first 64 bytes, and treat
  partly watched images the same way.
- **Chase next:** the report's TEST28, TEST27b rebuilt #5165 plus that fix. If the letters draw right and the
  reports drop to zero, the cause is proven. (#5165 is now in upstream main, so that base is main's.)
  Not the build called TEST28 on 29 Sep: branch test28-snormnz-conv 05d66732 is the pixel_format.h:359 SnormNz fix,
  a crash test, and does not touch the texture cache.

### 7a. 34 reports: images inside one page, kept by the 64-byte check

When a CPU write faults on a page that holds a whole image without touching it, `InvalidateMemory` unprotects the
page and marks the image MaybeCpuDirty (`texture_cache.cpp:148-151`). Later writes to that image no longer fault,
so a hash test in `RefreshImage` is the only thing that can see them.

- `MarkAsMaybeDirty` seeds `image.hash` over the whole image, but only while the hash is still 0 (`:115-121`).
- The test hashes only the first 8x8 texels' bytes (64 bytes for R8Unorm) and compares them with `image.hash`
  (`:700-716`).
- The first test does not match the whole-image seed (unless the image is only those 64 bytes), so it uploads, and
  line 717 stores the 64-byte hash. Every later test compares 64 bytes with 64 bytes and skips the upload while they
  match, whatever changed in the rest of the image.
- The code's own comment (`:702-704`) says the path only sees images under a page, and that 64 texels is "for now".

### 7b. 42 reports: images spanning 2 or more pages, partly watched

39 span 2 pages, 2 span 7, 1 spans 31.

- When a CPU write faults on the first or last page of such an image without touching the image, `InvalidateMemory`
  removes the watch from that one page and does not mark the image (`:137-147`; `UntrackImageHead` /
  `UntrackImageTail` at `:900-935`). The code's comment expects a real change to "receive more invalidations on its
  other pages".
- A later write to the image's part of that page no longer faults, and nothing else marks the image, so the cache
  keeps the old texels.
- A 2-page image that loses the watch on both of its pages is marked MaybeCpuDirty instead, and lands in 7a
  (`:909-914`, `:928-933`).

## Seen now, not mapped yet

HANDOFF.md (lines 119-120) lists three more visuals that no row above covers: the **washed-out left half**, **black
stripes**, and a **flat grey mirror**. Row 5 is the first candidate for the washed-out half; nothing is known yet
about the other two.

## Moved to the crash list: push user-data overflow = info.h:183 (G)

- The assert is in `Info::PushUd`: `ASSERT(bnd.user_data < NUM_USER_DATA_REGS && index < NUM_USER_DATA_REGS)`, with
  NUM_USER_DATA_REGS = 16, reached per stage from BindResources in `vk_rasterizer.cpp`. Every assert context so far
  is a tessellated pipeline (ls, hs, vs, fs).
- Rebuilt pr5165: all 4 runs that reached the race ended with it, two right after the pause menu
  (`logs\test27b_rebuild_runs_3_5_audit.txt`). Rebuilt pr5166 run 1 ended with it after the pause menu.
- The lab logged "user-data push overflow (slot 16)" on six vs shaders in run 291, 0xdbbb8a3c and 0xd9b26049 among
  them: the vs of the rebuilt pr5165 r4 and pr5166 r1 assert contexts.
- Lab patch f7ec625e, temporary: 32 push slots make PushData 184 bytes. Upstream keeps
  `static_assert(sizeof(PushData) <= 128)` (`resource.h:237`), the push-constant size every Vulkan device must
  support.

## The two configuration-only runs

- (a) `readbacksMode` 2 (Precise) from boot.
- (b) `directMemoryAccess` true.

Each one from a **copy** of the profile. `C:\shadps4-test19-gt7` stays at 0/false. No code change. The user decides
when, after the crash work.

## How to use this map

- One row at a time.
- Do the row's "Chase next" first: re-measure on 1.71 before changing any code.
- Fix the general mechanism, not the lab patch. A fix becomes a PR only under the three criteria in the lane rules
  (CLAUDE.md).
