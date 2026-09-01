@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 227 - THE RED MAP FIX: GT_RESOLVE_SWAP. Same switches as run 225 plus GT_RESOLVE_SWAP=1
REM (the ONE behavior change). Visual-front run (alternating lanes per the user's call).
REM Play: Music Rally menu is enough for the verdict; a race adds the wash datapoint.
REM
REM RUN 226 FINDINGS (RenderDoc capture CUSA24769_capture.rdc, analyses 12-15 in rdc/):
REM   - The red square IS the track-preview panel: a 520x480 RGBA8 resolve target at
REM     0x100a0b0000 (which also hosts a transient 1080p R16F between frames - memory reuse,
REM     not the bug). The game renders the preview at 2xMSAA, resolves, samples with T#
REM     dst_sel = AlphaBlueGreenRed.
REM   - PixelHistory: panel bg stored (0,0,0,1); sampled through the reversal -> (1,0,0,0)
REM     = SOLID RED. Everything else on the UI target survives because draws apply comp_swap
REM     in the shader EXPORT - but the RESOLVE pass is vkCmdResolveImage, a verbatim copy,
REM     and on real GCN the resolve reads MRT0 through ITS comp_swap and writes MRT1 through
REM     the DST's. When the two differ we are exactly one channel permutation short.
REM   - Also killed this run: the "temporal accumulator oscillation" theory - 13740/13746 are
REM     YCoCg-encoded TAA history (red trees = grayscale, cyan = chroma). NOT corruption.
REM   - The REAL wash defect, measured in the scene buffers: terrain/banks at the FP16
REM     ceiling (white), vegetation black, sky correct. Separate front, next visual run.
REM   - Depth 14685: 739 DepthStencilTarget draws yet content constant 1.0 - suspect
REM     viewport depth-range collapse; poisons fog/DoF/exposure. Separate front.
REM
REM WHAT THIS RUN CHANGES (GT_RESOLVE_SWAP=1):
REM   Rasterizer::Resolve compares MRT0/MRT1 comp_swap; when they differ it routes the resolve
REM   through the BlitHelper draw-copy whose SOURCE VIEW carries dstSwap(srcSwapInverse(...)).
REM   Honest doors, pre-declared: (a) the draw-copy takes MSAA sample 0 - no average - so
REM   resolved edges may alias slightly on such passes; (b) layered resolves keep the old
REM   verbatim path. A [resolve] WARNING line (budget 32) prints every differing pair even
REM   with the fix off, so the log proves the mechanism either way.
REM
REM VERDICT METRICS:
REM   1. THE PANEL: Music Rally menu track map - red square gone? (Expected: dark panel with
REM      white roads; it may stay DARK because the preview scene itself renders near-black -
REM      that is the wash front, not this fix. RED vs DARK is the verdict line.)
REM   2. grep "[resolve] comp_swap differs" - how many resolve pairs differ and which modes.
REM   3. No new artifacts on other resolve surfaces (menus, photomode thumbnails).
REM   4. FPS unchanged vs 225 (the fix runs only on differing pairs).
REM
REM The daily driver GT7_rtshape.bat is unchanged.

title GT7 - run 227: resolve comp_swap fixup (the red map)

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
