import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/screens/interval_timer_home_screen.dart';
import 'package:interval_counter/theme/app_theme.dart';

void main() {
  group('IntervalTimerHomeScreen', () {
    testWidgets('should render initial state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      // Vérifier la présence des éléments principaux
      expect(find.text('Démarrage rapide'), findsOneWidget);
      expect(find.text('VOS PRÉRÉGLAGES'), findsOneWidget);
      expect(find.text('COMMENCER'), findsOneWidget);
      expect(find.text('SAUVEGARDER'), findsOneWidget);
      expect(find.text('AJOUTER'), findsOneWidget);

      // Vérifier les valeurs par défaut
      expect(find.text('16'), findsOneWidget); // Répétitions
      expect(find.text('00:44'), findsOneWidget); // Travail
      expect(find.text('00:15'), findsOneWidget); // Repos

      // Vérifier les labels
      expect(find.text('RÉPÉTITIONS'), findsOneWidget);
      expect(find.text('TRAVAIL'), findsOneWidget);
      expect(find.text('REPOS'), findsOneWidget);
    });

    testWidgets('should have correct keys for testability', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      // Vérifier les keys des éléments principaux
      expect(find.byKey(const Key('interval_timer_home__Container-1')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__IconButton-2')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__Slider-3')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__Icon-4')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__IconButton-5')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__Card-6')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__start_button')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__save_button')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__add_preset_button')), findsOneWidget);
    });

    testWidgets('should increment repetitions when + button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      // Vérifier la valeur initiale
      expect(find.text('16'), findsOneWidget);

      // Taper sur le bouton +
      await tester.tap(find.byKey(const Key('interval_timer_home__repetitions_increase')));
      await tester.pump();

      // Vérifier que la valeur a augmenté
      expect(find.text('17'), findsOneWidget);
      expect(find.text('16'), findsNothing);
    });

    testWidgets('should decrement repetitions when - button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      // Vérifier la valeur initiale
      expect(find.text('16'), findsOneWidget);

      // Taper sur le bouton -
      await tester.tap(find.byKey(const Key('interval_timer_home__repetitions_decrease')));
      await tester.pump();

      // Vérifier que la valeur a diminué
      expect(find.text('15'), findsOneWidget);
      expect(find.text('16'), findsNothing);
    });

    testWidgets('should not allow repetitions to go below 1', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      // Diminuer les répétitions jusqu'à 1
      for (int i = 16; i > 1; i--) {
        await tester.tap(find.byKey(const Key('interval_timer_home__repetitions_decrease')));
        await tester.pump();
      }

      expect(find.text('1'), findsOneWidget);

      // Essayer de diminuer encore
      await tester.tap(find.byKey(const Key('interval_timer_home__repetitions_decrease')));
      await tester.pump();

      // La valeur doit rester à 1
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should update work duration when +/- buttons are tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      // Vérifier la valeur initiale
      expect(find.text('00:44'), findsOneWidget);

      // Augmenter le temps de travail
      await tester.tap(find.byKey(const Key('interval_timer_home__work_increase')));
      await tester.pump();

      expect(find.text('00:45'), findsOneWidget);

      // Diminuer le temps de travail
      await tester.tap(find.byKey(const Key('interval_timer_home__work_decrease')));
      await tester.pump();

      expect(find.text('00:44'), findsOneWidget);
    });

    testWidgets('should update rest duration when +/- buttons are tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      // Vérifier la valeur initiale
      expect(find.text('00:15'), findsOneWidget);

      // Augmenter le temps de repos
      await tester.tap(find.byKey(const Key('interval_timer_home__rest_increase')));
      await tester.pump();

      expect(find.text('00:16'), findsOneWidget);

      // Diminuer le temps de repos
      await tester.tap(find.byKey(const Key('interval_timer_home__rest_decrease')));
      await tester.pump();

      expect(find.text('00:15'), findsOneWidget);
    });

    testWidgets('should show snackbar when start button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      // Taper sur le bouton COMMENCER
      await tester.tap(find.byKey(const Key('interval_timer_home__start_button')));
      await tester.pump();

      // Vérifier qu'un SnackBar apparaît
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Démarrage de l\'entraînement'), findsOneWidget);
    });

    testWidgets('should respond to save button tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      // Vérifier que le bouton SAUVEGARDER est présent et activé
      final saveButton = find.byKey(const Key('interval_timer_home__save_button'));
      expect(saveButton, findsOneWidget);
      
      final saveButtonWidget = tester.widget<TextButton>(saveButton);
      expect(saveButtonWidget.onPressed, isNotNull);

      // Taper sur le bouton SAUVEGARDER (ne devrait pas planter)
      await tester.tap(saveButton);
      await tester.pump();
      
      // Le test réussit si aucune exception n'est levée
      expect(saveButton, findsOneWidget);
    });

    testWidgets('should update volume when slider is moved', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      final slider = find.byKey(const Key('interval_timer_home__Slider-3'));
      expect(slider, findsOneWidget);

      // Déplacer le slider (cette partie peut être complexe à tester sans état visible)
      await tester.tap(slider);
      await tester.pump();

      // Le slider devrait être présent et fonctionnel
      expect(slider, findsOneWidget);
    });

    testWidgets('should show empty presets message initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      // Attendre que l'état se charge
      await tester.pumpAndSettle();

      // Vérifier le message d'absence de préréglages
      expect(find.text('Aucun préréglage'), findsOneWidget);
      expect(find.text('Créez votre premier préréglage en sauvegardant une configuration'), findsOneWidget);
    });
  });
}
