#!/bin/bash

# Digital Fayda Wallet - Quick Start Script

echo "🪪 Digital Fayda Wallet - Quick Start"
echo "======================================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter first:"
    echo "- Windows: https://docs.flutter.dev/get-started/install/windows"
    echo "- macOS: https://docs.flutter.dev/get-started/install/macos"
    echo "- Linux: https://docs.flutter.dev/get-started/install/linux"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"

# Check Flutter doctor
echo ""
echo "🔍 Checking Flutter setup..."
flutter doctor

# Get dependencies
echo ""
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Enable web support
echo ""
echo "🌐 Enabling web support..."
flutter config --enable-web

# Clean build
echo ""
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Run the app
echo ""
echo "🚀 Starting Digital Fayda Wallet..."
echo "The app will be available at: http://localhost:8080"
echo ""
echo "Press Ctrl+C to stop the app"
echo "Press 'r' for hot reload, 'R' for hot restart"
echo ""

flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080