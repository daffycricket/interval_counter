import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import 'package:interval_counter/models/preset.dart';
import 'package:interval_counter/screens/end_workout_screen.dart';

void main() {
  const testPreset = Preset(
    id: 'test-id',
    name: 'Test Preset',
    prepareSeconds: 5,
    repetitions: 3,
    workSeconds: 20,
    restSeconds: 10,
    cooldownSeconds: 5,
  );

  Widget createTestApp() {
    return MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: EndWorkoutScreen(preset: testPreset),
    );
  }

  group('EndWorkoutScreen', () {
    testWidgets('affiche le titre FINI (text-2)', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('end_workout__text-2')), findsOneWidget);
    });

    testWidgets('affiche le bouton stop (iconbutton-4)', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('end_workout__iconbutton-4')), findsOneWidget);
    });

    testWidgets('affiche le bouton restart (iconbutton-6)', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('end_workout__iconbutton-6')), findsOneWidget);
    });

    testWidgets('affiche le container de boutons (container-3)', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('end_workout__container-3')), findsOneWidget);
    });

    testWidgets('fond de couleur teal', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF0F7C82));
    });

    testWidgets('icône stop est Icons.stop', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.stop), findsOneWidget);
    });

    testWidgets('icône restart est Icons.refresh', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('tap stop navigue vers home (pop)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (ctx) => Scaffold(
                body: Column(
                  children: [
                    const Text('Home', key: Key('home_screen')),
                    Builder(
                      builder: (ctx) => ElevatedButton(
                        onPressed: () => Navigator.of(ctx).push(
                          MaterialPageRoute(
                            builder: (_) => EndWorkoutScreen(preset: testPreset),
                          ),
                        ),
                        child: const Text('Go'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('end_workout__iconbutton-4')), findsOneWidget);

      await tester.tap(find.byKey(const Key('end_workout__iconbutton-4')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_screen')), findsOneWidget);
    });
  });
}
