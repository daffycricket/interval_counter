import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/state/interval_timer_home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// T10: Tester le calcul de la durée totale
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  test('T10 - Calculate total duration correctly', () async {
    final state = IntervalTimerHomeState();
    
    // Attendre que l'état initial soit chargé
    await Future.delayed(const Duration(milliseconds: 100));

    // Configuration par défaut: 16 reps, 44s work, 15s rest
    // Total = 16 * (44 + 15) = 16 * 59 = 944 secondes (15:44)
    expect(state.calculateTotalDuration(), 944);

    // Modifier les valeurs
    state.incrementReps(); // 17 reps
    expect(state.calculateTotalDuration(), 17 * 59);

    state.incrementWork(); // 45s work
    expect(state.calculateTotalDuration(), 17 * 60); // 17 * (45 + 15)

    state.decrementRest(); // 14s rest
    expect(state.calculateTotalDuration(), 17 * 59); // 17 * (45 + 14)
  });

  test('T10 - Calculate duration with minimum values', () async {
    final state = IntervalTimerHomeState();
    
    // Attendre que l'état initial soit chargé
    await Future.delayed(const Duration(milliseconds: 100));

    // Charger directement les valeurs minimales
    state.loadPresetValues(
      repetitions: IntervalTimerHomeState.minReps,
      workSeconds: IntervalTimerHomeState.minWork,
      restSeconds: IntervalTimerHomeState.minRest,
    );

    // Min: 1 rep, 1s work, 0s rest = 1 seconde
    expect(state.repetitions, 1);
    expect(state.workSeconds, 1);
    expect(state.restSeconds, 0);
    expect(state.calculateTotalDuration(), 1);
  });

  test('T10 - Calculate duration with maximum values', () async {
    final state = IntervalTimerHomeState();
    
    // Attendre que l'état initial soit chargé
    await Future.delayed(const Duration(milliseconds: 100));

    // Charger directement les valeurs maximales pour éviter des milliers d'incrémentations
    state.loadPresetValues(
      repetitions: IntervalTimerHomeState.maxReps,
      workSeconds: IntervalTimerHomeState.maxWork,
      restSeconds: IntervalTimerHomeState.maxRest,
    );

    // Attendre que la sauvegarde soit terminée
    await Future.delayed(const Duration(milliseconds: 100));

    // Max: 999 reps, 3599s work (59:59), 3599s rest (59:59)
    // Total = 999 * (3599 + 3599) = 999 * 7198 = 7190802 secondes
    expect(state.repetitions, 999);
    expect(state.workSeconds, 3599);
    expect(state.restSeconds, 3599);
    expect(state.calculateTotalDuration(), 7190802);
  });
}
