import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/state/workout_state.dart';
import 'package:interval_counter/models/preset.dart';
import 'package:interval_counter/domain/workout_engine.dart';
import 'package:interval_counter/services/ticker_service.dart';
import 'package:interval_counter/services/audio_service.dart';
import 'package:interval_counter/services/preferences_repository.dart';

// Mock implementations for testing
class MockTickerService implements TickerService {
  bool disposed = false;
  
  @override
  Stream<int> createTicker(Duration interval) {
    return Stream.periodic(interval, (count) => count + 1);
  }
  
  @override
  void dispose() {
    disposed = true;
  }
}

class MockAudioService implements AudioService {
  double _volume = 0.9;
  bool _isEnabled = true;
  int beepCount = 0;
  
  @override
  void playBeep() {
    beepCount++;
  }
  
  @override
  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
  }
  
  @override
  double get volume => _volume;
  
  @override
  bool get isEnabled => _isEnabled;
  
  @override
  set isEnabled(bool value) {
    _isEnabled = value;
  }
}

class MockPreferencesRepository implements PreferencesRepository {
  final Map<String, dynamic> _storage = {};
  
  @override
  T? get<T>(String key) {
    final value = _storage[key];
    if (value is T) return value;
    return null;
  }
  
  @override
  Future<void> set<T>(String key, T value) async {
    _storage[key] = value;
  }
  
  @override
  Future<void> remove(String key) async {
    _storage.remove(key);
  }
  
  @override
  Future<void> clear() async {
    _storage.clear();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('WorkoutState', () {
    late MockTickerService tickerService;
    late MockAudioService audioService;
    late MockPreferencesRepository prefsRepo;
    late Preset testPreset;

    setUp(() {
      tickerService = MockTickerService();
      audioService = MockAudioService();
      prefsRepo = MockPreferencesRepository();
      
      // Preset de test: 5/3x(40/20)/10
      testPreset = Preset.create(
        name: 'Test',
        prepareSeconds: 5,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 10,
      );
    });

    WorkoutState createState(Preset preset, {VoidCallback? onComplete}) {
      return WorkoutState(
        preset: preset,
        tickerService: MockTickerService(),
        audioService: MockAudioService(),
        prefsRepo: MockPreferencesRepository(),
        onWorkoutComplete: onComplete,
      );
    }

    test('initial values are correct', () {
      final state = createState(testPreset);
      
      expect(state.currentStep, StepType.preparation);
      expect(state.remainingTime, 5);
      expect(state.remainingReps, 3);
      expect(state.isPaused, false);
      expect(state.volume, 0.9);
      expect(state.soundEnabled, true);
      expect(state.controlsVisible, true);
      
      state.dispose();
    });

    test('formattedTime formats correctly', () {
      final state = createState(testPreset);
      
      expect(state.formattedTime, '00:05');
      
      state.dispose();
    });

    test('stepLabel returns correct label for each step', () {
      final state = createState(testPreset);
      
      expect(state.stepLabel, 'PRÉPARER');
      
      state.dispose();
    });

    test('shouldShowRepsCounter is false for preparation', () {
      final state = createState(testPreset);
      
      expect(state.shouldShowRepsCounter, false);
      
      state.dispose();
    });

    test('tick decrements remainingTime', () {
      final state = createState(testPreset);
      
      final initialTime = state.remainingTime;
      state.tick();
      
      expect(state.remainingTime, initialTime - 1);
      
      state.dispose();
    });

    test('nextStep transitions preparation -> work', () {
      final state = createState(testPreset);
      
      state.nextStep();
      
      expect(state.currentStep, StepType.work);
      expect(state.remainingTime, 40);
      expect(state.remainingReps, 3);
      
      state.dispose();
    });

    test('nextStep transitions work -> rest', () {
      final state = createState(testPreset);
      
      // Aller à work
      state.nextStep();
      
      // work -> rest
      state.nextStep();
      
      expect(state.currentStep, StepType.rest);
      expect(state.remainingTime, 20);
      expect(state.remainingReps, 2);
      
      state.dispose();
    });

    test('nextStep transitions rest -> work (when reps > 0)', () {
      final state = createState(testPreset);
      
      // prep -> work -> rest
      state.nextStep();
      state.nextStep();
      
      // rest -> work
      state.nextStep();
      
      expect(state.currentStep, StepType.work);
      expect(state.remainingTime, 40);
      expect(state.remainingReps, 2);
      
      state.dispose();
    });

    test('nextStep skips rest on last rep and goes to cooldown', () {
      final state = createState(testPreset);
      
      // Simulation: aller jusqu'à la dernière répétition
      state.nextStep(); // prep -> work
      state.nextStep(); // work -> rest (reps=2)
      state.nextStep(); // rest -> work (reps=2)
      state.nextStep(); // work -> rest (reps=1)
      state.nextStep(); // rest -> work (reps=1)
      state.nextStep(); // work -> cooldown (dernière rep, pas de rest)
      
      expect(state.currentStep, StepType.cooldown);
      expect(state.remainingTime, 10);
      
      state.dispose();
    });

    test('nextStep with zero cooldown ends workout', () async {
      final presetNoCooldown = Preset.create(
        name: 'Test No Cooldown',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 1,
        restSeconds: 0,
        cooldownSeconds: 0,
      );
      
      bool workoutEnded = false;
      final state = createState(presetNoCooldown, onComplete: () {
        workoutEnded = true;
      });
      
      state.nextStep(); // work -> end
      
      expect(workoutEnded, true);
      
      state.dispose();
    });

    test('preset with zero preparation starts at work', () {
      final presetNoPrep = Preset.create(
        name: 'Test No Prep',
        prepareSeconds: 0,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 10,
      );
      
      final state = createState(presetNoPrep);
      
      expect(state.currentStep, StepType.work);
      expect(state.remainingTime, 40);
      
      state.dispose();
    });

    test('previousStep goes back from work to preparation', () {
      final state = createState(testPreset);
      
      state.nextStep(); // prep -> work
      state.previousStep(); // work -> prep
      
      expect(state.currentStep, StepType.preparation);
      expect(state.remainingTime, 5);
      
      state.dispose();
    });

    test('previousStep goes back from rest to work', () {
      final state = createState(testPreset);
      
      state.nextStep(); // prep -> work
      state.nextStep(); // work -> rest
      state.previousStep(); // rest -> work
      
      expect(state.currentStep, StepType.work);
      expect(state.remainingTime, 40);
      expect(state.remainingReps, 3);
      
      state.dispose();
    });

    test('togglePause toggles isPaused', () {
      final state = createState(testPreset);
      
      expect(state.isPaused, false);
      
      state.togglePause(); // Pause
      expect(state.isPaused, true);
      
      state.togglePause(); // Resume
      expect(state.isPaused, false);
      
      state.dispose();
    });

    test('onVolumeChange updates volume', () {
      final state = WorkoutState(
        preset: testPreset,
        tickerService: tickerService,
        audioService: audioService,
        prefsRepo: prefsRepo,
      );
      
      state.onVolumeChange(0.5);
      expect(state.volume, 0.5);
      expect(audioService.volume, 0.5);
      
      state.dispose();
    });

    test('onVolumeChange clamps value between 0 and 1', () {
      final state = WorkoutState(
        preset: testPreset,
        tickerService: tickerService,
        audioService: audioService,
        prefsRepo: prefsRepo,
      );
      
      state.onVolumeChange(1.5);
      expect(state.volume, 1.0);
      
      state.onVolumeChange(-0.5);
      expect(state.volume, 0.0);
      
      state.dispose();
    });

    test('toggleSound toggles soundEnabled', () {
      final state = WorkoutState(
        preset: testPreset,
        tickerService: tickerService,
        audioService: audioService,
        prefsRepo: prefsRepo,
      );
      
      expect(state.soundEnabled, true);
      
      state.toggleSound();
      expect(state.soundEnabled, false);
      
      state.toggleSound();
      expect(state.soundEnabled, true);
      
      state.dispose();
    });

    test('onScreenTap shows controls', () {
      final state = createState(testPreset);
      
      state.onScreenTap();
      expect(state.controlsVisible, true);
      
      state.dispose();
    });

    test('exitWorkout calls onWorkoutComplete', () async {
      bool workoutEnded = false;
      final state = createState(testPreset, onComplete: () {
        workoutEnded = true;
      });
      
      state.exitWorkout();
      
      expect(workoutEnded, true);
      
      state.dispose();
    });

    test('persistence saves and loads volume', () async {
      final state1 = WorkoutState(
        preset: testPreset,
        tickerService: MockTickerService(),
        audioService: audioService,
        prefsRepo: prefsRepo,
      );
      
      state1.onVolumeChange(0.75);
      state1.dispose();
      
      // Vérifier la persistence
      expect(prefsRepo.get<double>('workout_volume'), 0.75);
      
      // Nouveau state devrait charger la valeur
      final audioService2 = MockAudioService();
      audioService2.setVolume(prefsRepo.get<double>('workout_volume') ?? 0.9);
      
      final state2 = WorkoutState(
        preset: testPreset,
        tickerService: MockTickerService(),
        audioService: audioService2,
        prefsRepo: prefsRepo,
      );
      expect(state2.volume, 0.75);
      
      state2.dispose();
    });

    test('persistence saves and loads soundEnabled', () async {
      final state1 = WorkoutState(
        preset: testPreset,
        tickerService: MockTickerService(),
        audioService: audioService,
        prefsRepo: prefsRepo,
      );
      
      state1.toggleSound();
      state1.dispose();
      
      // Vérifier la persistence
      expect(prefsRepo.get<bool>('workout_sound_enabled'), false);
    });

    test('tick at remainingTime=3 calls playBeep', () {
      final state = WorkoutState(
        preset: testPreset,
        tickerService: tickerService,
        audioService: audioService,
        prefsRepo: prefsRepo,
      );
      
      // Mettre le temps à 3 secondes
      while (state.remainingTime > 3) {
        state.tick();
      }
      
      expect(state.remainingTime, 3);
      
      final initialBeepCount = audioService.beepCount;
      state.tick();
      
      // Devrait avoir joué un bip
      expect(audioService.beepCount, initialBeepCount + 1);
      expect(state.remainingTime, 2);
      
      state.dispose();
    });

    test('tick at remainingTime=0 calls nextStep', () {
      final state = createState(testPreset);
      
      // Réduire à 0
      while (state.remainingTime > 0) {
        state.tick();
      }
      
      // Tick à 0 devrait passer à l'étape suivante
      final initialStep = state.currentStep;
      state.tick();
      
      expect(state.currentStep, isNot(initialStep));
      
      state.dispose();
    });

    test('dispose cancels timers and calls tickerService.dispose', () {
      final state = WorkoutState(
        preset: testPreset,
        tickerService: tickerService,
        audioService: audioService,
        prefsRepo: prefsRepo,
      );
      
      state.dispose();
      
      expect(tickerService.disposed, true);
    });
  });
}
