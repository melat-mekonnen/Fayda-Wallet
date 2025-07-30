class AppConstants {
  // Storage box names
  static const String settingsBox = 'settings';
  static const String userDataBox = 'userData';
  static const String walletDataBox = 'walletData';
  
  // FAN (Fayda Authentication Network) Configuration
  static const String fanBaseUrl = 'https://fan.fayda.gov.et';
  static const String fanOidcIssuer = 'https://fan.fayda.gov.et/auth/realms/fayda';
  static const String fanClientId = 'digital_fayda_wallet';
  static const String fanRedirectUri = 'com.digitalfayda.wallet://auth/callback';
  static const String fanScope = 'openid profile fayda_id citizen_data';
  
  // Legacy API endpoints (for backward compatibility)
  static const String baseUrl = 'https://api.verifayda.com';
  static const String oidcEndpoint = '/auth/oidc';
  static const String verificationEndpoint = '/verify';
  
  // FAN API Endpoints
  static const String fanUserInfoEndpoint = '/auth/realms/fayda/protocol/openid-connect/userinfo';
  static const String fanTokenEndpoint = '/auth/realms/fayda/protocol/openid-connect/token';
  static const String fanAuthEndpoint = '/auth/realms/fayda/protocol/openid-connect/auth';
  static const String fanVerificationEndpoint = '/api/v1/verify';
  
  // App info
  static const String appName = 'Digital Fayda Wallet';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Official digital wallet for Fayda ID - powered by FAN';
  
  // Security
  static const String encryptionKey = 'fayda_wallet_key_2024';
  static const int qrCodeExpiryMinutes = 5;
  static const int tokenRefreshThresholdMinutes = 10;
  
  // Biometric auth
  static const String biometricReason = 'Authenticate to access your digital Fayda ID';
  
  // Fayda ID Configuration
  static const String faydaIdPrefix = 'FID';
  static const int faydaIdLength = 12;
  static const String faydaIdPattern = r'^FID\d{9}$';
  
  // Routes
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String walletRoute = '/wallet';
  static const String settingsRoute = '/settings';
  static const String qrScanRoute = '/qr-scan';
  static const String profileRoute = '/profile';
}