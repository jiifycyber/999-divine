import 'package:justice_divine/services/divine_genesis/divine_master_engine.dart';
void main() {
  for (final category in ["Money & Prosperity", "Protection & Cleansing"]) {
    final ritual = DivineMasterEngine.generate(DateTime.now(), civilization: "china", category: category);
    print("=== ${ritual.title} ===");
    print("MATERIALS:");
    for (final material in ritual.materials) { print("- $material"); }
    print("GUIDED STEPS:");
    for (var i = 0; i < ritual.steps.length; i++) { print("${i + 1}. ${ritual.steps[i]}"); }
  }
}
