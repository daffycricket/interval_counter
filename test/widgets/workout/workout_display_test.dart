import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/widgets/workout/workout_display.dart';
import 'package:interval_counter/state/workout_state.dart';
import 'package:interval_counter/models/preset.dart';
import '../../helpers/mock_services.dart';

void main() {
  group('WorkoutDisplay Widget Tests', () {
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

    WorkoutState createTestState(Preset preset) {
      final tickerService = MockTickerService();
      final audioService = MockAudioService();
      final prefsRepo = MockPreferencesRepository();
      
      return WorkoutState(
        preset: preset,
        tickerService: tickerService,
        audioService: audioService,
        prefsRepo: prefsRepo,
      );
    }

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
      final state = createTestState(testPreset);
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.byKey(const Key('workout__text-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__text-3')), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('timer shows correct format', (tester) async {
      final state = createTestState(testPreset);
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.text('00:05'), findsOneWidget); // 5 seconds prep
      
      state.dispose();
    });

    testWidgets('step label shows correct text for preparation', (tester) async {
      final state = createTestState(testPreset);
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.text('PRÉPARER'), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('step label shows correct text for work', (tester) async {
      final state = createTestState(testPreset);
      
      state.nextStep(); // Go to work
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.text('TRAVAIL'), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('step label shows correct text for rest', (tester) async {
      final state = createTestState(testPreset);
      
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
      
      final state = createTestState(presetCooldown);
      
      state.nextStep(); // work -> cooldown
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.text('REFROIDIR'), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('reps counter not visible during preparation', (tester) async {
      final state = createTestState(testPreset);
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.byKey(const Key('workout__text-1')), findsNothing);
      
      state.dispose();
    });

    testWidgets('reps counter visible during work', (tester) async {
      final state = createTestState(testPreset);
      
      state.nextStep(); // Go to work
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.byKey(const Key('workout__text-1')), findsOneWidget);
      expect(find.text('3'), findsOneWidget); // 3 reps remaining
      
      state.dispose();
    });

    testWidgets('reps counter visible during rest', (tester) async {
      final state = createTestState(testPreset);
      
      state.nextStep(); // prep -> work
      state.nextStep(); // work -> rest
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.byKey(const Key('workout__text-1')), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // 2 reps remaining
      
      state.dispose();
    });
  });
}

