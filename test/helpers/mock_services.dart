// Mock implementations for testing
import 'package:interval_counter/services/ticker_service.dart';
import 'package:interval_counter/services/audio_service.dart';
import 'package:interval_counter/services/preferences_repository.dart';

class MockTickerService implements TickerService {
  bool disposed = false;
  
  @override
  Stream<int> createTicker(Duration interval) {
    return Stream.periodic(interval, (count) => count + 1);
  }
  
  @override
  void dispose() {
    disposed = true;
  }
}

class MockAudioService implements AudioService {
  double _volume = 0.9;
  bool _isEnabled = true;
  int beepCount = 0;
  bool disposed = false;
  
  @override
  void playBeep() {
    beepCount++;
  }
  
  @override
  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
  }
  
  @override
  double get volume => _volume;
  
  @override
  bool get isEnabled => _isEnabled;
  
  @override
  set isEnabled(bool value) {
    _isEnabled = value;
  }
  
  @override
  void dispose() {
    disposed = true;
  }
}

class MockPreferencesRepository implements PreferencesRepository {
  final Map<String, dynamic> _storage = {};
  
  @override
  T? get<T>(String key) {
    final value = _storage[key];
    if (value is T) return value;
    return null;
  }
  
  @override
  Future<void> set<T>(String key, T value) async {
    _storage[key] = value;
  }
  
  @override
  Future<void> remove(String key) async {
    _storage.remove(key);
  }
  
  @override
  Future<void> clear() async {
    _storage.clear();
  }
}









