import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gestion de l'état de l'écran d'accueil du minuteur d'intervalles
class IntervalTimerHomeState extends ChangeNotifier {
  static const String _repsKey = 'reps';
  static const String _workSecondsKey = 'workSeconds';
  static const String _restSecondsKey = 'restSeconds';
  static const String _volumeKey = 'volume';
  static const String _quickStartExpandedKey = 'quickStartExpanded';

  static const int minReps = 1;
  static const int maxReps = 999;
  static const int minSeconds = 0;
  static const int maxSeconds = 3600;
  static const int minWorkSeconds = 1;

  int _reps = 16;
  int _workSeconds = 44;
  int _restSeconds = 15;
  double _volume = 0.62;
  bool _quickStartExpanded = true;

  int get reps => _reps;
  int get workSeconds => _workSeconds;
  int get restSeconds => _restSeconds;
  double get volume => _volume;
  bool get quickStartExpanded => _quickStartExpanded;

  /// Formatte les secondes en MM:SS
  String formatSeconds(int seconds) {
    final int minutes = seconds ~/ 60;
    final int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : '
        '${secs.toString().padLeft(2, '0')}';
  }

  /// Calcule la durée totale de la session en secondes
  int calculateTotalDuration() {
    return _reps * (_workSeconds + _restSeconds);
  }

  /// Formatte la durée totale en MM:SS
  String get formattedTotalDuration {
    final totalSeconds = calculateTotalDuration();
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  IntervalTimerHomeState() {
    _loadState();
  }

  /// Charge l'état depuis SharedPreferences
  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _reps = prefs.getInt(_repsKey) ?? 16;
      _workSeconds = prefs.getInt(_workSecondsKey) ?? 44;
      _restSeconds = prefs.getInt(_restSecondsKey) ?? 15;
      _volume = prefs.getDouble(_volumeKey) ?? 0.62;
      _quickStartExpanded = prefs.getBool(_quickStartExpandedKey) ?? true;

      // Validation et clamping
      _reps = _reps.clamp(minReps, maxReps);
      _workSeconds = _workSeconds.clamp(minWorkSeconds, maxSeconds);
      _restSeconds = _restSeconds.clamp(minSeconds, maxSeconds);
      _volume = _volume.clamp(0.0, 1.0);

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading state: $e');
    }
  }

  /// Sauvegarde l'état dans SharedPreferences
  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_repsKey, _reps);
      await prefs.setInt(_workSecondsKey, _workSeconds);
      await prefs.setInt(_restSecondsKey, _restSeconds);
      await prefs.setDouble(_volumeKey, _volume);
      await prefs.setBool(_quickStartExpandedKey, _quickStartExpanded);
    } catch (e) {
      debugPrint('Error saving state: $e');
    }
  }

  /// Incrémente les répétitions
  void incrementReps() {
    if (_reps < maxReps) {
      _reps++;
      notifyListeners();
      _saveState();
    }
  }

  /// Décrémente les répétitions
  void decrementReps() {
    if (_reps > minReps) {
      _reps--;
      notifyListeners();
      _saveState();
    }
  }

  /// Incrémente le temps de travail
  void incrementWorkTime() {
    if (_workSeconds < maxSeconds) {
      _workSeconds++;
      notifyListeners();
      _saveState();
    }
  }

  /// Décrémente le temps de travail
  void decrementWorkTime() {
    if (_workSeconds > minWorkSeconds) {
      _workSeconds--;
      notifyListeners();
      _saveState();
    }
  }

  /// Incrémente le temps de repos
  void incrementRestTime() {
    if (_restSeconds < maxSeconds) {
      _restSeconds++;
      notifyListeners();
      _saveState();
    }
  }

  /// Décrémente le temps de repos
  void decrementRestTime() {
    if (_restSeconds > minSeconds) {
      _restSeconds--;
      notifyListeners();
      _saveState();
    }
  }

  /// Met à jour le volume
  void onVolumeChanged(double value) {
    _volume = value.clamp(0.0, 1.0);
    notifyListeners();
    _saveState();
  }

  /// Bascule l'état d'expansion de la section Démarrage rapide
  void toggleQuickStartSection() {
    _quickStartExpanded = !_quickStartExpanded;
    notifyListeners();
    _saveState();
  }

  /// Charge une configuration depuis un préréglage
  void loadPresetConfig(int reps, int workSeconds, int restSeconds) {
    _reps = reps.clamp(minReps, maxReps);
    _workSeconds = workSeconds.clamp(minWorkSeconds, maxSeconds);
    _restSeconds = restSeconds.clamp(minSeconds, maxSeconds);
    notifyListeners();
    _saveState();
  }

  /// Valide si la configuration actuelle est valide pour démarrer
  bool get canStart => _reps >= minReps && _workSeconds >= minWorkSeconds;
}

