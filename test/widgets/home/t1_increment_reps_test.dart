import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/screens/interval_timer_home_screen.dart';
import 'package:interval_counter/state/interval_timer_home_state.dart';
import 'package:interval_counter/state/presets_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('T1: Incrémenter les répétitions (16 → 17)', (WidgetTester tester) async {
    // Arrange: Mock SharedPreferences
    SharedPreferences.setMockInitialValues({
      'reps': 16,
      'workSeconds': 44,
      'restSeconds': 15,
      'volume': 0.62,
      'quickStartExpanded': true,
    });

    final homeState = IntervalTimerHomeState();
    final presetsState = PresetsState();

    // Attendre que l'état soit chargé
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<IntervalTimerHomeState>.value(value: homeState),
          ChangeNotifierProvider<PresetsState>.value(value: presetsState),
        ],
        child: const MaterialApp(
          home: IntervalTimerHomeScreen(),
        ),
      ),
    );

    // Pump initial frame
    await tester.pump();

    // Attendre que l'état soit stable
    await tester.pump(const Duration(milliseconds: 500));

    // Vérifie la valeur initiale
    expect(find.text('16'), findsOneWidget);
    expect(homeState.reps, 16);

    // Act: Tap sur le bouton d'incrémentation
    final incrementButton = find.byKey(const Key('interval_timer_home__IconButton-13'));
    expect(incrementButton, findsOneWidget);

    await tester.tap(incrementButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Assert: La valeur doit être 17
    expect(find.text('17'), findsOneWidget);
    expect(homeState.reps, 17);
  });
}

