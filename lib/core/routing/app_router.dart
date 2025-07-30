import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:digital_fayda_wallet/core/utils/app_constants.dart';
import 'package:digital_fayda_wallet/features/splash/presentation/pages/splash_page.dart';
import 'package:digital_fayda_wallet/features/auth/presentation/pages/login_page.dart';
import 'package:digital_fayda_wallet/features/home/presentation/pages/home_page.dart';
import 'package:digital_fayda_wallet/features/wallet/presentation/pages/wallet_page.dart';
import 'package:digital_fayda_wallet/features/settings/presentation/pages/settings_page.dart';
import 'package:digital_fayda_wallet/features/qr/presentation/pages/qr_scan_page.dart';
import 'package:digital_fayda_wallet/features/profile/presentation/pages/profile_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppConstants.splashRoute,
    routes: [
      GoRoute(
        path: AppConstants.splashRoute,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppConstants.homeRoute,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppConstants.walletRoute,
        name: 'wallet',
        builder: (context, state) => const WalletPage(),
      ),
      GoRoute(
        path: AppConstants.settingsRoute,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppConstants.qrScanRoute,
        name: 'qr-scan',
        builder: (context, state) => const QRScanPage(),
      ),
      GoRoute(
        path: AppConstants.profileRoute,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}