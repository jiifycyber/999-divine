import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DivineEventStore {
  static const key = 'justice_divine_calendar_events_v1';
  static Future<List<Map<String, dynamic>>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(List<Map<String, dynamic>> events) async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setString(key, jsonEncode(events));
    if (!ok) throw StateError('Calendar events could not be saved');
  }
}
