# Digital Fayda Wallet - API Documentation

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Core APIs](#core-apis)
4. [Authentication APIs](#authentication-apis)
5. [Wallet APIs](#wallet-apis)
6. [QR Code APIs](#qr-code-apis)
7. [Navigation APIs](#navigation-apis)
8. [Theme APIs](#theme-apis)
9. [Utility APIs](#utility-apis)
10. [State Management](#state-management)
11. [Components](#components)
12. [Examples](#examples)

## Overview

Digital Fayda Wallet is a Flutter-based mobile application for secure digital identity storage and verification. The app uses clean architecture principles with feature-based organization and Riverpod for state management.

### Key Features
- VeriPayda OIDC authentication
- Biometric authentication
- Digital ID storage and management
- QR code generation and scanning
- Secure local storage
- Firebase integration

## Architecture

The app follows clean architecture with three main layers:
- **Presentation Layer**: UI components, pages, and state management
- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Repositories, data sources, and external services

### Directory Structure
```
lib/
├── core/                 # Shared utilities and configurations
│   ├── routing/         # Navigation configuration
│   ├── theme/           # App theming
│   └── utils/           # Utility functions and constants
├── features/            # Feature modules
│   ├── auth/           # Authentication feature
│   ├── home/           # Home dashboard
│   ├── profile/        # User profile management
│   ├── qr/             # QR code functionality
│   ├── settings/       # App settings
│   ├── splash/         # Splash screen
│   └── wallet/         # Digital wallet
├── main.dart           # App entry point
└── app.dart            # Main app configuration
```

## Core APIs

### App Configuration

#### `DigitalFaydaWalletApp`
Main application widget that configures the app.

```dart
class DigitalFaydaWalletApp extends ConsumerWidget {
  const DigitalFaydaWalletApp({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref)
}
```

**Usage:**
```dart
runApp(
  const ProviderScope(
    child: DigitalFaydaWalletApp(),
  ),
);
```

#### `main()` Function
App initialization and setup.

```dart
void main() async
```

**Features:**
- Firebase initialization
- Hive local storage setup
- Provider scope configuration

**Usage:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.settingsBox);
  await Hive.openBox(AppConstants.userDataBox);
  
  runApp(
    const ProviderScope(
      child: DigitalFaydaWalletApp(),
    ),
  );
}
```

## Authentication APIs

### AuthRepository

Primary authentication service handling VeriPayda OIDC and biometric authentication.

#### Methods

##### `getCurrentUser()`
Gets the currently authenticated Firebase user.

```dart
User? getCurrentUser()
```

**Returns:** `User?` - Current Firebase user or null

**Example:**
```dart
final authRepo = AuthRepository();
final user = authRepo.getCurrentUser();
if (user != null) {
  print('User ID: ${user.uid}');
}
```

##### `signInWithVeriPaydaOIDC()`
Authenticates user through VeriPayda OIDC flow.

```dart
Future<User?> signInWithVeriPaydaOIDC() async
```

**Returns:** `Future<User?>` - Authenticated Firebase user

**Flow:**
1. Calls VeriPayda OIDC endpoint
2. Stores tokens securely
3. Creates Firebase custom token
4. Signs in to Firebase

**Example:**
```dart
try {
  final user = await authRepo.signInWithVeriPaydaOIDC();
  if (user != null) {
    print('Successfully authenticated: ${user.email}');
  }
} catch (e) {
  print('Authentication failed: $e');
}
```

##### `authenticateWithBiometrics()`
Performs biometric authentication.

```dart
Future<bool> authenticateWithBiometrics() async
```

**Returns:** `Future<bool>` - Authentication success status

**Example:**
```dart
try {
  final success = await authRepo.authenticateWithBiometrics();
  if (success) {
    print('Biometric authentication successful');
  }
} catch (e) {
  print('Biometric authentication failed: $e');
}
```

##### `signOut()`
Signs out the current user and clears stored tokens.

```dart
Future<void> signOut() async
```

**Example:**
```dart
await authRepo.signOut();
print('User signed out');
```

##### `isBiometricEnabled()` / `setBiometricEnabled()`
Manages biometric authentication preference.

```dart
Future<bool> isBiometricEnabled() async
Future<void> setBiometricEnabled(bool enabled) async
```

**Example:**
```dart
// Check if biometric is enabled
final isEnabled = await authRepo.isBiometricEnabled();

// Enable biometric authentication
await authRepo.setBiometricEnabled(true);
```

### AuthProvider (Riverpod)

State management for authentication using Riverpod.

#### Providers

```dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});
```

#### AuthState

Authentication state model.

```dart
class AuthState {
  final bool isLoading;
  final UserEntity? user;
  final String? error;
  
  bool get isAuthenticated => user != null;
}
```

**States:**
- `AuthState.initial()` - Initial state
- `AuthState.loading()` - Loading state
- `AuthState.authenticated(user)` - Authenticated state
- `AuthState.unauthenticated()` - Unauthenticated state
- `AuthState.error(message)` - Error state

#### AuthNotifier Methods

##### `signInWithVeriPaydaOIDC()`
```dart
Future<void> signInWithVeriPaydaOIDC() async
```

##### `signInWithBiometrics()`
```dart
Future<void> signInWithBiometrics() async
```

##### `signOut()`
```dart
Future<void> signOut() async
```

**Usage Example:**
```dart
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      body: authState.isLoading
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).signInWithVeriPaydaOIDC();
              },
              child: const Text('Sign In'),
            ),
    );
  }
}
```

### UserEntity

User data model representing authenticated users.

```dart
class UserEntity {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;
}
```

#### Constructors

##### `UserEntity()`
```dart
const UserEntity({
  required String id,
  String? email,
  String? displayName,
  String? photoURL,
  required bool emailVerified,
  DateTime? creationTime,
  DateTime? lastSignInTime,
})
```

##### `UserEntity.fromFirebaseUser()`
```dart
factory UserEntity.fromFirebaseUser(User user)
```

#### Methods

##### `toJson()` / `fromJson()`
```dart
Map<String, dynamic> toJson()
factory UserEntity.fromJson(Map<String, dynamic> json)
```

##### `copyWith()`
```dart
UserEntity copyWith({
  String? id,
  String? email,
  String? displayName,
  String? photoURL,
  bool? emailVerified,
  DateTime? creationTime,
  DateTime? lastSignInTime,
})
```

**Example:**
```dart
final user = UserEntity.fromFirebaseUser(firebaseUser);
final updatedUser = user.copyWith(displayName: 'New Name');
final json = user.toJson();
```

## Wallet APIs

### WalletPage

Main wallet interface for displaying and managing digital IDs.

```dart
class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});
}
```

#### Features
- Fayda ID display
- QR code generation
- Additional ID management

#### Key Methods

##### `_showQRDialog()`
Displays QR code dialog with expiring verification code.

```dart
void _showQRDialog(BuildContext context)
```

**QR Data Structure:**
```dart
final qrData = {
  'id': 'fayda_123456789',
  'type': 'fayda_id',
  'timestamp': DateTime.now().millisecondsSinceEpoch,
  'expires': DateTime.now().add(Duration(minutes: 5)).millisecondsSinceEpoch,
};
```

##### `_buildInfoRow()`
Helper method for displaying user information.

```dart
Widget _buildInfoRow(String label, String value)
```

**Usage:**
```dart
_buildInfoRow('Name', 'John Doe')
_buildInfoRow('ID Number', '****-****-1234')
_buildInfoRow('Status', 'Active')
```

## QR Code APIs

### QRScanPage

QR code scanning interface.

```dart
class QRScanPage extends StatelessWidget {
  const QRScanPage({super.key});
}
```

#### Features
- QR code camera scanning
- Identity verification
- Scan result processing

**Note:** Current implementation is a placeholder. Full scanning functionality requires integration with `flutter_barcode_scanner` or `qr_code_scanner`.

### QR Code Generation

Uses `qr_flutter` package for generating QR codes.

```dart
QrImageView(
  data: qrData.toString(),
  size: 200.0,
  backgroundColor: Colors.white,
)
```

## Navigation APIs

### AppRouter

Centralized routing configuration using GoRouter.

```dart
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppConstants.splashRoute,
    routes: [
      // Route definitions
    ],
  );
}
```

#### Routes

| Route | Path | Name | Component |
|-------|------|------|-----------|
| Splash | `/` | `splash` | `SplashPage` |
| Login | `/login` | `login` | `LoginPage` |
| Home | `/home` | `home` | `HomePage` |
| Wallet | `/wallet` | `wallet` | `WalletPage` |
| Settings | `/settings` | `settings` | `SettingsPage` |
| QR Scan | `/qr-scan` | `qr-scan` | `QRScanPage` |
| Profile | `/profile` | `profile` | `ProfilePage` |

#### Navigation Examples

```dart
// Navigate to wallet
context.go(AppConstants.walletRoute);

// Navigate to QR scanner
context.go(AppConstants.qrScanRoute);

// Navigate with named routes
context.goNamed('profile');
```

## Theme APIs

### AppTheme

Centralized theme configuration with Ethiopian flag colors.

```dart
class AppTheme {
  // Color constants
  static const Color primaryColor = Color(0xFF2E7D32);    // Ethiopian green
  static const Color secondaryColor = Color(0xFFFFD700);   // Ethiopian yellow
  static const Color accentColor = Color(0xFFDC143C);      // Ethiopian red
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);
}
```

#### Theme Data

##### `lightTheme`
```dart
static ThemeData get lightTheme
```

##### `darkTheme`
```dart
static ThemeData get darkTheme
```

#### Theme Components
- Material 3 design system
- Custom AppBar styling
- Elevated button themes
- Input decoration themes
- Card themes with rounded corners

**Usage:**
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,
)
```

## Utility APIs

### AppConstants

Application-wide constants and configuration.

```dart
class AppConstants {
  // Storage box names
  static const String settingsBox = 'settings';
  static const String userDataBox = 'userData';
  static const String walletDataBox = 'walletData';
  
  // API endpoints
  static const String baseUrl = 'https://api.verifayda.com';
  static const String oidcEndpoint = '/auth/oidc';
  static const String verificationEndpoint = '/verify';
  
  // Security
  static const String encryptionKey = 'fayda_wallet_key_2024';
  static const int qrCodeExpiryMinutes = 5;
  static const String biometricReason = 'Authenticate to access your digital wallet';
  
  // Routes (see Navigation APIs section)
}
```

#### Usage Categories

##### Storage Constants
```dart
await Hive.openBox(AppConstants.settingsBox);
```

##### API Endpoints
```dart
final response = await dio.post('${AppConstants.baseUrl}${AppConstants.oidcEndpoint}');
```

##### Security Configuration
```dart
final qrExpiry = DateTime.now().add(Duration(minutes: AppConstants.qrCodeExpiryMinutes));
```

## State Management

### Riverpod Providers

The app uses Riverpod for state management with the following provider pattern:

#### Provider Types Used
- `Provider` - For dependency injection
- `StateNotifierProvider` - For complex state management
- `ConsumerWidget` - For widgets that consume providers

#### Example Provider Setup
```dart
// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// State notifier provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});
```

#### Consumer Usage
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return authState.isLoading
        ? CircularProgressIndicator()
        : Text('User: ${authState.user?.displayName}');
  }
}
```

## Components

### Common UI Components

#### Action Cards (HomePage)
Reusable card components for quick actions.

```dart
Widget _buildActionCard(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
})
```

**Usage:**
```dart
_buildActionCard(
  context,
  icon: Icons.account_balance_wallet,
  title: 'My Wallet',
  subtitle: 'View your digital IDs',
  onTap: () => context.go(AppConstants.walletRoute),
)
```

#### Info Rows (WalletPage)
Displays label-value pairs in wallet information.

```dart
Widget _buildInfoRow(String label, String value)
```

**Usage:**
```dart
_buildInfoRow('Name', 'John Doe')
_buildInfoRow('Status', 'Active')
```

### Page Components

#### SplashPage
App initialization and routing logic.

#### LoginPage  
Authentication interface with VeriPayda OIDC and biometric options.

#### HomePage
Main dashboard with quick actions and user welcome.

#### WalletPage
Digital ID management and QR code generation.

#### ProfilePage
User profile information and settings.

#### SettingsPage
App configuration and preferences.

#### QRScanPage
QR code scanning interface.

## Examples

### Complete Authentication Flow

```dart
class AuthExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      body: Column(
        children: [
          // Display current state
          Text('Status: ${_getStatusText(authState)}'),
          
          // Authentication buttons
          if (!authState.isAuthenticated) ...[
            ElevatedButton(
              onPressed: authState.isLoading ? null : () {
                ref.read(authProvider.notifier).signInWithVeriPaydaOIDC();
              },
              child: Text('Sign In with VeriPayda'),
            ),
            ElevatedButton(
              onPressed: authState.isLoading ? null : () {
                ref.read(authProvider.notifier).signInWithBiometrics();
              },
              child: Text('Sign In with Biometrics'),
            ),
          ] else ...[
            Text('Welcome, ${authState.user?.displayName}!'),
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).signOut();
              },
              child: Text('Sign Out'),
            ),
          ],
          
          // Error display
          if (authState.error != null)
            Text('Error: ${authState.error}', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
  
  String _getStatusText(AuthState state) {
    if (state.isLoading) return 'Loading...';
    if (state.isAuthenticated) return 'Authenticated';
    if (state.error != null) return 'Error';
    return 'Not authenticated';
  }
}
```

### QR Code Generation Example

```dart
class QRGenerationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Generate QR code with user data
            QrImageView(
              data: _generateQRData(),
              size: 200.0,
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 20),
            Text('Scan this QR code for verification'),
            Text('Expires in ${AppConstants.qrCodeExpiryMinutes} minutes'),
          ],
        ),
      ),
    );
  }
  
  String _generateQRData() {
    final qrData = {
      'id': 'fayda_123456789',
      'type': 'fayda_id',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expires': DateTime.now()
          .add(Duration(minutes: AppConstants.qrCodeExpiryMinutes))
          .millisecondsSinceEpoch,
    };
    return qrData.toString();
  }
}
```

### Navigation Example

```dart
class NavigationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Navigation Example')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.go(AppConstants.walletRoute),
            child: Text('Go to Wallet'),
          ),
          ElevatedButton(
            onPressed: () => context.go(AppConstants.qrScanRoute),
            child: Text('Scan QR Code'),
          ),
          ElevatedButton(
            onPressed: () => context.go(AppConstants.profileRoute),
            child: Text('View Profile'),
          ),
          ElevatedButton(
            onPressed: () => context.go(AppConstants.settingsRoute),
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
```

### Theme Usage Example

```dart
class ThemedExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Themed Example'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: AppTheme.surfaceColor,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'This card uses theme colors',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text('Primary Button'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Ethiopian flag colors used throughout',
                style: TextStyle(color: AppTheme.accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Error Handling

### Authentication Errors
```dart
try {
  await authRepository.signInWithVeriPaydaOIDC();
} catch (e) {
  if (e.toString().contains('VeriPayda OIDC authentication failed')) {
    // Handle OIDC specific error
  } else if (e.toString().contains('Biometric authentication failed')) {
    // Handle biometric error
  } else {
    // Handle general authentication error
  }
}
```

### Network Errors
```dart
try {
  final response = await dio.post(url);
} on DioError catch (e) {
  if (e.type == DioErrorType.connectTimeout) {
    // Handle connection timeout
  } else if (e.type == DioErrorType.response) {
    // Handle HTTP error response
  }
}
```

## Security Considerations

### Token Storage
- ID tokens and access tokens are stored using `FlutterSecureStorage`
- Tokens are automatically cleared on sign out
- Biometric preference is stored securely

### QR Code Security
- QR codes expire after 5 minutes
- Include timestamp and expiry in QR data
- Verify expiry before processing scanned codes

### Biometric Authentication
- Uses device's secure biometric storage
- Fallback to device passcode if biometrics fail
- Configurable biometric authentication preference

## Testing

### Unit Testing Example
```dart
void main() {
  group('AuthRepository Tests', () {
    late AuthRepository authRepository;
    
    setUp(() {
      authRepository = AuthRepository();
    });
    
    test('should return current user when authenticated', () {
      // Test getCurrentUser method
    });
    
    test('should handle biometric authentication', () async {
      // Test biometric authentication flow
    });
  });
}
```

### Widget Testing Example
```dart
void main() {
  testWidgets('HomePage displays user name', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: HomePage()),
      ),
    );
    
    expect(find.text('Welcome back,'), findsOneWidget);
  });
}
```

This documentation provides comprehensive coverage of all public APIs, functions, and components in the Digital Fayda Wallet application. Each section includes practical examples and usage instructions to help developers understand and implement the various features effectively.