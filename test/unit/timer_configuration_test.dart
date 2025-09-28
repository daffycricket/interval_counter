import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/models/timer_configuration.dart';

void main() {
  group('TimerConfiguration', () {
    test('should create valid configuration', () {
      const config = TimerConfiguration(
        repetitions: 10,
        workDuration: Duration(seconds: 30),
        restDuration: Duration(seconds: 10),
      );

      expect(config.repetitions, 10);
      expect(config.workDuration, const Duration(seconds: 30));
      expect(config.restDuration, const Duration(seconds: 10));
      expect(config.isValid, true);
    });

    test('should calculate total duration correctly', () {
      const config = TimerConfiguration(
        repetitions: 3,
        workDuration: Duration(seconds: 20),
        restDuration: Duration(seconds: 10),
      );

      expect(config.totalDuration, const Duration(seconds: 90)); // (20+10) * 3
    });

    test('should validate minimum values', () {
      const validConfig = TimerConfiguration(
        repetitions: 1,
        workDuration: Duration(seconds: 1),
        restDuration: Duration(seconds: 1),
      );
      expect(validConfig.isValid, true);

      const invalidRepetitions = TimerConfiguration(
        repetitions: 0,
        workDuration: Duration(seconds: 30),
        restDuration: Duration(seconds: 10),
      );
      expect(invalidRepetitions.isValid, false);

      const invalidWork = TimerConfiguration(
        repetitions: 5,
        workDuration: Duration.zero,
        restDuration: Duration(seconds: 10),
      );
      expect(invalidWork.isValid, false);

      const invalidRest = TimerConfiguration(
        repetitions: 5,
        workDuration: Duration(seconds: 30),
        restDuration: Duration.zero,
      );
      expect(invalidRest.isValid, false);
    });

    test('should support copyWith', () {
      const original = TimerConfiguration(
        repetitions: 10,
        workDuration: Duration(seconds: 30),
        restDuration: Duration(seconds: 10),
      );

      final modified = original.copyWith(repetitions: 15);

      expect(modified.repetitions, 15);
      expect(modified.workDuration, const Duration(seconds: 30));
      expect(modified.restDuration, const Duration(seconds: 10));
    });

    test('should serialize to/from JSON', () {
      const config = TimerConfiguration(
        repetitions: 8,
        workDuration: Duration(seconds: 45),
        restDuration: Duration(seconds: 15),
      );

      final json = config.toJson();
      final restored = TimerConfiguration.fromJson(json);

      expect(restored, config);
    });

    test('should support equality comparison', () {
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

      expect(config1, config2);
      expect(config1, isNot(config3));
    });
  });
}
