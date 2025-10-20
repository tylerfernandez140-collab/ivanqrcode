import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:flutter/services.dart';

class MyQRScreen extends StatefulWidget {
  const MyQRScreen({super.key});

  @override
  State<MyQRScreen> createState() => _MyQRScreenState();
}

class _MyQRScreenState extends State<MyQRScreen> {
  final _name = TextEditingController();
  final _org = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  String vcard = '';
  final GlobalKey _qrKey = GlobalKey();

  void _buildVCard() {
    final name = _name.text.trim();
    final org = _org.text.trim();
    final phone = _phone.text.trim();
    final mail = _email.text.trim();
    final addr = _address.text.trim();
    vcard = '''
BEGIN:VCARD
VERSION:3.0
FN:$name
ORG:$org
TEL:$phone
EMAIL:$mail
ADR:;;$addr
END:VCARD
''';
    setState(() {});
  }

  Future<void> _shareQrCode() async {
    if (vcard.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generate QR code first!')),
      );
      return;
    }
    await SharePlus.instance.share(ShareParams(text: vcard, subject: 'My vCard QR Code'));
  }

  Future<void> _saveQrCode() async {
    if (vcard.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generate QR code first!')),
      );
      return;
    }
    try {
      RenderRepaintBoundary boundary = _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = (await getApplicationDocumentsDirectory()).path;
      File imgFile = File('$directory/qrcode.png');
      await imgFile.writeAsBytes(pngBytes);

      final result = await GallerySaver.saveImage(imgFile.path);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR Code saved to gallery: $result')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save QR Code: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My QR (Contact)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Full name')),
          TextField(controller: _org, decoration: const InputDecoration(labelText: 'Organization')),
          TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone')),
          TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: _address, decoration: const InputDecoration(labelText: 'Address')),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: _buildVCard, child: const Text('Create QR')),
          const SizedBox(height: 12),
          if (vcard.isNotEmpty)
            RepaintBoundary(
              key: _qrKey,
              child: QrImageView(data: vcard, size: 240, backgroundColor: Colors.white, version: QrVersions.auto),
            ),
          if (vcard.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _shareQrCode, child: const Text('Share QR')),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _saveQrCode, child: const Text('Export QR')),
              ],
            ),
        ]),
      ),
    );
  }
}
