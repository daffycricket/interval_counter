import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/models/preset.dart';

void main() {
  group('Preset', () {
    test('creates preset with required fields', () {
      const preset = Preset(
        id: 'test-id',
        name: 'Gainage',
        repetitions: 20,
        workSeconds: 40,
        restSeconds: 3,
      );

      expect(preset.id, 'test-id');
      expect(preset.name, 'Gainage');
      expect(preset.repetitions, 20);
      expect(preset.workSeconds, 40);
      expect(preset.restSeconds, 3);
    });

    test('calculates total duration correctly', () {
      const preset = Preset(
        id: 'test-id',
        name: 'Test',
        repetitions: 20,
        workSeconds: 40,
        restSeconds: 3,
      );

      // 20 * (40 + 3) = 20 * 43 = 860 seconds
      expect(preset.totalDurationSeconds, 860);
    });

    test('formats duration as mm:ss', () {
      const preset = Preset(
        id: 'test-id',
        name: 'Test',
        repetitions: 20,
        workSeconds: 40,
        restSeconds: 3,
      );

      // 860 seconds = 14 minutes 20 seconds
      expect(preset.formattedDuration, '14:20');
    });

    test('formats duration less than 1 minute', () {
      const preset = Preset(
        id: 'test-id',
        name: 'Test',
        repetitions: 2,
        workSeconds: 20,
        restSeconds: 5,
      );

      // 2 * 25 = 50 seconds
      expect(preset.formattedDuration, '00:50');
    });

    test('factory create generates unique ID', () {
      final preset1 = Preset.create(
        name: 'Test1',
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 10,
      );

      final preset2 = Preset.create(
        name: 'Test2',
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 10,
      );

      expect(preset1.id, isNot(preset2.id));
      expect(preset1.id, isNotEmpty);
      expect(preset2.id, isNotEmpty);
    });

    test('fromJson creates preset from map', () {
      final json = {
        'id': 'json-id',
        'name': 'JSON Preset',
        'repetitions': 15,
        'workSeconds': 45,
        'restSeconds': 15,
      };

      final preset = Preset.fromJson(json);

      expect(preset.id, 'json-id');
      expect(preset.name, 'JSON Preset');
      expect(preset.repetitions, 15);
      expect(preset.workSeconds, 45);
      expect(preset.restSeconds, 15);
    });

    test('toJson converts preset to map', () {
      const preset = Preset(
        id: 'test-id',
        name: 'Test Preset',
        repetitions: 12,
        workSeconds: 35,
        restSeconds: 10,
      );

      final json = preset.toJson();

      expect(json['id'], 'test-id');
      expect(json['name'], 'Test Preset');
      expect(json['repetitions'], 12);
      expect(json['workSeconds'], 35);
      expect(json['restSeconds'], 10);
    });

    test('copyWith creates modified copy', () {
      const preset = Preset(
        id: 'test-id',
        name: 'Original',
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 10,
      );

      final modified = preset.copyWith(name: 'Modified', repetitions: 20);

      expect(modified.id, preset.id);
      expect(modified.name, 'Modified');
      expect(modified.repetitions, 20);
      expect(modified.workSeconds, preset.workSeconds);
      expect(modified.restSeconds, preset.restSeconds);
    });

    test('equality works correctly', () {
      const preset1 = Preset(
        id: 'same-id',
        name: 'Test',
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 10,
      );

      const preset2 = Preset(
        id: 'same-id',
        name: 'Test',
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 10,
      );

      const preset3 = Preset(
        id: 'different-id',
        name: 'Test',
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 10,
      );

      expect(preset1, equals(preset2));
      expect(preset1, isNot(equals(preset3)));
    });

    test('hashCode is consistent', () {
      const preset1 = Preset(
        id: 'test-id',
        name: 'Test',
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 10,
      );

      const preset2 = Preset(
        id: 'test-id',
        name: 'Test',
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 10,
      );

      expect(preset1.hashCode, equals(preset2.hashCode));
    });

    test('toString returns readable format', () {
      const preset = Preset(
        id: 'test-id',
        name: 'Test',
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 10,
      );

      final string = preset.toString();
      
      expect(string, contains('test-id'));
      expect(string, contains('Test'));
      expect(string, contains('10'));
      expect(string, contains('30'));
    });

    // Tests pour les nouveaux champs (prepareSeconds, cooldownSeconds)
    
    test('creates preset with prepareSeconds and cooldownSeconds', () {
      const preset = Preset(
        id: 'test-id',
        name: 'Advanced',
        prepareSeconds: 10,
        repetitions: 15,
        workSeconds: 45,
        restSeconds: 20,
        cooldownSeconds: 30,
      );

      expect(preset.prepareSeconds, 10);
      expect(preset.cooldownSeconds, 30);
    });

    test('uses default values for prepareSeconds and cooldownSeconds', () {
      const preset = Preset(
        id: 'test-id',
        name: 'Basic',
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 10,
      );

      expect(preset.prepareSeconds, 0);
      expect(preset.cooldownSeconds, 0);
    });

    test('calculates total duration with prepare and cooldown', () {
      const preset = Preset(
        id: 'test-id',
        name: 'Full',
        prepareSeconds: 10,
        repetitions: 5,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
      );

      // 10 (prepare) + 5 * (40 + 20) (work/rest) + 30 (cooldown) = 10 + 300 + 30 = 340
      expect(preset.totalDurationSeconds, 340);
    });

    test('fromJson handles missing prepareSeconds and cooldownSeconds', () {
      final json = {
        'id': 'legacy-id',
        'name': 'Legacy Preset',
        'repetitions': 15,
        'workSeconds': 45,
        'restSeconds': 15,
      };

      final preset = Preset.fromJson(json);

      expect(preset.id, 'legacy-id');
      expect(preset.prepareSeconds, 0);
      expect(preset.cooldownSeconds, 0);
    });

    test('fromJson parses prepareSeconds and cooldownSeconds', () {
      final json = {
        'id': 'new-id',
        'name': 'New Preset',
        'prepareSeconds': 5,
        'repetitions': 10,
        'workSeconds': 40,
        'restSeconds': 20,
        'cooldownSeconds': 30,
      };

      final preset = Preset.fromJson(json);

      expect(preset.prepareSeconds, 5);
      expect(preset.cooldownSeconds, 30);
    });

    test('toJson includes prepareSeconds and cooldownSeconds', () {
      const preset = Preset(
        id: 'test-id',
        name: 'Complete',
        prepareSeconds: 5,
        repetitions: 12,
        workSeconds: 35,
        restSeconds: 10,
        cooldownSeconds: 25,
      );

      final json = preset.toJson();

      expect(json['prepareSeconds'], 5);
      expect(json['cooldownSeconds'], 25);
    });

    test('copyWith works with prepareSeconds and cooldownSeconds', () {
      const preset = Preset(
        id: 'test-id',
        name: 'Original',
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 10,
        cooldownSeconds: 20,
      );

      final modified = preset.copyWith(
        prepareSeconds: 10,
        cooldownSeconds: 30,
      );

      expect(modified.prepareSeconds, 10);
      expect(modified.cooldownSeconds, 30);
      expect(modified.repetitions, preset.repetitions);
    });

    test('equality includes prepareSeconds and cooldownSeconds', () {
      const preset1 = Preset(
        id: 'same-id',
        name: 'Test',
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 10,
        cooldownSeconds: 20,
      );

      const preset2 = Preset(
        id: 'same-id',
        name: 'Test',
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 10,
        cooldownSeconds: 20,
      );

      const preset3 = Preset(
        id: 'same-id',
        name: 'Test',
        prepareSeconds: 10, // Different
        repetitions: 10,
        workSeconds: 30,
        restSeconds: 10,
        cooldownSeconds: 20,
      );

      expect(preset1, equals(preset2));
      expect(preset1, isNot(equals(preset3)));
    });
  });
}

