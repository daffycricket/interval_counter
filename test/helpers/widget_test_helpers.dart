import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import 'package:interval_counter/state/interval_timer_home_state.dart';

/// Create a mock state with default values for testing
/// Note: This must be called from an async test function
Future<IntervalTimerHomeState> createMockState() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return IntervalTimerHomeState(prefs);
}

/// Wraps widget in MaterialApp + Provider for testing
Widget createTestApp(IntervalTimerHomeState state, Widget child) {
  return ChangeNotifierProvider.value(
    value: state,
    child: MaterialApp(
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
      home: Scaffold(body: child),
    ),
  );
}

/// Helper function to pump a widget for testing
Future<void> pumpTestWidget(
  WidgetTester tester,
  Widget widget,
) async {
  final state = await createMockState();
  await tester.pumpWidget(createTestApp(state, widget));
  await tester.pumpAndSettle();
}

/// Create a mock SharedPreferences with initial values
Future<SharedPreferences> createMockPrefs([Map<String, Object>? values]) async {
  SharedPreferences.setMockInitialValues(values ?? {});
  return await SharedPreferences.getInstance();
}

/// Helper to find a widget by its Key string
Finder findByKeyString(String keyString) {
  return find.byKey(Key(keyString));
}

/// Helper to verify a widget exists with a specific key
void expectWidgetWithKey(String keyString) {
  expect(findByKeyString(keyString), findsOneWidget);
}

/// Helper to tap a widget by its key string
Future<void> tapByKey(WidgetTester tester, String keyString) async {
  await tester.tap(findByKeyString(keyString));
  await tester.pumpAndSettle();
}

/// Helper to verify text exists on screen
void expectText(String text) {
  expect(find.text(text), findsOneWidget);
}

/// Helper to verify semantic label
void expectSemanticLabel(WidgetTester tester, String keyString, String label) {
  final semantics = tester.getSemantics(findByKeyString(keyString));
  expect(semantics.label, label);
}
