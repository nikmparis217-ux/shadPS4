# PR notes: video_core: commit the emulated-LDS allocation taken from the stream buffer

Branch `pr-lds-stream-commit` (worktree `C:\shadps4-pr-lds`): ONE commit `65b03b2f` on top of
upstream `main` `37cacc59` (22 Sep 2026). Diff: +1 line in
`src/video_core/renderer_vulkan/vk_rasterizer.cpp`, no instrumentation, no trailer.
Not pushed. To publish on the fork and open the PR against shadps4-emu/shadPS4 `main`:

    git -C C:\shadps4-pr-lds push -u mine pr-lds-stream-commit

## The change

```cpp
                const auto [data, offset] = lds_buffer.Map(lds_size, alignment);
                std::memset(data, 0, lds_size);
                lds_buffer.Commit();                       // <- added
                buffer_infos.emplace_back(lds_buffer.Handle(), offset, lds_size);
```

## What the surrounding code does (all upstream, unchanged)

- `SharedMemoryToStoragePass` (shader_recompiler): for a compute shader that uses LDS, when the
  requested LDS size exceeds the host's `maxComputeSharedMemorySize`, or the host lacks workgroup
  explicit memory layout and the shader mixes LDS access types, every LDS access is rewritten into
  an access to a storage buffer binding of `BufferType::SharedMemory` (`ssbo_shmem`).
- `Rasterizer::BindBuffers`: for that binding it takes `lds_size = SharedMemSize * NumWorkgroups`
  bytes from the buffer cache's stream ring (`GetUtilityBuffer(MemoryUsage::Stream)` =
  `stream_buffer`, 64 MB), zeroes them and binds them as the storage buffer.
- `StreamBuffer::Map(size, alignment)`: aligns the ring cursor, wraps to 0 when the region would
  overflow, waits for any GPU work that still references the bytes about to be handed out
  (`WaitPendingOperations` over the previous lap's watches), and returns pointer + offset.
  It does NOT advance the cursor; it only records `mapped_size`.
- `StreamBuffer::Commit()`: flushes the host writes when the memory is not coherent
  (`vmaFlushAllocation`), advances the cursor (`offset += mapped_size`) and records a watch
  `{upper_bound = offset, tick = CurrentTick()}` so that the next lap of the ring waits for the
  GPU work that used these bytes.
- `StreamBuffer::Copy` = Map + memcpy + Commit. `BufferCache::ObtainBuffer` uses it for every
  small read-only guest buffer that is not GPU-modified ("device local stream buffer to reduce
  renderpass breaks"), i.e. the ring also carries per-bind copies of uniform, index and vertex
  data.

## The bug

The SharedMemory path called `Map` and never `Commit`. Three things were therefore missing:

1. The cursor was not advanced. The next allocation on the same ring, typically the `Copy` of a
   small read-only guest buffer for the next bind, started at the same offset and overwrote the
   zeroed LDS backing while the dispatch that owns it was already recorded with a descriptor
   pointing there. In the other direction, the dispatch's LDS stores landed in bytes that a later
   draw or dispatch read as its own uniform, index or vertex data.
2. No completion watch was recorded, so even across a wrap nothing waited for the dispatch.
3. Host writes were not flushed on non-coherent memory.

Audit: the other six `StreamBuffer::Map` call sites (`buffer_cache.cpp` 123 / 439 / 728 / 827,
`texture_cache.cpp` 80, and `StreamBuffer::Copy`) are all paired with `Commit`. This was the only
one without.

## Evidence (GT7, CUSA24769 v01.00, fork gt7-main, subgroup-32 host)

GT7's GPU-driven pipeline runs a 64 KiB-LDS compute shader every frame next to a compute shader
that produces indirect-draw argument tables from inputs the emulator stream-copies. Symptom:
argument records came out absurd (indexCount above 2^24, at record indices 1 mod 16), the huge
indirect draws stalled the GPU for seconds and ended in VK_ERROR_DEVICE_LOST; distant objects
showed "flying" colours.

| run | binary | producer tables | absurd events | end |
|---|---|---|---|---|
| 345 | observers, WITHOUT the line | 56,037 | 2 (+ device lost at 817 s) | device lost |
| 346 | same binary + `Commit()` | 152,011 | 0 | closed by hand, 1,337 s |
| 347 | merged with upstream 4621b6a1 | 35,021 | 0 | unrelated shader-recompiler assert |
| 348 + 349 | diagnostic post-dispatch capture OFF | 77,519 | 0 | unrelated (see notes) |

Total after the fix: 264,551 producer tables, 0 events, 0 LDS ring overlaps in the allocation
ledger (single LDS user, 64 KiB, align 16), 0 multi-second GPU waits, 0 device loss.

## Not done (owner's decision, 22 Sep 2026)

Vulkan validation-layer run, God of War 2018 / Ghost of Tsushima regression runs, a standalone
StreamBuffer reproducer, and a from-scratch build of the PR worktree (its submodules are not
initialised; the identical line is built and run in gt7-main `b1cd966e`). CI builds the branch
when the PR is opened.
