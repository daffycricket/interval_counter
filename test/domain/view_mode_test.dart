import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/domain/view_mode.dart';

void main() {
  group('ViewMode', () {
    test('has simple value', () {
      expect(ViewMode.simple, isA<ViewMode>());
    });

    test('has advanced value', () {
      expect(ViewMode.advanced, isA<ViewMode>());
    });

    test('simple and advanced are distinct', () {
      expect(ViewMode.simple, isNot(ViewMode.advanced));
    });

    test('values contains both modes', () {
      expect(ViewMode.values, containsAll([ViewMode.simple, ViewMode.advanced]));
      expect(ViewMode.values.length, 2);
    });
  });
}
