@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 228 - THE RED MAP, SECOND CONVICTION: GT_CLEAR_RAW. Same switches as run 227 plus
REM GT_CLEAR_RAW=1. GT_RESOLVE_SWAP stays on but was PROVEN a no-op in run 227 (zero
REM "[resolve] comp_swap differs" lines over the whole session), so the one behavior change
REM this run is the clear fix. Visual-front run.
REM Play: Music Rally menu is enough for the verdict.
REM
REM WHY RUN 227 DID NOT FIX IT (measured in the run-226 capture, analyses 16-17):
REM   - The panel producer IS a vkCmdResolveImage (eid 16505, 94395 2xMSAA -> 137655), but
REM     the resolve pair's comp_swaps are EQUAL (run 227 logged zero differing pairs), so the
REM     verbatim resolve is faithful to real GCN. The resolve fix addressed a real semantic
REM     gap that this panel does not exercise.
REM   - The preview-scene DRAWS export through StandardReverse correctly: the roads/car-dot
REM     pixels sit in memory channel-reversed (dark cyan / pink in raw RGBA) and the game's
REM     AlphaBlueGreenRed T# reads them back correctly (they render white on screen - the
REM     white streaks inside the red square were RIGHT all along).
REM   - The BACKGROUND is the CLEAR, and the clear is the bug: CB_COLOR_CLEAR_WORD0 holds the
REM     RAW memory dword (the game packs comp_swap in when it writes the register). GT7
REM     clears the panel with word 0x000000FF = black, opaque, ALREADY in reversed storage.
REM     Our ColorBufferClearValue decoded it positionally AND applied Swizzle() on top -
REM     a double permutation - storing raw (0,0,0,1), which the ABGR T# reads as (1,0,0,0)
REM     = SOLID RED. Every other clear in the game is (0,0,0,0), permutation-invariant,
REM     which is why only this panel showed it.
REM
REM WHAT THIS RUN CHANGES (GT_CLEAR_RAW=1):
REM   ColorBufferClearValue applies only the format-layout remap (GCN slot order -> Vulkan
REM   channel order), not the comp_swap. For Standard comp_swap the two mappings are equal,
REM   so every currently-correct clear is byte-identical. An always-on WARNING
REM   "[clear] comp_swap-sensitive clear color" (budget 32) prints every clear where the
REM   old and new mappings disagree, with both values - the log proves the mechanism.
REM
REM VERDICT METRICS:
REM   1. THE PANEL: Music Rally menu track map - red square gone? Expected now: DARK panel
REM      with white roads and the car dot. (The white streaks were already correct.)
REM   2. grep "[clear] comp_swap-sensitive" - the panel clear must appear, doubled=(0,0,0,1)
REM      raw=(1,0,0,0).
REM   3. No regressions on other surfaces (menus, HUD, loading screens).
REM   4. FPS unchanged vs 227.
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 228: raw clear words (the red map, take 2)

set GT_RT_NOCLOBBER=0
set GT_LUT_IDENT=0
set GT_IMG_TRACE=0
set GT_VERTICAL_ALIAS=1
set GT_GPUWRITE_NOCLOBBER=0
set GT_SPLIT_DISPATCH=1
set GT_18256C0_GUARD=1
set GT_18256C0_LOOP_MAX=1024
set GT_DMA_DIRTY_LOG=1
set GT_BIND_SKIP=1
set GT_TEXEL_MEMO=1
set GT_FRAME_PROF=1
set GT_FAULT_HIST=1
set GT_FAST_PROTECT=1
set GT_HOSTIMPORT=0
set GT_BDA_IMPORT=1
set GT_DIRECT_IMPORT=1
set GT_STREAM_MEMO=1
set GT_RESOLVE_SWAP=1
set GT_CLEAR_RAW=1
set GT_HOT_PIN=0
set GT_FAULT_WIDE=0
set GT_CB_TRACE=
set GT_WATCH_VA=0
set GT_WATCH_SIZE=0

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo ================================================================
pause
