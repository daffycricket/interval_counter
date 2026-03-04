import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../domain/step_mode.dart';

/// Modèle immutable représentant une étape dans un entraînement avancé.
class AdvancedStep {
  final String id;
  final String name;
  final int durationSeconds;
  final Color color;
  final int order;
  final StepMode mode;
  final int repeatCount;

  const AdvancedStep({
    required this.id,
    required this.name,
    this.durationSeconds = 5,
    this.color = const Color(0xFFCC1177),
    this.order = 0,
    this.mode = StepMode.time,
    this.repeatCount = 1,
  });

  factory AdvancedStep.create({
    required String name,
    int durationSeconds = 5,
    Color color = const Color(0xFFCC1177),
    int order = 0,
    StepMode mode = StepMode.time,
    int repeatCount = 1,
  }) {
    return AdvancedStep(
      id: const Uuid().v4(),
      name: name,
      durationSeconds: durationSeconds,
      color: color,
      order: order,
      mode: mode,
      repeatCount: repeatCount,
    );
  }

  /// Durée effective en secondes, tenant compte du mode.
  int get effectiveDurationSeconds {
    if (mode == StepMode.reps) {
      return repeatCount * durationSeconds;
    }
    return durationSeconds;
  }

  factory AdvancedStep.fromJson(Map<String, dynamic> json) {
    return AdvancedStep(
      id: json['id'] as String,
      name: json['name'] as String,
      durationSeconds: json['durationSeconds'] as int? ?? 5,
      color: Color(json['color'] as int? ?? 0xFFCC1177),
      order: json['order'] as int? ?? 0,
      mode: json['mode'] == 'reps' ? StepMode.reps : StepMode.time,
      repeatCount: json['repeatCount'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'durationSeconds': durationSeconds,
      'color': color.toARGB32(),
      'order': order,
      'mode': mode == StepMode.reps ? 'reps' : 'time',
      'repeatCount': repeatCount,
    };
  }

  AdvancedStep copyWith({
    String? id,
    String? name,
    int? durationSeconds,
    Color? color,
    int? order,
    StepMode? mode,
    int? repeatCount,
  }) {
    return AdvancedStep(
      id: id ?? this.id,
      name: name ?? this.name,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      color: color ?? this.color,
      order: order ?? this.order,
      mode: mode ?? this.mode,
      repeatCount: repeatCount ?? this.repeatCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdvancedStep &&
        other.id == id &&
        other.name == name &&
        other.durationSeconds == durationSeconds &&
        other.color == color &&
        other.order == order &&
        other.mode == mode &&
        other.repeatCount == repeatCount;
  }

  @override
  int get hashCode =>
      Object.hash(id, name, durationSeconds, color, order, mode, repeatCount);

  @override
  String toString() {
    return 'AdvancedStep(id: $id, name: $name, durationSeconds: $durationSeconds, '
        'color: $color, order: $order, mode: $mode, repeatCount: $repeatCount)';
  }
}
