import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import 'package:interval_counter/widgets/home/presets_header.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr'), Locale('en')],
      locale: const Locale('fr'),
      home: Scaffold(body: child),
    );
  }

  group('PresetsHeader', () {
    testWidgets('renders with key home__Container-24', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PresetsHeader(onEdit: () {}, onAdd: () {}),
      ));
      await tester.pump();
      expect(find.byKey(const Key('home__Container-24')), findsOneWidget);
    });

    testWidgets('displays title with key home__Text-25', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PresetsHeader(onEdit: () {}, onAdd: () {}),
      ));
      await tester.pump();
      expect(find.byKey(const Key('home__Text-25')), findsOneWidget);
    });

    testWidgets('edit button has key home__IconButton-26', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PresetsHeader(onEdit: () {}, onAdd: () {}),
      ));
      await tester.pump();
      expect(find.byKey(const Key('home__IconButton-26')), findsOneWidget);
    });

    testWidgets('add button has key home__Button-27', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PresetsHeader(onEdit: () {}, onAdd: () {}),
      ));
      await tester.pump();
      expect(find.byKey(const Key('home__Button-27')), findsOneWidget);
    });

    testWidgets('calls onEdit when edit button is tapped', (tester) async {
      var editCalled = false;
      await tester.pumpWidget(buildTestWidget(
        PresetsHeader(onEdit: () => editCalled = true, onAdd: () {}),
      ));
      await tester.pump();
      await tester.tap(find.byKey(const Key('home__IconButton-26')));
      await tester.pump();
      expect(editCalled, true);
    });

    testWidgets('calls onAdd when add button is tapped', (tester) async {
      var addCalled = false;
      await tester.pumpWidget(buildTestWidget(
        PresetsHeader(onEdit: () {}, onAdd: () => addCalled = true),
      ));
      await tester.pump();
      await tester.tap(find.byKey(const Key('home__Button-27')));
      await tester.pump();
      expect(addCalled, true);
    });
  });
}
