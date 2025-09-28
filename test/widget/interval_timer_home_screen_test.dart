import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/screens/interval_timer_home_screen.dart';
import 'package:interval_counter/theme/app_theme.dart';

void main() {
  group('IntervalTimerHomeScreen', () {
    testWidgets('should display all main sections', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      // Attendre que les préréglages se chargent
      await tester.pumpAndSettle();

      // Vérifier la présence des sections principales
      expect(find.text('Démarrage rapide'), findsOneWidget);
      expect(find.text('VOS PRÉRÉGLAGES'), findsOneWidget);
      
      // Vérifier les contrôles de valeurs
      expect(find.text('RÉPÉTITIONS'), findsOneWidget);
      expect(find.text('TRAVAIL'), findsOneWidget);
      expect(find.text('REPOS'), findsOneWidget);
      
      // Vérifier les boutons principaux
      expect(find.text('SAUVEGARDER'), findsOneWidget);
      expect(find.text('COMMENCER'), findsOneWidget);
      expect(find.text('AJOUTER'), findsOneWidget);
    });

    testWidgets('should increment/decrement repetitions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Valeur initiale
      expect(find.text('16'), findsOneWidget);

      // Trouver les boutons +/- pour les répétitions
      final incrementButtons = find.byIcon(Icons.add);
      final decrementButtons = find.byIcon(Icons.remove);

      // Incrémenter (premier bouton + trouvé)
      await tester.tap(incrementButtons.first);
      await tester.pump();
      expect(find.text('17'), findsOneWidget);

      // Décrémenter (premier bouton - trouvé)
      await tester.tap(decrementButtons.first);
      await tester.pump();
      expect(find.text('16'), findsOneWidget);
    });

    testWidgets('should not allow repetitions below 1', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Décrémenter jusqu'à 1
      final decrementButtons = find.byIcon(Icons.remove);
      
      // Décrémenter 15 fois (de 16 à 1)
      for (int i = 0; i < 15; i++) {
        await tester.tap(decrementButtons.first);
        await tester.pump();
      }
      expect(find.text('1'), findsOneWidget);

      // Essayer de décrémenter encore (ne devrait pas passer en dessous de 1)
      await tester.tap(decrementButtons.first);
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should toggle quick start section', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Section initialement dépliée
      expect(find.text('RÉPÉTITIONS'), findsOneWidget);
      expect(find.byIcon(Icons.expand_less), findsOneWidget);

      // Replier la section
      await tester.tap(find.byIcon(Icons.expand_less));
      await tester.pump();

      // Section repliée
      expect(find.text('RÉPÉTITIONS'), findsNothing);
      expect(find.byIcon(Icons.expand_more), findsOneWidget);

      // Déplier à nouveau
      await tester.tap(find.byIcon(Icons.expand_more));
      await tester.pump();

      // Section dépliée
      expect(find.text('RÉPÉTITIONS'), findsOneWidget);
      expect(find.byIcon(Icons.expand_less), findsOneWidget);
    });

    testWidgets('should show volume controls', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier la présence des contrôles de volume
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('should show empty state when no presets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier l'état vide des préréglages
      expect(
        find.text('Vous n\'avez pas encore créé de préréglage.'),
        findsOneWidget,
      );
      expect(
        find.text('Utilisez + Ajouter pour en créer un.'),
        findsOneWidget,
      );
    });

    testWidgets('should show snackbar when starting timer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Appuyer sur COMMENCER
      await tester.tap(find.text('COMMENCER'));
      await tester.pump();

      // Vérifier l'affichage du snackbar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.textContaining('Démarrage timer:'),
        findsOneWidget,
      );
    });

    testWidgets('should have proper accessibility labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const IntervalTimerHomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier les tooltips/labels d'accessibilité
      expect(find.byTooltip('Régler le volume'), findsOneWidget);
      expect(find.byTooltip('Plus d\'options'), findsOneWidget);
      expect(find.byTooltip('Éditer les préréglages'), findsOneWidget);
    });
  });
}
