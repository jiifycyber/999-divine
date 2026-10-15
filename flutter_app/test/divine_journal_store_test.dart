import "package:flutter_test/flutter_test.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:justice_divine/services/divine_journal_store.dart";

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test("empty journal loads safely", () async {
    expect(await DivineJournalStore.load(), isEmpty);
  });

  test("journal saves and reloads entries", () async {
    await DivineJournalStore.upsert({
      "id": "one",
      "category": "New Entry",
      "title": "Reflection",
      "body": "Today was meaningful",
    });
    final entries = await DivineJournalStore.load();
    expect(entries.length, 1);
    expect(entries.first["body"], "Today was meaningful");
  });

  test("upsert preserves entry identity and advanced fields", () async {
    await DivineJournalStore.upsert({
      "id": "dream1",
      "category": "Dreams",
      "body": "Flying",
      "dreamLucid": true,
      "dreamSymbols": "birds, sky",
      "favorite": true,
    });
    final updated = Map<String, dynamic>.from(
      (await DivineJournalStore.load()).first,
    );
    updated["body"] = "Flying over water";
    await DivineJournalStore.upsert(updated);
    final entries = await DivineJournalStore.load();
    expect(entries.length, 1);
    expect(entries.first["id"], "dream1");
    expect(entries.first["dreamLucid"], true);
    expect(entries.first["dreamSymbols"], "birds, sky");
    expect(entries.first["favorite"], true);
  });

  test("gratitude and manifestation fields survive storage", () async {
    await DivineJournalStore.upsert({
      "id": "g1",
      "category": "Gratitude",
      "gratitudeBlessings": "Family",
      "gratitudeMeaning": "Connection",
      "gratitudeAction": "Give thanks",
    });
    await DivineJournalStore.upsert({
      "id": "m1",
      "category": "Manifestation Progress",
      "manifestationIntention": "Build a business",
      "manifestationMilestone": "Launch",
      "manifestationProgress": 65,
      "manifestationStatus": "In Progress",
    });
    final entries = await DivineJournalStore.load();
    final gratitude = entries.firstWhere((e) => e["id"] == "g1");
    final manifestation = entries.firstWhere((e) => e["id"] == "m1");
    expect(gratitude["gratitudeAction"], "Give thanks");
    expect(manifestation["manifestationProgress"], 65);
    expect(manifestation["manifestationMilestone"], "Launch");
  });

  test("deleting one entry preserves other entries", () async {
    await DivineJournalStore.upsert({"id": "a", "body": "First"});
    await DivineJournalStore.upsert({"id": "b", "body": "Second"});
    await DivineJournalStore.delete("a");
    final entries = await DivineJournalStore.load();
    expect(entries.length, 1);
    expect(entries.first["id"], "b");
  });

  test("missing entry ID is rejected", () async {
    await expectLater(
      DivineJournalStore.upsert({"body": "Invalid"}),
      throwsArgumentError,
    );
  });
}
