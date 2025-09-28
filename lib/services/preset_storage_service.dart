import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/timer_preset.dart';

class PresetStorageService {
  static const String _presetsKey = 'timer_presets';

  Future<List<TimerPreset>> loadPresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final presetsJson = prefs.getString(_presetsKey);
      
      if (presetsJson == null) {
        return [];
      }

      final List<dynamic> presetsList = json.decode(presetsJson);
      return presetsList
          .map((json) => TimerPreset.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // En cas d'erreur, retourner une liste vide
      return [];
    }
  }

  Future<void> savePresets(List<TimerPreset> presets) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final presetsJson = json.encode(
        presets.map((preset) => preset.toJson()).toList(),
      );
      await prefs.setString(_presetsKey, presetsJson);
    } catch (e) {
      // Gérer l'erreur de sauvegarde
      rethrow;
    }
  }

  Future<void> addPreset(TimerPreset preset) async {
    final presets = await loadPresets();
    presets.add(preset);
    // Trier par date de création (plus récent en premier)
    presets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    await savePresets(presets);
  }

  Future<void> removePreset(String presetId) async {
    final presets = await loadPresets();
    presets.removeWhere((preset) => preset.id == presetId);
    await savePresets(presets);
  }

  Future<void> updatePreset(TimerPreset updatedPreset) async {
    final presets = await loadPresets();
    final index = presets.indexWhere((preset) => preset.id == updatedPreset.id);
    
    if (index != -1) {
      presets[index] = updatedPreset;
      await savePresets(presets);
    }
  }

  Future<void> clearAllPresets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_presetsKey);
  }
}
