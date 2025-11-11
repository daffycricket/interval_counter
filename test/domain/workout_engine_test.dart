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

      // When
      final transitioned = engine.tick();

      // Then
      expect(transitioned, true);
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

      // When
      final transitioned = engine.tick();

      // Then
      expect(transitioned, true);
      expect(engine.currentStep, StepType.rest);
      expect(engine.remainingTime, 20);
      expect(engine.remainingReps, 2);
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
      engine.tick(); // work → rest
      expect(engine.currentStep, StepType.rest);

      // When
      final transitioned = engine.tick();

      // Then
      expect(transitioned, true);
      expect(engine.currentStep, StepType.work);
      expect(engine.remainingTime, 1);
      expect(engine.remainingReps, 2);
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

      // When
      final transitioned = engine.tick();

      // Then
      expect(transitioned, true);
      expect(engine.currentStep, StepType.cooldown);
      expect(engine.remainingTime, 10);
      expect(engine.remainingReps, 0);
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
      engine.tick();
      expect(engine.currentStep, StepType.rest);
      expect(engine.remainingReps, 1);
      
      // rest → work (second rep, last one)
      engine.tick();
      expect(engine.currentStep, StepType.work);
      expect(engine.remainingReps, 1);

      // When: last work → cooldown (skip rest)
      final transitioned = engine.tick();

      // Then
      expect(transitioned, true);
      expect(engine.currentStep, StepType.cooldown);
      expect(engine.remainingTime, 10);
      expect(engine.remainingReps, 0);
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
      engine.tick(); // work → cooldown
      expect(engine.currentStep, StepType.cooldown);

      // When
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
      engine.tick(); // work → cooldown
      engine.tick(); // cooldown → finished (remainingTime = 0)
      expect(engine.remainingTime, 0);

      // When
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

      // When
      engine.nextStep();

      // Then
      expect(engine.currentStep, StepType.rest);
      expect(engine.remainingTime, 20);
      expect(engine.remainingReps, 2);
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
      engine.tick(); // work → cooldown
      engine.tick(); // cooldown → finished

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

      // When
      engine.tick(); // work → cooldown (0 seconds)

      // Then
      expect(engine.currentStep, StepType.cooldown);
      expect(engine.remainingTime, 0);
      expect(engine.isFinished, true);
    });
  });
}
