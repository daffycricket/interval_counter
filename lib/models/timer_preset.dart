import 'timer_configuration.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'configuration': configuration.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

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
