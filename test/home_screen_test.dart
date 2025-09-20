import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/screens/home_screen.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('should_render_all_key_elements_when_loaded', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Assert - Check that all key texts are present
      expect(find.text('Démarrage rapide'), findsOneWidget);
      expect(find.text('RÉPÉTITIONS'), findsOneWidget);
      expect(find.text('TRAVAIL'), findsOneWidget);
      expect(find.text('REPOS'), findsOneWidget);
      expect(find.text('SAUVEGARDER'), findsOneWidget);
      expect(find.text('⚡ COMMENCER'), findsOneWidget);
      expect(find.text('VOS PRÉRÉGLAGES'), findsOneWidget);
      expect(find.text('+ AJOUTER'), findsOneWidget);
      
      // Check preset card
      expect(find.text('gainage'), findsOneWidget);
      expect(find.text('14:22'), findsOneWidget);
      expect(find.text('RÉPÉTITIONS 20x'), findsOneWidget);
      expect(find.text('TRAVAIL 00:40'), findsOneWidget);
      expect(find.text('REPOS 00:03'), findsOneWidget);
    });

    testWidgets('should_display_initial_values_when_loaded', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Assert - Check initial values
      expect(find.text('16'), findsOneWidget); // Initial repetitions
      expect(find.text('00 : 44'), findsOneWidget); // Initial work time
      expect(find.text('00 : 15'), findsOneWidget); // Initial rest time
    });

    testWidgets('should_increment_repetitions_when_plus_button_tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Find the plus button for repetitions (first plus button in the widget tree)
      final Finder repetitionsPlusButton = find.byIcon(Icons.add).first;

      // Act
      await tester.tap(repetitionsPlusButton);
      await tester.pump();

      // Assert
      expect(find.text('17'), findsOneWidget);
    });

    testWidgets('should_decrement_repetitions_when_minus_button_tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Find the minus button for repetitions (first minus button in the widget tree)
      final Finder repetitionsMinusButton = find.byIcon(Icons.remove).first;

      // Act
      await tester.tap(repetitionsMinusButton);
      await tester.pump();

      // Assert
      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('should_not_decrement_repetitions_below_one', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      final Finder repetitionsMinusButton = find.byIcon(Icons.remove).first;

      // Act - Tap minus button 20 times to try to go below 1
      for (int i = 0; i < 20; i++) {
        await tester.tap(repetitionsMinusButton);
        await tester.pump();
      }

      // Assert - Should not go below 1
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('should_increment_work_time_when_plus_button_tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Find the plus button for work time (second plus button)
      final Finder workPlusButton = find.byIcon(Icons.add).at(1);

      // Act
      await tester.tap(workPlusButton);
      await tester.pump();

      // Assert
      expect(find.text('00 : 45'), findsOneWidget);
    });

    testWidgets('should_handle_work_time_seconds_overflow', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      final Finder workPlusButton = find.byIcon(Icons.add).at(1);

      // Act - Tap plus button 16 times to go from 44 to 60 (which should become 01:00)
      for (int i = 0; i < 16; i++) {
        await tester.tap(workPlusButton);
        await tester.pump();
      }

      // Assert
      expect(find.text('01 : 00'), findsOneWidget);
    });

    testWidgets('should_have_accessibility_labels_for_buttons', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Assert - Check tooltips are present
      expect(find.byTooltip('Volume'), findsOneWidget);
      expect(find.byTooltip('Menu'), findsOneWidget);
      expect(find.byTooltip('Sauvegarder'), findsOneWidget);
      expect(find.byTooltip('Modifier vos préréglages'), findsOneWidget);
    });

    testWidgets('should_render_preset_card_as_tappable', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Act & Assert - Check that preset card is tappable (has InkWell)
      expect(find.byType(InkWell), findsAtLeastNWidgets(1));
    });
  });
}
