import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/domain/step_type.dart';
import 'package:interval_counter/domain/workout_engine.dart';
import 'package:interval_counter/models/preset.dart';

void main() {
  group('WorkoutEngine', () {
    test('constructor initializes with preparation step when prepareSeconds > 0', () {
      // Given
      final preset = Preset(
        id: 'test1',
        name: 'Test',
        prepareSeconds: 5,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 10,
      );

      // When
      final engine = WorkoutEngine(preset: preset);

      // Then
      expect(engine.currentStep, StepType.preparation);
      expect(engine.remainingTime, 5);
      expect(engine.remainingReps, 3);
    });

    test('constructor initializes with work step when prepareSeconds = 0', () {
      // Given
      final preset = Preset(
        id: 'test2',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 0,
      );

      // When
      final engine = WorkoutEngine(preset: preset);

      // Then
      expect(engine.currentStep, StepType.work);
      expect(engine.remainingTime, 40);
      expect(engine.remainingReps, 3);
    });

    test('shouldPlayBeep is false when remainingTime = 3', () {
      // Given
      final preset = Preset(
        id: 'test3',
        name: 'Test',
        prepareSeconds: 3,
        repetitions: 1,
        workSeconds: 40,
        restSeconds: 20,
      );
      final engine = WorkoutEngine(preset: preset);

      // When / Then
      expect(engine.shouldPlayBeep, false);
    });

    test('shouldPlayBeep is true when remainingTime = 2', () {
      // Given
      final preset = Preset(
        id: 'test4',
        name: 'Test',
        prepareSeconds: 2,
        repetitions: 1,
        workSeconds: 40,
        restSeconds: 20,
      );
      final engine = WorkoutEngine(preset: preset);

      // When / Then
      expect(engine.shouldPlayBeep, true);
    });

    test('shouldPlayBeep is true when remainingTime = 1', () {
      // Given
      final preset = Preset(
        id: 'test5',
        name: 'Test',
        prepareSeconds: 1,
        repetitions: 1,
        workSeconds: 40,
        restSeconds: 20,
      );
      final engine = WorkoutEngine(preset: preset);

      // When / Then
      expect(engine.shouldPlayBeep, true);
    });

    test('shouldPlayBeep is true when remainingTime = 0', () {
      // Given
      final preset = Preset(
        id: 'test6',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 1,
        restSeconds: 0,
      );
      final engine = WorkoutEngine(preset: preset);
      
      // Tick once to go from 1 to 0 (without transition)
      // We need to capture the state just before transition
      expect(engine.remainingTime, 1);
      expect(engine.shouldPlayBeep, true);
      
      // When
      engine.tick(); // This will transition to cooldown

      // Then - After transition, shouldPlayBeep is still true at 0
      expect(engine.remainingTime, 0);
      expect(engine.shouldPlayBeep, true);
    });

    test('tick decrements remainingTime', () {
      // Given
      final preset = Preset(
        id: 'test7',
        name: 'Test',
        prepareSeconds: 5,
        repetitions: 1,
        workSeconds: 40,
        restSeconds: 20,
      );
      final engine = WorkoutEngine(preset: preset);
      final initialTime = engine.remainingTime;

      // When
      engine.tick();

      // Then
      expect(engine.remainingTime, initialTime - 1);
    });

    test('tick transitions from preparation to work when time reaches 0', () {
      // Given
      final preset = Preset(
        id: 'test8',
        name: 'Test',
        prepareSeconds: 1,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
      );
      final engine = WorkoutEngine(preset: preset);

      // When: premier tick décrémente à 0
      final transitioned1 = engine.tick();
      expect(transitioned1, false);
      expect(engine.remainingTime, 0);
      expect(engine.currentStep, StepType.preparation);
      
      // Deuxième tick fait la transition
      final transitioned2 = engine.tick();

      // Then
      expect(transitioned2, true);
      expect(engine.currentStep, StepType.work);
      expect(engine.remainingTime, 40);
      expect(engine.remainingReps, 3);
    });

    test('tick transitions from work to rest when time reaches 0 and reps > 1', () {
      // Given
      final preset = Preset(
        id: 'test9',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 3,
        workSeconds: 1,
        restSeconds: 20,
      );
      final engine = WorkoutEngine(preset: preset);

      // When: premier tick décrémente à 0
      final transitioned1 = engine.tick();
      expect(transitioned1, false);
      expect(engine.remainingTime, 0);
      expect(engine.currentStep, StepType.work);
      
      // Deuxième tick fait la transition
      final transitioned2 = engine.tick();

      // Then
      expect(transitioned2, true);
      expect(engine.currentStep, StepType.rest);
      expect(engine.remainingTime, 20);
      expect(engine.remainingReps, 3); // Même valeur que work (pas encore décrémenté)
    });

    test('tick transitions from rest to work when time reaches 0', () {
      // Given
      final preset = Preset(
        id: 'test10',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 3,
        workSeconds: 1,
        restSeconds: 1,
      );
      final engine = WorkoutEngine(preset: preset);
      // work → rest: premier tick décrémente à 0, deuxième tick fait la transition
      engine.tick(); // 1 → 0
      engine.tick(); // transition work → rest
      expect(engine.currentStep, StepType.rest);
      expect(engine.remainingReps, 3); // Même valeur que work

      // When: rest → work
      // Premier tick décrémente rest à 0
      final transitioned1 = engine.tick();
      expect(transitioned1, false);
      expect(engine.remainingTime, 0);
      expect(engine.currentStep, StepType.rest);
      
      // Deuxième tick fait la transition (décrémente ici)
      final transitioned2 = engine.tick();

      // Then
      expect(transitioned2, true);
      expect(engine.currentStep, StepType.work);
      expect(engine.remainingTime, 1);
      expect(engine.remainingReps, 2); // Décrémenté au début de la nouvelle répétition
    });

    test('tick transitions from work to cooldown when last rep (reps = 1)', () {
      // Given
      final preset = Preset(
        id: 'test11',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 1,
        restSeconds: 20,
        cooldownSeconds: 10,
      );
      final engine = WorkoutEngine(preset: preset);
      expect(engine.remainingReps, 1);

      // When: premier tick décrémente à 0
      final transitioned1 = engine.tick();
      expect(transitioned1, false);
      expect(engine.remainingTime, 0);
      expect(engine.currentStep, StepType.work);
      
      // Deuxième tick fait la transition work → cooldown (dernière rep, pas de rest)
      final transitioned2 = engine.tick();

      // Then
      expect(transitioned2, true);
      expect(engine.currentStep, StepType.cooldown);
      expect(engine.remainingTime, 10);
      expect(engine.remainingReps, 1); // Reste à 1 car pas de décrémentation (pas de rest)
    });

    test('tick skips rest on last rep and goes directly to cooldown', () {
      // Given
      final preset = Preset(
        id: 'test12',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 2,
        workSeconds: 1,
        restSeconds: 1,
        cooldownSeconds: 10,
      );
      final engine = WorkoutEngine(preset: preset);
      
      // First rep: work → rest
      // Premier tick décrémente à 0
      engine.tick(); // 1 → 0
      // Deuxième tick fait la transition
      engine.tick(); // transition work → rest
      expect(engine.currentStep, StepType.rest);
      expect(engine.remainingReps, 2); // Même valeur que work (pas encore décrémenté)
      
      // rest → work (second rep, last one) - décrémente ici
      // Premier tick décrémente à 0
      engine.tick(); // 1 → 0
      // Deuxième tick fait la transition (décrémente ici)
      engine.tick(); // transition rest → work
      expect(engine.currentStep, StepType.work);
      expect(engine.remainingReps, 1); // Décrémenté au début de la nouvelle répétition

      // When: last work → cooldown (skip rest)
      // Premier tick décrémente à 0
      final transitioned1 = engine.tick();
      expect(transitioned1, false);
      expect(engine.remainingTime, 0);
      expect(engine.currentStep, StepType.work);
      
      // Deuxième tick fait la transition
      final transitioned2 = engine.tick();

      // Then
      expect(transitioned2, true);
      expect(engine.currentStep, StepType.cooldown);
      expect(engine.remainingTime, 10);
      expect(engine.remainingReps, 1); // Reste à 1 car pas de décrémentation (pas de rest)
    });

    test('tick finishes workout when cooldown ends', () {
      // Given
      final preset = Preset(
        id: 'test13',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 1,
        restSeconds: 0,
        cooldownSeconds: 1,
      );
      final engine = WorkoutEngine(preset: preset);
      // work → cooldown: premier tick décrémente à 0, deuxième tick fait la transition
      engine.tick(); // 1 → 0
      engine.tick(); // transition work → cooldown
      expect(engine.currentStep, StepType.cooldown);

      // When: cooldown → finished
      // Premier tick décrémente à 0
      engine.tick(); // 1 → 0
      expect(engine.currentStep, StepType.cooldown);
      expect(engine.remainingTime, 0);
      
      // Deuxième tick reste à cooldown avec remainingTime = 0
      engine.tick();

      // Then
      expect(engine.currentStep, StepType.cooldown);
      expect(engine.remainingTime, 0);
      expect(engine.isFinished, true);
    });

    test('tick does not change state when remainingTime = 0 already', () {
      // Given
      final preset = Preset(
        id: 'test14',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 1,
        restSeconds: 0,
        cooldownSeconds: 1,
      );
      final engine = WorkoutEngine(preset: preset);
      // work → cooldown: premier tick décrémente à 0, deuxième tick fait la transition
      engine.tick(); // 1 → 0
      engine.tick(); // transition work → cooldown
      // cooldown → finished: premier tick décrémente à 0
      engine.tick(); // 1 → 0
      expect(engine.remainingTime, 0);
      expect(engine.currentStep, StepType.cooldown);

      // When: deuxième tick reste à cooldown avec remainingTime = 0
      engine.tick();

      // Then
      expect(engine.remainingTime, 0);
      expect(engine.currentStep, StepType.cooldown);
    });

    test('nextStep transitions from work to rest', () {
      // Given
      final preset = Preset(
        id: 'test15',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
      );
      final engine = WorkoutEngine(preset: preset);
      expect(engine.currentStep, StepType.work);
      expect(engine.remainingReps, 3);

      // When
      engine.nextStep(); // work → rest

      // Then
      expect(engine.currentStep, StepType.rest);
      expect(engine.remainingTime, 20);
      expect(engine.remainingReps, 3); // Même valeur que work (pas encore décrémenté)
    });

    test('previousStep from work (first rep) goes to preparation', () {
      // Given
      final preset = Preset(
        id: 'test16',
        name: 'Test',
        prepareSeconds: 5,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
      );
      final engine = WorkoutEngine(preset: preset);
      
      // Tick through preparation to get to work
      while (engine.currentStep != StepType.work) {
        engine.tick();
      }
      expect(engine.currentStep, StepType.work);
      expect(engine.remainingReps, 3);

      // When
      engine.previousStep();

      // Then
      expect(engine.currentStep, StepType.preparation);
      expect(engine.remainingTime, 5);
    });

    test('previousStep from rest goes to work', () {
      // Given
      final preset = Preset(
        id: 'test17',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
      );
      final engine = WorkoutEngine(preset: preset);
      engine.nextStep(); // work → rest
      expect(engine.currentStep, StepType.rest);

      // When
      engine.previousStep();

      // Then
      expect(engine.currentStep, StepType.work);
      expect(engine.remainingTime, 40);
    });

    test('previousStep from cooldown goes to work (last rep)', () {
      // Given
      final preset = Preset(
        id: 'test18',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 40,
        restSeconds: 0,
        cooldownSeconds: 10,
      );
      final engine = WorkoutEngine(preset: preset);
      engine.nextStep(); // work → cooldown
      expect(engine.currentStep, StepType.cooldown);

      // When
      engine.previousStep();

      // Then
      expect(engine.currentStep, StepType.work);
      expect(engine.remainingTime, 40);
      expect(engine.remainingReps, 1);
    });

    test('previousStep from preparation stays at preparation', () {
      // Given
      final preset = Preset(
        id: 'test19',
        name: 'Test',
        prepareSeconds: 5,
        repetitions: 1,
        workSeconds: 40,
        restSeconds: 20,
      );
      final engine = WorkoutEngine(preset: preset);
      expect(engine.currentStep, StepType.preparation);

      // When
      engine.previousStep();

      // Then
      expect(engine.currentStep, StepType.preparation);
      expect(engine.remainingTime, 5);
    });

    test('formatTime formats 80 seconds as 01:20', () {
      // Given
      final preset = Preset(
        id: 'test20',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 40,
        restSeconds: 20,
      );
      final engine = WorkoutEngine(preset: preset);

      // When / Then
      expect(engine.formatTime(80), '01:20');
    });

    test('formatTime formats 0 seconds as 00:00', () {
      // Given
      final preset = Preset(
        id: 'test21',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 40,
        restSeconds: 20,
      );
      final engine = WorkoutEngine(preset: preset);

      // When / Then
      expect(engine.formatTime(0), '00:00');
    });

    test('formatTime formats 3599 seconds as 59:59', () {
      // Given
      final preset = Preset(
        id: 'test22',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 40,
        restSeconds: 20,
      );
      final engine = WorkoutEngine(preset: preset);

      // When / Then
      expect(engine.formatTime(3599), '59:59');
    });

    test('isFinished is false during workout', () {
      // Given
      final preset = Preset(
        id: 'test23',
        name: 'Test',
        prepareSeconds: 5,
        repetitions: 1,
        workSeconds: 40,
        restSeconds: 20,
      );
      final engine = WorkoutEngine(preset: preset);

      // When / Then
      expect(engine.isFinished, false);
    });

    test('isFinished is true when cooldown ends', () {
      // Given
      final preset = Preset(
        id: 'test24',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 1,
        restSeconds: 0,
        cooldownSeconds: 1,
      );
      final engine = WorkoutEngine(preset: preset);
      // work → cooldown: premier tick décrémente à 0, deuxième tick fait la transition
      engine.tick(); // 1 → 0
      engine.tick(); // transition work → cooldown
      // cooldown → finished: premier tick décrémente à 0, deuxième tick reste à cooldown avec remainingTime = 0
      engine.tick(); // 1 → 0
      engine.tick(); // reste à cooldown avec remainingTime = 0

      // When / Then
      expect(engine.isFinished, true);
    });

    test('workout with 0 cooldown finishes without cooldown step', () {
      // Given
      final preset = Preset(
        id: 'test25',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 1,
        restSeconds: 0,
        cooldownSeconds: 0,
      );
      final engine = WorkoutEngine(preset: preset);

      // When: work → cooldown
      // Premier tick décrémente à 0
      engine.tick(); // 1 → 0
      // Deuxième tick fait la transition work → cooldown (cooldownSeconds = 0, donc remainingTime = 0 immédiatement)
      engine.tick(); // transition work → cooldown

      // Then
      expect(engine.currentStep, StepType.cooldown);
      expect(engine.remainingTime, 0);
      expect(engine.isFinished, true);
    });

    test('work and rest of same repetition have same remainingReps', () {
      // Given: preset 0/3x(40/20)/0 (comme dans spec_complement.md)
      final preset = Preset(
        id: 'test26',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 3,
        workSeconds: 1,
        restSeconds: 1,
        cooldownSeconds: 0,
      );
      final engine = WorkoutEngine(preset: preset);
      
      // Répétition 1: Work
      expect(engine.currentStep, StepType.work);
      final repsBeforeWork1 = engine.remainingReps;
      expect(repsBeforeWork1, 3);  // Devrait être 3
      
      // When: transition work → rest (répétition 1)
      // Premier tick décrémente à 0
      engine.tick(); // 1 → 0
      // Deuxième tick fait la transition
      engine.tick(); // transition work → rest
      
      // Then: Rest de la répétition 1 devrait avoir la même valeur
      expect(engine.currentStep, StepType.rest);
      expect(engine.remainingReps, repsBeforeWork1, 
        reason: 'Rest de la répétition 1 devrait avoir le même remainingReps que Work de la répétition 1');
      
      // Répétition 2: Work (après rest → work)
      // Premier tick décrémente rest à 0
      engine.tick(); // 1 → 0
      // Deuxième tick fait la transition rest → work (décrémente ici)
      engine.tick(); // transition rest → work
      expect(engine.currentStep, StepType.work);
      final repsBeforeWork2 = engine.remainingReps;
      expect(repsBeforeWork2, 2);  // Devrait être décrémenté à 2
      
      // When: transition work → rest (répétition 2)
      // Premier tick décrémente à 0
      engine.tick(); // 1 → 0
      // Deuxième tick fait la transition
      engine.tick(); // transition work → rest
      
      // Then: Rest de la répétition 2 devrait avoir la même valeur
      expect(engine.currentStep, StepType.rest);
      expect(engine.remainingReps, repsBeforeWork2,
        reason: 'Rest de la répétition 2 devrait avoir le même remainingReps que Work de la répétition 2');
    });

    test('timer displays 0 before transitioning to next step', () {
      // Given: preset avec work de 3 secondes puis rest de 2 secondes
      // On utilise repetitions: 2 pour avoir un rest (pas de cooldown direct)
      final preset = Preset(
        id: 'test27',
        name: 'Test',
        prepareSeconds: 0,
        repetitions: 2,
        workSeconds: 3,
        restSeconds: 2,
      );
      final engine = WorkoutEngine(preset: preset);
      expect(engine.currentStep, StepType.work);
      expect(engine.remainingTime, 3);
      
      // Tick 1: 3 → 2
      engine.tick();
      expect(engine.remainingTime, 2);
      expect(engine.currentStep, StepType.work);
      expect(engine.shouldPlayBeep, true); // Bip à 2
      
      // Tick 2: 2 → 1 (bip à 2)
      engine.tick();
      expect(engine.remainingTime, 1);
      expect(engine.currentStep, StepType.work);
      expect(engine.shouldPlayBeep, true); // Bip à 1
      
      // Tick 3: 1 → 0 (bip à 1)
      final transitioned = engine.tick();
      
      // Then: Le chrono doit afficher 0 AVANT la transition
      expect(engine.remainingTime, 0, 
        reason: 'Le chrono doit afficher 0 avant de transitionner vers l\'étape suivante');
      expect(engine.currentStep, StepType.work,
        reason: 'L\'étape doit encore être work après avoir atteint 0, la transition se fait au tick suivant');
      expect(transitioned, false,
        reason: 'La transition ne doit pas se faire immédiatement quand remainingTime atteint 0');
      expect(engine.shouldPlayBeep, true); // Bip à 0
      
      // Tick 4: 0 → transition vers rest (bip à 0)
      final transitioned2 = engine.tick();
      expect(transitioned2, true);
      expect(engine.currentStep, StepType.rest);
      expect(engine.remainingTime, 2); // Valeur de rest
    });
  });
}
