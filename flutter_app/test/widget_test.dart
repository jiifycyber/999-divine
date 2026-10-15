import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justice_divine/main.dart';

void main() {
  testWidgets('Justice Divine opens', (tester) async {
    await tester.pumpWidget(const DivineApp());
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
  });
}
