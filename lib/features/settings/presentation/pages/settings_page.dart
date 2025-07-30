import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:digital_fayda_wallet/core/utils/app_constants.dart';
import 'package:digital_fayda_wallet/core/theme/app_theme.dart';
import 'package:digital_fayda_wallet/features/auth/presentation/providers/auth_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.security, color: AppTheme.primaryColor),
            title: const Text('Security'),
            subtitle: const Text('Manage biometric and PIN settings'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to security settings
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: AppTheme.primaryColor),
            title: const Text('Notifications'),
            subtitle: const Text('Configure app notifications'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to notification settings
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: AppTheme.primaryColor),
            title: const Text('Privacy'),
            subtitle: const Text('Data usage and privacy settings'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to privacy settings
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: AppTheme.primaryColor),
            title: const Text('Help & Support'),
            subtitle: const Text('Get help and contact support'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to help
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: AppTheme.primaryColor),
            title: const Text('About'),
            subtitle: const Text('App version and information'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to about
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            subtitle: const Text('Sign out of your account'),
            onTap: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).signOut();
              context.go(AppConstants.loginRoute);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}