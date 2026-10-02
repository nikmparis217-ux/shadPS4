---
name: gt7-no-gamepad-dies-at-boot-toproot
description: "GT7 on shadPS4 with the gamepad NOT registered dies ~75-83 lines after BootProject::TopRootWindow (AV). 6/6 runs (TEST18 r1 + 5 TEST20). Check 'Gamepad registered for slot 0' at the start of every run before reading anything into it."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 0bdb4255-1ac0-4abb-9dd3-ea05165bd11b
  modified: 2026-09-27T19:06:36.438Z
---

27 Sep 2026, TEST20 (leave-one-out builds). Five runs (test20b r1-r4, test20a r1) died at exactly the same place, 74-80
lines / 0.2-0.6 s after `EVENT_ROOT BootProject::TopRootWindow`, EXIT 0xC0000005, no Critical, no WER, no nvlddmkm.
I first wrote to the builder that this proved the preload fix was needed. It proved nothing about the fixes.

What was really different from the control, found by diffing the filtered call sequences FROM THE TOP (the first
divergence, at log line ~117):
- control: `TryOpenSDLControllers: 1 controllers are currently connected` + `Gamepad registered for slot 0! Handle: 3`;
- dead runs: `1 controllers are currently connected` but NO `Gamepad registered`, `0 controllers` at ~523, AV after TopRoot.
Across every archived GT7 log (TEST14-TEST20): all 6 runs without a registered pad (TEST18 r1 + the 5 TEST20 runs) died
there; every run with the pad passed it (TEST18 r4 died later, with the pad). Direct confirmation: test20b r5-r7, same exe,
cache and save, pad registered -> passed TopRoot and failed where predicted (device lost at SDRSettingRoot).

**Why:** a missing input device is invisible in every check I had (branch, build, pdb, launcher, cache, save) and still
changes the game's whole path. An equal-looking early death across different builds points at the environment first.

**How to apply:**
- At the start of each run, grep the live log for `Gamepad registered for slot` (within the first ~120 lines, 1-2 s).
  Missing = the run is void; say so at once.
- When a comparison run dies somewhere the control did not, diff the normalized call sequences from the top (strip
  thread names, hex, times; drop sceGnm/NetCtl/Timer noise) and look at the FIRST divergence, not the last lines.
- Separate emulator bug worth its own look later: GT7 with no usable pad AVs right after the first boot screen.

Related: [[gt7-shadps4-auditor-handoff]], [[feedback-list-every-difference-between-good-and-bad-run]],
[[feedback-async-log-loses-the-crash-line]].
