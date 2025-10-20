import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateQRScreen extends StatefulWidget {
  const CreateQRScreen({super.key});

  @override
  State<CreateQRScreen> createState() => _CreateQRScreenState();
}

class _CreateQRScreenState extends State<CreateQRScreen> {
  final TextEditingController _textController = TextEditingController();
  String _qrData = '';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _generateQrCode() {
    setState(() {
      _qrData = _textController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter data for QR code',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _qrData = '';
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateQrCode,
              child: const Text('Generate QR Code'),
            ),
            const SizedBox(height: 20),
            if (_qrData.isNotEmpty)
              QrImageView(
                data: _qrData,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}