import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  late AnimationController _animationController;
  late Animation<double> _animation;

  bool isFlashOn = false;
  bool isFrontCamera = false;
  double zoomLevel = 1.0;

  // Settings variables
  bool _beep = true;
  bool _vibrate = true;
  bool _autoOpen = false;
  bool _copyClip = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    controller.start();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Adjust duration as needed
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  Future<void> _loadSettings() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _beep = p.getBool('beep') ?? true;
      _vibrate = p.getBool('vibrate') ?? true;
      _autoOpen = p.getBool('auto_open') ?? false;
      _copyClip = p.getBool('copy_clip') ?? true;
    });
  }

  MobileScannerController controller = MobileScannerController();

  Future<void> saveHistory(String code) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history') ?? [];
    if (!history.contains(code)) {
      history.add(code);
      await prefs.setStringList('history', history);
    }
  }

  Future<void> _showScanResult(String data) async {
    if (_autoOpen && await canLaunchUrl(Uri.parse(data))) {
      await launchUrl(Uri.parse(data));
      await controller.start();
      return;
    }

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("QR Result"),
        content: Text(data),
        actions: [
          TextButton(
            onPressed: () async {
              await controller.start();
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: const Text("Scan Again"),
          ),
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: data));
              if (!mounted) return;
              Navigator.pop(context);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Copied to clipboard")),
              );
            },
            child: const Text("Copy"),
          ),
          TextButton(
            onPressed: () async {
              if (await canLaunchUrl(Uri.parse(data))) {
                await launchUrl(Uri.parse(data));
              }
              if (!mounted) return;
              Navigator.pop(context); // Dismiss dialog after opening URL
            },
            child: const Text("Open"),
          ),
        ],
      ),
    ).then((value) => controller.start()); // Resume camera when dialog is dismissed
  }

  Future<void> _scanFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      try {
        final result = await QrCodeToolsPlugin.decodeFrom(picked.path);
        if (result != null) {
          _showScanResult(result);
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No QR code found in image')),
        );
      }
    }
  }

  void _onDetect(BarcodeCapture barcodeCapture) async {
    final barcode = barcodeCapture.barcodes.first;
    if (barcode.rawValue == null) return;
    if (_beep) {
      FlutterRingtonePlayer().playNotification();
    }
    if (_vibrate && (await Vibration.hasVibrator())) {
      Vibration.vibrate(duration: 200);
    }
    if (_copyClip) {
      Clipboard.setData(ClipboardData(text: barcode.rawValue!));
    }
    saveHistory(barcode.rawValue!);
    _showScanResult(barcode.rawValue!);
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔹 App Logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/logo.png', // make sure you have this in assets folder
                      height: 48,
                      width: 48,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 🔹 App name and developer credit
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Quickode',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Developed by Ivan Creates',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text("Scan"),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)?.settings.name != '/') {
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_search),
              title: const Text("Scan Image"),
              onTap: () {
                Navigator.pop(context);
                _scanFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("History"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/history');
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_2),
              title: const Text("My QR"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/myqr');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text("Create QR"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/generator');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Share"),
              onTap: () {
                Navigator.pop(context);
                SharePlus.instance.share(ShareParams(text: 'Check out Quickode — your smart QR scanner!'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.apps),
              title: const Text("Our Apps"),
              onTap: () async {
                Navigator.pop(context);
                final Uri url = Uri.parse('https://example.com/myapps');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text("Remove Ads"),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    title: Text('Coming Soon!'),
                    content: Text('Ad removal feature will be available soon.'),
                  ),
                );
              },
            ),          ],
        ),
      ),
      body: Stack(
        children: [
          // Camera preview (AiBarcodeScanner)
          MobileScanner(
            controller: controller,
            onDetect: (barcode) => _onDetect(barcode),
          ),

          // Dimmed background with transparent scan area
          Positioned.fill(
            child: CustomPaint(
              painter: ScannerOverlayPainter(
                cutOutSize: 250, // same as your scanner box size
              ),
            ),
          ),

          // Scanner UI (corners + green laser)
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                children: [
                  CustomPaint(
                    size: const Size(250, 250),
                    painter: ScannerCornersPainter(
                      borderColor: Colors.white.withValues(alpha: 0.9),
                      borderWidth: 4,
                      cornerLength: 25,
                      borderRadius: 16,
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Positioned(
                        top: 250 * _animation.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.redAccent,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Top menu + controls
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image, color: Colors.white),
                      onPressed: _scanFromGallery,
                    ),
                    IconButton(
                      icon: Icon(
                        isFlashOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await controller.toggleTorch();
                        setState(() => isFlashOn = !isFlashOn);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cameraswitch, color: Colors.white),
                      onPressed: () async {
                        await controller.switchCamera();
                        setState(() => isFrontCamera = !isFrontCamera);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerCornersPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final double cornerLength;
  final double borderRadius;

  ScannerCornersPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.cornerLength,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double halfStroke = borderWidth / 2;
    final rect = Rect.fromLTWH(
      halfStroke,
      halfStroke,
      size.width - borderWidth,
      size.height - borderWidth,
    );

    // Top-left corner
    canvas.drawLine(
      Offset(rect.left, rect.top + cornerLength),
      Offset(rect.left, rect.top),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.left + cornerLength, rect.top),
      paint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(rect.right - cornerLength, rect.top),
      Offset(rect.right, rect.top),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.top),
      Offset(rect.right, rect.top + cornerLength),
      paint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(rect.left, rect.bottom - cornerLength),
      Offset(rect.left, rect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.left + cornerLength, rect.bottom),
      paint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(rect.right - cornerLength, rect.bottom),
      Offset(rect.right, rect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.bottom - cornerLength),
      Offset(rect.right, rect.bottom),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScannerOverlayPainter extends CustomPainter {
  final double cutOutSize;

  ScannerOverlayPainter({required this.cutOutSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final overlayRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final cutOutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cutOutSize,
      height: cutOutSize,
    );

    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(overlayRect),
      Path()..addRRect(RRect.fromRectXY(cutOutRect, 16, 16)),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
