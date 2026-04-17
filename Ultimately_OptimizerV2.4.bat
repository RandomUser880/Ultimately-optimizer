@echo off
title ULTIMATELY OPTIMIZER
color 0C

echo ======================================
echo        ULTIMATELY OPTIMIZER
echo           HEAVY MODE
echo ======================================
echo.

:: Admin check
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo RUN AS ADMINISTRATOR!
    pause
    exit
)

echo [1/10] Removing major bloat apps...
powershell -Command "Get-AppxPackage *xbox* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *bing* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *zune* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *3dviewer* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *skype* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *solitaire* | Remove-AppxPackage"

echo [2/10] Disabling telemetry + tracking...
sc stop "DiagTrack"
sc config "DiagTrack" start= disabled
sc stop "dmwappushservice"
sc config "dmwappushservice" start= disabled

echo [3/10] Disabling background services...
sc stop "SysMain"
sc config "SysMain" start= disabled
sc stop "WSearch"
sc config "WSearch" start= disabled

echo [4/10] Disabling Xbox services...
sc stop "XblGameSave"
sc config "XblGameSave" start= disabled
sc stop "XboxNetApiSvc"
sc config "XboxNetApiSvc" start= disabled

echo [5/10] Killing background apps...
taskkill /f /im OneDrive.exe
taskkill /f /im Teams.exe
taskkill /f /im Widgets.exe
taskkill /f /im YourPhone.exe
taskkill /f /im SearchApp.exe

echo [6/10] Removing OneDrive...
taskkill /f /im OneDrive.exe
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
%SystemRoot%\System32\OneDriveSetup.exe /uninstall

echo [7/10] Clearing startup registry...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /f

echo [8/10] Cleaning system junk...
del /s /f /q %temp%\*
del /s /f /q C:\Windows\Temp\*
del /s /f /q C:\Windows\Prefetch\*

echo [9/10] Network reset...
ipconfig /flushdns
netsh winsock reset

echo [10/10] Ultimate performance mode...
powercfg -setactive SCHEME_MIN

echo.
echo ======================================
echo        HEAVY OPTIMIZATION DONE 🚀
echo     RESTART YOUR PC NOW
echo ======================================
pause
exit