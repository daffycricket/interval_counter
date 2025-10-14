import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_counter/state/interval_timer_home_state.dart';

void main() {
  group('IntervalTimerHomeState', () {
    late SharedPreferences prefs;
    late IntervalTimerHomeState state;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      state = IntervalTimerHomeState(prefs);
    });

    group('Initial Values', () {
      test('should have default reps of 16', () {
        expect(state.reps, 16);
      });

      test('should have default workSeconds of 44', () {
        expect(state.workSeconds, 44);
      });

      test('should have default restSeconds of 15', () {
        expect(state.restSeconds, 15);
      });

      test('should have default volume of 0.62', () {
        expect(state.volume, 0.62);
      });

      test('should have volumePanelVisible as false', () {
        expect(state.volumePanelVisible, false);
      });

      test('should have quickStartExpanded as true', () {
        expect(state.quickStartExpanded, true);
      });

      test('should have presetsEditMode as false', () {
        expect(state.presetsEditMode, false);
      });

      test('should have empty presets list', () {
        expect(state.presets, isEmpty);
      });
    });

    group('incrementReps', () {
      test('should increment reps from 16 to 17', () {
        state.incrementReps();
        expect(state.reps, 17);
      });

      test('should not exceed max (99)', () {
        // Set to max
        for (int i = 16; i < 99; i++) {
          state.incrementReps();
        }
        expect(state.reps, 99);

        // Try to exceed
        state.incrementReps();
        expect(state.reps, 99);
      });

      test('should call notifyListeners', () {
        var notified = false;
        state.addListener(() => notified = true);

        state.incrementReps();
        expect(notified, true);
      });

      test('should persist value', () async {
        state.incrementReps();
        await Future.delayed(const Duration(milliseconds: 10));
        expect(prefs.getInt('quick_start_reps'), 17);
      });
    });

    group('decrementReps', () {
      test('should decrement reps from 16 to 15', () {
        state.decrementReps();
        expect(state.reps, 15);
      });

      test('should not go below min (1)', () {
        // Set to min
        for (int i = 16; i > 1; i--) {
          state.decrementReps();
        }
        expect(state.reps, 1);

        // Try to go below
        state.decrementReps();
        expect(state.reps, 1);
      });

      test('should call notifyListeners', () {
        var notified = false;
        state.addListener(() => notified = true);

        state.decrementReps();
        expect(notified, true);
      });
    });

    group('incrementWorkTime', () {
      test('should increment by 5 seconds', () {
        state.incrementWorkTime();
        expect(state.workSeconds, 49);
      });

      test('should not exceed max (3600)', () {
        // Set near max
        for (int i = 44; i < 3600; i += 5) {
          state.incrementWorkTime();
        }
        expect(state.workSeconds, 3600);

        // Try to exceed
        state.incrementWorkTime();
        expect(state.workSeconds, 3600);
      });

      test('should call notifyListeners', () {
        var notified = false;
        state.addListener(() => notified = true);

        state.incrementWorkTime();
        expect(notified, true);
      });
    });

    group('decrementWorkTime', () {
      test('should decrement by 5 seconds', () {
        state.decrementWorkTime();
        expect(state.workSeconds, 39);
      });

      test('should not go below min (5)', () {
        // Set to min
        while (state.workSeconds > 5) {
          state.decrementWorkTime();
        }
        expect(state.workSeconds, 5);

        // Try to go below
        state.decrementWorkTime();
        expect(state.workSeconds, 5);
      });

      test('should call notifyListeners', () {
        var notified = false;
        state.addListener(() => notified = true);

        state.decrementWorkTime();
        expect(notified, true);
      });
    });

    group('incrementRestTime', () {
      test('should increment by 5 seconds', () {
        state.incrementRestTime();
        expect(state.restSeconds, 20);
      });

      test('should not exceed max (3600)', () {
        // Set near max
        for (int i = 15; i < 3600; i += 5) {
          state.incrementRestTime();
        }
        expect(state.restSeconds, 3600);

        // Try to exceed
        state.incrementRestTime();
        expect(state.restSeconds, 3600);
      });

      test('should call notifyListeners', () {
        var notified = false;
        state.addListener(() => notified = true);

        state.incrementRestTime();
        expect(notified, true);
      });
    });

    group('decrementRestTime', () {
      test('should decrement by 5 seconds', () {
        state.decrementRestTime();
        expect(state.restSeconds, 10);
      });

      test('should allow 0 (min)', () {
        // Set to min
        while (state.restSeconds > 0) {
          state.decrementRestTime();
        }
        expect(state.restSeconds, 0);

        // Try to go below
        state.decrementRestTime();
        expect(state.restSeconds, 0);
      });

      test('should call notifyListeners', () {
        var notified = false;
        state.addListener(() => notified = true);

        state.decrementRestTime();
        expect(notified, true);
      });
    });

    group('onVolumeChange', () {
      test('should update volume and persist', () async {
        state.onVolumeChange(0.8);
        expect(state.volume, 0.8);

        await Future.delayed(const Duration(milliseconds: 10));
        expect(prefs.getDouble('volume'), 0.8);
      });

      test('should clamp to [0.0, 1.0]', () {
        state.onVolumeChange(1.5);
        expect(state.volume, 1.0);

        state.onVolumeChange(-0.5);
        expect(state.volume, 0.0);
      });

      test('should call notifyListeners', () {
        var notified = false;
        state.addListener(() => notified = true);

        state.onVolumeChange(0.5);
        expect(notified, true);
      });
    });

    group('toggleQuickStartSection', () {
      test('should toggle expanded state', () {
        final initial = state.quickStartExpanded;
        state.toggleQuickStartSection();
        expect(state.quickStartExpanded, !initial);
      });

      test('should persist state', () async {
        state.toggleQuickStartSection();
        await Future.delayed(const Duration(milliseconds: 10));
        expect(prefs.getBool('quick_start_expanded'), false);
      });

      test('should call notifyListeners', () {
        var notified = false;
        state.addListener(() => notified = true);

        state.toggleQuickStartSection();
        expect(notified, true);
      });
    });

    group('toggleVolumePanel', () {
      test('should toggle panel visibility', () {
        expect(state.volumePanelVisible, false);
        state.toggleVolumePanel();
        expect(state.volumePanelVisible, true);
        state.toggleVolumePanel();
        expect(state.volumePanelVisible, false);
      });

      test('should call notifyListeners', () {
        var notified = false;
        state.addListener(() => notified = true);

        state.toggleVolumePanel();
        expect(notified, true);
      });
    });

    group('saveCurrentAsPreset', () {
      test('should add preset to list', () async {
        await state.saveCurrentAsPreset('Test Preset');
        expect(state.presets.length, 1);
        expect(state.presets[0].name, 'Test Preset');
        expect(state.presets[0].reps, 16);
        expect(state.presets[0].workSeconds, 44);
        expect(state.presets[0].restSeconds, 15);
      });

      test('should persist preset', () async {
        await state.saveCurrentAsPreset('Persisted');
        await Future.delayed(const Duration(milliseconds: 10));

        final presetsJson = prefs.getString('presets');
        expect(presetsJson, isNotNull);
        expect(presetsJson, contains('Persisted'));
      });

      test('should handle storage errors', () async {
        expect(
          () => state.saveCurrentAsPreset(''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should call notifyListeners', () async {
        var notified = false;
        state.addListener(() => notified = true);

        await state.saveCurrentAsPreset('Test');
        expect(notified, true);
      });
    });

    group('loadPreset', () {
      test('should load preset values into current state', () async {
        await state.saveCurrentAsPreset('Original');
        final presetId = state.presets[0].id;

        // Change values
        state.incrementReps();
        state.incrementWorkTime();
        state.incrementRestTime();

        // Load preset
        state.loadPreset(presetId);

        expect(state.reps, 16);
        expect(state.workSeconds, 44);
        expect(state.restSeconds, 15);
      });

      test('should handle missing preset', () {
        expect(
          () => state.loadPreset('nonexistent'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should call notifyListeners', () async {
        await state.saveCurrentAsPreset('Test');
        final presetId = state.presets[0].id;

        var notified = false;
        state.addListener(() => notified = true);

        state.loadPreset(presetId);
        expect(notified, true);
      });
    });

    group('deletePreset', () {
      test('should remove preset from list', () async {
        await state.saveCurrentAsPreset('To Delete');
        expect(state.presets.length, 1);

        final presetId = state.presets[0].id;
        await state.deletePreset(presetId);

        expect(state.presets.length, 0);
      });

      test('should persist changes', () async {
        await state.saveCurrentAsPreset('To Delete');
        final presetId = state.presets[0].id;

        await state.deletePreset(presetId);
        await Future.delayed(const Duration(milliseconds: 10));

        final presetsJson = prefs.getString('presets');
        expect(presetsJson, isNotNull);
        expect(presetsJson, equals('[]'));
      });

      test('should call notifyListeners', () async {
        await state.saveCurrentAsPreset('Test');
        final presetId = state.presets[0].id;

        var notified = false;
        state.addListener(() => notified = true);

        await state.deletePreset(presetId);
        expect(notified, true);
      });
    });

    group('Constructor with saved state', () {
      test('should load defaults when no saved state', () {
        expect(state.reps, 16);
        expect(state.workSeconds, 44);
        expect(state.restSeconds, 15);
      });

      test('should load saved state from SharedPreferences', () async {
        await prefs.setInt('quick_start_reps', 25);
        await prefs.setInt('quick_start_work_seconds', 60);
        await prefs.setInt('quick_start_rest_seconds', 30);
        await prefs.setDouble('volume', 0.75);
        await prefs.setBool('quick_start_expanded', false);

        final newState = IntervalTimerHomeState(prefs);

        expect(newState.reps, 25);
        expect(newState.workSeconds, 60);
        expect(newState.restSeconds, 30);
        expect(newState.volume, 0.75);
        expect(newState.quickStartExpanded, false);
      });

      test('should validate and clamp loaded values', () async {
        await prefs.setInt('quick_start_reps', 150); // exceeds max
        await prefs.setInt('quick_start_work_seconds', 0); // below min
        await prefs.setDouble('volume', 2.0); // exceeds max

        final newState = IntervalTimerHomeState(prefs);

        expect(newState.reps, 99); // clamped to max
        expect(newState.workSeconds, 5); // clamped to min
        expect(newState.volume, 1.0); // clamped to max
      });
    });

    group('enterEditMode and exitEditMode', () {
      test('should enter edit mode', () {
        state.enterEditMode();
        expect(state.presetsEditMode, true);
      });

      test('should exit edit mode', () {
        state.enterEditMode();
        state.exitEditMode();
        expect(state.presetsEditMode, false);
      });

      test('should call notifyListeners', () {
        var notified = false;
        state.addListener(() => notified = true);

        state.enterEditMode();
        expect(notified, true);
      });
    });
  });
}
