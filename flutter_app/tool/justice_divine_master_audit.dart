import 'package:justice_divine/services/divine_genesis/divine_master_engine.dart';

void main() {
  const categories = [
    "Money & Prosperity",
    "Love & Relationships",
    "Protection & Cleansing",
    "Moon & Manifestation",
    "Dreams & Intuition",
    "Ancestors & Remembrance",
  ];
  var passed = 0;
  var failed = 0;
  for (final civilization in ["egypt", "china"]) {
    for (final frequency in ["daily", "weekly", "monthly"]) {
      for (final category in categories) {
        try {
          final ritual = DivineMasterEngine.generate(
            DateTime.now(),
            civilization: civilization,
            frequency: frequency,
            category: category,
          );
          final steps = ritual.steps;
          final prep = steps.where((s) => s.startsWith("PREPARATION:")).length;
          final invocation = steps
              .where((s) => s.startsWith("SPOKEN INVOCATION"))
              .length;
          final closing = steps
              .where((s) => s.startsWith("CEREMONIAL CLOSING:"))
              .length;
          final weekly = steps
              .where((s) => s.startsWith("WEEKLY OBSERVANCE:"))
              .length;
          final monthly = steps
              .where((s) => s.startsWith("MONTHLY OBSERVANCE:"))
              .length;
          final valid =
              prep == 1 &&
              invocation == 1 &&
              closing == 1 &&
              weekly == (frequency == "weekly" ? 1 : 0) &&
              monthly == (frequency == "monthly" ? 1 : 0) &&
              steps.last.startsWith("CEREMONIAL CLOSING:");
          if (valid) {
            passed++;
            print("PASS $civilization $frequency $category");
          } else {
            failed++;
            print(
              "FAIL $civilization $frequency $category prep=$prep invocation=$invocation closing=$closing weekly=$weekly monthly=$monthly",
            );
          }
        } catch (e) {
          failed++;
          print("ERROR $civilization $frequency $category: $e");
        }
      }
    }
  }
  print("AUDIT COMPLETE: $passed PASSED, $failed FAILED");
  if (failed > 0) throw StateError("Master engine audit failed");
}
