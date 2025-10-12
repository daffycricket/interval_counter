import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/preset.dart';

/// État de l'écran IntervalTimerHome
class IntervalTimerHomeState extends ChangeNotifier {
  static const String _repsKey = 'reps';
  static const String _workSecondsKey = 'workSeconds';
  static const String _restSecondsKey = 'restSeconds';
  static const String _volumeKey = 'volume';

  // Contraintes
  static const int minReps = 1;
  static const int maxReps = 99;
  static const int minWorkSeconds = 1;
  static const int maxWorkSeconds = 3599; // 59:59
  static const int minRestSeconds = 0;
  static const int maxRestSeconds = 3599; // 59:59
  static const int timeStep = 5; // Incrémentation/décrémentation en secondes

  // Valeurs d'état
  int _reps = 16;
  int _workSeconds = 44;
  int _restSeconds = 15;
  double _volume = 0.62;
  bool _quickStartExpanded = true;

  // Getters
  int get reps => _reps;
  int get workSeconds => _workSeconds;
  int get restSeconds => _restSeconds;
  double get volume => _volume;
  bool get quickStartExpanded => _quickStartExpanded;

  /// Formatte les secondes en MM:SS
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${secs.toString().padLeft(2, '0')}';
  }

  /// Temps de travail formaté
  String get formattedWorkTime => formatTime(_workSeconds);

  /// Temps de repos formaté
  String get formattedRestTime => formatTime(_restSeconds);

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

      // Validation et clamping
      _reps = _reps.clamp(minReps, maxReps);
      _workSeconds = _workSeconds.clamp(minWorkSeconds, maxWorkSeconds);
      _restSeconds = _restSeconds.clamp(minRestSeconds, maxRestSeconds);
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
    if (_workSeconds < maxWorkSeconds) {
      _workSeconds = (_workSeconds + timeStep).clamp(minWorkSeconds, maxWorkSeconds);
      notifyListeners();
      _saveState();
    }
  }

  /// Décrémente le temps de travail
  void decrementWorkTime() {
    if (_workSeconds > minWorkSeconds) {
      _workSeconds = (_workSeconds - timeStep).clamp(minWorkSeconds, maxWorkSeconds);
      notifyListeners();
      _saveState();
    }
  }

  /// Incrémente le temps de repos
  void incrementRestTime() {
    if (_restSeconds < maxRestSeconds) {
      _restSeconds = (_restSeconds + timeStep).clamp(minRestSeconds, maxRestSeconds);
      notifyListeners();
      _saveState();
    }
  }

  /// Décrémente le temps de repos
  void decrementRestTime() {
    if (_restSeconds > minRestSeconds) {
      _restSeconds = (_restSeconds - timeStep).clamp(minRestSeconds, maxRestSeconds);
      notifyListeners();
      _saveState();
    }
  }

  /// Met à jour le volume
  void updateVolume(double value) {
    _volume = value.clamp(0.0, 1.0);
    notifyListeners();
    _saveState();
  }

  /// Toggle la section de démarrage rapide
  void toggleQuickStartSection() {
    _quickStartExpanded = !_quickStartExpanded;
    notifyListeners();
  }

  /// Charge un préréglage
  void loadPreset(Preset preset) {
    _reps = preset.reps.clamp(minReps, maxReps);
    _workSeconds = preset.workSeconds.clamp(minWorkSeconds, maxWorkSeconds);
    _restSeconds = preset.restSeconds.clamp(minRestSeconds, maxRestSeconds);
    notifyListeners();
    _saveState();
  }

  /// Crée un préréglage à partir des valeurs actuelles
  Preset createPresetFromCurrentValues(String id, String name) {
    return Preset(
      id: id,
      name: name,
      reps: _reps,
      workSeconds: _workSeconds,
      restSeconds: _restSeconds,
    );
  }

  /// Valide si les valeurs actuelles permettent de démarrer
  bool get canStart => _reps >= minReps && _workSeconds >= minWorkSeconds;
}

