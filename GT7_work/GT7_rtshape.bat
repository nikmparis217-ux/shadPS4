@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM GT7 vertical-atlas alias plus the cs_0x018256c0 live-loop watchdog.
REM
REM The same guest address was measured as a 1920x2160 color target and a 1920x1080 sampled
REM texture. Sample count is 1 and the two negative-height viewports select the top and bottom
REM 1920x1080 fields. This run copies the newest GPU-rendered top field into the separate Vulkan
REM image required by the smaller same-base T# before it can upload stale guest RAM.
REM Device-fault dumps isolate a deterministic GPU timeout to cs_0x018256c0. Runs 191/192
REM disproved the GPU-time-read theory: the CPU walker already captures valid block/extent
REM scalars at flatbuf 2114/2115, while the BDA override makes the dispatch hang. Keep only the
REM record-count watchdog and trace the true post-window scalar slots.

title GT7 - render target shape probe

set GT_RT_NOCLOBBER=0
set GT_LUT_IDENT=0
set GT_IMG_TRACE=0
set GT_VERTICAL_ALIAS=1
set GT_GPUWRITE_NOCLOBBER=0
REM Runs 196/197 proved that N=64 and N=8 can both leave enough parse-to-execute lag for
REM NVIDIA to time out, while N=1 passes the same wall. Keep the known-stable cadence until
REM the lighter queue-pacing replacement is implemented.
set GT_SPLIT_DISPATCH=1
set GT_18256C0_GUARD=1
set GT_18256C0_LOOP_MAX=1024
REM Run 198: with the cache warm and the watches off, FPS still decayed 10-3 with the CPU at
REM 11-12 cores and the GPU at 21 percent. The cost is the per-DMA-draw full walk of every
REM cached buffer. The dirty log syncs only what became CPU-dirty since the last DMA draw.
REM Set 0 to restore the upstream full walk for an A/B.
set GT_DMA_DIRTY_LOG=1
REM Run 205: [obtprof] convicted the cached ObtainBuffer path - ~30k SynchronizeBuffer calls
REM per 2 s window, 230-660 ms, almost all finding nothing dirty. This gate mirrors the
REM tracker's CPU-dirty state into a range set (fed by the same producers as the DMA log) and
REM skips the per-region walk when the bound window is clean. Requires GT_DMA_DIRTY_LOG=1.
REM Set 0 for an A/B against the full walk.
set GT_BIND_SKIP=1
REM Run 206: the gate fired (94 percent skips) and sync did NOT move - the shared bill is the
REM texel-buffer image lookup (a page-table walk per bind that usually finds nothing). The memo
REM caches the overlap candidates against the image registration generation; the live flags
REM are re-checked every call. Set 0 for an A/B.
set GT_TEXEL_MEMO=1
REM Run 210: [protprof] closed the sync ledger - memcpy 5-16 ms and recording 5-27 ms are
REM innocent; the bill is the page-protection PING-PONG: 12-23k claimed write faults and
REM 1.8-3.3 SECONDS of VirtualProtect per 2 s window (about 190 us each, under the region
REM locks the GPU thread's upload walk then spins on). The game sweeps its per-frame buffers
REM linearly, paying one fault + one protect per 4K page. This widens each write fault to a
REM 64 KiB window (buffer cache only, GPU-modified pages excluded, clamped to the mapped
REM interval) so a sweep pays ONE fault + ONE protect per window. Set 0 for an A/B.
set GT_FAULT_WIDE=65536
REM Run 200 (warm cache, dirty log armed): FPS still decayed 11-4 and the GpuCommandProcessor
REM burned ~66 ms of real CPU per 110 ms frame while the ~60 guest Job# threads spun 9.5 cores
REM waiting on it. The profiler prints one [fprof] line per 2 s naming where those
REM milliseconds go, so the growing category is visible. Observational; set 0 to disable.
set GT_FRAME_PROF=1
REM The shader/VA watches already answered their questions and produced thousands of log lines
REM during the old split=1 performance run. Disable them for an honest FPS/audio measurement.
set GT_CB_TRACE=
set GT_WATCH_VA=0
set GT_WATCH_SIZE=0

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo ================================================================
pause
