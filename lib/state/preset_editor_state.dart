import 'package:flutter/foundation.dart';
import '../models/preset.dart';
import 'home_state.dart';

/// État de l'écran PresetEditor
/// Gère l'édition et la création de préréglages
class PresetEditorState extends ChangeNotifier {
  final HomeState _homeState;

  // Constantes de limites
  static const int minReps = 1;
  static const int maxReps = 999;
  static const int minSeconds = 0;
  static const int maxSeconds = 3599;

  // État privé
  String _name = '';
  int _prepareSeconds = 5;
  int _repetitions = 10;
  int _workSeconds = 40;
  int _restSeconds = 20;
  int _cooldownSeconds = 30;
  String _viewMode = 'simple'; // simple|advanced
  bool _editMode = false; // false = création, true = modification
  String? _presetId; // ID du préréglage en cours d'édition

  // Getters publics
  String get name => _name;
  int get prepareSeconds => _prepareSeconds;
  int get repetitions => _repetitions;
  int get workSeconds => _workSeconds;
  int get restSeconds => _restSeconds;
  int get cooldownSeconds => _cooldownSeconds;
  String get viewMode => _viewMode;
  bool get editMode => _editMode;
  String? get presetId => _presetId;

  /// Formate un temps en secondes au format "mm : ss" avec espaces
  String formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')} : ${secs.toString().padLeft(2, '0')}';
  }

  /// Formate le temps de préparation
  String get formattedPrepareTime => formatTime(_prepareSeconds);

  /// Formate le temps de travail
  String get formattedWorkTime => formatTime(_workSeconds);

  /// Formate le temps de repos
  String get formattedRestTime => formatTime(_restSeconds);

  /// Formate le temps de refroidissement
  String get formattedCooldownTime => formatTime(_cooldownSeconds);

  /// Calcule et formate le temps total
  String get formattedTotal {
    final total = _prepareSeconds + (_repetitions * (_workSeconds + _restSeconds)) + _cooldownSeconds;
    final mins = total ~/ 60;
    final secs = total % 60;
    return 'TOTAL ${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// Constructeur de test (sync, accepte les dépendances)
  PresetEditorState(this._homeState, {
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
      // Mode édition : charger les valeurs du préréglage existant
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
      // Mode création : utiliser les valeurs initiales ou par défaut
      _name = initialName ?? '';
      _prepareSeconds = initialPrepareSeconds ?? 5;
      _repetitions = initialRepetitions ?? 10;
      _workSeconds = initialWorkSeconds ?? 40;
      _restSeconds = initialRestSeconds ?? 20;
      _cooldownSeconds = initialCooldownSeconds ?? 30;
      _editMode = false;
      _presetId = null;
    }

    // Valider et clamper les valeurs
    _prepareSeconds = _prepareSeconds.clamp(minSeconds, maxSeconds);
    _repetitions = _repetitions.clamp(minReps, maxReps);
    _workSeconds = _workSeconds.clamp(minSeconds, maxSeconds);
    _restSeconds = _restSeconds.clamp(minSeconds, maxSeconds);
    _cooldownSeconds = _cooldownSeconds.clamp(minSeconds, maxSeconds);
  }

  /// Incrémente le temps de préparation
  void incrementPrepare() {
    if (_prepareSeconds < maxSeconds) {
      _prepareSeconds++;
      notifyListeners();
    }
  }

  /// Décrémente le temps de préparation
  void decrementPrepare() {
    if (_prepareSeconds > minSeconds) {
      _prepareSeconds--;
      notifyListeners();
    }
  }

  /// Incrémente les répétitions
  void incrementReps() {
    if (_repetitions < maxReps) {
      _repetitions++;
      notifyListeners();
    }
  }

  /// Décrémente les répétitions
  void decrementReps() {
    if (_repetitions > minReps) {
      _repetitions--;
      notifyListeners();
    }
  }

  /// Incrémente le temps de travail
  void incrementWork() {
    if (_workSeconds < maxSeconds) {
      _workSeconds++;
      notifyListeners();
    }
  }

  /// Décrémente le temps de travail
  void decrementWork() {
    if (_workSeconds > minSeconds) {
      _workSeconds--;
      notifyListeners();
    }
  }

  /// Incrémente le temps de repos
  void incrementRest() {
    if (_restSeconds < maxSeconds) {
      _restSeconds++;
      notifyListeners();
    }
  }

  /// Décrémente le temps de repos
  void decrementRest() {
    if (_restSeconds > minSeconds) {
      _restSeconds--;
      notifyListeners();
    }
  }

  /// Incrémente le temps de refroidissement
  void incrementCooldown() {
    if (_cooldownSeconds < maxSeconds) {
      _cooldownSeconds++;
      notifyListeners();
    }
  }

  /// Décrémente le temps de refroidissement
  void decrementCooldown() {
    if (_cooldownSeconds > minSeconds) {
      _cooldownSeconds--;
      notifyListeners();
    }
  }

  /// Met à jour le nom du préréglage
  void onNameChange(String value) {
    _name = value;
    notifyListeners();
  }

  /// Bascule vers le mode SIMPLE
  void switchToSimple() {
    _viewMode = 'simple';
    notifyListeners();
  }

  /// Bascule vers le mode ADVANCED
  void switchToAdvanced() {
    _viewMode = 'advanced';
    notifyListeners();
  }

  /// Sauvegarde le préréglage et retourne true si succès
  /// Lance une exception si le nom est vide
  bool save() {
    if (_name.trim().isEmpty) {
      throw Exception('Veuillez saisir un nom');
    }

    if (_editMode && _presetId != null) {
      // Mode édition : mettre à jour le préréglage existant
      final index = _homeState.presets.indexWhere((p) => p.id == _presetId);
      if (index != -1) {
        final updatedPreset = _homeState.presets[index].copyWith(
          name: _name.trim(),
          prepareSeconds: _prepareSeconds,
          repetitions: _repetitions,
          workSeconds: _workSeconds,
          restSeconds: _restSeconds,
          cooldownSeconds: _cooldownSeconds,
        );
        _homeState.updatePreset(updatedPreset);
      }
    } else {
      // Mode création : créer un nouveau préréglage
      final preset = Preset.create(
        name: _name.trim(),
        prepareSeconds: _prepareSeconds,
        repetitions: _repetitions,
        workSeconds: _workSeconds,
        restSeconds: _restSeconds,
        cooldownSeconds: _cooldownSeconds,
      );
      _homeState.addPresetDirect(preset);
    }

    return true;
  }

  /// Ferme l'écran sans sauvegarder
  void close() {
    // Aucune action nécessaire, la navigation gérera la fermeture
  }
}

