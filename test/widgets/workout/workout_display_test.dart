import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_counter/widgets/workout/workout_display.dart';
import 'package:interval_counter/state/workout_state.dart';
import 'package:interval_counter/models/preset.dart';

void main() {
  group('WorkoutDisplay Widget Tests', () {
    late SharedPreferences prefs;
    late Preset testPreset;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      
      testPreset = Preset.create(
        name: 'Test',
        prepareSeconds: 5,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 10,
      );
    });

    Widget createTestWidget(WorkoutState state) {
      return ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(
          home: Scaffold(
            body: WorkoutDisplay(),
          ),
        ),
      );
    }

    testWidgets('renders timer and step label', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.byKey(const Key('workout__text-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__text-3')), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('timer shows correct format', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.text('00:05'), findsOneWidget); // 5 seconds prep
      
      state.dispose();
    });

    testWidgets('step label shows correct text for preparation', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.text('PRÉPARER'), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('step label shows correct text for work', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      state.nextStep(); // Go to work
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.text('TRAVAIL'), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('step label shows correct text for rest', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      state.nextStep(); // prep -> work
      state.nextStep(); // work -> rest
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.text('REPOS'), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('step label shows correct text for cooldown', (tester) async {
      final presetCooldown = Preset.create(
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 1,
        restSeconds: 0,
        cooldownSeconds: 10,
      );
      
      final state = WorkoutState(prefs, presetCooldown);
      state.stopTimer();
      
      state.nextStep(); // work -> cooldown
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.text('REFROIDIR'), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('reps counter not visible during preparation', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.byKey(const Key('workout__text-1')), findsNothing);
      
      state.dispose();
    });

    testWidgets('reps counter visible during work', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      state.nextStep(); // Go to work
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.byKey(const Key('workout__text-1')), findsOneWidget);
      expect(find.text('3'), findsOneWidget); // 3 reps remaining
      
      state.dispose();
    });

    testWidgets('reps counter visible during rest', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      state.nextStep(); // prep -> work
      state.nextStep(); // work -> rest
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.byKey(const Key('workout__text-1')), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // 2 reps remaining
      
      state.dispose();
    });
  });
}

