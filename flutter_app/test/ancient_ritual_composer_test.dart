import 'package:flutter_test/flutter_test.dart';
import 'package:justice_divine/services/divine_genesis/ancient_ritual_composer.dart';

void main() {
  final date = DateTime(2026, 10, 14);
  for (final civilization in ['egypt', 'china']) {
    for (final frequency in ['daily', 'weekly', 'monthly']) {
      test('composer $civilization / $frequency', () {
        final steps = AncientRitualComposer.compose(
          civilization: civilization,
          pathway: 'protection',
          date: date,
          frequency: frequency,
        );
        final output = steps.join(' | ');
        expect(output, contains('2026-10-14'));
        expect(output, contains('HISTORICAL FOUNDATION:'));
        expect(output, contains('SOURCE:'));
        expect(output, contains('Modern guided adaptation'));
        expect(output.contains('WEEKLY REFLECTION:'), frequency == 'weekly');
        expect(output.contains('MONTHLY REFLECTION:'), frequency == 'monthly');
      });
    }
  }
  test('civilizations produce different protection ceremonies', () {
    final egypt = AncientRitualComposer.compose(
      civilization: 'egypt',
      pathway: 'protection',
      date: date,
    );
    final china = AncientRitualComposer.compose(
      civilization: 'china',
      pathway: 'protection',
      date: date,
    );
    expect(egypt, isNot(equals(china)));
  });
  test('unknown pathway is rejected', () {
    expect(
      () => AncientRitualComposer.compose(
        civilization: 'egypt',
        pathway: 'unknown',
        date: date,
      ),
      throwsArgumentError,
    );
  });
}
