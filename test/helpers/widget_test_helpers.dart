import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/state/interval_timer_home_state.dart';
import 'package:interval_counter/models/preset.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Helpers pour les tests de widgets

/// Crée un état mockéavec des valeurs par défaut
Future<IntervalTimerHomeState> createMockState({
  int reps = 16,
  int workSeconds = 44,
  int restSeconds = 15,
  double volume = 0.62,
  bool quickStartExpanded = true,
  List<Preset> presets = const [],
}) async {
  // Initialiser SharedPreferences avec des valeurs mockées
  SharedPreferences.setMockInitialValues({
    'quick_start_reps': reps,
    'quick_start_work_seconds': workSeconds,
    'quick_start_rest_seconds': restSeconds,
    'volume': volume,
    'quick_start_expanded': quickStartExpanded,
    'presets': presets.isEmpty ? '[]' : '[${presets.map((p) => '{"id":"${p.id}","name":"${p.name}","reps":${p.reps},"workSeconds":${p.workSeconds},"restSeconds":${p.restSeconds}}').join(',')}]',
  });
  
  return await IntervalTimerHomeState.create();
}

/// Enveloppe un widget dans MaterialApp + Provider pour les tests
Widget createTestApp(IntervalTimerHomeState state, Widget child) {
  return ChangeNotifierProvider.value(
    value: state,
    child: MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

/// Enveloppe un widget dans MaterialApp + MultiProvider pour les tests
Widget createTestAppWithProviders(List<ChangeNotifier> providers, Widget child) {
  return MultiProvider(
    providers: providers.map((p) => ChangeNotifierProvider.value(value: p)).toList(),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

/// Attend que toutes les animations soient terminées
Future<void> pumpAndSettle(WidgetTester tester, [Duration duration = const Duration(milliseconds: 100)]) async {
  await tester.pumpAndSettle(duration);
}

/// Crée un preset de test
Preset createTestPreset({
  String id = '1',
  String name = 'Test Preset',
  int reps = 20,
  int workSeconds = 40,
  int restSeconds = 3,
}) {
  return Preset(
    id: id,
    name: name,
    reps: reps,
    workSeconds: workSeconds,
    restSeconds: restSeconds,
  );
}

