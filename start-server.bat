@echo off
title CPMS - College Placement Management System
color 0b
echo =====================================================================
echo           COLLEGE PLACEMENT MANAGEMENT SYSTEM (CPMS)
echo =====================================================================
echo.

set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-25.0.5.8-hotspot"
set "JRE_HOME=C:\Program Files\Eclipse Adoptium\jdk-25.0.5.8-hotspot"
set "CATALINA_HOME=C:\apache-tomcat-10.1.61"
set "CATALINA_BASE=C:\apache-tomcat-10.1.61"

echo [1/3] Checking Java Runtime Environment...
if not exist "%JAVA_HOME%\bin\java.exe" (
    echo [ERROR] Java not found at %JAVA_HOME%
    pause
    exit /b 1
)
echo       Java is ready: OpenJDK 25

echo [2/3] Checking Apache Tomcat 10.1...
if not exist "%CATALINA_HOME%\bin\catalina.bat" (
    echo [ERROR] Tomcat not found at %CATALINA_HOME%
    pause
    exit /b 1
)
echo       Tomcat is ready at %CATALINA_HOME%

echo [3/3] Launching Tomcat Server...
echo.
echo =====================================================================
echo Server is starting on:
echo   -- Portal URL:    http://localhost:8080/CPMS/
echo   -- Direct Root:   http://localhost:8080/
echo.
echo Login Credentials:
echo   * Student:        student@cpms.test   / Student@123
echo   * Officer:        officer@cpms.test   / Officer@123
echo   * Recruiter:      recruiter@example.com / Recruiter@123
echo =====================================================================
echo.

:: Launch browser in background after 4 seconds
start /b cmd /c "timeout /t 4 /nobreak >nul && start http://localhost:8080/CPMS/"

:: Run Tomcat
cd /d "%CATALINA_HOME%\bin"
call catalina.bat run
pause

