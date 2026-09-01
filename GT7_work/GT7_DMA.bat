@echo off
REM ASCII + 8.3 SHORT PATHS ONLY - the user profile is "Nikos" in Greek and cmd.exe reads this
REM file in the OEM codepage, so a real path here would be mangled and "not found".
REM
REM THE DMA RETRIAL + BINDLESS LOWERING (19 Aug). Same as GT7_PSN.bat (local PSN server,
REM network on) PLUS:
REM   - GPU.direct_memory_access_enabled = true  (the old "DMA crashes boots" verdict was
REM     contaminated by the gt.idx file race, fixed 18 Aug - this is the clean retrial)
REM   - GT_BINDLESS_LOWER=1: untrackable bindless ReadConstBuffers become GPU-time BDA
REM     reads instead of stubbing the whole shader (the post-FX smears / red RT suspects).
REM
REM If THIS crashes at boot twice in a row, go back to GT7_PSN.bat and report - that is
REM the honest DMA verdict we never had.

title GT7 - PSN local + DMA retrial + bindless lowering

powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -Net -Dma %*

echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo ================================================================
pause
