import 'dart:async';
import 'package:flutter/foundation.dart';
import '../domain/step_type.dart';
import '../domain/workout_engine.dart';
import '../models/preset.dart';
import '../services/audio_service.dart';
import '../services/preferences_repository.dart';
import '../services/ticker_service.dart';

/// Thin coordinator for the workout session.
///
/// Delegates business logic to [WorkoutEngine], I/O to service interfaces.
/// ≤5 constructor dependencies, <200 lines.
class WorkoutState extends ChangeNotifier {
  final WorkoutEngine _engine;
  final TickerService _tickerService;
  final AudioService _audioService;
  final PreferencesRepository _prefsRepo;

  static const String _volumeKey = 'home_volume';
  static const Duration _hideDelay = Duration(milliseconds: 1500);

  StreamSubscription<int>? _tickerSubscription;
  Timer? _hideTimer;

  bool _isPaused = false;
  bool _isExiting = false;
  bool _controlsVisible = true;
  double _volume = 0.62;

  /// Production factory — async, instantiates concrete dependencies.
  static Future<WorkoutState> create({required Preset preset}) async {
    throw UnimplementedError('Use DI from screen instead');
  }

  /// Constructor accepting injected dependencies (sync, testable).
  WorkoutState({
    required Preset preset,
    required TickerService tickerService,
    required AudioService audioService,
    required PreferencesRepository prefsRepo,
    VoidCallback? onWorkoutComplete,
  })  : _engine = WorkoutEngine(preset: preset),
        _tickerService = tickerService,
        _audioService = audioService,
        _prefsRepo = prefsRepo {
    _loadVolume();
    _startTicker();
    _startHideTimer();
  }

  /// Test-only constructor with pre-built engine.
  @visibleForTesting
  WorkoutState.withEngine({
    required WorkoutEngine engine,
    required TickerService tickerService,
    required AudioService audioService,
    required PreferencesRepository prefsRepo,
  })  : _engine = engine,
        _tickerService = tickerService,
        _audioService = audioService,
        _prefsRepo = prefsRepo {
    _loadVolume();
  }

  // --- Getters (delegate to engine) ---

  StepType get currentStep => _engine.currentStep;
  int get remainingTime => _engine.remainingTime;
  int get remainingReps => _engine.remainingReps;
  String get formattedTime => _engine.formattedTime;
  bool get isComplete => _engine.isComplete;

  bool get isPaused => _isPaused;
  bool get isExiting => _isExiting;
  bool get controlsVisible => _controlsVisible;
  double get volume => _volume;

  // --- Actions ---

  void togglePause() {
    _isPaused = !_isPaused;
    if (_isPaused) {
      _tickerSubscription?.cancel();
      _tickerSubscription = null;
      _cancelHideTimer();
    } else {
      _startTicker();
      _startHideTimer();
    }
    notifyListeners();
  }

  void nextStep() {
    _engine.moveToNext();
    if (_engine.isComplete) {
      _tickerSubscription?.cancel();
      _tickerSubscription = null;
    }
    notifyListeners();
  }

  void previousStep() {
    _engine.moveToPrevious();
    notifyListeners();
  }

  void onScreenTap() {
    _controlsVisible = true;
    notifyListeners();
    if (!_isPaused) {
      _startHideTimer();
    }
  }

  void onVolumeChange(double value) {
    _volume = value.clamp(0.0, 1.0);
    _audioService.setVolume(_volume);
    _prefsRepo.set<double>(_volumeKey, _volume);
    notifyListeners();
  }

  void onLongPress() {
    _isExiting = true;
    _tickerSubscription?.cancel();
    _tickerSubscription = null;
    notifyListeners();
  }

  // --- Private ---

  void _loadVolume() {
    _volume = _prefsRepo.get<double>(_volumeKey) ?? 0.62;
    _audioService.setVolume(_volume);
  }

  void _startTicker() {
    _tickerSubscription?.cancel();
    _tickerSubscription = _tickerService
        .createTicker(const Duration(seconds: 1))
        .listen((_) => _onTick());
  }

  void _onTick() {
    if (_isPaused || _engine.isComplete) return;

    final shouldBeep = _engine.tick();

    if (shouldBeep && _volume > 0) {
      _audioService.playBeep();
    }

    if (_engine.isComplete) {
      _tickerSubscription?.cancel();
      _tickerSubscription = null;
    }

    notifyListeners();
  }

  void _startHideTimer() {
    _cancelHideTimer();
    _hideTimer = Timer(_hideDelay, () {
      _controlsVisible = false;
      notifyListeners();
    });
  }

  void _cancelHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = null;
  }

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    _cancelHideTimer();
    _tickerService.dispose();
    _audioService.dispose();
    super.dispose();
  }
}
