class DurationFormatter {
  /// Formate une durée au format mm:ss
  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Formate une durée au format hh:mm pour les durées longues
  static String formatTotalDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
  }

  /// Parse une chaîne au format mm:ss vers Duration
  static Duration? parseDuration(String durationString) {
    try {
      final parts = durationString.split(':');
      if (parts.length != 2) return null;
      
      final minutes = int.parse(parts[0]);
      final seconds = int.parse(parts[1]);
      
      if (minutes < 0 || seconds < 0 || seconds >= 60) return null;
      
      return Duration(minutes: minutes, seconds: seconds);
    } catch (e) {
      return null;
    }
  }

  /// Valide si une chaîne est un format de durée valide
  static bool isValidDurationFormat(String durationString) {
    return parseDuration(durationString) != null;
  }

  /// Incrémente une durée de n secondes
  static Duration incrementDuration(Duration duration, int seconds) {
    final newDuration = Duration(seconds: duration.inSeconds + seconds);
    return newDuration.isNegative ? Duration.zero : newDuration;
  }

  /// Décrémente une durée de n secondes (minimum 1 seconde)
  static Duration decrementDuration(Duration duration, int seconds) {
    final newSeconds = duration.inSeconds - seconds;
    return Duration(seconds: newSeconds < 1 ? 1 : newSeconds);
  }
}
