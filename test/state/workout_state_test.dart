import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/domain/step_type.dart';
import 'package:interval_counter/domain/workout_engine.dart';
import 'package:interval_counter/state/workout_state.dart';
import '../helpers/mock_services.dart';

void main() {
  late MockTickerService tickerService;
  late MockAudioService audioService;
  late MockPreferencesRepository prefsRepo;

  setUp(() {
    tickerService = MockTickerService();
    audioService = MockAudioService();
    prefsRepo = MockPreferencesRepository();
  });

  /// Creates a WorkoutState with a simple engine for testing.
  /// Uses withEngine to avoid starting the ticker automatically.
  WorkoutState createState({WorkoutEngine? engine}) {
    final e = engine ??
        WorkoutEngine.fromSteps([
          const WorkoutStep(type: StepType.preparation, duration: 5, reps: 0),
          const WorkoutStep(type: StepType.work, duration: 40, reps: 3),
          const WorkoutStep(type: StepType.rest, duration: 20, reps: 3),
          const WorkoutStep(type: StepType.cooldown, duration: 10, reps: 0),
        ]);

    return WorkoutState.withEngine(
      engine: e,
      tickerService: tickerService,
      audioService: audioService,
      prefsRepo: prefsRepo,
    );
  }

  group('WorkoutState — initial values', () {
    test('delegates getters to engine', () {
      final state = createState();

      expect(state.currentStep, StepType.preparation);
      expect(state.remainingTime, 5);
      expect(state.remainingReps, 0);
      expect(state.formattedTime, '00:05');
      expect(state.isComplete, false);
    });

    test('starts not paused and not exiting', () {
      final state = createState();

      expect(state.isPaused, false);
      expect(state.isExiting, false);
    });

    test('controls are initially visible', () {
      final state = createState();

      expect(state.controlsVisible, true);
    });

    test('loads volume from preferences', () async {
      await prefsRepo.set<double>('home_volume', 0.75);

      final state = createState();

      expect(state.volume, 0.75);
      expect(audioService.volume, 0.75);
    });

    test('uses default volume when no preference', () {
      final state = createState();

      expect(state.volume, 0.62);
    });
  });

  group('WorkoutState — togglePause', () {
    test('toggles isPaused and notifies listeners', () {
      final state = createState();
      var notified = false;
      state.addListener(() => notified = true);

      state.togglePause();

      expect(state.isPaused, true);
      expect(notified, true);
    });

    test('toggling twice returns to not paused', () {
      final state = createState();

      state.togglePause();
      state.togglePause();

      expect(state.isPaused, false);
    });
  });

  group('WorkoutState — nextStep', () {
    test('delegates to engine and notifies', () {
      final state = createState();
      var notified = false;
      state.addListener(() => notified = true);

      state.nextStep();

      expect(state.currentStep, StepType.work);
      expect(state.remainingTime, 40);
      expect(notified, true);
    });

    test('at last step sets isComplete', () {
      final engine = WorkoutEngine.fromSteps([
        const WorkoutStep(type: StepType.work, duration: 5, reps: 1),
      ]);
      final state = createState(engine: engine);

      state.nextStep();

      expect(state.isComplete, true);
    });
  });

  group('WorkoutState — previousStep', () {
    test('delegates to engine and notifies', () {
      final state = createState();
      state.nextStep(); // move to work
      var notified = false;
      state.addListener(() => notified = true);

      state.previousStep();

      expect(state.currentStep, StepType.preparation);
      expect(notified, true);
    });
  });

  group('WorkoutState — onScreenTap', () {
    test('sets controlsVisible to true and notifies', () {
      final state = createState();
      // Manually set controls invisible for test
      state.togglePause(); // pause so hide timer doesn't interfere
      var notified = false;
      state.addListener(() => notified = true);

      state.onScreenTap();

      expect(state.controlsVisible, true);
      expect(notified, true);
    });
  });

  group('WorkoutState — onVolumeChange', () {
    test('updates volume and notifies', () {
      final state = createState();
      var notified = false;
      state.addListener(() => notified = true);

      state.onVolumeChange(0.5);

      expect(state.volume, 0.5);
      expect(notified, true);
    });

    test('calls audioService.setVolume', () {
      final state = createState();

      state.onVolumeChange(0.3);

      expect(audioService.volume, 0.3);
    });

    test('saves volume to preferences', () async {
      final state = createState();

      state.onVolumeChange(0.8);

      // Verify the preference was set
      expect(prefsRepo.get<double>('home_volume'), 0.8);
    });

    test('clamps volume to 0.0-1.0', () {
      final state = createState();

      state.onVolumeChange(1.5);
      expect(state.volume, 1.0);

      state.onVolumeChange(-0.5);
      expect(state.volume, 0.0);
    });
  });

  group('WorkoutState — onLongPress', () {
    test('sets isExiting to true and notifies', () {
      final state = createState();
      var notified = false;
      state.addListener(() => notified = true);

      state.onLongPress();

      expect(state.isExiting, true);
      expect(notified, true);
    });
  });

  group('WorkoutState — formattedTime', () {
    test('delegates to engine formattedTime', () {
      final state = createState();

      expect(state.formattedTime, '00:05');
    });
  });

  group('WorkoutState — dispose', () {
    test('disposes services', () {
      final state = createState();

      state.dispose();

      expect(tickerService.disposed, true);
      expect(audioService.disposed, true);
    });
  });
}
