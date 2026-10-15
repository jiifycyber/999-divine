import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justice_divine/services/divine_genesis/divine_master_engine.dart';

void main() {
  for (final civilization in ['egypt', 'china']) {
    test('both engines selected for $civilization', () {
      var composer = 0;
      var ceremonial = 0;
      for (var i = 0; i < 100; i++) {
        final ritual = DivineMasterEngine.generate(
          DateTime(2026, 10, 14),
          civilization: civilization,
          category: 'Protection & Cleansing',
        );
        if (ritual.id.contains('_composer_')) {
          composer++;
        } else {
          ceremonial++;
        }
      }
      debugPrint(
        'RANDOM ENGINE AUDIT $civilization: composer=$composer ceremonial=$ceremonial',
      );
      expect(composer, greaterThan(0));
      expect(ceremonial, greaterThan(0));
    });
  }
}
