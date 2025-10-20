import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';


class QRScannerView extends StatefulWidget {
  const QRScannerView({super.key});

  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  MobileScannerController? controller;

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      onDetect: (BarcodeCapture barcodeCapture) {
        // Handle the detected barcode here.
        // For now, we'll just print it.
        // print(barcodeCapture.barcodes.first.rawValue);
      },
      controller: controller,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}