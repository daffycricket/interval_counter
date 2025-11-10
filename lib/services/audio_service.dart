/// Service abstrait pour les sons et audio.
/// Permet de découpler la logique métier de SystemSound et autres APIs audio.
abstract class AudioService {
  /// Joue un bip sonore
  void playBeep();

  double get volume;
  
  /// Définit le volume [0.0, 1.0]
  void setVolume(double volume);

  void dispose();
}









