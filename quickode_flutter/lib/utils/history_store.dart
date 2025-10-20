import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_entry.dart';

class HistoryStore {
  static const _key = 'quickode_scan_history';

  static Future<List<ScanEntry>> getAll() async {
    final p = await SharedPreferences.getInstance();
    final list = p.getStringList(_key) ?? <String>[];
    return list.map((e) {
      final Map<String, dynamic> m = jsonDecode(e);
      return ScanEntry.fromJson(m);
    }).toList();
  }

  static Future<void> addEntry(ScanEntry entry) async {
    final p = await SharedPreferences.getInstance();
    final list = p.getStringList(_key) ?? <String>[];
    list.insert(0, jsonEncode(entry.toJson())); // newest first
    // optionally limit history size
    if (list.length > 1000) list.removeRange(1000, list.length);
    await p.setStringList(_key, list);
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_key);
  }
}
