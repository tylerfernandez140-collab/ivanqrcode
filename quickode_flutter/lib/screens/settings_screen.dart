import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quickode_scanner/screens/privacy_policy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool beep = true;
  bool vibrate = true;
  bool autoOpen = false;
  bool copyClip = true;
  bool batchMode = false;
  bool keepDuplicates = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      beep = p.getBool('beep') ?? true;
      vibrate = p.getBool('vibrate') ?? true;
      autoOpen = p.getBool('auto_open') ?? false;
      copyClip = p.getBool('copy_clip') ?? true;
      batchMode = p.getBool('batch_mode') ?? false;
      keepDuplicates = p.getBool('keep_duplicates') ?? false;
    });
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('beep', beep);
    await p.setBool('vibrate', vibrate);
    await p.setBool('auto_open', autoOpen);
    await p.setBool('copy_clip', copyClip);
    await p.setBool('batch_mode', batchMode);
    await p.setBool('keep_duplicates', keepDuplicates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(children: [
        SwitchListTile(title: const Text('Beep on scan'), value: beep, onChanged: (v) => setState(() { beep = v; _save(); })),
        SwitchListTile(title: const Text('Vibrate on scan'), value: vibrate, onChanged: (v) => setState(() { vibrate = v; _save(); })),
        SwitchListTile(title: const Text('Copy result to clipboard'), value: copyClip, onChanged: (v) => setState(() { copyClip = v; _save(); })),
        SwitchListTile(title: const Text('Automatically open URLs'), value: autoOpen, onChanged: (v) => setState(() { autoOpen = v; _save(); })),
        SwitchListTile(title: const Text('Batch scan mode'), value: batchMode, onChanged: (v) => setState(() { batchMode = v; _save(); })),
        SwitchListTile(title: const Text('Keep duplicates'), value: keepDuplicates, onChanged: (v) => setState(() { keepDuplicates = v; _save(); })),
        ListTile(
          title: const Text('Privacy Policy'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
            );
          },
        ),
      ]),
    );
  }
}
