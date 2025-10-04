import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/state/interval_timer_home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('IntervalTimerHomeState - Unit Tests', () {
    test('T16: incrementRepetitions() increments from 16 to 17', () async {
      final state = IntervalTimerHomeState();
      await state.initialize();
      
      expect(state.repetitions, 16);
      await state.incrementRepetitions();
      expect(state.repetitions, 17);
    });

    test('T17: decrementRepetitions() decrements from 16 to 15', () async {
      final state = IntervalTimerHomeState();
      await state.initialize();
      
      expect(state.repetitions, 16);
      await state.decrementRepetitions();
      expect(state.repetitions, 15);
    });

    test('T18: incrementRepetitions() at 99 stays at 99', () async {
      final state = IntervalTimerHomeState();
      await state.initialize();
      
      // Increment to 99
      for (int i = 16; i < 99; i++) {
        await state.incrementRepetitions();
      }
      expect(state.repetitions, 99);
      
      // Try to increment beyond
      await state.incrementRepetitions();
      expect(state.repetitions, 99);
    });

    test('T19: decrementRepetitions() at 1 stays at 1', () async {
      final state = IntervalTimerHomeState();
      await state.initialize();
      
      // Decrement to 1
      for (int i = 16; i > 1; i--) {
        await state.decrementRepetitions();
      }
      expect(state.repetitions, 1);
      
      // Try to decrement beyond
      await state.decrementRepetitions();
      expect(state.repetitions, 1);
    });

    test('T20: saveQuickStartAsPreset() creates and adds preset', () async {
      final state = IntervalTimerHomeState();
      await state.initialize();
      
      expect(state.presetsList.length, 0);
      
      final preset = await state.saveQuickStartAsPreset('Test Preset');
      
      expect(state.presetsList.length, 1);
      expect(preset.name, 'Test Preset');
      expect(preset.repetitions, 16);
      expect(preset.workSeconds, 44);
      expect(preset.restSeconds, 15);
    });

    test('validateConfig() returns true for valid config', () async {
      final state = IntervalTimerHomeState();
      await state.initialize();
      
      expect(state.validateConfig(), true);
    });

    test('setVolume() updates volume level', () async {
      final state = IntervalTimerHomeState();
      await state.initialize();
      
      expect(state.volumeLevel, 0.62);
      await state.setVolume(0.8);
      expect(state.volumeLevel, 0.8);
    });

    test('toggleQuickStartExpanded() toggles state', () async {
      final state = IntervalTimerHomeState();
      await state.initialize();
      
      expect(state.quickStartExpanded, true);
      await state.toggleQuickStartExpanded();
      expect(state.quickStartExpanded, false);
      await state.toggleQuickStartExpanded();
      expect(state.quickStartExpanded, true);
    });
  });
}
