import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/domain/workout_engine.dart';
import 'package:interval_counter/models/preset.dart';

void main() {
  group('WorkoutEngine', () {
    late Preset preset;
    
    setUp(() {
      preset = Preset(
        id: 'test',
        name: 'Test',
        prepareSeconds: 5,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 10,
      );
    });
    
    group('Initialization', () {
      test('fromPreset with prepare > 0 starts at preparation', () {
        final engine = WorkoutEngine.fromPreset(preset);
        
        expect(engine.currentStep, StepType.preparation);
        expect(engine.remainingTime, 5);
        expect(engine.remainingReps, 3);
        expect(engine.isPaused, false);
      });
      
      test('fromPreset with prepare = 0 starts at work', () {
        final presetNoPrep = preset.copyWith(prepareSeconds: 0);
        final engine = WorkoutEngine.fromPreset(presetNoPrep);
        
        expect(engine.currentStep, StepType.work);
        expect(engine.remainingTime, 40);
        expect(engine.remainingReps, 3);
      });
    });
    
    group('Computed properties', () {
      test('shouldPlayBeep is true for times 1, 2, 3', () {
        expect(WorkoutEngine.fromPreset(preset).copyWith(remainingTime: 3).shouldPlayBeep, true);
        expect(WorkoutEngine.fromPreset(preset).copyWith(remainingTime: 2).shouldPlayBeep, true);
        expect(WorkoutEngine.fromPreset(preset).copyWith(remainingTime: 1).shouldPlayBeep, true);
      });
      
      test('shouldPlayBeep is false for times 0, 4+', () {
        expect(WorkoutEngine.fromPreset(preset).copyWith(remainingTime: 0).shouldPlayBeep, false);
        expect(WorkoutEngine.fromPreset(preset).copyWith(remainingTime: 4).shouldPlayBeep, false);
        expect(WorkoutEngine.fromPreset(preset).copyWith(remainingTime: 10).shouldPlayBeep, false);
      });
      
      test('shouldShowRepsCounter is true for work and rest', () {
        final engine = WorkoutEngine.fromPreset(preset);
        
        expect(engine.copyWith(currentStep: StepType.work).shouldShowRepsCounter, true);
        expect(engine.copyWith(currentStep: StepType.rest).shouldShowRepsCounter, true);
      });
      
      test('shouldShowRepsCounter is false for preparation and cooldown', () {
        final engine = WorkoutEngine.fromPreset(preset);
        
        expect(engine.copyWith(currentStep: StepType.preparation).shouldShowRepsCounter, false);
        expect(engine.copyWith(currentStep: StepType.cooldown).shouldShowRepsCounter, false);
      });
      
      test('isComplete is true when cooldown and time = 0', () {
        final engine = WorkoutEngine.fromPreset(preset);
        
        expect(
          engine.copyWith(currentStep: StepType.cooldown, remainingTime: 0).isComplete,
          true,
        );
      });
      
      test('isComplete is false otherwise', () {
        final engine = WorkoutEngine.fromPreset(preset);
        
        expect(engine.copyWith(currentStep: StepType.cooldown, remainingTime: 5).isComplete, false);
        expect(engine.copyWith(currentStep: StepType.work, remainingTime: 0).isComplete, false);
      });
    });
    
    group('Tick', () {
      test('tick decrements remainingTime when > 0', () {
        final engine = WorkoutEngine.fromPreset(preset); // prep, time=5
        final newEngine = engine.tick();
        
        expect(newEngine.remainingTime, 4);
        expect(newEngine.currentStep, StepType.preparation);
      });
      
      test('tick does not decrement when paused', () {
        final engine = WorkoutEngine.fromPreset(preset).togglePause();
        final newEngine = engine.tick();
        
        expect(newEngine.remainingTime, engine.remainingTime);
      });
      
      test('tick calls nextStep when remainingTime = 0', () {
        final engine = WorkoutEngine.fromPreset(preset).copyWith(remainingTime: 0);
        final newEngine = engine.tick();
        
        // Should transition from preparation to work
        expect(newEngine.currentStep, StepType.work);
        expect(newEngine.remainingTime, 40);
      });
    });
    
    group('nextStep transitions', () {
      test('preparation -> work', () {
        final engine = WorkoutEngine.fromPreset(preset); // prep
        final newEngine = engine.nextStep();
        
        expect(newEngine.currentStep, StepType.work);
        expect(newEngine.remainingTime, 40);
        expect(newEngine.remainingReps, 3);
      });
      
      test('work -> rest (not last rep, rest > 0)', () {
        final engine = WorkoutEngine.fromPreset(preset)
            .copyWith(currentStep: StepType.work, remainingReps: 3);
        final newEngine = engine.nextStep();
        
        expect(newEngine.currentStep, StepType.rest);
        expect(newEngine.remainingTime, 20);
        expect(newEngine.remainingReps, 2);
      });
      
      test('work -> cooldown (last rep)', () {
        final engine = WorkoutEngine.fromPreset(preset)
            .copyWith(currentStep: StepType.work, remainingReps: 1);
        final newEngine = engine.nextStep();
        
        expect(newEngine.currentStep, StepType.cooldown);
        expect(newEngine.remainingTime, 10);
        expect(newEngine.remainingReps, 0);
      });
      
      test('work -> end (last rep, no cooldown)', () {
        final presetNoCooldown = preset.copyWith(cooldownSeconds: 0);
        final engine = WorkoutEngine.fromPreset(presetNoCooldown)
            .copyWith(currentStep: StepType.work, remainingReps: 1);
        final newEngine = engine.nextStep();
        
        expect(newEngine.currentStep, StepType.cooldown);
        expect(newEngine.remainingTime, 0);
        expect(newEngine.isComplete, true);
      });
      
      test('rest -> work (more reps remaining)', () {
        final engine = WorkoutEngine.fromPreset(preset)
            .copyWith(currentStep: StepType.rest, remainingReps: 2);
        final newEngine = engine.nextStep();
        
        expect(newEngine.currentStep, StepType.work);
        expect(newEngine.remainingTime, 40);
        expect(newEngine.remainingReps, 2);
      });
      
      test('cooldown -> stay at cooldown', () {
        final engine = WorkoutEngine.fromPreset(preset)
            .copyWith(currentStep: StepType.cooldown);
        final newEngine = engine.nextStep();
        
        expect(newEngine.currentStep, StepType.cooldown);
      });
    });
    
    group('previousStep transitions', () {
      test('preparation -> preparation (restart)', () {
        final engine = WorkoutEngine.fromPreset(preset)
            .copyWith(remainingTime: 2);
        final newEngine = engine.previousStep();
        
        expect(newEngine.currentStep, StepType.preparation);
        expect(newEngine.remainingTime, 5);
      });
      
      test('work -> preparation (if prepare > 0)', () {
        final engine = WorkoutEngine.fromPreset(preset)
            .copyWith(currentStep: StepType.work);
        final newEngine = engine.previousStep();
        
        expect(newEngine.currentStep, StepType.preparation);
        expect(newEngine.remainingTime, 5);
        expect(newEngine.remainingReps, 3);
      });
      
      test('work -> work restart (if prepare = 0)', () {
        final presetNoPrep = preset.copyWith(prepareSeconds: 0);
        final engine = WorkoutEngine.fromPreset(presetNoPrep)
            .copyWith(currentStep: StepType.work, remainingTime: 10);
        final newEngine = engine.previousStep();
        
        expect(newEngine.currentStep, StepType.work);
        expect(newEngine.remainingTime, 40);
      });
      
      test('rest -> work (increment reps)', () {
        final engine = WorkoutEngine.fromPreset(preset)
            .copyWith(currentStep: StepType.rest, remainingReps: 2);
        final newEngine = engine.previousStep();
        
        expect(newEngine.currentStep, StepType.work);
        expect(newEngine.remainingTime, 40);
        expect(newEngine.remainingReps, 3);
      });
      
      test('cooldown -> work (last rep)', () {
        final engine = WorkoutEngine.fromPreset(preset)
            .copyWith(currentStep: StepType.cooldown);
        final newEngine = engine.previousStep();
        
        expect(newEngine.currentStep, StepType.work);
        expect(newEngine.remainingTime, 40);
        expect(newEngine.remainingReps, 1);
      });
    });
    
    group('togglePause', () {
      test('togglePause switches isPaused', () {
        final engine = WorkoutEngine.fromPreset(preset);
        
        expect(engine.isPaused, false);
        expect(engine.togglePause().isPaused, true);
        expect(engine.togglePause().togglePause().isPaused, false);
      });
    });
    
    group('Complete flow scenario', () {
      test('preset 5/3x(40/20)/10 follows correct sequence', () {
        var engine = WorkoutEngine.fromPreset(preset);
        
        // 1. Préparation (5s)
        expect(engine.currentStep, StepType.preparation);
        expect(engine.remainingTime, 5);
        
        // Fast-forward to end of preparation
        engine = engine.copyWith(remainingTime: 0).tick();
        
        // 2. Travail (40s, 3 reps)
        expect(engine.currentStep, StepType.work);
        expect(engine.remainingReps, 3);
        
        engine = engine.copyWith(remainingTime: 0).tick();
        
        // 3. Repos (20s, 2 reps remaining)
        expect(engine.currentStep, StepType.rest);
        expect(engine.remainingReps, 2);
        
        engine = engine.copyWith(remainingTime: 0).tick();
        
        // 4. Travail (40s, 2 reps)
        expect(engine.currentStep, StepType.work);
        expect(engine.remainingReps, 2);
        
        engine = engine.copyWith(remainingTime: 0).tick();
        
        // 5. Repos (20s, 1 rep remaining)
        expect(engine.currentStep, StepType.rest);
        expect(engine.remainingReps, 1);
        
        engine = engine.copyWith(remainingTime: 0).tick();
        
        // 6. Travail (40s, 1 rep) - dernière répétition
        expect(engine.currentStep, StepType.work);
        expect(engine.remainingReps, 1);
        
        engine = engine.copyWith(remainingTime: 0).tick();
        
        // 7. Refroidissement (10s) - skip le repos de la dernière rep
        expect(engine.currentStep, StepType.cooldown);
        expect(engine.remainingTime, 10);
      });
      
      test('preset 0/3x(40/20)/0 skips prep and cooldown', () {
        final presetSimple = preset.copyWith(
          prepareSeconds: 0,
          cooldownSeconds: 0,
        );
        var engine = WorkoutEngine.fromPreset(presetSimple);
        
        // 1. Starts at Work (no prep)
        expect(engine.currentStep, StepType.work);
        expect(engine.remainingReps, 3);
        
        // Fast-forward through all steps
        engine = engine.copyWith(remainingTime: 0).tick(); // work -> rest
        expect(engine.currentStep, StepType.rest);
        
        engine = engine.copyWith(remainingTime: 0).tick(); // rest -> work
        expect(engine.currentStep, StepType.work);
        expect(engine.remainingReps, 2);
        
        engine = engine.copyWith(remainingTime: 0).tick(); // work -> rest
        expect(engine.currentStep, StepType.rest);
        
        engine = engine.copyWith(remainingTime: 0).tick(); // rest -> work
        expect(engine.currentStep, StepType.work);
        expect(engine.remainingReps, 1);
        
        engine = engine.copyWith(remainingTime: 0).tick(); // work -> end (no cooldown)
        expect(engine.currentStep, StepType.cooldown);
        expect(engine.remainingTime, 0);
        expect(engine.isComplete, true);
      });
    });
  });
}









