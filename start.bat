@echo off
REM Novel Navigation - System Start Script (Windows)
REM Interactive Novel Map Visualization System
REM Version: 1.0

setlocal enabledelayedexpansion

echo ==================================================
echo   Novel Navigation - System Start Script
echo   Interactive Map Visualization System
echo ==================================================
echo.

echo [INFO] Checking Node.js installation...

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed
    echo.
    echo Please install Node.js:
    echo 1. Visit https://nodejs.org/
    echo 2. Download the LTS version for Windows
    echo 3. Run the installer
    echo 4. Restart your command prompt
    echo 5. Run this script again
    echo.
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo [SUCCESS] Node.js is installed: !NODE_VERSION!
)

echo.
echo [INFO] Checking npm availability...

REM Check if npm is available
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] npm is not available
    echo Please reinstall Node.js from https://nodejs.org/
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
    echo [SUCCESS] npm is available: v!NPM_VERSION!
)

echo.
echo [INFO] Installing project dependencies...

REM Check if package.json exists
if not exist "package.json" (
    echo [ERROR] package.json not found. Are you in the correct directory?
    pause
    exit /b 1
)

REM Install dependencies
npm install
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)

echo [SUCCESS] Dependencies installed successfully
echo.
echo [SUCCESS] System setup complete!
echo.
echo [INFO] Starting development server...
echo [INFO] The application will open in your browser at http://localhost:3000
echo [INFO] Press Ctrl+C to stop the server
echo.

REM Start the development server
npm run dev

pause
