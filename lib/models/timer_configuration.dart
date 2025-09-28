/// Configuration d'un timer d'intervalles
class TimerConfiguration {
  final int repetitions;
  final Duration workDuration;
  final Duration restDuration;

  const TimerConfiguration({
    required this.repetitions,
    required this.workDuration,
    required this.restDuration,
  });

  /// Durée totale de la séance
  Duration get totalDuration {
    return Duration(
      seconds: (workDuration.inSeconds + restDuration.inSeconds) * repetitions,
    );
  }

  /// Validation de la configuration
  bool get isValid {
    return repetitions >= 1 &&
        workDuration.inSeconds >= 1 &&
        restDuration.inSeconds >= 1;
  }

  /// Copie avec modifications
  TimerConfiguration copyWith({
    int? repetitions,
    Duration? workDuration,
    Duration? restDuration,
  }) {
    return TimerConfiguration(
      repetitions: repetitions ?? this.repetitions,
      workDuration: workDuration ?? this.workDuration,
      restDuration: restDuration ?? this.restDuration,
    );
  }

  /// Sérialisation JSON
  Map<String, dynamic> toJson() {
    return {
      'repetitions': repetitions,
      'workDurationSeconds': workDuration.inSeconds,
      'restDurationSeconds': restDuration.inSeconds,
    };
  }

  /// Désérialisation JSON
  factory TimerConfiguration.fromJson(Map<String, dynamic> json) {
    return TimerConfiguration(
      repetitions: json['repetitions'] as int,
      workDuration: Duration(seconds: json['workDurationSeconds'] as int),
      restDuration: Duration(seconds: json['restDurationSeconds'] as int),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimerConfiguration &&
        other.repetitions == repetitions &&
        other.workDuration == workDuration &&
        other.restDuration == restDuration;
  }

  @override
  int get hashCode {
    return Object.hash(repetitions, workDuration, restDuration);
  }

  @override
  String toString() {
    return 'TimerConfiguration(repetitions: $repetitions, work: $workDuration, rest: $restDuration)';
  }
}
