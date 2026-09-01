@echo off
REM ASCII + 8.3 short paths only. Same as GT7.bat but with GPU-ASSISTED VALIDATION on.
REM It instruments the shaders to catch out-of-bounds accesses inside them.
REM
REM !! CORRECTION 17 Aug: the old comment here said this was "the main remaining suspect now that
REM sync validation reports 0 hazards". Sync validation never ran - the script wrote the sub-key
REM but not the master vkvalidation_enabled, so no layer was ever loaded (both logs: "Vulkan
REM vkValidation: false"). Nothing was ruled out. Run GT7.bat first (device fault, no layers),
REM then GT7_sync.bat, and only then this one - it is the slowest and most invasive of the three.
REM EXPECT IT TO BE VERY SLOW. Let it run.
title GT7 - GPU-assisted validation (slow)
powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -GpuAV
echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo ================================================================
pause
