/// Utilitaires pour le formatage des durées
class DurationFormatter {
  /// Formate une durée au format mm:ss
  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }

  /// Parse une chaîne au format mm:ss vers Duration
  static Duration? parseDuration(String formatted) {
    try {
      // Supporte les formats "mm:ss" et "mm : ss"
      final cleaned = formatted.replaceAll(' ', '');
      final parts = cleaned.split(':');
      
      if (parts.length != 2) return null;
      
      final minutes = int.parse(parts[0]);
      final seconds = int.parse(parts[1]);
      
      if (minutes < 0 || seconds < 0 || seconds >= 60) return null;
      
      return Duration(minutes: minutes, seconds: seconds);
    } catch (e) {
      return null;
    }
  }

  /// Formate une durée totale de manière lisible
  static String formatTotalDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h${minutes.toString().padLeft(2, '0')}';
    } else {
      return '${minutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
  }

  /// Incrémente une durée de façon intelligente
  static Duration incrementDuration(Duration current, {int seconds = 1}) {
    final newDuration = Duration(seconds: current.inSeconds + seconds);
    return newDuration.isNegative ? Duration.zero : newDuration;
  }

  /// Décrémente une durée de façon intelligente
  static Duration decrementDuration(Duration current, {int seconds = 1}) {
    final newDuration = Duration(seconds: current.inSeconds - seconds);
    return newDuration.isNegative ? Duration.zero : newDuration;
  }

  /// Incrémente une durée par paliers intelligents
  static Duration smartIncrement(Duration current) {
    final totalSeconds = current.inSeconds;
    
    if (totalSeconds < 60) {
      // Moins d'1 minute : incrément de 5 secondes
      return incrementDuration(current, seconds: 5);
    } else if (totalSeconds < 300) {
      // Moins de 5 minutes : incrément de 15 secondes
      return incrementDuration(current, seconds: 15);
    } else {
      // Plus de 5 minutes : incrément de 30 secondes
      return incrementDuration(current, seconds: 30);
    }
  }

  /// Décrémente une durée par paliers intelligents
  static Duration smartDecrement(Duration current) {
    final totalSeconds = current.inSeconds;
    
    if (totalSeconds <= 5) {
      // Minimum 1 seconde
      return const Duration(seconds: 1);
    } else if (totalSeconds <= 60) {
      // Moins d'1 minute : décrément de 5 secondes
      return decrementDuration(current, seconds: 5);
    } else if (totalSeconds <= 300) {
      // Moins de 5 minutes : décrément de 15 secondes
      return decrementDuration(current, seconds: 15);
    } else {
      // Plus de 5 minutes : décrément de 30 secondes
      return decrementDuration(current, seconds: 30);
    }
  }
}
