@echo off
setlocal EnableExtensions
cd /d "%~dp0"

if /I "%~1"=="admin" goto ADMIN
if /I "%~1"=="help" goto HELP
if /I "%~1"=="--help" goto HELP
if not "%~1"=="" goto UNKNOWN

:RUN
if not exist "RootGlass.exe" goto MISSING
start "Veyra" "%CD%\RootGlass.exe"
exit /b 0

:ADMIN
if not exist "RootGlass.exe" goto MISSING
set "VEYRA_LEGACY_EXE=%CD%\RootGlass.exe"
powershell.exe -NoLogo -NoProfile -Command "Start-Process -FilePath $env:VEYRA_LEGACY_EXE -Verb RunAs"
exit /b %ERRORLEVEL%

:HELP
echo.
echo VEYRA v0.1.1-alpha
echo Glass-box Windows authority instrument - read-only alpha
echo.
echo   Veyra.cmd          Launch Veyra
echo   Veyra.cmd admin    Launch elevated for fuller read visibility
echo   Veyra.cmd help     Show this help
echo.
echo Compatibility note:
echo   The imported alpha executable is still named RootGlass.exe.
echo   Read README.md and VERIFICATION.md for the current proof boundary.
echo.
exit /b 0

:UNKNOWN
echo [BLOCKED] Unknown Veyra option: %~1
echo Run Veyra.cmd help for supported options.
exit /b 2

:MISSING
echo [BLOCKED] RootGlass.exe is missing from this folder.
echo The Veyra compatibility launcher cannot start the imported alpha.
pause
exit /b 1
