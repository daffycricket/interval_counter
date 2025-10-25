import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_counter/widgets/workout/pause_button.dart';
import 'package:interval_counter/state/workout_state.dart';
import 'package:interval_counter/models/preset.dart';

void main() {
  group('PauseButton Widget Tests', () {
    late SharedPreferences prefs;
    late Preset testPreset;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      
      testPreset = Preset.create(
        name: 'Test',
        prepareSeconds: 5,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 10,
      );
    });

    Widget createTestWidget(WorkoutState state) {
      return ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(
          home: Scaffold(
            body: PauseButton(),
          ),
        ),
      );
    }

    testWidgets('renders with correct key', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.byKey(const Key('workout__iconbutton-4')), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('shows play icon when paused', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer(); // Start paused
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('shows pause icon when playing', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      state.startTimer(); // Start playing
      
      await tester.pumpWidget(createTestWidget(state));
      await tester.pump();
      
      expect(find.byIcon(Icons.pause), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('tap toggles pause state', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      expect(state.isPaused, true);
      
      await tester.pumpWidget(createTestWidget(state));
      
      await tester.tap(find.byKey(const Key('workout__iconbutton-4')));
      await tester.pump();
      
      expect(state.isPaused, false);
      expect(find.byIcon(Icons.pause), findsOneWidget);
      
      await tester.tap(find.byKey(const Key('workout__iconbutton-4')));
      await tester.pump();
      
      expect(state.isPaused, true);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('FAB has correct background color', (tester) async {
      final state = WorkoutState(prefs, testPreset);
      state.stopTimer();
      
      await tester.pumpWidget(createTestWidget(state));
      
      final fab = tester.widget<FloatingActionButton>(
        find.byKey(const Key('workout__iconbutton-4')),
      );
      
      expect(fab.backgroundColor, isNotNull);
      
      state.dispose();
    });
  });
}

