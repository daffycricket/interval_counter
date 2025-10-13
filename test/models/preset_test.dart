import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/models/preset.dart';

void main() {
  group('Preset', () {
    group('Construction', () {
      test('crée un preset avec tous les champs', () {
        final preset = Preset(
          id: '1',
          name: 'Test',
          reps: 20,
          workSeconds: 40,
          restSeconds: 3,
        );

        expect(preset.id, '1');
        expect(preset.name, 'Test');
        expect(preset.reps, 20);
        expect(preset.workSeconds, 40);
        expect(preset.restSeconds, 3);
      });
    });

    group('totalSeconds', () {
      test('calcule la durée totale correctement', () {
        final preset = Preset(
          id: '1',
          name: 'Test',
          reps: 20,
          workSeconds: 40,
          restSeconds: 3,
        );

        // 20 × (40 + 3) = 20 × 43 = 860
        expect(preset.totalSeconds, 860);
      });

      test('calcule correctement avec repos à 0', () {
        final preset = Preset(
          id: '1',
          name: 'Test',
          reps: 10,
          workSeconds: 30,
          restSeconds: 0,
        );

        // 10 × 30 = 300
        expect(preset.totalSeconds, 300);
      });
    });

    group('formattedDuration', () {
      test('formate correctement 860 secondes (14:20)', () {
        final preset = Preset(
          id: '1',
          name: 'Test',
          reps: 20,
          workSeconds: 40,
          restSeconds: 3,
        );

        expect(preset.formattedDuration, '14:20');
      });

      test('formate correctement avec padding à gauche', () {
        final preset = Preset(
          id: '1',
          name: 'Test',
          reps: 2,
          workSeconds: 30,
          restSeconds: 5,
        );

        // 2 × 35 = 70 = 1:10
        expect(preset.formattedDuration, '1:10');
      });

      test('formate correctement 3600+ secondes', () {
        final preset = Preset(
          id: '1',
          name: 'Test',
          reps: 100,
          workSeconds: 40,
          restSeconds: 20,
        );

        // 100 × 60 = 6000 = 100:00
        expect(preset.formattedDuration, '100:00');
      });
    });

    group('fromJson / toJson', () {
      test('fromJson crée un preset valide', () {
        final json = {
          'id': '123',
          'name': 'Gainage',
          'reps': 20,
          'workSeconds': 40,
          'restSeconds': 3,
        };

        final preset = Preset.fromJson(json);

        expect(preset.id, '123');
        expect(preset.name, 'Gainage');
        expect(preset.reps, 20);
        expect(preset.workSeconds, 40);
        expect(preset.restSeconds, 3);
      });

      test('toJson produit un JSON valide', () {
        final preset = Preset(
          id: '123',
          name: 'Gainage',
          reps: 20,
          workSeconds: 40,
          restSeconds: 3,
        );

        final json = preset.toJson();

        expect(json['id'], '123');
        expect(json['name'], 'Gainage');
        expect(json['reps'], 20);
        expect(json['workSeconds'], 40);
        expect(json['restSeconds'], 3);
      });

      test('roundtrip fromJson -> toJson -> fromJson préserve les données', () {
        final original = Preset(
          id: '456',
          name: 'Cardio',
          reps: 15,
          workSeconds: 60,
          restSeconds: 10,
        );

        final json = original.toJson();
        final restored = Preset.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.reps, original.reps);
        expect(restored.workSeconds, original.workSeconds);
        expect(restored.restSeconds, original.restSeconds);
      });
    });

    group('copyWith', () {
      test('copyWith sans paramètres retourne une copie identique', () {
        final preset = Preset(
          id: '1',
          name: 'Test',
          reps: 20,
          workSeconds: 40,
          restSeconds: 3,
        );

        final copy = preset.copyWith();

        expect(copy.id, preset.id);
        expect(copy.name, preset.name);
        expect(copy.reps, preset.reps);
        expect(copy.workSeconds, preset.workSeconds);
        expect(copy.restSeconds, preset.restSeconds);
      });

      test('copyWith avec name change uniquement le name', () {
        final preset = Preset(
          id: '1',
          name: 'Test',
          reps: 20,
          workSeconds: 40,
          restSeconds: 3,
        );

        final copy = preset.copyWith(name: 'New Name');

        expect(copy.id, preset.id);
        expect(copy.name, 'New Name');
        expect(copy.reps, preset.reps);
        expect(copy.workSeconds, preset.workSeconds);
        expect(copy.restSeconds, preset.restSeconds);
      });

      test('copyWith avec plusieurs champs change uniquement ceux spécifiés', () {
        final preset = Preset(
          id: '1',
          name: 'Test',
          reps: 20,
          workSeconds: 40,
          restSeconds: 3,
        );

        final copy = preset.copyWith(
          reps: 30,
          workSeconds: 50,
        );

        expect(copy.id, preset.id);
        expect(copy.name, preset.name);
        expect(copy.reps, 30);
        expect(copy.workSeconds, 50);
        expect(copy.restSeconds, preset.restSeconds);
      });
    });

    group('Equality', () {
      test('deux presets avec mêmes valeurs sont égaux', () {
        final preset1 = Preset(
          id: '1',
          name: 'Test',
          reps: 20,
          workSeconds: 40,
          restSeconds: 3,
        );

        final preset2 = Preset(
          id: '1',
          name: 'Test',
          reps: 20,
          workSeconds: 40,
          restSeconds: 3,
        );

        expect(preset1, equals(preset2));
        expect(preset1.hashCode, equals(preset2.hashCode));
      });

      test('deux presets avec valeurs différentes ne sont pas égaux', () {
        final preset1 = Preset(
          id: '1',
          name: 'Test',
          reps: 20,
          workSeconds: 40,
          restSeconds: 3,
        );

        final preset2 = Preset(
          id: '1',
          name: 'Test',
          reps: 21, // Différent
          workSeconds: 40,
          restSeconds: 3,
        );

        expect(preset1, isNot(equals(preset2)));
      });

      test('preset égal à lui-même', () {
        final preset = Preset(
          id: '1',
          name: 'Test',
          reps: 20,
          workSeconds: 40,
          restSeconds: 3,
        );

        expect(preset, equals(preset));
      });
    });
  });
}

