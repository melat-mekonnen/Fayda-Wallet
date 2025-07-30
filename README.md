# 🪪 Digital Fayda Wallet – Secure ID for Seamless Services

## 👥 Contributors

- Marsilas Wondimagegnehu
- Melat Mekonnen

---

## 📘 Project Synopsis

### 🔍 Problem Statement

Ethiopian citizens often rely on **physical Fayda ID cards** to access basic services like banking, telecom, and government offices. These cards can be easily forgotten, lost, or damaged — and there's currently **no secure and user-friendly digital alternative**. Institutions also lack a fast, verifiable, and privacy-respecting way to confirm ID ownership in real time.

---

### 💡 Planned Solution

We are building a **mobile wallet app** that allows users to store their Fayda ID digitally on their phone, protected by biometric login or PIN. The app generates a **secure QR code** that banks or institutions can scan to verify the user.

To enhance functionality and trust, we are adding:

- **Digital consent**: Users approve or deny each access attempt
- **Blockchain-style verification**: Each scan generates a verifiable hash stored in a tamper-proof log
- **Multi-ID support**: Store not just Fayda, but other essential IDs like driver’s license

---

### 🎯 Expected Outcome

By the end of the hackathon, we expect to deliver:

- A functional mobile app that:

  - Stores Fayda ID data securely
  - Displays encrypted QR for verification
  - Uses biometric/PIN login for access
  - Supports digital consent and logging

- A working web verifier portal that:
  - Scans the QR code
  - Displays verified data from backend
  - Simulates ID verification

---

### 🪪 Fayda’s Role

Fayda is at the center of our solution. We are building a secure, accessible, and scalable interface around the Fayda ID system to:

- Promote **digital adoption** of national ID
- Enable secure and **real-time verification**
- Increase **citizen trust** in government-issued IDs
- Lay a foundation for **future integrations** (healthcare, education, elections)

This directly supports Ethiopia’s national goal of digital transformation and expands the usability of Fayda in everyday life.

---

## 🛠️ Tech Stack

| Component             | Technology                            |
| --------------------- | ------------------------------------- |
| Mobile App            | Flutter (Dart), flutter_barcode_sdk   |
| Backend & Auth        | Firebase (Auth, Firestore, Functions) |
| Encryption            | AES encryption, SHA256 for hashing    |
| Blockchain Simulation | Local hash-based verification ledger  |
| Multi-ID Structure    | JSON + Firestore schema design        |
| Digital Consent Logs  | Firestore logging + real-time UI      |
| Biometric Auth        | Flutter biometric plugins             |
| UI/UX Prototyping     | Figma                                 |
| Version Control       | Git + GitHub                          |

---

## 🚀 Installation and Deployment

### Prerequisites

Before running the Digital Fayda Wallet application, ensure you have the following installed:

- **Docker** (v20.10 or later) and **Docker Compose** (v2.0 or later)
- **Git** for cloning the repository
- **Flutter SDK** (v3.16.0 or later) for local development
- **Firebase CLI** (optional, for Firebase deployment)

### Quick Start with Docker

**Note: If you prefer to run with Flutter directly, skip to "Local Development Setup" section below.**

1. **Clone the Repository**
   ```bash
   git clone <your-repo-url>
   cd digital-fayda-wallet
   ```

2. **Build and Run with Docker Compose**
   ```bash
   # Build and start all services
   docker-compose up --build
   
   # Or run in detached mode
   docker-compose up -d --build
   ```

3. **Access the Application**
   - **Web App**: http://localhost:3000
   - **Firebase Emulator UI**: http://localhost:4000
   - **API Health Check**: http://localhost/health

### Local Development Setup

**This is the recommended approach for development and hackathon testing.**

#### Installing Dependencies

1. **Install Flutter SDK**
   
   Follow the official Flutter installation guide for your platform:
   - **Windows**: https://docs.flutter.dev/get-started/install/windows
   - **macOS**: https://docs.flutter.dev/get-started/install/macos  
   - **Linux**: https://docs.flutter.dev/get-started/install/linux

   Or use the quick install scripts provided:
   ```bash
   # For Linux/macOS
   chmod +x run_app.sh
   ./run_app.sh
   
   # For Windows
   run_app.bat
   ```

2. **Verify Flutter Installation**
   ```bash
   flutter doctor
   ```
   Fix any issues shown before proceeding.

3. **Install Flutter Dependencies**
   ```bash
   flutter pub get
   ```

4. **Enable Flutter Web Support**
   ```bash
   flutter config --enable-web
   ```

#### Running the App Locally

1. **Quick Start (Recommended)**
   ```bash
   # All-in-one command
   flutter pub get && flutter config --enable-web && flutter run -d web-server --web-port 8080
   ```

2. **Step by Step**
   ```bash
   # Clean and get dependencies
   flutter clean
   flutter pub get
   
   # Run the app
   flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
   ```

3. **Access the App**
   Open your browser and go to: http://localhost:8080

4. **Alternative: Start Firebase Emulators (Optional)**
   ```bash
   firebase emulators:start
   ```

#### Other Platforms

**Android Emulator:**
```bash
# Start Android emulator first, then:
flutter run
```

**iOS Simulator (macOS only):**
```bash
# Start iOS simulator first, then:
flutter run
```

#### Development Tips

- **Hot Reload**: Press `r` in terminal while app is running
- **Hot Restart**: Press `R` in terminal while app is running  
- **Stop App**: Press `q` or `Ctrl+C`
- **Debug Mode**: `flutter run --debug` (default)
- **Release Mode**: `flutter run --release`

### Troubleshooting Flutter Issues

#### Common Problems:

1. **"flutter: command not found"**
   ```bash
   # Ensure Flutter is in your PATH
   # Restart terminal and try: flutter doctor
   ```

2. **Dependencies issues**
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Web build issues**
   ```bash
   flutter config --enable-web
   flutter clean
   flutter pub get
   flutter build web
   ```

4. **Gradle issues (Android)**
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   ```

### Production Deployment

#### Option 1: Docker Deployment

1. **Build the Production Image**
   ```bash
   docker build -t digital-fayda-wallet:latest .
   ```

2. **Run the Production Container**
   ```bash
   docker run -p 80:80 digital-fayda-wallet:latest
   ```

#### Option 2: Firebase Hosting

1. **Build the Web App**
   ```bash
   flutter build web --release
   ```

2. **Deploy to Firebase Hosting**
   ```bash
   firebase login
   firebase init hosting
   firebase deploy --only hosting
   ```

### Environment Configuration

#### Firebase Configuration

The Firebase configuration is already set up in `lib/firebase_options.dart`. For production deployment, update the configuration with your actual Firebase project credentials:

```dart
// Update these values with your actual Firebase project configuration
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-actual-api-key',
  appId: 'your-actual-app-id',
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  authDomain: 'your-project.firebaseapp.com',
  storageBucket: 'your-project.appspot.com',
);
```

#### Environment Variables

Set the following environment variables for production:

```bash
# API Configuration
API_BASE_URL=https://api.verifayda.com
OIDC_CLIENT_ID=your_client_id
OIDC_REDIRECT_URI=your_redirect_uri

# Firebase Configuration
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_API_KEY=your_api_key
FIREBASE_AUTH_DOMAIN=your_auth_domain

# Security
ENCRYPTION_KEY=your_encryption_key
JWT_SECRET=your_jwt_secret
```

### VeriFayda OIDC Integration

This application integrates with VeriFayda OIDC as per hackathon requirements:

#### Authentication Flow
1. **User initiates login** - Clicks "Sign in with VeriFayda"
2. **OIDC Authorization** - App redirects to VeriFayda authorization server
3. **User Authentication** - User authenticates with VeriFayda credentials
4. **Authorization Code** - VeriFayda returns authorization code
5. **Token Exchange** - App exchanges code for access/ID tokens
6. **Firebase Integration** - Custom token created for Firebase authentication
7. **User Session** - User is signed in with verified Fayda ID data

#### Configuration
The VeriFayda integration is configured in `lib/features/auth/data/repositories/verifayda_auth_repository.dart`:

```dart
// VeriFayda OIDC Configuration
static const String _veriFaydaBaseUrl = 'https://api.verifayda.com';
static const String _clientId = 'digital_fayda_wallet_hackathon';
static const String _redirectUri = 'com.digitalfayda.wallet://auth/callback';
```

#### Security Features
- **Secure Token Storage** - All tokens stored using Flutter Secure Storage
- **Token Refresh** - Automatic token refresh when expired
- **Biometric Authentication** - Additional security layer with device biometrics
- **Session Management** - Proper session handling and cleanup

### Testing the Application

#### Manual Testing Checklist

1. **Authentication Flow**
   - [ ] VeriFayda OIDC login works
   - [ ] Biometric authentication functions
   - [ ] User can logout successfully

2. **Wallet Functionality**
   - [ ] Fayda ID displays correctly
   - [ ] QR code generation works
   - [ ] QR code expires after 5 minutes

3. **Security Features**
   - [ ] Data is encrypted locally
   - [ ] Biometric prompts appear
   - [ ] Session management works

4. **UI/UX**
   - [ ] App loads within 3 seconds
   - [ ] Responsive design works on mobile/desktop
   - [ ] Ethiopian flag colors are consistent

#### Automated Testing

Run the test suite to verify functionality:

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Troubleshooting

#### Common Issues

1. **Docker Build Fails**
   ```bash
   # Clear Docker cache and rebuild
   docker system prune -a
   docker-compose up --build --force-recreate
   ```

2. **Flutter Dependencies Issues**
   ```bash
   # Clean and reinstall dependencies
   flutter clean
   flutter pub get
   ```

3. **Firebase Connection Issues**
   ```bash
   # Check Firebase configuration
   firebase projects:list
   firebase use your-project-id
   ```

4. **VeriFayda Authentication Issues**
   ```bash
   # Check network connectivity
   curl -I https://api.verifayda.com/health
   
   # Verify OIDC configuration
   flutter logs | grep "VeriFayda"
   ```

### Security Considerations

1. **HTTPS Configuration**
   - Always use HTTPS in production
   - Configure SSL certificates properly
   - Use HSTS headers (already configured in nginx)

2. **Data Protection**
   - All sensitive data is encrypted at rest
   - Biometric data never leaves the device
   - QR codes have short expiration times

3. **Firebase Security**
   - Review Firestore rules regularly
   - Enable audit logging
   - Use Firebase App Check in production

4. **VeriFayda Integration Security**
   - OIDC state and nonce parameters prevent CSRF attacks
   - Tokens are stored securely using device keychain
   - Regular token rotation and validation
   - Secure communication with HTTPS only

### Hackathon Compliance

This project meets all Fayda Hackathon requirements:

✅ **Project Structure** - Complete Flutter app with proper organization
✅ **Working Main Branch** - Fully functional code on main branch
✅ **VeriFayda OIDC Integration** - Implemented as per documentation
✅ **Docker Deployment** - Complete Docker setup with compose file
✅ **README Documentation** - Comprehensive installation and deployment guide

### Demo Credentials

For hackathon demonstration purposes, the app includes demo authentication flow. In production, replace with actual VeriFayda credentials and endpoints.
---
