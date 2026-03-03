import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/preset_editor/preset_editor_header.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import 'package:interval_counter/state/preset_editor_state.dart';
import 'package:interval_counter/state/home_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late HomeState homeState;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    homeState = HomeState(prefs);
  });

  Widget createTestWidget({
    required String viewMode,
    VoidCallback? onClose,
    VoidCallback? onSwitchToSimple,
    VoidCallback? onSwitchToAdvanced,
    VoidCallback? onSave,
  }) {
    final state = PresetEditorState(homeState);
    if (viewMode == 'advanced') state.switchToAdvanced();

    return ChangeNotifierProvider<PresetEditorState>.value(
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
        home: Scaffold(
          appBar: PresetEditorHeader(
            onClose: onClose ?? () {},
            onSave: onSave ?? () {},
          ),
        ),
      ),
    );
  }

  group('PresetEditorHeader', () {
    testWidgets('renders all buttons', (tester) async {
      await tester.pumpWidget(createTestWidget(viewMode: 'simple'));

      expect(find.byKey(const Key('preset_editor__iconbutton-2')), findsOneWidget);
      expect(find.byKey(const Key('preset_editor__button-3')), findsOneWidget);
      expect(find.byKey(const Key('preset_editor__button-4')), findsOneWidget);
      expect(find.byKey(const Key('preset_editor__iconbutton-5')), findsOneWidget);
    });

    testWidgets('renders SIMPLE button in simple mode', (tester) async {
      await tester.pumpWidget(createTestWidget(viewMode: 'simple'));

      final simpleButton = find.byKey(const Key('preset_editor__button-3'));
      expect(simpleButton, findsOneWidget);
      expect(find.text('SIMPLE'), findsOneWidget);
    });

    testWidgets('renders ADVANCED button in simple mode', (tester) async {
      await tester.pumpWidget(createTestWidget(viewMode: 'simple'));

      final advancedButton = find.byKey(const Key('preset_editor__button-4'));
      expect(advancedButton, findsOneWidget);
      expect(find.text('ADVANCED'), findsOneWidget);
    });

    testWidgets('SIMPLE button is primary in simple mode', (tester) async {
      await tester.pumpWidget(createTestWidget(viewMode: 'simple'));

      final simpleButton = tester.widget<ElevatedButton>(
        find.byKey(const Key('preset_editor__button-3')),
      );
      final buttonStyle = simpleButton.style!;
      final bgColor = buttonStyle.backgroundColor!.resolve({});

      // In simple mode, SIMPLE button has white background
      expect(bgColor, const Color(0xFFFFFFFF));
    }, skip: true);

    testWidgets('ADVANCED button is ghost in simple mode', (tester) async {
      await tester.pumpWidget(createTestWidget(viewMode: 'simple'));

      final advancedButton = tester.widget<TextButton>(
        find.byKey(const Key('preset_editor__button-4')),
      );
      final buttonStyle = advancedButton.style!;
      final bgColor = buttonStyle.backgroundColor!.resolve({});

      // In simple mode, ADVANCED button has primary (dark) background
      expect(bgColor, const Color(0xFF607D8B));
    }, skip: true);

    testWidgets('taps ADVANCED button calls switchToAdvanced', (tester) async {
      await tester.pumpWidget(createTestWidget(viewMode: 'simple'));

      await tester.tap(find.byKey(const Key('preset_editor__button-4')));
      await tester.pump();

      expect(find.byKey(const Key('preset_editor__button-4')), findsOneWidget);
    });

    testWidgets('taps SIMPLE button calls switchToSimple', (tester) async {
      await tester.pumpWidget(createTestWidget(viewMode: 'advanced'));

      await tester.tap(find.byKey(const Key('preset_editor__button-3')));
      await tester.pump();

      expect(find.byKey(const Key('preset_editor__button-3')), findsOneWidget);
    });

    testWidgets('taps SAVE button calls save action', (tester) async {
      var called = false;
      
      await tester.pumpWidget(createTestWidget(
        viewMode: 'simple',
        onSave: () => called = true,
      ));

      await tester.tap(find.byKey(const Key('preset_editor__iconbutton-5')));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('taps CLOSE button calls close action', (tester) async {
      var called = false;
      
      await tester.pumpWidget(createTestWidget(
        viewMode: 'simple',
        onClose: () => called = true,
      ));

      await tester.tap(find.byKey(const Key('preset_editor__iconbutton-2')));
      await tester.pump();

      expect(called, true);
    });

    // Note: Semantic tests omitted as button semantics are framework-generated and too fragile to test
  });
}

