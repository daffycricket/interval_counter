import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_counter/screens/interval_timer_home_screen.dart';
import 'package:interval_counter/state/interval_timer_home_state.dart';
import '../helpers/widget_test_helpers.dart';

void main() {
  group('IntervalTimerHomeScreen Integration Tests', () {
    late IntervalTimerHomeState state;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      state = IntervalTimerHomeState(prefs);
    });

    testWidgets('all main components are present', (tester) async {
      await tester.pumpWidget(createTestApp(
        state,
        const IntervalTimerHomeScreen(),
      ));
      await tester.pumpAndSettle();

      // Volume header components
      expectWidgetWithKey('interval_timer_home__IconButton-2');
      expectWidgetWithKey('interval_timer_home__Slider-3');
      expectWidgetWithKey('interval_timer_home__IconButton-5');

      // Quick start section
      expectWidgetWithKey('interval_timer_home__Card-6');
      expectWidgetWithKey('interval_timer_home__Button-23');

      // Presets section header
      expectWidgetWithKey('interval_timer_home__Container-24');
      expectWidgetWithKey('interval_timer_home__Button-27');
    });

    testWidgets('displays title texts', (tester) async {
      await tester.pumpWidget(createTestApp(
        state,
        const IntervalTimerHomeScreen(),
      ));
      await tester.pumpAndSettle();

      expectText('Démarrage rapide');
      expectText('VOS PRÉRÉGLAGES');
    });

    testWidgets('displays default values', (tester) async {
      await tester.pumpWidget(createTestApp(
        state,
        const IntervalTimerHomeScreen(),
      ));
      await tester.pumpAndSettle();

      expectText('16'); // default reps
      expectText('00 : 44'); // default work time
      expectText('00 : 15'); // default rest time
    });

    testWidgets('user can increment reps and see update', (tester) async {
      await tester.pumpWidget(createTestApp(
        state,
        const IntervalTimerHomeScreen(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('16'), findsOneWidget);

      await tapByKey(tester, 'interval_timer_home__IconButton-13');

      expect(find.text('17'), findsOneWidget);
      expect(state.reps, 17);
    });

    testWidgets('user can decrement work time and see update', (tester) async {
      await tester.pumpWidget(createTestApp(
        state,
        const IntervalTimerHomeScreen(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('00 : 44'), findsOneWidget);

      await tapByKey(tester, 'interval_timer_home__IconButton-15');

      expect(find.text('00 : 39'), findsOneWidget);
      expect(state.workSeconds, 39);
    });

    testWidgets('user can adjust volume slider', (tester) async {
      await tester.pumpWidget(createTestApp(
        state,
        const IntervalTimerHomeScreen(),
      ));
      await tester.pumpAndSettle();

      final initialVolume = state.volume;

      final slider = tester.widget<Slider>(
        findByKeyString('interval_timer_home__Slider-3'),
      );

      slider.onChanged!(0.9);
      await tester.pump();

      expect(state.volume, 0.9);
      expect(state.volume, isNot(initialVolume));
    });

    testWidgets('quick start section can be collapsed', (tester) async {
      await tester.pumpWidget(createTestApp(
        state,
        const IntervalTimerHomeScreen(),
      ));
      await tester.pumpAndSettle();

      expect(state.quickStartExpanded, true);
      expect(findByKeyString('interval_timer_home__Button-23'), findsOneWidget);

      await tapByKey(tester, 'interval_timer_home__IconButton-9');

      expect(state.quickStartExpanded, false);
      expect(findByKeyString('interval_timer_home__Button-23'), findsNothing);
    });

    testWidgets('shows empty state when no presets', (tester) async {
      await tester.pumpWidget(createTestApp(
        state,
        const IntervalTimerHomeScreen(),
      ));
      await tester.pumpAndSettle();

      expect(state.presets, isEmpty);
      expect(
        find.text('Aucun préréglage sauvegardé.\nAppuyez sur + AJOUTER pour créer.'),
        findsOneWidget,
      );
    });

    testWidgets('displays presets when available', (tester) async {
      // Add a preset to state
      await state.saveCurrentAsPreset('Test Preset');

      await tester.pumpWidget(createTestApp(
        state,
        const IntervalTimerHomeScreen(),
      ));
      await tester.pumpAndSettle();

      expect(state.presets.length, 1);
      expectText('Test Preset');
    });

    testWidgets('can load preset into quick start', (tester) async {
      // Add a preset with specific values
      state.incrementReps(); // 17
      state.incrementReps(); // 18
      state.incrementWorkTime(); // 49
      await state.saveCurrentAsPreset('Custom Preset');

      // Reset to defaults
      state.decrementReps(); // 17
      state.decrementReps(); // 16
      state.decrementWorkTime(); // 44

      await tester.pumpWidget(createTestApp(
        state,
        const IntervalTimerHomeScreen(),
      ));
      await tester.pumpAndSettle();

      expect(state.reps, 16);
      expect(state.workSeconds, 44);

      // Tap the preset card to load it
      final presetId = state.presets[0].id;
      await tester.tap(find.byKey(Key('interval_timer_home__Card-28_$presetId')));
      await tester.pumpAndSettle();

      // Values should be restored
      expect(state.reps, 18);
      expect(state.workSeconds, 49);
    });

    testWidgets('start button is always visible when expanded', (tester) async {
      await tester.pumpWidget(createTestApp(
        state,
        const IntervalTimerHomeScreen(),
      ));
      await tester.pumpAndSettle();

      final startButton = tester.widget<ElevatedButton>(
        find.descendant(
          of: findByKeyString('interval_timer_home__Button-23'),
          matching: find.byType(ElevatedButton),
        ),
      );

      expect(startButton.onPressed, isNotNull);
    });

    testWidgets('critical user flow: increment then start', (tester) async {
      await tester.pumpWidget(createTestApp(
        state,
        const IntervalTimerHomeScreen(),
      ));
      await tester.pumpAndSettle();

      // Increment reps
      await tapByKey(tester, 'interval_timer_home__IconButton-13');
      expect(state.reps, 17);

      // Increment work time
      await tapByKey(tester, 'interval_timer_home__IconButton-17');
      expect(state.workSeconds, 49);

      // Tap start button
      await tapByKey(tester, 'interval_timer_home__Button-23');

      // Should show snackbar (placeholder for navigation)
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('17 reps'), findsOneWidget);
      expect(find.textContaining('49s work'), findsOneWidget);
    });

    testWidgets('respects boundary constraints', (tester) async {
      // Set to minimum reps
      while (state.reps > 1) {
        state.decrementReps();
      }

      await tester.pumpWidget(createTestApp(
        state,
        const IntervalTimerHomeScreen(),
      ));
      await tester.pumpAndSettle();

      expect(state.reps, 1);

      // Try to decrement below minimum
      await tapByKey(tester, 'interval_timer_home__IconButton-11');

      // Should stay at minimum
      expect(state.reps, 1);
    });

    testWidgets('all interactive components have stable keys', (tester) async {
      await tester.pumpWidget(createTestApp(
        state,
        const IntervalTimerHomeScreen(),
      ));
      await tester.pumpAndSettle();

      // Verify all critical keys exist
      final criticalKeys = [
        'interval_timer_home__IconButton-2', // Volume toggle
        'interval_timer_home__Slider-3', // Volume slider
        'interval_timer_home__IconButton-5', // More options
        'interval_timer_home__IconButton-9', // Collapse quick start
        'interval_timer_home__IconButton-11', // Decrease reps
        'interval_timer_home__IconButton-13', // Increase reps
        'interval_timer_home__Button-23', // Start button
        'interval_timer_home__Button-27', // Add preset
      ];

      for (final keyString in criticalKeys) {
        expectWidgetWithKey(keyString);
      }
    });
  });
}
