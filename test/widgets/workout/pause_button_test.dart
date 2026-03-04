import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/domain/step_type.dart';
import 'package:interval_counter/domain/workout_engine.dart';
import 'package:interval_counter/state/workout_state.dart';
import 'package:interval_counter/widgets/workout/pause_button.dart';

import '../../helpers/mock_services.dart';

void main() {
  group('PauseButton Widget Tests', () {
    late MockTickerService mockTickerService;
    late MockAudioService mockAudioService;
    late MockPreferencesRepository mockPrefsRepo;

    setUp(() {
      mockTickerService = MockTickerService();
      mockAudioService = MockAudioService();
      mockPrefsRepo = MockPreferencesRepository();
    });

    WorkoutState createState() {
      return WorkoutState.withEngine(
        engine: WorkoutEngine.fromSteps([
          const WorkoutStep(type: StepType.work, duration: 40, reps: 3),
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
            body: PauseButton(),
          ),
        ),
      );
    }

    testWidgets('renders with correct key', (tester) async {
      final state = createState();

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('workout__iconbutton-4')), findsOneWidget);
    });

    testWidgets('displays pause icon when isPaused = false', (tester) async {
      final state = createState();
      expect(state.isPaused, false);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      final fab = tester.widget<FloatingActionButton>(
        find.byKey(const Key('workout__iconbutton-4')),
      );
      final icon = fab.child as Icon;
      expect(icon.icon, Icons.pause);
    });

    testWidgets('displays play_arrow icon when isPaused = true', (tester) async {
      final state = createState();
      state.togglePause();
      expect(state.isPaused, true);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      final fab = tester.widget<FloatingActionButton>(
        find.byKey(const Key('workout__iconbutton-4')),
      );
      final icon = fab.child as Icon;
      expect(icon.icon, Icons.play_arrow);
    });

    testWidgets('tap on button calls togglePause', (tester) async {
      final state = createState();
      expect(state.isPaused, false);

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('workout__iconbutton-4')));
      await tester.pumpAndSettle();

      expect(state.isPaused, true);
    });

    testWidgets('tap twice toggles pause state back', (tester) async {
      final state = createState();

      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('workout__iconbutton-4')));
      await tester.pumpAndSettle();
      expect(state.isPaused, true);

      await tester.tap(find.byKey(const Key('workout__iconbutton-4')));
      await tester.pumpAndSettle();
      expect(state.isPaused, false);

      // Dispose to cancel pending timers
      state.dispose();
    });
  });
}
