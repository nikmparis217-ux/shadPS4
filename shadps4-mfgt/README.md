# My First Gran Turismo (CUSA49696, 01.01) on shadPS4

A separate game from GT7. The lane does not run it: no exe, launcher or profile here, only logs that other people
made and the user passed on.

## logs\pr5218_external_1790982170991.txt (3 Oct 2026)

- From the user's Downloads (`1790982170991.txt`, 20,247,761 B, cmp IDENTICAL; SHA256 eb616ce6...). An outside tester
  ran PR #5218 (resource guards): revision cdf0dee7 = GitHub's test merge of the PR head b7d6cf22 into main ead912cf,
  the commit the PR's CI builds. `resourceGuards: true`, `directMemoryAccess: true`, readbacksMode 1, pipeline cache
  off; Ryzen 7 7800X3D, 32 GB, Windows 11 Home.
- 807 shader compiles, 582 graphics + 55 compute pipelines, 0 "Unknown opcode", no recompiler assert.
- Ending: `liverpool.cpp:917 ProcessCompute: Unreachable code!` "Invalid PM4 type 0" (the packet reader of the
  compute queue), right after "Compiling cs shader 0x76be7cf5 (permutation)" and main's "Rejecting invalid T#
  address=0xff00000000, pitch=14336, width=0, data_format=48, num_format=15". The tester's screenshot: the main menu
  with License Center highlighted and the intro dialog on screen, flip frame 3248, 29.8 fps, green blocks over parts
  of the menu.
- Upstream #5204 (open, 1 Oct, official nightly without #5218) reports the same line when a license tutorial video is
  opened. So #5218 neither causes nor fixes this ending.
- The game's earlier upstream crashes, both fixed on main by 1 Oct: #5173 `resource.h:485 MaxAniso` unreachable,
  #5195 `image.cpp:121` assert.
- Not shown by this log: whether the guards change anything here (the green blocks included); that needs the same
  spot with `resourceGuards` false.
- Summary script: `C:\shadps4-gt7\GT7_upstream\builder_scripts\ext_log_summary_v1.sh <log>`.
