import "dart:convert";

import "package:shared_preferences/shared_preferences.dart";

class DivineJournalStore {
  static const String key = "justice_divine_journal_entries_v1";
  static const List<String> categories = [
    "New Entry",
    "My 23rd Birthday",
    "Dreams",
    "Gratitude",
    "Manifestation Progress",
  ];

  static Future<List<Map<String, dynamic>>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) throw const FormatException("Invalid journal data");
    return decoded
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  static Future<void> save(List<Map<String, dynamic>> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.setString(key, jsonEncode(entries));
    if (!result) throw StateError("Could not save journal entries");
  }

  static Future<void> upsert(Map<String, dynamic> entry) async {
    final id = entry["id"];
    if (id is! String || id.isEmpty) throw ArgumentError("Entry ID required");
    final entries = await load();
    final index = entries.indexWhere((item) => item["id"] == id);
    if (index >= 0) {
      entries[index] = entry;
    } else {
      entries.insert(0, entry);
    }
    await save(entries);
  }

  static Future<void> delete(String id) async {
    final entries = await load();
    entries.removeWhere((entry) => entry["id"] == id);
    await save(entries);
  }
}
