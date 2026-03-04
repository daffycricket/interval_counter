import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/domain/step_type.dart';
import 'package:interval_counter/domain/workout_engine.dart';
import 'package:interval_counter/models/preset.dart';

void main() {
  /// Helper to create a preset with given parameters
  Preset makePreset({
    int prepare = 5,
    int repetitions = 3,
    int work = 40,
    int rest = 20,
    int cooldown = 10,
  }) {
    return Preset(
      id: 'test-id',
      name: 'Test',
      prepareSeconds: prepare,
      repetitions: repetitions,
      workSeconds: work,
      restSeconds: rest,
      cooldownSeconds: cooldown,
    );
  }

  group('WorkoutStep', () {
    test('equality', () {
      const a = WorkoutStep(type: StepType.work, duration: 40, reps: 3);
      const b = WorkoutStep(type: StepType.work, duration: 40, reps: 3);
      const c = WorkoutStep(type: StepType.rest, duration: 20, reps: 3);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('toString', () {
      const step = WorkoutStep(type: StepType.work, duration: 40, reps: 3);
      expect(step.toString(), contains('StepType.work'));
      expect(step.toString(), contains('40'));
      expect(step.toString(), contains('3'));
    });
  });

  group('WorkoutEngine — step generation', () {
    test('generates correct step list for preset 5/3x(40/20)/10', () {
      final engine = WorkoutEngine(preset: makePreset());

      // preparation, work(3), rest(3), work(2), rest(2), work(1), cooldown = 7 steps
      expect(engine.stepCount, 7);

      expect(engine.steps[0], const WorkoutStep(type: StepType.preparation, duration: 5, reps: 0));
      expect(engine.steps[1], const WorkoutStep(type: StepType.work, duration: 40, reps: 3));
      expect(engine.steps[2], const WorkoutStep(type: StepType.rest, duration: 20, reps: 3));
      expect(engine.steps[3], const WorkoutStep(type: StepType.work, duration: 40, reps: 2));
      expect(engine.steps[4], const WorkoutStep(type: StepType.rest, duration: 20, reps: 2));
      expect(engine.steps[5], const WorkoutStep(type: StepType.work, duration: 40, reps: 1));
      expect(engine.steps[6], const WorkoutStep(type: StepType.cooldown, duration: 10, reps: 0));
    });

    test('skips preparation when 0 seconds', () {
      final engine = WorkoutEngine(preset: makePreset(prepare: 0));

      expect(engine.steps.first.type, StepType.work);
    });

    test('skips cooldown when 0 seconds', () {
      final engine = WorkoutEngine(preset: makePreset(cooldown: 0));

      expect(engine.steps.last.type, StepType.work);
    });

    test('skips last rest', () {
      final engine = WorkoutEngine(preset: makePreset());

      // Find all rest steps
      final restSteps = engine.steps.where((s) => s.type == StepType.rest).toList();
      // 3 reps → 2 rest periods (last rest skipped)
      expect(restSteps, hasLength(2));
    });

    test('preset 0/3x(40/20)/0 has no prep or cooldown', () {
      final engine = WorkoutEngine(preset: makePreset(prepare: 0, cooldown: 0));

      expect(engine.steps.first.type, StepType.work);
      expect(engine.steps.last.type, StepType.work);
      // work, rest, work, rest, work = 5 steps
      expect(engine.stepCount, 5);
    });

    test('single repetition has no rest', () {
      final engine = WorkoutEngine(preset: makePreset(repetitions: 1));

      final restSteps = engine.steps.where((s) => s.type == StepType.rest);
      expect(restSteps, isEmpty);
    });

    test('skips work when 0 seconds', () {
      final engine = WorkoutEngine(preset: makePreset(work: 0));

      final workSteps = engine.steps.where((s) => s.type == StepType.work);
      expect(workSteps, isEmpty);
    });

    test('skips rest when 0 seconds (all reps)', () {
      final engine = WorkoutEngine(preset: makePreset(rest: 0));

      final restSteps = engine.steps.where((s) => s.type == StepType.rest);
      expect(restSteps, isEmpty);
    });

    test('reps counter decrements on rest→work transitions', () {
      final engine = WorkoutEngine(preset: makePreset(repetitions: 3));

      final workSteps = engine.steps.where((s) => s.type == StepType.work).toList();
      expect(workSteps[0].reps, 3);
      expect(workSteps[1].reps, 2);
      expect(workSteps[2].reps, 1);
    });

    test('work and rest of same repetition have same reps value', () {
      final engine = WorkoutEngine(preset: makePreset(repetitions: 3));

      // Rep 1: steps[1]=work(3), steps[2]=rest(3)
      expect(engine.steps[1].reps, engine.steps[2].reps);
      // Rep 2: steps[3]=work(2), steps[4]=rest(2)
      expect(engine.steps[3].reps, engine.steps[4].reps);
    });
  });

  group('WorkoutEngine — initial state', () {
    test('starts at first step with full duration', () {
      final engine = WorkoutEngine(preset: makePreset());

      expect(engine.currentIndex, 0);
      expect(engine.currentStep, StepType.preparation);
      expect(engine.remainingTime, 5);
      expect(engine.isComplete, false);
    });

    test('empty steps list marks complete immediately', () {
      final engine = WorkoutEngine.fromSteps([]);

      expect(engine.isComplete, true);
    });
  });

  group('WorkoutEngine — tick', () {
    test('decrements remainingTime', () {
      final engine = WorkoutEngine.fromSteps([
        const WorkoutStep(type: StepType.work, duration: 5, reps: 1),
      ]);

      engine.tick();
      expect(engine.remainingTime, 4);
    });

    test('returns shouldBeep at 2, 1, 0', () {
      final engine = WorkoutEngine.fromSteps([
        const WorkoutStep(type: StepType.work, duration: 5, reps: 1),
        const WorkoutStep(type: StepType.cooldown, duration: 3, reps: 0),
      ]);

      // 5→4: no beep
      expect(engine.tick(), false);
      // 4→3: no beep
      expect(engine.tick(), false);
      // 3→2: beep
      expect(engine.tick(), true);
      // 2→1: beep
      expect(engine.tick(), true);
      // 1→0: beep
      expect(engine.tick(), true);
    });

    test('advances to next step after time reaches 0', () {
      final engine = WorkoutEngine.fromSteps([
        const WorkoutStep(type: StepType.preparation, duration: 2, reps: 0),
        const WorkoutStep(type: StepType.work, duration: 40, reps: 3),
      ]);

      engine.tick(); // 2→1
      engine.tick(); // 1→0
      engine.tick(); // 0→transition to work

      expect(engine.currentStep, StepType.work);
      expect(engine.remainingTime, 40);
    });

    test('sets isComplete at end of last step', () {
      final engine = WorkoutEngine.fromSteps([
        const WorkoutStep(type: StepType.work, duration: 2, reps: 1),
      ]);

      engine.tick(); // 2→1
      engine.tick(); // 1→0
      engine.tick(); // 0→advance → complete

      expect(engine.isComplete, true);
    });

    test('tick on completed engine returns false', () {
      final engine = WorkoutEngine.fromSteps([
        const WorkoutStep(type: StepType.work, duration: 1, reps: 1),
      ]);

      engine.tick(); // 1→0
      engine.tick(); // 0→complete

      expect(engine.isComplete, true);
      expect(engine.tick(), false);
    });

    test('full session simulation for preset 5/3x(40/20)/10', () {
      final engine = WorkoutEngine(preset: makePreset());

      var totalTicks = 0;

      while (!engine.isComplete) {
        engine.tick();
        totalTicks++;
        // Safety: avoid infinite loop
        if (totalTicks > 500) break;
      }

      expect(engine.isComplete, true);
      // Total duration: 5 + 40+20 + 40+20 + 40 + 10 = 175 seconds
      // + 1 tick per step transition (7 transitions between steps, plus 1 final)
      // Each step has 3 beeps, 7 steps with durations (prep 5, work 40, rest 20, work 40, rest 20, work 40, cooldown 10)
      // But the last step's final tick completes the session
    });
  });

  group('WorkoutEngine — moveToNext', () {
    test('advances step index', () {
      final engine = WorkoutEngine(preset: makePreset());

      engine.moveToNext();

      expect(engine.currentIndex, 1);
      expect(engine.currentStep, StepType.work);
      expect(engine.remainingTime, 40);
    });

    test('at last step sets isComplete', () {
      final engine = WorkoutEngine.fromSteps([
        const WorkoutStep(type: StepType.work, duration: 5, reps: 1),
      ]);

      engine.moveToNext();

      expect(engine.isComplete, true);
    });

    test('does nothing when already complete', () {
      final engine = WorkoutEngine.fromSteps([
        const WorkoutStep(type: StepType.work, duration: 5, reps: 1),
      ]);
      engine.moveToNext(); // complete

      engine.moveToNext(); // should not crash
      expect(engine.isComplete, true);
    });
  });

  group('WorkoutEngine — moveToPrevious', () {
    test('decrements step index', () {
      final engine = WorkoutEngine(preset: makePreset());
      engine.moveToNext(); // index 1

      engine.moveToPrevious();

      expect(engine.currentIndex, 0);
      expect(engine.currentStep, StepType.preparation);
      expect(engine.remainingTime, 5);
    });

    test('at first step stays at first', () {
      final engine = WorkoutEngine(preset: makePreset());

      engine.moveToPrevious();

      expect(engine.currentIndex, 0);
    });

    test('does nothing when complete', () {
      final engine = WorkoutEngine.fromSteps([
        const WorkoutStep(type: StepType.work, duration: 5, reps: 1),
      ]);
      engine.moveToNext(); // complete

      engine.moveToPrevious(); // should not crash
      expect(engine.isComplete, true);
    });
  });

  group('WorkoutEngine — formattedTime', () {
    test('formats seconds as MM:SS', () {
      final engine = WorkoutEngine.fromSteps([
        const WorkoutStep(type: StepType.work, duration: 80, reps: 1),
      ]);

      expect(engine.formattedTime, '01:20');
    });

    test('formats zero as 00:00', () {
      final engine = WorkoutEngine.fromSteps([
        const WorkoutStep(type: StepType.work, duration: 0, reps: 1),
      ]);

      expect(engine.formattedTime, '00:00');
    });

    test('pads single digits', () {
      final engine = WorkoutEngine.fromSteps([
        const WorkoutStep(type: StepType.work, duration: 5, reps: 1),
      ]);

      expect(engine.formattedTime, '00:05');
    });
  });

  group('WorkoutEngine — getters on complete', () {
    test('currentStep returns last step type when complete', () {
      final engine = WorkoutEngine.fromSteps([
        const WorkoutStep(type: StepType.work, duration: 1, reps: 1),
      ]);
      engine.moveToNext();

      expect(engine.isComplete, true);
      expect(engine.currentStep, StepType.work);
    });

    test('remainingReps returns last step reps when complete', () {
      final engine = WorkoutEngine.fromSteps([
        const WorkoutStep(type: StepType.work, duration: 1, reps: 2),
      ]);
      engine.moveToNext();

      expect(engine.remainingReps, 2);
    });
  });
}
