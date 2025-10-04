import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/preset.dart';

/// Service de stockage des préréglages
class PresetStorageService {
  static const String _presetsKey = 'interval_timer_presets';

  /// Charge tous les préréglages
  Future<List<Preset>> loadPresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? presetsJson = prefs.getString(_presetsKey);
      
      if (presetsJson == null || presetsJson.isEmpty) {
        return [];
      }

      final List<dynamic> presetsList = jsonDecode(presetsJson) as List<dynamic>;
      return presetsList
          .map((json) => Preset.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // En cas d'erreur, retourner une liste vide plutôt que de crasher
      return [];
    }
  }

  /// Sauvegarde tous les préréglages
  Future<void> savePresets(List<Preset> presets) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String presetsJson = jsonEncode(
        presets.map((preset) => preset.toJson()).toList(),
      );
      await prefs.setString(_presetsKey, presetsJson);
    } catch (e) {
      // En cas d'erreur, propager l'exception
      rethrow;
    }
  }

  /// Ajoute un préréglage
  Future<void> addPreset(Preset preset) async {
    final presets = await loadPresets();
    presets.add(preset);
    await savePresets(presets);
  }

  /// Supprime un préréglage par ID
  Future<void> deletePreset(String presetId) async {
    final presets = await loadPresets();
    presets.removeWhere((preset) => preset.id == presetId);
    await savePresets(presets);
  }

  /// Met à jour un préréglage
  Future<void> updatePreset(Preset updatedPreset) async {
    final presets = await loadPresets();
    final index = presets.indexWhere((p) => p.id == updatedPreset.id);
    if (index != -1) {
      presets[index] = updatedPreset;
      await savePresets(presets);
    }
  }
}
