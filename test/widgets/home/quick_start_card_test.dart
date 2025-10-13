import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/home/quick_start_card.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  group('QuickStartCard Widget Tests', () {
    testWidgets('renders with correct card key', (tester) async {
      final state = await createMockState();
      var startCalled = false;
      var saveCalled = false;

      await tester.pumpWidget(createTestApp(
        state,
        QuickStartCard(
          onStart: () => startCalled = true,
          onSave: () => saveCalled = true,
        ),
      ));

      expect(find.byKey(const Key('interval_timer_home__Card-6')), findsOneWidget);
    });

    testWidgets('affiche les ValueControls quand expanded', (tester) async {
      final state = await createMockState(quickStartExpanded: true, reps: 16);
      await tester.pumpWidget(createTestApp(
        state,
        QuickStartCard(onStart: () {}, onSave: () {}),
      ));

      // Vérifier les clés des ValueControls
      expect(find.byKey(const Key('interval_timer_home__Text-12')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__IconButton-11')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__IconButton-13')), findsOneWidget);
      
      expect(find.byKey(const Key('interval_timer_home__Text-16')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__IconButton-15')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__IconButton-17')), findsOneWidget);
      
      expect(find.byKey(const Key('interval_timer_home__Text-20')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__IconButton-19')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__IconButton-21')), findsOneWidget);
    });

    testWidgets('masque les ValueControls quand collapsed', (tester) async {
      final state = await createMockState(quickStartExpanded: false);
      await tester.pumpWidget(createTestApp(
        state,
        QuickStartCard(onStart: () {}, onSave: () {}),
      ));

      // Les ValueControls ne doivent pas être affichés
      expect(find.byKey(const Key('interval_timer_home__Text-12')), findsNothing);
      expect(find.byKey(const Key('interval_timer_home__IconButton-11')), findsNothing);
    });

    testWidgets('affiche les valeurs correctes dans les ValueControls', (tester) async {
      final state = await createMockState(
        quickStartExpanded: true,
        reps: 20,
        workSeconds: 60,
        restSeconds: 10,
      );
      await tester.pumpWidget(createTestApp(
        state,
        QuickStartCard(onStart: () {}, onSave: () {}),
      ));

      // Vérifier la valeur des répétitions
      expect(find.text('20'), findsOneWidget);
      
      // Vérifier les temps formatés
      expect(find.text('01 : 00'), findsOneWidget); // workSeconds
      expect(find.text('00 : 10'), findsOneWidget); // restSeconds
    });

    testWidgets('bouton SAUVEGARDER appelle onSave', (tester) async {
      final state = await createMockState(quickStartExpanded: true);
      var saveCalled = false;

      await tester.pumpWidget(createTestApp(
        state,
        QuickStartCard(
          onStart: () {},
          onSave: () => saveCalled = true,
        ),
      ));

      await tester.tap(find.byKey(const Key('interval_timer_home__Button-22')));
      await tester.pump();

      expect(saveCalled, true);
    });

    testWidgets('bouton COMMENCER appelle onStart', (tester) async {
      final state = await createMockState(quickStartExpanded: true);
      var startCalled = false;

      await tester.pumpWidget(createTestApp(
        state,
        QuickStartCard(
          onStart: () => startCalled = true,
          onSave: () {},
        ),
      ));

      await tester.tap(find.byKey(const Key('interval_timer_home__Button-23')));
      await tester.pump();

      expect(startCalled, true);
    });

    testWidgets('incrementer/décrémenter répétitions fonctionne', (tester) async {
      final state = await createMockState(quickStartExpanded: true, reps: 16);
      await tester.pumpWidget(createTestApp(
        state,
        QuickStartCard(onStart: () {}, onSave: () {}),
      ));

      // Incrémenter
      await tester.tap(find.byKey(const Key('interval_timer_home__IconButton-13')));
      await tester.pump();
      expect(state.reps, 17);

      // Décrémenter
      await tester.tap(find.byKey(const Key('interval_timer_home__IconButton-11')));
      await tester.pump();
      expect(state.reps, 16);
    });

    testWidgets('incrementer/décrémenter temps de travail fonctionne', (tester) async {
      final state = await createMockState(quickStartExpanded: true, workSeconds: 44);
      await tester.pumpWidget(createTestApp(
        state,
        QuickStartCard(onStart: () {}, onSave: () {}),
      ));

      // Incrémenter
      await tester.tap(find.byKey(const Key('interval_timer_home__IconButton-17')));
      await tester.pump();
      expect(state.workSeconds, 49);

      // Décrémenter
      await tester.tap(find.byKey(const Key('interval_timer_home__IconButton-15')));
      await tester.pump();
      expect(state.workSeconds, 44);
    });

    testWidgets('incrementer/décrémenter temps de repos fonctionne', (tester) async {
      final state = await createMockState(quickStartExpanded: true, restSeconds: 15);
      await tester.pumpWidget(createTestApp(
        state,
        QuickStartCard(onStart: () {}, onSave: () {}),
      ));

      // Incrémenter
      await tester.tap(find.byKey(const Key('interval_timer_home__IconButton-21')));
      await tester.pump();
      expect(state.restSeconds, 20);

      // Décrémenter
      await tester.tap(find.byKey(const Key('interval_timer_home__IconButton-19')));
      await tester.pump();
      expect(state.restSeconds, 10);
    });
  });
}

