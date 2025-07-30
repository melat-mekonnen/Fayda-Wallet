import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_fayda_wallet/core/theme/app_theme.dart';
import 'package:digital_fayda_wallet/core/routing/app_router.dart';
import 'package:digital_fayda_wallet/features/auth/presentation/providers/auth_provider.dart';

class DigitalFaydaWalletApp extends ConsumerWidget {
  const DigitalFaydaWalletApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return MaterialApp.router(
      title: 'Digital Fayda Wallet',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}