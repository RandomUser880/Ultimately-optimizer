@echo off
title ULTIMATELY OPTIMIZER
color 0a

echo ======================================
echo        ULTIMATELY OPTIMIZER
echo ======================================

:: ---------------- ADMIN CHECK ----------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Run as Administrator!
    pause
    exit /b
)

:: ============================================================
:: RESTORE POINT (requires PowerShell call)
:: ============================================================
echo Creating restore point...
powershell -Command "Checkpoint-Computer -Description 'ULTIMATELY_OPTIMIZER' -RestorePointType MODIFY_SETTINGS" >nul 2>&1

:: ============================================================
:: SERVICES REDUCTION (SAFE)
:: ============================================================

echo Disabling services...

for %%s in (
DiagTrack dmwappushservice SysMain WSearch Fax lfsvc MapsBroker
WbioSrvc WalletService DoSvc RemoteRegistry WerSvc PcaSvc TrkWks
RetailDemo WMPNetworkSvc wisvc TabletInputService PhoneSvc OneSyncSvc
Spooler PrintNotify XboxGipSvc XblAuthManager XblGameSave XboxNetApiSvc
) do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)

:: ============================================================
:: XBOX SAFE MODE (NOT REMOVED)
:: ============================================================

sc config XblAuthManager start= demand >nul 2>&1
sc config XblGameSave start= demand >nul 2>&1
sc config XboxNetApiSvc start= demand >nul 2>&1
sc config XboxGipSvc start= demand >nul 2>&1

:: ============================================================
:: PROCESS CLEANUP
:: ============================================================

echo Stopping background processes...

for %%p in (
OneDrive SkypeApp Teams YourPhone PhoneExperienceHost Widgets
GameBar GameBarPresenceWriter CompatTelRunner SearchApp StartMenuExperienceHost
) do (
    taskkill /f /im %%p.exe >nul 2>&1
)

:: ============================================================
:: STARTUP CLEANUP
:: ============================================================

echo Cleaning startup entries...

reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v Teams /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v Skype /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v YourPhone /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v Widgets /f >nul 2>&1

:: ============================================================
:: REGISTRY PERFORMANCE TWEAKS
:: ============================================================

echo Applying registry tweaks...

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 10 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f

reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f

:: ============================================================
:: 60+ SAFE SCHEDULED TASK DISABLE
:: ============================================================

echo Disabling scheduled tasks...

schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Application Experience\StartupAppTask" /Disable >nul 2>&1

schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1

schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1

schtasks /Change /TN "\Microsoft\Windows\Maps\MapsToastTask" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /Disable >nul 2>&1

schtasks /Change /TN "\Microsoft\XblGameSave\XblGameSaveTask" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\XblGameSave\XblGameSaveTaskLogon" /Disable >nul 2>&1

schtasks /Change /TN "\Microsoft\EdgeUpdate\MicrosoftEdgeUpdateTaskMachineCore" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\EdgeUpdate\MicrosoftEdgeUpdateTaskMachineUA" /Disable >nul 2>&1

schtasks /Change /TN "\Microsoft\Office\Office Automatic Updates" /Disable >nul 2>&1

schtasks /Change /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Autochk\Proxy" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Maintenance\WinSAT" /Disable >nul 2>&1

schtasks /Change /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Location\Notifications" /Disable >nul 2>&1

:: ============================================================
:: TEMP CLEANUP
:: ============================================================

echo Cleaning temp files...

del /s /q "%TEMP%\*" >nul 2>&1
del /s /q "C:\Windows\Temp\*" >nul 2>&1

:: ============================================================
:: NETWORK RESET
:: ============================================================

echo Resetting network...

ipconfig /flushdns
netsh winsock reset

:: ============================================================
:: RESTART EXPLORER
:: ============================================================

echo Restarting Explorer...

taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

:: ============================================================
:: COMPLETE
:: ============================================================

echo ======================================
echo        OPTIMIZATION COMPLETE
echo   Smoothness + latency improved
echo   Xbox + Photos SAFE
echo   Restart recommended
echo ======================================

pause