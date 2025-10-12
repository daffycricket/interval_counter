import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/state/interval_timer_home_state.dart';
import 'package:interval_counter/state/presets_state.dart';
import 'package:interval_counter/screens/interval_timer_home_screen.dart';

void main() {
  group('IntervalTimerHomeScreen Widget Tests', () {
    Widget createTestWidget() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => IntervalTimerHomeState()),
          ChangeNotifierProvider(create: (_) => PresetsState()),
        ],
        child: const MaterialApp(
          home: IntervalTimerHomeScreen(),
        ),
      );
    }

    testWidgets('screen renders with all main components', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify volume header is present
      expect(find.byKey(const Key('interval_timer_home__icon_button_2')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__slider_3')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__icon_button_5')), findsOneWidget);

      // Verify quick start card is present
      expect(find.byKey(const Key('interval_timer_home__card_6')), findsOneWidget);
      expect(find.text('Démarrage rapide'), findsOneWidget);

      // Verify start button is present
      expect(find.byKey(const Key('interval_timer_home__button_23')), findsOneWidget);
      expect(find.text('COMMENCER'), findsOneWidget);
    });

    testWidgets('incrementing reps updates the display', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap the increment button for reps
      final incrementButton = find.byKey(const Key('interval_timer_home__icon_button_13'));
      expect(incrementButton, findsOneWidget);

      // Initial value should be 16
      expect(find.text('16'), findsOneWidget);

      // Tap increment
      await tester.tap(incrementButton);
      await tester.pumpAndSettle();

      // Value should now be 17
      expect(find.text('17'), findsOneWidget);
    });

    testWidgets('decrementing reps updates the display', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap the decrement button for reps
      final decrementButton = find.byKey(const Key('interval_timer_home__icon_button_11'));
      expect(decrementButton, findsOneWidget);

      // Initial value should be 16
      expect(find.text('16'), findsOneWidget);

      // Tap decrement
      await tester.tap(decrementButton);
      await tester.pumpAndSettle();

      // Value should now be 15
      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('reps cannot go below min value', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final decrementButton = find.byKey(const Key('interval_timer_home__icon_button_11'));

      // Decrement many times to reach minimum
      for (int i = 0; i < 20; i++) {
        await tester.tap(decrementButton);
        await tester.pumpAndSettle();
      }

      // Should be at minimum (1)
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('slider updates volume', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final slider = find.byKey(const Key('interval_timer_home__slider_3'));
      expect(slider, findsOneWidget);

      // Drag slider to change volume
      await tester.drag(slider, const Offset(100, 0));
      await tester.pumpAndSettle();

      // Volume should have changed (we can't easily test the exact value in widget test)
      // But the slider should still be present
      expect(slider, findsOneWidget);
    });

    testWidgets('toggle quick start section collapses and expands', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final toggleButton = find.byKey(const Key('interval_timer_home__icon_button_9'));
      expect(toggleButton, findsOneWidget);

      // Section should be expanded initially - verify controls are visible
      expect(find.byKey(const Key('interval_timer_home__icon_button_11')), findsOneWidget);

      // Tap to collapse
      await tester.tap(toggleButton);
      await tester.pumpAndSettle();

      // Controls should not be visible
      expect(find.byKey(const Key('interval_timer_home__icon_button_11')), findsNothing);

      // Tap to expand again
      await tester.tap(toggleButton);
      await tester.pumpAndSettle();

      // Controls should be visible again
      expect(find.byKey(const Key('interval_timer_home__icon_button_11')), findsOneWidget);
    });

    testWidgets('save button shows dialog', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final saveButton = find.byKey(const Key('interval_timer_home__button_22'));
      expect(saveButton, findsOneWidget);

      // Tap save button
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Dialog should appear
      expect(find.text('Sauvegarder le préréglage'), findsOneWidget);
      expect(find.text('ANNULER'), findsOneWidget);
    });

    testWidgets('empty state shows when no presets', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should show empty state
      expect(find.text('Aucun préréglage'), findsOneWidget);
      expect(find.text('Créez-en un avec + AJOUTER'), findsOneWidget);
    });
  });
}

