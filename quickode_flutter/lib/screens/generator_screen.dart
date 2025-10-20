import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final TextEditingController _ctrl = TextEditingController(text: 'https://quickode.netlify.app');
  String data = '';
  final GlobalKey _qrKey = GlobalKey();

  Future<void> _shareQrCode() async {
    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generate QR code first!')),
      );
      return;
    }
    await SharePlus.instance.share(ShareParams(text: data, subject: 'My QR Code'));
  }

  Future<void> _saveQrCode() async {
    if (data.isEmpty) {
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

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Generator')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          TextField(controller: _ctrl, decoration: const InputDecoration(labelText: 'Text or URL')),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () => setState(() => data = _ctrl.text.trim()), child: const Text('Generate')),
          const SizedBox(height: 12),
          if (data.isNotEmpty)
            RepaintBoundary(
              key: _qrKey,
              child: Center(child: QrImageView(data: data, size: 240, backgroundColor: Colors.white, version: QrVersions.auto)),
            ),
          const SizedBox(height: 12),
          if (data.isNotEmpty)
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(onPressed: () async {
                await Clipboard.setData(ClipboardData(text: data));
                _showSnackBar('Copied');
              }, child: const Text('Copy')),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: _shareQrCode, child: const Text('Share QR')),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: _saveQrCode, child: const Text('Export QR')),
            ]),
        ]),
      ),
    );
  }
}
