import 'dart:io';

import 'package:justice_divine/services/divine_genesis/divine_master_engine.dart';
import 'package:justice_divine/services/divine_ritual_engine.dart';

void main() {
  final today = DateTime.now();
  final report = StringBuffer();
  report.writeln('JUSTICE DIVINE - PRE-LAUNCH RITUAL PREVIEW');
  report.writeln('Date: $today');
  var count = 0;
  for (final frequency in ['daily', 'weekly', 'monthly']) {
    report.writeln(
      '\n============================================================',
    );
    for (final category in DivineRitualEngine.categories) {
      final ritual = DivineMasterEngine.generate(
        today,
        category: category,
        frequency: frequency,
      );
      count++;
      report.writeln(
        '\n============================================================',
      );
      report.writeln('$count. ${ritual.title}');
      report.writeln('CATEGORY: ${ritual.category}');
      report.writeln('FREQUENCY: ${ritual.frequency}');
      report.writeln('DURATION: ${ritual.durationMinutes} minutes');
      report.writeln('\nPURPOSE\n${ritual.purpose}');
      report.writeln('\nMATERIALS');
      if (ritual.materials.isEmpty) report.writeln('No materials listed.');
      for (final material in ritual.materials) {
        report.writeln('- $material');
      }
      report.writeln('\nGUIDED STEPS');
      for (var i = 0; i < ritual.steps.length; i++) {
        report.writeln('${i + 1}. ${ritual.steps[i]}');
      }
      report.writeln('\nAFFIRMATION\n${ritual.affirmation}');
      report.writeln('\nREFLECTION\n${ritual.reflection}');
    }
  }
  report.writeln('\nPREVIEW COMPLETE: $count CEREMONIES');
  final output = report.toString();
  print(output);
  final file = File('build/ritual_preview.txt');
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(output);
  print('\nREPORT SAVED: ${file.path}');
}
