import 'package:audioplayers/audioplayers.dart';
import '../audio_service.dart';

/// Implémentation du AudioService utilisant audioplayers de Flutter.
class BeepAudioService implements AudioService {
  final AudioPlayer _player = AudioPlayer();
  
  double _volume = 0.9;

  @override
  double get volume => _volume;

  initialize() async {
    await _player.setSourceAsset('sounds/beep500ms.mp3');
    await _player.setReleaseMode(ReleaseMode.stop);
  }

  @override
  void playBeep() async {
    _player.seek(Duration.zero).then((value) => _player.resume());
  }
  
  @override
  void setVolume(double volume) {
    _volume = volume;
    _player.setVolume(_volume);
  }

  @override
  void dispose() {
    _player.dispose();
  }
}








