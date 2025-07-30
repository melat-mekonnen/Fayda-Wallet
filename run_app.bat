@echo off
REM Digital Fayda Wallet - Quick Start Script for Windows

echo 🪪 Digital Fayda Wallet - Quick Start
echo ======================================

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed or not in PATH
    echo Please install Flutter first:
    echo https://docs.flutter.dev/get-started/install/windows
    pause
    exit /b 1
)

echo ✅ Flutter found
flutter --version | findstr "Flutter"

REM Check Flutter doctor
echo.
echo 🔍 Checking Flutter setup...
flutter doctor

REM Get dependencies
echo.
echo 📦 Getting Flutter dependencies...
flutter pub get

REM Enable web support
echo.
echo 🌐 Enabling web support...
flutter config --enable-web

REM Clean build
echo.
echo 🧹 Cleaning previous builds...
flutter clean
flutter pub get

REM Run the app
echo.
echo 🚀 Starting Digital Fayda Wallet...
echo The app will be available at: http://localhost:8080
echo.
echo Press Ctrl+C to stop the app
echo Press 'r' for hot reload, 'R' for hot restart
echo.

flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080