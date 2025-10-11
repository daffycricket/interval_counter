import 'package:flutter/foundation.dart';

/// Modèle représentant un préréglage d'intervalle sauvegardé
@immutable
class Preset {
  final String id;
  final String name;
  final int repetitions;
  final int workSeconds;
  final int restSeconds;
  final DateTime createdAt;

  const Preset({
    required this.id,
    required this.name,
    required this.repetitions,
    required this.workSeconds,
    required this.restSeconds,
    required this.createdAt,
  });

  /// Calcule la durée totale de la session en secondes
  int get totalDuration => repetitions * (workSeconds + restSeconds);

  /// Formatte la durée totale en MM:SS ou HH:MM:SS
  String get formattedDuration {
    final int totalSeconds = totalDuration;
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Crée une instance depuis un JSON
  factory Preset.fromJson(Map<String, dynamic> json) {
    return Preset(
      id: json['id'] as String,
      name: json['name'] as String,
      repetitions: json['repetitions'] as int,
      workSeconds: json['workSeconds'] as int,
      restSeconds: json['restSeconds'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convertit l'instance en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'repetitions': repetitions,
      'workSeconds': workSeconds,
      'restSeconds': restSeconds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Crée une copie avec des champs modifiés
  Preset copyWith({
    String? id,
    String? name,
    int? repetitions,
    int? workSeconds,
    int? restSeconds,
    DateTime? createdAt,
  }) {
    return Preset(
      id: id ?? this.id,
      name: name ?? this.name,
      repetitions: repetitions ?? this.repetitions,
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Preset &&
        other.id == id &&
        other.name == name &&
        other.repetitions == repetitions &&
        other.workSeconds == workSeconds &&
        other.restSeconds == restSeconds &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      repetitions,
      workSeconds,
      restSeconds,
      createdAt,
    );
  }

  @override
  String toString() {
    return 'Preset(id: $id, name: $name, reps: $repetitions, '
        'work: $workSeconds, rest: $restSeconds, created: $createdAt)';
  }
}

