import 'dart:async';
import 'package:flutter/foundation.dart';
import '../domain/step_type.dart';
import '../domain/workout_engine.dart';
import '../models/preset.dart';
import '../services/audio_service.dart';
import '../services/preferences_repository.dart';
import '../services/ticker_service.dart';

/// État de l'écran Workout
/// Coordinateur mince qui délègue la logique métier au WorkoutEngine
/// et orchestre les services (audio, ticker, persistance)
class WorkoutState extends ChangeNotifier {
  // Services injectés
  final WorkoutEngine _engine;
  final TickerService _tickerService;
  final AudioService _audioService;
  final PreferencesRepository _prefsRepo;
  final VoidCallback? onWorkoutComplete;
  
  // Clés de persistance (partagées avec Home)
  static const String _keyVolume = 'volume_level';
  
  // État privé
  bool _isPaused = false;
  double _volume = 0.62;
  bool _controlsVisible = true;
  bool _isExiting = false;
  double? _previousVolume; // Pour toggleMute
  
  // Timers et streams
  StreamSubscription<int>? _tickerSubscription;
  Timer? _controlsTimer;
  
  // Getters publics (délégués au domain ou état local)
  StepType get currentStep => _engine.currentStep;
  int get remainingTime => _engine.remainingTime;
  int get remainingReps => _engine.remainingReps;
  bool get isPaused => _isPaused;
  double get volume => _volume;
  bool get controlsVisible => _controlsVisible;
  bool get isExiting => _isExiting;
  bool get isFinished => _engine.isFinished;
  
  /// Constructeur (injection de dépendances)
  WorkoutState({
    required Preset preset,
    required TickerService tickerService,
    required AudioService audioService,
    required PreferencesRepository prefsRepo,
    this.onWorkoutComplete,
  })  : _engine = WorkoutEngine(preset: preset),
        _tickerService = tickerService,
        _audioService = audioService,
        _prefsRepo = prefsRepo {
    _loadVolume();
    _startTicker();
    _scheduleControlsHide();
  }
  
  /// Charge le volume depuis la persistance
  void _loadVolume() {
    _volume = _prefsRepo.get<double>(_keyVolume) ?? 0.62;
    _volume = _volume.clamp(0.0, 1.0);
    _audioService.setVolume(_volume);
  }
  
  /// Démarre le ticker (1 tick par seconde)
  void _startTicker() {
    _tickerSubscription?.cancel();
    _tickerSubscription = _tickerService
        .createTicker(const Duration(seconds: 1))
        .listen((_) => tick());
  }
  
  /// Arrête le ticker
  void _stopTicker() {
    _tickerSubscription?.cancel();
  }
  
  /// Fait progresser le temps d'une seconde (appelé par le ticker)
  void tick() {
    if (_isPaused) return;
    
    // Jouer le bip si nécessaire (avant le tick pour jouer à 2, 1, 0)
    if (_engine.shouldPlayBeep && _volume > 0) {
      _audioService.playBeep();
    }
    
    // Déléguer au domain engine
    _engine.tick();
    
    notifyListeners();
  }
  
  /// Passe à l'étape suivante (bouton Suivant)
  void nextStep() {
    _engine.nextStep();
    notifyListeners();
  }
  
  /// Revient à l'étape précédente (bouton Précédent)
  void previousStep() {
    _engine.previousStep();
    notifyListeners();
  }
  
  /// Bascule entre pause et lecture
  void togglePause() {
    _isPaused = !_isPaused;
    
    if (_isPaused) {
      _stopTicker();
    } else {
      _startTicker();
      // Quand on reprend, on lance le timer pour masquer les contrôles
      _scheduleControlsHide();
    }
    
    notifyListeners();
  }
  
  /// Change le volume et persiste
  void onVolumeChange(double value) {
    _volume = value.clamp(0.0, 1.0);
    _audioService.setVolume(_volume);
    _prefsRepo.set<double>(_keyVolume, _volume);
    notifyListeners();
  }
  
  /// Tap sur l'écran : affiche les contrôles et lance le timer de masquage
  void onScreenTap() {
    _controlsVisible = true;
    notifyListeners();
    
    // Ne pas masquer automatiquement si en pause
    if (!_isPaused) {
      _scheduleControlsHide();
    }
  }
  
  /// Long press sur le bouton "Maintenir pour sortir"
  void onLongPress() {
    _isExiting = true;
    notifyListeners();
  }
  
  /// Toggle mute (volume à 0 ou restaure valeur précédente)
  void toggleMute() {
    if (_volume > 0) {
      _previousVolume = _volume;
      onVolumeChange(0.0);
    } else {
      onVolumeChange(_previousVolume ?? 0.62);
    }
  }
  
  /// Programme le masquage automatique des contrôles après 1500ms
  void _scheduleControlsHide() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!_isPaused) {
        _controlsVisible = false;
        notifyListeners();
      }
    });
  }
  
  /// Formate le temps restant au format MM:SS
  String get formattedTime => _engine.formatTime(_engine.remainingTime);
  
  /// Libère les ressources
  @override
  void dispose() {
    _tickerSubscription?.cancel();
    _controlsTimer?.cancel();
    _tickerService.dispose();
    _audioService.dispose();
    super.dispose();
  }
}
