@echo off
REM ASCII + 8.3 short paths only. Same as GT7.bat but with SYNCHRONIZATION VALIDATION really on.
REM
REM This is the test runs 17 and 18 believed they had done and had not: the script wrote
REM vkvalidation_sync_enabled but never vkvalidation_enabled, which is the master that loads
REM VK_LAYER_KHRONOS_validation. Both logs say "Vulkan vkValidation: false", so no layer was ever
REM loaded and both "ZERO findings" results were meaningless. Fixed 17 Aug.
REM
REM Synchronization validation is the tool built exactly for missing barriers and races.
REM EXPECT IT TO BE SLOWER, and expect it to possibly HIDE the device lost - a layer adds
REM synchronization, which is what the CDL layer did. If the device lost disappears here, that is
REM itself a measurement: it points at a race rather than a steady fault.
REM
REM Run GT7.bat FIRST (no layers, device fault only) - that is the run that can still reproduce it.
title GT7 - synchronization validation (slower)
powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Sync
echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo  Check the "what the emulator says it ran with" block: it must
echo  say vkValidation: true AND "VALIDATION LAYER LOADED".
echo ================================================================
pause
