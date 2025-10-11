import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/preset.dart';

/// Gestion de l'état des préréglages sauvegardés
class PresetsState extends ChangeNotifier {
  static const String _presetsKey = 'presets';

  List<Preset> _presets = [];
  bool _isLoading = false;

  List<Preset> get presets => List.unmodifiable(_presets);
  bool get isLoading => _isLoading;

  PresetsState() {
    _loadPresets();
  }

  /// Charge les préréglages depuis SharedPreferences
  Future<void> _loadPresets() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final presetsJson = prefs.getString(_presetsKey);

      if (presetsJson != null) {
        final List<dynamic> decoded = jsonDecode(presetsJson) as List<dynamic>;
        _presets = decoded
            .map((json) => Preset.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading presets: $e');
      _presets = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sauvegarde les préréglages dans SharedPreferences
  Future<void> _savePresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final presetsJson = jsonEncode(_presets.map((p) => p.toJson()).toList());
      await prefs.setString(_presetsKey, presetsJson);
    } catch (e) {
      debugPrint('Error saving presets: $e');
      rethrow;
    }
  }

  /// Ajoute un nouveau préréglage
  Future<void> savePreset(Preset preset) async {
    _presets.add(preset);
    notifyListeners();
    await _savePresets();
  }

  /// Charge un préréglage par son ID
  Preset? loadPreset(String presetId) {
    try {
      return _presets.firstWhere((p) => p.id == presetId);
    } catch (e) {
      debugPrint('Preset not found: $presetId');
      return null;
    }
  }

  /// Supprime un préréglage
  Future<void> deletePreset(String presetId) async {
    _presets.removeWhere((p) => p.id == presetId);
    notifyListeners();
    await _savePresets();
  }

  /// Rafraîchit les préréglages depuis le stockage
  Future<void> refresh() async {
    await _loadPresets();
  }
}

