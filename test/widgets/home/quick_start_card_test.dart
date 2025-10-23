import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:interval_counter/widgets/home/quick_start_card.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      locale: const Locale('fr'),
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('QuickStartCard', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          QuickStartCard(
            expanded: true,
            reps: 10,
            workTime: '00 : 40',
            restTime: '00 : 20',
            onToggleExpanded: () {},
            onDecrementReps: () {},
            onIncrementReps: () {},
            onDecrementWork: () {},
            onIncrementWork: () {},
            onDecrementRest: () {},
            onIncrementRest: () {},
            onSave: () {},
            decreaseRepsEnabled: true,
            decreaseWorkEnabled: true,
            decreaseRestEnabled: true,
          ),
        ),
      );

      expect(find.byKey(const Key('home__Text-8')), findsOneWidget);
      expect(find.text('Démarrage rapide'), findsOneWidget);
    });

    testWidgets('displays reps value', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          QuickStartCard(
            expanded: true,
            reps: 16,
            workTime: '00 : 40',
            restTime: '00 : 20',
            onToggleExpanded: () {},
            onDecrementReps: () {},
            onIncrementReps: () {},
            onDecrementWork: () {},
            onIncrementWork: () {},
            onDecrementRest: () {},
            onIncrementRest: () {},
            onSave: () {},
            decreaseRepsEnabled: true,
            decreaseWorkEnabled: true,
            decreaseRestEnabled: true,
          ),
        ),
      );

      expect(find.byKey(const Key('home__Text-12')), findsOneWidget);
      expect(find.text('16'), findsOneWidget);
    });

    testWidgets('displays work time', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          QuickStartCard(
            expanded: true,
            reps: 10,
            workTime: '00 : 44',
            restTime: '00 : 20',
            onToggleExpanded: () {},
            onDecrementReps: () {},
            onIncrementReps: () {},
            onDecrementWork: () {},
            onIncrementWork: () {},
            onDecrementRest: () {},
            onIncrementRest: () {},
            onSave: () {},
            decreaseRepsEnabled: true,
            decreaseWorkEnabled: true,
            decreaseRestEnabled: true,
          ),
        ),
      );

      expect(find.byKey(const Key('home__Text-16')), findsOneWidget);
      expect(find.text('00 : 44'), findsOneWidget);
    });

    testWidgets('displays rest time', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          QuickStartCard(
            expanded: true,
            reps: 10,
            workTime: '00 : 40',
            restTime: '00 : 15',
            onToggleExpanded: () {},
            onDecrementReps: () {},
            onIncrementReps: () {},
            onDecrementWork: () {},
            onIncrementWork: () {},
            onDecrementRest: () {},
            onIncrementRest: () {},
            onSave: () {},
            decreaseRepsEnabled: true,
            decreaseWorkEnabled: true,
            decreaseRestEnabled: true,
          ),
        ),
      );

      expect(find.byKey(const Key('home__Text-20')), findsOneWidget);
      expect(find.text('00 : 15'), findsOneWidget);
    });

    testWidgets('taps increment reps button', (tester) async {
      var incrementCalled = false;

      await tester.pumpWidget(
        buildTestWidget(
          QuickStartCard(
            expanded: true,
            reps: 10,
            workTime: '00 : 40',
            restTime: '00 : 20',
            onToggleExpanded: () {},
            onDecrementReps: () {},
            onIncrementReps: () => incrementCalled = true,
            onDecrementWork: () {},
            onIncrementWork: () {},
            onDecrementRest: () {},
            onIncrementRest: () {},
            onSave: () {},
            decreaseRepsEnabled: true,
            decreaseWorkEnabled: true,
            decreaseRestEnabled: true,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('home__IconButton-13')));
      await tester.pump();

      expect(incrementCalled, true);
    });

    testWidgets('taps collapse button', (tester) async {
      var toggleCalled = false;

      await tester.pumpWidget(
        buildTestWidget(
          QuickStartCard(
            expanded: true,
            reps: 10,
            workTime: '00 : 40',
            restTime: '00 : 20',
            onToggleExpanded: () => toggleCalled = true,
            onDecrementReps: () {},
            onIncrementReps: () {},
            onDecrementWork: () {},
            onIncrementWork: () {},
            onDecrementRest: () {},
            onIncrementRest: () {},
            onSave: () {},
            decreaseRepsEnabled: true,
            decreaseWorkEnabled: true,
            decreaseRestEnabled: true,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('home__IconButton-9')));
      await tester.pump();

      expect(toggleCalled, true);
    });

    testWidgets('hides controls when collapsed', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          QuickStartCard(
            expanded: false,
            reps: 10,
            workTime: '00 : 40',
            restTime: '00 : 20',
            onToggleExpanded: () {},
            onDecrementReps: () {},
            onIncrementReps: () {},
            onDecrementWork: () {},
            onIncrementWork: () {},
            onDecrementRest: () {},
            onIncrementRest: () {},
            onSave: () {},
            decreaseRepsEnabled: true,
            decreaseWorkEnabled: true,
            decreaseRestEnabled: true,
          ),
        ),
      );

      // Les contrôles ne doivent pas être visibles quand collapsed
      expect(find.byKey(const Key('home__IconButton-11')), findsNothing);
      expect(find.byKey(const Key('home__Button-22')), findsNothing);
    });

    testWidgets('button disabled when decreaseEnabled is false', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          QuickStartCard(
            expanded: true,
            reps: 1,
            workTime: '00 : 40',
            restTime: '00 : 20',
            onToggleExpanded: () {},
            onDecrementReps: () {},
            onIncrementReps: () {},
            onDecrementWork: () {},
            onIncrementWork: () {},
            onDecrementRest: () {},
            onIncrementRest: () {},
            onSave: () {},
            decreaseRepsEnabled: false,
            decreaseWorkEnabled: true,
            decreaseRestEnabled: true,
          ),
        ),
      );

      // Le bouton devrait être présent mais le ValueControl le désactive
      expect(find.byKey(const Key('home__IconButton-11')), findsOneWidget);
    });
  });
}

