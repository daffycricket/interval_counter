import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/preset_editor/preset_total_display.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:interval_counter/l10n/app_localizations.dart';

void main() {
  Widget createTestWidget({required String formattedTotal}) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr'), Locale('en')],
      locale: const Locale('fr'),
      home: Scaffold(
        body: PresetTotalDisplay(formattedTotal: formattedTotal),
      ),
    );
  }

  group('PresetTotalDisplay', () {
    testWidgets('displays total duration', (tester) async {
      await tester.pumpWidget(createTestWidget(formattedTotal: 'TOTAL 01:34'));

      expect(find.byKey(const Key('preset_editor__text-28')), findsOneWidget);
      expect(find.text('TOTAL 01:34'), findsOneWidget);
    });

    testWidgets('displays different total durations', (tester) async {
      await tester.pumpWidget(createTestWidget(formattedTotal: 'TOTAL 10:35'));

      expect(find.text('TOTAL 10:35'), findsOneWidget);
    });

    testWidgets('updates when formattedTotal changes', (tester) async {
      await tester.pumpWidget(createTestWidget(formattedTotal: 'TOTAL 05:00'));
      expect(find.text('TOTAL 05:00'), findsOneWidget);

      // Rebuild with new value
      await tester.pumpWidget(createTestWidget(formattedTotal: 'TOTAL 06:30'));
      expect(find.text('TOTAL 06:30'), findsOneWidget);
      expect(find.text('TOTAL 05:00'), findsNothing);
    });

    testWidgets('displays zero total', (tester) async {
      await tester.pumpWidget(createTestWidget(formattedTotal: 'TOTAL 00:00'));

      expect(find.text('TOTAL 00:00'), findsOneWidget);
    });

    testWidgets('displays large total', (tester) async {
      await tester.pumpWidget(createTestWidget(formattedTotal: 'TOTAL 59:59'));

      expect(find.text('TOTAL 59:59'), findsOneWidget);
    });

    testWidgets('has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget(formattedTotal: 'TOTAL 01:00'));

      expect(find.byKey(const Key('preset_editor__text-28')), findsOneWidget);
    });
  });
}

