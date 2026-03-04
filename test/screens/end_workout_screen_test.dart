import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import 'package:interval_counter/models/preset.dart';
import 'package:interval_counter/routes/app_routes.dart';
import 'package:interval_counter/screens/end_workout_screen.dart';

void main() {
  group('EndWorkoutScreen', () {
    late Preset testPreset;

    setUp(() {
      testPreset = const Preset(
        id: 'test-id',
        name: 'Test Preset',
        prepareSeconds: 10,
        repetitions: 3,
        workSeconds: 30,
        restSeconds: 15,
        cooldownSeconds: 10,
      );
    });

    Widget createTestWidget() {
      return MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: EndWorkoutScreen(preset: testPreset),
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.workout) {
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('WorkoutScreen')),
              ),
            );
          }
          return null;
        },
      );
    }

    testWidgets('T1 - displays title with correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('end_workout__text-2')), findsOneWidget);
    });

    testWidgets('T2 - displays stop button with correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('end_workout__iconbutton-4')), findsOneWidget);
    });

    testWidgets('T3 - displays restart button with correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('end_workout__iconbutton-6')), findsOneWidget);
    });

    testWidgets('T4 - scaffold has correct background color', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF008290));
    });

    testWidgets('T5 - stop button has correct accessibility label', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Stop timer'), findsOneWidget);
    });

    testWidgets('T6 - restart button has correct accessibility label', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Restart timer'), findsOneWidget);
    });

    testWidgets('T7 - tap stop button pops screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EndWorkoutScreen(preset: testPreset),
                    ),
                  );
                },
                child: const Text('Go to End'),
              ),
            ),
          ),
        ),
      );

      // Navigate to EndWorkoutScreen
      await tester.tap(find.text('Go to End'));
      await tester.pumpAndSettle();

      // Verify EndWorkoutScreen is displayed
      expect(find.byType(EndWorkoutScreen), findsOneWidget);

      // Tap stop button
      await tester.tap(find.byKey(const Key('end_workout__iconbutton-4')));
      await tester.pumpAndSettle();

      // Verify screen was popped
      expect(find.byType(EndWorkoutScreen), findsNothing);
      expect(find.text('Go to End'), findsOneWidget);
    });

    testWidgets('T8 - tap restart button navigates to workout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap restart button
      await tester.tap(find.byKey(const Key('end_workout__iconbutton-6')));
      await tester.pumpAndSettle();

      // Verify navigation to WorkoutScreen
      expect(find.text('WorkoutScreen'), findsOneWidget);
      expect(find.byType(EndWorkoutScreen), findsNothing);
    });
  });
}
