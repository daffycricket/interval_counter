import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/preset.dart';

/// Type d'étape dans la session d'entraînement
enum StepType {
  preparation,
  work,
  rest,
  cooldown,
}

/// État de l'écran Workout
/// Gère le timer, les transitions d'étapes et les contrôles
class WorkoutState extends ChangeNotifier {
  final SharedPreferences _prefs;
  final Preset preset;
  
  // Clés de persistance
  static const String _keyVolume = 'workout_volume';
  static const String _keySoundEnabled = 'workout_sound_enabled';
  
  // État privé
  StepType _currentStep = StepType.preparation;
  int _remainingTime = 0;
  int _remainingReps = 0;
  bool _isPaused = false;
  double _volume = 0.9;
  bool _soundEnabled = true;
  bool _controlsVisible = true;
  DateTime? _lastTapTime;
  Timer? _timer;
  Timer? _controlsHideTimer;
  
  // Callback pour navigation
  final VoidCallback? onWorkoutComplete;
  
  // Getters publics
  StepType get currentStep => _currentStep;
  int get remainingTime => _remainingTime;
  int get remainingReps => _remainingReps;
  bool get isPaused => _isPaused;
  double get volume => _volume;
  bool get soundEnabled => _soundEnabled;
  bool get controlsVisible => _controlsVisible;
  
  /// Formatte le temps restant en MM:SS
  String get formattedTime {
    final minutes = _remainingTime ~/ 60;
    final seconds = _remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  /// Retourne le libellé de l'étape actuelle
  String get stepLabel {
    switch (_currentStep) {
      case StepType.preparation:
        return 'PRÉPARER';
      case StepType.work:
        return 'TRAVAIL';
      case StepType.rest:
        return 'REPOS';
      case StepType.cooldown:
        return 'REFROIDIR';
    }
  }
  
  /// Indique si le compteur de répétitions doit être affiché
  bool get shouldShowRepsCounter {
    return _currentStep == StepType.work || _currentStep == StepType.rest;
  }
  
  /// Constructeur de production (async, instantie les dépendances)
  static Future<WorkoutState> create(Preset preset, {VoidCallback? onWorkoutComplete}) async {
    final prefs = await SharedPreferences.getInstance();
    return WorkoutState(prefs, preset, onWorkoutComplete: onWorkoutComplete);
  }
  
  /// Constructeur de test (sync, accepte les dépendances)
  WorkoutState(this._prefs, this.preset, {this.onWorkoutComplete}) {
    _loadState();
    _initializeWorkout();
    startTimer();
  }
  
  /// Charge l'état depuis SharedPreferences
  void _loadState() {
    _volume = _prefs.getDouble(_keyVolume) ?? 0.9;
    _soundEnabled = _prefs.getBool(_keySoundEnabled) ?? true;
    
    // Valider les valeurs
    _volume = _volume.clamp(0.0, 1.0);
  }
  
  /// Sauvegarde l'état dans SharedPreferences
  Future<void> _saveState() async {
    await _prefs.setDouble(_keyVolume, _volume);
    await _prefs.setBool(_keySoundEnabled, _soundEnabled);
  }
  
  /// Initialise la session d'entraînement
  void _initializeWorkout() {
    _remainingReps = preset.repetitions;
    
    // Déterminer l'étape initiale
    if (preset.prepareSeconds > 0) {
      _currentStep = StepType.preparation;
      _remainingTime = preset.prepareSeconds;
    } else if (preset.workSeconds > 0) {
      _currentStep = StepType.work;
      _remainingTime = preset.workSeconds;
    } else {
      // Pas d'étape valide
      _currentStep = StepType.work;
      _remainingTime = 0;
    }
  }
  
  /// Démarre le timer
  void startTimer() {
    if (_timer != null && _timer!.isActive) {
      return;
    }
    
    _isPaused = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
    notifyListeners();
  }
  
  /// Arrête le timer
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isPaused = true;
    notifyListeners();
  }
  
  /// Tick du timer (appelé chaque seconde)
  void tick() {
    if (_remainingTime > 0) {
      _remainingTime--;
      
      // Émettre un bip lors des 3 dernières secondes
      if (_remainingTime <= 3 && _remainingTime > 0) {
        playBeep();
      }
      
      notifyListeners();
    } else {
      // Temps écoulé, passer à l'étape suivante
      nextStep();
    }
  }
  
  /// Passe à l'étape suivante
  void nextStep() {
    switch (_currentStep) {
      case StepType.preparation:
        // Préparation → Travail
        _currentStep = StepType.work;
        _remainingTime = preset.workSeconds;
        break;
        
      case StepType.work:
        // Travail → Repos (sauf dernière répétition)
        _remainingReps--;
        if (_remainingReps > 0 && preset.restSeconds > 0) {
          _currentStep = StepType.rest;
          _remainingTime = preset.restSeconds;
        } else {
          // Dernière répétition ou pas de repos → Refroidissement
          _goToCooldownOrEnd();
        }
        break;
        
      case StepType.rest:
        // Repos → Travail
        if (_remainingReps > 0) {
          _currentStep = StepType.work;
          _remainingTime = preset.workSeconds;
        } else {
          _goToCooldownOrEnd();
        }
        break;
        
      case StepType.cooldown:
        // Refroidissement → Fin
        _endWorkout();
        return;
    }
    
    notifyListeners();
  }
  
  /// Va à l'étape de refroidissement ou termine
  void _goToCooldownOrEnd() {
    if (preset.cooldownSeconds > 0) {
      _currentStep = StepType.cooldown;
      _remainingTime = preset.cooldownSeconds;
    } else {
      _endWorkout();
    }
  }
  
  /// Termine la session
  void _endWorkout() {
    stopTimer();
    onWorkoutComplete?.call();
  }
  
  /// Revient à l'étape précédente
  void previousStep() {
    switch (_currentStep) {
      case StepType.preparation:
        // Déjà au début
        _remainingTime = preset.prepareSeconds;
        break;
        
      case StepType.work:
        if (preset.prepareSeconds > 0) {
          _currentStep = StepType.preparation;
          _remainingTime = preset.prepareSeconds;
          _remainingReps = preset.repetitions;
        } else {
          // Recommencer le travail
          _remainingTime = preset.workSeconds;
        }
        break;
        
      case StepType.rest:
        _currentStep = StepType.work;
        _remainingTime = preset.workSeconds;
        _remainingReps++;
        break;
        
      case StepType.cooldown:
        // Retour à la dernière répétition de travail
        _currentStep = StepType.work;
        _remainingTime = preset.workSeconds;
        _remainingReps = 1;
        break;
    }
    
    notifyListeners();
  }
  
  /// Toggle pause/lecture
  void togglePause() {
    if (_isPaused) {
      startTimer();
    } else {
      stopTimer();
    }
  }
  
  /// Met à jour le volume
  void onVolumeChange(double value) {
    _volume = value.clamp(0.0, 1.0);
    notifyListeners();
    _saveState();
  }
  
  /// Toggle son activé/désactivé
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    notifyListeners();
    _saveState();
  }
  
  /// Gère le tap sur l'écran
  void onScreenTap() {
    _lastTapTime = DateTime.now();
    _controlsVisible = true;
    notifyListeners();
    
    // Masquer les contrôles après 1 seconde
    _controlsHideTimer?.cancel();
    _controlsHideTimer = Timer(const Duration(seconds: 1), hideControlsAfterDelay);
  }
  
  /// Masque les contrôles après le délai
  void hideControlsAfterDelay() {
    if (_lastTapTime != null && 
        DateTime.now().difference(_lastTapTime!).inSeconds >= 1) {
      _controlsVisible = false;
      notifyListeners();
    }
  }
  
  /// Démarre le masquage automatique des contrôles
  void startAutoHideControls() {
    _controlsHideTimer?.cancel();
    _controlsHideTimer = Timer(const Duration(seconds: 1), () {
      _controlsVisible = false;
      notifyListeners();
    });
  }
  
  /// Émet un bip sonore
  void playBeep() {
    if (_soundEnabled && _volume > 0) {
      // Jouer un son système simple
      SystemSound.play(SystemSoundType.click);
    }
  }
  
  /// Quitte la session d'entraînement
  void exitWorkout() {
    stopTimer();
    onWorkoutComplete?.call();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _controlsHideTimer?.cancel();
    super.dispose();
  }
}

