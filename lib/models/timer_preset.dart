import 'timer_configuration.dart';

/// Préréglage sauvegardé d'un timer d'intervalles
class TimerPreset {
  final String id;
  final String name;
  final TimerConfiguration configuration;
  final DateTime createdAt;
  final DateTime? lastUsedAt;

  const TimerPreset({
    required this.id,
    required this.name,
    required this.configuration,
    required this.createdAt,
    this.lastUsedAt,
  });

  /// Formatage de l'heure de création (HH:MM)
  String get createdTimeFormatted {
    return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  /// Copie avec modifications
  TimerPreset copyWith({
    String? id,
    String? name,
    TimerConfiguration? configuration,
    DateTime? createdAt,
    DateTime? lastUsedAt,
  }) {
    return TimerPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      configuration: configuration ?? this.configuration,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  /// Marquer comme utilisé
  TimerPreset markAsUsed() {
    return copyWith(lastUsedAt: DateTime.now());
  }

  /// Sérialisation JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'configuration': configuration.toJson(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastUsedAt': lastUsedAt?.millisecondsSinceEpoch,
    };
  }

  /// Désérialisation JSON
  factory TimerPreset.fromJson(Map<String, dynamic> json) {
    return TimerPreset(
      id: json['id'] as String,
      name: json['name'] as String,
      configuration: TimerConfiguration.fromJson(
        json['configuration'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      lastUsedAt: json['lastUsedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastUsedAt'] as int)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimerPreset &&
        other.id == id &&
        other.name == name &&
        other.configuration == configuration &&
        other.createdAt == createdAt &&
        other.lastUsedAt == lastUsedAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, configuration, createdAt, lastUsedAt);
  }

  @override
  String toString() {
    return 'TimerPreset(id: $id, name: $name, configuration: $configuration)';
  }
}
