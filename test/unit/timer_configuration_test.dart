import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/models/timer_configuration.dart';

void main() {
  group('TimerConfiguration', () {
    test('should create a valid configuration', () {
      const config = TimerConfiguration(
        repetitions: 10,
        workDuration: Duration(seconds: 30),
        restDuration: Duration(seconds: 10),
      );

      expect(config.repetitions, equals(10));
      expect(config.workDuration, equals(const Duration(seconds: 30)));
      expect(config.restDuration, equals(const Duration(seconds: 10)));
    });

    test('should calculate total duration correctly', () {
      const config = TimerConfiguration(
        repetitions: 3,
        workDuration: Duration(seconds: 20),
        restDuration: Duration(seconds: 10),
      );

      expect(config.totalDuration, equals(const Duration(seconds: 90))); // (20+10) * 3
    });

    test('should validate configuration correctly', () {
      const validConfig = TimerConfiguration(
        repetitions: 1,
        workDuration: Duration(seconds: 1),
        restDuration: Duration(seconds: 1),
      );
      expect(validConfig.isValid, isTrue);

      const invalidRepetitions = TimerConfiguration(
        repetitions: 0,
        workDuration: Duration(seconds: 30),
        restDuration: Duration(seconds: 10),
      );
      expect(invalidRepetitions.isValid, isFalse);

      const invalidWorkDuration = TimerConfiguration(
        repetitions: 5,
        workDuration: Duration.zero,
        restDuration: Duration(seconds: 10),
      );
      expect(invalidWorkDuration.isValid, isFalse);

      const invalidRestDuration = TimerConfiguration(
        repetitions: 5,
        workDuration: Duration(seconds: 30),
        restDuration: Duration.zero,
      );
      expect(invalidRestDuration.isValid, isFalse);
    });

    test('should create copy with updated values', () {
      const original = TimerConfiguration(
        repetitions: 10,
        workDuration: Duration(seconds: 30),
        restDuration: Duration(seconds: 10),
      );

      final updated = original.copyWith(repetitions: 15);

      expect(updated.repetitions, equals(15));
      expect(updated.workDuration, equals(original.workDuration));
      expect(updated.restDuration, equals(original.restDuration));
    });

    test('should serialize to and from JSON', () {
      const config = TimerConfiguration(
        repetitions: 8,
        workDuration: Duration(seconds: 45),
        restDuration: Duration(seconds: 15),
      );

      final json = config.toJson();
      final restored = TimerConfiguration.fromJson(json);

      expect(restored, equals(config));
    });

    test('should have correct default configuration', () {
      expect(TimerConfiguration.defaultConfig.repetitions, equals(16));
      expect(TimerConfiguration.defaultConfig.workDuration, equals(const Duration(seconds: 44)));
      expect(TimerConfiguration.defaultConfig.restDuration, equals(const Duration(seconds: 15)));
      expect(TimerConfiguration.defaultConfig.isValid, isTrue);
    });

    test('should implement equality correctly', () {
      const config1 = TimerConfiguration(
        repetitions: 10,
        workDuration: Duration(seconds: 30),
        restDuration: Duration(seconds: 10),
      );

      const config2 = TimerConfiguration(
        repetitions: 10,
        workDuration: Duration(seconds: 30),
        restDuration: Duration(seconds: 10),
      );

      const config3 = TimerConfiguration(
        repetitions: 5,
        workDuration: Duration(seconds: 30),
        restDuration: Duration(seconds: 10),
      );

      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
      expect(config1.hashCode, equals(config2.hashCode));
    });
  });
}
