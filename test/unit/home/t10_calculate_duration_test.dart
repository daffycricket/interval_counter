import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/models/preset.dart';

void main() {
  group('Calcul de durée totale', () {
    test('T15: reps=16, work=44, rest=15 → 944 secondes (15:44)', () {
      final preset = Preset(
        id: 'test',
        name: 'Test',
        repetitions: 16,
        workSeconds: 44,
        restSeconds: 15,
        createdAt: DateTime.now(),
      );

      expect(preset.totalDuration, 944);
      expect(preset.formattedDuration, '15:44');
    });

    test('T16: reps=20, work=40, rest=3 → 860 secondes (14:20)', () {
      final preset = Preset(
        id: 'test',
        name: 'Test',
        repetitions: 20,
        workSeconds: 40,
        restSeconds: 3,
        createdAt: DateTime.now(),
      );

      expect(preset.totalDuration, 860);
      expect(preset.formattedDuration, '14:20');
    });

    test('Durée avec heures (reps=100, work=60, rest=0 → 1h40)', () {
      final preset = Preset(
        id: 'test',
        name: 'Test',
        repetitions: 100,
        workSeconds: 60,
        restSeconds: 0,
        createdAt: DateTime.now(),
      );

      expect(preset.totalDuration, 6000);
      expect(preset.formattedDuration, '01:40:00');
    });

    test('Durée minimale (reps=1, work=1, rest=0 → 00:01)', () {
      final preset = Preset(
        id: 'test',
        name: 'Test',
        repetitions: 1,
        workSeconds: 1,
        restSeconds: 0,
        createdAt: DateTime.now(),
      );

      expect(preset.totalDuration, 1);
      expect(preset.formattedDuration, '00:01');
    });
  });
}

