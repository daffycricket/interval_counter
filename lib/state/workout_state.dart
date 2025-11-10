import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/preset.dart';
import '../domain/workout_engine.dart';
import '../services/ticker_service.dart';
import '../services/audio_service.dart';
import '../services/preferences_repository.dart';

// Exporter StepType pour rétro-compatibilité
export '../domain/workout_engine.dart' show StepType;

/// État de l'écran Workout - Thin Coordinator.
/// Orchestrer le domain logic (WorkoutEngine) et les services externes.
/// Conforme à ARCHITECTURE_CONTRACT.md.
class WorkoutState extends ChangeNotifier {
  // Dependencies injectées (interfaces)
  final TickerService _tickerService;
  final AudioService _audioService;
  final PreferencesRepository _prefsRepo;
  
  // Clés de persistance
  static const String _keyVolume = 'workout_volume';
  static const String _keySoundEnabled = 'workout_sound_enabled';
  
  // Domain engine
  WorkoutEngine _engine;
  
  // État UI local
  bool _controlsVisible = true;
  Timer? _controlsHideTimer;
  bool _isExiting = false;
  
  // Subscription au ticker
  StreamSubscription<int>? _tickerSubscription;
  
  // Callback pour navigation
  final VoidCallback? onWorkoutComplete;
  
  // --- Getters publics (délégués à l'engine ou local) ---
  
  StepType get currentStep => _engine.currentStep;
  int get remainingTime => _engine.remainingTime;
  int get remainingReps => _engine.remainingReps;
  bool get isPaused => _engine.isPaused;
  double get volume => _audioService.volume;
  //bool get soundEnabled => _audioService.isEnabled;
  bool get controlsVisible => _controlsVisible;
  bool get isExiting => _isExiting;
  
  /// Formatte le temps restant en MM:SS
  String get formattedTime {
    final minutes = _engine.remainingTime ~/ 60;
    final seconds = _engine.remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  /// Indique si le compteur de répétitions doit être affiché
  bool get shouldShowRepsCounter => _engine.shouldShowRepsCounter;
  
  // --- Constructeur ---
  
  /// Constructeur avec injection de dépendances (testable).
  WorkoutState({
    required Preset preset,
    required TickerService tickerService,
    required AudioService audioService,
    required PreferencesRepository prefsRepo,
    this.onWorkoutComplete,
  })  : _tickerService = tickerService,
        _audioService = audioService,
        _prefsRepo = prefsRepo,
        _engine = WorkoutEngine.fromPreset(preset) {
    _loadState();
    _startTicker();
    _scheduleControlsAutoHide();
  }
  
  // --- Méthodes privées ---
  
  /// Charge l'état persisté
  void _loadState() {
    //final volume = _prefsRepo.get<double>(_keyVolume) ?? 0.9;
    //final soundEnabled = _prefsRepo.get<bool>(_keySoundEnabled) ?? true;
    
    //_audioService.setVolume(volume);
    //_audioService.isEnabled = soundEnabled;
  }
  
  /// Démarre le ticker
  void _startTicker() {
    _tickerSubscription?.cancel();
    
    final stream = _tickerService.createTicker(const Duration(seconds: 1));
    _tickerSubscription = stream.listen((_) => tick());
  }
  
  /// Arrête le ticker
  void _stopTicker() {
    _tickerSubscription?.cancel();
    _tickerSubscription = null;
  }
  
  /// Schedule le masquage automatique des contrôles après 1500ms
  void _scheduleControlsAutoHide() {
    _controlsHideTimer?.cancel();
    _controlsHideTimer = Timer(const Duration(milliseconds: 1500), () {
      _controlsVisible = false;
      notifyListeners();
    });
  }
  
  // --- Actions publiques ---
  
  /// Tick du timer : délègue au domain engine
  void tick() {
    // Jouer un bip si nécessaire (avant le tick)
    if (_engine.shouldPlayBeep) {
      _audioService.playBeep();
    }
    
    // Déléguer le tick au domain engine
    _engine = _engine.tick();
    
    // Vérifier si la session est terminée
    if (_engine.isComplete) {
      _endWorkout();
      return;
    }
    
    notifyListeners();
  }
  
  /// Toggle pause/lecture
  void togglePause() {
    _engine = _engine.togglePause();
    
    if (_engine.isPaused) {
      _stopTicker();
    } else {
      _startTicker();
    }
    
    notifyListeners();
  }
  
  /// Passe à l'étape suivante
  void nextStep() {
    _engine = _engine.nextStep();
    
    // Vérifier si la session est terminée
    if (_engine.isComplete) {
      _endWorkout();
      return;
    }
    
    notifyListeners();
  }
  
  /// Revient à l'étape précédente
  void previousStep() {
    _engine = _engine.previousStep();
    notifyListeners();
  }
  
  /// Met à jour le volume
  void onVolumeChange(double value) {
    _audioService.setVolume(value);
    notifyListeners();
    _prefsRepo.set(_keyVolume, 0.9);
  }
  
  /// Toggle son activé/désactivé
  void toggleSound() {
    //_audioService.isEnabled = !_audioService.isEnabled;
    //notifyListeners();
    //_prefsRepo.set(_keySoundEnabled, _audioService.isEnabled);
  }
  
  /// Gère le tap sur l'écran
  void onScreenTap() {
    _controlsVisible = true;
    notifyListeners();
    
    // Re-scheduler le masquage automatique
    _scheduleControlsAutoHide();
  }
  
  /// Quitte la session d'entraînement
  void exitWorkout() {
    print('🔴 exitWorkout() called - _isExiting = true');  // 🆕 Debug
    _isExiting = true;
    _stopTicker();
    notifyListeners();
    onWorkoutComplete?.call();
  }
  
  /// Termine la session
  void _endWorkout() {
    _stopTicker();
    onWorkoutComplete?.call();
  }
  
  @override
  void dispose() {
    _stopTicker();
    _controlsHideTimer?.cancel();
    _tickerService.dispose();
    _audioService.dispose();
    super.dispose();
  }
}
