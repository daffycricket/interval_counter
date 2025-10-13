import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/screens/interval_timer_home_screen.dart';
import '../helpers/widget_test_helpers.dart';

void main() {
  group('IntervalTimerHomeScreen Tests', () {
    testWidgets('renders all main components', (tester) async {
      final state = await createMockState();

      await tester.pumpWidget(createTestApp(state, const IntervalTimerHomeScreen()));

      // Vérifier que les composants principaux sont présents
      expect(find.byType(Scaffold), findsOneWidget);
      
      // VolumeHeader doit être présent
      expect(find.byKey(const Key('interval_timer_home__Slider-3')), findsOneWidget);
      
      // QuickStartCard doit être présent
      expect(find.byKey(const Key('interval_timer_home__Card-6')), findsOneWidget);
      
      // Button COMMENCER doit être présent
      expect(find.byKey(const Key('interval_timer_home__Button-23')), findsOneWidget);
      
      // PresetsHeader doit être présent
      expect(find.byKey(const Key('interval_timer_home__Text-25')), findsOneWidget);
    });

    testWidgets('affiche empty state quand aucun preset', (tester) async {
      final state = await createMockState(presets: []);

      await tester.pumpWidget(createTestApp(state, const IntervalTimerHomeScreen()));

      expect(
        find.text('Aucun préréglage sauvegardé.\nAppuyez sur + AJOUTER pour créer.'),
        findsOneWidget,
      );
    });

    testWidgets('affiche les presets quand présents', (tester) async {
      final presets = [
        createTestPreset(id: '1', name: 'Gainage'),
        createTestPreset(id: '2', name: 'Cardio'),
      ];
      final state = await createMockState(presets: presets);

      await tester.pumpWidget(createTestApp(state, const IntervalTimerHomeScreen()));

      // Vérifier que les presets sont affichés
      expect(find.text('Gainage'), findsOneWidget);
      expect(find.text('Cardio'), findsOneWidget);
    });

    testWidgets('bouton COMMENCER affiche un SnackBar', (tester) async {
      final state = await createMockState(reps: 16, workSeconds: 44, restSeconds: 15);

      await tester.pumpWidget(createTestApp(state, const IntervalTimerHomeScreen()));

      await tester.tap(find.byKey(const Key('interval_timer_home__Button-23')));
      await tester.pumpAndSettle();

      expect(
        find.text('Démarrage: 16 reps, 44s travail, 15s repos'),
        findsOneWidget,
      );
    });

    testWidgets('bouton SAUVEGARDER affiche dialogue', (tester) async {
      final state = await createMockState();

      await tester.pumpWidget(createTestApp(state, const IntervalTimerHomeScreen()));

      await tester.tap(find.byKey(const Key('interval_timer_home__Button-22')));
      await tester.pumpAndSettle();

      // Vérifier que le dialogue est affiché
      expect(find.text('Sauvegarder le préréglage'), findsOneWidget);
      expect(find.text('Nom du préréglage'), findsOneWidget);
    });

    testWidgets('sauvegarder un preset avec nom valide', (tester) async {
      final state = await createMockState();

      await tester.pumpWidget(createTestApp(state, const IntervalTimerHomeScreen()));

      // Ouvrir le dialogue
      await tester.tap(find.byKey(const Key('interval_timer_home__Button-22')));
      await tester.pumpAndSettle();

      // Saisir un nom
      await tester.enterText(find.byType(TextFormField), 'Mon Preset');
      await tester.pumpAndSettle();

      // Confirmer
      await tester.tap(find.text('SAUVEGARDER'));
      await tester.pumpAndSettle();

      // Vérifier que le preset a été ajouté
      expect(state.presets, hasLength(1));
      expect(state.presets.first.name, 'Mon Preset');
      
      // Vérifier le SnackBar de confirmation
      expect(find.text('Préréglage sauvegardé'), findsOneWidget);
    });

    testWidgets('ne sauvegarde pas un preset avec nom vide', (tester) async {
      final state = await createMockState();

      await tester.pumpWidget(createTestApp(state, const IntervalTimerHomeScreen()));

      // Ouvrir le dialogue
      await tester.tap(find.byKey(const Key('interval_timer_home__Button-22')));
      await tester.pumpAndSettle();

      // Ne pas saisir de nom, tenter de confirmer
      await tester.tap(find.text('SAUVEGARDER'));
      await tester.pumpAndSettle();

      // Le dialogue doit toujours être ouvert (validation échouée)
      expect(find.text('Sauvegarder le préréglage'), findsOneWidget);
      
      // Aucun preset ne doit avoir été ajouté
      expect(state.presets, isEmpty);
    });

    testWidgets('charger un preset met à jour l\'état', (tester) async {
      final preset = createTestPreset(
        id: '1',
        name: 'Test',
        reps: 25,
        workSeconds: 50,
        restSeconds: 5,
      );
      final state = await createMockState(presets: [preset]);

      await tester.pumpWidget(createTestApp(state, const IntervalTimerHomeScreen()));

      // Tap sur la carte du preset
      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      // Vérifier que les valeurs ont été chargées
      expect(state.reps, 25);
      expect(state.workSeconds, 50);
      expect(state.restSeconds, 5);
      
      // Vérifier le SnackBar
      expect(find.text('Préréglage chargé'), findsOneWidget);
    });

    testWidgets('supprimer un preset après confirmation', (tester) async {
      final preset = createTestPreset(id: '1', name: 'Test');
      final state = await createMockState(presets: [preset]);
      state.enterEditMode();

      await tester.pumpWidget(createTestApp(state, const IntervalTimerHomeScreen()));
      await tester.pump();

      // Trouver et taper sur le bouton delete
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Confirmer la suppression dans le dialogue
      await tester.tap(find.text('SUPPRIMER'));
      await tester.pumpAndSettle();

      // Vérifier que le preset a été supprimé
      expect(state.presets, isEmpty);
      
      // Vérifier le SnackBar
      expect(find.text('Préréglage supprimé'), findsOneWidget);
    });

    testWidgets('annuler suppression de preset', (tester) async {
      final preset = createTestPreset(id: '1', name: 'Test');
      final state = await createMockState(presets: [preset]);
      state.enterEditMode();

      await tester.pumpWidget(createTestApp(state, const IntervalTimerHomeScreen()));
      await tester.pump();

      // Taper sur le bouton delete
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Annuler dans le dialogue
      await tester.tap(find.text('ANNULER'));
      await tester.pumpAndSettle();

      // Le preset doit toujours être là
      expect(state.presets, hasLength(1));
    });

    testWidgets('scroll fonctionne correctement', (tester) async {
      final presets = List.generate(
        10,
        (i) => createTestPreset(id: '$i', name: 'Preset $i'),
      );
      final state = await createMockState(presets: presets);

      await tester.pumpWidget(createTestApp(state, const IntervalTimerHomeScreen()));

      // Vérifier que l'écran est scrollable
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}

