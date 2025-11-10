import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/services/impl/system_audio_service.dart';

void main() {
  group('SystemAudioService', () {
    late SystemAudioService service;
    
    setUp(() {
      service = SystemAudioService();
    });
    
    test('initial volume is 0.9', () {
      expect(service.volume, 0.9);
    });
    
    test('initial isEnabled is true', () {
      expect(service.isEnabled, true);
    });
    
    test('setVolume updates volume', () {
      service.setVolume(0.5);
      expect(service.volume, 0.5);
    });
    
    test('setVolume clamps to [0.0, 1.0]', () {
      service.setVolume(-0.5);
      expect(service.volume, 0.0);
      
      service.setVolume(1.5);
      expect(service.volume, 1.0);
    });
    
    test('isEnabled can be toggled', () {
      service.isEnabled = false;
      expect(service.isEnabled, false);
      
      service.isEnabled = true;
      expect(service.isEnabled, true);
    });
    
    test('playBeep does not throw when enabled', () {
      service.isEnabled = true;
      service.setVolume(0.5);
      
      expect(() => service.playBeep(), returnsNormally);
    });
    
    test('playBeep does not throw when disabled', () {
      service.isEnabled = false;
      
      expect(() => service.playBeep(), returnsNormally);
    });
    
    test('playBeep does not throw when volume = 0', () {
      service.setVolume(0.0);
      
      expect(() => service.playBeep(), returnsNormally);
    });
  });
}









