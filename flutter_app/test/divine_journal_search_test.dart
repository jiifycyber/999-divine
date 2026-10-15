import "package:flutter_test/flutter_test.dart";
import "package:justice_divine/services/divine_journal_search.dart";

void main() {
  test("empty search matches entries", () {
    expect(DivineJournalSearch.matches({"title": "Morning"}, "  "), isTrue);
  });

  test("search finds dream symbols", () {
    expect(
      DivineJournalSearch.matches({
        "dreamSymbols": "Moon, River, Stars",
      }, "river"),
      isTrue,
    );
  });

  test("search finds gratitude reflections", () {
    expect(
      DivineJournalSearch.matches({
        "gratitudeBlessings": "My family",
        "gratitudeMeaning": "Love and support",
      }, "support"),
      isTrue,
    );
  });

  test("search finds manifestation goals and milestones", () {
    expect(
      DivineJournalSearch.matches({
        "manifestationIntention": "Build my business",
        "manifestationMilestone": "Open the office",
      }, "office"),
      isTrue,
    );
  });

  test("search ignores capitalization", () {
    expect(
      DivineJournalSearch.matches({"title": "Divine Awakening"}, "DIVINE"),
      isTrue,
    );
  });

  test("multiple terms can match across fields", () {
    expect(
      DivineJournalSearch.matches({
        "title": "Moon Dream",
        "dreamSymbols": "Golden Door",
      }, "moon golden"),
      isTrue,
    );
  });

  test("unmatched terms reject entry", () {
    expect(
      DivineJournalSearch.matches({"title": "Moon Dream"}, "moon ocean"),
      isFalse,
    );
  });

  test("search does not match unrelated metadata", () {
    expect(
      DivineJournalSearch.matches({
        "id": "secret-token",
        "body": "Reflection",
      }, "secret-token"),
      isFalse,
    );
  });
}
