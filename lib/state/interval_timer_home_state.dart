import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/preset.dart';
import '../services/preset_storage_service.dart';

/// État de l'écran IntervalTimerHome
class IntervalTimerHomeState extends ChangeNotifier {
  final PresetStorageService _storageService = PresetStorageService();

  // Constantes de validation
  static const int minRepetitions = 1;
  static const int maxRepetitions = 99;
  static const int minWorkSeconds = 5;
  static const int maxWorkSeconds = 3600;
  static const int minRestSeconds = 3;
  static const int maxRestSeconds = 3600;
  static const int workTimeStep = 5;
  static const int restTimeStep = 1;

  // État local
  double _volumeLevel = 0.62;
  bool _quickStartExpanded = true;
  int _repetitions = 16;
  int _workSeconds = 44;
  int _restSeconds = 15;
  List<Preset> _presetsList = [];
  bool _editModeActive = false;
  bool _isLoading = false;

  // Getters
  double get volumeLevel => _volumeLevel;
  bool get quickStartExpanded => _quickStartExpanded;
  int get repetitions => _repetitions;
  int get workSeconds => _workSeconds;
  int get restSeconds => _restSeconds;
  List<Preset> get presetsList => _presetsList;
  bool get editModeActive => _editModeActive;
  bool get isLoading => _isLoading;

  // Getters de validation
  bool get canDecrementRepetitions => _repetitions > minRepetitions;
  bool get canIncrementRepetitions => _repetitions < maxRepetitions;
  bool get canDecrementWorkTime => _workSeconds > minWorkSeconds;
  bool get canIncrementWorkTime => _workSeconds < maxWorkSeconds;
  bool get canDecrementRestTime => _restSeconds > minRestSeconds;
  bool get canIncrementRestTime => _restSeconds < maxRestSeconds;

  /// Initialise l'état depuis SharedPreferences
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      
      _volumeLevel = prefs.getDouble('volumeLevel') ?? 0.62;
      _quickStartExpanded = prefs.getBool('quickStartExpanded') ?? true;
      _repetitions = prefs.getInt('repetitions') ?? 16;
      _workSeconds = prefs.getInt('workSeconds') ?? 44;
      _restSeconds = prefs.getInt('restSeconds') ?? 15;
      
      _presetsList = await _storageService.loadPresets();
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Met à jour le niveau de volume
  Future<void> setVolume(double value) async {
    _volumeLevel = value.clamp(0.0, 1.0);
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volumeLevel', _volumeLevel);
  }

  /// Bascule l'expansion de la section Quick Start
  Future<void> toggleQuickStartExpanded() async {
    _quickStartExpanded = !_quickStartExpanded;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('quickStartExpanded', _quickStartExpanded);
  }

  /// Incrémente les répétitions
  Future<void> incrementRepetitions() async {
    if (canIncrementRepetitions) {
      _repetitions++;
      notifyListeners();
      await _persistQuickStartConfig();
    }
  }

  /// Décrémente les répétitions
  Future<void> decrementRepetitions() async {
    if (canDecrementRepetitions) {
      _repetitions--;
      notifyListeners();
      await _persistQuickStartConfig();
    }
  }

  /// Incrémente le temps de travail
  Future<void> incrementWorkTime() async {
    if (canIncrementWorkTime) {
      _workSeconds += workTimeStep;
      if (_workSeconds > maxWorkSeconds) {
        _workSeconds = maxWorkSeconds;
      }
      notifyListeners();
      await _persistQuickStartConfig();
    }
  }

  /// Décrémente le temps de travail
  Future<void> decrementWorkTime() async {
    if (canDecrementWorkTime) {
      _workSeconds -= workTimeStep;
      if (_workSeconds < minWorkSeconds) {
        _workSeconds = minWorkSeconds;
      }
      notifyListeners();
      await _persistQuickStartConfig();
    }
  }

  /// Incrémente le temps de repos
  Future<void> incrementRestTime() async {
    if (canIncrementRestTime) {
      _restSeconds += restTimeStep;
      if (_restSeconds > maxRestSeconds) {
        _restSeconds = maxRestSeconds;
      }
      notifyListeners();
      await _persistQuickStartConfig();
    }
  }

  /// Décrémente le temps de repos
  Future<void> decrementRestTime() async {
    if (canDecrementRestTime) {
      _restSeconds -= restTimeStep;
      if (_restSeconds < minRestSeconds) {
        _restSeconds = minRestSeconds;
      }
      notifyListeners();
      await _persistQuickStartConfig();
    }
  }

  /// Persiste la configuration Quick Start
  Future<void> _persistQuickStartConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('repetitions', _repetitions);
    await prefs.setInt('workSeconds', _workSeconds);
    await prefs.setInt('restSeconds', _restSeconds);
  }

  /// Sauvegarde la configuration Quick Start en tant que préréglage
  Future<Preset> saveQuickStartAsPreset(String name) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Le nom du préréglage ne peut pas être vide');
    }
    if (name.length > 30) {
      throw ArgumentError('Le nom du préréglage ne peut pas dépasser 30 caractères');
    }

    final preset = Preset(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      repetitions: _repetitions,
      workSeconds: _workSeconds,
      restSeconds: _restSeconds,
      createdAt: DateTime.now(),
    );

    await _storageService.addPreset(preset);
    _presetsList = await _storageService.loadPresets();
    notifyListeners();

    return preset;
  }

  /// Charge les préréglages
  Future<void> loadPresets() async {
    _isLoading = true;
    notifyListeners();

    try {
      _presetsList = await _storageService.loadPresets();
    } catch (e) {
      debugPrint('Erreur lors du chargement des préréglages: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Supprime un préréglage
  Future<void> deletePreset(String presetId) async {
    await _storageService.deletePreset(presetId);
    _presetsList = await _storageService.loadPresets();
    notifyListeners();
  }

  /// Bascule le mode édition
  void toggleEditMode() {
    _editModeActive = !_editModeActive;
    notifyListeners();
  }

  /// Valide la configuration actuelle
  bool validateConfig() {
    return _repetitions >= minRepetitions &&
        _repetitions <= maxRepetitions &&
        _workSeconds >= minWorkSeconds &&
        _workSeconds <= maxWorkSeconds &&
        _restSeconds >= minRestSeconds &&
        _restSeconds <= maxRestSeconds;
  }

  /// Charge une configuration depuis un préréglage
  void loadConfigFromPreset(Preset preset) {
    _repetitions = preset.repetitions;
    _workSeconds = preset.workSeconds;
    _restSeconds = preset.restSeconds;
    notifyListeners();
  }
}
