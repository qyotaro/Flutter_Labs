import 'package:flutter/material.dart';
import 'package:flutter_project/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    const bool hasLoggedIn = false; 
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(hasLoggedIn: hasLoggedIn));

    // Перевірка початкового стану лічильника.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Тап по іконці '+' та перерисовка.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Перевірка, що лічильник збільшився.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
