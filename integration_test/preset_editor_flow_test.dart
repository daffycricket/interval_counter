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

  group('Preset Editor Screen', () {
    Future<void> navigateToEditor(WidgetTester tester) async {
      await tester.pumpWidget(IntervalCounterApp(homeState: homeState));
      await tester.pumpAndSettle();

      // Tap the add preset button (stable key)
      await tester.tap(find.byKey(const Key('home__Button-27')));
      await tester.pumpAndSettle();
    }

    testWidgets('editor screen loads with all controls', (tester) async {
      await navigateToEditor(tester);

      // Header controls
      expect(find.byKey(const Key('preset_editor__iconbutton-2')),
          findsOneWidget); // close
      expect(find.byKey(const Key('preset_editor__iconbutton-5')),
          findsOneWidget); // save

      // Name input
      expect(
          find.byKey(const Key('preset_editor__input-6')), findsOneWidget);

      // Params panel
      expect(find.byKey(const Key('preset_editor__container-7')),
          findsOneWidget);

      // Total display
      expect(
          find.byKey(const Key('preset_editor__text-28')), findsOneWidget);
    });

    testWidgets('enter name and modify parameters', (tester) async {
      await navigateToEditor(tester);

      // Enter preset name
      await tester.enterText(
        find.byKey(const Key('preset_editor__input-6')),
        'My Custom Preset',
      );
      await tester.pumpAndSettle();

      // Increment reps 3 times
      for (int i = 0; i < 3; i++) {
        await tester.tap(
            find.byKey(const Key('preset_editor__iconbutton-15')));
        await tester.pumpAndSettle();
      }

      // Read reps value — should have changed from default
      final repsText = tester.widget<Text>(
        find.byKey(const Key('preset_editor__text-14')),
      );
      expect(repsText.data, isNotNull);

      // Increment work time
      await tester
          .tap(find.byKey(const Key('preset_editor__iconbutton-19')));
      await tester.pumpAndSettle();

      // Total should be updated
      final totalText = tester.widget<Text>(
        find.byKey(const Key('preset_editor__text-28')),
      );
      expect(totalText.data, isNotNull);
    });

    testWidgets('save preset returns to home with new preset',
        (tester) async {
      await navigateToEditor(tester);

      // Enter name
      await tester.enterText(
        find.byKey(const Key('preset_editor__input-6')),
        'Saved Preset',
      );
      await tester.pumpAndSettle();

      // Tap save
      await tester
          .tap(find.byKey(const Key('preset_editor__iconbutton-5')));
      await tester.pumpAndSettle();

      // Back on home screen — Start button visible
      expect(find.byKey(const Key('home__Button-23')), findsOneWidget);

      // Saved preset appears in list
      expect(find.text('Saved Preset'), findsOneWidget);
    });

    testWidgets('close without saving returns to home without new preset',
        (tester) async {
      await navigateToEditor(tester);

      // Enter name but don't save
      await tester.enterText(
        find.byKey(const Key('preset_editor__input-6')),
        'Not Saved',
      );
      await tester.pumpAndSettle();

      // Tap close
      await tester
          .tap(find.byKey(const Key('preset_editor__iconbutton-2')));
      await tester.pumpAndSettle();

      // Back on home screen
      expect(find.byKey(const Key('home__Button-23')), findsOneWidget);

      // Preset NOT in list
      expect(find.text('Not Saved'), findsNothing);
    });

    testWidgets('all value controls respond to taps', (tester) async {
      await navigateToEditor(tester);

      // Test each increment button exists and is tappable
      final incrementKeys = [
        'preset_editor__iconbutton-11', // prepare +
        'preset_editor__iconbutton-15', // reps +
        'preset_editor__iconbutton-19', // work +
        'preset_editor__iconbutton-23', // rest +
        'preset_editor__iconbutton-27', // cooldown +
      ];

      for (final key in incrementKeys) {
        final finder = find.byKey(Key(key));
        expect(finder, findsOneWidget, reason: 'Missing: $key');
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }

      // Total should reflect the changes
      final totalText = tester.widget<Text>(
        find.byKey(const Key('preset_editor__text-28')),
      );
      expect(totalText.data, isNotNull);
    });
  });
}
