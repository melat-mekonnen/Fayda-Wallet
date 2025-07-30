import 'package:flutter/material.dart';
import 'package:digital_fayda_wallet/core/theme/app_theme.dart';

class QRScanPage extends StatelessWidget {
  const QRScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner,
                size: 100,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                'QR Scanner',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tap to scan a QR code for identity verification',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement QR scanning
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Start Scanning'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}