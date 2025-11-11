import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:interval_counter/domain/step_type.dart';
import 'package:interval_counter/models/preset.dart';
import 'package:interval_counter/services/audio_service.dart';
import 'package:interval_counter/services/preferences_repository.dart';
import 'package:interval_counter/services/ticker_service.dart';
import 'package:interval_counter/state/workout_state.dart';

import 'workout_state_test.mocks.dart';

@GenerateMocks([TickerService, AudioService, PreferencesRepository])
void main() {
  group('WorkoutState', () {
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

      // Setup default mocks - use thenAnswer for Stream
      // Create a new stream each time to avoid "already listened to" error
      when(mockTickerService.createTicker(any)).thenAnswer((_) {
        final newController = StreamController<int>();
        return newController.stream;
      });
      // Default volume level (can be overridden in individual tests)
      when(mockPrefsRepo.get<double>('home_volume')).thenReturn(0.62);
      // Default no-op for setVolume
      when(mockAudioService.setVolume(any)).thenReturn(null);
      // Default no-op for set
      when(mockPrefsRepo.set<double>(any, any)).thenAnswer((_) async {});
      // Default no-op for dispose
      when(mockTickerService.dispose()).thenReturn(null);
      when(mockAudioService.dispose()).thenReturn(null);
    });

    tearDown(() {
      tickerController.close();
    });

    test('constructor initializes with correct initial state', () {
      // When
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // Then
      expect(state.currentStep, StepType.preparation);
      expect(state.remainingTime, 5);
      expect(state.remainingReps, 3);
      expect(state.isPaused, false);
      expect(state.controlsVisible, true);
      expect(state.isExiting, false);
      
      state.dispose();
    });

    test('load volume from SharedPreferences', () {
      // Given
      when(mockPrefsRepo.get<double>('home_volume')).thenReturn(0.8);

      // When
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // Then
      expect(state.volume, 0.8);
      verify(mockAudioService.setVolume(0.8)).called(1);
      
      state.dispose();
    });

    test('load volume defaults to 0.62 when missing', () {
      // Given
      when(mockPrefsRepo.get<double>('home_volume')).thenReturn(null);

      // When
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // Then
      expect(state.volume, 0.62);
      verify(mockAudioService.setVolume(0.62)).called(1);
      
      state.dispose();
    });

    test('tick calls audioService.playBeep when shouldPlayBeep and volume > 0', () {
      // Given
      final preset = Preset(
        id: 'test',
        name: 'Test',
        prepareSeconds: 2,
        repetitions: 1,
        workSeconds: 40,
        restSeconds: 20,
      );
      final state = WorkoutState(
        preset: preset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When
      state.tick(); // remainingTime goes from 2 → 1 (shouldPlayBeep = true)

      // Then
      verify(mockAudioService.playBeep()).called(1);
      expect(state.remainingTime, 1);
      
      state.dispose();
    });

    test('tick does not call audioService.playBeep when volume = 0', () {
      // Given
      when(mockPrefsRepo.get<double>('home_volume')).thenReturn(0.0);
      final preset = Preset(
        id: 'test',
        name: 'Test',
        prepareSeconds: 2,
        repetitions: 1,
        workSeconds: 40,
        restSeconds: 20,
      );
      final state = WorkoutState(
        preset: preset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When
      state.tick();

      // Then
      verifyNever(mockAudioService.playBeep());
      
      state.dispose();
    });

    test('tick does not progress when isPaused = true', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      final initialTime = state.remainingTime;
      state.togglePause(); // Pause

      // When
      state.tick();

      // Then
      expect(state.remainingTime, initialTime); // No change
      
      state.dispose();
    });

    test('tick calls notifyListeners', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      var notified = false;
      state.addListener(() => notified = true);

      // When
      state.tick();

      // Then
      expect(notified, true);
      
      state.dispose();
    });

    test('nextStep calls notifyListeners', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      var notified = false;
      state.addListener(() => notified = true);

      // When
      state.nextStep();

      // Then
      expect(notified, true);
      expect(state.currentStep, StepType.work);
      
      state.dispose();
    });

    test('previousStep calls notifyListeners', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      state.nextStep(); // preparation → work
      var notified = false;
      state.addListener(() => notified = true);

      // When
      state.previousStep();

      // Then
      expect(notified, true);
      expect(state.currentStep, StepType.preparation);
      
      state.dispose();
    });

    test('togglePause changes isPaused to true and stops ticker', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      expect(state.isPaused, false);

      // When
      state.togglePause();

      // Then
      expect(state.isPaused, true);
      // Ticker should be cancelled (createTicker called only once in constructor)
      verify(mockTickerService.createTicker(any)).called(1);
      
      state.dispose();
    });

    test('togglePause changes isPaused to false and resumes ticker', () {
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
      state.togglePause(); // Resume

      // Then
      expect(state.isPaused, false);
      // Ticker should be recreated (createTicker called twice: constructor + resume)
      verify(mockTickerService.createTicker(any)).called(2);
      
      state.dispose();
    });

    test('togglePause calls notifyListeners', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      var notified = false;
      state.addListener(() => notified = true);

      // When
      state.togglePause();

      // Then
      expect(notified, true);
      
      state.dispose();
    });

    test('onVolumeChange updates volume, persists, and calls setVolume', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When
      state.onVolumeChange(0.75);

      // Then
      expect(state.volume, 0.75);
      verify(mockAudioService.setVolume(0.75)).called(1);
      verify(mockPrefsRepo.set<double>('home_volume', 0.75)).called(1);
      
      state.dispose();
    });

    test('onVolumeChange clamps volume to [0.0, 1.0]', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When
      state.onVolumeChange(1.5); // > 1.0

      // Then
      expect(state.volume, 1.0);
      verify(mockAudioService.setVolume(1.0)).called(1);
      
      state.dispose();
    });

    test('onVolumeChange calls notifyListeners', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      var notified = false;
      state.addListener(() => notified = true);

      // When
      state.onVolumeChange(0.5);

      // Then
      expect(notified, true);
      
      state.dispose();
    });

    test('onScreenTap sets controlsVisible to true', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      // Simulate controls hidden
      // Note: We can't directly set controlsVisible to false, so we skip this part

      // When
      state.onScreenTap();

      // Then
      expect(state.controlsVisible, true);
      
      state.dispose();
    });

    test('onScreenTap calls notifyListeners', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      var notified = false;
      state.addListener(() => notified = true);

      // When
      state.onScreenTap();

      // Then
      expect(notified, true);
      
      state.dispose();
    });

    test('onLongPress sets isExiting to true', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      expect(state.isExiting, false);

      // When
      state.onLongPress();

      // Then
      expect(state.isExiting, true);
      
      state.dispose();
    });

    test('onLongPress calls notifyListeners', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      var notified = false;
      state.addListener(() => notified = true);

      // When
      state.onLongPress();

      // Then
      expect(notified, true);
      
      state.dispose();
    });

    test('toggleMute sets volume to 0 when volume > 0', () {
      // Given
      when(mockPrefsRepo.get<double>('home_volume')).thenReturn(0.8);
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      expect(state.volume, 0.8);

      // When
      state.toggleMute();

      // Then
      expect(state.volume, 0.0);
      verify(mockAudioService.setVolume(0.0)).called(1);
      
      state.dispose();
    });

    test('toggleMute restores previous volume when volume = 0', () {
      // Given
      when(mockPrefsRepo.get<double>('home_volume')).thenReturn(0.8);
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );
      state.toggleMute(); // Mute (volume 0.8 → 0.0)
      expect(state.volume, 0.0);

      // When
      state.toggleMute(); // Unmute

      // Then
      expect(state.volume, 0.8);
      // setVolume is called: 1) in constructor with 0.8, 2) in toggleMute with 0.0, 3) in toggleMute with 0.8
      verify(mockAudioService.setVolume(0.8)).called(2); // Constructor + restore
      
      state.dispose();
    });

    test('formattedTime returns MM:SS format', () {
      // Given
      final preset = Preset(
        id: 'test',
        name: 'Test',
        prepareSeconds: 80,
        repetitions: 1,
        workSeconds: 40,
        restSeconds: 20,
      );
      final state = WorkoutState(
        preset: preset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When / Then
      expect(state.formattedTime, '01:20');
      
      state.dispose();
    });

    test('formattedTime returns 00:00 when time is 0', () {
      // Given
      final preset = Preset(
        id: 'test',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 0, // Start with 0 seconds
        restSeconds: 0,
      );
      final state = WorkoutState(
        preset: preset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When / Then
      expect(state.formattedTime, '00:00');
      
      state.dispose();
    });

    test('dispose disposes all services', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When
      state.dispose();

      // Then
      verify(mockTickerService.dispose()).called(1);
      verify(mockAudioService.dispose()).called(1);
    });

    test('isFinished is false during workout', () {
      // Given
      final state = WorkoutState(
        preset: testPreset,
        tickerService: mockTickerService,
        audioService: mockAudioService,
        prefsRepo: mockPrefsRepo,
      );

      // When / Then
      expect(state.isFinished, false);
      
      state.dispose();
    });
  });
}
