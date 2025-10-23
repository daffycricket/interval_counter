import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_counter/state/home_state.dart';

void main() {
  group('HomeState', () {
    late SharedPreferences prefs;
    late HomeState state;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      state = HomeState(prefs);
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

    test('incrementReps increments from 998 to 999 (boundary)', () {
      // Charger une valeur proche de la limite
      prefs.setInt('home_reps', 998);
      state = HomeState(prefs);
      
      expect(state.reps, 998);
      state.incrementReps();
      expect(state.reps, 999);
      
      // Vérifier qu'on ne dépasse pas le max
      state.incrementReps();
      expect(state.reps, 999);
    });

    test('decrementReps decrements from 10 to 9', () {
      expect(state.reps, 10);
      state.decrementReps();
      expect(state.reps, 9);
    });

    test('decrementReps stops at minimum (1)', () {
      prefs.setInt('home_reps', 2);
      state = HomeState(prefs);
      
      expect(state.reps, 2);
      state.decrementReps();
      expect(state.reps, 1);
      
      // Vérifier qu'on ne descend pas en dessous du min
      state.decrementReps();
      expect(state.reps, 1);
    });

    test('incrementWork increments from default (40) to 41', () {
      expect(state.workSeconds, 40);
      state.incrementWork();
      expect(state.workSeconds, 41);
    });

    test('decrementWork decrements from 40 to 39', () {
      expect(state.workSeconds, 40);
      state.decrementWork();
      expect(state.workSeconds, 39);
    });

    test('decrementWork stops at minimum (1)', () {
      prefs.setInt('home_work_seconds', 2);
      state = HomeState(prefs);
      
      expect(state.workSeconds, 2);
      state.decrementWork();
      expect(state.workSeconds, 1);
      
      // Vérifier qu'on ne descend pas en dessous du min
      state.decrementWork();
      expect(state.workSeconds, 1);
    });

    test('incrementRest increments from default (20) to 21', () {
      expect(state.restSeconds, 20);
      state.incrementRest();
      expect(state.restSeconds, 21);
    });

    test('decrementRest decrements from 20 to 19', () {
      expect(state.restSeconds, 20);
      state.decrementRest();
      expect(state.restSeconds, 19);
    });

    test('decrementRest stops at minimum (0)', () {
      prefs.setInt('home_rest_seconds', 1);
      state = HomeState(prefs);
      
      expect(state.restSeconds, 1);
      state.decrementRest();
      expect(state.restSeconds, 0);
      
      // Vérifier qu'on ne descend pas en dessous de 0
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
      state.toggleQuickStart(); // false
      state.toggleQuickStart(); // true
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
      expect(
        () => state.savePreset(''),
        throwsA(isA<ArgumentError>()),
      );
      
      expect(
        () => state.savePreset('   '),
        throwsA(isA<ArgumentError>()),
      );
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

    test('deletePreset handles non-existent preset', () {
      state.savePreset('Preset 1');
      expect(state.presets, hasLength(1));
      
      state.deletePreset('non-existent-id');
      
      expect(state.presets, hasLength(1));
    });

    test('formatTime formats 44 seconds as "00 : 44"', () {
      expect(HomeState.formatTime(44), '00 : 44');
    });

    test('formatTime formats 0 seconds as "00 : 00"', () {
      expect(HomeState.formatTime(0), '00 : 00');
    });

    test('formatTime formats 3661 seconds as "01 : 01 : 01"', () {
      expect(HomeState.formatTime(3661), '01 : 01 : 01');
    });

    test('formatTime formats 65 seconds as "01 : 05"', () {
      expect(HomeState.formatTime(65), '01 : 05');
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

    test('state persists to SharedPreferences', () async {
      state.incrementReps();
      state.incrementWork();
      state.savePreset('Test');
      
      // Attendre que la sauvegarde asynchrone se termine
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Créer un nouveau state qui devrait charger les valeurs sauvegardées
      final newState = HomeState(prefs);
      
      expect(newState.reps, 11);
      expect(newState.workSeconds, 41);
      expect(newState.presets, hasLength(1));
      expect(newState.presets[0].name, 'Test');
    });
  });
}

