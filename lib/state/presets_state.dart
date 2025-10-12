import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/preset.dart';

/// État des préréglages
class PresetsState extends ChangeNotifier {
  static const String _presetsKey = 'presets';

  List<Preset> _presets = [];
  bool _presetsEditMode = false;

  List<Preset> get presets => List.unmodifiable(_presets);
  bool get presetsEditMode => _presetsEditMode;

  PresetsState() {
    _loadPresets();
  }

  /// Charge les préréglages depuis SharedPreferences
  Future<void> _loadPresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final presetsJson = prefs.getString(_presetsKey);
      
      if (presetsJson != null) {
        final List<dynamic> decoded = jsonDecode(presetsJson);
        _presets = decoded.map((json) => Preset.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading presets: $e');
      _presets = [];
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
    }
  }

  /// Ajoute un préréglage
  Future<void> addPreset(Preset preset) async {
    _presets.add(preset);
    notifyListeners();
    await _savePresets();
  }

  /// Supprime un préréglage
  Future<void> deletePreset(String presetId) async {
    _presets.removeWhere((p) => p.id == presetId);
    notifyListeners();
    await _savePresets();
  }

  /// Active le mode édition
  void enterEditMode() {
    _presetsEditMode = true;
    notifyListeners();
  }

  /// Désactive le mode édition
  void exitEditMode() {
    _presetsEditMode = false;
    notifyListeners();
  }

  /// Recharge les préréglages (utile après modification externe)
  Future<void> reloadPresets() async {
    await _loadPresets();
  }
}

