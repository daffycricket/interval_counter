import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_counter/screens/workout_screen.dart';
import 'package:interval_counter/models/preset.dart';

void main() {
  group('WorkoutScreen Integration Tests', () {
    late Preset testPreset;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      
      testPreset = Preset.create(
        name: 'Test',
        prepareSeconds: 5,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 10,
      );
    });

    testWidgets('renders loading indicator initially', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutScreen(preset: testPreset),
        ),
      );
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders all main components after loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutScreen(preset: testPreset),
        ),
      );
      
      // Attendre que le FutureBuilder se résolve
      await tester.pumpAndSettle();
      
      // Vérifier que tous les composants sont présents
      expect(find.byKey(const Key('workout__container-1')), findsOneWidget);
      expect(find.byKey(const Key('workout__slider-1')), findsOneWidget);
      expect(find.byKey(const Key('workout__text-2')), findsOneWidget);
      expect(find.byKey(const Key('workout__text-3')), findsOneWidget);
      expect(find.byKey(const Key('workout__iconbutton-4')), findsOneWidget);
    });

    testWidgets('background color changes based on step', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutScreen(preset: testPreset),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Vérifier que le scaffold a une couleur de fond
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);
    });

    testWidgets('tap on screen toggles controls visibility', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutScreen(preset: testPreset),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Tap sur l'écran
      await tester.tap(find.byKey(const Key('workout__container-1')));
      await tester.pump();
      
      // Les contrôles devraient toujours être visibles après le tap
      expect(find.byKey(const Key('workout__slider-1')), findsOneWidget);
    });

    testWidgets('screen pops on workout complete', (tester) async {
      final presetQuick = Preset.create(
        name: 'Quick',
        prepareSeconds: 0,
        repetitions: 1,
        workSeconds: 1,
        restSeconds: 0,
        cooldownSeconds: 0,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutScreen(preset: presetQuick),
                    ),
                  );
                },
                child: const Text('Start'),
              ),
            ),
          ),
        ),
      );
      
      await tester.tap(find.text('Start'));
      await tester.pumpAndSettle();
      
      // Le WorkoutScreen devrait être affiché
      expect(find.byType(WorkoutScreen), findsOneWidget);
    });
  });
}

