import 'package:uuid/uuid.dart';
import 'advanced_step.dart';

/// Modèle immutable représentant un groupe d'étapes dans un entraînement avancé.
/// Un groupe contient une liste ordonnée d'étapes et un nombre de répétitions.
class WorkoutGroup {
  final String id;
  final int repeatCount;
  final List<AdvancedStep> steps;
  final int order;

  const WorkoutGroup({
    required this.id,
    this.repeatCount = 1,
    this.steps = const [],
    this.order = 0,
  });

  factory WorkoutGroup.create({
    int repeatCount = 1,
    List<AdvancedStep> steps = const [],
    int order = 0,
  }) {
    return WorkoutGroup(
      id: const Uuid().v4(),
      repeatCount: repeatCount,
      steps: steps,
      order: order,
    );
  }

  /// Durée totale du groupe en secondes (reps × somme des durées effectives des étapes).
  int get totalDurationSeconds {
    final stepsDuration =
        steps.fold<int>(0, (sum, step) => sum + step.effectiveDurationSeconds);
    return repeatCount * stepsDuration;
  }

  factory WorkoutGroup.fromJson(Map<String, dynamic> json) {
    return WorkoutGroup(
      id: json['id'] as String,
      repeatCount: json['repeatCount'] as int? ?? 1,
      steps: (json['steps'] as List<dynamic>?)
              ?.map((s) => AdvancedStep.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'repeatCount': repeatCount,
      'steps': steps.map((s) => s.toJson()).toList(),
      'order': order,
    };
  }

  WorkoutGroup copyWith({
    String? id,
    int? repeatCount,
    List<AdvancedStep>? steps,
    int? order,
  }) {
    return WorkoutGroup(
      id: id ?? this.id,
      repeatCount: repeatCount ?? this.repeatCount,
      steps: steps ?? this.steps,
      order: order ?? this.order,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WorkoutGroup) return false;
    if (other.id != id ||
        other.repeatCount != repeatCount ||
        other.order != order) {
      return false;
    }
    if (other.steps.length != steps.length) {
      return false;
    }
    for (var i = 0; i < steps.length; i++) {
      if (other.steps[i] != steps[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(id, repeatCount, order, Object.hashAll(steps));

  @override
  String toString() {
    return 'WorkoutGroup(id: $id, repeatCount: $repeatCount, '
        'steps: ${steps.length}, order: $order)';
  }
}
