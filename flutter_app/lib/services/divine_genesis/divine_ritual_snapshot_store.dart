import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../divine_ritual_engine.dart';

class DivineRitualSnapshotStore {
  static const key = 'justice_divine_ritual_snapshots_v1';

  static Map<String, dynamic> encode(DivineRitual ritual) => {
    'id': ritual.id,
    'title': ritual.title,
    'category': ritual.category,
    'purpose': ritual.purpose,
    'frequency': ritual.frequency,
    'affirmation': ritual.affirmation,
    'materials': List<String>.of(ritual.materials),
    'steps': List<String>.of(ritual.steps),
    'reflection': ritual.reflection,
    'durationMinutes': ritual.durationMinutes,
  };

  static DivineRitual decode(Map<String, dynamic> data) => DivineRitual(
    id: data['id'] as String,
    title: data['title'] as String,
    category: data['category'] as String,
    purpose: data['purpose'] as String,
    frequency: data['frequency'] as String,
    affirmation: data['affirmation'] as String,
    materials: List<String>.from(data['materials'] as List),
    steps: List<String>.from(data['steps'] as List),
    reflection: data['reflection'] as String,
    durationMinutes: data['durationMinutes'] as int,
  );

  static Future<List<DivineRitual>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((e) => decode(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  static Future<void> save(List<DivineRitual> rituals) async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setString(
      key,
      jsonEncode(rituals.map(encode).toList()),
    );
    if (!ok) throw StateError('Ritual snapshots could not be saved');
  }
}
