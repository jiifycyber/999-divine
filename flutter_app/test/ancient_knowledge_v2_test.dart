import 'package:flutter_test/flutter_test.dart';
import 'package:justice_divine/services/divine_genesis/divine_master_engine.dart';

void main() {
  final date = DateTime(2026, 10, 14);
  test('egypt / Money & Prosperity', () {
    final ritual = DivineMasterEngine.generate(
      date,
      civilization: 'egypt',
      category: 'Money & Prosperity',
    );
    expect(ritual.steps.join(' | '), contains('Hapi'));
    expect(ritual.steps.join(' | '), contains('AUTHENTICITY:'));
  });
  test('egypt / Love & Relationships', () {
    final ritual = DivineMasterEngine.generate(
      date,
      civilization: 'egypt',
      category: 'Love & Relationships',
    );
    expect(ritual.steps.join(' | '), contains('Hathor'));
    expect(ritual.steps.join(' | '), contains('AUTHENTICITY:'));
  });
  test('egypt / Protection & Cleansing', () {
    final ritual = DivineMasterEngine.generate(
      date,
      civilization: 'egypt',
      category: 'Protection & Cleansing',
    );
    expect(ritual.steps.join(' | '), contains('Isis'));
    expect(ritual.steps.join(' | '), contains('AUTHENTICITY:'));
  });
  test('egypt / Moon & Manifestation', () {
    final ritual = DivineMasterEngine.generate(
      date,
      civilization: 'egypt',
      category: 'Moon & Manifestation',
    );
    expect(ritual.steps.join(' | '), contains('Khonsu'));
    expect(ritual.steps.join(' | '), contains('AUTHENTICITY:'));
  });
  test('egypt / Dreams & Intuition', () {
    final ritual = DivineMasterEngine.generate(
      date,
      civilization: 'egypt',
      category: 'Dreams & Intuition',
    );
    expect(ritual.steps.join(' | '), contains('Thoth'));
    expect(ritual.steps.join(' | '), contains('AUTHENTICITY:'));
  });
  test('egypt / Ancestors & Remembrance', () {
    final ritual = DivineMasterEngine.generate(
      date,
      civilization: 'egypt',
      category: 'Ancestors & Remembrance',
    );
    expect(ritual.steps.join(' | '), contains('Osiris'));
    expect(ritual.steps.join(' | '), contains('AUTHENTICITY:'));
  });
  test('china / Money & Prosperity', () {
    final ritual = DivineMasterEngine.generate(
      date,
      civilization: 'china',
      category: 'Money & Prosperity',
    );
    expect(ritual.steps.join(' | '), contains('Dao De Jing'));
    expect(ritual.steps.join(' | '), contains('AUTHENTICITY:'));
  });
  test('china / Love & Relationships', () {
    final ritual = DivineMasterEngine.generate(
      date,
      civilization: 'china',
      category: 'Love & Relationships',
    );
    expect(ritual.steps.join(' | '), contains('Humaneness'));
    expect(ritual.steps.join(' | '), contains('AUTHENTICITY:'));
  });
  test('china / Protection & Cleansing', () {
    final ritual = DivineMasterEngine.generate(
      date,
      civilization: 'china',
      category: 'Protection & Cleansing',
    );
    expect(ritual.steps.join(' | '), contains('Daoist Protective'));
    expect(ritual.steps.join(' | '), contains('AUTHENTICITY:'));
  });
  test('china / Moon & Manifestation', () {
    final ritual = DivineMasterEngine.generate(
      date,
      civilization: 'china',
      category: 'Moon & Manifestation',
    );
    expect(ritual.steps.join(' | '), contains('Yijing'));
    expect(ritual.steps.join(' | '), contains('AUTHENTICITY:'));
  });
  test('china / Dreams & Intuition', () {
    final ritual = DivineMasterEngine.generate(
      date,
      civilization: 'china',
      category: 'Dreams & Intuition',
    );
    expect(ritual.steps.join(' | '), contains('Zhuangzi'));
    expect(ritual.steps.join(' | '), contains('AUTHENTICITY:'));
  });
  test('china / Ancestors & Remembrance', () {
    final ritual = DivineMasterEngine.generate(
      date,
      civilization: 'china',
      category: 'Ancestors & Remembrance',
    );
    expect(ritual.steps.join(' | '), contains('Ancestral Ritual'));
    expect(ritual.steps.join(' | '), contains('AUTHENTICITY:'));
  });
}
