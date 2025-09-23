import 'timer_configuration.dart';

/// Préréglage sauvegardé d'un timer d'intervalles
class TimerPreset {
  final String id;
  final String name;
  final TimerConfiguration configuration;
  final DateTime createdAt;

  const TimerPreset({
    required this.id,
    required this.name,
    required this.configuration,
    required this.createdAt,
  });

  /// Accesseurs pour faciliter l'utilisation
  int get repetitions => configuration.repetitions;
  Duration get workTime => configuration.workTime;
  Duration get restTime => configuration.restTime;
  Duration get totalDuration => configuration.totalDuration;

  /// Heure de création formatée (HH:mm)
  String get formattedCreatedTime {
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Texte de répétitions formaté (ex: "20x")
  String get formattedRepetitions => '${repetitions}x';

  /// Temps de travail formaté (mm:ss)
  String get formattedWorkTime => _formatDuration(workTime);

  /// Temps de repos formaté (mm:ss)
  String get formattedRestTime => _formatDuration(restTime);

  /// Utilitaire de formatage de durée
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Copie avec modifications
  TimerPreset copyWith({
    String? id,
    String? name,
    TimerConfiguration? configuration,
    DateTime? createdAt,
  }) {
    return TimerPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      configuration: configuration ?? this.configuration,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'configuration': configuration.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Création depuis JSON
  factory TimerPreset.fromJson(Map<String, dynamic> json) {
    return TimerPreset(
      id: json['id'] as String,
      name: json['name'] as String,
      configuration: TimerConfiguration.fromJson(
        json['configuration'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimerPreset &&
           other.id == id &&
           other.name == name &&
           other.configuration == configuration &&
           other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
           name.hashCode ^
           configuration.hashCode ^
           createdAt.hashCode;
  }

  @override
  String toString() {
    return 'TimerPreset(id: $id, name: $name, configuration: $configuration, createdAt: $createdAt)';
  }
}
