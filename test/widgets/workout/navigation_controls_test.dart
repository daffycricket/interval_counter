import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/domain/step_type.dart';
import 'package:interval_counter/domain/workout_engine.dart';
import 'package:interval_counter/state/workout_state.dart';
import 'package:interval_counter/widgets/workout/navigation_controls.dart';

import '../../helpers/mock_services.dart';

void main() {
  group('NavigationControls Widget Tests', () {
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
          const WorkoutStep(type: StepType.rest, duration: 20, reps: 3),
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
            body: NavigationControls(),
          ),
        ),
      );
    }

    testWidgets('renders with correct keys', (tester) async {
      final state = createState();

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('workout__container-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__iconbutton-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__button-1')), findsOneWidget);
      expect(find.byKey(const Key('workout__iconbutton-3')), findsOneWidget);
    });

    testWidgets('displays skip_previous icon for previous button', (tester) async {
      final state = createState();

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      final iconButton = tester.widget<IconButton>(
        find.byKey(const Key('workout__iconbutton-2')),
      );
      final icon = iconButton.icon as Icon;
      expect(icon.icon, Icons.skip_previous);
    });

    testWidgets('displays skip_next icon for next button', (tester) async {
      final state = createState();

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      final iconButton = tester.widget<IconButton>(
        find.byKey(const Key('workout__iconbutton-3')),
      );
      final icon = iconButton.icon as Icon;
      expect(icon.icon, Icons.skip_next);
    });

    testWidgets('displays localized exit button text', (tester) async {
      final state = createState();

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.text('Maintenir pour sortir'), findsOneWidget);
    });

    testWidgets('tap on previous button calls previousStep', (tester) async {
      final state = createState();
      state.nextStep(); // Move to work
      expect(state.currentStep, StepType.work);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('workout__iconbutton-2')));
      await tester.pumpAndSettle();

      expect(state.currentStep, StepType.preparation);
    });

    testWidgets('tap on next button calls nextStep', (tester) async {
      final state = createState();
      expect(state.currentStep, StepType.preparation);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('workout__iconbutton-3')));
      await tester.pumpAndSettle();

      expect(state.currentStep, StepType.work);
    });

    testWidgets('long press on exit button calls onLongPress', (tester) async {
      final state = createState();
      expect(state.isExiting, false);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();
      await tester.longPress(find.byKey(const Key('workout__button-1')));
      await tester.pumpAndSettle();

      expect(state.isExiting, true);
    });
  });
}
