# Digital Fayda Wallet - Usage Guide

## Table of Contents
1. [Getting Started](#getting-started)
2. [Project Setup](#project-setup)
3. [Development Workflow](#development-workflow)
4. [Authentication Integration](#authentication-integration)
5. [State Management](#state-management)
6. [Navigation](#navigation)
7. [UI Development](#ui-development)
8. [Testing](#testing)
9. [Build and Deployment](#build-and-deployment)
10. [Best Practices](#best-practices)
11. [Troubleshooting](#troubleshooting)

## Getting Started

### Prerequisites

Before working with the Digital Fayda Wallet app, ensure you have:

- **Flutter SDK** (>=3.10.0)
- **Dart SDK** (>=3.0.0)
- **Android Studio** or **VS Code** with Flutter extensions
- **Firebase CLI** for Firebase services
- **Git** for version control

### Quick Start

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd digital_fayda_wallet
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## Project Setup

### Environment Configuration

1. **Firebase Setup:**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Initialize Firebase in the project
   firebase init
   ```

2. **Configure Firebase services:**
   - Authentication
   - Firestore Database
   - Firebase Storage

3. **Environment Variables:**
   Create a `.env` file for sensitive configurations:
   ```env
   VERIFAYDA_API_BASE_URL=https://api.verifayda.com
   FIREBASE_PROJECT_ID=your-project-id
   ```

### Dependencies Management

Key dependencies in `pubspec.yaml`:

```yaml
dependencies:
  # State Management
  flutter_riverpod: ^2.4.9
  
  # Authentication & Security
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  local_auth: ^2.1.7
  flutter_secure_storage: ^9.0.0
  
  # Navigation
  go_router: ^12.1.3
  
  # QR Code
  qr_flutter: ^4.1.0
  qr_code_scanner: ^1.0.1
  
  # Storage
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
```

## Development Workflow

### Feature Development Process

1. **Create Feature Branch:**
   ```bash
   git checkout -b feature/new-feature-name
   ```

2. **Feature Structure:**
   ```
   lib/features/new_feature/
   ├── domain/
   │   └── entities/
   ├── data/
   │   └── repositories/
   └── presentation/
       ├── pages/
       ├── providers/
       └── widgets/
   ```

3. **Implementation Steps:**
   - Create domain entities
   - Implement data repositories
   - Create Riverpod providers
   - Build UI components
   - Add navigation routes
   - Write tests

### Code Generation

For models with JSON serialization:

```bash
# Run code generation
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch
```

## Authentication Integration

### Setting Up Authentication

1. **Configure AuthRepository:**
   ```dart
   class AuthRepository {
     final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
     final LocalAuthentication _localAuth = LocalAuthentication();
     final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
     
     // Implementation methods...
   }
   ```

2. **Create Authentication Provider:**
   ```dart
   final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
     return AuthNotifier(ref.read(authRepositoryProvider));
   });
   ```

3. **Use in UI Components:**
   ```dart
   class LoginPage extends ConsumerWidget {
     @override
     Widget build(BuildContext context, WidgetRef ref) {
       final authState = ref.watch(authProvider);
       
       return Scaffold(
         body: Column(
           children: [
             if (authState.isLoading)
               const CircularProgressIndicator(),
             ElevatedButton(
               onPressed: () {
                 ref.read(authProvider.notifier).signInWithVeriPaydaOIDC();
               },
               child: const Text('Sign In'),
             ),
           ],
         ),
       );
     }
   }
   ```

### VeriPayda OIDC Integration

```dart
Future<User?> signInWithVeriPaydaOIDC() async {
  try {
    // Step 1: Call VeriPayda OIDC endpoint
    final response = await _dio.post(
      '${AppConstants.baseUrl}${AppConstants.oidcEndpoint}',
      data: {
        'client_id': 'digital_fayda_wallet',
        'response_type': 'code',
        'scope': 'openid profile fayda_id',
        'redirect_uri': 'com.digitalfayda.wallet://auth/callback',
      },
    );

    if (response.statusCode == 200) {
      final authData = response.data;
      
      // Step 2: Store tokens securely
      await _secureStorage.write(key: 'id_token', value: authData['id_token']);
      await _secureStorage.write(key: 'access_token', value: authData['access_token']);

      // Step 3: Create and use Firebase custom token
      final customToken = await _createFirebaseCustomToken(authData['id_token']);
      final userCredential = await _firebaseAuth.signInWithCustomToken(customToken);
      
      return userCredential.user;
    }
  } catch (e) {
    throw Exception('VeriPayda OIDC authentication failed: $e');
  }
  return null;
}
```

### Biometric Authentication

```dart
Future<bool> authenticateWithBiometrics() async {
  try {
    final bool isAvailable = await _localAuth.canCheckBiometrics;
    if (!isAvailable) {
      throw Exception('Biometric authentication not available');
    }

    final bool didAuthenticate = await _localAuth.authenticate(
      localizedReason: AppConstants.biometricReason,
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );

    return didAuthenticate;
  } catch (e) {
    throw Exception('Biometric authentication failed: $e');
  }
}
```

## State Management

### Riverpod Provider Setup

1. **Repository Provider:**
   ```dart
   final authRepositoryProvider = Provider<AuthRepository>((ref) {
     return AuthRepository();
   });
   ```

2. **State Notifier Provider:**
   ```dart
   final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
     return AuthNotifier(ref.read(authRepositoryProvider));
   });
   ```

3. **Future Provider for Async Data:**
   ```dart
   final userProfileProvider = FutureProvider<UserProfile>((ref) async {
     final authRepo = ref.read(authRepositoryProvider);
     return authRepo.getUserProfile();
   });
   ```

### State Management Patterns

#### Loading States
```dart
class DataState<T> {
  final bool isLoading;
  final T? data;
  final String? error;

  const DataState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  const DataState.loading() : this(isLoading: true);
  const DataState.data(T data) : this(data: data);
  const DataState.error(String error) : this(error: error);
}
```

#### Using AsyncValue
```dart
final dataProvider = FutureProvider<List<Item>>((ref) async {
  // Async operation
  return await fetchData();
});

// In UI
Consumer(
  builder: (context, ref, child) {
    final asyncData = ref.watch(dataProvider);
    
    return asyncData.when(
      data: (data) => ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(data[index].name),
        ),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  },
)
```

## Navigation

### GoRouter Configuration

```dart
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppConstants.splashRoute,
    routes: [
      GoRoute(
        path: AppConstants.homeRoute,
        name: 'home',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}
```

### Navigation Examples

```dart
// Simple navigation
context.go('/wallet');

// Named route navigation
context.goNamed('profile');

// Navigation with parameters
context.go('/wallet/details/${userId}');

// Replace current route
context.replace('/login');

// Go back
context.pop();
```

### Route Guards

```dart
GoRoute(
  path: '/protected',
  name: 'protected',
  builder: (context, state) => const ProtectedPage(),
  redirect: (context, state) {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) {
      return '/login';
    }
    return null;
  },
)
```

## UI Development

### Creating New Pages

1. **Basic Page Structure:**
   ```dart
   class NewPage extends ConsumerWidget {
     const NewPage({super.key});

     @override
     Widget build(BuildContext context, WidgetRef ref) {
       return Scaffold(
         appBar: AppBar(
           title: const Text('New Page'),
         ),
         body: SingleChildScrollView(
           padding: const EdgeInsets.all(16.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               // Page content
             ],
           ),
         ),
       );
     }
   }
   ```

2. **Add to Router:**
   ```dart
   GoRoute(
     path: '/new-page',
     name: 'new-page',
     builder: (context, state) => const NewPage(),
   )
   ```

### Custom Widgets

```dart
class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Theme Usage

```dart
// Using theme colors
Container(
  color: AppTheme.primaryColor,
  child: Text(
    'Themed Text',
    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
)

// Using theme components
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppTheme.primaryColor,
  ),
  onPressed: () {},
  child: const Text('Button'),
)
```

### QR Code Integration

#### Generating QR Codes
```dart
import 'package:qr_flutter/qr_flutter.dart';

void _showQRDialog(BuildContext context) {
  final qrData = {
    'id': 'fayda_123456789',
    'type': 'fayda_id',
    'timestamp': DateTime.now().millisecondsSinceEpoch,
    'expires': DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch,
  };

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Your QR Code'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: jsonEncode(qrData),
            size: 200.0,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 16),
          Text('Expires in ${AppConstants.qrCodeExpiryMinutes} minutes'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
```

#### Scanning QR Codes
```dart
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

Future<void> scanQRCode() async {
  try {
    final qrCode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.QR,
    );

    if (qrCode != '-1') {
      final data = jsonDecode(qrCode);
      // Process scanned data
      await processQRData(data);
    }
  } catch (e) {
    print('Error scanning QR code: $e');
  }
}
```

## Testing

### Unit Testing

```dart
// test/auth/auth_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('AuthRepository Tests', () {
    late AuthRepository authRepository;
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      authRepository = AuthRepository(firebaseAuth: mockFirebaseAuth);
    });

    test('should return current user when authenticated', () {
      // Arrange
      final mockUser = MockUser();
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      // Act
      final result = authRepository.getCurrentUser();

      // Assert
      expect(result, equals(mockUser));
    });

    test('should handle sign out', () async {
      // Act
      await authRepository.signOut();

      // Assert
      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });
}
```

### Widget Testing

```dart
// test/pages/home_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('HomePage displays welcome message', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: const HomePage(),
        ),
      ),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Welcome back,'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
  });

  testWidgets('HomePage navigates to wallet on card tap', (WidgetTester tester) async {
    // Test navigation functionality
  });
}
```

### Integration Testing

```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:digital_fayda_wallet/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('complete authentication flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test splash screen
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test login page
      expect(find.text('Sign In with VeriPayda'), findsOneWidget);
      
      // Tap sign in button
      await tester.tap(find.text('Sign In with VeriPayda'));
      await tester.pumpAndSettle();

      // Verify navigation to home page
      expect(find.text('Digital Fayda Wallet'), findsOneWidget);
    });
  });
}
```

### Running Tests

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/pages/

# Integration tests
flutter test integration_test/

# Test with coverage
flutter test --coverage
```

## Build and Deployment

### Development Build

```bash
# Debug build
flutter run

# Profile build
flutter run --profile

# Release build
flutter run --release
```

### Android Build

```bash
# Build APK
flutter build apk

# Build App Bundle
flutter build appbundle

# Build with specific flavor
flutter build apk --flavor production
```

### iOS Build

```bash
# Build iOS app
flutter build ios

# Build for release
flutter build ios --release
```

### Firebase Deployment

```bash
# Deploy to Firebase Hosting
firebase deploy --only hosting

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy all
firebase deploy
```

### Environment-Specific Builds

1. **Create flavor configurations:**
   ```yaml
   # android/app/build.gradle
   flavorDimensions "default"
   productFlavors {
       development {
           dimension "default"
           applicationIdSuffix ".dev"
           versionNameSuffix "-dev"
       }
       production {
           dimension "default"
       }
   }
   ```

2. **Build with flavor:**
   ```bash
   flutter build apk --flavor development
   flutter build apk --flavor production
   ```

## Best Practices

### Code Organization

1. **Feature-based structure:**
   ```
   lib/
   ├── core/           # Shared utilities
   ├── features/       # Feature modules
   │   ├── auth/
   │   ├── wallet/
   │   └── profile/
   └── main.dart
   ```

2. **Consistent naming:**
   - Files: `snake_case`
   - Classes: `PascalCase`
   - Variables: `camelCase`
   - Constants: `UPPER_SNAKE_CASE`

### State Management

1. **Use appropriate providers:**
   - `Provider` for dependency injection
   - `StateNotifierProvider` for complex state
   - `FutureProvider` for async operations

2. **Keep providers focused:**
   ```dart
   // Good: Focused on authentication
   final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
     return AuthNotifier(ref.read(authRepositoryProvider));
   });

   // Bad: Too many responsibilities
   final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
     return AppNotifier(); // Handles auth, user data, settings, etc.
   });
   ```

### Error Handling

1. **Consistent error handling:**
   ```dart
   try {
     await authRepository.signIn();
   } catch (e) {
     if (e is AuthException) {
       // Handle auth-specific errors
     } else if (e is NetworkException) {
       // Handle network errors
     } else {
       // Handle general errors
     }
   }
   ```

2. **User-friendly error messages:**
   ```dart
   String getErrorMessage(Exception e) {
     if (e is AuthException) {
       return 'Authentication failed. Please try again.';
     } else if (e is NetworkException) {
       return 'Network error. Check your connection.';
     }
     return 'Something went wrong. Please try again.';
   }
   ```

### Performance

1. **Optimize widget rebuilds:**
   ```dart
   // Use Consumer for specific parts
   Consumer(
     builder: (context, ref, child) {
       final authState = ref.watch(authProvider);
       return Text(authState.user?.name ?? 'Guest');
     },
   )
   ```

2. **Use const constructors:**
   ```dart
   const Text('Static text')
   const SizedBox(height: 16)
   ```

### Security

1. **Secure storage for sensitive data:**
   ```dart
   final secureStorage = FlutterSecureStorage();
   await secureStorage.write(key: 'token', value: accessToken);
   ```

2. **Validate user input:**
   ```dart
   String? validateEmail(String? value) {
     if (value?.isEmpty ?? true) return 'Email is required';
     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
       return 'Enter a valid email';
     }
     return null;
   }
   ```

## Troubleshooting

### Common Issues

1. **Firebase initialization error:**
   ```dart
   // Solution: Ensure Firebase is initialized before runApp
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
     runApp(MyApp());
   }
   ```

2. **Provider not found error:**
   ```dart
   // Solution: Ensure ProviderScope wraps the app
   runApp(
     const ProviderScope(
       child: MyApp(),
     ),
   );
   ```

3. **Build errors with code generation:**
   ```bash
   # Clean and rebuild
   flutter clean
   flutter pub get
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

### Debugging

1. **Enable Flutter Inspector:**
   ```bash
   flutter run --debug
   ```

2. **Use debugger breakpoints:**
   ```dart
   debugger(); // Breaks here when debugging
   ```

3. **Print debugging:**
   ```dart
   print('Debug: $variable');
   debugPrint('Debug message');
   ```

4. **Network debugging:**
   ```dart
   final dio = Dio();
   dio.interceptors.add(LogInterceptor(
     requestBody: true,
     responseBody: true,
   ));
   ```

### Performance Issues

1. **Identify performance bottlenecks:**
   ```bash
   flutter run --profile
   ```

2. **Use Flutter DevTools:**
   ```bash
   flutter pub global activate devtools
   flutter pub global run devtools
   ```

3. **Optimize images:**
   ```yaml
   # Use appropriate image formats
   assets:
     - assets/images/logo.webp  # Better than PNG for photos
     - assets/images/icon.png   # Good for simple graphics
   ```

This usage guide provides comprehensive instructions for developing, testing, and deploying the Digital Fayda Wallet application. Follow these practices to ensure consistent, maintainable, and high-quality code.