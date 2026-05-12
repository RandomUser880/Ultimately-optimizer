# ============================================================
#                  Ultimately optimizer
# ============================================================
# RUN AS ADMIN
# Advanced performance / process / service / registry framework
# Creates restore point + registry backup first

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "        Ultimately optimizer" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# -------------------------------
# 0. ADMIN CHECK
# -------------------------------
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole] "Administrator"
)

if (-not $IsAdmin) {
    Write-Host "Run as Administrator." -ForegroundColor Red
    Pause
    Exit
}

# -------------------------------
# 1. HARDWARE / VERSION DETECTION
# -------------------------------
$WinBuild = (Get-ComputerInfo).WindowsVersion
$CPU = (Get-CimInstance Win32_Processor).Manufacturer
$GPU = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name

Write-Host "Windows Build: $WinBuild"
Write-Host "CPU Vendor: $CPU"
Write-Host "GPU: $GPU"

# -------------------------------
# 2. BACKUP + RESTORE POINT
# -------------------------------
Enable-ComputerRestore -Drive "C:\"
Checkpoint-Computer -Description "Before_Ultimately_Optimizer" -RestorePointType "MODIFY_SETTINGS"

reg export HKLM "$env:USERPROFILE\Desktop\HKLM_Backup.reg" /y
reg export HKCU "$env:USERPROFILE\Desktop\HKCU_Backup.reg" /y

# -------------------------------
# 3. TEMP / CACHE CLEANUP
# -------------------------------
Write-Host "Cleaning temp files..."
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue

# -------------------------------
# 4. PROCESS TERMINATION
# -------------------------------
Write-Host "Stopping selected background processes..."
$KillProcesses = @(
    "GameBarPresenceWriter",
    "CompatTelRunner",
    "OneDrive",
    "Widgets",
    "Skype",
    "Teams",
    "YourPhone"
)

foreach ($proc in $KillProcesses) {
    Get-Process -Name $proc -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}

# -------------------------------
# 5. SERVICE MANAGEMENT
# -------------------------------
Write-Host "Disabling selected heavy services..."
$Services = @(
    "SysMain",
    "WSearch",
    "DiagTrack",
    "DoSvc"
)

foreach ($svc in $Services) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    sc.exe config $svc start= disabled | Out-Null
}

# -------------------------------
# 6. EXECUTION BLOCKING (IFEO)
# -------------------------------
Write-Host "Blocking telemetry executables..."
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe" /v Debugger /t REG_SZ /d "systray.exe" /f

# -------------------------------
# 7. REGISTRY OPTIMIZATION
# -------------------------------

# Kernel / Scheduler
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 42 /f

# Memory
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v HeapDeCommitFreeBlockThreshold /t REG_DWORD /d 262144 /f

# FileSystem
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisable8dot3NameCreation /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f

# Visuals
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f

# Telemetry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

# Background Apps
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f

# Game DVR
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f

# -------------------------------
# 8. GPU / GRAPHICS
# -------------------------------
Write-Host "Applying graphics optimizations..."

reg add "HKCU\Software\Microsoft\Avalon.Graphics" /v DisableHWAcceleration /t REG_DWORD /d 0 /f

if ($GPU -match "NVIDIA") {
    Write-Host "NVIDIA detected."
}
elseif ($GPU -match "AMD") {
    Write-Host "AMD detected."
}
elseif ($GPU -match "Intel") {
    Write-Host "Intel graphics detected."
}

# -------------------------------
# 9. POWER MANAGEMENT
# -------------------------------
Write-Host "Applying power optimizations..."
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
powercfg -h off
powercfg -setacvalueindex scheme_current sub_pci express 0
powercfg -setactive scheme_current

# -------------------------------
# 10. NETWORK
# -------------------------------
Write-Host "Optimizing network..."
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxUserPort /t REG_DWORD /d 65534 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpTimedWaitDelay /t REG_DWORD /d 30 /f

ipconfig /flushdns
netsh winsock reset | Out-Null

# -------------------------------
# 11. SCHEDULED TASK PRIVACY
# -------------------------------
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable | Out-Null
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable | Out-Null

# -------------------------------
# 12. BROWSER PRIVACY
# -------------------------------
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v MetricsReportingEnabled /t REG_DWORD /d 0 /f

# -------------------------------
# 13. MEMORY CLEANUP
# -------------------------------
Write-Host "Cleaning memory..."
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

# -------------------------------
# 14. EXPLORER RESTART
# -------------------------------
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Process explorer.exe

# -------------------------------
# FINAL
# -------------------------------
Write-Host "======================================" -ForegroundColor Green
Write-Host "      Ultimately optimizer complete" -ForegroundColor Green
Write-Host " Restart recommended." -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green