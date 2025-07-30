import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:dio/dio.dart';
import 'package:digital_fayda_wallet/core/utils/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:openid_client/openid_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'dart:math';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// Enhanced FAN OIDC Authentication
  Future<User?> signInWithFaydaFAN() async {
    try {
      // Step 1: Discover FAN OIDC configuration
      final issuer = await Issuer.discover(Uri.parse(AppConstants.fanOidcIssuer));
      
      // Step 2: Create OIDC client
      final client = Client(
        issuer,
        AppConstants.fanClientId,
      );

      // Step 3: Create authenticator for mobile flow
      final authenticator = Authenticator(
        client,
        scopes: AppConstants.fanScope.split(' '),
        port: 4000,
        urlLancher: (url) async {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            );
          }
        },
      );

      // Step 4: Perform authentication
      final credential = await authenticator.authorize();
      
      if (credential != null) {
        // Step 5: Extract tokens
        final idToken = credential.idToken;
        final accessToken = credential.accessToken;
        final refreshToken = credential.refreshToken;

        // Step 6: Validate ID token
        if (idToken != null && !JwtDecoder.isExpired(idToken)) {
          final decodedToken = JwtDecoder.decode(idToken);
          
          // Step 7: Store tokens securely
          await _secureStorage.write(key: 'fan_id_token', value: idToken);
          await _secureStorage.write(key: 'fan_access_token', value: accessToken);
          if (refreshToken != null) {
            await _secureStorage.write(key: 'fan_refresh_token', value: refreshToken);
          }
          
          // Step 8: Store user info
          await _storeFaydaUserInfo(decodedToken);
          
          // Step 9: Create Firebase custom token
          final customToken = await _createFirebaseCustomToken(idToken);
          
          // Step 10: Sign in to Firebase
          final userCredential = await _firebaseAuth.signInWithCustomToken(customToken);
          
          return userCredential.user;
        }
      }
    } catch (e) {
      throw Exception('FAN OIDC authentication failed: $e');
    }
    return null;
  }

  /// Store Fayda user information from ID token
  Future<void> _storeFaydaUserInfo(Map<String, dynamic> tokenData) async {
    final userInfo = {
      'sub': tokenData['sub'],
      'name': tokenData['name'] ?? tokenData['preferred_username'],
      'email': tokenData['email'],
      'fayda_id': tokenData['fayda_id'],
      'citizen_id': tokenData['citizen_id'],
      'birth_date': tokenData['birthdate'],
      'gender': tokenData['gender'],
      'address': tokenData['address'],
      'phone_number': tokenData['phone_number'],
      'verified': tokenData['verified'] ?? false,
      'issued_at': DateTime.now().toIso8601String(),
    };
    
    await _secureStorage.write(
      key: 'fayda_user_info', 
      value: jsonEncode(userInfo),
    );
  }

  /// Get stored Fayda user information
  Future<Map<String, dynamic>?> getFaydaUserInfo() async {
    final userInfoString = await _secureStorage.read(key: 'fayda_user_info');
    if (userInfoString != null) {
      return jsonDecode(userInfoString);
    }
    return null;
  }

  /// Refresh FAN tokens
  Future<bool> refreshFanTokens() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'fan_refresh_token');
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '${AppConstants.fanBaseUrl}${AppConstants.fanTokenEndpoint}',
        data: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': AppConstants.fanClientId,
        },
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Update stored tokens
        await _secureStorage.write(key: 'fan_access_token', value: data['access_token']);
        if (data['id_token'] != null) {
          await _secureStorage.write(key: 'fan_id_token', value: data['id_token']);
        }
        if (data['refresh_token'] != null) {
          await _secureStorage.write(key: 'fan_refresh_token', value: data['refresh_token']);
        }
        
        return true;
      }
    } catch (e) {
      print('Token refresh failed: $e');
    }
    return false;
  }

  /// Check if FAN tokens are valid and refresh if needed
  Future<bool> ensureValidTokens() async {
    final idToken = await _secureStorage.read(key: 'fan_id_token');
    if (idToken == null) return false;

    try {
      // Check if token is expired or expires soon
      if (JwtDecoder.isExpired(idToken)) {
        return await refreshFanTokens();
      }
      
      // Check if token expires within threshold
      final expirationDate = JwtDecoder.getExpirationDate(idToken);
      final now = DateTime.now();
      final threshold = Duration(minutes: AppConstants.tokenRefreshThresholdMinutes);
      
      if (expirationDate.difference(now) < threshold) {
        return await refreshFanTokens();
      }
      
      return true;
    } catch (e) {
      return await refreshFanTokens();
    }
  }

  /// Legacy VeriPayda OIDC support (for backward compatibility)
  Future<User?> signInWithVeriPaydaOIDC() async {
    try {
      // Redirect to new FAN authentication
      return await signInWithFaydaFAN();
    } catch (e) {
      throw Exception('Authentication failed: $e');
    }
  }

  Future<String> _createFirebaseCustomToken(String idToken) async {
    try {
      final response = await _dio.post(
        '${AppConstants.baseUrl}/auth/firebase-token',
        data: {'id_token': idToken},
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
          },
        ),
      );
      
      return response.data['custom_token'];
    } catch (e) {
      // Fallback: create a mock token for development
      final payload = {
        'iss': 'fayda-wallet',
        'sub': 'user_${Random().nextInt(999999)}',
        'aud': 'digital-fayda-wallet',
        'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
        'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      };
      
      // In production, this should be properly signed by your backend
      return base64Encode(utf8.encode(jsonEncode(payload)));
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        throw Exception('Biometric authentication not available');
      }

      final List<BiometricType> availableBiometrics = 
          await _localAuth.getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        throw Exception('No biometric methods configured');
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

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _secureStorage.deleteAll();
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<bool> isBiometricEnabled() async {
    final value = await _secureStorage.read(key: 'biometric_enabled');
    return value == 'true';
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(
      key: 'biometric_enabled', 
      value: enabled.toString(),
    );
  }

  /// Generate secure QR data for Fayda ID verification
  Future<Map<String, dynamic>> generateFaydaQRData() async {
    final userInfo = await getFaydaUserInfo();
    if (userInfo == null) throw Exception('No Fayda user information available');

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final expiryTime = DateTime.now().add(Duration(minutes: AppConstants.qrCodeExpiryMinutes)).millisecondsSinceEpoch;
    
    final qrData = {
      'version': '1.0',
      'issuer': 'FAN',
      'type': 'fayda_id_verification',
      'subject': userInfo['sub'],
      'fayda_id': userInfo['fayda_id'],
      'name': userInfo['name'],
      'verified': userInfo['verified'],
      'timestamp': timestamp,
      'expires': expiryTime,
      'nonce': Random().nextInt(999999999).toString(),
    };

    return qrData;
  }
}