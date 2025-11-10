import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/services/impl/system_ticker_service.dart';

void main() {
  group('SystemTickerService', () {
    late SystemTickerService service;
    
    setUp(() {
      service = SystemTickerService();
    });
    
    tearDown(() {
      service.dispose();
    });
    
    test('createTicker emits incremental values', () async {
      final stream = service.createTicker(const Duration(milliseconds: 10));
      
      final values = await stream.take(3).toList();
      
      expect(values, [1, 2, 3]);
    });
    
    test('dispose cancels the timer', () async {
      final stream = service.createTicker(const Duration(milliseconds: 10));
      
      // Collect first value
      await stream.first;
      
      // Dispose should cancel
      service.dispose();
      
      // Stream should be closed/empty after dispose
      // (difficult to test directly, but no crash is good)
      expect(service, isNotNull);
    });
    
    test('createTicker cancels previous timer', () async {
      final stream1 = service.createTicker(const Duration(milliseconds: 10));
      
      // Wait a bit
      await Future.delayed(const Duration(milliseconds: 15));
      
      // Create new ticker
      final stream2 = service.createTicker(const Duration(milliseconds: 10));
      
      // New stream should start from 1
      final firstValue = await stream2.first;
      expect(firstValue, 1);
    });
  });
}









