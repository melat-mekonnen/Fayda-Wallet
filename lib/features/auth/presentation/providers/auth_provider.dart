import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_fayda_wallet/features/auth/data/repositories/auth_repository.dart';
import 'package:digital_fayda_wallet/features/auth/domain/entities/user_entity.dart';

class AuthState {
  final UserEntity? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserEntity? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState()) {
    _initializeAuth();
  }

  void _initializeAuth() {
    final currentUser = _authRepository.getCurrentUser();
    if (currentUser != null) {
      state = state.copyWith(
        user: UserEntity(
          id: currentUser.uid,
          email: currentUser.email ?? '',
          name: currentUser.displayName ?? '',
        ),
        isAuthenticated: true,
      );
    }
  }

  /// Enhanced FAN OIDC Authentication
  Future<void> signInWithFaydaFAN() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await _authRepository.signInWithFaydaFAN();
      if (user != null) {
        // Get additional Fayda user info
        final faydaUserInfo = await _authRepository.getFaydaUserInfo();
        
        state = state.copyWith(
          user: UserEntity(
            id: user.uid,
            email: user.email ?? faydaUserInfo?['email'] ?? '',
            name: user.displayName ?? faydaUserInfo?['name'] ?? '',
            faydaId: faydaUserInfo?['fayda_id'],
            isVerified: faydaUserInfo?['verified'] ?? false,
          ),
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'FAN authentication failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Legacy method - redirects to FAN
  Future<void> signInWithVeriPaydaOIDC() async {
    await signInWithFaydaFAN();
  }

  Future<void> signInWithBiometrics() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final isAuthenticated = await _authRepository.authenticateWithBiometrics();
      if (isAuthenticated) {
        // Check if we have valid tokens
        final hasValidTokens = await _authRepository.ensureValidTokens();
        if (hasValidTokens) {
          final faydaUserInfo = await _authRepository.getFaydaUserInfo();
          if (faydaUserInfo != null) {
            state = state.copyWith(
              user: UserEntity(
                id: faydaUserInfo['sub'] ?? '',
                email: faydaUserInfo['email'] ?? '',
                name: faydaUserInfo['name'] ?? '',
                faydaId: faydaUserInfo['fayda_id'],
                isVerified: faydaUserInfo['verified'] ?? false,
              ),
              isAuthenticated: true,
              isLoading: false,
            );
          } else {
            state = state.copyWith(
              isLoading: false,
              error: 'Please authenticate with FAN first',
            );
          }
        } else {
          state = state.copyWith(
            isLoading: false,
            error: 'Session expired. Please sign in again.',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Biometric authentication failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _authRepository.signOut();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshTokens() async {
    try {
      await _authRepository.ensureValidTokens();
    } catch (e) {
      // If token refresh fails, sign out
      await signOut();
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});