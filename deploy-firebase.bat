@echo off
REM Firebase Hosting Deployment Script for LearnMark
REM This script deploys the web build to Firebase Hosting

setlocal enabledelayedexpansion

cd /d "C:\Users\LAB\Desktop\myapp\learnmark_app"

REM Set up PATH to include Node.js
SET "PATH=C:\Program Files\nodejs;C:\Users\LAB\AppData\Roaming\npm;%PATH%"

echo.
echo ===============================================
echo   LearnMark Firebase Hosting Deployment
echo ===============================================
echo.

echo [1/4] Verifying Node.js...
node --version
if %errorlevel% neq 0 (
    echo ERROR: Node.js not found!
    pause
    exit /b 1
)

echo.
echo [2/4] Building web app...
call C:\src\flutter\bin\flutter.bat build web --release
if %errorlevel% neq 0 (
    echo ERROR: Flutter build failed!
    pause
    exit /b 1
)

echo.
echo [3/4] Logging into Firebase...
call npm run firebase -- login

echo.
echo [4/4] Deploying to Firebase...
call npm run firebase -- deploy --only hosting

echo.
echo ===============================================
echo   Deployment Complete!
echo ===============================================
echo.
echo Your app is now live! Check the output above for your URL.
echo It will be in the format: https://your-project.web.app
echo.
pause
