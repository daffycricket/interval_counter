import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import 'package:interval_counter/models/preset.dart';
import 'package:interval_counter/widgets/home/preset_card.dart';

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

  final testPreset = Preset(
    id: 'test-id-1',
    name: 'gainage',
    repetitions: 20,
    workSeconds: 40,
    restSeconds: 3,
  );

  group('PresetCard', () {
    testWidgets('renders with key home__Card-28', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PresetCard(preset: testPreset, onTap: () {}, onDelete: () {}),
      ));
      await tester.pump();
      expect(find.byKey(const Key('home__Card-28')), findsOneWidget);
    });

    testWidgets('displays preset name', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PresetCard(preset: testPreset, onTap: () {}, onDelete: () {}),
      ));
      await tester.pump();
      expect(find.byKey(const Key('home__Text-30')), findsOneWidget);
      expect(find.text('gainage'), findsOneWidget);
    });

    testWidgets('displays formatted duration', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PresetCard(preset: testPreset, onTap: () {}, onDelete: () {}),
      ));
      await tester.pump();
      expect(find.byKey(const Key('home__Text-31')), findsOneWidget);
    });

    testWidgets('displays reps detail with key home__Text-32', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PresetCard(preset: testPreset, onTap: () {}, onDelete: () {}),
      ));
      await tester.pump();
      expect(find.byKey(const Key('home__Text-32')), findsOneWidget);
    });

    testWidgets('displays work detail with key home__Text-33', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PresetCard(preset: testPreset, onTap: () {}, onDelete: () {}),
      ));
      await tester.pump();
      expect(find.byKey(const Key('home__Text-33')), findsOneWidget);
    });

    testWidgets('displays rest detail with key home__Text-34', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PresetCard(preset: testPreset, onTap: () {}, onDelete: () {}),
      ));
      await tester.pump();
      expect(find.byKey(const Key('home__Text-34')), findsOneWidget);
    });

    testWidgets('calls onTap when card is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildTestWidget(
        PresetCard(
          preset: testPreset,
          onTap: () => tapped = true,
          onDelete: () {},
        ),
      ));
      await tester.pump();
      await tester.tap(find.byKey(const Key('home__Card-28')));
      await tester.pump();
      expect(tapped, true);
    });

    testWidgets('calls onDelete when dismissed', (tester) async {
      var deleted = false;
      await tester.pumpWidget(buildTestWidget(
        PresetCard(
          preset: testPreset,
          onTap: () {},
          onDelete: () => deleted = true,
        ),
      ));
      await tester.pump();
      await tester.drag(
        find.byKey(const Key('home__Card-28')),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();
      expect(deleted, true);
    });
  });
}
