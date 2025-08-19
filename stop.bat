@echo off
REM Novel Navigation - System Stop Script (Windows)
REM Interactive Novel Map Visualization System
REM Version: 1.0

setlocal enabledelayedexpansion

echo ==================================================
echo   Novel Navigation - System Stop Script
echo   Graceful Shutdown Manager
echo ==================================================
echo.

echo [INFO] Searching for Novel Navigation processes...

REM Find processes using port 3000
echo [INFO] Checking for processes on port 3000...
netstat -ano | findstr :3000 > temp_port_check.txt 2>nul

if exist temp_port_check.txt (
    for /f "tokens=5" %%a in (temp_port_check.txt) do (
        if "%%a" neq "" (
            echo [INFO] Found process using port 3000: PID %%a
            echo [INFO] Terminating process %%a...
            taskkill /PID %%a /F >nul 2>&1
            if !errorlevel! equ 0 (
                echo [SUCCESS] Process %%a terminated successfully
            ) else (
                echo [WARNING] Could not terminate process %%a
            )
        )
    )
    del temp_port_check.txt >nul 2>&1
) else (
    echo [INFO] No processes found using port 3000
)

echo.
echo [INFO] Searching for Node.js development processes...

REM Find Node.js processes related to Vite
tasklist /FI "IMAGENAME eq node.exe" /FO CSV | findstr /C:"vite" > temp_node_check.txt 2>nul

if exist temp_node_check.txt (
    echo [INFO] Found Node.js development processes:
    type temp_node_check.txt
    echo.
    
    REM Extract PIDs and kill processes
    for /f "tokens=2 delims=," %%a in (temp_node_check.txt) do (
        set "pid=%%a"
        set "pid=!pid:"=!"
        echo [INFO] Terminating Node.js process: PID !pid!
        taskkill /PID !pid! /F >nul 2>&1
        if !errorlevel! equ 0 (
            echo [SUCCESS] Process !pid! terminated successfully
        ) else (
            echo [WARNING] Could not terminate process !pid!
        )
    )
    del temp_node_check.txt >nul 2>&1
) else (
    echo [INFO] No Node.js development processes found
)

echo.
echo [INFO] Cleaning up temporary files...

REM Remove Vite cache if it exists
if exist "node_modules\.vite" (
    rmdir /S /Q "node_modules\.vite" >nul 2>&1
    echo [INFO] Removed Vite cache
)

REM Remove any .tmp files
for /r %%i in (*.tmp) do (
    del "%%i" >nul 2>&1
)

REM Remove any lock files
if exist ".vite-dev-server.lock" (
    del ".vite-dev-server.lock" >nul 2>&1
    echo [INFO] Removed stale lock files
)

echo [SUCCESS] Temporary files cleaned up

echo.
echo [INFO] Verifying shutdown...

REM Check if port 3000 is still in use
netstat -ano | findstr :3000 >nul 2>&1
if !errorlevel! equ 0 (
    echo [WARNING] Port 3000 is still in use
    echo [INFO] Some processes may still be running
) else (
    echo [SUCCESS] Port 3000 is now available
)

REM Check for remaining Node.js processes
tasklist /FI "IMAGENAME eq node.exe" /FO CSV | findstr /C:"vite" >nul 2>&1
if !errorlevel! equ 0 (
    echo [WARNING] Node.js development processes are still running
    echo [INFO] You may need to manually terminate them
) else (
    echo [SUCCESS] All Node.js development processes have been stopped
)

echo.
echo [SUCCESS] Novel Navigation system shutdown complete
echo [INFO] You can restart the system using start.bat
echo.

REM Show help if requested
if "%1"=="--help" goto :help
if "%1"=="-h" goto :help
if "%1"=="--verbose" goto :verbose
if "%1"=="-v" goto :verbose

goto :end

:help
echo Novel Navigation - System Stop Script
echo.
echo Usage: %0 [options]
echo.
echo Options:
echo   -h, --help     Show this help message
echo   -v, --verbose  Show detailed process information
echo.
echo This script will:
echo   1. Find and terminate all Novel Navigation processes
echo   2. Free up port 3000
echo   3. Clean up temporary files
echo   4. Verify successful shutdown
goto :end

:verbose
echo.
echo [INFO] Current Node.js processes:
tasklist /FI "IMAGENAME eq node.exe" 2>nul
echo.
echo [INFO] Processes using port 3000:
netstat -ano | findstr :3000 2>nul
goto :end

:end
pause
