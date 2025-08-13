# Digital Fayda Wallet - Component Documentation

## Table of Contents
1. [Overview](#overview)
2. [Page Components](#page-components)
3. [UI Components](#ui-components)
4. [State Management Components](#state-management-components)
5. [Utility Components](#utility-components)
6. [Component Architecture](#component-architecture)
7. [Styling Guidelines](#styling-guidelines)
8. [Usage Examples](#usage-examples)

## Overview

This document provides comprehensive documentation for all UI components and widgets used in the Digital Fayda Wallet application. Each component is documented with its purpose, properties, usage examples, and styling guidelines.

## Page Components

### SplashPage

Initial loading screen displayed when the app starts.

```dart
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});
}
```

#### Features
- App initialization
- Authentication state checking
- Automatic navigation based on auth status
- Loading animations

#### Usage
```dart
// Automatically displayed as initial route
GoRoute(
  path: AppConstants.splashRoute,
  name: 'splash',
  builder: (context, state) => const SplashPage(),
)
```

#### Implementation Details
- Uses `ConsumerStatefulWidget` for state management
- Checks authentication state on initialization
- Navigates to home or login based on auth status
- Displays app logo and loading indicator

### LoginPage

Authentication interface with multiple sign-in options.

```dart
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});
}
```

#### Features
- VeriPayda OIDC authentication
- Biometric authentication
- Loading states
- Error handling
- Responsive design

#### Props/State
- `authState` - Current authentication state from provider
- Loading indicators during authentication
- Error message display

#### Usage Example
```dart
ElevatedButton(
  onPressed: authState.isLoading ? null : () {
    ref.read(authProvider.notifier).signInWithVeriPaydaOIDC();
  },
  child: const Text('Sign In with VeriPayda'),
)
```

#### Styling
- Uses `AppTheme.primaryColor` for primary buttons
- Ethiopian flag colors for branding
- Material 3 design components
- Responsive padding and spacing

### HomePage

Main dashboard with quick actions and user information.

```dart
class HomePage extends ConsumerWidget {
  const HomePage({super.key});
}
```

#### Features
- Welcome message with user name
- Quick action cards grid
- Security status indicator
- Navigation to other features

#### Key Widgets
- Welcome card with user greeting
- 2x2 grid of action cards
- Security status card
- AppBar with settings navigation

#### Action Cards
Each action card includes:
- Icon representation
- Title text
- Subtitle description
- Tap navigation

#### Usage Example
```dart
_buildActionCard(
  context,
  icon: Icons.account_balance_wallet,
  title: 'My Wallet',
  subtitle: 'View your digital IDs',
  onTap: () => context.go(AppConstants.walletRoute),
)
```

### WalletPage

Digital ID management and QR code generation interface.

```dart
class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});
}
```

#### Features
- Fayda ID card display
- User information rows
- QR code generation dialog
- Additional ID placeholders

#### Key Components
- ID card with user details
- Info rows for structured data display
- QR generation button
- Additional ID list tiles

#### QR Code Dialog
```dart
void _showQRDialog(BuildContext context) {
  // Creates modal dialog with QR code
  // Includes expiry information
  // Uses QrImageView widget
}
```

#### Data Structure
```dart
final qrData = {
  'id': 'fayda_123456789',
  'type': 'fayda_id',
  'timestamp': DateTime.now().millisecondsSinceEpoch,
  'expires': DateTime.now().add(Duration(minutes: 5)).millisecondsSinceEpoch,
};
```

### QRScanPage

QR code scanning interface (placeholder implementation).

```dart
class QRScanPage extends StatelessWidget {
  const QRScanPage({super.key});
}
```

#### Features
- Scanner placeholder UI
- Instructions for users
- Camera activation button
- Centered layout design

#### Future Implementation
- Camera integration
- QR code detection
- Result processing
- Error handling

### ProfilePage

User profile information and management.

```dart
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});
}
```

#### Features
- User profile display
- Account information
- Profile picture
- Edit capabilities (future)

### SettingsPage

Application settings and preferences.

```dart
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});
}
```

#### Features
- App preferences
- Security settings
- Theme selection
- Account management

## UI Components

### Action Card Component

Reusable card component for quick actions on the home page.

```dart
Widget _buildActionCard(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
})
```

#### Properties
- `icon` - Material icon to display
- `title` - Main action title
- `subtitle` - Descriptive text
- `onTap` - Callback function for tap events

#### Styling
- Card elevation and rounded corners
- Primary color icon
- Bold title text
- Grey subtitle text
- Centered content alignment
- InkWell for tap effects

#### Usage
```dart
_buildActionCard(
  context,
  icon: Icons.qr_code_scanner,
  title: 'Scan QR',
  subtitle: 'Verify someone else',
  onTap: () => context.go(AppConstants.qrScanRoute),
)
```

### Info Row Component

Displays label-value pairs in the wallet page.

```dart
Widget _buildInfoRow(String label, String value)
```

#### Properties
- `label` - Field label (e.g., "Name:")
- `value` - Field value (e.g., "John Doe")

#### Styling
- Fixed width label column
- Bold value text
- Consistent vertical spacing
- Grey label color

#### Usage
```dart
_buildInfoRow('Name', 'John Doe')
_buildInfoRow('ID Number', '****-****-1234')
_buildInfoRow('Status', 'Active')
```

### QR Code Display

QR code generation and display component.

```dart
QrImageView(
  data: qrData.toString(),
  size: 200.0,
  backgroundColor: Colors.white,
)
```

#### Properties
- `data` - QR code data string
- `size` - QR code dimensions
- `backgroundColor` - Background color

#### Features
- Automatic QR generation
- Customizable size
- White background for contrast
- Error correction built-in

### Security Status Card

Displays current security status on home page.

```dart
Card(
  color: AppTheme.primaryColor.withOpacity(0.1),
  child: // Security status content
)
```

#### Features
- Security icon
- Status message
- Check mark indicator
- Themed background color

#### Styling
- Light green background
- Primary color icons and text
- Consistent padding
- Row layout with icons

## State Management Components

### Consumer Widgets

All page components extend `ConsumerWidget` for Riverpod integration.

```dart
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    // Component implementation
  }
}
```

#### Benefits
- Automatic rebuild on state changes
- Access to provider data
- Efficient widget updates
- Type-safe state access

### Provider Integration

Components use providers for:
- Authentication state
- User data
- Loading states
- Error handling

#### Common Pattern
```dart
final authState = ref.watch(authProvider);

// Conditional rendering based on state
if (authState.isLoading) {
  return CircularProgressIndicator();
}

if (authState.error != null) {
  return Text('Error: ${authState.error}');
}

// Normal content
return NormalWidget();
```

## Utility Components

### Navigation Helpers

Components use GoRouter for navigation:

```dart
// Direct navigation
context.go(AppConstants.walletRoute);

// Named route navigation
context.goNamed('profile');

// Navigation with parameters
context.go('/wallet/details/${userId}');
```

### Theme Integration

All components use centralized theming:

```dart
// Color usage
color: AppTheme.primaryColor
backgroundColor: AppTheme.backgroundColor

// Text styling
style: Theme.of(context).textTheme.headlineSmall?.copyWith(
  fontWeight: FontWeight.bold,
  color: AppTheme.primaryColor,
)
```

### Responsive Design

Components adapt to different screen sizes:

```dart
// Responsive padding
padding: const EdgeInsets.all(16.0)

// Flexible layouts
Expanded(child: content)

// Grid layouts
GridView.count(
  crossAxisCount: 2,
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
)
```

## Component Architecture

### Widget Hierarchy

```
MaterialApp
├── Scaffold
│   ├── AppBar
│   └── Body
│       ├── SingleChildScrollView
│       └── Column/ListView
│           ├── Cards
│           ├── Buttons
│           └── Custom Widgets
```

### State Flow

```
Provider → Consumer Widget → UI Update
    ↑           ↓
Repository ← User Action
```

### Component Communication

1. **Parent to Child**: Props/Parameters
2. **Child to Parent**: Callbacks
3. **Global State**: Riverpod Providers
4. **Navigation**: GoRouter context

## Styling Guidelines

### Color Scheme

```dart
// Primary colors (Ethiopian flag inspired)
primaryColor: Color(0xFF2E7D32)    // Green
secondaryColor: Color(0xFFFFD700)  // Yellow  
accentColor: Color(0xFFDC143C)     // Red

// Neutral colors
backgroundColor: Color(0xFFF5F5F5)
surfaceColor: Colors.white
errorColor: Color(0xFFD32F2F)
```

### Typography

```dart
// Headlines
Theme.of(context).textTheme.headlineSmall?.copyWith(
  fontWeight: FontWeight.bold,
)

// Body text
Theme.of(context).textTheme.bodyMedium

// Captions
Theme.of(context).textTheme.bodySmall?.copyWith(
  color: Colors.grey[600],
)
```

### Spacing

```dart
// Standard spacing units
const SizedBox(height: 8)   // Small
const SizedBox(height: 16)  // Medium  
const SizedBox(height: 24)  // Large
const SizedBox(height: 32)  // Extra large
```

### Card Design

```dart
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: content,
  ),
)
```

### Button Styling

```dart
ElevatedButton.styleFrom(
  backgroundColor: AppTheme.primaryColor,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
)
```

## Usage Examples

### Creating a New Page Component

```dart
class NewFeaturePage extends ConsumerWidget {
  const NewFeaturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch relevant providers
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Feature'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Feature Title',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Feature description',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle action
                    },
                    child: const Text('Primary Action'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle secondary action
                    },
                    child: const Text('Secondary'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### Creating Custom Widgets

```dart
class CustomInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const CustomInfoCard({
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
              Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Dialog Components

```dart
void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Dialog Title'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dialog content
          const Text('Dialog message'),
          const SizedBox(height: 16),
          // Custom widget in dialog
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Important information'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle confirmation
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}
```

### Loading States

```dart
class LoadingStateExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(someProvider);
    
    return Scaffold(
      body: state.when(
        data: (data) => ContentWidget(data: data),
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading...'),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: AppTheme.errorColor,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Error: $error',
                style: TextStyle(color: AppTheme.errorColor),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Retry logic
                  ref.refresh(someProvider);
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Form Components

```dart
class FormExample extends StatefulWidget {
  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Email is required';
                  }
                  if (!value!.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Handle form submission
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Form submitted successfully'),
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
```

This component documentation provides comprehensive guidance for understanding, using, and extending the UI components in the Digital Fayda Wallet application. Each component is designed with consistency, reusability, and maintainability in mind, following Flutter best practices and the app's design system.