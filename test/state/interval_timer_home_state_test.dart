import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/state/interval_timer_home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IntervalTimerHomeState', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Valeurs par défaut correctes', () {
      final state = IntervalTimerHomeState();
      expect(state.reps, 16);
      expect(state.workSeconds, 44);
      expect(state.restSeconds, 15);
      expect(state.volume, 0.62);
      expect(state.quickStartExpanded, true);
    });

    test('Incrémenter les répétitions', () {
      final state = IntervalTimerHomeState();
      final initialReps = state.reps;

      state.incrementReps();

      expect(state.reps, initialReps + 1);
    });

    test('Décrémenter les répétitions', () {
      final state = IntervalTimerHomeState();
      final initialReps = state.reps;

      state.decrementReps();

      expect(state.reps, initialReps - 1);
    });

    test('Ne peut pas décrémenter en dessous du minimum (reps)', () {
      final state = IntervalTimerHomeState();

      // Descendre au minimum
      while (state.reps > IntervalTimerHomeState.minReps) {
        state.decrementReps();
      }

      final minValue = state.reps;
      state.decrementReps();

      expect(state.reps, minValue);
      expect(state.reps, IntervalTimerHomeState.minReps);
    });

    test('Ne peut pas incrémenter au-dessus du maximum (reps)', () {
      final state = IntervalTimerHomeState();

      // Monter au maximum
      while (state.reps < IntervalTimerHomeState.maxReps) {
        state.incrementReps();
      }

      final maxValue = state.reps;
      state.incrementReps();

      expect(state.reps, maxValue);
      expect(state.reps, IntervalTimerHomeState.maxReps);
    });

    test('Incrémenter/décrémenter le temps de travail', () {
      final state = IntervalTimerHomeState();
      final initialWork = state.workSeconds;

      state.incrementWorkTime();
      expect(state.workSeconds, initialWork + 1);

      state.decrementWorkTime();
      expect(state.workSeconds, initialWork);
    });

    test('Incrémenter/décrémenter le temps de repos', () {
      final state = IntervalTimerHomeState();
      final initialRest = state.restSeconds;

      state.incrementRestTime();
      expect(state.restSeconds, initialRest + 1);

      state.decrementRestTime();
      expect(state.restSeconds, initialRest);
    });

    test('Changer le volume', () {
      final state = IntervalTimerHomeState();

      state.onVolumeChanged(0.75);
      expect(state.volume, 0.75);

      state.onVolumeChanged(0.0);
      expect(state.volume, 0.0);

      state.onVolumeChanged(1.0);
      expect(state.volume, 1.0);
    });

    test('Volume clamped entre 0 et 1', () {
      final state = IntervalTimerHomeState();

      state.onVolumeChanged(-0.5);
      expect(state.volume, 0.0);

      state.onVolumeChanged(1.5);
      expect(state.volume, 1.0);
    });

    test('Basculer l\'expansion de la section Démarrage rapide', () {
      final state = IntervalTimerHomeState();
      final initialExpanded = state.quickStartExpanded;

      state.toggleQuickStartSection();
      expect(state.quickStartExpanded, !initialExpanded);

      state.toggleQuickStartSection();
      expect(state.quickStartExpanded, initialExpanded);
    });

    test('Formater les secondes en MM:SS', () {
      final state = IntervalTimerHomeState();

      expect(state.formatSeconds(0), '00 : 00');
      expect(state.formatSeconds(15), '00 : 15');
      expect(state.formatSeconds(60), '01 : 00');
      expect(state.formatSeconds(125), '02 : 05');
      expect(state.formatSeconds(3599), '59 : 59');
    });

    test('Calculer la durée totale', () {
      final state = IntervalTimerHomeState();

      // reps=16, work=44, rest=15
      // total = 16 * (44 + 15) = 16 * 59 = 944 secondes
      expect(state.calculateTotalDuration(), 944);
    });

    test('Charger une configuration de préréglage', () {
      final state = IntervalTimerHomeState();

      state.loadPresetConfig(20, 40, 3);

      expect(state.reps, 20);
      expect(state.workSeconds, 40);
      expect(state.restSeconds, 3);
    });

    test('canStart retourne true si configuration valide', () {
      final state = IntervalTimerHomeState();

      expect(state.canStart, true);
    });

    test('canStart retourne false si reps < minimum', () {
      final state = IntervalTimerHomeState();

      while (state.reps > 1) {
        state.decrementReps();
      }
      state.decrementReps(); // Tente de descendre en dessous du minimum

      expect(state.canStart, true); // Reste à 1, donc valide
    });

    test('canStart retourne false si workSeconds < minimum', () {
      final state = IntervalTimerHomeState();

      while (state.workSeconds > 1) {
        state.decrementWorkTime();
      }

      expect(state.canStart, true); // workSeconds = 1, valide

      state.decrementWorkTime(); // Tente de descendre en dessous

      expect(state.canStart, true); // Reste à 1, donc valide
    });
  });
}

