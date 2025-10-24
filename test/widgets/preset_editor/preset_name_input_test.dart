import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/preset_editor/preset_name_input.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  Widget createTestWidget({
    String? name,
    ValueChanged<String>? onNameChange,
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
        body: PresetNameInput(
          name: name ?? '',
          onNameChange: onNameChange ?? (_) {},
        ),
      ),
    );
  }

  group('PresetNameInput', () {
    testWidgets('renders name input field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byKey(const Key('preset_editor__input-6')), findsOneWidget);
    });

    testWidgets('displays initial name', (tester) async {
      await tester.pumpWidget(createTestWidget(name: 'Test Name'));

      final textField = tester.widget<TextField>(
        find.byKey(const Key('preset_editor__input-6')),
      );
      expect(textField.controller!.text, 'Test Name');
    });

    testWidgets('displays empty when no initial name', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final textField = tester.widget<TextField>(
        find.byKey(const Key('preset_editor__input-6')),
      );
      expect(textField.controller!.text, '');
    });

    testWidgets('enters text "Test" calls onNameChange', (tester) async {
      String? capturedName;
      
      await tester.pumpWidget(createTestWidget(
        onNameChange: (name) => capturedName = name,
      ));

      await tester.enterText(
        find.byKey(const Key('preset_editor__input-6')),
        'Test',
      );
      await tester.pump();

      expect(capturedName, 'Test');
    });

    testWidgets('enters multiple texts calls onNameChange each time', (tester) async {
      final capturedNames = <String>[];
      
      await tester.pumpWidget(createTestWidget(
        onNameChange: (name) => capturedNames.add(name),
      ));

      final input = find.byKey(const Key('preset_editor__input-6'));
      
      await tester.enterText(input, 'Test');
      await tester.pump();
      
      await tester.enterText(input, 'Test 2');
      await tester.pump();

      expect(capturedNames, ['Test', 'Test 2']);
    });

    testWidgets('has correct placeholder', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final textField = tester.widget<TextField>(
        find.byKey(const Key('preset_editor__input-6')),
      );
      
      expect(textField.decoration!.hintText, 'Nom prédéfini');
    });

    testWidgets('has correct semantic label', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final input = find.byKey(const Key('preset_editor__input-6'));
      
      expect(
        tester.getSemantics(input),
        matchesSemantics(
          label: 'Nom prédéfini',
          isTextField: true,
        ),
      );
    });

    testWidgets('accepts empty text', (tester) async {
      String? capturedName;
      
      await tester.pumpWidget(createTestWidget(
        name: 'Initial',
        onNameChange: (name) => capturedName = name,
      ));

      await tester.enterText(
        find.byKey(const Key('preset_editor__input-6')),
        '',
      );
      await tester.pump();

      expect(capturedName, '');
    });

    testWidgets('accepts long text', (tester) async {
      String? capturedName;
      const longText = 'This is a very long preset name that might wrap';
      
      await tester.pumpWidget(createTestWidget(
        onNameChange: (name) => capturedName = name,
      ));

      await tester.enterText(
        find.byKey(const Key('preset_editor__input-6')),
        longText,
      );
      await tester.pump();

      expect(capturedName, longText);
    });
  });
}

