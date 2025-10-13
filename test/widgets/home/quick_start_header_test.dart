import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/home/quick_start_header.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  group('QuickStartHeader Widget Tests', () {
    testWidgets('renders with correct keys', (tester) async {
      final state = await createMockState();
      await tester.pumpWidget(createTestApp(state, const QuickStartHeader()));

      expect(find.byKey(const Key('interval_timer_home__Text-8')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__IconButton-9')), findsOneWidget);
    });

    testWidgets('affiche le bon texte "Démarrage rapide"', (tester) async {
      final state = await createMockState();
      await tester.pumpWidget(createTestApp(state, const QuickStartHeader()));

      expect(find.text('Démarrage rapide'), findsOneWidget);
    });

    testWidgets('affiche expand_less quand expanded est true', (tester) async {
      final state = await createMockState(quickStartExpanded: true);
      await tester.pumpWidget(createTestApp(state, const QuickStartHeader()));

      final iconButton = tester.widget<IconButton>(
        find.byKey(const Key('interval_timer_home__IconButton-9')),
      );

      final icon = iconButton.icon as Icon;
      expect(icon.icon, Icons.expand_less);
    });

    testWidgets('affiche expand_more quand expanded est false', (tester) async {
      final state = await createMockState(quickStartExpanded: false);
      await tester.pumpWidget(createTestApp(state, const QuickStartHeader()));

      final iconButton = tester.widget<IconButton>(
        find.byKey(const Key('interval_timer_home__IconButton-9')),
      );

      final icon = iconButton.icon as Icon;
      expect(icon.icon, Icons.expand_more);
    });

    testWidgets('toggle button appelle toggleQuickStartSection', (tester) async {
      final state = await createMockState(quickStartExpanded: true);
      await tester.pumpWidget(createTestApp(state, const QuickStartHeader()));

      await tester.tap(find.byKey(const Key('interval_timer_home__IconButton-9')));
      await tester.pump();

      expect(state.quickStartExpanded, false);
    });
  });
}

