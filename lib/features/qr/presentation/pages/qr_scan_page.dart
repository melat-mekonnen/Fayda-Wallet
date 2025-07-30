import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:digital_fayda_wallet/core/theme/app_theme.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  bool _isScanning = false;
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: _isScanning ? _buildScanner() : _buildScannerPrompt(),
    );
  }

  Widget _buildScannerPrompt() {
    return Center(
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
                setState(() {
                  _isScanning = true;
                });
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Start Scanning'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanner() {
    return Stack(
      children: [
        MobileScanner(
          controller: cameraController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              _handleScannedCode(barcode.rawValue ?? '');
              break;
            }
          },
        ),
        Positioned(
          bottom: 32,
          left: 32,
          right: 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: "flash",
                onPressed: () => cameraController.toggleTorch(),
                backgroundColor: Colors.black54,
                child: const Icon(Icons.flash_on, color: Colors.white),
              ),
              FloatingActionButton(
                heroTag: "camera",
                onPressed: () => cameraController.switchCamera(),
                backgroundColor: Colors.black54,
                child: const Icon(Icons.camera_rear, color: Colors.white),
              ),
              FloatingActionButton(
                heroTag: "close",
                onPressed: () {
                  setState(() {
                    _isScanning = false;
                  });
                },
                backgroundColor: Colors.red,
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleScannedCode(String code) {
    setState(() {
      _isScanning = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Scanned'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scanned QR Code:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                code,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Verification Status: ✅ Valid Fayda ID',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Process verification
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}