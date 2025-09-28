import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/models/timer_configuration.dart';
import 'package:interval_counter/models/timer_preset.dart';

void main() {
  group('TimerPreset', () {
    late TimerConfiguration testConfig;
    late DateTime testDate;

    setUp(() {
      testConfig = const TimerConfiguration(
        repetitions: 10,
        workDuration: Duration(seconds: 30),
        restDuration: Duration(seconds: 10),
      );
      testDate = DateTime(2024, 1, 1, 12, 0, 0);
    });

    test('should create a valid preset', () {
      final preset = TimerPreset(
        id: 'test-id',
        name: 'Test Preset',
        configuration: testConfig,
        createdAt: testDate,
      );

      expect(preset.id, equals('test-id'));
      expect(preset.name, equals('Test Preset'));
      expect(preset.configuration, equals(testConfig));
      expect(preset.createdAt, equals(testDate));
    });

    test('should create copy with updated values', () {
      final original = TimerPreset(
        id: 'original-id',
        name: 'Original',
        configuration: testConfig,
        createdAt: testDate,
      );

      final updated = original.copyWith(name: 'Updated');

      expect(updated.name, equals('Updated'));
      expect(updated.id, equals(original.id));
      expect(updated.configuration, equals(original.configuration));
      expect(updated.createdAt, equals(original.createdAt));
    });

    test('should serialize to and from JSON', () {
      final preset = TimerPreset(
        id: 'json-test',
        name: 'JSON Test',
        configuration: testConfig,
        createdAt: testDate,
      );

      final json = preset.toJson();
      final restored = TimerPreset.fromJson(json);

      expect(restored, equals(preset));
    });

    test('should implement equality correctly', () {
      final preset1 = TimerPreset(
        id: 'same-id',
        name: 'Same Name',
        configuration: testConfig,
        createdAt: testDate,
      );

      final preset2 = TimerPreset(
        id: 'same-id',
        name: 'Same Name',
        configuration: testConfig,
        createdAt: testDate,
      );

      final preset3 = TimerPreset(
        id: 'different-id',
        name: 'Same Name',
        configuration: testConfig,
        createdAt: testDate,
      );

      expect(preset1, equals(preset2));
      expect(preset1, isNot(equals(preset3)));
      expect(preset1.hashCode, equals(preset2.hashCode));
    });

    test('should handle different configurations', () {
      final config1 = const TimerConfiguration(
        repetitions: 5,
        workDuration: Duration(seconds: 20),
        restDuration: Duration(seconds: 5),
      );

      final config2 = const TimerConfiguration(
        repetitions: 10,
        workDuration: Duration(seconds: 40),
        restDuration: Duration(seconds: 10),
      );

      final preset1 = TimerPreset(
        id: 'preset1',
        name: 'Preset 1',
        configuration: config1,
        createdAt: testDate,
      );

      final preset2 = TimerPreset(
        id: 'preset2',
        name: 'Preset 2',
        configuration: config2,
        createdAt: testDate,
      );

      expect(preset1.configuration.totalDuration, equals(const Duration(seconds: 125))); // (20+5) * 5
      expect(preset2.configuration.totalDuration, equals(const Duration(seconds: 500))); // (40+10) * 10
    });

    test('should handle date serialization correctly', () {
      final preset = TimerPreset(
        id: 'date-test',
        name: 'Date Test',
        configuration: testConfig,
        createdAt: DateTime(2024, 3, 15, 14, 30, 45),
      );

      final json = preset.toJson();
      final restored = TimerPreset.fromJson(json);

      expect(restored.createdAt, equals(preset.createdAt));
    });
  });
}
