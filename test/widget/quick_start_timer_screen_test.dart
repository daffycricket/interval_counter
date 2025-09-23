import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/screens/quick_start_timer_screen.dart';
import 'package:interval_counter/theme/app_theme.dart';

void main() {
  group('QuickStartTimerScreen Widget Tests', () {
    testWidgets('should display all main components', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const QuickStartTimerScreen(),
        ),
      );

      // Vérifier que l'écran se charge
      expect(find.byKey(const Key('quick_start_timer__screen')), findsOneWidget);

      // Vérifier le header
      expect(find.byKey(const Key('quick_start_timer__header')), findsOneWidget);
      expect(find.byKey(const Key('quick_start_timer__volume-btn')), findsOneWidget);
      expect(find.byKey(const Key('quick_start_timer__volume-slider')), findsOneWidget);
      expect(find.byKey(const Key('quick_start_timer__menu-btn')), findsOneWidget);

      // Vérifier la carte principale
      expect(find.byKey(const Key('quick_start_timer__main-card')), findsOneWidget);
      expect(find.byKey(const Key('quick_start_timer__title')), findsOneWidget);
      expect(find.text('Démarrage rapide'), findsOneWidget);

      // Vérifier les contrôles
      expect(find.text('RÉPÉTITIONS'), findsOneWidget);
      expect(find.text('TRAVAIL'), findsOneWidget);
      expect(find.text('REPOS'), findsOneWidget);

      // Vérifier les boutons
      expect(find.byKey(const Key('quick_start_timer__save-btn')), findsOneWidget);
      expect(find.byKey(const Key('quick_start_timer__start-btn')), findsOneWidget);
      expect(find.text('SAUVEGARDER'), findsOneWidget);
      expect(find.text('COMMENCER'), findsOneWidget);

      // Vérifier la section préréglages
      expect(find.text('VOS PRÉRÉGLAGES'), findsOneWidget);
      expect(find.byKey(const Key('quick_start_timer__add-preset-btn')), findsOneWidget);
    });

    testWidgets('should display default values correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const QuickStartTimerScreen(),
        ),
      );

      // Attendre que le widget se charge complètement
      await tester.pumpAndSettle();

      // Vérifier les valeurs par défaut
      expect(find.text('16'), findsOneWidget); // Répétitions
      expect(find.text('00 : 44'), findsOneWidget); // Temps de travail
      expect(find.text('00 : 15'), findsOneWidget); // Temps de repos
    });

    testWidgets('should increment repetitions when plus button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const QuickStartTimerScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Trouver et taper le bouton plus des répétitions
      final plusButton = find.byKey(const Key('répétitions_plus_btn'));
      expect(plusButton, findsOneWidget);

      await tester.tap(plusButton);
      await tester.pump();

      // Vérifier que la valeur a augmenté
      expect(find.text('17'), findsOneWidget);
    });

    testWidgets('should decrement repetitions when minus button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const QuickStartTimerScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Trouver et taper le bouton moins des répétitions
      final minusButton = find.byKey(const Key('répétitions_minus_btn'));
      expect(minusButton, findsOneWidget);

      await tester.tap(minusButton);
      await tester.pump();

      // Vérifier que la valeur a diminué
      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('should not allow repetitions to go below 1', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const QuickStartTimerScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final minusButton = find.byKey(const Key('répétitions_minus_btn'));

      // Diminuer jusqu'à 1
      for (int i = 16; i > 1; i--) {
        await tester.tap(minusButton);
        await tester.pump();
      }

      expect(find.text('1'), findsOneWidget);

      // Essayer de diminuer encore
      await tester.tap(minusButton);
      await tester.pump();

      // Devrait rester à 1
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should increment work time when plus button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const QuickStartTimerScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final plusButton = find.byKey(const Key('travail_plus_btn'));
      expect(plusButton, findsOneWidget);

      await tester.tap(plusButton);
      await tester.pump();

      // Devrait passer de 00:44 à 00:45
      expect(find.text('00 : 45'), findsOneWidget);
    });

    testWidgets('should show save preset dialog when save button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const QuickStartTimerScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Taper le bouton sauvegarder
      await tester.tap(find.byKey(const Key('quick_start_timer__save-btn')));
      await tester.pumpAndSettle();

      // Vérifier que le dialog s'affiche
      expect(find.text('Sauvegarder le préréglage'), findsOneWidget);
      expect(find.text('Nom du préréglage'), findsOneWidget);
      expect(find.text('Annuler'), findsOneWidget);
      expect(find.text('Sauvegarder'), findsAtLeastNWidgets(1)); // Peut avoir le bouton ET le dialog
    });

    testWidgets('should adjust volume slider', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const QuickStartTimerScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final slider = find.byKey(const Key('quick_start_timer__volume-slider'));
      expect(slider, findsOneWidget);

      // Le slider devrait être présent et interactif
      expect(tester.widget<Slider>(slider).value, equals(0.7));
    });

    testWidgets('should display preset card when presets are loaded', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const QuickStartTimerScreen(),
        ),
      );

      // Attendre que les préréglages se chargent
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Vérifier qu'un préréglage d'exemple s'affiche
      expect(find.text('gainage'), findsOneWidget);
      expect(find.textContaining('RÉPÉTITIONS 20x'), findsOneWidget);
      expect(find.textContaining('TRAVAIL 00:40'), findsOneWidget);
      expect(find.textContaining('REPOS 00:03'), findsOneWidget);
    });

    testWidgets('should show semantic labels for accessibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const QuickStartTimerScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier les semantic labels sur les boutons d'icône
      final volumeBtn = tester.widget<IconButton>(
        find.byKey(const Key('quick_start_timer__volume-btn'))
      );
      expect(volumeBtn.tooltip, equals('volume'));

      final menuBtn = tester.widget<IconButton>(
        find.byKey(const Key('quick_start_timer__menu-btn'))
      );
      expect(menuBtn.tooltip, equals('menu'));
    });
  });
}
