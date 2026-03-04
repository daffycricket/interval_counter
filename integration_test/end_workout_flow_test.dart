import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_counter/main.dart';
import 'package:interval_counter/state/home_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late HomeState homeState;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    homeState = await HomeState.create();
  });

  group('End Workout Screen', () {
    /// Helper: lance l'app et navigue jusqu'à l'écran de fin de workout
    /// en forçant la complétion du workout via les boutons "next".
    Future<void> navigateToEndWorkout(WidgetTester tester) async {
      await tester.pumpWidget(IntervalCounterApp(homeState: homeState));
      await tester.pumpAndSettle();

      // Démarrer un workout depuis la home
      await tester.tap(find.byKey(const Key('home__Button-23')));
      await tester.pumpAndSettle();

      // Afficher les contrôles
      await tester.tap(find.byKey(const Key('workout__container-1')));
      await tester.pumpAndSettle();

      // Avancer jusqu'à la fin via "next" (répéter jusqu'à ce que le workout se termine)
      // Le preset par défaut a prepareSeconds=10, repetitions=3, workSeconds=30, restSeconds=15
      // On skip toutes les étapes via next jusqu'à isComplete
      for (int i = 0; i < 20; i++) {
        final nextBtn = find.byKey(const Key('workout__iconbutton-3'));
        if (nextBtn.evaluate().isEmpty) break;
        await tester.tap(nextBtn);
        await tester.pump(const Duration(milliseconds: 100));

        // Vérifier si l'écran end_workout est affiché
        if (find.byKey(const Key('end_workout__text-2')).evaluate().isNotEmpty) {
          break;
        }

        // Ré-afficher les contrôles si masqués
        final containerKey = find.byKey(const Key('workout__container-1'));
        if (containerKey.evaluate().isNotEmpty) {
          await tester.tap(containerKey);
          await tester.pump(const Duration(milliseconds: 100));
        }
      }

      await tester.pumpAndSettle();
    }

    testWidgets('end_workout screen displays FINI title after workout completes',
        (tester) async {
      await navigateToEndWorkout(tester);

      expect(find.byKey(const Key('end_workout__text-2')), findsOneWidget);
    });

    testWidgets('end_workout screen displays stop and restart buttons',
        (tester) async {
      await navigateToEndWorkout(tester);

      expect(find.byKey(const Key('end_workout__iconbutton-4')), findsOneWidget);
      expect(find.byKey(const Key('end_workout__iconbutton-6')), findsOneWidget);
    });

    testWidgets('tap stop returns to home screen', (tester) async {
      await navigateToEndWorkout(tester);

      // Tap bouton Stop
      await tester.tap(find.byKey(const Key('end_workout__iconbutton-4')));
      await tester.pumpAndSettle();

      // Doit être revenu sur la home
      expect(find.byKey(const Key('home__Button-23')), findsOneWidget);
    });

    testWidgets('tap restart launches a new workout', (tester) async {
      await navigateToEndWorkout(tester);

      // Tap bouton Restart
      await tester.tap(find.byKey(const Key('end_workout__iconbutton-6')));
      await tester.pumpAndSettle();

      // Un nouveau workout est lancé : l'écran workout s'affiche
      expect(find.byKey(const Key('workout__text-2')), findsOneWidget);
    });
  });
}
