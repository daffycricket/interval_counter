import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/domain/preset_calculator.dart';

void main() {
  group('PresetCalculator.calculateTotal', () {
    test('default spec values: 5 + 10×(40+20) + 30 = 635', () {
      final result = PresetCalculator.calculateTotal(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
      );
      expect(result, 635);
    });

    test('all zeros returns 0', () {
      final result = PresetCalculator.calculateTotal(
        prepareSeconds: 0,
        repetitions: 0,
        workSeconds: 0,
        restSeconds: 0,
        cooldownSeconds: 0,
      );
      expect(result, 0);
    });

    test('1 rep, work=90, rest=30: 0 + 1×(90+30) + 0 = 120', () {
      final result = PresetCalculator.calculateTotal(
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 90,
        restSeconds: 30,
        cooldownSeconds: 0,
      );
      expect(result, 120);
    });

    test('only prepare and cooldown (reps=0)', () {
      final result = PresetCalculator.calculateTotal(
        prepareSeconds: 10,
        repetitions: 0,
        workSeconds: 60,
        restSeconds: 30,
        cooldownSeconds: 20,
      );
      expect(result, 30); // 10 + 0 + 20
    });

    test('spec scenario T13: prepare=5, reps=10, work=40, rest=20, cooldown=30', () {
      // Spec §10 T13: "returns TOTAL 11:35" (spec typo — actually 10:35)
      // 5 + 10×(40+20) + 30 = 635s = 10min 35s
      final result = PresetCalculator.calculateTotal(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
      );
      expect(result, 635);
    });

    test('incremented prepare: 6 + 10×(40+20) + 30 = 636', () {
      final result = PresetCalculator.calculateTotal(
        prepareSeconds: 6,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
      );
      expect(result, 636);
    });
  });

  group('PresetCalculator.formatTotal', () {
    test('default values: "TOTAL 10:35"', () {
      final result = PresetCalculator.formatTotal(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
      );
      expect(result, 'TOTAL 10:35');
    });

    test('all zeros: "TOTAL 00:00"', () {
      final result = PresetCalculator.formatTotal(
        prepareSeconds: 0,
        repetitions: 0,
        workSeconds: 0,
        restSeconds: 0,
        cooldownSeconds: 0,
      );
      expect(result, 'TOTAL 00:00');
    });

    test('120 seconds: "TOTAL 02:00"', () {
      final result = PresetCalculator.formatTotal(
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 90,
        restSeconds: 30,
        cooldownSeconds: 0,
      );
      expect(result, 'TOTAL 02:00');
    });

    test('prefix is "TOTAL " (with space)', () {
      final result = PresetCalculator.formatTotal(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
      );
      expect(result, startsWith('TOTAL '));
    });

    test('no spaces around colon (unlike TimeFormatter)', () {
      final result = PresetCalculator.formatTotal(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
      );
      // TimeFormatter uses " : " with spaces; formatTotal uses ":"
      expect(result, isNot(contains(' : ')));
    });
  });
}
