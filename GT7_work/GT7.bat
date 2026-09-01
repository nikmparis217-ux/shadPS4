@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is "Nikos" in Greek and cmd.exe reads this
REM file in the OEM codepage, so a real path here would be mangled and "not found".
REM
REM Double-click this. It bypasses shadPS4QtLauncher, which overwrites config.json from its own
REM settings model at the moment it spawns the game (proven by timestamps, 17 Aug) and therefore
REM silently threw away every diagnostic we tried to enable.

title GT7 - direct launch (launcher bypassed)

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo  If it said "Close these first", close shadPS4QtLauncher and retry.
echo ================================================================
pause
