@echo off
setlocal EnableExtensions
cd /d "%~dp0"

if /I "%~1"=="admin" goto ADMIN
if /I "%~1"=="help" goto HELP
if /I "%~1"=="--help" goto HELP

if not exist "RootGlass.exe" (
  echo [BLOCKED] RootGlass.exe is missing from this folder.
  pause
  exit /b 1
)
start "Root Glass" "%CD%\RootGlass.exe"
exit /b 0

:ADMIN
if not exist "RootGlass.exe" (
  echo [BLOCKED] RootGlass.exe is missing from this folder.
  pause
  exit /b 1
)
set "ROOTGLASS_EXE=%CD%\RootGlass.exe"
powershell.exe -NoLogo -NoProfile -Command "Start-Process -FilePath $env:ROOTGLASS_EXE -Verb RunAs"
exit /b %ERRORLEVEL%

:HELP
echo.
echo ROOT GLASS v0.1.1-alpha
echo.
echo   RootGlass.cmd          Launch the read-only application
echo   RootGlass.cmd admin    Launch with an elevated token for fuller visibility
echo.
exit /b 0
