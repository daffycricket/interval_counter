import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/state/interval_timer_home_state.dart';
import 'package:interval_counter/widgets/home/quick_start_card.dart';

/// T1: Tester l'incrémentation des répétitions
void main() {
  testWidgets('T1 - Increment repetitions increments the value by 1', (WidgetTester tester) async {
    final state = IntervalTimerHomeState();
    
    // État initial: 16 répétitions
    expect(state.repetitions, 16);

    await tester.pumpWidget(
      ChangeNotifierProvider<IntervalTimerHomeState>.value(
        value: state,
        child: MaterialApp(
          home: Scaffold(
            body: Consumer<IntervalTimerHomeState>(
              builder: (context, homeState, _) {
                return QuickStartCard(
                  isExpanded: true,
                  onToggleExpanded: () {},
                  repetitions: homeState.repetitions,
                  workTime: homeState.formattedWorkTime,
                  restTime: homeState.formattedRestTime,
                  onIncrementReps: homeState.incrementReps,
                  onDecrementReps: homeState.decrementReps,
                  onIncrementWork: homeState.incrementWork,
                  onDecrementWork: homeState.decrementWork,
                  onIncrementRest: homeState.incrementRest,
                  onDecrementRest: homeState.decrementRest,
                  canIncrementReps: homeState.canIncrementReps,
                  canDecrementReps: homeState.canDecrementReps,
                  canIncrementWork: homeState.canIncrementWork,
                  canDecrementWork: homeState.canDecrementWork,
                  canIncrementRest: homeState.canIncrementRest,
                  canDecrementRest: homeState.canDecrementRest,
                  onSavePreset: () {},
                  onStartInterval: () {},
                  isStartEnabled: true,
                );
              },
            ),
          ),
        ),
      ),
    );

    // Trouver le bouton d'incrémentation des répétitions
    final incrementButton = find.byKey(const Key('interval_timer_home__IconButton-13'));
    expect(incrementButton, findsOneWidget);

    // Trouver le texte de valeur
    final valueText = find.byKey(const Key('interval_timer_home__Text-12'));
    expect(valueText, findsOneWidget);
    expect(find.text('16'), findsOneWidget);

    // Taper sur le bouton d'incrémentation
    await tester.tap(incrementButton);
    await tester.pumpAndSettle();

    // Vérifier que la valeur a été incrémentée
    expect(state.repetitions, 17);
    expect(find.text('17'), findsOneWidget);
  });
}
