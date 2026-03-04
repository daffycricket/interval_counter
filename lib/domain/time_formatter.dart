/// Formats a duration in seconds to "mm : ss" (or "hh : mm : ss" for ≥1h).
/// Spaces around colons per spec §4.2.
/// Pure Dart — no Flutter imports.
class TimeFormatter {
  TimeFormatter._();

  static String format(int seconds) {
    if (seconds >= 3600) {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      final secs = seconds % 60;
      return '${hours.toString().padLeft(2, '0')} : '
          '${minutes.toString().padLeft(2, '0')} : '
          '${secs.toString().padLeft(2, '0')}';
    } else {
      final minutes = seconds ~/ 60;
      final secs = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')} : '
          '${secs.toString().padLeft(2, '0')}';
    }
  }
}
