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
      testDate = DateTime(2024, 1, 15, 14, 22);
    });

    test('should create valid preset', () {
      final preset = TimerPreset(
        id: 'test-id',
        name: 'Test Preset',
        configuration: testConfig,
        createdAt: testDate,
      );

      expect(preset.id, 'test-id');
      expect(preset.name, 'Test Preset');
      expect(preset.configuration, testConfig);
      expect(preset.createdAt, testDate);
      expect(preset.lastUsedAt, null);
    });

    test('should format created time correctly', () {
      final preset = TimerPreset(
        id: 'test-id',
        name: 'Test Preset',
        configuration: testConfig,
        createdAt: testDate, // 14:22
      );

      expect(preset.createdTimeFormatted, '14:22');
    });

    test('should format created time with leading zeros', () {
      final earlyTime = DateTime(2024, 1, 15, 9, 5); // 09:05
      final preset = TimerPreset(
        id: 'test-id',
        name: 'Test Preset',
        configuration: testConfig,
        createdAt: earlyTime,
      );

      expect(preset.createdTimeFormatted, '09:05');
    });

    test('should support copyWith', () {
      final original = TimerPreset(
        id: 'test-id',
        name: 'Original',
        configuration: testConfig,
        createdAt: testDate,
      );

      final modified = original.copyWith(name: 'Modified');

      expect(modified.name, 'Modified');
      expect(modified.id, 'test-id');
      expect(modified.configuration, testConfig);
      expect(modified.createdAt, testDate);
    });

    test('should mark as used', () {
      final preset = TimerPreset(
        id: 'test-id',
        name: 'Test Preset',
        configuration: testConfig,
        createdAt: testDate,
      );

      expect(preset.lastUsedAt, null);

      final usedPreset = preset.markAsUsed();
      expect(usedPreset.lastUsedAt, isNotNull);
      expect(usedPreset.lastUsedAt!.isBefore(DateTime.now().add(const Duration(seconds: 1))), true);
    });

    test('should serialize to/from JSON', () {
      final preset = TimerPreset(
        id: 'test-id',
        name: 'Test Preset',
        configuration: testConfig,
        createdAt: testDate,
        lastUsedAt: testDate.add(const Duration(hours: 1)),
      );

      final json = preset.toJson();
      final restored = TimerPreset.fromJson(json);

      expect(restored, preset);
    });

    test('should serialize to/from JSON without lastUsedAt', () {
      final preset = TimerPreset(
        id: 'test-id',
        name: 'Test Preset',
        configuration: testConfig,
        createdAt: testDate,
      );

      final json = preset.toJson();
      final restored = TimerPreset.fromJson(json);

      expect(restored, preset);
      expect(restored.lastUsedAt, null);
    });

    test('should support equality comparison', () {
      final preset1 = TimerPreset(
        id: 'test-id',
        name: 'Test Preset',
        configuration: testConfig,
        createdAt: testDate,
      );

      final preset2 = TimerPreset(
        id: 'test-id',
        name: 'Test Preset',
        configuration: testConfig,
        createdAt: testDate,
      );

      final preset3 = TimerPreset(
        id: 'different-id',
        name: 'Test Preset',
        configuration: testConfig,
        createdAt: testDate,
      );

      expect(preset1, preset2);
      expect(preset1, isNot(preset3));
    });
  });
}
