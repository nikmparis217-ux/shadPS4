@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is "Nikos" in Greek and cmd.exe reads this
REM file in the OEM codepage, so a real path here would be mangled and "not found".
REM
REM Act 12, the auto-exposure hunt. Run 183's captures proved: the scene ENTERS the output
REM transform already blown to half-float max (65020) - physical light units (sun 128000 lux,
REM Earth-radius constants in the atmosphere pass) with NO working pre-exposure. The two
REM state textures that should carry the exposure/transmittance read ZERO in every capture
REM and nothing writes them in-frame:
REM   0x1000e33200  1x1 R8 (6 mips), read by 262 draws + the atmosphere CS
REM   0x10b19a1700  16x1 R16_FLOAT, read by the atmosphere CS (cs_e3dae865)
REM This run watches BOTH across the whole session (GT_WATCH_VA grew comma lists):
REM   [vawatch]  = every GPU bind touching them (a WRITE bind names the producer)
REM   [aewatch]  = every guest->GPU upload of them WITH the bytes it carries
REM Play 2-3 minutes: menu -> Music Rally -> into the race, then quit. Grep the log for
REM "aewatch", "vawatch", "lut3d" afterwards.

REM Run 187: run 186 (readbacks ON) proved the plumbing works - four 8192-float tone curves
REM at 0x101e32c800..0x101e346800 downloaded REAL data into guest RAM (wb 1) - but the
REM luminance measurement pyramid at 0x100b444000..0x100b45bdxx (64x64 -> 1x1, B10G11R11)
REM is ZERO on the GPU itself, so the game's exposure math still sees a black scene.
REM This run watches the whole pyramid: a WRITE bind in [vawatch] names the builder shader;
REM no write bind = it is written by BDA stores or a copy op instead.

title GT7 - AE state watch run (launcher bypassed)

set GT_LUT_IDENT=1
set GT_WATCH_VA=1000e33200,10b19a1700,100b444000
set GT_WATCH_SIZE=600,100,20000

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo  If it said "Close these first", close shadPS4QtLauncher and retry.
echo ================================================================
pause
