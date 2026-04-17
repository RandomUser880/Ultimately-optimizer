@echo off
title ULTIMATELY OPTIMIZER
color 0C

:: Admin check
net session >nul 2>&1
if %errorLevel% NEQ 0 (
 echo Run as Administrator!
 pause
 exit
)

cls
echo ULTIMATELY OPTIMIZER
echo.

:: =========================
echo [1/18]
:: Remove apps (keep Store + Defender)
powershell -Command "Get-AppxPackage | Where-Object {$_.Name -notlike '*store*' -and $_.Name -notlike '*windows.security*'} | Remove-AppxPackage" >nul 2>&1

:: =========================
echo [2/18]
:: Remove provisioned apps (keep Store)
powershell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -notlike '*Store*'} | Remove-AppxProvisionedPackage -Online" >nul 2>&1

:: =========================
echo [3/18]
:: Disable telemetry
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1

:: =========================
echo [4/18]
:: Disable Windows Update
sc stop wuauserv >nul 2>&1
sc config wuauserv start= disabled >nul 2>&1

:: =========================
echo [5/18]
:: Disable heavy services
for %%s in (SysMain WSearch WerSvc) do (
 sc stop %%s >nul 2>&1
 sc config %%s start= disabled >nul 2>&1
)

:: =========================
echo [6/18]
:: Disable Xbox services
sc stop XblGameSave >nul 2>&1
sc config XblGameSave start= disabled >nul 2>&1
sc stop XboxNetApiSvc >nul 2>&1
sc config XboxNetApiSvc start= disabled >nul 2>&1

:: =========================
echo [7/18]
:: Kill background apps
taskkill /f /im OneDrive.exe >nul 2>&1
taskkill /f /im Widgets.exe >nul 2>&1
taskkill /f /im YourPhone.exe >nul 2>&1
taskkill /f /im SearchApp.exe >nul 2>&1

:: =========================
echo [8/18]
:: Remove OneDrive
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall >nul 2>&1
%SystemRoot%\System32\OneDriveSetup.exe /uninstall >nul 2>&1

:: =========================
echo [9/18]
:: Clear startup
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /f >nul 2>&1

:: =========================
echo [10/18]
:: Clean system
del /s /f /q %temp%\* >nul 2>&1
del /s /f /q C:\Windows\Temp\* >nul 2>&1
del /s /f /q C:\Windows\Prefetch\* >nul 2>&1

:: =========================
echo [11/18]
:: Network tweaks
ipconfig /flushdns >nul
netsh winsock reset >nul

:: =========================
echo [12/18]
:: Ultimate performance power plan
powercfg -setactive SCHEME_MIN

:: =========================
echo [13/18]
:: Disable visual effects
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul

:: =========================
echo [14/18]
:: GPU scheduling ON
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul

:: =========================
echo [15/18]
:: Reduce input latency
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f >nul

:: =========================
echo [16/18]
:: Disable background apps globally
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul

:: =========================
echo [17/18]
:: Edge debloat (keep Edge)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /t REG_DWORD /d 0 /f >nul

:: =========================
echo [18/18]
:: Restart explorer
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo.
echo DONE
pause
exit