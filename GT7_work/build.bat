@echo off
REM ASCII + short paths only (Greek user name).
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >nul
set "PATH=C:\Program Files\LLVM\bin;%PATH%"
cd /d C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4
cmake --build Build/x64-Clang-RelWithDebInfo --parallel 14
echo BUILD EXIT %ERRORLEVEL%
