import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/preset_editor/preset_params_panel.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  // Helper pour formater le temps
  String formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')} : ${secs.toString().padLeft(2, '0')}';
  }

  Widget createTestWidget({
    required int prepareSeconds,
    required int repetitions,
    required int workSeconds,
    required int restSeconds,
    required int cooldownSeconds,
    VoidCallback? onIncrementPrepare,
    VoidCallback? onDecrementPrepare,
    VoidCallback? onIncrementReps,
    VoidCallback? onDecrementReps,
    VoidCallback? onIncrementWork,
    VoidCallback? onDecrementWork,
    VoidCallback? onIncrementRest,
    VoidCallback? onDecrementRest,
    VoidCallback? onIncrementCooldown,
    VoidCallback? onDecrementCooldown,
  }) {
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
        body: PresetParamsPanel(
          prepareSeconds: prepareSeconds,
          repetitions: repetitions,
          workSeconds: workSeconds,
          restSeconds: restSeconds,
          cooldownSeconds: cooldownSeconds,
          formattedPrepareTime: formatTime(prepareSeconds),
          formattedWorkTime: formatTime(workSeconds),
          formattedRestTime: formatTime(restSeconds),
          formattedCooldownTime: formatTime(cooldownSeconds),
          onIncrementPrepare: onIncrementPrepare ?? () {},
          onDecrementPrepare: onDecrementPrepare ?? () {},
          onIncrementReps: onIncrementReps ?? () {},
          onDecrementReps: onDecrementReps ?? () {},
          onIncrementWork: onIncrementWork ?? () {},
          onDecrementWork: onDecrementWork ?? () {},
          onIncrementRest: onIncrementRest ?? () {},
          onDecrementRest: onDecrementRest ?? () {},
          onIncrementCooldown: onIncrementCooldown ?? () {},
          onDecrementCooldown: onDecrementCooldown ?? () {},
        ),
      ),
    );
  }

  group('PresetParamsPanel', () {
    testWidgets('renders PRÉPARER label', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
      ));

      expect(find.text('PRÉPARER'), findsOneWidget);
    });

    testWidgets('renders RÉPÉTITIONS label', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
      ));

      expect(find.text('RÉPÉTITIONS'), findsOneWidget);
    });

    testWidgets('renders TRAVAIL label', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
      ));

      expect(find.text('TRAVAIL'), findsOneWidget);
    });

    testWidgets('renders REPOS label', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
      ));

      expect(find.text('REPOS'), findsOneWidget);
    });

    testWidgets('renders REFROIDIR label', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
      ));

      expect(find.text('REFROIDIR'), findsOneWidget);
    });

    testWidgets('displays prepare value as formatted time', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
      ));

      expect(find.byKey(const Key('preset_editor__text-10')), findsOneWidget);
      expect(find.text('00 : 05'), findsOneWidget);
    });

    testWidgets('displays reps value', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 1,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
      ));

      expect(find.byKey(const Key('preset_editor__text-14')), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('displays work time as formatted time', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 89,
        restSeconds: 20,
        cooldownSeconds: 30,
      ));

      expect(find.byKey(const Key('preset_editor__text-18')), findsOneWidget);
      expect(find.text('01 : 29'), findsOneWidget);
    });

    testWidgets('displays rest time as formatted time', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 25,
        cooldownSeconds: 30,
      ));

      expect(find.byKey(const Key('preset_editor__text-22')), findsOneWidget);
      expect(find.text('00 : 25'), findsOneWidget);
    });

    testWidgets('displays cooldown time as formatted time', (tester) async {
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 0,
      ));

      expect(find.byKey(const Key('preset_editor__text-26')), findsOneWidget);
      expect(find.text('00 : 00'), findsOneWidget);
    });

    testWidgets('taps decrement prepare calls decrementPrepare', (tester) async {
      var called = false;
      
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
        onDecrementPrepare: () => called = true,
      ));

      await tester.tap(find.byKey(const Key('preset_editor__iconbutton-9')));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('taps increment prepare calls incrementPrepare', (tester) async {
      var called = false;
      
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
        onIncrementPrepare: () => called = true,
      ));

      await tester.tap(find.byKey(const Key('preset_editor__iconbutton-11')));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('taps decrement reps calls decrementReps', (tester) async {
      var called = false;
      
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
        onDecrementReps: () => called = true,
      ));

      await tester.tap(find.byKey(const Key('preset_editor__iconbutton-13')));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('taps increment reps calls incrementReps', (tester) async {
      var called = false;
      
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
        onIncrementReps: () => called = true,
      ));

      await tester.tap(find.byKey(const Key('preset_editor__iconbutton-15')));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('taps decrement work calls decrementWork', (tester) async {
      var called = false;
      
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
        onDecrementWork: () => called = true,
      ));

      await tester.tap(find.byKey(const Key('preset_editor__iconbutton-17')));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('taps increment work calls incrementWork', (tester) async {
      var called = false;
      
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
        onIncrementWork: () => called = true,
      ));

      await tester.tap(find.byKey(const Key('preset_editor__iconbutton-19')));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('taps decrement rest calls decrementRest', (tester) async {
      var called = false;
      
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
        onDecrementRest: () => called = true,
      ));

      await tester.tap(find.byKey(const Key('preset_editor__iconbutton-21')));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('taps increment rest calls incrementRest', (tester) async {
      var called = false;
      
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
        onIncrementRest: () => called = true,
      ));

      await tester.tap(find.byKey(const Key('preset_editor__iconbutton-23')));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('taps decrement cooldown calls decrementCooldown', (tester) async {
      var called = false;
      
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
        onDecrementCooldown: () => called = true,
      ));

      await tester.tap(find.byKey(const Key('preset_editor__iconbutton-25')));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('taps increment cooldown calls incrementCooldown', (tester) async {
      var called = false;
      
      await tester.pumpWidget(createTestWidget(
        prepareSeconds: 5,
        repetitions: 10,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 30,
        onIncrementCooldown: () => called = true,
      ));

      await tester.tap(find.byKey(const Key('preset_editor__iconbutton-27')));
      await tester.pump();

      expect(called, true);
    });

    // Note: Tests for disabled buttons at minimum values are covered by State tests
  });
}

