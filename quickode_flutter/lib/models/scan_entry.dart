class ScanEntry {
  final String value;
  final String timestampIso;
  final String type;

  ScanEntry({
    required this.value,
    required this.timestampIso,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'value': value,
        'timestampIso': timestampIso,
        'type': type,
      };

  static ScanEntry fromJson(Map<String, dynamic> j) => ScanEntry(
        value: j['value'] as String,
        timestampIso: j['timestampIso'] as String,
        type: j['type'] as String,
      );
}
