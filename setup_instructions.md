# Flutter Setup Instructions

## Prerequisites Installation

### 1. Install Flutter SDK

#### Windows:
1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/windows
2. Extract to `C:\flutter`
3. Add `C:\flutter\bin` to your PATH environment variable
4. Run `flutter doctor` to verify installation

#### macOS:
```bash
# Using Homebrew
brew install flutter

# Or download from: https://docs.flutter.dev/get-started/install/macos
```

#### Linux:
```bash
# Download Flutter SDK
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
tar xf flutter_linux_3.16.0-stable.tar.xz

# Add to PATH
echo 'export PATH="$PATH:`pwd`/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

### 2. Install Dependencies

#### Android Studio (Recommended):
1. Download from: https://developer.android.com/studio
2. Install Android SDK and tools
3. Install Flutter and Dart plugins

#### VS Code (Alternative):
1. Install Flutter extension
2. Install Dart extension

### 3. Verify Installation
```bash
flutter doctor
```

Fix any issues shown by flutter doctor before proceeding.

## Running the Digital Fayda Wallet App

### 1. Clone and Setup
```bash
# Navigate to project directory
cd digital-fayda-wallet

# Get Flutter dependencies
flutter pub get

# Enable web support
flutter config --enable-web
```

### 2. Run the App

#### For Web (Recommended for Hackathon):
```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

#### For Android Emulator:
```bash
# Start Android emulator first, then:
flutter run
```

#### For iOS Simulator (macOS only):
```bash
# Start iOS simulator first, then:
flutter run
```

### 3. Build for Production

#### Web Build:
```bash
flutter build web --release
```

#### Android APK:
```bash
flutter build apk --release
```

## Troubleshooting

### Common Issues:

1. **"flutter: command not found"**
   - Ensure Flutter is in your PATH
   - Restart terminal/command prompt
   - Run `flutter doctor` to verify

2. **Gradle issues (Android)**
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   ```

3. **Web build issues**
   ```bash
   flutter clean
   flutter pub get
   flutter build web --release
   ```

4. **Firebase issues**
   - The app uses demo Firebase configuration
   - For production, replace with actual Firebase project

### Development Tips:

1. **Hot Reload**: Press `r` in terminal while app is running
2. **Hot Restart**: Press `R` in terminal while app is running
3. **Debug Mode**: Use `flutter run --debug`
4. **Release Mode**: Use `flutter run --release`

## Hackathon Demo Mode

The app includes demo authentication for hackathon purposes:
- VeriFayda OIDC integration (simulated)
- Demo user data
- Mock QR code generation
- Biometric authentication (if device supports)

## Quick Start Commands

```bash
# Complete setup and run
flutter pub get
flutter config --enable-web
flutter run -d web-server --web-port 8080

# Access the app at: http://localhost:8080
```