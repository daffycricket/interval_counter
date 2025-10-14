import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preset model for saved interval configurations
class Preset {
  final String id;
  final String name;
  final int reps;
  final int workSeconds;
  final int restSeconds;

  const Preset({
    required this.id,
    required this.name,
    required this.reps,
    required this.workSeconds,
    required this.restSeconds,
  });

  factory Preset.fromJson(Map<String, dynamic> json) {
    return Preset(
      id: json['id'] as String,
      name: json['name'] as String,
      reps: json['reps'] as int,
      workSeconds: json['workSeconds'] as int,
      restSeconds: json['restSeconds'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'reps': reps,
      'workSeconds': workSeconds,
      'restSeconds': restSeconds,
    };
  }

  Preset copyWith({
    String? id,
    String? name,
    int? reps,
    int? workSeconds,
    int? restSeconds,
  }) {
    return Preset(
      id: id ?? this.id,
      name: name ?? this.name,
      reps: reps ?? this.reps,
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Preset &&
        other.id == id &&
        other.name == name &&
        other.reps == reps &&
        other.workSeconds == workSeconds &&
        other.restSeconds == restSeconds;
  }

  @override
  int get hashCode => Object.hash(id, name, reps, workSeconds, restSeconds);

  @override
  String toString() => 'Preset(id: $id, name: $name, reps: $reps, '
      'workSeconds: $workSeconds, restSeconds: $restSeconds)';
}

/// State management for IntervalTimerHome screen.
/// Follows Provider + ChangeNotifier pattern with dependency injection.
class IntervalTimerHomeState extends ChangeNotifier {
  final SharedPreferences _prefs;

  // Private state fields
  int _reps = 16;
  int _workSeconds = 44;
  int _restSeconds = 15;
  double _volume = 0.62;
  bool _volumePanelVisible = false;
  bool _quickStartExpanded = true;
  bool _presetsEditMode = false;
  List<Preset> _presets = [];

  // Constants for validation
  static const int minReps = 1;
  static const int maxReps = 99;
  static const int minWorkSeconds = 5;
  static const int maxWorkSeconds = 3600;
  static const int minRestSeconds = 0;
  static const int maxRestSeconds = 3600;
  static const double minVolume = 0.0;
  static const double maxVolume = 1.0;
  static const int timeIncrement = 5;

  // Persistence keys
  static const String _keyReps = 'quick_start_reps';
  static const String _keyWorkSeconds = 'quick_start_work_seconds';
  static const String _keyRestSeconds = 'quick_start_rest_seconds';
  static const String _keyVolume = 'volume';
  static const String _keyQuickStartExpanded = 'quick_start_expanded';
  static const String _keyPresets = 'presets';

  // Public getters
  int get reps => _reps;
  int get workSeconds => _workSeconds;
  int get restSeconds => _restSeconds;
  double get volume => _volume;
  bool get volumePanelVisible => _volumePanelVisible;
  bool get quickStartExpanded => _quickStartExpanded;
  bool get presetsEditMode => _presetsEditMode;
  List<Preset> get presets => List.unmodifiable(_presets);

  /// Production constructor - creates instance with real SharedPreferences
  static Future<IntervalTimerHomeState> create() async {
    final prefs = await SharedPreferences.getInstance();
    return IntervalTimerHomeState(prefs);
  }

  /// Test constructor - accepts mock SharedPreferences for testing
  IntervalTimerHomeState(this._prefs) {
    _loadState();
  }

  /// Load persisted state from SharedPreferences
  void _loadState() {
    _reps = _prefs.getInt(_keyReps) ?? 16;
    _workSeconds = _prefs.getInt(_keyWorkSeconds) ?? 44;
    _restSeconds = _prefs.getInt(_keyRestSeconds) ?? 15;
    _volume = _prefs.getDouble(_keyVolume) ?? 0.62;
    _quickStartExpanded = _prefs.getBool(_keyQuickStartExpanded) ?? true;

    // Validate and clamp loaded values
    _reps = _reps.clamp(minReps, maxReps);
    _workSeconds = _workSeconds.clamp(minWorkSeconds, maxWorkSeconds);
    _restSeconds = _restSeconds.clamp(minRestSeconds, maxRestSeconds);
    _volume = _volume.clamp(minVolume, maxVolume);

    // Load presets
    final presetsJson = _prefs.getString(_keyPresets);
    if (presetsJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(presetsJson);
        _presets = decoded
            .map((item) => Preset.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Error loading presets: $e');
        _presets = [];
      }
    }
  }

  /// Persist quick start configuration
  Future<void> _saveQuickStart() async {
    await Future.wait([
      _prefs.setInt(_keyReps, _reps),
      _prefs.setInt(_keyWorkSeconds, _workSeconds),
      _prefs.setInt(_keyRestSeconds, _restSeconds),
    ]);
  }

  /// Persist presets list
  Future<void> _savePresets() async {
    final encoded = jsonEncode(_presets.map((p) => p.toJson()).toList());
    await _prefs.setString(_keyPresets, encoded);
  }

  // Action methods per plan.md § 7.2

  /// Increment repetitions (max 99)
  void incrementReps() {
    if (_reps < maxReps) {
      _reps++;
      notifyListeners();
      _saveQuickStart();
    }
  }

  /// Decrement repetitions (min 1)
  void decrementReps() {
    if (_reps > minReps) {
      _reps--;
      notifyListeners();
      _saveQuickStart();
    }
  }

  /// Increment work time by 5 seconds (max 3600)
  void incrementWorkTime() {
    if (_workSeconds < maxWorkSeconds) {
      _workSeconds = (_workSeconds + timeIncrement).clamp(minWorkSeconds, maxWorkSeconds);
      notifyListeners();
      _saveQuickStart();
    }
  }

  /// Decrement work time by 5 seconds (min 5)
  void decrementWorkTime() {
    if (_workSeconds > minWorkSeconds) {
      _workSeconds = (_workSeconds - timeIncrement).clamp(minWorkSeconds, maxWorkSeconds);
      notifyListeners();
      _saveQuickStart();
    }
  }

  /// Increment rest time by 5 seconds (max 3600)
  void incrementRestTime() {
    if (_restSeconds < maxRestSeconds) {
      _restSeconds = (_restSeconds + timeIncrement).clamp(minRestSeconds, maxRestSeconds);
      notifyListeners();
      _saveQuickStart();
    }
  }

  /// Decrement rest time by 5 seconds (min 0)
  void decrementRestTime() {
    if (_restSeconds > minRestSeconds) {
      _restSeconds = (_restSeconds - timeIncrement).clamp(minRestSeconds, maxRestSeconds);
      notifyListeners();
      _saveQuickStart();
    }
  }

  /// Update volume (0.0 - 1.0)
  void onVolumeChange(double value) {
    _volume = value.clamp(minVolume, maxVolume);
    notifyListeners();
    _prefs.setDouble(_keyVolume, _volume);
  }

  /// Toggle quick start section expanded/collapsed
  void toggleQuickStartSection() {
    _quickStartExpanded = !_quickStartExpanded;
    notifyListeners();
    _prefs.setBool(_keyQuickStartExpanded, _quickStartExpanded);
  }

  /// Toggle volume panel visibility
  void toggleVolumePanel() {
    _volumePanelVisible = !_volumePanelVisible;
    notifyListeners();
  }

  /// Save current configuration as a preset
  Future<void> saveCurrentAsPreset(String name) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Preset name cannot be empty');
    }

    final preset = Preset(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      reps: _reps,
      workSeconds: _workSeconds,
      restSeconds: _restSeconds,
    );

    _presets.add(preset);
    notifyListeners();
    await _savePresets();
  }

  /// Load preset configuration into quick start
  void loadPreset(String presetId) {
    final preset = _presets.firstWhere(
      (p) => p.id == presetId,
      orElse: () => throw ArgumentError('Preset not found: $presetId'),
    );

    _reps = preset.reps;
    _workSeconds = preset.workSeconds;
    _restSeconds = preset.restSeconds;
    notifyListeners();
    _saveQuickStart();
  }

  /// Navigate to timer running screen (handled by screen widget)
  void startInterval() {
    // Navigation is handled by the screen widget
    // State just ensures values are valid
    notifyListeners();
  }

  /// Navigate to preset editor (handled by screen widget)
  void createNewPreset() {
    // Navigation is handled by the screen widget
    notifyListeners();
  }

  /// Enter presets edit mode
  void enterEditMode() {
    _presetsEditMode = true;
    notifyListeners();
  }

  /// Exit presets edit mode
  void exitEditMode() {
    _presetsEditMode = false;
    notifyListeners();
  }

  /// Delete a preset
  Future<void> deletePreset(String presetId) async {
    _presets.removeWhere((p) => p.id == presetId);
    notifyListeners();
    await _savePresets();
  }
}
