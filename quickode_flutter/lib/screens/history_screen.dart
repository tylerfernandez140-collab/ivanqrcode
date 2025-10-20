import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<List<String>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('history') ?? [];
  }

  Future<void> _load() async {
    items = await loadHistory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final e = items[i];
            return ListTile(
              leading: const Icon(Icons.qr_code),
              title: Text(e),
              onTap: () {},
              trailing: IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  SharePlus.instance.share(ShareParams(text: e));
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.delete),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setStringList('history', []);
          await _load();
        },
      ),
    );
  }
}
