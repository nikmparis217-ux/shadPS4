@echo off
REM ASCII + 8.3 short paths only.
REM
REM RUN THIS ONE NEXT (17 Aug, after the first real device-fault result).
REM
REM Same as GT7.bat - no Vulkan layers, so nothing perturbs the GPU and the device loss can still
REM happen - plus two things:
REM   1. the vendor crash dump now actually gets written (it was silently failing: in this codebase
REM      FileAccessMode::Write means "open an EXISTING file", so the first write always failed with
REM      ENOENT; it is FileAccessMode::Create now). ~30 KB of NVIDIA dump was being thrown away.
REM   2. dump_shaders=true, which writes every compiled shader to
REM      %APPDATA%\shadPS4\shader\dumps. Shader dumping happens at COMPILE time on the CPU, so it
REM      does NOT change what the GPU executes and cannot hide the fault.
REM
REM WHY: the first device-fault result was 11 instruction pointers inside 592 bytes and ZERO
REM memory-access faults - i.e. the GPU was executing shader code and no bad access was reported,
REM which reads as a HANG, not an out-of-bounds. Windows logged an nvlddmkm reset in the same
REM minute, which is consistent. The wanted shader is compute 0xda05e7f8: it is the only shader in
REM the whole log the recompiler admits it mis-translated ("ReadConst has non-immediate offset" =
REM it could not resolve a buffer address), and compute queues were being fed right before death.
title GT7 - device fault + shader dump
powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\run_gt7.ps1 -DumpShaders
echo.
echo ================================================================
echo  Window stays open so the messages above can be read.
echo  Wanted from this run:
echo    - "vendor crash dump: NNNNN bytes"   (not "NOT written")
echo    - the SUMMARY lines after the fault records
echo    - "suspect files: 2" listing cs_...da05e7f8... dumps
echo ================================================================
pause
