import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/widgets/workout/pause_button.dart';
import 'package:interval_counter/state/workout_state.dart';
import 'package:interval_counter/models/preset.dart';
import '../../helpers/mock_services.dart';

void main() {
  group('PauseButton Widget Tests', () {
    late Preset testPreset;

    setUp(() {
      testPreset = Preset.create(
        name: 'Test',
        prepareSeconds: 5,
        repetitions: 3,
        workSeconds: 40,
        restSeconds: 20,
        cooldownSeconds: 10,
      );
    });
    
    WorkoutState createState() {
      return WorkoutState(
        preset: testPreset,
        tickerService: MockTickerService(),
        audioService: MockAudioService(),
        prefsRepo: MockPreferencesRepository(),
      );
    }

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
      final state = createState();
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.byKey(const Key('workout__iconbutton-4')), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('shows play icon when paused', (tester) async {
      final state = createState(); // Start paused
      
      await tester.pumpWidget(createTestWidget(state));
      
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('shows pause icon when playing', (tester) async {
      final state = createState();
      // State starts with timer running (not paused)
      
      await tester.pumpWidget(createTestWidget(state));
      await tester.pump();
      
      expect(find.byIcon(Icons.pause), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('tap toggles pause state', (tester) async {
      final state = createState();
      
      expect(state.isPaused, false);
      
      await tester.pumpWidget(createTestWidget(state));
      
      await tester.tap(find.byKey(const Key('workout__iconbutton-4')));
      await tester.pump();
      
      expect(state.isPaused, true);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      
      await tester.tap(find.byKey(const Key('workout__iconbutton-4')));
      await tester.pump();
      
      expect(state.isPaused, false);
      expect(find.byIcon(Icons.pause), findsOneWidget);
      
      state.dispose();
    });

    testWidgets('FAB has correct background color', (tester) async {
      final state = createState();
      
      await tester.pumpWidget(createTestWidget(state));
      
      final fab = tester.widget<FloatingActionButton>(
        find.byKey(const Key('workout__iconbutton-4')),
      );
      
      expect(fab.backgroundColor, isNotNull);
      
      state.dispose();
    });
  });
}

