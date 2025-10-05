import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/preset.dart';

/// État de gestion des préréglages
class PresetsState extends ChangeNotifier {
  static const String _keyPresets = 'presets_list';

  List<Preset> _presets = [];

  List<Preset> get presets => List.unmodifiable(_presets);

  /// Constructeur : charge les préréglages depuis SharedPreferences
  PresetsState() {
    _loadPresets();
  }

  /// Charge les préréglages depuis SharedPreferences
  Future<void> _loadPresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final presetsJson = prefs.getString(_keyPresets);
      
      if (presetsJson != null) {
        final List<dynamic> decoded = jsonDecode(presetsJson);
        _presets = decoded
            .map((json) => Preset.fromJson(json as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement des préréglages: $e');
    }
  }

  /// Sauvegarde les préréglages dans SharedPreferences
  Future<void> _savePresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final presetsJson = jsonEncode(_presets.map((p) => p.toJson()).toList());
      await prefs.setString(_keyPresets, presetsJson);
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde des préréglages: $e');
      rethrow;
    }
  }

  /// Crée un nouveau préréglage
  Future<void> createPreset({
    required String name,
    required int repetitions,
    required int workSeconds,
    required int restSeconds,
  }) async {
    final now = DateTime.now();
    final preset = Preset(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      repetitions: repetitions,
      workSeconds: workSeconds,
      restSeconds: restSeconds,
      createdAt: now,
      modifiedAt: now,
    );

    _presets.add(preset);
    notifyListeners();
    await _savePresets();
  }

  /// Met à jour un préréglage existant
  Future<void> updatePreset(Preset updatedPreset) async {
    final index = _presets.indexWhere((p) => p.id == updatedPreset.id);
    if (index != -1) {
      _presets[index] = updatedPreset.copyWith(modifiedAt: DateTime.now());
      notifyListeners();
      await _savePresets();
    }
  }

  /// Supprime un préréglage
  Future<void> deletePreset(String presetId) async {
    _presets.removeWhere((p) => p.id == presetId);
    notifyListeners();
    await _savePresets();
  }

  /// Recherche un préréglage par ID
  Preset? getPresetById(String id) {
    try {
      return _presets.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Recharge les préréglages depuis le stockage
  Future<void> reload() async {
    await _loadPresets();
  }
}
