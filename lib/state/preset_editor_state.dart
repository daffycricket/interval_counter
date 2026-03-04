import 'package:flutter/material.dart';
import '../models/preset.dart';
import '../models/advanced_step.dart';
import '../models/workout_group.dart';
import '../domain/time_formatter.dart';
import '../domain/view_mode.dart';
import '../domain/step_mode.dart';
import '../domain/preset_calculator.dart';
import '../domain/advanced_preset_calculator.dart';
import '../theme/app_colors.dart';
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

  // ADVANCED mode fields
  List<WorkoutGroup> _groups = [];
  Color _finishColor = AppColors.finishYellow;
  final int _finishAlarmBeeps = 3;

  String get name => _name;
  int get prepareSeconds => _prepareSeconds;
  int get repetitions => _repetitions;
  int get workSeconds => _workSeconds;
  int get restSeconds => _restSeconds;
  int get cooldownSeconds => _cooldownSeconds;
  ViewMode get viewMode => _viewMode;
  bool get editMode => _editMode;
  String? get presetId => _presetId;

  // ADVANCED getters
  List<WorkoutGroup> get groups => List.unmodifiable(_groups);
  Color get finishColor => _finishColor;
  int get finishAlarmBeeps => _finishAlarmBeeps;

  String get formattedPrepareTime => TimeFormatter.format(_prepareSeconds);
  String get formattedWorkTime => TimeFormatter.format(_workSeconds);
  String get formattedRestTime => TimeFormatter.format(_restSeconds);
  String get formattedCooldownTime => TimeFormatter.format(_cooldownSeconds);

  String get formattedTotal {
    if (_viewMode == ViewMode.advanced) {
      return AdvancedPresetCalculator.formatTotal(_groups);
    }
    return PresetCalculator.formatTotal(
      prepareSeconds: _prepareSeconds,
      repetitions: _repetitions,
      workSeconds: _workSeconds,
      restSeconds: _restSeconds,
      cooldownSeconds: _cooldownSeconds,
    );
  }

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

    // Initialize ADVANCED mode with one default group + one step
    _groups = [
      WorkoutGroup.create(
        repeatCount: 1,
        steps: [
          AdvancedStep.create(name: 'Étape 1', durationSeconds: 5),
        ],
      ),
    ];
  }

  // --- SIMPLE mode methods (existing) ---

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

  // --- ADVANCED mode methods ---

  void addGroup() {
    final newGroup = WorkoutGroup.create(
      repeatCount: 1,
      order: _groups.length,
    );
    _groups = [..._groups, newGroup];
    notifyListeners();
  }

  void removeGroup(int groupIdx) {
    if (_groups.length <= 1 || groupIdx < 0 || groupIdx >= _groups.length) {
      return;
    }
    _groups = [..._groups]..removeAt(groupIdx);
    notifyListeners();
  }

  void incrementGroupReps(int groupIdx) {
    if (groupIdx < 0 || groupIdx >= _groups.length) return;
    final group = _groups[groupIdx];
    if (group.repeatCount >= maxReps) return;
    _groups = [..._groups];
    _groups[groupIdx] = group.copyWith(repeatCount: group.repeatCount + 1);
    notifyListeners();
  }

  void decrementGroupReps(int groupIdx) {
    if (groupIdx < 0 || groupIdx >= _groups.length) return;
    final group = _groups[groupIdx];
    if (group.repeatCount <= minReps) return;
    _groups = [..._groups];
    _groups[groupIdx] = group.copyWith(repeatCount: group.repeatCount - 1);
    notifyListeners();
  }

  void addStep(int groupIdx) {
    if (groupIdx < 0 || groupIdx >= _groups.length) return;
    final group = _groups[groupIdx];
    final stepNumber = group.steps.length + 1;
    final newStep = AdvancedStep.create(
      name: 'Étape $stepNumber',
      durationSeconds: 5,
      order: group.steps.length,
    );
    _groups = [..._groups];
    _groups[groupIdx] = group.copyWith(steps: [...group.steps, newStep]);
    notifyListeners();
  }

  void removeStep(int groupIdx, int stepIdx) {
    if (groupIdx < 0 || groupIdx >= _groups.length) return;
    final group = _groups[groupIdx];
    if (stepIdx < 0 || stepIdx >= group.steps.length) return;
    final newSteps = [...group.steps]..removeAt(stepIdx);
    _groups = [..._groups];
    _groups[groupIdx] = group.copyWith(steps: newSteps);
    notifyListeners();
  }

  void duplicateStep(int groupIdx, int stepIdx) {
    if (groupIdx < 0 || groupIdx >= _groups.length) return;
    final group = _groups[groupIdx];
    if (stepIdx < 0 || stepIdx >= group.steps.length) return;
    final original = group.steps[stepIdx];
    final copy = AdvancedStep.create(
      name: original.name,
      durationSeconds: original.durationSeconds,
      color: original.color,
      mode: original.mode,
      repeatCount: original.repeatCount,
      order: stepIdx + 1,
    );
    final newSteps = [...group.steps]..insert(stepIdx + 1, copy);
    _groups = [..._groups];
    _groups[groupIdx] = group.copyWith(steps: newSteps);
    notifyListeners();
  }

  void reorderStep(int groupIdx, int oldIdx, int newIdx) {
    if (groupIdx < 0 || groupIdx >= _groups.length) return;
    final group = _groups[groupIdx];
    if (oldIdx < 0 || oldIdx >= group.steps.length) return;
    var adjustedNewIdx = newIdx;
    if (adjustedNewIdx > oldIdx) adjustedNewIdx--;
    if (adjustedNewIdx < 0 || adjustedNewIdx >= group.steps.length) return;
    final newSteps = [...group.steps];
    final step = newSteps.removeAt(oldIdx);
    newSteps.insert(adjustedNewIdx, step);
    _groups = [..._groups];
    _groups[groupIdx] = group.copyWith(steps: newSteps);
    notifyListeners();
  }

  void toggleStepMode(int groupIdx, int stepIdx) {
    if (groupIdx < 0 || groupIdx >= _groups.length) return;
    final group = _groups[groupIdx];
    if (stepIdx < 0 || stepIdx >= group.steps.length) return;
    final step = group.steps[stepIdx];
    final newMode = step.mode == StepMode.time ? StepMode.reps : StepMode.time;
    final newSteps = [...group.steps];
    newSteps[stepIdx] = step.copyWith(mode: newMode);
    _groups = [..._groups];
    _groups[groupIdx] = group.copyWith(steps: newSteps);
    notifyListeners();
  }

  void incrementStepValue(int groupIdx, int stepIdx) {
    if (groupIdx < 0 || groupIdx >= _groups.length) return;
    final group = _groups[groupIdx];
    if (stepIdx < 0 || stepIdx >= group.steps.length) return;
    final step = group.steps[stepIdx];
    final newSteps = [...group.steps];
    if (step.mode == StepMode.time) {
      if (step.durationSeconds >= maxSeconds) return;
      newSteps[stepIdx] = step.copyWith(durationSeconds: step.durationSeconds + 1);
    } else {
      if (step.repeatCount >= maxReps) return;
      newSteps[stepIdx] = step.copyWith(repeatCount: step.repeatCount + 1);
    }
    _groups = [..._groups];
    _groups[groupIdx] = group.copyWith(steps: newSteps);
    notifyListeners();
  }

  void decrementStepValue(int groupIdx, int stepIdx) {
    if (groupIdx < 0 || groupIdx >= _groups.length) return;
    final group = _groups[groupIdx];
    if (stepIdx < 0 || stepIdx >= group.steps.length) return;
    final step = group.steps[stepIdx];
    final newSteps = [...group.steps];
    if (step.mode == StepMode.time) {
      if (step.durationSeconds <= minSeconds) return;
      newSteps[stepIdx] = step.copyWith(durationSeconds: step.durationSeconds - 1);
    } else {
      if (step.repeatCount <= minReps) return;
      newSteps[stepIdx] = step.copyWith(repeatCount: step.repeatCount - 1);
    }
    _groups = [..._groups];
    _groups[groupIdx] = group.copyWith(steps: newSteps);
    notifyListeners();
  }

  void incrementStepDuration(int groupIdx, int stepIdx) {
    if (groupIdx < 0 || groupIdx >= _groups.length) return;
    final group = _groups[groupIdx];
    if (stepIdx < 0 || stepIdx >= group.steps.length) return;
    final step = group.steps[stepIdx];
    if (step.durationSeconds >= maxSeconds) return;
    final newSteps = [...group.steps];
    newSteps[stepIdx] = step.copyWith(durationSeconds: step.durationSeconds + 1);
    _groups = [..._groups];
    _groups[groupIdx] = group.copyWith(steps: newSteps);
    notifyListeners();
  }

  void decrementStepDuration(int groupIdx, int stepIdx) {
    if (groupIdx < 0 || groupIdx >= _groups.length) return;
    final group = _groups[groupIdx];
    if (stepIdx < 0 || stepIdx >= group.steps.length) return;
    final step = group.steps[stepIdx];
    if (step.durationSeconds <= minSeconds) return;
    final newSteps = [...group.steps];
    newSteps[stepIdx] = step.copyWith(durationSeconds: step.durationSeconds - 1);
    _groups = [..._groups];
    _groups[groupIdx] = group.copyWith(steps: newSteps);
    notifyListeners();
  }

  void setStepColor(int groupIdx, int stepIdx, Color color) {
    if (groupIdx < 0 || groupIdx >= _groups.length) return;
    final group = _groups[groupIdx];
    if (stepIdx < 0 || stepIdx >= group.steps.length) return;
    final newSteps = [...group.steps];
    newSteps[stepIdx] = group.steps[stepIdx].copyWith(color: color);
    _groups = [..._groups];
    _groups[groupIdx] = group.copyWith(steps: newSteps);
    notifyListeners();
  }

  void setFinishColor(Color color) {
    _finishColor = color;
    notifyListeners();
  }

  /// Formatted group subtotal (e.g. "00:35").
  String formattedGroupSubtotal(int groupIdx) {
    if (groupIdx < 0 || groupIdx >= _groups.length) return '00:00';
    return AdvancedPresetCalculator.formatGroupSubtotal(_groups[groupIdx]);
  }

  // --- Shared methods ---

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
