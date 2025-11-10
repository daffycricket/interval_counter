/// Repository abstrait pour la persistance des préférences.
/// Permet de découpler la logique métier de SharedPreferences.
abstract class PreferencesRepository {
  /// Récupère une valeur par clé
  T? get<T>(String key);
  
  /// Sauvegarde une valeur par clé
  Future<void> set<T>(String key, T value);
  
  /// Supprime une clé
  Future<void> remove(String key);
  
  /// Vide toutes les préférences
  Future<void> clear();
}









