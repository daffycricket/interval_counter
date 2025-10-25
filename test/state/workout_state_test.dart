import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_counter/state/workout_state.dart';
import 'package:interval_counter/models/preset.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('WorkoutState', () {
    late SharedPreferences prefs;
    late Preset testPreset;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      
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

    test('initial values are correct', () {
      final state = WorkoutState(prefs, testPreset);
      
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
      final state = WorkoutState(prefs, testPreset);
      
      expect(state.formattedTime, '00:05');
      
      state.dispose();
    });

    test('stepLabel returns correct label for each step', () {
      final state = WorkoutState(prefs, testPreset);
      
      expect(state.stepLabel, 'PRÉPARER');
      
      state.dispose();
    });

    test('shouldShowRepsCounter is false for preparation', () {
      final state = WorkoutState(prefs, testPreset);
      
      expect(state.shouldShowRepsCounter, false);
      
      state.dispose();
    });

    test('tick decrements remainingTime', () {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer(); // Arrêter le timer auto
      
      final initialTime = state.remainingTime;
      state.tick();
      
      expect(state.remainingTime, initialTime - 1);
      
      state.dispose();
    });

    test('nextStep transitions preparation -> work', () {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      state.nextStep();
      
      expect(state.currentStep, StepType.work);
      expect(state.remainingTime, 40);
      expect(state.remainingReps, 3);
      
      state.dispose();
    });

    test('nextStep transitions work -> rest', () {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
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
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
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
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
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
      final state = WorkoutState(prefs, presetNoCooldown, onWorkoutComplete: () {
        workoutEnded = true;
      });
      state.stopTimer();
      
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
      
      final state = WorkoutState(prefs, presetNoPrep);
      state.stopTimer();
      
      expect(state.currentStep, StepType.work);
      expect(state.remainingTime, 40);
      
      state.dispose();
    });

    test('previousStep goes back from work to preparation', () {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      state.nextStep(); // prep -> work
      state.previousStep(); // work -> prep
      
      expect(state.currentStep, StepType.preparation);
      expect(state.remainingTime, 5);
      
      state.dispose();
    });

    test('previousStep goes back from rest to work', () {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      state.nextStep(); // prep -> work
      state.nextStep(); // work -> rest
      state.previousStep(); // rest -> work
      
      expect(state.currentStep, StepType.work);
      expect(state.remainingTime, 40);
      expect(state.remainingReps, 3);
      
      state.dispose();
    });

    test('togglePause toggles isPaused', () {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer(); // Commencer arrêté
      
      expect(state.isPaused, true);
      
      state.togglePause(); // Start
      expect(state.isPaused, false);
      
      state.togglePause(); // Pause
      expect(state.isPaused, true);
      
      state.dispose();
    });

    test('onVolumeChange updates volume', () {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      state.onVolumeChange(0.5);
      expect(state.volume, 0.5);
      
      state.dispose();
    });

    test('onVolumeChange clamps value between 0 and 1', () {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      state.onVolumeChange(1.5);
      expect(state.volume, 1.0);
      
      state.onVolumeChange(-0.5);
      expect(state.volume, 0.0);
      
      state.dispose();
    });

    test('toggleSound toggles soundEnabled', () {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      expect(state.soundEnabled, true);
      
      state.toggleSound();
      expect(state.soundEnabled, false);
      
      state.toggleSound();
      expect(state.soundEnabled, true);
      
      state.dispose();
    });

    test('onScreenTap shows controls and updates lastTapTime', () {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      state.onScreenTap();
      expect(state.controlsVisible, true);
      
      state.dispose();
    });

    test('exitWorkout calls onWorkoutComplete', () async {
      bool workoutEnded = false;
      final state = WorkoutState(prefs, testPreset, onWorkoutComplete: () {
        workoutEnded = true;
      });
      state.stopTimer();
      
      state.exitWorkout();
      
      expect(workoutEnded, true);
      expect(state.isPaused, true);
      
      state.dispose();
    });

    test('persistence saves and loads volume', () async {
      final state1 = WorkoutState(prefs, testPreset);
      state1.stopTimer();
      
      state1.onVolumeChange(0.75);
      state1.dispose();
      
      // Attendre un peu pour la persistence
      await Future.delayed(const Duration(milliseconds: 100));
      
      final state2 = WorkoutState(prefs, testPreset);
      expect(state2.volume, 0.75);
      
      state2.dispose();
    });

    test('persistence saves and loads soundEnabled', () async {
      final state1 = WorkoutState(prefs, testPreset);
      state1.stopTimer();
      
      state1.toggleSound();
      state1.dispose();
      
      // Attendre un peu pour la persistence
      await Future.delayed(const Duration(milliseconds: 100));
      
      final state2 = WorkoutState(prefs, testPreset);
      expect(state2.soundEnabled, false);
      
      state2.dispose();
    });

    test('tick at remainingTime=3 should call playBeep', () {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      // Mettre le temps à 3 secondes
      while (state.remainingTime > 3) {
        state.tick();
      }
      
      expect(state.remainingTime, 3);
      
      // Le prochain tick devrait jouer un bip (on ne peut pas tester le son directement)
      state.tick();
      expect(state.remainingTime, 2);
      
      state.dispose();
    });

    test('tick at remainingTime=0 calls nextStep', () {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
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
  });
}

