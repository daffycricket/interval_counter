import 'package:shared_preferences/shared_preferences.dart';
import '../preferences_repository.dart';

/// Implémentation du PreferencesRepository utilisant SharedPreferences.
class SharedPrefsRepository implements PreferencesRepository {
  final SharedPreferences _prefs;
  
  SharedPrefsRepository(this._prefs);
  
  @override
  T? get<T>(String key) {
    final value = _prefs.get(key);
    if (value is T) {
      return value;
    }
    return null;
  }
  
  @override
  Future<void> set<T>(String key, T value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      throw ArgumentError('Type non supporté: ${value.runtimeType}');
    }
  }
  
  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
  
  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}









