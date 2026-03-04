import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/state/preset_editor_state.dart';
import 'package:interval_counter/state/home_state.dart';
import 'package:interval_counter/models/preset.dart';
import '../helpers/mock_services.dart';

void main() {
  group('PresetEditorState', () {
    late HomeState homeState;

    setUp(() {
      homeState = HomeState(MockPreferencesRepository());
    });

    group('Initial values', () {
      test('default values for create mode', () {
        final state = PresetEditorState(homeState);

        expect(state.name, '');
        expect(state.prepareSeconds, 5);
        expect(state.repetitions, 10);
        expect(state.workSeconds, 40);
        expect(state.restSeconds, 20);
        expect(state.cooldownSeconds, 30);
        expect(state.viewMode, 'simple');
        expect(state.editMode, false);
        expect(state.presetId, null);
      });

      test('custom initial values for create mode', () {
        final state = PresetEditorState(
          homeState,
          initialName: 'Test',
          initialPrepareSeconds: 10,
          initialRepetitions: 15,
          initialWorkSeconds: 50,
          initialRestSeconds: 25,
          initialCooldownSeconds: 35,
        );

        expect(state.name, 'Test');
        expect(state.prepareSeconds, 10);
        expect(state.repetitions, 15);
        expect(state.workSeconds, 50);
        expect(state.restSeconds, 25);
        expect(state.cooldownSeconds, 35);
      });

      test('values from existing preset in edit mode', () {
        final preset = Preset.create(
          name: 'Existing',
          prepareSeconds: 15,
          repetitions: 12,
          workSeconds: 45,
          restSeconds: 30,
          cooldownSeconds: 40,
        );
        homeState.addPresetDirect(preset);

        final state = PresetEditorState(
          homeState,
          isEditMode: true,
          presetId: preset.id,
        );

        expect(state.name, 'Existing');
        expect(state.prepareSeconds, 15);
        expect(state.repetitions, 12);
        expect(state.workSeconds, 45);
        expect(state.restSeconds, 30);
        expect(state.cooldownSeconds, 40);
        expect(state.editMode, true);
        expect(state.presetId, preset.id);
      });
    });

    group('incrementPrepare', () {
      test('increments from default (5) to 6', () {
        final state = PresetEditorState(homeState);
        var notified = false;
        state.addListener(() => notified = true);

        state.incrementPrepare();

        expect(state.prepareSeconds, 6);
        expect(notified, true);
      });

      test('increments multiple times', () {
        final state = PresetEditorState(homeState);

        state.incrementPrepare();
        state.incrementPrepare();
        state.incrementPrepare();

        expect(state.prepareSeconds, 8);
      });

      test('does not exceed max (3599)', () {
        final state = PresetEditorState(
          homeState,
          initialPrepareSeconds: 3599,
        );

        state.incrementPrepare();

        expect(state.prepareSeconds, 3599);
      });
    });

    group('decrementPrepare', () {
      test('decrements from 5 to 4', () {
        final state = PresetEditorState(homeState);
        var notified = false;
        state.addListener(() => notified = true);

        state.decrementPrepare();

        expect(state.prepareSeconds, 4);
        expect(notified, true);
      });

      test('stops at minimum (0)', () {
        final state = PresetEditorState(
          homeState,
          initialPrepareSeconds: 0,
        );

        state.decrementPrepare();

        expect(state.prepareSeconds, 0);
      });
    });

    group('incrementReps', () {
      test('increments from default (10) to 11', () {
        final state = PresetEditorState(homeState);
        var notified = false;
        state.addListener(() => notified = true);

        state.incrementReps();

        expect(state.repetitions, 11);
        expect(notified, true);
      });

      test('does not exceed max (999)', () {
        final state = PresetEditorState(
          homeState,
          initialRepetitions: 999,
        );

        state.incrementReps();

        expect(state.repetitions, 999);
      });
    });

    group('decrementReps', () {
      test('decrements from 10 to 9', () {
        final state = PresetEditorState(homeState);
        var notified = false;
        state.addListener(() => notified = true);

        state.decrementReps();

        expect(state.repetitions, 9);
        expect(notified, true);
      });

      test('stops at minimum (1)', () {
        final state = PresetEditorState(
          homeState,
          initialRepetitions: 1,
        );

        state.decrementReps();

        expect(state.repetitions, 1);
      });
    });

    group('incrementWork', () {
      test('increments from default (40) to 41', () {
        final state = PresetEditorState(homeState);

        state.incrementWork();

        expect(state.workSeconds, 41);
      });
    });

    group('decrementWork', () {
      test('decrements from 40 to 39', () {
        final state = PresetEditorState(homeState);

        state.decrementWork();

        expect(state.workSeconds, 39);
      });

      test('stops at minimum (0)', () {
        final state = PresetEditorState(
          homeState,
          initialWorkSeconds: 0,
        );

        state.decrementWork();

        expect(state.workSeconds, 0);
      });
    });

    group('incrementRest', () {
      test('increments from default (20) to 21', () {
        final state = PresetEditorState(homeState);

        state.incrementRest();

        expect(state.restSeconds, 21);
      });
    });

    group('decrementRest', () {
      test('decrements from 20 to 19', () {
        final state = PresetEditorState(homeState);

        state.decrementRest();

        expect(state.restSeconds, 19);
      });

      test('stops at minimum (0)', () {
        final state = PresetEditorState(
          homeState,
          initialRestSeconds: 0,
        );

        state.decrementRest();

        expect(state.restSeconds, 0);
      });
    });

    group('incrementCooldown', () {
      test('increments from default (30) to 31', () {
        final state = PresetEditorState(homeState);

        state.incrementCooldown();

        expect(state.cooldownSeconds, 31);
      });
    });

    group('decrementCooldown', () {
      test('decrements from 30 to 29', () {
        final state = PresetEditorState(homeState);

        state.decrementCooldown();

        expect(state.cooldownSeconds, 29);
      });

      test('stops at minimum (0)', () {
        final state = PresetEditorState(
          homeState,
          initialCooldownSeconds: 0,
        );

        state.decrementCooldown();

        expect(state.cooldownSeconds, 0);
      });
    });

    group('onNameChange', () {
      test('updates name to "Test"', () {
        final state = PresetEditorState(homeState);
        var notified = false;
        state.addListener(() => notified = true);

        state.onNameChange('Test');

        expect(state.name, 'Test');
        expect(notified, true);
      });

      test('handles empty string', () {
        final state = PresetEditorState(homeState, initialName: 'Initial');

        state.onNameChange('');

        expect(state.name, '');
      });
    });

    group('Mode switching', () {
      test('switchToSimple sets viewMode to "simple"', () {
        final state = PresetEditorState(homeState);
        state.switchToAdvanced();
        var notified = false;
        state.addListener(() => notified = true);

        state.switchToSimple();

        expect(state.viewMode, 'simple');
        expect(notified, true);
      });

      test('switchToAdvanced sets viewMode to "advanced"', () {
        final state = PresetEditorState(homeState);
        var notified = false;
        state.addListener(() => notified = true);

        state.switchToAdvanced();

        expect(state.viewMode, 'advanced');
        expect(notified, true);
      });
    });

    group('save', () {
      test('saves preset with valid name in create mode', () {
        final state = PresetEditorState(
          homeState,
          initialName: 'New Preset',
          initialPrepareSeconds: 10,
          initialRepetitions: 15,
          initialWorkSeconds: 45,
          initialRestSeconds: 25,
          initialCooldownSeconds: 35,
        );

        final result = state.save();

        expect(result, true);
        expect(homeState.presets.length, 1);
        expect(homeState.presets[0].name, 'New Preset');
        expect(homeState.presets[0].prepareSeconds, 10);
        expect(homeState.presets[0].repetitions, 15);
      });

      test('saves preset with valid name in edit mode', () {
        final preset = Preset.create(
          name: 'Original',
          prepareSeconds: 5,
          repetitions: 10,
          workSeconds: 40,
          restSeconds: 20,
          cooldownSeconds: 30,
        );
        homeState.addPresetDirect(preset);

        final state = PresetEditorState(
          homeState,
          isEditMode: true,
          presetId: preset.id,
        );
        state.onNameChange('Modified');
        state.incrementReps();

        final result = state.save();

        expect(result, true);
        expect(homeState.presets.length, 1);
        expect(homeState.presets[0].name, 'Modified');
        expect(homeState.presets[0].repetitions, 11);
      });

      test('rejects empty name', () {
        final state = PresetEditorState(homeState, initialName: '');

        expect(() => state.save(), throwsException);
        expect(homeState.presets.length, 0);
      });

      test('trims whitespace from name', () {
        final state = PresetEditorState(
          homeState,
          initialName: '  Trimmed  ',
        );

        state.save();

        expect(homeState.presets[0].name, 'Trimmed');
      });
    });

    group('close', () {
      test('closes without saving', () {
        final state = PresetEditorState(homeState);

        state.close();

        // close() is a no-op, just verify it doesn't throw
        expect(homeState.presets.length, 0);
      });
    });

    group('Total calculation', () {
      test('calculates correct total (5 + 10×(40+20) + 30 = 635s)', () {
        final state = PresetEditorState(homeState);

        final total = state.formattedTotal;

        // 5 + 10*(40+20) + 30 = 5 + 600 + 30 = 635 = 10:35
        expect(total, 'TOTAL 10:35');
      });

      test('formats as "TOTAL mm:ss"', () {
        final state = PresetEditorState(
          homeState,
          initialPrepareSeconds: 0,
          initialRepetitions: 1,
          initialWorkSeconds: 90,
          initialRestSeconds: 30,
          initialCooldownSeconds: 0,
        );

        final total = state.formattedTotal;

        // 0 + 1*(90+30) + 0 = 120 = 2:00
        expect(total, 'TOTAL 02:00');
      });

      test('updates when parameters change', () {
        final state = PresetEditorState(homeState);

        state.incrementPrepare();
        final total = state.formattedTotal;

        // 6 + 10*(40+20) + 30 = 636 = 10:36
        expect(total, 'TOTAL 10:36');
      });
    });

    group('formatTime', () {
      test('formats 5 seconds as "00 : 05"', () {
        final state = PresetEditorState(
          homeState,
          initialPrepareSeconds: 5,
        );

        expect(state.formattedPrepareTime, '00 : 05');
      });

      test('formats 89 seconds as "01 : 29"', () {
        final state = PresetEditorState(
          homeState,
          initialWorkSeconds: 89,
        );

        expect(state.formattedWorkTime, '01 : 29');
      });

      test('formats 0 seconds as "00 : 00"', () {
        final state = PresetEditorState(
          homeState,
          initialRestSeconds: 0,
        );

        expect(state.formattedRestTime, '00 : 00');
      });

      test('formats 60 seconds as "01 : 00"', () {
        final state = PresetEditorState(
          homeState,
          initialCooldownSeconds: 60,
        );

        expect(state.formattedCooldownTime, '01 : 00');
      });
    });
  });
}

