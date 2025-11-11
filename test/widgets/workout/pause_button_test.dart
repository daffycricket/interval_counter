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
import 'package:interval_counter/widgets/workout/pause_button.dart';

import 'pause_button_test.mocks.dart';

@GenerateMocks([TickerService, AudioService, PreferencesRepository])
void main() {
  group('PauseButton Widget Tests', () {
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
            body: PauseButton(),
          ),
        ),
      );
    }

    testWidgets('renders with correct key', (tester) async {
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
      expect(find.byKey(const Key('workout__iconbutton-4')), findsOneWidget);

      state.dispose();
    });

    testWidgets('displays pause icon when isPaused = false', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      expect(state.isPaused, false);

      // When
      await tester.pumpWidget(createTestWidget(state));

      // Then
      final fab = tester.widget<FloatingActionButton>(
        find.byKey(const Key('workout__iconbutton-4')),
      );
      final icon = fab.child as Icon;
      expect(icon.icon, Icons.pause);

      state.dispose();
    });

    testWidgets('displays play_arrow icon when isPaused = true', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      state.togglePause(); // Pause
      expect(state.isPaused, true);

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.pumpAndSettle();

      // Then
      final fab = tester.widget<FloatingActionButton>(
        find.byKey(const Key('workout__iconbutton-4')),
      );
      final icon = fab.child as Icon;
      expect(icon.icon, Icons.play_arrow);

      state.dispose();
    });

    testWidgets('tap on button calls togglePause', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      expect(state.isPaused, false);

      // When
      await tester.pumpWidget(createTestWidget(state));
      await tester.tap(find.byKey(const Key('workout__iconbutton-4')));
      await tester.pumpAndSettle();

      // Then
      expect(state.isPaused, true);

      state.dispose();
    });

    testWidgets('tap on button toggles pause state', (tester) async {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When
      await tester.pumpWidget(createTestWidget(state));
      
      // First tap: pause
      await tester.tap(find.byKey(const Key('workout__iconbutton-4')));
      await tester.pumpAndSettle();
      expect(state.isPaused, true);
      
      // Second tap: resume
      await tester.tap(find.byKey(const Key('workout__iconbutton-4')));
      await tester.pumpAndSettle();
      expect(state.isPaused, false);

      state.dispose();
    });
  });
}
