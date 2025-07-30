import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digital_fayda_wallet/features/auth/data/repositories/auth_repository.dart';
import 'package:digital_fayda_wallet/features/auth/domain/entities/user_entity.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState.initial()) {
    _checkAuthState();
  }

  void _checkAuthState() {
    final user = _authRepository.getCurrentUser();
    if (user != null) {
      state = AuthState.authenticated(UserEntity.fromFirebaseUser(user));
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> signInWithVeriPaydaOIDC() async {
    state = const AuthState.loading();
    
    try {
      final user = await _authRepository.signInWithVeriPaydaOIDC();
      if (user != null) {
        state = AuthState.authenticated(UserEntity.fromFirebaseUser(user));
      } else {
        state = const AuthState.error('Authentication failed');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signInWithBiometrics() async {
    state = const AuthState.loading();
    
    try {
      final success = await _authRepository.authenticateWithBiometrics();
      if (success) {
        final user = _authRepository.getCurrentUser();
        if (user != null) {
          state = AuthState.authenticated(UserEntity.fromFirebaseUser(user));
        }
      } else {
        state = const AuthState.error('Biometric authentication failed');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = const AuthState.unauthenticated();
  }
}

class AuthState {
  final bool isLoading;
  final UserEntity? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  const AuthState.initial() : this();
  const AuthState.loading() : this(isLoading: true);
  const AuthState.authenticated(UserEntity user) : this(user: user);
  const AuthState.unauthenticated() : this();
  const AuthState.error(String error) : this(error: error);

  bool get isAuthenticated => user != null;
}