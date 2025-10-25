import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_counter/widgets/workout/navigation_controls.dart';
import 'package:interval_counter/state/workout_state.dart';
import 'package:interval_counter/models/preset.dart';

void main() {
  group('NavigationControls Widget Tests', () {
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
            body: NavigationControls(),
          ),
        ),
      );
    }

    testWidgets('renders all navigation controls', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.byKey(const Key('workout__container-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__iconbutton-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__button-1')), findsOneWidget);
      expect(find.byKey(const Key('workout__iconbutton-3')), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('previous button calls previousStep', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      // Aller à work d'abord
      state.nextStep();
      expect(state.currentStep, StepType.work);
      
      await tester.pumpWidget(createTestWidget(state));
      
      await tester.tap(find.byKey(const Key('workout__iconbutton-2')));
      await tester.pump();
      
      expect(state.currentStep, StepType.preparation);
      
      state.dispose();
    });

    testWidgets('next button calls nextStep', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      expect(state.currentStep, StepType.preparation);
      
      await tester.pumpWidget(createTestWidget(state));
      
      await tester.tap(find.byKey(const Key('workout__iconbutton-3')));
      await tester.pump();
      
      expect(state.currentStep, StepType.work);
      
      state.dispose();
    });

    testWidgets('exit button shows correct text', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.text('Maintenir pour sortir'), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('long press on exit button calls exitWorkout', (tester) async {
      bool workoutExited = false;
      final state = WorkoutState(prefs, testPreset, onWorkoutComplete: () {
        workoutExited = true;
      });
      state.stopTimer();
      
      await tester.pumpWidget(createTestWidget(state));
      
      await tester.longPress(find.byKey(const Key('workout__button-1')));
      await tester.pump();
      
      expect(workoutExited, true);
      
      state.dispose();
    });
  });
}

