import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/models/timer_configuration.dart';

void main() {
  group('TimerConfiguration', () {
    test('should calculate total duration correctly', () {
      const config = TimerConfiguration(
        repetitions: 5,
        workTime: Duration(seconds: 30),
        restTime: Duration(seconds: 10),
      );

      expect(config.totalDuration, equals(const Duration(seconds: 200))); // (30+10) * 5
    });

    test('should calculate total work time correctly', () {
      const config = TimerConfiguration(
        repetitions: 3,
        workTime: Duration(seconds: 45),
        restTime: Duration(seconds: 15),
      );

      expect(config.totalWorkTime, equals(const Duration(seconds: 135))); // 45 * 3
    });

    test('should calculate total rest time correctly', () {
      const config = TimerConfiguration(
        repetitions: 4,
        workTime: Duration(seconds: 20),
        restTime: Duration(seconds: 10),
      );

      expect(config.totalRestTime, equals(const Duration(seconds: 40))); // 10 * 4
    });

    test('should validate configuration correctly', () {
      const validConfig = TimerConfiguration(
        repetitions: 1,
        workTime: Duration(seconds: 1),
        restTime: Duration(seconds: 1),
      );
      expect(validConfig.isValid, isTrue);

      const invalidRepetitions = TimerConfiguration(
        repetitions: 0,
        workTime: Duration(seconds: 30),
        restTime: Duration(seconds: 10),
      );
      expect(invalidRepetitions.isValid, isFalse);

      const invalidWorkTime = TimerConfiguration(
        repetitions: 5,
        workTime: Duration.zero,
        restTime: Duration(seconds: 10),
      );
      expect(invalidWorkTime.isValid, isFalse);

      const invalidRestTime = TimerConfiguration(
        repetitions: 5,
        workTime: Duration(seconds: 30),
        restTime: Duration.zero,
      );
      expect(invalidRestTime.isValid, isFalse);
    });

    test('should serialize to JSON correctly', () {
      const config = TimerConfiguration(
        repetitions: 10,
        workTime: Duration(seconds: 45),
        restTime: Duration(seconds: 15),
      );

      final json = config.toJson();
      expect(json['repetitions'], equals(10));
      expect(json['workTimeSeconds'], equals(45));
      expect(json['restTimeSeconds'], equals(15));
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'repetitions': 8,
        'workTimeSeconds': 60,
        'restTimeSeconds': 20,
      };

      final config = TimerConfiguration.fromJson(json);
      expect(config.repetitions, equals(8));
      expect(config.workTime, equals(const Duration(seconds: 60)));
      expect(config.restTime, equals(const Duration(seconds: 20)));
    });

    test('should support copyWith correctly', () {
      const original = TimerConfiguration(
        repetitions: 5,
        workTime: Duration(seconds: 30),
        restTime: Duration(seconds: 10),
      );

      final modified = original.copyWith(repetitions: 8);
      expect(modified.repetitions, equals(8));
      expect(modified.workTime, equals(original.workTime));
      expect(modified.restTime, equals(original.restTime));
    });

    test('should implement equality correctly', () {
      const config1 = TimerConfiguration(
        repetitions: 5,
        workTime: Duration(seconds: 30),
        restTime: Duration(seconds: 10),
      );

      const config2 = TimerConfiguration(
        repetitions: 5,
        workTime: Duration(seconds: 30),
        restTime: Duration(seconds: 10),
      );

      const config3 = TimerConfiguration(
        repetitions: 6,
        workTime: Duration(seconds: 30),
        restTime: Duration(seconds: 10),
      );

      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
    });
  });
}
