import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/domain/time_formatter.dart';

void main() {
  group('TimeFormatter', () {
    test('formats 0 seconds as "00 : 00"', () {
      expect(TimeFormatter.format(0), '00 : 00');
    });

    test('formats 44 seconds as "00 : 44"', () {
      expect(TimeFormatter.format(44), '00 : 44');
    });

    test('formats 60 seconds as "01 : 00"', () {
      expect(TimeFormatter.format(60), '01 : 00');
    });

    test('formats 65 seconds as "01 : 05"', () {
      expect(TimeFormatter.format(65), '01 : 05');
    });

    test('formats 3599 seconds as "59 : 59"', () {
      expect(TimeFormatter.format(3599), '59 : 59');
    });

    test('formats 3600 seconds as "01 : 00 : 00"', () {
      expect(TimeFormatter.format(3600), '01 : 00 : 00');
    });

    test('formats 3661 seconds as "01 : 01 : 01"', () {
      expect(TimeFormatter.format(3661), '01 : 01 : 01');
    });

    test('formats 7384 seconds as "02 : 03 : 04"', () {
      expect(TimeFormatter.format(7384), '02 : 03 : 04');
    });
  });
}
