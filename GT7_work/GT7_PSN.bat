@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is "Nikos" in Greek and cmd.exe reads this
REM file in the OEM codepage, so a real path here would be mangled and "not found".
REM
REM Double-click THIS one to play with PSN "connected": it starts the LOCAL shadNet server
REM (psn_local\shadnet_local_server.py) if it is not already running, signs the emulator in
REM to it, and launches GT7 - so the game does not show the PSN sign-in error.
REM
REM GT7.bat stays the UNTOUCHED baseline of the device-lost hunt (network forced OFF there).

title GT7 - PSN local (launcher bypassed)

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo  If it said "Close these first", close shadPS4QtLauncher and retry.
echo ================================================================
pause
