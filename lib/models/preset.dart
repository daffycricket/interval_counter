/// Modèle de préréglage d'intervalle
class Preset {
  final String id;
  final String name;
  final int repetitions;
  final int workSeconds;
  final int restSeconds;
  final DateTime createdAt;

  Preset({
    required this.id,
    required this.name,
    required this.repetitions,
    required this.workSeconds,
    required this.restSeconds,
    required this.createdAt,
  });

  /// Durée totale en secondes
  int get totalDurationSeconds =>
      repetitions * (workSeconds + restSeconds);

  /// Durée totale formatée en MM:SS
  String get formattedDuration {
    final int totalSeconds = totalDurationSeconds;
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Crée un Preset à partir d'un JSON
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

  /// Convertit le Preset en JSON
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

  /// Copie avec modifications
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
}
