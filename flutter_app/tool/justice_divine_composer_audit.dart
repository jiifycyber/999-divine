import "package:justice_divine/services/divine_genesis/ancient_ritual_composer.dart";
void main() {
  for (final civilization in ["egypt", "china"]) {
    for (final pathway in ["prosperity", "love", "protection", "lunar", "dreams", "ancestors"]) {
      for (final frequency in ["daily", "weekly", "monthly"]) {
        try {
          final steps = AncientRitualComposer.compose(civilization: civilization, pathway: pathway, date: DateTime.now(), frequency: frequency);
          print("PASS $civilization $pathway $frequency: ${steps.length} steps");
        } catch (e) {
          print("FAIL $civilization $pathway $frequency: $e");
        }
      }
    }
  }
}
