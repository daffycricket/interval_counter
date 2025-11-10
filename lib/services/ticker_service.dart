/// Service abstrait pour les timers périodiques.
/// Permet de découpler la logique métier de Timer.periodic.
abstract class TickerService {
  /// Crée un ticker qui émet un événement à chaque intervalle
  Stream<int> createTicker(Duration interval);
  
  /// Libère les ressources
  void dispose();
}









