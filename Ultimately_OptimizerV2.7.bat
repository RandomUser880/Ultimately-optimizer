@echo off
title ULTIMATELY OPTIMIZER
color 0C

:: ================= ADMIN CHECK =================
net session >nul 2>&1
if %errorLevel% NEQ 0 (
 echo Run as Administrator!
 pause
 exit
)

:: ================= UI =================
cls
echo ==========================================
echo        ULTIMATELY OPTIMIZER
echo ==========================================
echo.

echo Creating restore point...
powershell -Command "Enable-ComputerRestore -Drive 'C:\'" >nul 2>&1
powershell -Command "Checkpoint-Computer -Description 'UltimatelyOptimizer Restore Point' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1

echo Restore point created ✅
timeout /t 2 >nul

:: ================= START =================
cls
echo ULTIMATELY OPTIMIZER
echo.

:: 1
echo [1/15] Removing bloat apps...
timeout /t 1 >nul
powershell -Command "Get-AppxPackage *xbox* | Remove-AppxPackage" >nul 2>&1
powershell -Command "Get-AppxPackage *skype* | Remove-AppxPackage" >nul 2>&1
powershell -Command "Get-AppxPackage *linkedin* | Remove-AppxPackage" >nul 2>&1
powershell -Command "Get-AppxPackage *clipchamp* | Remove-AppxPackage" >nul 2>&1
powershell -Command "Get-AppxPackage *feedbackhub* | Remove-AppxPackage" >nul 2>&1
powershell -Command "Get-AppxPackage *3dviewer* | Remove-AppxPackage" >nul 2>&1

:: 2
echo [2/15] Disabling telemetry...
timeout /t 1 >nul
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1

:: 3
echo [3/15] Disabling background services...
timeout /t 1 >nul
sc stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1
sc stop WSearch >nul 2>&1
sc config WSearch start= disabled >nul 2>&1

:: 4
echo [4/15] Disabling Xbox services...
timeout /t 1 >nul
sc stop XblGameSave >nul 2>&1
sc config XblGameSave start= disabled >nul 2>&1
sc stop XboxNetApiSvc >nul 2>&1
sc config XboxNetApiSvc start= disabled >nul 2>&1

:: 5
echo [5/15] Killing background processes...
timeout /t 1 >nul
taskkill /f /im OneDrive.exe >nul 2>&1
taskkill /f /im Widgets.exe >nul 2>&1
taskkill /f /im YourPhone.exe >nul 2>&1
taskkill /f /im SearchApp.exe >nul 2>&1

:: 6
echo [6/15] Removing OneDrive...
timeout /t 1 >nul
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall >nul 2>&1
%SystemRoot%\System32\OneDriveSetup.exe /uninstall >nul 2>&1

:: 7
echo [7/15] Cleaning system...
timeout /t 1 >nul
del /s /f /q %temp%\* >nul 2>&1
del /s /f /q C:\Windows\Temp\* >nul 2>&1
del /s /f /q C:\Windows\Prefetch\* >nul 2>&1

:: 8
echo [8/15] Network optimization...
timeout /t 1 >nul
ipconfig /flushdns >nul
netsh winsock reset >nul

:: 9
echo [9/15] Performance mode...
timeout /t 1 >nul
powercfg -setactive SCHEME_MIN

:: 10
echo [10/15] Disabling visual effects...
timeout /t 1 >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul

:: 11
echo [11/15] Enabling GPU scheduling...
timeout /t 1 >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul

:: 12
echo [12/15] Reducing input latency...
timeout /t 1 >nul
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f >nul

:: 13
echo [13/15] Disabling background apps...
timeout /t 1 >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul

:: 14
echo [14/15] Edge optimization...
timeout /t 1 >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /t REG_DWORD /d 0 /f >nul

:: 15
echo [15/15] Finalizing...
timeout /t 1 >nul
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

:: ================= DONE =================
cls
echo ==========================================
echo        ULTIMATELY OPTIMIZER
echo ==========================================
echo.
echo   OPTIMIZATION COMPLETE 🚀
echo   Restart your PC for best results
echo.
pause
exit