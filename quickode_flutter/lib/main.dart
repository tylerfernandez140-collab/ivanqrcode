import 'package:flutter/material.dart';
import 'screens/scanner_screen.dart';
import 'screens/history_screen.dart';
import 'screens/generator_screen.dart';
import 'screens/my_qr_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const QuickodeApp());
}

class QuickodeApp extends StatelessWidget {
  const QuickodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quickode',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      routes: {
        '/': (_) => const ScanPage(),
        '/history': (_) => const HistoryScreen(),
        '/generator': (_) => const GeneratorScreen(),
        '/myqr': (_) => const MyQRScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
