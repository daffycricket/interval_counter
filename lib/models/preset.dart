/// Modèle de préréglage d'intervalle
class Preset {
  final String id;
  final String name;
  final int repetitions;
  final int workSeconds;
  final int restSeconds;
  final DateTime createdAt;
  final DateTime modifiedAt;

  const Preset({
    required this.id,
    required this.name,
    required this.repetitions,
    required this.workSeconds,
    required this.restSeconds,
    required this.createdAt,
    required this.modifiedAt,
  });

  /// Calcule la durée totale de l'intervalle en secondes
  int get totalDurationSeconds => repetitions * (workSeconds + restSeconds);

  /// Formate la durée totale en MM:SS
  String get formattedDuration {
    final minutes = totalDurationSeconds ~/ 60;
    final seconds = totalDurationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Crée un Preset à partir d'un Map JSON
  factory Preset.fromJson(Map<String, dynamic> json) {
    return Preset(
      id: json['id'] as String,
      name: json['name'] as String,
      repetitions: json['repetitions'] as int,
      workSeconds: json['workSeconds'] as int,
      restSeconds: json['restSeconds'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
    );
  }

  /// Convertit le Preset en Map JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'repetitions': repetitions,
      'workSeconds': workSeconds,
      'restSeconds': restSeconds,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }

  /// Crée une copie du Preset avec des valeurs modifiées
  Preset copyWith({
    String? id,
    String? name,
    int? repetitions,
    int? workSeconds,
    int? restSeconds,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return Preset(
      id: id ?? this.id,
      name: name ?? this.name,
      repetitions: repetitions ?? this.repetitions,
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Preset && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Preset(id: $id, name: $name, reps: $repetitions, work: $workSeconds, rest: $restSeconds)';
}
