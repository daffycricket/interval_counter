import 'package:flutter/services.dart';
import '../audio_service.dart';

/// Implémentation du AudioService utilisant SystemSound de Flutter.
class SystemAudioService implements AudioService {
  double _volume = 0.9;
  bool _isEnabled = true;
  
  @override
  void playBeep() {
    if (_isEnabled && _volume > 0) {
      // SystemSound ne supporte pas le contrôle du volume directement
      // On utilise _volume et _isEnabled comme garde-fou logique
      SystemSound.play(SystemSoundType.click);
    }
  }
  
  @override
  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
  }
  
  @override
  double get volume => _volume;
  
  @override
  void dispose() {
  }
}









