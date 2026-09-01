@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is Greek and cmd.exe reads this file in the
REM OEM codepage, so a real path here would be mangled and "not found".
REM
REM RUN 190 - THE RENDER TARGET CLOBBER TEST.
REM
REM Run 189 measured, on the MAIN SCENE TARGET (1920x1080 at 2x MSAA, which the game stores as a
REM double-height 1920x2160 RGBA16F surface at 0x100a0b0000, 34 MB):
REM   [aewatch] upload 0x100a0b0000+0x2200000 (1920x2160x1 R16G16B16A16Sfloat) GPU-dirty
REM   [imgsrc]  0x100a0b0000+0x2200000 <- staging (gpumod 0 cpudirty 1)
REM i.e. shadPS4 copies the WHOLE 34 MB of guest RAM over everything the GPU rendered. The
REM num_samples guard in RefreshImage does not protect it, because at 1920x2160 the emulator
REM sees a single-sample image.
REM
REM GT_RT_NOCLOBBER=2 blocks that re-upload for any image the GPU has rendered into, and logs
REM every occurrence as [rtclobber] BLOCKED with the guest bytes it would have written.
REM   =1 measures only (logs "would clobber", changes nothing)
REM   =0 upstream behaviour
REM
REM Play: menu -> Music Rally -> into the race. WATCH THE WHITE WASH. Then quit.
REM Afterwards grep the log for "rtclobber".

title GT7 - render target clobber test (run 190)

set GT_RT_NOCLOBBER=2
set GT_WATCH_VA=100a0b0000
set GT_WATCH_SIZE=2200000

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo ================================================================
pause
