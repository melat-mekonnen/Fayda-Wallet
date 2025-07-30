import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:dio/dio.dart';
import 'package:digital_fayda_wallet/core/utils/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

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
        final idToken = authData['id_token'];
        final accessToken = authData['access_token'];

        // Step 2: Store tokens securely
        await _secureStorage.write(key: 'id_token', value: idToken);
        await _secureStorage.write(key: 'access_token', value: accessToken);

        // Step 3: Create custom token for Firebase Auth
        final customToken = await _createFirebaseCustomToken(idToken);
        
        // Step 4: Sign in to Firebase with custom token
        final userCredential = await _firebaseAuth.signInWithCustomToken(customToken);
        
        return userCredential.user;
      }
    } catch (e) {
      throw Exception('VeriPayda OIDC authentication failed: $e');
    }
    return null;
  }

  Future<String> _createFirebaseCustomToken(String idToken) async {
    // This would typically be done by your backend server
    // For demo purposes, we'll simulate this
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
      throw Exception('Failed to create Firebase custom token: $e');
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      // Check if biometrics are available
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        throw Exception('Biometric authentication not available');
      }

      // Get available biometric types
      final List<BiometricType> availableBiometrics = 
          await _localAuth.getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        throw Exception('No biometric methods configured');
      }

      // Authenticate with biometrics
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
}