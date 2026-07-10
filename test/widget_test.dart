import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studymate_flutter/app.dart';

void main() {
  testWidgets('App launches and shows Login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const StudyMateApp());
    expect(find.text('StudyMate'), findsWidgets);
  });
}
