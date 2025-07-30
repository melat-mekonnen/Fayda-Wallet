import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:digital_fayda_wallet/core/theme/app_theme.dart';

class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fayda ID Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.credit_card,
                          color: AppTheme.primaryColor,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Fayda ID',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Name', 'John Doe'),
                    _buildInfoRow('ID Number', '****-****-1234'),
                    _buildInfoRow('Status', 'Active'),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _showQRDialog(context),
                        icon: const Icon(Icons.qr_code),
                        label: const Text('Generate QR Code'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Additional IDs
            Text(
              'Additional IDs',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.drive_eta,
                  color: AppTheme.primaryColor,
                ),
                title: const Text('Driver\'s License'),
                subtitle: const Text('Add your driver\'s license'),
                trailing: const Icon(Icons.add),
                onTap: () {
                  // TODO: Implement add driver's license
                },
              ),
            ),
            
            const SizedBox(height: 8),
            
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.local_hospital,
                  color: AppTheme.primaryColor,
                ),
                title: const Text('Health ID'),
                subtitle: const Text('Add your health identification'),
                trailing: const Icon(Icons.add),
                onTap: () {
                  // TODO: Implement add health ID
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQRDialog(BuildContext context) {
    final qrData = {
      'id': 'fayda_123456789',
      'type': 'fayda_id',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expires': DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch,
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: qrData.toString(),
              size: 200.0,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 16),
            const Text(
              'This QR code expires in 5 minutes',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}