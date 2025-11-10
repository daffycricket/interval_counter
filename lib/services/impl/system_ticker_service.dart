import 'dart:async';
import '../ticker_service.dart';

/// Implémentation du TickerService utilisant Timer.periodic de Dart.
class SystemTickerService implements TickerService {
  Timer? _timer;
  StreamController<int>? _controller;
  int _tickCount = 0;
  
  @override
  Stream<int> createTicker(Duration interval) {
    // Annuler le timer précédent si existant
    dispose();
    
    _tickCount = 0;
    _controller = StreamController<int>.broadcast();
    
    _timer = Timer.periodic(interval, (timer) {
      _tickCount++;
      _controller?.add(_tickCount);
    });
    
    return _controller!.stream;
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _controller?.close();
    _controller = null;
  }
}









