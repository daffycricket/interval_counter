import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_counter/state/interval_timer_home_state.dart';
import 'package:interval_counter/models/preset.dart';

void main() {
  // Initialiser le binding pour les tests
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('IntervalTimerHomeState', () {
    late IntervalTimerHomeState state;

    setUp(() async {
      // Réinitialiser SharedPreferences avant chaque test
      SharedPreferences.setMockInitialValues({});
      state = await IntervalTimerHomeState.create();
    });

    group('Valeurs initiales', () {
      test('reps initial est 16', () {
        expect(state.reps, 16);
      });

      test('workSeconds initial est 44', () {
        expect(state.workSeconds, 44);
      });

      test('restSeconds initial est 15', () {
        expect(state.restSeconds, 15);
      });

      test('volume initial est 0.62', () {
        expect(state.volume, 0.62);
      });

      test('quickStartExpanded initial est true', () {
        expect(state.quickStartExpanded, true);
      });

      test('presetsEditMode initial est false', () {
        expect(state.presetsEditMode, false);
      });

      test('presets initial est liste vide', () {
        expect(state.presets, isEmpty);
      });
    });

    group('incrementReps', () {
      test('incrémente reps de 1', () {
        state.incrementReps();
        expect(state.reps, 17);
      });

      test('ne dépasse pas maxReps (99)', () {
        // Incrementer jusqu'à 99
        for (int i = 16; i < 99; i++) {
          state.incrementReps();
        }
        expect(state.reps, 99);
        
        // Tenter d'incrementer au-delà
        state.incrementReps();
        expect(state.reps, 99); // Reste à 99
      });

      test('notifie les listeners', () {
        var notified = false;
        state.addListener(() => notified = true);
        
        state.incrementReps();
        expect(notified, true);
      });
    });

    group('decrementReps', () {
      test('décrémente reps de 1', () {
        state.decrementReps();
        expect(state.reps, 15);
      });

      test('ne descend pas en dessous de minReps (1)', () async {
        // Créer un state avec reps = 1
        SharedPreferences.setMockInitialValues({'quick_start_reps': 1});
        final state2 = await IntervalTimerHomeState.create();
        
        expect(state2.reps, 1);
        state2.decrementReps();
        expect(state2.reps, 1); // Reste à 1
      });

      test('notifie les listeners', () {
        var notified = false;
        state.addListener(() => notified = true);
        
        state.decrementReps();
        expect(notified, true);
      });
    });

    group('incrementWorkTime', () {
      test('incrémente workSeconds de 5', () {
        state.incrementWorkTime();
        expect(state.workSeconds, 49);
      });

      test('ne dépasse pas maxWorkSeconds (3600)', () async {
        SharedPreferences.setMockInitialValues({'quick_start_work_seconds': 3598});
        final state2 = await IntervalTimerHomeState.create();
        
        state2.incrementWorkTime();
        expect(state2.workSeconds, 3600);
        
        state2.incrementWorkTime();
        expect(state2.workSeconds, 3600); // Reste à 3600
      });

      test('notifie les listeners', () {
        var notified = false;
        state.addListener(() => notified = true);
        
        state.incrementWorkTime();
        expect(notified, true);
      });
    });

    group('decrementWorkTime', () {
      test('décrémente workSeconds de 5', () {
        state.decrementWorkTime();
        expect(state.workSeconds, 39);
      });

      test('ne descend pas en dessous de minWorkSeconds (5)', () async {
        SharedPreferences.setMockInitialValues({'quick_start_work_seconds': 7});
        final state2 = await IntervalTimerHomeState.create();
        
        state2.decrementWorkTime();
        expect(state2.workSeconds, 5);
        
        state2.decrementWorkTime();
        expect(state2.workSeconds, 5); // Reste à 5
      });

      test('notifie les listeners', () {
        var notified = false;
        state.addListener(() => notified = true);
        
        state.decrementWorkTime();
        expect(notified, true);
      });
    });

    group('incrementRestTime', () {
      test('incrémente restSeconds de 5', () {
        state.incrementRestTime();
        expect(state.restSeconds, 20);
      });

      test('ne dépasse pas maxRestSeconds (3600)', () async {
        SharedPreferences.setMockInitialValues({'quick_start_rest_seconds': 3598});
        final state2 = await IntervalTimerHomeState.create();
        
        state2.incrementRestTime();
        expect(state2.restSeconds, 3600);
        
        state2.incrementRestTime();
        expect(state2.restSeconds, 3600); // Reste à 3600
      });

      test('notifie les listeners', () {
        var notified = false;
        state.addListener(() => notified = true);
        
        state.incrementRestTime();
        expect(notified, true);
      });
    });

    group('decrementRestTime', () {
      test('décrémente restSeconds de 5', () {
        state.decrementRestTime();
        expect(state.restSeconds, 10);
      });

      test('ne descend pas en dessous de minRestSeconds (0)', () async {
        SharedPreferences.setMockInitialValues({'quick_start_rest_seconds': 3});
        final state2 = await IntervalTimerHomeState.create();
        
        state2.decrementRestTime();
        expect(state2.restSeconds, 0);
        
        state2.decrementRestTime();
        expect(state2.restSeconds, 0); // Reste à 0
      });

      test('notifie les listeners', () {
        var notified = false;
        state.addListener(() => notified = true);
        
        state.decrementRestTime();
        expect(notified, true);
      });
    });

    group('onVolumeChange', () {
      test('change la valeur du volume', () {
        state.onVolumeChange(0.8);
        expect(state.volume, 0.8);
      });

      test('clamp à 0.0 si valeur négative', () {
        state.onVolumeChange(-0.5);
        expect(state.volume, 0.0);
      });

      test('clamp à 1.0 si valeur > 1', () {
        state.onVolumeChange(1.5);
        expect(state.volume, 1.0);
      });

      test('notifie les listeners', () {
        var notified = false;
        state.addListener(() => notified = true);
        
        state.onVolumeChange(0.5);
        expect(notified, true);
      });
    });

    group('toggleQuickStartSection', () {
      test('bascule quickStartExpanded de true à false', () {
        expect(state.quickStartExpanded, true);
        state.toggleQuickStartSection();
        expect(state.quickStartExpanded, false);
      });

      test('bascule quickStartExpanded de false à true', () async {
        SharedPreferences.setMockInitialValues({'quick_start_expanded': false});
        final state2 = await IntervalTimerHomeState.create();
        
        expect(state2.quickStartExpanded, false);
        state2.toggleQuickStartSection();
        expect(state2.quickStartExpanded, true);
      });

      test('notifie les listeners', () {
        var notified = false;
        state.addListener(() => notified = true);
        
        state.toggleQuickStartSection();
        expect(notified, true);
      });
    });

    group('saveCurrentAsPreset', () {
      test('ajoute un nouveau preset à la liste', () async {
        await state.saveCurrentAsPreset('Test Preset');
        expect(state.presets, hasLength(1));
        expect(state.presets.first.name, 'Test Preset');
        expect(state.presets.first.reps, 16);
        expect(state.presets.first.workSeconds, 44);
        expect(state.presets.first.restSeconds, 15);
      });

      test('lance une erreur si nom vide', () {
        expect(
          () => state.saveCurrentAsPreset(''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('trim le nom avant de sauvegarder', () async {
        await state.saveCurrentAsPreset('  Test  ');
        expect(state.presets.first.name, 'Test');
      });

      test('notifie les listeners', () async {
        var notified = false;
        state.addListener(() => notified = true);
        
        await state.saveCurrentAsPreset('Test');
        expect(notified, true);
      });
    });

    group('loadPreset', () {
      test('charge les valeurs du preset', () async {
        await state.saveCurrentAsPreset('Test');
        final presetId = state.presets.first.id;
        
        // Changer les valeurs
        state.incrementReps();
        state.incrementWorkTime();
        state.incrementRestTime();
        
        // Charger le preset
        state.loadPreset(presetId);
        
        expect(state.reps, 16);
        expect(state.workSeconds, 44);
        expect(state.restSeconds, 15);
      });

      test('lance une erreur si preset non trouvé', () {
        expect(
          () => state.loadPreset('invalid_id'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('notifie les listeners', () async {
        await state.saveCurrentAsPreset('Test');
        final presetId = state.presets.first.id;
        
        var notified = false;
        state.addListener(() => notified = true);
        
        state.loadPreset(presetId);
        expect(notified, true);
      });
    });

    group('deletePreset', () {
      test('supprime un preset de la liste', () async {
        await state.saveCurrentAsPreset('Test 1');
        await state.saveCurrentAsPreset('Test 2');
        expect(state.presets, hasLength(2));
        
        final presetId = state.presets.first.id;
        await state.deletePreset(presetId);
        
        expect(state.presets, hasLength(1));
        expect(state.presets.first.name, 'Test 2');
      });

      test('notifie les listeners', () async {
        await state.saveCurrentAsPreset('Test');
        final presetId = state.presets.first.id;
        
        var notified = false;
        state.addListener(() => notified = true);
        
        await state.deletePreset(presetId);
        expect(notified, true);
      });
    });

    group('enterEditMode / exitEditMode', () {
      test('enterEditMode met presetsEditMode à true', () {
        expect(state.presetsEditMode, false);
        state.enterEditMode();
        expect(state.presetsEditMode, true);
      });

      test('exitEditMode met presetsEditMode à false', () {
        state.enterEditMode();
        expect(state.presetsEditMode, true);
        
        state.exitEditMode();
        expect(state.presetsEditMode, false);
      });

      test('notifie les listeners', () {
        var notified = false;
        state.addListener(() => notified = true);
        
        state.enterEditMode();
        expect(notified, true);
        
        notified = false;
        state.exitEditMode();
        expect(notified, true);
      });
    });

    group('formatTime', () {
      test('formate correctement 44 secondes', () {
        expect(state.formatTime(44), '00 : 44');
      });

      test('formate correctement 125 secondes', () {
        expect(state.formatTime(125), '02 : 05');
      });

      test('formate correctement 3600 secondes', () {
        expect(state.formatTime(3600), '60 : 00');
      });

      test('formate correctement 0 secondes', () {
        expect(state.formatTime(0), '00 : 00');
      });
    });

    group('Persistence', () {
      test('les valeurs sont persistées dans SharedPreferences', () async {
        // Modifier les valeurs
        state.incrementReps();
        state.incrementWorkTime();
        state.incrementRestTime();
        state.onVolumeChange(0.9);
        state.toggleQuickStartSection();
        
        // Créer un nouvel état (simule un redémarrage de l'app)
        final state2 = await IntervalTimerHomeState.create();
        
        expect(state2.reps, 17);
        expect(state2.workSeconds, 49);
        expect(state2.restSeconds, 20);
        expect(state2.volume, 0.9);
        expect(state2.quickStartExpanded, false);
      });

      test('les presets sont persistés dans SharedPreferences', () async {
        await state.saveCurrentAsPreset('Test Preset');
        
        // Créer un nouvel état
        final state2 = await IntervalTimerHomeState.create();
        
        expect(state2.presets, hasLength(1));
        expect(state2.presets.first.name, 'Test Preset');
      });
    });
  });
}

