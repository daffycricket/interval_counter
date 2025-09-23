/// Configuration d'un timer d'intervalles
class TimerConfiguration {
  final int repetitions;
  final Duration workTime;
  final Duration restTime;

  const TimerConfiguration({
    required this.repetitions,
    required this.workTime,
    required this.restTime,
  });

  /// Durée totale de l'entraînement
  Duration get totalDuration => (workTime + restTime) * repetitions;

  /// Durée de travail totale
  Duration get totalWorkTime => workTime * repetitions;

  /// Durée de repos totale
  Duration get totalRestTime => restTime * repetitions;

  /// Validation de la configuration
  bool get isValid {
    return repetitions >= 1 &&
           workTime.inSeconds >= 1 &&
           restTime.inSeconds >= 1;
  }

  /// Copie avec modifications
  TimerConfiguration copyWith({
    int? repetitions,
    Duration? workTime,
    Duration? restTime,
  }) {
    return TimerConfiguration(
      repetitions: repetitions ?? this.repetitions,
      workTime: workTime ?? this.workTime,
      restTime: restTime ?? this.restTime,
    );
  }

  /// Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'repetitions': repetitions,
      'workTimeSeconds': workTime.inSeconds,
      'restTimeSeconds': restTime.inSeconds,
    };
  }

  /// Création depuis JSON
  factory TimerConfiguration.fromJson(Map<String, dynamic> json) {
    return TimerConfiguration(
      repetitions: json['repetitions'] as int,
      workTime: Duration(seconds: json['workTimeSeconds'] as int),
      restTime: Duration(seconds: json['restTimeSeconds'] as int),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimerConfiguration &&
           other.repetitions == repetitions &&
           other.workTime == workTime &&
           other.restTime == restTime;
  }

  @override
  int get hashCode {
    return repetitions.hashCode ^
           workTime.hashCode ^
           restTime.hashCode;
  }

  @override
  String toString() {
    return 'TimerConfiguration(repetitions: $repetitions, workTime: $workTime, restTime: $restTime)';
  }
}
