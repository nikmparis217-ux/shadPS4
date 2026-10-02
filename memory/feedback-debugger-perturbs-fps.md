---
name: feedback-debugger-perturbs-fps
description: crashcatch is a debugger - every first-chance AV freezes the whole emulator; never read FPS from a run with it attached
metadata:
  node_type: memory
  type: feedback
  originSessionId: 69673bdb-6869-4891-9c3e-5db85d30824f
  modified: 2026-09-27T01:53:17.847Z
---

crashcatch (scratchpad `crashcatch.exe`, DebugActiveProcess) attaches at `EVENT_ROOT PlayGoProject::EventSelectRoot`, so the whole race runs under a debugger. Windows suspends every thread of the debuggee on each debug event until the debugger answers, and shadPS4 raises first-chance access violations for its own memory tracking. Measured rates (report line "first-chance exceptions while attached"):
- TEST12 run 1: 5,260/s (1,277,131 in 242.8 s);
- TEST13: 3,957/s and 5,214/s;
- TEST14 run 1: 7,818/s.

The periodic rate lines print only after 1 s with no exception, so peaks are lower bounds; the per-run average is exact. Every "1-7 FPS" figure from TEST10-TEST14 was taken with the debugger attached. The cost per event was never measured.

It may also make crashes more likely, but it is not required for them. On builds that contain the preload fix f13bf337, NVIDIA GPU resets (nvlddmkm event 153, usually followed by "Device lost during submit"):
- **with crashcatch: 4 of 4** (TEST13 runs 1-2 cold, TEST14 run 1 and TEST15 run 2 warm);
- **without it: 4 of 13** (TEST5 runs 1-2, TEST14 run 2, TEST15 runs 3-6, TEST16 runs 1-5, TEST17 run 1). The four are TEST15 run 6 (153 at 04:00:10 on 27 Sep), TEST16 run 3 (04:21:44), TEST16 run 4 (04:23:37) and TEST17 run 1 (04:36:02), all in the menus.

**6 of the 7 menu resets, with and without the debugger, carry the same data signature.** TEST17 run 1 carries a different one, found by the peer: an image range of 1.56 GiB (0x109ed93000-0x11026a0000) that is "not fully GPU mapped", and right after it the only "Migrating arena" line in all TEST11-17 logs. I first misread that size as 99 MB by dropping a hex digit; compute sizes with shell arithmetic, never by eye. The shared signature: `Tracking memory region 0x3f80000000 - 0x3f80000000 which is not fully GPU mapped` and then `Creating tiling pipeline Thick3DThickPrt_32 detiler`, 9-1270 log lines before the end. None of the 11 runs without a menu reset has that watch. 0x3f80000000 is 1.0f << 8: float data read as a T#. It passes `IsValidGpuMapping(addr, 0)`, which is only a 40-bit range test. The zero-length range does NOT mean the memory is unmapped: `Rasterizer::IsMapped` returns false whenever size is 0. It means the image's u32 `guest_size` is 0, plausibly because garbage dimensions wrapped it, and a zero-size image then gets detiled. TEST17 (c48229d2) rejects such T#s. So the resets look data-dependent, not debugger-caused; the debugger's role is unproven. The peer's earlier hypothesis (the debugger stalls the CPU side past the driver timeout) does not explain the signature.

**Why:** the TEST14 frame-rate run was designed without accounting for the debugger. The confound was caught only because crashcatch counts first-chance exceptions.

**How to apply:** for a frame-rate run, compare like with like (debugger on in both runs, or off in both), and make "debugger off" its own one-difference run. On 27 Sep this was agreed with the peer: TEST14 run 1 with the debugger, run 2 without. Crash probes keep crashcatch.

Related: [[feedback-list-every-difference-between-good-and-bad-run]], [[gt7-shadps4-lane]].
