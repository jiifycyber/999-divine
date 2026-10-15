import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:justice_divine/services/divine_genesis/divine_master_engine.dart';
import 'package:justice_divine/services/divine_genesis/divine_ritual_snapshot_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('snapshot serialization preserves every ritual field', () {
    final original = DivineMasterEngine.generate(DateTime(2026, 10, 14));
    final restored = DivineRitualSnapshotStore.decode(
      DivineRitualSnapshotStore.encode(original),
    );
    expect(restored.id, original.id);
    expect(restored.title, original.title);
    expect(restored.category, original.category);
    expect(restored.purpose, original.purpose);
    expect(restored.frequency, original.frequency);
    expect(restored.affirmation, original.affirmation);
    expect(restored.materials, original.materials);
    expect(restored.steps, original.steps);
    expect(restored.reflection, original.reflection);
    expect(restored.durationMinutes, original.durationMinutes);
  });

  for (final civilization in ['egypt', 'china']) {
    test(
      'saved $civilization ceremony retains original instructions',
      () async {
        final original = DivineMasterEngine.generate(
          DateTime(2026, 10, 14),
          civilization: civilization,
        );
        await DivineRitualSnapshotStore.save([original]);
        final restored = await DivineRitualSnapshotStore.load();
        expect(restored, hasLength(1));
        expect(restored.single.id, original.id);
        expect(restored.single.steps, original.steps);
        expect(restored.single.materials, original.materials);
      },
    );
  }

  test('empty snapshot storage returns an empty list', () async {
    expect(await DivineRitualSnapshotStore.load(), isEmpty);
  });
}
