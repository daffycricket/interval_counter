import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/domain/step_type.dart';
import 'package:interval_counter/domain/workout_engine.dart';
import 'package:interval_counter/state/workout_state.dart';
import 'package:interval_counter/widgets/workout/workout_display.dart';
import 'package:interval_counter/widgets/workout/navigation_controls.dart';
import 'package:interval_counter/widgets/workout/pause_button.dart';

import '../helpers/mock_services.dart';

void main() {
  group('WorkoutScreen integration', () {
    late MockTickerService mockTickerService;
    late MockAudioService mockAudioService;
    late MockPreferencesRepository mockPrefsRepo;

    setUp(() {
      mockTickerService = MockTickerService();
      mockAudioService = MockAudioService();
      mockPrefsRepo = MockPreferencesRepository();
    });

    WorkoutState createState({List<WorkoutStep>? steps}) {
      return WorkoutState.withEngine(
        engine: WorkoutEngine.fromSteps(steps ?? [
          const WorkoutStep(type: StepType.preparation, duration: 5, reps: 0),
          const WorkoutStep(type: StepType.work, duration: 40, reps: 3),
          const WorkoutStep(type: StepType.cooldown, duration: 10, reps: 0),
        ]),
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
              child: Column(
                children: [
                  NavigationControls(),
                  WorkoutDisplay(),
                  PauseButton(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('all key workout components are present', (tester) async {
      final state = createState();

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      // Navigation controls
      expect(find.byKey(const Key('workout__container-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__iconbutton-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__button-1')), findsOneWidget);
      expect(find.byKey(const Key('workout__iconbutton-3')), findsOneWidget);

      // Display
      expect(find.byKey(const Key('workout__text-1')), findsOneWidget);
      expect(find.byKey(const Key('workout__text-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__text-3')), findsOneWidget);

      // Pause button
      expect(find.byKey(const Key('workout__iconbutton-4')), findsOneWidget);
    });

    testWidgets('navigation flow: next then previous', (tester) async {
      final state = createState();
      expect(state.currentStep, StepType.preparation);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      // Tap next
      await tester.tap(find.byKey(const Key('workout__iconbutton-3')));
      await tester.pumpAndSettle();
      expect(state.currentStep, StepType.work);

      // Tap previous
      await tester.tap(find.byKey(const Key('workout__iconbutton-2')));
      await tester.pumpAndSettle();
      expect(state.currentStep, StepType.preparation);
    });

    testWidgets('pause and resume flow via state', (tester) async {
      final state = createState();

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      // Pause via state (FAB may be off-screen in test viewport)
      state.togglePause();
      await tester.pumpAndSettle();
      expect(state.isPaused, true);

      // Resume via state
      state.togglePause();
      await tester.pumpAndSettle();
      expect(state.isPaused, false);

      // Dispose to cancel pending timers
      state.dispose();
    });
  });
}
