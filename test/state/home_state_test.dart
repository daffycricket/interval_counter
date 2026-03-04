import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/state/home_state.dart';
import '../helpers/mock_services.dart';

void main() {
  group('HomeState', () {
    late MockPreferencesRepository repo;
    late HomeState state;

    setUp(() {
      repo = MockPreferencesRepository();
      state = HomeState(repo);
    });

    test('loads default values on initialization', () {
      expect(state.reps, 10);
      expect(state.workSeconds, 40);
      expect(state.restSeconds, 20);
      expect(state.volume, closeTo(0.62, 0.01));
      expect(state.quickStartExpanded, true);
      expect(state.presets, isEmpty);
      expect(state.editMode, false);
    });

    test('incrementReps increases from default (10) to 11', () {
      expect(state.reps, 10);
      state.incrementReps();
      expect(state.reps, 11);
    });

    test('incrementReps stops at maxReps (999)', () {
      for (var i = 10; i < 999; i++) {
        state.incrementReps();
      }
      expect(state.reps, 999);
      state.incrementReps();
      expect(state.reps, 999);
    });

    test('decrementReps decrements from 10 to 9', () {
      state.decrementReps();
      expect(state.reps, 9);
    });

    test('decrementReps stops at minimum (1)', () {
      repo.set<int>('home_reps', 2);
      state = HomeState(repo);
      expect(state.reps, 2);
      state.decrementReps();
      expect(state.reps, 1);
      state.decrementReps();
      expect(state.reps, 1);
    });

    test('incrementWork increments from default (40) to 41', () {
      state.incrementWork();
      expect(state.workSeconds, 41);
    });

    test('decrementWork decrements from 40 to 39', () {
      state.decrementWork();
      expect(state.workSeconds, 39);
    });

    test('decrementWork stops at minimum (1)', () {
      repo.set<int>('home_work_seconds', 2);
      state = HomeState(repo);
      expect(state.workSeconds, 2);
      state.decrementWork();
      expect(state.workSeconds, 1);
      state.decrementWork();
      expect(state.workSeconds, 1);
    });

    test('incrementRest increments from default (20) to 21', () {
      state.incrementRest();
      expect(state.restSeconds, 21);
    });

    test('decrementRest decrements from 20 to 19', () {
      state.decrementRest();
      expect(state.restSeconds, 19);
    });

    test('decrementRest stops at minimum (0)', () {
      repo.set<int>('home_rest_seconds', 1);
      state = HomeState(repo);
      expect(state.restSeconds, 1);
      state.decrementRest();
      expect(state.restSeconds, 0);
      state.decrementRest();
      expect(state.restSeconds, 0);
    });

    test('onVolumeChange updates volume to 0.5', () {
      state.onVolumeChange(0.5);
      expect(state.volume, 0.5);
    });

    test('onVolumeChange clamps volume to [0.0, 1.0]', () {
      state.onVolumeChange(-0.5);
      expect(state.volume, 0.0);
      state.onVolumeChange(1.5);
      expect(state.volume, 1.0);
    });

    test('toggleQuickStart toggles from true to false', () {
      expect(state.quickStartExpanded, true);
      state.toggleQuickStart();
      expect(state.quickStartExpanded, false);
    });

    test('toggleQuickStart toggles from false to true', () {
      state.toggleQuickStart();
      state.toggleQuickStart();
      expect(state.quickStartExpanded, true);
    });

    test('savePreset adds preset with valid name', () {
      expect(state.presets, isEmpty);
      state.savePreset('Gainage');
      expect(state.presets, hasLength(1));
      expect(state.presets[0].name, 'Gainage');
      expect(state.presets[0].repetitions, 10);
      expect(state.presets[0].workSeconds, 40);
      expect(state.presets[0].restSeconds, 20);
    });

    test('savePreset rejects empty name', () {
      expect(() => state.savePreset(''), throwsA(isA<ArgumentError>()));
      expect(() => state.savePreset('   '), throwsA(isA<ArgumentError>()));
    });

    test('deletePreset removes existing preset', () {
      state.savePreset('Preset 1');
      state.savePreset('Preset 2');
      expect(state.presets, hasLength(2));
      final idToDelete = state.presets[0].id;
      state.deletePreset(idToDelete);
      expect(state.presets, hasLength(1));
      expect(state.presets[0].name, 'Preset 2');
    });

    test('deletePreset handles non-existent id', () {
      state.savePreset('Preset 1');
      state.deletePreset('non-existent-id');
      expect(state.presets, hasLength(1));
    });

    test('editPresets toggles editMode', () {
      expect(state.editMode, false);
      state.editPresets();
      expect(state.editMode, true);
      state.editPresets();
      expect(state.editMode, false);
    });

    test('addPresetDirect adds preset', () {
      final preset = state.presets;
      expect(preset, isEmpty);
      state.savePreset('Direct');
      expect(state.presets, hasLength(1));
    });

    test('updatePreset replaces existing preset', () {
      state.savePreset('Old name');
      final id = state.presets[0].id;
      final updated = state.presets[0].copyWith(name: 'New name');
      state.updatePreset(updated);
      expect(state.presets[0].name, 'New name');
      expect(state.presets[0].id, id);
    });

    test('updatePreset ignores unknown id', () {
      state.savePreset('Keep');
      final unknown = state.presets[0].copyWith(id: 'unknown');
      state.updatePreset(unknown);
      expect(state.presets[0].name, 'Keep');
    });

    test('formattedWorkTime returns formatted work time', () {
      expect(state.formattedWorkTime, '00 : 40');
      state.incrementWork();
      state.incrementWork();
      expect(state.formattedWorkTime, '00 : 42');
    });

    test('formattedRestTime returns formatted rest time', () {
      expect(state.formattedRestTime, '00 : 20');
      state.decrementRest();
      state.decrementRest();
      expect(state.formattedRestTime, '00 : 18');
    });

    test('state persists to repository', () async {
      state.incrementReps();
      state.incrementWork();
      state.savePreset('Test');
      await Future.delayed(const Duration(milliseconds: 10));

      final newState = HomeState(repo);
      expect(newState.reps, 11);
      expect(newState.workSeconds, 41);
      expect(newState.presets, hasLength(1));
      expect(newState.presets[0].name, 'Test');
    });

    test('notifyListeners called on incrementReps', () {
      var notified = false;
      state.addListener(() => notified = true);
      state.incrementReps();
      expect(notified, true);
    });

    test('notifyListeners called on toggleQuickStart', () {
      var notified = false;
      state.addListener(() => notified = true);
      state.toggleQuickStart();
      expect(notified, true);
    });

    test('notifyListeners called on savePreset', () {
      var notified = false;
      state.addListener(() => notified = true);
      state.savePreset('Notif');
      expect(notified, true);
    });

    test('notifyListeners called on deletePreset', () {
      state.savePreset('Delete me');
      var notified = false;
      state.addListener(() => notified = true);
      state.deletePreset(state.presets[0].id);
      expect(notified, true);
    });
  });
}
