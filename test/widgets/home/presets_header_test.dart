import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/home/presets_header.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  group('PresetsHeader Widget Tests', () {
    testWidgets('renders with correct keys', (tester) async {
      final state = await createMockState();
      await tester.pumpWidget(createTestApp(
        state,
        PresetsHeader(onAdd: () {}),
      ));

      expect(find.byKey(const Key('interval_timer_home__Text-25')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__IconButton-26')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__Button-27')), findsOneWidget);
    });

    testWidgets('affiche le bon texte "VOS PRÉRÉGLAGES"', (tester) async {
      final state = await createMockState();
      await tester.pumpWidget(createTestApp(
        state,
        PresetsHeader(onAdd: () {}),
      ));

      expect(find.text('VOS PRÉRÉGLAGES'), findsOneWidget);
    });

    testWidgets('affiche le bouton "+ AJOUTER"', (tester) async {
      final state = await createMockState();
      await tester.pumpWidget(createTestApp(
        state,
        PresetsHeader(onAdd: () {}),
      ));

      expect(find.text('+ AJOUTER'), findsOneWidget);
    });

    testWidgets('bouton edit toggle le mode édition', (tester) async {
      final state = await createMockState();
      await tester.pumpWidget(createTestApp(
        state,
        PresetsHeader(onAdd: () {}),
      ));

      expect(state.presetsEditMode, false);

      await tester.tap(find.byKey(const Key('interval_timer_home__IconButton-26')));
      await tester.pump();

      expect(state.presetsEditMode, true);

      await tester.tap(find.byKey(const Key('interval_timer_home__IconButton-26')));
      await tester.pump();

      expect(state.presetsEditMode, false);
    });

    testWidgets('bouton + AJOUTER appelle onAdd', (tester) async {
      final state = await createMockState();
      var addCalled = false;

      await tester.pumpWidget(createTestApp(
        state,
        PresetsHeader(onAdd: () => addCalled = true),
      ));

      await tester.tap(find.byKey(const Key('interval_timer_home__Button-27')));
      await tester.pump();

      expect(addCalled, true);
    });
  });
}

