import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_fayda_wallet/core/theme/app_theme.dart';
import 'package:digital_fayda_wallet/features/auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primaryColor,
                      child: Text(
                        authState.user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      authState.user?.displayName ?? 'User Name',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      authState.user?.email ?? 'user@example.com',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Profile Information
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person, color: AppTheme.primaryColor),
                    title: const Text('Personal Information'),
                    subtitle: const Text('Update your personal details'),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      // TODO: Navigate to edit profile
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.phone, color: AppTheme.primaryColor),
                    title: const Text('Phone Number'),
                    subtitle: const Text('+251 912 345 678'),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      // TODO: Edit phone number
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.location_on, color: AppTheme.primaryColor),
                    title: const Text('Address'),
                    subtitle: const Text('Addis Ababa, Ethiopia'),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      // TODO: Edit address
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Account Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Status',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text('Verified Account'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text('Biometric Authentication Enabled'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}