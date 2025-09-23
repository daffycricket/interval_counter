import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/timer_preset.dart';
import '../models/timer_configuration.dart';

/// Service de stockage des préréglages
/// Simule un stockage local pour la démonstration
class PresetStorageService {
  static final PresetStorageService _instance = PresetStorageService._internal();
  factory PresetStorageService() => _instance;
  PresetStorageService._internal();

  // Stockage en mémoire pour la simulation
  final List<TimerPreset> _presets = [];

  /// Récupère tous les préréglages
  Future<List<TimerPreset>> getPresets() async {
    // Simulation d'un délai réseau/disque
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Retourne une copie pour éviter les modifications externes
    return List.from(_presets);
  }

  /// Sauvegarde un nouveau préréglage
  Future<void> savePreset(TimerPreset preset) async {
    // Simulation d'un délai réseau/disque
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Vérification que l'ID n'existe pas déjà
    final existingIndex = _presets.indexWhere((p) => p.id == preset.id);
    if (existingIndex != -1) {
      throw Exception('Un préréglage avec cet ID existe déjà');
    }
    
    _presets.add(preset);
    _sortPresetsByCreationDate();
    
    if (kDebugMode) {
      print('Préréglage sauvegardé: ${preset.name}');
    }
  }

  /// Met à jour un préréglage existant
  Future<void> updatePreset(TimerPreset preset) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final index = _presets.indexWhere((p) => p.id == preset.id);
    if (index == -1) {
      throw Exception('Préréglage non trouvé');
    }
    
    _presets[index] = preset;
    _sortPresetsByCreationDate();
    
    if (kDebugMode) {
      print('Préréglage mis à jour: ${preset.name}');
    }
  }

  /// Supprime un préréglage
  Future<void> deletePreset(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    
    final index = _presets.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw Exception('Préréglage non trouvé');
    }
    
    final deletedPreset = _presets.removeAt(index);
    
    if (kDebugMode) {
      print('Préréglage supprimé: ${deletedPreset.name}');
    }
  }

  /// Récupère un préréglage par ID
  Future<TimerPreset?> getPresetById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    try {
      return _presets.firstWhere((preset) => preset.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Vérifie si un nom de préréglage existe déjà
  Future<bool> presetNameExists(String name, {String? excludeId}) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    return _presets.any((preset) => 
      preset.name.toLowerCase() == name.toLowerCase() && 
      preset.id != excludeId
    );
  }

  /// Trie les préréglages par date de création (plus récent en premier)
  void _sortPresetsByCreationDate() {
    _presets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Charge des données d'exemple pour la démonstration
  Future<void> loadSampleData() async {
    if (_presets.isNotEmpty) return;

    final samplePreset = TimerPreset(
      id: 'sample-gainage',
      name: 'gainage',
      configuration: TimerConfiguration(
        repetitions: 20,
        workTime: Duration(seconds: 40),
        restTime: Duration(seconds: 3),
      ),
      createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 22)),
    );

    await savePreset(samplePreset);
  }

  /// Export de tous les préréglages au format JSON
  Future<String> exportPresets() async {
    final presets = await getPresets();
    final presetsJson = presets.map((preset) => preset.toJson()).toList();
    return jsonEncode(presetsJson);
  }

  /// Import de préréglages depuis JSON
  Future<void> importPresets(String jsonString) async {
    try {
      final List<dynamic> presetsData = jsonDecode(jsonString);
      final presets = presetsData
          .map((data) => TimerPreset.fromJson(data as Map<String, dynamic>))
          .toList();
      
      for (final preset in presets) {
        // Éviter les doublons en vérifiant l'ID
        if (!_presets.any((p) => p.id == preset.id)) {
          _presets.add(preset);
        }
      }
      
      _sortPresetsByCreationDate();
      
      if (kDebugMode) {
        print('${presets.length} préréglage(s) importé(s)');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'import: $e');
    }
  }

  /// Vide tous les préréglages (pour les tests)
  @visibleForTesting
  Future<void> clearAllPresets() async {
    _presets.clear();
  }
}
