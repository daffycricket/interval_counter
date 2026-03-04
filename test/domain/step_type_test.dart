import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/domain/step_type.dart';

void main() {
  group('StepType', () {
    test('has all expected values', () {
      expect(StepType.values, hasLength(4));
      expect(StepType.values, contains(StepType.preparation));
      expect(StepType.values, contains(StepType.work));
      expect(StepType.values, contains(StepType.rest));
      expect(StepType.values, contains(StepType.cooldown));
    });

    test('values have correct indices', () {
      expect(StepType.preparation.index, 0);
      expect(StepType.work.index, 1);
      expect(StepType.rest.index, 2);
      expect(StepType.cooldown.index, 3);
    });
  });
}
