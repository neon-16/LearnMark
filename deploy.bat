@echo off
REM LearnMark Firebase Hosting Deployment Setup
REM This script installs Node.js and Firebase CLI, then deploys the app

setlocal enabledelayedexpansion

echo.
echo ===============================================
echo   LearnMark Firebase Hosting Setup
echo ===============================================
echo.

REM Step 1: Check if Node.js exists
echo [1/5] Checking for Node.js...
where node >nul 2>&1
if %errorlevel% == 0 (
    echo Node.js found!
    node --version
    goto :firebase_cli
) else (
    echo Node.js not found. Would you like to:
    echo 1. Download Node.js installer (https://nodejs.org)
    echo 2. Install Firebase globally (if npm exists elsewhere)
    echo 3. Use manual deployment method
    echo.
    set /p choice="Enter choice (1-3): "
    
    if "!choice!"=="1" (
        echo Opening Node.js download page...
        start https://nodejs.org/en/download/
        echo Please install Node.js, then run this script again.
        pause
        goto :end
    ) else if "!choice!"=="2" (
        goto :firebase_cli
    ) else (
        goto :manual_deploy
    )
)

:firebase_cli
echo.
echo [2/5] Installing Firebase CLI globally...
npm install -g firebase-tools
if %errorlevel% neq 0 (
    echo Failed to install Firebase CLI. Please check npm is working.
    pause
    goto :end
)

echo [3/5] Logging into Firebase...
firebase login

echo.
echo [4/5] Initializing Firebase Hosting...
cd /d "C:\Users\LAB\Desktop\myapp\learnmark_app"
firebase init hosting

echo.
echo [5/5] Deploying to Firebase...
flutter build web --release
firebase deploy --only hosting

echo.
echo ===============================================
echo   Deployment Complete!
echo ===============================================
echo Your app is now live! Check the console for your URL.
echo.
pause
goto :end

:manual_deploy
echo.
echo ===============================================
echo   Manual Deployment Instructions
echo ===============================================
echo.
echo Since Node.js is not installed, use the manual method:
echo.
echo 1. Go to: https://console.firebase.google.com
echo 2. Create a new project named "LearnMark"
echo 3. Enable Firebase Hosting
echo 4. Upload the files from: C:\Users\LAB\Desktop\myapp\learnmark_app\build\web
echo 5. Your app will be live at the URL shown in Firebase Console
echo.
pause
goto :end

:end
echo.
echo Setup script completed.
pause
