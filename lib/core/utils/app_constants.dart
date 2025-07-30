class AppConstants {
  // Storage box names
  static const String settingsBox = 'settings';
  static const String userDataBox = 'userData';
  static const String walletDataBox = 'walletData';
  
  // API endpoints
  static const String baseUrl = 'https://api.verifayda.com';
  static const String oidcEndpoint = '/auth/oidc';
  static const String verificationEndpoint = '/verify';
  
  // App info
  static const String appName = 'Digital Fayda Wallet';
  static const String appVersion = '1.0.0';
  
  // Security
  static const String encryptionKey = 'fayda_wallet_key_2024';
  static const int qrCodeExpiryMinutes = 5;
  
  // Biometric auth
  static const String biometricReason = 'Authenticate to access your digital wallet';
  
  // Routes
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String walletRoute = '/wallet';
  static const String settingsRoute = '/settings';
  static const String qrScanRoute = '/qr-scan';
  static const String profileRoute = '/profile';
}