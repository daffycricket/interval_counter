import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/state/interval_timer_home_state.dart';

void main() {
  group('IntervalTimerHomeState', () {
    late IntervalTimerHomeState state;

    setUp(() {
      state = IntervalTimerHomeState();
    });

    test('initial values are correct', () {
      expect(state.reps, 16);
      expect(state.workSeconds, 44);
      expect(state.restSeconds, 15);
      expect(state.volume, closeTo(0.62, 0.01));
      expect(state.quickStartExpanded, true);
    });

    test('incrementReps increases reps by 1', () {
      final initialReps = state.reps;
      state.incrementReps();
      expect(state.reps, initialReps + 1);
    });

    test('decrementReps decreases reps by 1', () {
      final initialReps = state.reps;
      state.decrementReps();
      expect(state.reps, initialReps - 1);
    });

    test('decrementReps does not go below minReps', () {
      // Set reps to minimum
      while (state.reps > IntervalTimerHomeState.minReps) {
        state.decrementReps();
      }
      expect(state.reps, IntervalTimerHomeState.minReps);
      
      // Try to decrement again
      state.decrementReps();
      expect(state.reps, IntervalTimerHomeState.minReps);
    });

    test('incrementReps does not go above maxReps', () {
      // Set reps to maximum
      while (state.reps < IntervalTimerHomeState.maxReps) {
        state.incrementReps();
      }
      expect(state.reps, IntervalTimerHomeState.maxReps);
      
      // Try to increment again
      state.incrementReps();
      expect(state.reps, IntervalTimerHomeState.maxReps);
    });

    test('incrementWorkTime increases workSeconds by timeStep', () {
      final initialWork = state.workSeconds;
      state.incrementWorkTime();
      expect(state.workSeconds, initialWork + IntervalTimerHomeState.timeStep);
    });

    test('decrementWorkTime decreases workSeconds by timeStep', () {
      // Set to a higher value first
      while (state.workSeconds < 50) {
        state.incrementWorkTime();
      }
      final initialWork = state.workSeconds;
      state.decrementWorkTime();
      expect(state.workSeconds, initialWork - IntervalTimerHomeState.timeStep);
    });

    test('decrementWorkTime does not go below minWorkSeconds', () {
      // Set to minimum
      while (state.workSeconds > IntervalTimerHomeState.minWorkSeconds) {
        state.decrementWorkTime();
      }
      expect(state.workSeconds, IntervalTimerHomeState.minWorkSeconds);
      
      // Try to decrement again
      state.decrementWorkTime();
      expect(state.workSeconds, IntervalTimerHomeState.minWorkSeconds);
    });

    test('incrementRestTime increases restSeconds by timeStep', () {
      final initialRest = state.restSeconds;
      state.incrementRestTime();
      expect(state.restSeconds, initialRest + IntervalTimerHomeState.timeStep);
    });

    test('decrementRestTime decreases restSeconds by timeStep', () {
      final initialRest = state.restSeconds;
      state.decrementRestTime();
      expect(state.restSeconds, initialRest - IntervalTimerHomeState.timeStep);
    });

    test('decrementRestTime does not go below minRestSeconds', () {
      // Set to minimum
      while (state.restSeconds > IntervalTimerHomeState.minRestSeconds) {
        state.decrementRestTime();
      }
      expect(state.restSeconds, IntervalTimerHomeState.minRestSeconds);
      
      // Try to decrement again
      state.decrementRestTime();
      expect(state.restSeconds, IntervalTimerHomeState.minRestSeconds);
    });

    test('updateVolume sets volume correctly', () {
      state.updateVolume(0.8);
      expect(state.volume, 0.8);
      
      state.updateVolume(0.0);
      expect(state.volume, 0.0);
      
      state.updateVolume(1.0);
      expect(state.volume, 1.0);
    });

    test('updateVolume clamps to 0.0-1.0 range', () {
      state.updateVolume(1.5);
      expect(state.volume, 1.0);
      
      state.updateVolume(-0.5);
      expect(state.volume, 0.0);
    });

    test('toggleQuickStartSection toggles expanded state', () {
      final initialState = state.quickStartExpanded;
      state.toggleQuickStartSection();
      expect(state.quickStartExpanded, !initialState);
      
      state.toggleQuickStartSection();
      expect(state.quickStartExpanded, initialState);
    });

    test('formatTime formats seconds correctly', () {
      expect(state.formatTime(0), '00 : 00');
      expect(state.formatTime(44), '00 : 44');
      expect(state.formatTime(60), '01 : 00');
      expect(state.formatTime(125), '02 : 05');
      expect(state.formatTime(3599), '59 : 59');
    });

    test('canStart returns true when values are valid', () {
      expect(state.canStart, true);
    });
  });
}

