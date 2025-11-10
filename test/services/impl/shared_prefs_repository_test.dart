import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_counter/services/impl/shared_prefs_repository.dart';

void main() {
  group('SharedPrefsRepository', () {
    late SharedPrefsRepository repo;
    
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      repo = SharedPrefsRepository(prefs);
    });
    
    test('set and get String', () async {
      await repo.set('key', 'value');
      expect(repo.get<String>('key'), 'value');
    });
    
    test('set and get int', () async {
      await repo.set('key', 42);
      expect(repo.get<int>('key'), 42);
    });
    
    test('set and get double', () async {
      await repo.set('key', 3.14);
      expect(repo.get<double>('key'), 3.14);
    });
    
    test('set and get bool', () async {
      await repo.set('key', true);
      expect(repo.get<bool>('key'), true);
    });
    
    test('get returns null for non-existent key', () {
      expect(repo.get<String>('nonexistent'), null);
    });
    
    test('remove deletes key', () async {
      await repo.set('key', 'value');
      await repo.remove('key');
      expect(repo.get<String>('key'), null);
    });
    
    test('clear removes all keys', () async {
      await repo.set('key1', 'value1');
      await repo.set('key2', 'value2');
      await repo.clear();
      
      expect(repo.get<String>('key1'), null);
      expect(repo.get<String>('key2'), null);
    });
  });
}









