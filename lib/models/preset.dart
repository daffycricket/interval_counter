/// Modèle de préréglage d'intervalle
class Preset {
  final String id;
  final String name;
  final int reps;
  final int workSeconds;
  final int restSeconds;

  const Preset({
    required this.id,
    required this.name,
    required this.reps,
    required this.workSeconds,
    required this.restSeconds,
  });

  /// Durée totale en secondes
  int get totalDuration => reps * (workSeconds + restSeconds);

  /// Durée formatée en MM:SS
  String get formattedTotalDuration {
    final minutes = totalDuration ~/ 60;
    final seconds = totalDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Crée un Preset depuis JSON
  factory Preset.fromJson(Map<String, dynamic> json) {
    return Preset(
      id: json['id'] as String,
      name: json['name'] as String,
      reps: json['reps'] as int,
      workSeconds: json['workSeconds'] as int,
      restSeconds: json['restSeconds'] as int,
    );
  }

  /// Convertit le Preset en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'reps': reps,
      'workSeconds': workSeconds,
      'restSeconds': restSeconds,
    };
  }

  /// Crée une copie avec des champs modifiés
  Preset copyWith({
    String? id,
    String? name,
    int? reps,
    int? workSeconds,
    int? restSeconds,
  }) {
    return Preset(
      id: id ?? this.id,
      name: name ?? this.name,
      reps: reps ?? this.reps,
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Preset &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          reps == other.reps &&
          workSeconds == other.workSeconds &&
          restSeconds == other.restSeconds;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      reps.hashCode ^
      workSeconds.hashCode ^
      restSeconds.hashCode;

  @override
  String toString() {
    return 'Preset(id: $id, name: $name, reps: $reps, workSeconds: $workSeconds, restSeconds: $restSeconds)';
  }
}

