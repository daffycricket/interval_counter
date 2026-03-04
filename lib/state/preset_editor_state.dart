import 'package:flutter/foundation.dart';
import '../models/preset.dart';
import '../domain/time_formatter.dart';
import '../domain/view_mode.dart';
import '../domain/preset_calculator.dart';
import 'home_state.dart';

/// State for PresetEditorScreen — thin coordinator per CODE_CONTRACT §5.
/// Delegates formatting to TimeFormatter, total calculation to PresetCalculator.
class PresetEditorState extends ChangeNotifier {
  final HomeState _homeState;

  static const int minReps = 1;
  static const int maxReps = 999;
  static const int minSeconds = 0;
  static const int maxSeconds = 3599;

  String _name = '';
  int _prepareSeconds = 5;
  int _repetitions = 10;
  int _workSeconds = 40;
  int _restSeconds = 20;
  int _cooldownSeconds = 30;
  ViewMode _viewMode = ViewMode.simple;
  bool _editMode = false;
  String? _presetId;

  String get name => _name;
  int get prepareSeconds => _prepareSeconds;
  int get repetitions => _repetitions;
  int get workSeconds => _workSeconds;
  int get restSeconds => _restSeconds;
  int get cooldownSeconds => _cooldownSeconds;
  ViewMode get viewMode => _viewMode;
  bool get editMode => _editMode;
  String? get presetId => _presetId;

  String get formattedPrepareTime => TimeFormatter.format(_prepareSeconds);
  String get formattedWorkTime => TimeFormatter.format(_workSeconds);
  String get formattedRestTime => TimeFormatter.format(_restSeconds);
  String get formattedCooldownTime => TimeFormatter.format(_cooldownSeconds);

  String get formattedTotal => PresetCalculator.formatTotal(
        prepareSeconds: _prepareSeconds,
        repetitions: _repetitions,
        workSeconds: _workSeconds,
        restSeconds: _restSeconds,
        cooldownSeconds: _cooldownSeconds,
      );

  /// Accepts any HomeState (mock or real) — use directly in tests and production.
  PresetEditorState(
    this._homeState, {
    String? initialName,
    int? initialPrepareSeconds,
    int? initialRepetitions,
    int? initialWorkSeconds,
    int? initialRestSeconds,
    int? initialCooldownSeconds,
    bool? isEditMode,
    String? presetId,
  }) {
    if (isEditMode == true && presetId != null) {
      _editMode = true;
      _presetId = presetId;
      final preset = _homeState.presets.firstWhere(
        (p) => p.id == presetId,
        orElse: () => Preset.create(
          name: '',
          prepareSeconds: 5,
          repetitions: 10,
          workSeconds: 40,
          restSeconds: 20,
          cooldownSeconds: 30,
        ),
      );
      _name = preset.name;
      _prepareSeconds = preset.prepareSeconds;
      _repetitions = preset.repetitions;
      _workSeconds = preset.workSeconds;
      _restSeconds = preset.restSeconds;
      _cooldownSeconds = preset.cooldownSeconds;
    } else {
      _name = initialName ?? '';
      _prepareSeconds = initialPrepareSeconds ?? 5;
      _repetitions = initialRepetitions ?? 10;
      _workSeconds = initialWorkSeconds ?? 40;
      _restSeconds = initialRestSeconds ?? 20;
      _cooldownSeconds = initialCooldownSeconds ?? 30;
    }
    _prepareSeconds = _prepareSeconds.clamp(minSeconds, maxSeconds);
    _repetitions = _repetitions.clamp(minReps, maxReps);
    _workSeconds = _workSeconds.clamp(minSeconds, maxSeconds);
    _restSeconds = _restSeconds.clamp(minSeconds, maxSeconds);
    _cooldownSeconds = _cooldownSeconds.clamp(minSeconds, maxSeconds);
  }

  void incrementPrepare() {
    if (_prepareSeconds < maxSeconds) { _prepareSeconds++; notifyListeners(); }
  }

  void decrementPrepare() {
    if (_prepareSeconds > minSeconds) { _prepareSeconds--; notifyListeners(); }
  }

  void incrementReps() {
    if (_repetitions < maxReps) { _repetitions++; notifyListeners(); }
  }

  void decrementReps() {
    if (_repetitions > minReps) { _repetitions--; notifyListeners(); }
  }

  void incrementWork() {
    if (_workSeconds < maxSeconds) { _workSeconds++; notifyListeners(); }
  }

  void decrementWork() {
    if (_workSeconds > minSeconds) { _workSeconds--; notifyListeners(); }
  }

  void incrementRest() {
    if (_restSeconds < maxSeconds) { _restSeconds++; notifyListeners(); }
  }

  void decrementRest() {
    if (_restSeconds > minSeconds) { _restSeconds--; notifyListeners(); }
  }

  void incrementCooldown() {
    if (_cooldownSeconds < maxSeconds) { _cooldownSeconds++; notifyListeners(); }
  }

  void decrementCooldown() {
    if (_cooldownSeconds > minSeconds) { _cooldownSeconds--; notifyListeners(); }
  }

  void onNameChange(String value) {
    _name = value;
    notifyListeners();
  }

  void switchToSimple() {
    _viewMode = ViewMode.simple;
    notifyListeners();
  }

  void switchToAdvanced() {
    _viewMode = ViewMode.advanced;
    notifyListeners();
  }

  bool save() {
    if (_name.trim().isEmpty) throw Exception('Veuillez saisir un nom');
    if (_editMode && _presetId != null) {
      final index = _homeState.presets.indexWhere((p) => p.id == _presetId);
      if (index != -1) {
        _homeState.updatePreset(_homeState.presets[index].copyWith(
          name: _name.trim(),
          prepareSeconds: _prepareSeconds,
          repetitions: _repetitions,
          workSeconds: _workSeconds,
          restSeconds: _restSeconds,
          cooldownSeconds: _cooldownSeconds,
        ));
      }
    } else {
      _homeState.addPresetDirect(Preset.create(
        name: _name.trim(),
        prepareSeconds: _prepareSeconds,
        repetitions: _repetitions,
        workSeconds: _workSeconds,
        restSeconds: _restSeconds,
        cooldownSeconds: _cooldownSeconds,
      ));
    }
    return true;
  }

  void close() {}
}
