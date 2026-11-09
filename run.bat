@echo off
setlocal
title CPMS - College Placement Management System (Desktop App)
color 0b

echo =====================================================================
echo       COLLEGE PLACEMENT MANAGEMENT SYSTEM (CPMS) - DESKTOP
echo =====================================================================
echo.

set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-25.0.5.8-hotspot"
set "JRE_HOME=C:\Program Files\Eclipse Adoptium\jdk-25.0.5.8-hotspot"
set "CATALINA_HOME=C:\apache-tomcat-10.1.61"
set "CATALINA_BASE=C:\apache-tomcat-10.1.61"

:: 1. Verify and start MySQL Database if not running
sc query MySQL80 2>nul | find "RUNNING" >nul 2>&1
if errorlevel 1 (
    echo [1/3] Starting MySQL Service...
    net start MySQL80 >nul 2>&1
) else (
    echo [1/3] MySQL Database is running.
)

:: 2. Check if CPMS Engine is already online
echo [2/3] Checking CPMS Application Engine...
powershell -NoProfile -Command "try { $r = (Invoke-WebRequest -Uri 'http://localhost:8080/CPMS/' -UseBasicParsing -TimeoutSec 2).StatusCode; if ($r -eq 200) { exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1
if not errorlevel 1 goto engine_ready

echo       Starting CPMS Engine in background...
start /min "CPMS_Engine" cmd /c "cd /d %CATALINA_HOME%\bin && catalina.bat run"

echo       Waiting for engine initialization...
set attempts=0

:wait_loop
ping -n 2 127.0.0.1 >nul
set /a attempts=attempts+1
powershell -NoProfile -Command "try { $r = (Invoke-WebRequest -Uri 'http://localhost:8080/CPMS/' -UseBasicParsing -TimeoutSec 2).StatusCode; if ($r -eq 200) { exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1
if not errorlevel 1 goto engine_ready
if %attempts% lss 25 goto wait_loop

:engine_ready
echo       CPMS Engine is online!

:: 3. Detect standalone desktop app runner (Edge or Chrome in App Mode)
set "APP_RUNNER="
if exist "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" (
    set "APP_RUNNER=C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
) else if exist "C:\Program Files\Microsoft\Edge\Application\msedge.exe" (
    set "APP_RUNNER=C:\Program Files\Microsoft\Edge\Application\msedge.exe"
) else if exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
    set "APP_RUNNER=C:\Program Files\Google\Chrome\Application\chrome.exe"
) else if exist "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" (
    set "APP_RUNNER=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
)

echo [3/3] Launching CPMS Desktop Application Window...
echo.
echo =====================================================================
echo  CPMS DESKTOP APPLICATION IS ACTIVE
echo =====================================================================
echo  Mode:         Native Desktop Application (App Mode, No Browser Chrome)
echo  Demo Sign-In:
echo    * Student:    student@cpms.test     / Student@123
echo    * Officer:    officer@cpms.test     / Officer@123
echo    * Recruiter:  recruiter@example.com / Recruiter@123
echo =====================================================================
echo.

if defined APP_RUNNER (
    start "" "%APP_RUNNER%" --app="http://localhost:8080/CPMS/" --user-data-dir="%LOCALAPPDATA%\CPMS_DesktopApp" --window-size=1420,920 --window-position=60,30
) else (
    start http://localhost:8080/CPMS/
)

:: Minimize console window so the desktop application window takes center stage
powershell -NoProfile -Command "$w=(Get-Process -Id $PID).MainWindowHandle; if ($w -ne [IntPtr]::Zero) { Add-Type -Name W -Namespace W -MemberDefinition '[DllImport(\"user32.dll\")]public static extern bool ShowWindow(IntPtr h,int c);'; [W.W]::ShowWindow($w,2) }" >nul 2>&1

exit /b 0
