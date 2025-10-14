import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/interval_timer_home/quick_start_section.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  group('QuickStartSection', () {
    testWidgets('renders with all keys when expanded', (tester) async {
      await pumpTestWidget(
        tester,
        QuickStartSection(
          expanded: true,
          reps: 16,
          workSeconds: 44,
          restSeconds: 15,
          onToggleExpand: () {},
          onIncrementReps: () {},
          onDecrementReps: () {},
          onIncrementWork: () {},
          onDecrementWork: () {},
          onIncrementRest: () {},
          onDecrementRest: () {},
          onSave: () {},
          onStart: () {},
        ),
      );

      expectWidgetWithKey('interval_timer_home__Card-6');
      expectWidgetWithKey('interval_timer_home__Container-7');
      expectWidgetWithKey('interval_timer_home__Text-8');
      expectWidgetWithKey('interval_timer_home__IconButton-9');
      expectWidgetWithKey('interval_timer_home__Button-22');
      expectWidgetWithKey('interval_timer_home__Button-23');
    });

    testWidgets('displays title text', (tester) async {
      await pumpTestWidget(
        tester,
        QuickStartSection(
          expanded: true,
          reps: 16,
          workSeconds: 44,
          restSeconds: 15,
          onToggleExpand: () {},
          onIncrementReps: () {},
          onDecrementReps: () {},
          onIncrementWork: () {},
          onDecrementWork: () {},
          onIncrementRest: () {},
          onDecrementRest: () {},
          onSave: () {},
          onStart: () {},
        ),
      );

      expectText('Démarrage rapide');
    });

    testWidgets('collapse button toggles section', (tester) async {
      var toggled = false;

      await pumpTestWidget(
        tester,
        QuickStartSection(
          expanded: true,
          reps: 16,
          workSeconds: 44,
          restSeconds: 15,
          onToggleExpand: () => toggled = true,
          onIncrementReps: () {},
          onDecrementReps: () {},
          onIncrementWork: () {},
          onDecrementWork: () {},
          onIncrementRest: () {},
          onDecrementRest: () {},
          onSave: () {},
          onStart: () {},
        ),
      );

      await tapByKey(tester, 'interval_timer_home__IconButton-9');
      expect(toggled, true);
    });

    testWidgets('hides content when collapsed', (tester) async {
      await pumpTestWidget(
        tester,
        QuickStartSection(
          expanded: false,
          reps: 16,
          workSeconds: 44,
          restSeconds: 15,
          onToggleExpand: () {},
          onIncrementReps: () {},
          onDecrementReps: () {},
          onIncrementWork: () {},
          onDecrementWork: () {},
          onIncrementRest: () {},
          onDecrementRest: () {},
          onSave: () {},
          onStart: () {},
        ),
      );

      // Value controls should not be visible when collapsed
      expect(findByKeyString('interval_timer_home__IconButton-11'), findsNothing);
      expect(findByKeyString('interval_timer_home__Button-22'), findsNothing);
      expect(findByKeyString('interval_timer_home__Button-23'), findsNothing);
    });

    testWidgets('save button calls callback', (tester) async {
      var saved = false;

      await pumpTestWidget(
        tester,
        QuickStartSection(
          expanded: true,
          reps: 16,
          workSeconds: 44,
          restSeconds: 15,
          onToggleExpand: () {},
          onIncrementReps: () {},
          onDecrementReps: () {},
          onIncrementWork: () {},
          onDecrementWork: () {},
          onIncrementRest: () {},
          onDecrementRest: () {},
          onSave: () => saved = true,
          onStart: () {},
        ),
      );

      await tapByKey(tester, 'interval_timer_home__Button-22');
      expect(saved, true);
    });

    testWidgets('start button calls callback', (tester) async {
      var started = false;

      await pumpTestWidget(
        tester,
        QuickStartSection(
          expanded: true,
          reps: 16,
          workSeconds: 44,
          restSeconds: 15,
          onToggleExpand: () {},
          onIncrementReps: () {},
          onDecrementReps: () {},
          onIncrementWork: () {},
          onDecrementWork: () {},
          onIncrementRest: () {},
          onDecrementRest: () {},
          onSave: () {},
          onStart: () => started = true,
        ),
      );

      await tapByKey(tester, 'interval_timer_home__Button-23');
      expect(started, true);
    });

    testWidgets('displays reps value correctly', (tester) async {
      await pumpTestWidget(
        tester,
        QuickStartSection(
          expanded: true,
          reps: 25,
          workSeconds: 44,
          restSeconds: 15,
          onToggleExpand: () {},
          onIncrementReps: () {},
          onDecrementReps: () {},
          onIncrementWork: () {},
          onDecrementWork: () {},
          onIncrementRest: () {},
          onDecrementRest: () {},
          onSave: () {},
          onStart: () {},
        ),
      );

      expectText('25');
    });

    testWidgets('displays work time formatted correctly', (tester) async {
      await pumpTestWidget(
        tester,
        QuickStartSection(
          expanded: true,
          reps: 16,
          workSeconds: 125, // 2 minutes 5 seconds
          restSeconds: 15,
          onToggleExpand: () {},
          onIncrementReps: () {},
          onDecrementReps: () {},
          onIncrementWork: () {},
          onDecrementWork: () {},
          onIncrementRest: () {},
          onDecrementRest: () {},
          onSave: () {},
          onStart: () {},
        ),
      );

      expectText('02 : 05');
    });

    testWidgets('displays rest time formatted correctly', (tester) async {
      await pumpTestWidget(
        tester,
        QuickStartSection(
          expanded: true,
          reps: 16,
          workSeconds: 44,
          restSeconds: 90, // 1 minute 30 seconds
          onToggleExpand: () {},
          onIncrementReps: () {},
          onDecrementReps: () {},
          onIncrementWork: () {},
          onDecrementWork: () {},
          onIncrementRest: () {},
          onDecrementRest: () {},
          onSave: () {},
          onStart: () {},
        ),
      );

      expectText('01 : 30');
    });

    testWidgets('ValueControl widgets receive correct callbacks', (tester) async {
      var repsDec = false;
      var repsInc = false;
      var workDec = false;
      var workInc = false;
      var restDec = false;
      var restInc = false;

      await pumpTestWidget(
        tester,
        QuickStartSection(
          expanded: true,
          reps: 16,
          workSeconds: 44,
          restSeconds: 15,
          onToggleExpand: () {},
          onIncrementReps: () => repsInc = true,
          onDecrementReps: () => repsDec = true,
          onIncrementWork: () => workInc = true,
          onDecrementWork: () => workDec = true,
          onIncrementRest: () => restInc = true,
          onDecrementRest: () => restDec = true,
          onSave: () {},
          onStart: () {},
        ),
      );

      // Test reps controls
      await tapByKey(tester, 'interval_timer_home__IconButton-11');
      expect(repsDec, true);

      await tapByKey(tester, 'interval_timer_home__IconButton-13');
      expect(repsInc, true);

      // Test work controls
      await tapByKey(tester, 'interval_timer_home__IconButton-15');
      expect(workDec, true);

      await tapByKey(tester, 'interval_timer_home__IconButton-17');
      expect(workInc, true);

      // Test rest controls
      await tapByKey(tester, 'interval_timer_home__IconButton-19');
      expect(restDec, true);

      await tapByKey(tester, 'interval_timer_home__IconButton-21');
      expect(restInc, true);
    });

    testWidgets('shows correct icon based on expanded state', (tester) async {
      await pumpTestWidget(
        tester,
        QuickStartSection(
          expanded: true,
          reps: 16,
          workSeconds: 44,
          restSeconds: 15,
          onToggleExpand: () {},
          onIncrementReps: () {},
          onDecrementReps: () {},
          onIncrementWork: () {},
          onDecrementWork: () {},
          onIncrementRest: () {},
          onDecrementRest: () {},
          onSave: () {},
          onStart: () {},
        ),
      );

      final expandedButton = tester.widget<IconButton>(
        findByKeyString('interval_timer_home__IconButton-9'),
      );
      expect((expandedButton.icon as Icon).icon, Icons.expand_less);

      final state = await createMockState();
      await tester.pumpWidget(createTestApp(
        state,
        QuickStartSection(
          expanded: false,
          reps: 16,
          workSeconds: 44,
          restSeconds: 15,
          onToggleExpand: () {},
          onIncrementReps: () {},
          onDecrementReps: () {},
          onIncrementWork: () {},
          onDecrementWork: () {},
          onIncrementRest: () {},
          onDecrementRest: () {},
          onSave: () {},
          onStart: () {},
        ),
      ));

      final collapsedButton = tester.widget<IconButton>(
        findByKeyString('interval_timer_home__IconButton-9'),
      );
      expect((collapsedButton.icon as Icon).icon, Icons.expand_more);
    });
  });
}
