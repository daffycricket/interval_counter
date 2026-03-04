import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/screens/preset_editor_screen.dart';
import 'package:interval_counter/state/preset_editor_state.dart';
import 'package:interval_counter/state/home_state.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import '../helpers/mock_services.dart';

void main() {
  late HomeState homeState;

  setUp(() {
    homeState = HomeState(MockPreferencesRepository());
  });

  Widget createTestWidget(PresetEditorState editorState) {
    return ChangeNotifierProvider.value(
      value: editorState,
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      supportedLocales: const [Locale('fr'), Locale('en')],
      locale: const Locale('fr'),
      home: const PresetEditorScreen(),
      ),
    );
  }

  group('PresetEditorScreen', () {
    testWidgets('renders all main components', (tester) async {
      final editorState = PresetEditorState(homeState);

      await tester.pumpWidget(createTestWidget(editorState));

      // Header buttons
      expect(find.byKey(const Key('preset_editor__iconbutton-2')), findsOneWidget); // Close
      expect(find.byKey(const Key('preset_editor__button-3')), findsOneWidget); // SIMPLE
      expect(find.byKey(const Key('preset_editor__button-4')), findsOneWidget); // ADVANCED
      expect(find.byKey(const Key('preset_editor__iconbutton-5')), findsOneWidget); // Save

      // Name input
      expect(find.byKey(const Key('preset_editor__input-6')), findsOneWidget);

      // Simple mode panel visible by default
      expect(find.byKey(const Key('preset_editor__container-7')), findsOneWidget);

      // Total display
      expect(find.byKey(const Key('preset_editor__text-28')), findsOneWidget);
    });

    testWidgets('displays SAVE button', (tester) async {
      final editorState = PresetEditorState(homeState);

      await tester.pumpWidget(createTestWidget(editorState));

      final saveButton = find.byKey(const Key('preset_editor__iconbutton-5'));
      expect(saveButton, findsOneWidget);
    });

    testWidgets('taps CLOSE button navigates back', (tester) async {
      final editorState = PresetEditorState(homeState);

      await tester.pumpWidget(createTestWidget(editorState));

      final closeButton = find.byKey(const Key('preset_editor__iconbutton-2'));
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      // Screen should pop
      expect(find.byType(PresetEditorScreen), findsNothing);
    });

    testWidgets('displays initial total correctly', (tester) async {
      final editorState = PresetEditorState(homeState);

      await tester.pumpWidget(createTestWidget(editorState));

      // Default: 5 + 10*(40+20) + 30 = 635 = 10:35
      expect(find.text('TOTAL 10:35'), findsOneWidget);
    });

    testWidgets('switches to advanced mode hides params panel', (tester) async {
      final editorState = PresetEditorState(homeState);

      await tester.pumpWidget(createTestWidget(editorState));

      // Initially simple mode
      expect(find.byKey(const Key('preset_editor__container-7')), findsOneWidget);

      // Tap ADVANCED
      await tester.tap(find.byKey(const Key('preset_editor__button-4')));
      await tester.pumpAndSettle();

      // Params panel should be hidden, placeholder visible
      expect(find.byKey(const Key('preset_editor__container-7')), findsNothing);
      expect(find.text('Mode avancé - À venir'), findsOneWidget);
    });

    testWidgets('save with empty name shows error', (tester) async {
      final editorState = PresetEditorState(homeState);

      await tester.pumpWidget(createTestWidget(editorState));

      // Tap save without entering name
      await tester.tap(find.byKey(const Key('preset_editor__iconbutton-5')));
      await tester.pumpAndSettle();

      // Error should be shown
      expect(find.text('Exception: Veuillez saisir un nom'), findsOneWidget);
    });

    testWidgets('save with valid name closes screen', (tester) async {
      final editorState = PresetEditorState(homeState, initialName: 'Test Preset');

      await tester.pumpWidget(createTestWidget(editorState));

      // Tap save
      await tester.tap(find.byKey(const Key('preset_editor__iconbutton-5')));
      await tester.pumpAndSettle();

      // Screen should close
      expect(find.byType(PresetEditorScreen), findsNothing);

      // Preset should be saved in homeState
      expect(homeState.presets.length, 1);
      expect(homeState.presets[0].name, 'Test Preset');
    });
  });
}

