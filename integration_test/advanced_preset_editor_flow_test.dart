import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_counter/main.dart';
import 'package:interval_counter/state/home_state.dart';
import 'package:interval_counter/widgets/preset_editor/finish_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late HomeState homeState;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    homeState = await HomeState.create();
  });

  /// Navigate to the preset editor, then switch to ADVANCED mode.
  Future<void> navigateToAdvanced(WidgetTester tester) async {
    await tester.pumpWidget(IntervalCounterApp(homeState: homeState));
    await tester.pumpAndSettle();

    // Tap "add preset" button on home screen
    await tester.tap(find.byKey(const Key('home__Button-27')));
    await tester.pumpAndSettle();

    // Tap ADVANCED toggle button
    await tester.tap(find.byKey(const Key('preset_editor__button-4')));
    await tester.pumpAndSettle();
  }

  /// Scroll down within the SingleChildScrollView.
  Future<void> scrollDown(WidgetTester tester, {double dy = -300}) async {
    final scrollable = find.byType(SingleChildScrollView);
    await tester.drag(scrollable, Offset(0, dy));
    await tester.pumpAndSettle();
  }

  group('Advanced Preset Editor — Layout', () {
    testWidgets('switching to ADVANCED shows group card with default step',
        (tester) async {
      await navigateToAdvanced(tester);

      // Default step name visible (only exists in ADVANCED mode)
      expect(find.text('Étape 1'), findsOneWidget);

      // TIME/REPS toggle labels visible on the step
      expect(find.text('TIME'), findsOneWidget);
      expect(find.text('REPS'), findsOneWidget);

      // COLOR button on step action bar
      expect(find.text('COLOR'), findsWidgets);
    });

    testWidgets('switching back to SIMPLE hides advanced panel',
        (tester) async {
      await navigateToAdvanced(tester);

      // Confirm we see advanced-only content (step name)
      expect(find.text('Étape 1'), findsOneWidget);

      // Switch back to SIMPLE
      await tester.tap(find.byKey(const Key('preset_editor__button-3')));
      await tester.pumpAndSettle();

      // Advanced-only content should be gone
      expect(find.text('Étape 1'), findsNothing);
      expect(find.text('TIME'), findsNothing);
    });
  });

  group('Advanced Preset Editor — Group Reps', () {
    testWidgets('increment/decrement group repetitions', (tester) async {
      await navigateToAdvanced(tester);

      // Default reps = 1
      expect(find.text('1'), findsWidgets);

      // Find the "Increase group repetitions" button via semantics
      final incFinder = find.bySemanticsLabel('Increase group repetitions');
      expect(incFinder, findsOneWidget);

      // Tap increment 3 times → reps should become 4
      for (int i = 0; i < 3; i++) {
        await tester.tap(incFinder);
        await tester.pumpAndSettle();
      }
      expect(find.text('4'), findsWidgets);

      // Decrement once → reps should become 3
      final decFinder = find.bySemanticsLabel('Decrease group repetitions');
      await tester.tap(decFinder);
      await tester.pumpAndSettle();
      expect(find.text('3'), findsWidgets);
    });
  });

  group('Advanced Preset Editor — Step Operations', () {
    testWidgets('add step creates a second step', (tester) async {
      await navigateToAdvanced(tester);

      // Only one step initially
      expect(find.text('Étape 1'), findsOneWidget);
      expect(find.text('Étape 2'), findsNothing);

      // Scroll to reveal "add step" button
      await scrollDown(tester);

      // Find add step button
      final addStepFinder = find.bySemanticsLabel('Add step to group');
      expect(addStepFinder, findsOneWidget);
      await tester.tap(addStepFinder);
      await tester.pumpAndSettle();

      // Now two steps
      expect(find.text('Étape 1'), findsOneWidget);
      expect(find.text('Étape 2'), findsOneWidget);
    });

    testWidgets('duplicate step creates a copy', (tester) async {
      await navigateToAdvanced(tester);

      // One step initially
      expect(find.text('Étape 1'), findsOneWidget);

      // Scroll to reveal action bar
      await scrollDown(tester, dy: -200);

      // Tap duplicate button (content_copy icon)
      final dupFinder = find.byIcon(Icons.content_copy);
      expect(dupFinder, findsOneWidget);
      await tester.tap(dupFinder);
      await tester.pumpAndSettle();

      // Now two step cards with name "Étape 1"
      expect(find.text('Étape 1'), findsNWidgets(2));
    });

    testWidgets('delete step removes a step', (tester) async {
      await navigateToAdvanced(tester);

      // Add a second step first — scroll to reveal button
      await scrollDown(tester);
      await tester.tap(find.bySemanticsLabel('Add step to group'));
      await tester.pumpAndSettle();
      expect(find.text('Étape 2'), findsOneWidget);

      // Scroll to reveal delete buttons
      await scrollDown(tester, dy: -300);

      // Delete the second step (tap on second delete icon)
      final deleteFinders = find.byIcon(Icons.delete);
      expect(deleteFinders, findsNWidgets(2));
      await tester.tap(deleteFinders.last);
      await tester.pumpAndSettle();

      // Only first step remains
      expect(find.text('Étape 1'), findsOneWidget);
      expect(find.text('Étape 2'), findsNothing);
    });
  });

  group('Advanced Preset Editor — Step Mode Toggle', () {
    testWidgets('toggling to REPS shows reps counter and duration',
        (tester) async {
      await navigateToAdvanced(tester);

      // Default mode is TIME — tap "REPS" text to toggle
      await tester.tap(find.text('REPS'));
      await tester.pumpAndSettle();

      // In REPS mode, we should see reps semantic labels
      expect(find.bySemanticsLabel('Increase reps Étape 1'), findsOneWidget);
      expect(find.bySemanticsLabel('Decrease reps Étape 1'), findsOneWidget);

      // And duration controls as well
      expect(
          find.bySemanticsLabel('Increase duration Étape 1'), findsOneWidget);
      expect(
          find.bySemanticsLabel('Decrease duration Étape 1'), findsOneWidget);
    });

    testWidgets('toggling back to TIME shows single time control',
        (tester) async {
      await navigateToAdvanced(tester);

      // Toggle to REPS
      await tester.tap(find.text('REPS'));
      await tester.pumpAndSettle();

      // Toggle back to TIME
      await tester.tap(find.text('TIME'));
      await tester.pumpAndSettle();

      // Time mode has time-specific semantics
      expect(find.bySemanticsLabel('Increase time Étape 1'), findsOneWidget);
      expect(find.bySemanticsLabel('Decrease time Étape 1'), findsOneWidget);

      // REPS-specific controls should be gone
      expect(find.bySemanticsLabel('Increase reps Étape 1'), findsNothing);
    });
  });

  group('Advanced Preset Editor — Step Value Controls', () {
    testWidgets('default step shows initial time value', (tester) async {
      await navigateToAdvanced(tester);

      // Default step duration is 5s — TimeFormatter uses "00 : 05" format
      // Appears in step value display and subtotal
      expect(find.text('00 : 05'), findsWidgets);

      // Time controls are present (semantics nodes exist)
      expect(find.bySemanticsLabel('Increase time Étape 1'), findsOneWidget);
      expect(find.bySemanticsLabel('Decrease time Étape 1'), findsOneWidget);
    });

    testWidgets('REPS mode shows reps and duration controls', (tester) async {
      await navigateToAdvanced(tester);

      // Switch to REPS mode
      await tester.tap(find.text('REPS'));
      await tester.pumpAndSettle();

      // REPS controls present
      expect(find.bySemanticsLabel('Increase reps Étape 1'), findsOneWidget);
      expect(find.bySemanticsLabel('Decrease reps Étape 1'), findsOneWidget);

      // Duration controls also present in REPS mode
      expect(
          find.bySemanticsLabel('Increase duration Étape 1'), findsOneWidget);
      expect(
          find.bySemanticsLabel('Decrease duration Étape 1'), findsOneWidget);
    });
  });

  group('Advanced Preset Editor — Add Group', () {
    testWidgets('add group creates a second group', (tester) async {
      await navigateToAdvanced(tester);

      // Initially one step name visible
      expect(find.text('Étape 1'), findsOneWidget);

      // Scroll to reveal add group button
      await scrollDown(tester, dy: -400);

      // Find add group button
      final addGroupFinder = find.bySemanticsLabel('Add a new group');
      expect(addGroupFinder, findsOneWidget);
      await tester.tap(addGroupFinder);
      await tester.pumpAndSettle();

      // Now two groups → two RÉPÉTITIONS labels
      expect(find.text('RÉPÉTITIONS'), findsNWidgets(2));
    });
  });

  group('Advanced Preset Editor — FINISH Card', () {
    testWidgets('finish card shows FINISH title and ALARM info',
        (tester) async {
      await navigateToAdvanced(tester);

      // Scroll to reveal FINISH card
      await scrollDown(tester, dy: -500);

      expect(find.text('FINISH'), findsOneWidget);
      expect(find.text('ALARM'), findsOneWidget);
      expect(find.text('BEEP X3'), findsOneWidget);

      // The FinishCard widget itself should be present
      expect(find.byType(FinishCard), findsOneWidget);
    });

    testWidgets('tapping COLOR on finish opens color picker dialog',
        (tester) async {
      await navigateToAdvanced(tester);

      // Scroll to reveal FINISH card
      await scrollDown(tester, dy: -500);

      // Find COLOR text inside the FINISH card and tap it
      final finishColorBtn = find.descendant(
        of: find.byType(FinishCard),
        matching: find.text('COLOR'),
      );
      expect(finishColorBtn, findsOneWidget);
      await tester.tap(finishColorBtn);
      await tester.pumpAndSettle();

      // Color picker dialog should appear
      expect(find.text('Choose a color'), findsOneWidget);

      // Dismiss dialog by tapping outside
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Dialog closed
      expect(find.text('Choose a color'), findsNothing);
    });
  });

  group('Advanced Preset Editor — Color Picker', () {
    testWidgets('step color picker opens and selects a color',
        (tester) async {
      await navigateToAdvanced(tester);

      // Scroll to reveal step action bar with COLOR button
      await scrollDown(tester, dy: -200);

      // Tap COLOR text on step action bar (the first one found, not in FINISH card)
      final colorTextFinders = find.text('COLOR');
      expect(colorTextFinders, findsWidgets);
      await tester.tap(colorTextFinders.first);
      await tester.pumpAndSettle();

      // Dialog opens
      expect(find.text('Choose a color'), findsOneWidget);

      // Tap on one of the color containers in the dialog
      final dialogFinder = find.byType(AlertDialog);
      final colorCircles = find.descendant(
        of: dialogFinder,
        matching: find.byType(GestureDetector),
      );
      expect(colorCircles, findsWidgets);

      // Tap the second color option (to change from default)
      await tester.tap(colorCircles.at(1));
      await tester.pumpAndSettle();

      // Dialog should close after selection
      expect(find.text('Choose a color'), findsNothing);
    });
  });

  group('Advanced Preset Editor — Total Display', () {
    testWidgets('total updates when group reps change', (tester) async {
      await navigateToAdvanced(tester);

      // Initial: 1 group × 1 rep × 1 step × 5s = "00 : 05"
      expect(find.text('00 : 05'), findsWidgets);

      // Increment group reps (outside ReorderableListView, so tap works)
      // 2 reps × 5s = 10s → "00 : 10"
      final incRepsFinder = find.bySemanticsLabel('Increase group repetitions');
      await tester.tap(incRepsFinder);
      await tester.pumpAndSettle();

      // Total should now be "00 : 10" (displayed in subtotal and/or total)
      expect(find.text('00 : 10'), findsWidgets);

      // Increment again: 3 × 5s = 15s → "00 : 15"
      await tester.tap(incRepsFinder);
      await tester.pumpAndSettle();
      expect(find.text('00 : 15'), findsWidgets);
    });

    testWidgets('total updates when second group added', (tester) async {
      await navigateToAdvanced(tester);

      // Initial total: "00 : 05"
      expect(find.text('00 : 05'), findsWidgets);

      // Scroll to add group button and add a second group
      await scrollDown(tester, dy: -400);
      await tester.tap(find.bySemanticsLabel('Add a new group'));
      await tester.pumpAndSettle();

      // Second group adds 0s (empty group), total stays "00 : 05"
      // But the subtotal for the empty group should show "00 : 00"
      expect(find.text('00 : 00'), findsWidgets);
    });
  });
}
