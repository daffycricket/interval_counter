import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/models/timer_preset.dart';
import 'package:interval_counter/models/timer_configuration.dart';

void main() {
  group('TimerPreset', () {
    final testConfiguration = TimerConfiguration(
      repetitions: 10,
      workTime: Duration(seconds: 45),
      restTime: Duration(seconds: 15),
    );

    final testDate = DateTime(2025, 9, 23, 14, 30);

    test('should format created time correctly', () {
      final preset = TimerPreset(
        id: 'test-1',
        name: 'Test Preset',
        configuration: testConfiguration,
        createdAt: testDate,
      );

      expect(preset.formattedCreatedTime, equals('14:30'));
    });

    test('should format repetitions correctly', () {
      final preset = TimerPreset(
        id: 'test-1',
        name: 'Test Preset',
        configuration: testConfiguration,
        createdAt: testDate,
      );

      expect(preset.formattedRepetitions, equals('10x'));
    });

    test('should format work time correctly', () {
      final preset = TimerPreset(
        id: 'test-1',
        name: 'Test Preset',
        configuration: testConfiguration,
        createdAt: testDate,
      );

      expect(preset.formattedWorkTime, equals('00:45'));
    });

    test('should format rest time correctly', () {
      final preset = TimerPreset(
        id: 'test-1',
        name: 'Test Preset',
        configuration: testConfiguration,
        createdAt: testDate,
      );

      expect(preset.formattedRestTime, equals('00:15'));
    });

    test('should provide configuration accessors', () {
      final preset = TimerPreset(
        id: 'test-1',
        name: 'Test Preset',
        configuration: testConfiguration,
        createdAt: testDate,
      );

      expect(preset.repetitions, equals(10));
      expect(preset.workTime, equals(Duration(seconds: 45)));
      expect(preset.restTime, equals(Duration(seconds: 15)));
      expect(preset.totalDuration, equals(Duration(seconds: 600))); // (45+15) * 10
    });

    test('should serialize to JSON correctly', () {
      final preset = TimerPreset(
        id: 'test-1',
        name: 'Test Preset',
        configuration: testConfiguration,
        createdAt: testDate,
      );

      final json = preset.toJson();
      expect(json['id'], equals('test-1'));
      expect(json['name'], equals('Test Preset'));
      expect(json['configuration'], isA<Map<String, dynamic>>());
      expect(json['createdAt'], equals('2025-09-23T14:30:00.000'));
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'test-2',
        'name': 'JSON Preset',
        'configuration': {
          'repetitions': 8,
          'workTimeSeconds': 30,
          'restTimeSeconds': 10,
        },
        'createdAt': '2025-09-23T10:15:00.000',
      };

      final preset = TimerPreset.fromJson(json);
      expect(preset.id, equals('test-2'));
      expect(preset.name, equals('JSON Preset'));
      expect(preset.repetitions, equals(8));
      expect(preset.workTime, equals(Duration(seconds: 30)));
      expect(preset.restTime, equals(Duration(seconds: 10)));
      expect(preset.createdAt, equals(DateTime(2025, 9, 23, 10, 15)));
    });

    test('should support copyWith correctly', () {
      final original = TimerPreset(
        id: 'test-1',
        name: 'Original',
        configuration: testConfiguration,
        createdAt: testDate,
      );

      final modified = original.copyWith(name: 'Modified');
      expect(modified.name, equals('Modified'));
      expect(modified.id, equals(original.id));
      expect(modified.configuration, equals(original.configuration));
      expect(modified.createdAt, equals(original.createdAt));
    });

    test('should implement equality correctly', () {
      final preset1 = TimerPreset(
        id: 'test-1',
        name: 'Test',
        configuration: testConfiguration,
        createdAt: testDate,
      );

      final preset2 = TimerPreset(
        id: 'test-1',
        name: 'Test',
        configuration: testConfiguration,
        createdAt: testDate,
      );

      final preset3 = TimerPreset(
        id: 'test-2',
        name: 'Test',
        configuration: testConfiguration,
        createdAt: testDate,
      );

      expect(preset1, equals(preset2));
      expect(preset1, isNot(equals(preset3)));
    });

    test('should format duration with proper padding', () {
      final longWorkConfig = TimerConfiguration(
        repetitions: 5,
        workTime: Duration(minutes: 2, seconds: 5), // 2:05
        restTime: Duration(seconds: 30), // 0:30
      );

      final preset = TimerPreset(
        id: 'test-long',
        name: 'Long Preset',
        configuration: longWorkConfig,
        createdAt: testDate,
      );

      expect(preset.formattedWorkTime, equals('02:05'));
      expect(preset.formattedRestTime, equals('00:30'));
    });
  });
}
