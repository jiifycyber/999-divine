import 'package:flutter_test/flutter_test.dart';

import 'package:justice_divine/services/divine_genesis/divine_master_engine.dart';

void main() {
  final date = DateTime(2026, 10, 14);
  const categories = <String>[
    'Money & Prosperity',
    'Love & Relationships',
    'Protection & Cleansing',
    'Moon & Manifestation',
    'Dreams & Intuition',
    'Ancestors & Remembrance',
  ];
  for (final civilization in ['egypt', 'china']) {
    for (final category in categories) {
      test('$civilization / $category', () {
        final ritual = DivineMasterEngine.generate(
          date,
          category: category,
          civilization: civilization,
        );
        expect(ritual.steps, isNotEmpty);
        expect(ritual.category, category);
        expect(
          ritual.title,
          startsWith(
            civilization == 'egypt' ? 'Ancient Egyptian' : 'Ancient Chinese',
          ),
        );
        expect(ritual.steps.first, contains('HISTORICAL BACKGROUND'));
        expect(ritual.steps.first, contains('RESEARCH SOURCES'));
      });
    }
  }
  test('unsupported civilization rejected', () {
    expect(
      () => DivineMasterEngine.generate(date, civilization: 'unknown'),
      throwsArgumentError,
    );
  });
  test('civilizations generate distinct ceremonies', () {
    final egypt = DivineMasterEngine.generate(
      date,
      category: 'Protection & Cleansing',
      civilization: 'egypt',
    );
    final china = DivineMasterEngine.generate(
      date,
      category: 'Protection & Cleansing',
      civilization: 'china',
    );
    expect(egypt.steps, isNot(equals(china.steps)));
  });
}
