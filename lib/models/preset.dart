import 'package:uuid/uuid.dart';

/// Modèle immutable représentant un préréglage d'intervalle
class Preset {
  final String id;
  final String name;
  final int prepareSeconds;
  final int repetitions;
  final int workSeconds;
  final int restSeconds;
  final int cooldownSeconds;

  const Preset({
    required this.id,
    required this.name,
    this.prepareSeconds = 0,
    required this.repetitions,
    required this.workSeconds,
    required this.restSeconds,
    this.cooldownSeconds = 0,
  });

  /// Calcule la durée totale en secondes
  int get totalDurationSeconds =>
      prepareSeconds + (repetitions * (workSeconds + restSeconds)) + cooldownSeconds;

  /// Formate la durée totale au format mm:ss
  String get formattedDuration {
    final minutes = totalDurationSeconds ~/ 60;
    final seconds = totalDurationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Crée un nouveau préréglage avec un ID auto-généré
  factory Preset.create({
    required String name,
    int prepareSeconds = 0,
    required int repetitions,
    required int workSeconds,
    required int restSeconds,
    int cooldownSeconds = 0,
  }) {
    return Preset(
      id: const Uuid().v4(),
      name: name,
      prepareSeconds: prepareSeconds,
      repetitions: repetitions,
      workSeconds: workSeconds,
      restSeconds: restSeconds,
      cooldownSeconds: cooldownSeconds,
    );
  }

  /// Crée une instance depuis JSON
  factory Preset.fromJson(Map<String, dynamic> json) {
    return Preset(
      id: json['id'] as String,
      name: json['name'] as String,
      prepareSeconds: json['prepareSeconds'] as int? ?? 0,
      repetitions: json['repetitions'] as int,
      workSeconds: json['workSeconds'] as int,
      restSeconds: json['restSeconds'] as int,
      cooldownSeconds: json['cooldownSeconds'] as int? ?? 0,
    );
  }

  /// Convertit en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'prepareSeconds': prepareSeconds,
      'repetitions': repetitions,
      'workSeconds': workSeconds,
      'restSeconds': restSeconds,
      'cooldownSeconds': cooldownSeconds,
    };
  }

  /// Crée une copie avec modifications
  Preset copyWith({
    String? id,
    String? name,
    int? prepareSeconds,
    int? repetitions,
    int? workSeconds,
    int? restSeconds,
    int? cooldownSeconds,
  }) {
    return Preset(
      id: id ?? this.id,
      name: name ?? this.name,
      prepareSeconds: prepareSeconds ?? this.prepareSeconds,
      repetitions: repetitions ?? this.repetitions,
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Preset &&
        other.id == id &&
        other.name == name &&
        other.prepareSeconds == prepareSeconds &&
        other.repetitions == repetitions &&
        other.workSeconds == workSeconds &&
        other.restSeconds == restSeconds &&
        other.cooldownSeconds == cooldownSeconds;
  }

  @override
  int get hashCode => Object.hash(id, name, prepareSeconds, repetitions, workSeconds, restSeconds, cooldownSeconds);

  @override
  String toString() {
    return 'Preset(id: $id, name: $name, prepareSeconds: $prepareSeconds, repetitions: $repetitions, '
        'workSeconds: $workSeconds, restSeconds: $restSeconds, cooldownSeconds: $cooldownSeconds)';
  }
}

