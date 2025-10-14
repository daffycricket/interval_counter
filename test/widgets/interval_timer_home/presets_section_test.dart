import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/interval_timer_home/presets_section.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  group('PresetsSection', () {
    testWidgets('renders with all keys', (tester) async {
      await pumpTestWidget(
        tester,
        PresetsSection(
          onEdit: () {},
          onAdd: () {},
        ),
      );

      expectWidgetWithKey('interval_timer_home__Container-24');
      expectWidgetWithKey('interval_timer_home__Text-25');
      expectWidgetWithKey('interval_timer_home__IconButton-26');
      expectWidgetWithKey('interval_timer_home__Button-27');
    });

    testWidgets('displays presets title', (tester) async {
      await pumpTestWidget(
        tester,
        PresetsSection(
          onEdit: () {},
          onAdd: () {},
        ),
      );

      expectText('VOS PRÉRÉGLAGES');
    });

    testWidgets('edit button calls callback', (tester) async {
      var edited = false;

      await pumpTestWidget(
        tester,
        PresetsSection(
          onEdit: () => edited = true,
          onAdd: () {},
        ),
      );

      await tapByKey(tester, 'interval_timer_home__IconButton-26');
      expect(edited, true);
    });

    testWidgets('add button calls callback', (tester) async {
      var added = false;

      await pumpTestWidget(
        tester,
        PresetsSection(
          onEdit: () {},
          onAdd: () => added = true,
        ),
      );

      await tapByKey(tester, 'interval_timer_home__Button-27');
      expect(added, true);
    });

    testWidgets('edit button has correct icon', (tester) async {
      await pumpTestWidget(
        tester,
        PresetsSection(
          onEdit: () {},
          onAdd: () {},
        ),
      );

      final editButton = tester.widget<IconButton>(
        findByKeyString('interval_timer_home__IconButton-26'),
      );

      expect((editButton.icon as Icon).icon, Icons.edit);
    });

    testWidgets('add button has correct icon', (tester) async {
      await pumpTestWidget(
        tester,
        PresetsSection(
          onEdit: () {},
          onAdd: () {},
        ),
      );

      final addButton = find.descendant(
        of: findByKeyString('interval_timer_home__Button-27'),
        matching: find.byIcon(Icons.add),
      );

      expect(addButton, findsOneWidget);
    });

    testWidgets('add button displays text', (tester) async {
      await pumpTestWidget(
        tester,
        PresetsSection(
          onEdit: () {},
          onAdd: () {},
        ),
      );

      expectText('+ AJOUTER');
    });

    testWidgets('has correct semantic labels', (tester) async {
      await pumpTestWidget(
        tester,
        PresetsSection(
          onEdit: () {},
          onAdd: () {},
        ),
      );

      // Edit button should have tooltip
      final editButton = tester.widget<IconButton>(
        findByKeyString('interval_timer_home__IconButton-26'),
      );
      expect(editButton.tooltip, 'Éditer les préréglages');
    });

    testWidgets('title has correct text style', (tester) async {
      await pumpTestWidget(
        tester,
        PresetsSection(
          onEdit: () {},
          onAdd: () {},
        ),
      );

      final titleText = tester.widget<Text>(
        findByKeyString('interval_timer_home__Text-25'),
      );

      expect(titleText.style?.fontSize, 16);
      expect(titleText.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('layout arranges elements correctly', (tester) async {
      await pumpTestWidget(
        tester,
        PresetsSection(
          onEdit: () {},
          onAdd: () {},
        ),
      );

      final container = tester.widget<Container>(
        findByKeyString('interval_timer_home__Container-24'),
      );

      expect(container.padding, const EdgeInsets.symmetric(horizontal: 4, vertical: 4));
    });
  });
}
