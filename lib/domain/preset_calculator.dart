/// Pure business logic for preset time calculations.
/// Spec §4.2: Total = prepare + (reps × (work + rest)) + cooldown.
abstract class PresetCalculator {

  /// Returns total duration in seconds.
  static int calculateTotal({
    required int prepareSeconds,
    required int repetitions,
    required int workSeconds,
    required int restSeconds,
    required int cooldownSeconds,
  }) {
    return prepareSeconds +
        (repetitions * (workSeconds + restSeconds)) +
        cooldownSeconds;
  }

  /// Returns total formatted as "TOTAL mm:ss".
  static String formatTotal({
    required int prepareSeconds,
    required int repetitions,
    required int workSeconds,
    required int restSeconds,
    required int cooldownSeconds,
  }) {
    final total = calculateTotal(
      prepareSeconds: prepareSeconds,
      repetitions: repetitions,
      workSeconds: workSeconds,
      restSeconds: restSeconds,
      cooldownSeconds: cooldownSeconds,
    );
    final mins = total ~/ 60;
    final secs = total % 60;
    return 'TOTAL ${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
