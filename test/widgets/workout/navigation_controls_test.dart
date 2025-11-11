import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/services/audio_service.dart';
import 'package:interval_counter/services/preferences_repository.dart';
import 'package:interval_counter/services/ticker_service.dart';
import 'package:interval_counter/models/preset.dart';
import 'package:interval_counter/state/workout_state.dart';
import 'package:interval_counter/widgets/workout/navigation_controls.dart';

import 'navigation_controls_test.mocks.dart';

@GenerateMocks([TickerService, AudioService, PreferencesRepository])
void main() {
  group('NavigationControls Widget Tests', () {
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
        child: const MaterialApp(
          home: Scaffold(
            body: NavigationControls(),
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

      // Then
      expect(find.byKey(const Key('workout__container-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__iconbutton-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__button-1')), findsOneWidget);
      expect(find.byKey(const Key('workout__iconbutton-3')), findsOneWidget);

      state.dispose();
    });

    testWidgets('displays skip_previous icon for previous button', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When
      await tester.pumpWidget(createTestWidget(state));

      // Then
      final iconButton = tester.widget<IconButton>(
        find.byKey(const Key('workout__iconbutton-2')),
      );
      final icon = iconButton.icon as Icon;
      expect(icon.icon, Icons.skip_previous);

      state.dispose();
    });

    testWidgets('displays skip_next icon for next button', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When
      await tester.pumpWidget(createTestWidget(state));

      // Then
      final iconButton = tester.widget<IconButton>(
        find.byKey(const Key('workout__iconbutton-3')),
      );
      final icon = iconButton.icon as Icon;
      expect(icon.icon, Icons.skip_next);

      state.dispose();
    });

    testWidgets('displays "Maintenir pour sortir" text', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When
      await tester.pumpWidget(createTestWidget(state));

      // Then
      expect(find.text('Maintenir pour sortir'), findsOneWidget);

      state.dispose();
    });

    testWidgets('tap on previous button calls previousStep', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      state.nextStep(); // Move to work step
      expect(state.currentStep.toString(), contains('work'));

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.tap(find.byKey(const Key('workout__iconbutton-2')));
      await tester.pumpAndSettle();

      // Then
      expect(state.currentStep.toString(), contains('preparation'));

      state.dispose();
    });

    testWidgets('tap on next button calls nextStep', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      expect(state.currentStep.toString(), contains('preparation'));

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.tap(find.byKey(const Key('workout__iconbutton-3')));
      await tester.pumpAndSettle();

      // Then
      expect(state.currentStep.toString(), contains('work'));

      state.dispose();
    });

    testWidgets('long press on exit button calls onLongPress', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      expect(state.isExiting, false);

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.longPress(find.byKey(const Key('workout__button-1')));
      await tester.pumpAndSettle();

      // Then
      expect(state.isExiting, true);

      state.dispose();
    });
  });
}
