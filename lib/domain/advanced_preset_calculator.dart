import '../models/workout_group.dart';
import 'time_formatter.dart';

/// Calculateur de durée totale pour les presets en mode ADVANCED.
/// Pure Dart — pas de dépendance Flutter.
class AdvancedPresetCalculator {
  AdvancedPresetCalculator._();

  /// Calcule la durée totale en secondes pour une liste de groupes.
  static int calculateTotal(List<WorkoutGroup> groups) {
    return groups.fold<int>(0, (sum, group) => sum + group.totalDurationSeconds);
  }

  /// Calcule le sous-total d'un seul groupe en secondes.
  static int calculateGroupSubtotal(WorkoutGroup group) {
    return group.totalDurationSeconds;
  }

  /// Formate la durée totale pour affichage (ex: "TOTAL 03:35").
  static String formatTotal(List<WorkoutGroup> groups) {
    final total = calculateTotal(groups);
    return 'TOTAL ${TimeFormatter.format(total)}';
  }

  /// Formate le sous-total d'un groupe (ex: "00:35").
  static String formatGroupSubtotal(WorkoutGroup group) {
    return TimeFormatter.format(group.totalDurationSeconds);
  }
}
