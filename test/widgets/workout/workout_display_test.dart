import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/domain/step_type.dart';
import 'package:interval_counter/domain/workout_engine.dart';
import 'package:interval_counter/state/workout_state.dart';
import 'package:interval_counter/widgets/workout/workout_display.dart';

import '../../helpers/mock_services.dart';

void main() {
  group('WorkoutDisplay Widget Tests', () {
    late MockTickerService mockTickerService;
    late MockAudioService mockAudioService;
    late MockPreferencesRepository mockPrefsRepo;

    setUp(() {
      mockTickerService = MockTickerService();
      mockAudioService = MockAudioService();
      mockPrefsRepo = MockPreferencesRepository();
    });

    WorkoutState createState({required List<WorkoutStep> steps}) {
      return WorkoutState.withEngine(
        engine: WorkoutEngine.fromSteps(steps),
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
    }

    Widget createTestWidget(WorkoutState state) {
      return ChangeNotifierProvider.value(
        value: state,
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: WorkoutDisplay(),
            ),
          ),
        ),
      );
    }

    testWidgets('renders with correct keys', (tester) async {
      final state = createState(steps: [
        const WorkoutStep(type: StepType.preparation, duration: 5, reps: 0),
      ]);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('workout__text-1')), findsOneWidget);
      expect(find.byKey(const Key('workout__text-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__text-3')), findsOneWidget);
    });

    testWidgets('displays formattedTime in chronometre', (tester) async {
      final state = createState(steps: [
        const WorkoutStep(type: StepType.preparation, duration: 5, reps: 0),
      ]);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.text('00:05'), findsOneWidget);
    });

    testWidgets('displays remainingReps when in work step', (tester) async {
      final state = createState(steps: [
        const WorkoutStep(type: StepType.work, duration: 40, reps: 3),
      ]);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);
      expect(state.currentStep, StepType.work);
    });

    testWidgets('displays remainingReps when in rest step', (tester) async {
      final state = createState(steps: [
        const WorkoutStep(type: StepType.rest, duration: 20, reps: 3),
      ]);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);
      expect(state.currentStep, StepType.rest);
    });

    testWidgets('hides remainingReps when in preparation step', (tester) async {
      final state = createState(steps: [
        const WorkoutStep(type: StepType.preparation, duration: 5, reps: 0),
      ]);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      final repsWidget = tester.widget<Visibility>(
        find.ancestor(
          of: find.byKey(const Key('workout__text-1')),
          matching: find.byType(Visibility),
        ),
      );
      expect(repsWidget.visible, false);
    });

    testWidgets('hides remainingReps when in cooldown step', (tester) async {
      final state = createState(steps: [
        const WorkoutStep(type: StepType.cooldown, duration: 10, reps: 0),
      ]);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      final repsWidget = tester.widget<Visibility>(
        find.ancestor(
          of: find.byKey(const Key('workout__text-1')),
          matching: find.byType(Visibility),
        ),
      );
      expect(repsWidget.visible, false);
    });

    testWidgets('displays "PRÉPARER" label for preparation step', (tester) async {
      final state = createState(steps: [
        const WorkoutStep(type: StepType.preparation, duration: 5, reps: 0),
      ]);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.text('PRÉPARER'), findsOneWidget);
    });

    testWidgets('displays "TRAVAIL" label for work step', (tester) async {
      final state = createState(steps: [
        const WorkoutStep(type: StepType.work, duration: 40, reps: 3),
      ]);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.text('TRAVAIL'), findsOneWidget);
    });

    testWidgets('displays "REPOS" label for rest step', (tester) async {
      final state = createState(steps: [
        const WorkoutStep(type: StepType.rest, duration: 20, reps: 3),
      ]);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.text('REPOS'), findsOneWidget);
    });

    testWidgets('displays "REFROIDIR" label for cooldown step', (tester) async {
      final state = createState(steps: [
        const WorkoutStep(type: StepType.cooldown, duration: 10, reps: 0),
      ]);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.text('REFROIDIR'), findsOneWidget);
    });
  });
}
