import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/preset.dart';

/// État de l'écran Home
/// Gère les paramètres d'intervalle et les préréglages
class HomeState extends ChangeNotifier {
  final SharedPreferences _prefs;

  // Constantes de limites
  static const int minReps = 1;
  static const int maxReps = 999;
  static const int minSeconds = 0;
  static const int maxWorkSeconds = 1;
  static const int maxSeconds = 3599;

  // Clés de persistance
  static const String _keyReps = 'home_reps';
  static const String _keyWorkSeconds = 'home_work_seconds';
  static const String _keyRestSeconds = 'home_rest_seconds';
  static const String _keyVolume = 'home_volume';
  static const String _keyPresets = 'home_presets';

  // État privé
  int _reps = 10;
  int _workSeconds = 40;
  int _restSeconds = 20;
  double _volume = 0.62;
  bool _quickStartExpanded = true;
  List<Preset> _presets = [];
  bool _editMode = false;

  // Getters publics
  int get reps => _reps;
  int get workSeconds => _workSeconds;
  int get restSeconds => _restSeconds;
  double get volume => _volume;
  bool get quickStartExpanded => _quickStartExpanded;
  List<Preset> get presets => List.unmodifiable(_presets);
  bool get editMode => _editMode;

  /// Constructeur de production (async, instantie les dépendances)
  static Future<HomeState> create() async {
    final prefs = await SharedPreferences.getInstance();
    return HomeState(prefs);
  }

  /// Constructeur de test (sync, accepte les dépendances)
  HomeState(this._prefs) {
    _loadState();
  }

  /// Charge l'état depuis SharedPreferences
  void _loadState() {
    _reps = _prefs.getInt(_keyReps) ?? 10;
    _workSeconds = _prefs.getInt(_keyWorkSeconds) ?? 40;
    _restSeconds = _prefs.getInt(_keyRestSeconds) ?? 20;
    _volume = _prefs.getDouble(_keyVolume) ?? 0.62;

    // Charger les préréglages depuis JSON
    final presetsJson = _prefs.getString(_keyPresets);
    if (presetsJson != null) {
      try {
        final List<dynamic> presetsList = jsonDecode(presetsJson) as List<dynamic>;
        _presets = presetsList
            .map((json) => Preset.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Error loading presets: $e');
        _presets = [];
      }
    }

    // Valider et clamper les valeurs
    _reps = _reps.clamp(minReps, maxReps);
    _workSeconds = _workSeconds.clamp(maxWorkSeconds, maxSeconds);
    _restSeconds = _restSeconds.clamp(minSeconds, maxSeconds);
    _volume = _volume.clamp(0.0, 1.0);
  }

  /// Sauvegarde l'état dans SharedPreferences
  Future<void> _saveState() async {
    await _prefs.setInt(_keyReps, _reps);
    await _prefs.setInt(_keyWorkSeconds, _workSeconds);
    await _prefs.setInt(_keyRestSeconds, _restSeconds);
    await _prefs.setDouble(_keyVolume, _volume);

    // Sauvegarder les préréglages en JSON
    final presetsJson = jsonEncode(_presets.map((p) => p.toJson()).toList());
    await _prefs.setString(_keyPresets, presetsJson);
  }

  /// Incrémente les répétitions
  void incrementReps() {
    if (_reps < maxReps) {
      _reps++;
      notifyListeners();
      _saveState();
    }
  }

  /// Décrémente les répétitions (minimum 1)
  void decrementReps() {
    if (_reps > minReps) {
      _reps--;
      notifyListeners();
      _saveState();
    }
  }

  /// Incrémente le temps de travail (1 seconde)
  void incrementWork() {
    if (_workSeconds < maxSeconds) {
      _workSeconds++;
      notifyListeners();
      _saveState();
    }
  }

  /// Décrémente le temps de travail (minimum 1 seconde)
  void decrementWork() {
    if (_workSeconds > maxWorkSeconds) {
      _workSeconds--;
      notifyListeners();
      _saveState();
    }
  }

  /// Incrémente le temps de repos (1 seconde)
  void incrementRest() {
    if (_restSeconds < maxSeconds) {
      _restSeconds++;
      notifyListeners();
      _saveState();
    }
  }

  /// Décrémente le temps de repos (minimum 0)
  void decrementRest() {
    if (_restSeconds > minSeconds) {
      _restSeconds--;
      notifyListeners();
      _saveState();
    }
  }

  /// Met à jour le volume
  void onVolumeChange(double value) {
    _volume = value.clamp(0.0, 1.0);
    notifyListeners();
    _saveState();
  }

  /// Toggle l'expansion de la section Quick Start
  void toggleQuickStart() {
    _quickStartExpanded = !_quickStartExpanded;
    notifyListeners();
  }

  /// Sauvegarde un nouveau préréglage
  /// Lance une exception si le nom est vide
  void savePreset(String name) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Preset name cannot be empty');
    }

    final preset = Preset.create(
      name: name.trim(),
      repetitions: _reps,
      workSeconds: _workSeconds,
      restSeconds: _restSeconds,
    );

    _presets.add(preset);
    notifyListeners();
    _saveState();
  }

  /// Supprime un préréglage par son ID
  void deletePreset(String id) {
    _presets.removeWhere((preset) => preset.id == id);
    notifyListeners();
    _saveState();
  }

  /// Toggle le mode édition
  void editPresets() {
    _editMode = !_editMode;
    notifyListeners();
  }

  /// Formate un temps en secondes au format "00 : 44"
  /// Avec espaces autour des deux-points selon spec
  static String formatTime(int seconds) {
    if (seconds >= 3600) {
      // Format hh : mm : ss pour les durées >= 1 heure
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      final secs = seconds % 60;
      return '${hours.toString().padLeft(2, '0')} : '
          '${minutes.toString().padLeft(2, '0')} : '
          '${secs.toString().padLeft(2, '0')}';
    } else {
      // Format mm : ss pour les durées < 1 heure
      final minutes = seconds ~/ 60;
      final secs = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')} : '
          '${secs.toString().padLeft(2, '0')}';
    }
  }

  /// Formate le temps de travail
  String get formattedWorkTime => formatTime(_workSeconds);

  /// Formate le temps de repos
  String get formattedRestTime => formatTime(_restSeconds);
}

