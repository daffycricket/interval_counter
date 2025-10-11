import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/value_control.dart';

void main() {
  group('ValueControl widget', () {
    testWidgets('Affiche le label et la valeur correctement', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueControl(
              label: 'RÉPÉTITIONS',
              value: '16',
              onDecrease: () {},
              onIncrease: () {},
              decreaseKey: 'test_decrease',
              valueKey: 'test_value',
              increaseKey: 'test_increase',
              decreaseSemanticLabel: 'Diminuer',
              increaseSemanticLabel: 'Augmenter',
            ),
          ),
        ),
      );

      expect(find.text('RÉPÉTITIONS'), findsOneWidget);
      expect(find.text('16'), findsOneWidget);
    });

    testWidgets('Les boutons sont cliquables quand enabled', (WidgetTester tester) async {
      int decreaseCount = 0;
      int increaseCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueControl(
              label: 'TEST',
              value: '10',
              onDecrease: () => decreaseCount++,
              onIncrease: () => increaseCount++,
              decreaseKey: 'test_decrease',
              valueKey: 'test_value',
              increaseKey: 'test_increase',
              decreaseSemanticLabel: 'Diminuer',
              increaseSemanticLabel: 'Augmenter',
              decreaseEnabled: true,
              increaseEnabled: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('test_decrease')));
      await tester.pump();
      expect(decreaseCount, 1);

      await tester.tap(find.byKey(const Key('test_increase')));
      await tester.pump();
      expect(increaseCount, 1);
    });

    testWidgets('Les boutons sont désactivés quand disabled', (WidgetTester tester) async {
      int decreaseCount = 0;
      int increaseCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueControl(
              label: 'TEST',
              value: '1',
              onDecrease: () => decreaseCount++,
              onIncrease: () => increaseCount++,
              decreaseKey: 'test_decrease',
              valueKey: 'test_value',
              increaseKey: 'test_increase',
              decreaseSemanticLabel: 'Diminuer',
              increaseSemanticLabel: 'Augmenter',
              decreaseEnabled: false,
              increaseEnabled: false,
            ),
          ),
        ),
      );

      // Vérifier que les boutons existent
      expect(find.byKey(const Key('test_decrease')), findsOneWidget);
      expect(find.byKey(const Key('test_increase')), findsOneWidget);

      // Tenter de taper sur les boutons désactivés
      await tester.tap(find.byKey(const Key('test_decrease')));
      await tester.pump();
      
      await tester.tap(find.byKey(const Key('test_increase')));
      await tester.pump();

      // Les callbacks ne doivent pas avoir été appelés
      expect(decreaseCount, 0);
      expect(increaseCount, 0);
    });
  });
}

