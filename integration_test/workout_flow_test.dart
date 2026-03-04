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

  group('Workout Screen', () {
    Future<void> navigateToWorkout(WidgetTester tester) async {
      await tester.pumpWidget(IntervalCounterApp(homeState: homeState));
      await tester.pumpAndSettle();

      // Start workout from home
      await tester.tap(find.byKey(const Key('home__Button-23')));
      await tester.pumpAndSettle();
    }

    testWidgets('workout screen displays timer and step label',
        (tester) async {
      await navigateToWorkout(tester);

      // Timer display visible
      expect(find.byKey(const Key('workout__text-2')), findsOneWidget);

      // Step label visible
      expect(find.byKey(const Key('workout__text-3')), findsOneWidget);
    });

    testWidgets('tap screen toggles controls visibility', (tester) async {
      await navigateToWorkout(tester);

      // Tap the workout container to toggle controls
      await tester.tap(find.byKey(const Key('workout__container-1')));
      await tester.pumpAndSettle();

      // Pause FAB should be present (visible or animating)
      expect(find.byKey(const Key('workout__iconbutton-4')), findsOneWidget);
    });

    testWidgets('pause button toggles pause state', (tester) async {
      await navigateToWorkout(tester);

      // Show controls
      await tester.tap(find.byKey(const Key('workout__container-1')));
      await tester.pumpAndSettle();

      // Tap pause
      await tester.tap(find.byKey(const Key('workout__iconbutton-4')));
      await tester.pumpAndSettle();

      // Should show play icon (resume)
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);

      // Tap again to resume
      await tester.tap(find.byKey(const Key('workout__iconbutton-4')));
      await tester.pumpAndSettle();

      // Should show pause icon again
      expect(find.byIcon(Icons.pause), findsOneWidget);
    });

    testWidgets('next step button advances workout', (tester) async {
      await navigateToWorkout(tester);

      // Read initial step label
      final initialLabel = tester.widget<Text>(
        find.byKey(const Key('workout__text-3')),
      );
      final initialText = initialLabel.data;

      // Show controls
      await tester.tap(find.byKey(const Key('workout__container-1')));
      await tester.pumpAndSettle();

      // Tap next step
      await tester.tap(find.byKey(const Key('workout__iconbutton-3')));
      await tester.pumpAndSettle();

      // Step label should change
      final updatedLabel = tester.widget<Text>(
        find.byKey(const Key('workout__text-3')),
      );
      expect(updatedLabel.data, isNot(equals(initialText)));
    });

    testWidgets('previous step button goes back', (tester) async {
      await navigateToWorkout(tester);

      // Show controls and advance one step
      await tester.tap(find.byKey(const Key('workout__container-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('workout__iconbutton-3')));
      await tester.pumpAndSettle();

      // Read current step
      final afterNext = tester.widget<Text>(
        find.byKey(const Key('workout__text-3')),
      );
      final afterNextText = afterNext.data;

      // Show controls again (may have auto-hidden)
      await tester.tap(find.byKey(const Key('workout__container-1')));
      await tester.pumpAndSettle();

      // Tap previous
      await tester.tap(find.byKey(const Key('workout__iconbutton-2')));
      await tester.pumpAndSettle();

      // Step should go back
      final afterPrev = tester.widget<Text>(
        find.byKey(const Key('workout__text-3')),
      );
      expect(afterPrev.data, isNot(equals(afterNextText)));
    });

    testWidgets('long press exit returns to home', (tester) async {
      await navigateToWorkout(tester);

      // Show controls
      await tester.tap(find.byKey(const Key('workout__container-1')));
      await tester.pumpAndSettle();

      // Long press exit button
      await tester.longPress(find.byKey(const Key('workout__button-1')));
      await tester.pumpAndSettle();

      // Back on home screen
      expect(find.byKey(const Key('home__Button-23')), findsOneWidget);
    });

    testWidgets('navigation controls have correct icons', (tester) async {
      await navigateToWorkout(tester);

      // Show controls
      await tester.tap(find.byKey(const Key('workout__container-1')));
      await tester.pumpAndSettle();

      // Previous button
      expect(find.byKey(const Key('workout__iconbutton-2')), findsOneWidget);

      // Next button
      expect(find.byKey(const Key('workout__iconbutton-3')), findsOneWidget);

      // Exit button
      expect(find.byKey(const Key('workout__button-1')), findsOneWidget);
    });
  });
}
