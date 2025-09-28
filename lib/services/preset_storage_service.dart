import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/timer_preset.dart';
import '../models/timer_configuration.dart';

/// Service de stockage des préréglages de timer
class PresetStorageService {
  static const String _presetsKey = 'timer_presets';
  static PresetStorageService? _instance;
  
  PresetStorageService._();
  
  /// Instance singleton
  static PresetStorageService get instance {
    _instance ??= PresetStorageService._();
    return _instance!;
  }

  /// Charge tous les préréglages
  Future<List<TimerPreset>> loadPresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final presetsJson = prefs.getStringList(_presetsKey) ?? [];
      
      return presetsJson
          .map((json) => TimerPreset.fromJson(jsonDecode(json)))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Tri par date décroissante
    } catch (e) {
      // En cas d'erreur, retourner une liste vide
      return [];
    }
  }

  /// Sauvegarde tous les préréglages
  Future<bool> savePresets(List<TimerPreset> presets) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final presetsJson = presets
          .map((preset) => jsonEncode(preset.toJson()))
          .toList();
      
      return await prefs.setStringList(_presetsKey, presetsJson);
    } catch (e) {
      return false;
    }
  }

  /// Ajoute un nouveau préréglage
  Future<bool> addPreset(TimerPreset preset) async {
    final presets = await loadPresets();
    presets.add(preset);
    return await savePresets(presets);
  }

  /// Met à jour un préréglage existant
  Future<bool> updatePreset(TimerPreset updatedPreset) async {
    final presets = await loadPresets();
    final index = presets.indexWhere((p) => p.id == updatedPreset.id);
    
    if (index != -1) {
      presets[index] = updatedPreset;
      return await savePresets(presets);
    }
    
    return false;
  }

  /// Supprime un préréglage
  Future<bool> deletePreset(String presetId) async {
    final presets = await loadPresets();
    presets.removeWhere((p) => p.id == presetId);
    return await savePresets(presets);
  }

  /// Crée un préréglage à partir d'une configuration
  TimerPreset createPreset({
    required String name,
    required TimerConfiguration configuration,
  }) {
    return TimerPreset(
      id: _generateId(),
      name: name,
      configuration: configuration,
      createdAt: DateTime.now(),
    );
  }

  /// Génère un ID unique pour un préréglage
  String _generateId() {
    return 'preset_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Efface tous les préréglages (pour les tests ou reset)
  Future<bool> clearAllPresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_presetsKey);
    } catch (e) {
      return false;
    }
  }

  /// Vérifie si un nom de préréglage existe déjà
  Future<bool> presetNameExists(String name, {String? excludeId}) async {
    final presets = await loadPresets();
    return presets.any((p) => 
        p.name.toLowerCase() == name.toLowerCase() && 
        p.id != excludeId
    );
  }

  /// Génère un nom unique pour un préréglage
  Future<String> generateUniqueName(String baseName) async {
    if (!await presetNameExists(baseName)) {
      return baseName;
    }
    
    int counter = 1;
    String uniqueName;
    
    do {
      uniqueName = '$baseName ($counter)';
      counter++;
    } while (await presetNameExists(uniqueName));
    
    return uniqueName;
  }
}
