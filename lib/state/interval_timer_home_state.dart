import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// État de l'écran principal du minuteur d'intervalles
class IntervalTimerHomeState extends ChangeNotifier {
  // Contraintes
  static const int minReps = 1;
  static const int maxReps = 999;
  static const int minWork = 1;
  static const int maxWork = 3599; // 59:59
  static const int minRest = 0;
  static const int maxRest = 3599; // 59:59
  static const int stepSize = 1; // Incrément/décrément en secondes

  // Clés SharedPreferences
  static const String _keyReps = 'quick_start_reps';
  static const String _keyWork = 'quick_start_work';
  static const String _keyRest = 'quick_start_rest';
  static const String _keyVolume = 'volume_level';
  static const String _keyExpanded = 'quick_start_expanded';

  // État local
  int _repetitions = 16;
  int _workSeconds = 44;
  int _restSeconds = 15;
  double _volumeLevel = 0.62;
  bool _quickStartExpanded = true;
  bool _editMode = false;

  // Getters
  int get repetitions => _repetitions;
  int get workSeconds => _workSeconds;
  int get restSeconds => _restSeconds;
  double get volumeLevel => _volumeLevel;
  bool get quickStartExpanded => _quickStartExpanded;
  bool get editMode => _editMode;

  // Valeur formattée pour affichage (MM : SS)
  String get formattedWorkTime => _formatTime(_workSeconds);
  String get formattedRestTime => _formatTime(_restSeconds);

  // Validation : configuration valide pour démarrer
  bool get isConfigValid =>
      _repetitions >= minReps &&
      _repetitions <= maxReps &&
      _workSeconds >= minWork &&
      _workSeconds <= maxWork &&
      _restSeconds >= minRest &&
      _restSeconds <= maxRest;

  // États des boutons
  bool get canIncrementReps => _repetitions < maxReps;
  bool get canDecrementReps => _repetitions > minReps;
  bool get canIncrementWork => _workSeconds < maxWork;
  bool get canDecrementWork => _workSeconds > minWork;
  bool get canIncrementRest => _restSeconds < maxRest;
  bool get canDecrementRest => _restSeconds > minRest;

  /// Constructeur : charge l'état depuis SharedPreferences
  IntervalTimerHomeState() {
    _loadState();
  }

  /// Charge l'état depuis SharedPreferences
  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _repetitions = prefs.getInt(_keyReps) ?? 16;
      _workSeconds = prefs.getInt(_keyWork) ?? 44;
      _restSeconds = prefs.getInt(_keyRest) ?? 15;
      _volumeLevel = prefs.getDouble(_keyVolume) ?? 0.62;
      _quickStartExpanded = prefs.getBool(_keyExpanded) ?? true;

      // Valider les valeurs chargées
      _repetitions = _repetitions.clamp(minReps, maxReps);
      _workSeconds = _workSeconds.clamp(minWork, maxWork);
      _restSeconds = _restSeconds.clamp(minRest, maxRest);
      _volumeLevel = _volumeLevel.clamp(0.0, 1.0);

      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement de l\'état: $e');
    }
  }

  /// Sauvegarde l'état dans SharedPreferences
  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyReps, _repetitions);
      await prefs.setInt(_keyWork, _workSeconds);
      await prefs.setInt(_keyRest, _restSeconds);
      await prefs.setDouble(_keyVolume, _volumeLevel);
      await prefs.setBool(_keyExpanded, _quickStartExpanded);
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde de l\'état: $e');
    }
  }

  /// Incrémente les répétitions
  void incrementReps() {
    if (canIncrementReps) {
      _repetitions++;
      notifyListeners();
      _saveState();
    }
  }

  /// Décrémente les répétitions
  void decrementReps() {
    if (canDecrementReps) {
      _repetitions--;
      notifyListeners();
      _saveState();
    }
  }

  /// Incrémente le temps de travail
  void incrementWork() {
    if (canIncrementWork) {
      _workSeconds += stepSize;
      notifyListeners();
      _saveState();
    }
  }

  /// Décrémente le temps de travail
  void decrementWork() {
    if (canDecrementWork) {
      _workSeconds -= stepSize;
      notifyListeners();
      _saveState();
    }
  }

  /// Incrémente le temps de repos
  void incrementRest() {
    if (canIncrementRest) {
      _restSeconds += stepSize;
      notifyListeners();
      _saveState();
    }
  }

  /// Décrémente le temps de repos
  void decrementRest() {
    if (canDecrementRest) {
      _restSeconds -= stepSize;
      notifyListeners();
      _saveState();
    }
  }

  /// Définit le niveau de volume
  void setVolume(double value) {
    _volumeLevel = value.clamp(0.0, 1.0);
    notifyListeners();
    _saveState();
  }

  /// Bascule l'état d'expansion de la section rapide
  void toggleQuickStartSection() {
    _quickStartExpanded = !_quickStartExpanded;
    notifyListeners();
    _saveState();
  }

  /// Active le mode édition des préréglages
  void enterEditMode() {
    _editMode = true;
    notifyListeners();
  }

  /// Désactive le mode édition des préréglages
  void exitEditMode() {
    _editMode = false;
    notifyListeners();
  }

  /// Charge les valeurs d'un préréglage dans la configuration rapide
  void loadPresetValues({
    required int repetitions,
    required int workSeconds,
    required int restSeconds,
  }) {
    _repetitions = repetitions.clamp(minReps, maxReps);
    _workSeconds = workSeconds.clamp(minWork, maxWork);
    _restSeconds = restSeconds.clamp(minRest, maxRest);
    notifyListeners();
    _saveState();
  }

  /// Formate un temps en secondes vers MM : SS
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${secs.toString().padLeft(2, '0')}';
  }

  /// Calcule la durée totale de l'intervalle configuré
  int calculateTotalDuration() {
    return _repetitions * (_workSeconds + _restSeconds);
  }
}
