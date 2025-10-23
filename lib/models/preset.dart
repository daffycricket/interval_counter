import 'package:uuid/uuid.dart';

/// Modèle immutable représentant un préréglage d'intervalle
class Preset {
  final String id;
  final String name;
  final int repetitions;
  final int workSeconds;
  final int restSeconds;

  const Preset({
    required this.id,
    required this.name,
    required this.repetitions,
    required this.workSeconds,
    required this.restSeconds,
  });

  /// Calcule la durée totale en secondes
  int get totalDurationSeconds =>
      repetitions * (workSeconds + restSeconds);

  /// Formate la durée totale au format mm:ss
  String get formattedDuration {
    final minutes = totalDurationSeconds ~/ 60;
    final seconds = totalDurationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Crée un nouveau préréglage avec un ID auto-généré
  factory Preset.create({
    required String name,
    required int repetitions,
    required int workSeconds,
    required int restSeconds,
  }) {
    return Preset(
      id: const Uuid().v4(),
      name: name,
      repetitions: repetitions,
      workSeconds: workSeconds,
      restSeconds: restSeconds,
    );
  }

  /// Crée une instance depuis JSON
  factory Preset.fromJson(Map<String, dynamic> json) {
    return Preset(
      id: json['id'] as String,
      name: json['name'] as String,
      repetitions: json['repetitions'] as int,
      workSeconds: json['workSeconds'] as int,
      restSeconds: json['restSeconds'] as int,
    );
  }

  /// Convertit en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'repetitions': repetitions,
      'workSeconds': workSeconds,
      'restSeconds': restSeconds,
    };
  }

  /// Crée une copie avec modifications
  Preset copyWith({
    String? id,
    String? name,
    int? repetitions,
    int? workSeconds,
    int? restSeconds,
  }) {
    return Preset(
      id: id ?? this.id,
      name: name ?? this.name,
      repetitions: repetitions ?? this.repetitions,
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
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
        other.restSeconds == restSeconds;
  }

  @override
  int get hashCode => Object.hash(id, name, repetitions, workSeconds, restSeconds);

  @override
  String toString() {
    return 'Preset(id: $id, name: $name, repetitions: $repetitions, '
        'workSeconds: $workSeconds, restSeconds: $restSeconds)';
  }
}

