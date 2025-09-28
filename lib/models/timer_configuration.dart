class TimerConfiguration {
  final int repetitions;
  final Duration workDuration;
  final Duration restDuration;

  const TimerConfiguration({
    required this.repetitions,
    required this.workDuration,
    required this.restDuration,
  });

  Duration get totalDuration => (workDuration + restDuration) * repetitions;

  bool get isValid =>
      repetitions >= 1 &&
      workDuration >= const Duration(seconds: 1) &&
      restDuration >= const Duration(seconds: 1);

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

  Map<String, dynamic> toJson() {
    return {
      'repetitions': repetitions,
      'workDurationSeconds': workDuration.inSeconds,
      'restDurationSeconds': restDuration.inSeconds,
    };
  }

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
    return repetitions.hashCode ^
        workDuration.hashCode ^
        restDuration.hashCode;
  }

  @override
  String toString() {
    return 'TimerConfiguration(repetitions: $repetitions, workDuration: $workDuration, restDuration: $restDuration)';
  }

  static const TimerConfiguration defaultConfig = TimerConfiguration(
    repetitions: 16,
    workDuration: Duration(seconds: 44),
    restDuration: Duration(seconds: 15),
  );
}
