import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/models/preset.dart';

void main() {
  group('Preset Model Tests', () {
    test('totalDurationSeconds calculates correctly', () {
      final preset = Preset(
        id: '1',
        name: 'Test',
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 15,
        createdAt: DateTime.now(),
      );

      expect(preset.totalDurationSeconds, 450); // 10 * (30 + 15)
    });

    test('formattedDuration formats correctly', () {
      final preset = Preset(
        id: '1',
        name: 'Test',
        repetitions: 20,
        workSeconds: 40,
        restSeconds: 3,
        createdAt: DateTime.now(),
      );

      expect(preset.formattedDuration, '14:20'); // 20 * 43 = 860s = 14m 20s
    });

    test('toJson and fromJson roundtrip works', () {
      final now = DateTime.now();
      final preset = Preset(
        id: '123',
        name: 'Gainage',
        repetitions: 20,
        workSeconds: 40,
        restSeconds: 3,
        createdAt: now,
      );

      final json = preset.toJson();
      final restored = Preset.fromJson(json);

      expect(restored.id, preset.id);
      expect(restored.name, preset.name);
      expect(restored.repetitions, preset.repetitions);
      expect(restored.workSeconds, preset.workSeconds);
      expect(restored.restSeconds, preset.restSeconds);
      expect(restored.createdAt.toIso8601String(), preset.createdAt.toIso8601String());
    });

    test('copyWith creates modified copy', () {
      final preset = Preset(
        id: '1',
        name: 'Original',
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 15,
        createdAt: DateTime.now(),
      );

      final modified = preset.copyWith(name: 'Modified', repetitions: 20);

      expect(modified.name, 'Modified');
      expect(modified.repetitions, 20);
      expect(modified.workSeconds, preset.workSeconds);
      expect(modified.restSeconds, preset.restSeconds);
      expect(modified.id, preset.id);
    });
  });
}
