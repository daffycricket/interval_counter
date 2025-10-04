import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/value_control.dart';

void main() {
  group('ValueControl Widget Tests', () {
    testWidgets('displays label and value correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueControl(
              label: 'TEST LABEL',
              value: '42',
              decreaseSemanticLabel: 'Decrease',
              increaseSemanticLabel: 'Increase',
            ),
          ),
        ),
      );

      expect(find.text('TEST LABEL'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('calls onIncrease when + button tapped', (WidgetTester tester) async {
      bool increaseWasCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueControl(
              label: 'COUNT',
              value: '5',
              onIncrease: () => increaseWasCalled = true,
              decreaseSemanticLabel: 'Decrease',
              increaseSemanticLabel: 'Increase',
              increaseKey: 'increase_btn',
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('increase_btn')));
      await tester.pump();

      expect(increaseWasCalled, true);
    });

    testWidgets('calls onDecrease when - button tapped', (WidgetTester tester) async {
      bool decreaseWasCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueControl(
              label: 'COUNT',
              value: '5',
              onDecrease: () => decreaseWasCalled = true,
              decreaseSemanticLabel: 'Decrease',
              increaseSemanticLabel: 'Increase',
              decreaseKey: 'decrease_btn',
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('decrease_btn')));
      await tester.pump();

      expect(decreaseWasCalled, true);
    });

    testWidgets('disables decrease button when decreaseEnabled is false', (WidgetTester tester) async {
      int callCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueControl(
              label: 'COUNT',
              value: '1',
              onDecrease: () => callCount++,
              decreaseSemanticLabel: 'Decrease',
              increaseSemanticLabel: 'Increase',
              decreaseEnabled: false,
              decreaseKey: 'decrease_btn',
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('decrease_btn')));
      await tester.pump();

      expect(callCount, 0); // Should not be called when disabled
    });

    testWidgets('disables increase button when increaseEnabled is false', (WidgetTester tester) async {
      int callCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueControl(
              label: 'COUNT',
              value: '99',
              onIncrease: () => callCount++,
              decreaseSemanticLabel: 'Decrease',
              increaseSemanticLabel: 'Increase',
              increaseEnabled: false,
              increaseKey: 'increase_btn',
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('increase_btn')));
      await tester.pump();

      expect(callCount, 0); // Should not be called when disabled
    });
  });
}
