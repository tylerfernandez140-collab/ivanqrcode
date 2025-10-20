import 'package:flutter/material.dart';

class QRScannerView extends StatelessWidget {
  const QRScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'QR scanning is only supported on mobile devices.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}