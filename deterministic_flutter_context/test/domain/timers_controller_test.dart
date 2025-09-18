import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/domain/timers/timers_controller.dart';

void main() {
  test('should increment/decrement repetitions', () {
    final c = TimersController(repetitions: 1);
    c.incReps();
    expect(c.repetitions, 2);
    c.decReps();
    expect(c.repetitions, 1);
  });
}
