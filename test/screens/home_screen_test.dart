import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import 'package:interval_counter/state/home_state.dart';
import 'package:interval_counter/screens/home_screen.dart';
import 'package:interval_counter/routes/app_routes.dart';
import '../helpers/mock_services.dart';

Widget buildTestApp(HomeState state) {
  return ChangeNotifierProvider.value(
    value: state,
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr'), Locale('en')],
      locale: const Locale('fr'),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.workout:
            return MaterialPageRoute(builder: (_) => const Scaffold(body: Text('Workout')));
          case AppRoutes.presetEditor:
            return MaterialPageRoute(builder: (_) => const Scaffold(body: Text('PresetEditor')));
          default:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
      },
      home: const HomeScreen(),
    ),
  );
}

void main() {
  late MockPreferencesRepository repo;
  late HomeState state;

  setUp(() {
    repo = MockPreferencesRepository();
    state = HomeState(repo);
  });

  group('HomeScreen', () {
    testWidgets('renders start button with key home__Button-23', (tester) async {
      await tester.pumpWidget(buildTestApp(state));
      await tester.pump();
      expect(find.byKey(const Key('home__Button-23')), findsOneWidget);
    });

    testWidgets('renders quick start card with key home__Card-6', (tester) async {
      await tester.pumpWidget(buildTestApp(state));
      await tester.pump();
      expect(find.byKey(const Key('home__Card-6')), findsOneWidget);
    });

    testWidgets('renders presets header with key home__Container-24', (tester) async {
      await tester.pumpWidget(buildTestApp(state));
      await tester.pump();
      expect(find.byKey(const Key('home__Container-24')), findsOneWidget);
    });

    testWidgets('shows no-presets message when list is empty', (tester) async {
      await tester.pumpWidget(buildTestApp(state));
      await tester.pump();
      expect(find.text('Aucun préréglage'), findsOneWidget);
    });

    testWidgets('shows preset cards when presets exist', (tester) async {
      state.savePreset('gainage');
      await tester.pumpWidget(buildTestApp(state));
      await tester.pump();
      expect(find.byKey(const Key('home__Card-28')), findsOneWidget);
      expect(find.text('gainage'), findsOneWidget);
    });

    testWidgets('tapping add button opens preset editor', (tester) async {
      await tester.pumpWidget(buildTestApp(state));
      await tester.pump();
      await tester.tap(find.byKey(const Key('home__Button-27')));
      await tester.pumpAndSettle();
      expect(find.text('PresetEditor'), findsOneWidget);
    });

    testWidgets('tapping start button navigates to workout', (tester) async {
      await tester.pumpWidget(buildTestApp(state));
      await tester.pump();
      await tester.tap(find.byKey(const Key('home__Button-23')));
      await tester.pumpAndSettle();
      expect(find.text('Workout'), findsOneWidget);
    });

    testWidgets('tapping save button shows dialog', (tester) async {
      await tester.pumpWidget(buildTestApp(state));
      await tester.pump();
      await tester.tap(find.byKey(const Key('home__Button-22')));
      await tester.pump();
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('increment reps updates display', (tester) async {
      await tester.pumpWidget(buildTestApp(state));
      await tester.pump();
      await tester.tap(find.byKey(const Key('home__IconButton-13')));
      await tester.pump();
      expect(find.byKey(const Key('home__Text-12')), findsOneWidget);
      expect(find.text('11'), findsOneWidget);
    });
  });
}
