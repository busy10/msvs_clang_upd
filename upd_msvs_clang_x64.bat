@echo off

:: >> PLS SET VS PATH <<
set vs_path=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community
set no_bak=1

if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

if not exist "%vs_path%\VC\Tools\Llvm\x64\lib\clang\" (
  echo no x64 clang in vs dir //check bat file src
  timeout /t 3 > nul
  exit
)

cd /d "%~dp0"
for /f %%i in ('dir LLVM*win64.exe /b') do set clang_inst=%%i

cd /d "%vs_path%\VC\Tools\Llvm\x64\lib\clang"
for /f %%i in ('dir /b') do set clang_ver1=%%i

cd /d "%vs_path%\VC\Tools\Llvm"

if exist "x64_bak\" (
  rmdir /S /Q x64_bak
)
ren "%vs_path%\VC\Tools\Llvm\x64" x64_bak
if "%no_bak%"=="1" (
  rmdir /S /Q x64_bak
)
"%~dp07z.exe" x -ox64 "%~dp0%clang_inst%"

pushd "x64"
 for /f "delims=" %%a in ('2^>nul dir /b^|findstr /xv /c:"bin" /c:"lib"') do >nul 2>&1 rd /s /q "%%a"& >nul 2>&1 del /q "%%a"
popd

for /f %%i in ('dir x64\lib\clang\ /b') do set clang_ver2=%%i
ren x64\lib\clang\%clang_ver2% %clang_ver1%
