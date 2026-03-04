import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/time_formatter.dart';
import '../models/preset.dart';
import '../services/preferences_repository.dart';
import '../services/impl/shared_prefs_repository.dart';

/// State for HomeScreen — thin coordinator per CODE_CONTRACT §5.
/// Delegates persistence to PreferencesRepository, formatting to TimeFormatter.
class HomeState extends ChangeNotifier {
  final PreferencesRepository _repo;

  static const int minReps = 1;
  static const int maxReps = 999;
  static const int minSeconds = 0;
  static const int minWorkSeconds = 1;
  static const int maxSeconds = 3599;

  static const String _keyReps = 'home_reps';
  static const String _keyWorkSeconds = 'home_work_seconds';
  static const String _keyRestSeconds = 'home_rest_seconds';
  static const String _keyVolume = 'home_volume';
  static const String _keyPresets = 'home_presets';

  int _reps = 10;
  int _workSeconds = 40;
  int _restSeconds = 20;
  double _volume = 0.62;
  bool _quickStartExpanded = true;
  List<Preset> _presets = [];
  bool _editMode = false;

  int get reps => _reps;
  int get workSeconds => _workSeconds;
  int get restSeconds => _restSeconds;
  double get volume => _volume;
  bool get quickStartExpanded => _quickStartExpanded;
  List<Preset> get presets => List.unmodifiable(_presets);
  bool get editMode => _editMode;
  String get formattedWorkTime => TimeFormatter.format(_workSeconds);
  String get formattedRestTime => TimeFormatter.format(_restSeconds);

  /// Production factory — wires concrete dependencies.
  static Future<HomeState> create() async {
    final prefs = await SharedPreferences.getInstance();
    return HomeState(SharedPrefsRepository(prefs));
  }

  /// Test constructor — accepts any PreferencesRepository (mock or real).
  HomeState(this._repo) {
    _loadState();
  }

  void _loadState() {
    _reps = (_repo.get<int>(_keyReps) ?? 10).clamp(minReps, maxReps);
    _workSeconds = (_repo.get<int>(_keyWorkSeconds) ?? 40).clamp(minWorkSeconds, maxSeconds);
    _restSeconds = (_repo.get<int>(_keyRestSeconds) ?? 20).clamp(minSeconds, maxSeconds);
    _volume = (_repo.get<double>(_keyVolume) ?? 0.62).clamp(0.0, 1.0);
    final presetsJson = _repo.get<String>(_keyPresets);
    if (presetsJson != null) {
      try {
        final list = jsonDecode(presetsJson) as List<dynamic>;
        _presets = list.map((j) => Preset.fromJson(j as Map<String, dynamic>)).toList();
      } catch (_) {
        _presets = [];
      }
    }
  }

  Future<void> _saveState() async {
    await _repo.set<int>(_keyReps, _reps);
    await _repo.set<int>(_keyWorkSeconds, _workSeconds);
    await _repo.set<int>(_keyRestSeconds, _restSeconds);
    await _repo.set<double>(_keyVolume, _volume);
    await _repo.set<String>(_keyPresets, jsonEncode(_presets.map((p) => p.toJson()).toList()));
  }

  void incrementReps() {
    if (_reps < maxReps) {
      _reps++;
      notifyListeners();
      _saveState();
    }
  }

  void decrementReps() {
    if (_reps > minReps) {
      _reps--;
      notifyListeners();
      _saveState();
    }
  }

  void incrementWork() {
    if (_workSeconds < maxSeconds) {
      _workSeconds++;
      notifyListeners();
      _saveState();
    }
  }

  void decrementWork() {
    if (_workSeconds > minWorkSeconds) {
      _workSeconds--;
      notifyListeners();
      _saveState();
    }
  }

  void incrementRest() {
    if (_restSeconds < maxSeconds) {
      _restSeconds++;
      notifyListeners();
      _saveState();
    }
  }

  void decrementRest() {
    if (_restSeconds > minSeconds) {
      _restSeconds--;
      notifyListeners();
      _saveState();
    }
  }

  void onVolumeChange(double value) {
    _volume = value.clamp(0.0, 1.0);
    notifyListeners();
    _saveState();
  }

  void toggleQuickStart() {
    _quickStartExpanded = !_quickStartExpanded;
    notifyListeners();
  }

  void savePreset(String name) {
    if (name.trim().isEmpty) throw ArgumentError('Preset name cannot be empty');
    _presets.add(Preset.create(
      name: name.trim(),
      prepareSeconds: 0,
      repetitions: _reps,
      workSeconds: _workSeconds,
      restSeconds: _restSeconds,
      cooldownSeconds: 0,
    ));
    notifyListeners();
    _saveState();
  }

  void addPresetDirect(Preset preset) {
    _presets.add(preset);
    notifyListeners();
    _saveState();
  }

  void updatePreset(Preset preset) {
    final index = _presets.indexWhere((p) => p.id == preset.id);
    if (index != -1) {
      _presets[index] = preset;
      notifyListeners();
      _saveState();
    }
  }

  void deletePreset(String id) {
    _presets.removeWhere((preset) => preset.id == id);
    notifyListeners();
    _saveState();
  }

  void editPresets() {
    _editMode = !_editMode;
    notifyListeners();
  }
}
