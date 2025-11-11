import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/widgets/workout/navigation_controls.dart';
import 'package:interval_counter/state/workout_state.dart';
import 'package:interval_counter/models/preset.dart';
import '../../helpers/mock_services.dart';

void main() {
  group('NavigationControls Widget Tests', () {
    late Preset testPreset;

    setUp(() async {
      testPreset = Preset.create(
        name: 'Test',
        prepareSeconds: 5,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 10,
      );
    });

    WorkoutState createTestState(Preset preset, {VoidCallback? onWorkoutComplete}) {
      final tickerService = MockTickerService();
      final audioService = MockAudioService();
      final prefsRepo = MockPreferencesRepository();
      
      return WorkoutState(
        preset: preset,
        tickerService: tickerService,
        audioService: audioService,
        prefsRepo: prefsRepo,
        onWorkoutComplete: onWorkoutComplete,
      );
    }

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
      final state = createTestState(testPreset);
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.byKey(const Key('workout__container-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__iconbutton-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__button-1')), findsOneWidget);
      expect(find.byKey(const Key('workout__iconbutton-3')), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('previous button calls previousStep', (tester) async {
      final state = createTestState(testPreset);
      
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
      final state = createTestState(testPreset);
      
      expect(state.currentStep, StepType.preparation);
      
      await tester.pumpWidget(createTestWidget(state));
      
      await tester.tap(find.byKey(const Key('workout__iconbutton-3')));
      await tester.pump();
      
      expect(state.currentStep, StepType.work);
      
      state.dispose();
    });

    testWidgets('exit button shows correct text', (tester) async {
      final state = createTestState(testPreset);
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.text('Maintenir pour sortir'), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('long press on exit button calls exitWorkout', (tester) async {
      bool workoutExited = false;
      final state = createTestState(testPreset, onWorkoutComplete: () {
        workoutExited = true;
      });
      
      await tester.pumpWidget(createTestWidget(state));
      
      await tester.longPress(find.byKey(const Key('workout__button-1')));
      await tester.pump();
      
      expect(workoutExited, true);
      
      state.dispose();
    });
  });
}

