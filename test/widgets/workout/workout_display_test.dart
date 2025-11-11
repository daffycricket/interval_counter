import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/domain/step_type.dart';
import 'package:interval_counter/services/audio_service.dart';
import 'package:interval_counter/services/preferences_repository.dart';
import 'package:interval_counter/services/ticker_service.dart';
import 'package:interval_counter/models/preset.dart';
import 'package:interval_counter/state/workout_state.dart';
import 'package:interval_counter/widgets/workout/workout_display.dart';

import 'workout_display_test.mocks.dart';

@GenerateMocks([TickerService, AudioService, PreferencesRepository])
void main() {
  group('WorkoutDisplay Widget Tests', () {
    late MockTickerService mockTickerService;
    late MockAudioService mockAudioService;
    late MockPreferencesRepository mockPrefsRepo;
    late Preset testPreset;
    late StreamController<int> tickerController;

    setUp(() {
      mockTickerService = MockTickerService();
      mockAudioService = MockAudioService();
      mockPrefsRepo = MockPreferencesRepository();
      tickerController = StreamController<int>();

      testPreset = Preset(
        id: 'test',
        name: 'Test Preset',
        prepareSeconds: 5,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 10,
      );

      when(mockTickerService.createTicker(any)).thenAnswer((_) {
        final newController = StreamController<int>();
        return newController.stream;
      });
      when(mockPrefsRepo.get<double>('volume_level')).thenReturn(0.62);
      when(mockAudioService.setVolume(any)).thenReturn(null);
      when(mockTickerService.dispose()).thenReturn(null);
      when(mockAudioService.dispose()).thenReturn(null);
    });

    tearDown(() {
      tickerController.close();
    });

    Widget createTestWidget(WorkoutState state) {
      return ChangeNotifierProvider.value(
        value: state,
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: const WorkoutDisplay(),
            ),
          ),
        ),
      );
    }

    testWidgets('renders with correct keys', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      // Then
      expect(find.byKey(const Key('workout__text-1')), findsOneWidget);
      expect(find.byKey(const Key('workout__text-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__text-3')), findsOneWidget);

      state.dispose();
    });

    testWidgets('displays formattedTime in chronomètre', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('00:05'), findsOneWidget); // 5 seconds formatted

      state.dispose();
    });

    testWidgets('displays remainingReps when in work step', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      state.nextStep(); // Move to work step

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('3'), findsOneWidget); // 3 reps remaining
      expect(state.currentStep, StepType.work);

      state.dispose();
    });

    testWidgets('displays remainingReps when in rest step', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      state.nextStep(); // Move to work
      state.nextStep(); // Move to rest

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('2'), findsOneWidget); // 2 reps remaining after work→rest transition
      expect(state.currentStep, StepType.rest);

      state.dispose();
    });

    testWidgets('hides remainingReps when in preparation step', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      // Then
      final repsWidget = tester.widget<Visibility>(
        find.ancestor(
          of: find.byKey(const Key('workout__text-1')),
          matching: find.byType(Visibility),
        ),
      );
      expect(repsWidget.visible, false);
      expect(state.currentStep, StepType.preparation);

      state.dispose();
    });

    testWidgets('hides remainingReps when in cooldown step', (tester) async {
      // Given
      final preset = Preset(
        id: 'test',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 1,
        restSeconds: 0,
        cooldownSeconds: 10,
      );
      final state = WorkoutState(
        preset: preset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      state.tick(); // work → cooldown

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      // Then
      final repsWidget = tester.widget<Visibility>(
        find.ancestor(
          of: find.byKey(const Key('workout__text-1')),
          matching: find.byType(Visibility),
        ),
      );
      expect(repsWidget.visible, false);
      expect(state.currentStep, StepType.cooldown);

      state.dispose();
    });

    testWidgets('displays "PRÉPARER" label for preparation step', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('PRÉPARER'), findsOneWidget);
      expect(state.currentStep, StepType.preparation);

      state.dispose();
    });

    testWidgets('displays "TRAVAIL" label for work step', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      state.nextStep(); // Move to work

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('TRAVAIL'), findsOneWidget);
      expect(state.currentStep, StepType.work);

      state.dispose();
    });

    testWidgets('displays "REPOS" label for rest step', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      state.nextStep(); // Move to work
      state.nextStep(); // Move to rest

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('REPOS'), findsOneWidget);
      expect(state.currentStep, StepType.rest);

      state.dispose();
    });

    testWidgets('displays "REFROIDIR" label for cooldown step', (tester) async {
      // Given
      final preset = Preset(
        id: 'test',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 1,
        restSeconds: 0,
        cooldownSeconds: 10,
      );
      final state = WorkoutState(
        preset: preset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      state.tick(); // work → cooldown

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('REFROIDIR'), findsOneWidget);
      expect(state.currentStep, StepType.cooldown);

      state.dispose();
    });
  });
}
