import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/preset.dart';

/// État de l'écran d'accueil Interval Timer
/// Gère la configuration rapide et les préréglages sauvegardés
class IntervalTimerHomeState extends ChangeNotifier {
  final SharedPreferences _prefs;
  
  // Constantes de limites
  static const int _minReps = 1;
  static const int _maxReps = 99;
  static const int _minWorkSeconds = 5;
  static const int _maxWorkSeconds = 3600;
  static const int _minRestSeconds = 0;
  static const int _maxRestSeconds = 3600;
  static const int _timeIncrement = 5;
  
  // Clés de persistence
  static const String _keyReps = 'quick_start_reps';
  static const String _keyWorkSeconds = 'quick_start_work_seconds';
  static const String _keyRestSeconds = 'quick_start_rest_seconds';
  static const String _keyVolume = 'volume';
  static const String _keyQuickStartExpanded = 'quick_start_expanded';
  static const String _keyPresets = 'presets';
  
  // Champs d'état
  int _reps;
  int _workSeconds;
  int _restSeconds;
  double _volume;
  bool _volumePanelVisible;
  bool _quickStartExpanded;
  bool _presetsEditMode;
  List<Preset> _presets;
  
  IntervalTimerHomeState._(
    this._prefs,
    this._reps,
    this._workSeconds,
    this._restSeconds,
    this._volume,
    this._volumePanelVisible,
    this._quickStartExpanded,
    this._presetsEditMode,
    this._presets,
  );
  
  /// Factory avec chargement asynchrone depuis SharedPreferences
  static Future<IntervalTimerHomeState> create() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Charger les valeurs avec defaults
    final reps = prefs.getInt(_keyReps) ?? 16;
    final workSeconds = prefs.getInt(_keyWorkSeconds) ?? 44;
    final restSeconds = prefs.getInt(_keyRestSeconds) ?? 15;
    final volume = prefs.getDouble(_keyVolume) ?? 0.62;
    final quickStartExpanded = prefs.getBool(_keyQuickStartExpanded) ?? true;
    
    // Charger les préréglages
    final presetsJson = prefs.getString(_keyPresets);
    List<Preset> presets = [];
    if (presetsJson != null && presetsJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(presetsJson);
        presets = decoded.map((json) => Preset.fromJson(json)).toList();
      } catch (e) {
        debugPrint('Erreur lors du chargement des préréglages: $e');
      }
    }
    
    return IntervalTimerHomeState._(
      prefs,
      reps.clamp(_minReps, _maxReps),
      workSeconds.clamp(_minWorkSeconds, _maxWorkSeconds),
      restSeconds.clamp(_minRestSeconds, _maxRestSeconds),
      volume.clamp(0.0, 1.0),
      false, // volumePanelVisible
      quickStartExpanded,
      false, // presetsEditMode
      presets,
    );
  }
  
  // Getters read-only
  int get reps => _reps;
  int get minReps => _minReps;
  int get maxReps => _maxReps;
  int get workSeconds => _workSeconds;
  int get restSeconds => _restSeconds;
  double get volume => _volume;
  bool get volumePanelVisible => _volumePanelVisible;
  bool get quickStartExpanded => _quickStartExpanded;
  bool get presetsEditMode => _presetsEditMode;
  List<Preset> get presets => List.unmodifiable(_presets);
  
  /// Formatage du temps en MM : SS (avec espaces, selon design)
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${secs.toString().padLeft(2, '0')}';
  }
  
  // Actions de modification des répétitions
  
  void incrementReps() {
    if (_reps < _maxReps) {
      _reps++;
      _persistReps();
      notifyListeners();
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
  }
  
  void decrementReps() {
    if (_reps > _minReps) {
      _reps--;
      _persistReps();
      notifyListeners();
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
  }
  
  // Actions de modification du temps de travail
  
  void incrementWorkTime() {
    if (_workSeconds < _maxWorkSeconds) {
      _workSeconds = (_workSeconds + _timeIncrement).clamp(_minWorkSeconds, _maxWorkSeconds);
      _persistWorkSeconds();
      notifyListeners();
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
  }
  
  void decrementWorkTime() {
    if (_workSeconds > _minWorkSeconds) {
      _workSeconds = (_workSeconds - _timeIncrement).clamp(_minWorkSeconds, _maxWorkSeconds);
      _persistWorkSeconds();
      notifyListeners();
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
  }
  
  // Actions de modification du temps de repos
  
  void incrementRestTime() {
    if (_restSeconds < _maxRestSeconds) {
      _restSeconds = (_restSeconds + _timeIncrement).clamp(_minRestSeconds, _maxRestSeconds);
      _persistRestSeconds();
      notifyListeners();
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
  }
  
  void decrementRestTime() {
    if (_restSeconds > _minRestSeconds) {
      _restSeconds = (_restSeconds - _timeIncrement).clamp(_minRestSeconds, _maxRestSeconds);
      _persistRestSeconds();
      notifyListeners();
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
  }
  
  // Action de modification du volume
  
  void onVolumeChange(double value) {
    _volume = value.clamp(0.0, 1.0);
    _persistVolume();
    notifyListeners();
  }
  
  // Toggle de la section Démarrage rapide
  
  void toggleQuickStartSection() {
    _quickStartExpanded = !_quickStartExpanded;
    _persistQuickStartExpanded();
    notifyListeners();
  }
  
  // Gestion des préréglages
  
  Future<void> saveCurrentAsPreset(String name) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Le nom du préréglage ne peut pas être vide');
    }
    
    final preset = Preset(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      reps: _reps,
      workSeconds: _workSeconds,
      restSeconds: _restSeconds,
    );
    
    _presets.add(preset);
    await _persistPresets();
    notifyListeners();
    HapticFeedback.lightImpact();
  }
  
  void loadPreset(String presetId) {
    final preset = _presets.firstWhere(
      (p) => p.id == presetId,
      orElse: () => throw ArgumentError('Préréglage non trouvé: $presetId'),
    );
    
    _reps = preset.reps;
    _workSeconds = preset.workSeconds;
    _restSeconds = preset.restSeconds;
    
    _persistReps();
    _persistWorkSeconds();
    _persistRestSeconds();
    
    notifyListeners();
    HapticFeedback.lightImpact();
  }
  
  Future<void> deletePreset(String presetId) async {
    _presets.removeWhere((p) => p.id == presetId);
    await _persistPresets();
    notifyListeners();
    HapticFeedback.lightImpact();
  }
  
  // Mode édition des préréglages
  
  void enterEditMode() {
    _presetsEditMode = true;
    notifyListeners();
  }
  
  void exitEditMode() {
    _presetsEditMode = false;
    notifyListeners();
  }
  
  // Navigation (gérée par le widget, pas par le state)
  // startInterval() et createNewPreset() sont des callbacks du widget
  
  // Méthodes de persistence privées
  
  void _persistReps() {
    _prefs.setInt(_keyReps, _reps);
  }
  
  void _persistWorkSeconds() {
    _prefs.setInt(_keyWorkSeconds, _workSeconds);
  }
  
  void _persistRestSeconds() {
    _prefs.setInt(_keyRestSeconds, _restSeconds);
  }
  
  void _persistVolume() {
    _prefs.setDouble(_keyVolume, _volume);
  }
  
  void _persistQuickStartExpanded() {
    _prefs.setBool(_keyQuickStartExpanded, _quickStartExpanded);
  }
  
  Future<void> _persistPresets() async {
    final List<Map<String, dynamic>> jsonList = _presets.map((p) => p.toJson()).toList();
    final String encoded = jsonEncode(jsonList);
    await _prefs.setString(_keyPresets, encoded);
  }
}

