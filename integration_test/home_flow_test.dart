import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_counter/main.dart';
import 'package:interval_counter/state/home_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late HomeState homeState;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    homeState = await HomeState.create();
  });

  group('Home Screen', () {
    testWidgets('displays Quick Start card with value controls',
        (tester) async {
      await tester.pumpWidget(IntervalCounterApp(homeState: homeState));
      await tester.pumpAndSettle();

      // Quick Start card visible
      expect(find.byKey(const Key('home__Card-6')), findsOneWidget);

      // Value controls visible (reps, work, rest)
      expect(find.byKey(const Key('home__Text-12')), findsOneWidget); // reps
      expect(find.byKey(const Key('home__Text-16')), findsOneWidget); // work
      expect(find.byKey(const Key('home__Text-20')), findsOneWidget); // rest

      // Start button visible
      expect(find.byKey(const Key('home__Button-23')), findsOneWidget);
    });

    testWidgets('increment reps updates displayed value', (tester) async {
      await tester.pumpWidget(IntervalCounterApp(homeState: homeState));
      await tester.pumpAndSettle();

      // Read initial reps value
      final repsText = tester.widget<Text>(
        find.byKey(const Key('home__Text-12')),
      );
      final initialReps = repsText.data!;

      // Tap increment reps
      await tester.tap(find.byKey(const Key('home__IconButton-13')));
      await tester.pumpAndSettle();

      // Verify value changed
      final updatedRepsText = tester.widget<Text>(
        find.byKey(const Key('home__Text-12')),
      );
      expect(updatedRepsText.data, isNot(equals(initialReps)));
    });

    testWidgets('decrement work time updates displayed value', (tester) async {
      await tester.pumpWidget(IntervalCounterApp(homeState: homeState));
      await tester.pumpAndSettle();

      final workText = tester.widget<Text>(
        find.byKey(const Key('home__Text-16')),
      );
      final initialWork = workText.data!;

      await tester.tap(find.byKey(const Key('home__IconButton-15')));
      await tester.pumpAndSettle();

      final updatedWorkText = tester.widget<Text>(
        find.byKey(const Key('home__Text-16')),
      );
      expect(updatedWorkText.data, isNot(equals(initialWork)));
    });

    testWidgets('collapse and expand Quick Start card', (tester) async {
      await tester.pumpWidget(IntervalCounterApp(homeState: homeState));
      await tester.pumpAndSettle();

      // Controls initially visible
      expect(find.byKey(const Key('home__IconButton-13')), findsOneWidget);

      // Tap collapse button
      await tester.tap(find.byKey(const Key('home__IconButton-9')));
      await tester.pumpAndSettle();

      // Controls hidden
      expect(find.byKey(const Key('home__IconButton-13')), findsNothing);

      // Tap expand again
      await tester.tap(find.byKey(const Key('home__IconButton-9')));
      await tester.pumpAndSettle();

      // Controls visible again
      expect(find.byKey(const Key('home__IconButton-13')), findsOneWidget);
    });

    testWidgets('tap Start navigates to Workout screen', (tester) async {
      await tester.pumpWidget(IntervalCounterApp(homeState: homeState));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('home__Button-23')));
      await tester.pumpAndSettle();

      // Workout screen loaded — timer display visible
      expect(find.byKey(const Key('workout__text-2')), findsOneWidget);
    });

    testWidgets('save preset and see it in list', (tester) async {
      await tester.pumpWidget(IntervalCounterApp(homeState: homeState));
      await tester.pumpAndSettle();

      // Tap save button
      await tester.tap(find.byKey(const Key('home__Button-22')));
      await tester.pumpAndSettle();

      // Dialog appears — enter name
      await tester.enterText(find.byType(TextField), 'Test Preset');
      await tester.pumpAndSettle();

      // Tap OK
      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle();

      // Preset card appears in list
      expect(find.byKey(const Key('home__Card-28')), findsOneWidget);
      expect(find.text('Test Preset'), findsOneWidget);
    });

    testWidgets('tap preset card navigates to Workout', (tester) async {
      // Pre-populate a preset
      homeState.savePreset('My Preset');

      await tester.pumpWidget(IntervalCounterApp(homeState: homeState));
      await tester.pumpAndSettle();

      // Tap preset card
      await tester.tap(find.byKey(const Key('home__Card-28')));
      await tester.pumpAndSettle();

      // Workout screen loaded
      expect(find.byKey(const Key('workout__text-2')), findsOneWidget);
    });
  });
}
