@echo off
REM ASCII + 8.3 SHORT PATHS ONLY (Greek profile + OEM codepage).
REM
REM RUN THIS WHILE THE GAME IS STUCK, BEFORE KILLING IT. It captures every thread's live
REM call stack (with symbols from the build's own PDB), CPU activity and wait state into
REM GT7_work\logs\stuckstack_<timestamp>.txt - the measurement runs 244 and 246 died
REM without. Threads are paused for microseconds each; the game is not harmed. You can
REM run it several times. Kill the game AFTER this has printed "written: ...".

title capture stacks from a stuck shadps4

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\stuckstack.ps1

echo.
echo ================================================================
echo  Done. Now you can kill the game. The file above goes to Claude.
echo ================================================================
pause
