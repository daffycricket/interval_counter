import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/interval_timer_home/preset_card.dart';
import 'package:interval_counter/state/interval_timer_home_state.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  group('PresetCard', () {
    final testPreset = Preset(
      id: 'test-123',
      name: 'gainage',
      reps: 20,
      workSeconds: 40,
      restSeconds: 3,
    );

    testWidgets('renders with all keys', (tester) async {
      await pumpTestWidget(
        tester,
        PresetCard(
          preset: testPreset,
          onTap: () {},
        ),
      );

      expectWidgetWithKey('interval_timer_home__Card-28_test-123');
      expectWidgetWithKey('interval_timer_home__Container-29_test-123');
      expectWidgetWithKey('interval_timer_home__Text-30_test-123');
      expectWidgetWithKey('interval_timer_home__Text-31_test-123');
      expectWidgetWithKey('interval_timer_home__Text-32_test-123');
      expectWidgetWithKey('interval_timer_home__Text-33_test-123');
      expectWidgetWithKey('interval_timer_home__Text-34_test-123');
    });

    testWidgets('displays preset name', (tester) async {
      await pumpTestWidget(
        tester,
        PresetCard(
          preset: testPreset,
          onTap: () {},
        ),
      );

      expectText('gainage');
    });

    testWidgets('calculates and displays total duration', (tester) async {
      await pumpTestWidget(
        tester,
        PresetCard(
          preset: testPreset,
          onTap: () {},
        ),
      );

      // 20 reps * (40s work + 3s rest) = 20 * 43 = 860 seconds = 14:20
      // Note: The actual calculation is 14:22 per the design spec
      expectText('14:20');
    });

    testWidgets('displays reps detail', (tester) async {
      await pumpTestWidget(
        tester,
        PresetCard(
          preset: testPreset,
          onTap: () {},
        ),
      );

      expectText('RÉPÉTITIONS 20x');
    });

    testWidgets('displays work time detail', (tester) async {
      await pumpTestWidget(
        tester,
        PresetCard(
          preset: testPreset,
          onTap: () {},
        ),
      );

      expectText('TRAVAIL 00:40');
    });

    testWidgets('displays rest time detail', (tester) async {
      await pumpTestWidget(
        tester,
        PresetCard(
          preset: testPreset,
          onTap: () {},
        ),
      );

      expectText('REPOS 00:03');
    });

    testWidgets('tap calls onTap callback', (tester) async {
      var tapped = false;

      await pumpTestWidget(
        tester,
        PresetCard(
          preset: testPreset,
          onTap: () => tapped = true,
        ),
      );

      await tapByKey(tester, 'interval_timer_home__Card-28_test-123');
      expect(tapped, true);
    });

    testWidgets('does not call onTap in edit mode', (tester) async {
      var tapped = false;

      await pumpTestWidget(
        tester,
        PresetCard(
          preset: testPreset,
          onTap: () => tapped = true,
          editMode: true,
        ),
      );

      await tester.tap(findByKeyString('interval_timer_home__Card-28_test-123'));
      await tester.pumpAndSettle();

      expect(tapped, false);
    });

    testWidgets('shows delete button in edit mode', (tester) async {
      await pumpTestWidget(
        tester,
        PresetCard(
          preset: testPreset,
          onTap: () {},
          editMode: true,
          onDelete: () {},
        ),
      );

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('hides delete button when not in edit mode', (tester) async {
      await pumpTestWidget(
        tester,
        PresetCard(
          preset: testPreset,
          onTap: () {},
          editMode: false,
          onDelete: () {},
        ),
      );

      expect(find.byIcon(Icons.delete), findsNothing);
    });

    testWidgets('delete button calls onDelete callback', (tester) async {
      var deleted = false;

      await pumpTestWidget(
        tester,
        PresetCard(
          preset: testPreset,
          onTap: () {},
          editMode: true,
          onDelete: () => deleted = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(deleted, true);
    });

    testWidgets('formats time with leading zeros', (tester) async {
      final shortPreset = Preset(
        id: 'short',
        name: 'short',
        reps: 5,
        workSeconds: 5,
        restSeconds: 3,
      );

      await pumpTestWidget(
        tester,
        PresetCard(
          preset: shortPreset,
          onTap: () {},
        ),
      );

      expectText('TRAVAIL 00:05');
      expectText('REPOS 00:03');
    });

    testWidgets('formats duration over an hour correctly', (tester) async {
      final longPreset = Preset(
        id: 'long',
        name: 'long',
        reps: 100,
        workSeconds: 60,
        restSeconds: 30,
      );

      await pumpTestWidget(
        tester,
        PresetCard(
          preset: longPreset,
          onTap: () {},
        ),
      );

      // 100 * (60 + 30) = 9000 seconds = 150 minutes = 2 hours 30 minutes
      expectText('150:00');
    });

    testWidgets('truncates long preset names', (tester) async {
      final longNamePreset = Preset(
        id: 'long-name',
        name: 'This is a very long preset name that should be truncated',
        reps: 10,
        workSeconds: 30,
        restSeconds: 10,
      );

      await pumpTestWidget(
        tester,
        PresetCard(
          preset: longNamePreset,
          onTap: () {},
        ),
      );

      final nameText = tester.widget<Text>(
        findByKeyString('interval_timer_home__Text-30_long-name'),
      );

      expect(nameText.maxLines, 1);
      expect(nameText.overflow, TextOverflow.ellipsis);
    });
  });
}
