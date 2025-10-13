import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/home/preset_card.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  group('PresetCard Widget Tests', () {
    testWidgets('renders with correct key', (tester) async {
      final state = await createMockState();
      final preset = createTestPreset(id: '1', name: 'Gainage');

      await tester.pumpWidget(createTestApp(
        state,
        PresetCard(
          preset: preset,
          onTap: () {},
        ),
      ));

      expect(find.byKey(const Key('interval_timer_home__Card-28-1')), findsOneWidget);
    });

    testWidgets('affiche le nom du preset', (tester) async {
      final state = await createMockState();
      final preset = createTestPreset(name: 'Gainage');

      await tester.pumpWidget(createTestApp(
        state,
        PresetCard(
          preset: preset,
          onTap: () {},
        ),
      ));

      expect(find.text('Gainage'), findsOneWidget);
    });

    testWidgets('affiche la durée totale formatée', (tester) async {
      final state = await createMockState();
      final preset = createTestPreset(
        reps: 20,
        workSeconds: 40,
        restSeconds: 3,
      );

      await tester.pumpWidget(createTestApp(
        state,
        PresetCard(
          preset: preset,
          onTap: () {},
        ),
      ));

      // 20 × 43 = 860 seconds = 14:20
      expect(find.text('14:20'), findsOneWidget);
    });

    testWidgets('affiche les détails du preset', (tester) async {
      final state = await createMockState();
      final preset = createTestPreset(
        reps: 20,
        workSeconds: 40,
        restSeconds: 3,
      );

      await tester.pumpWidget(createTestApp(
        state,
        PresetCard(
          preset: preset,
          onTap: () {},
        ),
      ));

      expect(find.text('RÉPÉTITIONS 20x'), findsOneWidget);
      expect(find.text('TRAVAIL 00:40'), findsOneWidget);
      expect(find.text('REPOS 00:03'), findsOneWidget);
    });

    testWidgets('onTap est appelé lors du tap sur la carte', (tester) async {
      final state = await createMockState();
      final preset = createTestPreset();
      var tapCalled = false;

      await tester.pumpWidget(createTestApp(
        state,
        PresetCard(
          preset: preset,
          onTap: () => tapCalled = true,
        ),
      ));

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(tapCalled, true);
    });

    testWidgets('bouton delete visible en mode édition', (tester) async {
      final state = await createMockState();
      state.enterEditMode();
      
      final preset = createTestPreset();
      var deleteCalled = false;

      await tester.pumpWidget(createTestApp(
        state,
        PresetCard(
          preset: preset,
          onTap: () {},
          onDelete: () => deleteCalled = true,
        ),
      ));

      await tester.pump();

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('bouton delete caché quand pas en mode édition', (tester) async {
      final state = await createMockState();
      final preset = createTestPreset();

      await tester.pumpWidget(createTestApp(
        state,
        PresetCard(
          preset: preset,
          onTap: () {},
          onDelete: () {},
        ),
      ));

      expect(find.byIcon(Icons.delete), findsNothing);
    });

    testWidgets('bouton delete appelle onDelete', (tester) async {
      final state = await createMockState();
      state.enterEditMode();
      
      final preset = createTestPreset();
      var deleteCalled = false;

      await tester.pumpWidget(createTestApp(
        state,
        PresetCard(
          preset: preset,
          onTap: () {},
          onDelete: () => deleteCalled = true,
        ),
      ));

      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(deleteCalled, true);
    });

    testWidgets('durée cachée en mode édition', (tester) async {
      final state = await createMockState();
      state.enterEditMode();
      
      final preset = createTestPreset(
        reps: 20,
        workSeconds: 40,
        restSeconds: 3,
      );

      await tester.pumpWidget(createTestApp(
        state,
        PresetCard(
          preset: preset,
          onTap: () {},
          onDelete: () {},
        ),
      ));

      await tester.pump();

      // La durée ne doit pas être affichée en mode édition
      expect(find.text('14:20'), findsNothing);
    });
  });
}

