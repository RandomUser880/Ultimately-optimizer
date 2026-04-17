@echo off
title ULTIMATELY OPTIMIZER
color 0C

:menu
cls
echo ======================================
echo        ULTIMATELY OPTIMIZER
echo ======================================
echo.
echo 1. Quick Optimize
echo 2. Gaming Mode
echo 3. Clean System
echo 4. Safe Debloat
echo 5. Aggressive Mode
echo 6. Restore Defaults
echo 7. Exit
echo.
set /p choice=Select an option:

if %choice%==1 goto quick
if %choice%==2 goto gaming
if %choice%==3 goto clean
if %choice%==4 goto debloat
if %choice%==5 goto aggressive
if %choice%==6 goto restore
if %choice%==7 exit

goto menu

:: =========================
:quick
cls
echo Running Quick Optimize...
timeout /t 1 >nul

del /s /f /q %temp%\* >nul 2>&1
ipconfig /flushdns >nul
powercfg -setactive SCHEME_MIN

echo Done!
pause
goto menu

:: =========================
:gaming
cls
echo Activating Gaming Mode...
timeout /t 1 >nul

taskkill /f /im OneDrive.exe >nul 2>&1
taskkill /f /im Teams.exe >nul 2>&1
taskkill /f /im Discord.exe >nul 2>&1

sc stop "SysMain" >nul 2>&1
sc stop "WSearch" >nul 2>&1

powercfg -setactive SCHEME_MIN

echo Gaming Mode ON 🚀
pause
goto menu

:: =========================
:clean
cls
echo Cleaning System...
timeout /t 1 >nul

del /s /f /q %temp%\* >nul 2>&1
del /s /f /q C:\Windows\Temp\* >nul 2>&1
del /s /f /q C:\Windows\Prefetch\* >nul 2>&1

echo Clean complete!
pause
goto menu

:: =========================
:debloat
cls
echo Running Safe Debloat...
timeout /t 1 >nul

powershell -Command "Get-AppxPackage *bing* | Remove-AppxPackage" >nul 2>&1
powershell -Command "Get-AppxPackage *getstarted* | Remove-AppxPackage" >nul 2>&1

sc stop "DiagTrack" >nul 2>&1
sc config "DiagTrack" start= disabled >nul 2>&1

echo Debloat complete!
pause
goto menu

:: =========================
:aggressive
cls
echo WARNING: Aggressive Mode may disable features!
pause

echo Running Aggressive Tweaks...
timeout /t 1 >nul

:: Disable more services
sc stop "SysMain" >nul 2>&1
sc config "SysMain" start= disabled >nul 2>&1

sc stop "WSearch" >nul 2>&1
sc config "WSearch" start= disabled >nul 2>&1

sc stop "DiagTrack" >nul 2>&1
sc config "DiagTrack" start= disabled >nul 2>&1

sc stop "dmwappushservice" >nul 2>&1
sc config "dmwappushservice" start= disabled >nul 2>&1

:: Kill more background processes
taskkill /f /im OneDrive.exe >nul 2>&1
taskkill /f /im Teams.exe >nul 2>&1
taskkill /f /im Widgets.exe >nul 2>&1
taskkill /f /im YourPhone.exe >nul 2>&1
taskkill /f /im SearchApp.exe >nul 2>&1

:: Disable startup apps (user-level)
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /f >nul 2>&1

:: Network tweaks
ipconfig /flushdns >nul
netsh winsock reset >nul

:: Performance tweaks
powercfg -setactive SCHEME_MIN

:: Clean everything
del /s /f /q %temp%\* >nul 2>&1
del /s /f /q C:\Windows\Temp\* >nul 2>&1
del /s /f /q C:\Windows\Prefetch\* >nul 2>&1

echo Aggressive Optimization DONE 🚀
pause
goto menu

:: =========================
:restore
cls
echo Restoring Defaults...
timeout /t 1 >nul

sc config "SysMain" start= auto >nul 2>&1
sc start "SysMain" >nul 2>&1

sc config "WSearch" start= auto >nul 2>&1
sc start "WSearch" >nul 2>&1

sc config "DiagTrack" start= auto >nul 2>&1
sc start "DiagTrack" >nul 2>&1

sc config "dmwappushservice" start= auto >nul 2>&1
sc start "dmwappushservice" >nul 2>&1

echo Defaults restored!
pause
goto menu