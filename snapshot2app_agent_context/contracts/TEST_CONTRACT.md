# TEST_CONTRACT — Testing Requirements

## Purpose
Define mandatory testing standards for generated Flutter code.
All generated code must be testable and include comprehensive test coverage.
All new code must be tested.

> **Prerequisites:** Code must be generated according to **PROJECT_CONTRACT.md** (Testability & Dependency Injection) and **ARCHITECTURE_CONTRACT.md** (domain layer, service interfaces, State as coordinator).

---

## Pass/Fail Criteria

### Test Coverage Requirements

**MUST achieve:**
- State classes (lib/state/**): **100% line coverage, 100% branch coverage**
- Model classes (lib/models/**): **100% line coverage, 100% branch coverage**
- Generic widgets (lib/widgets/*.dart): **≥90% line coverage**
- Screen-specific widgets (lib/widgets/{screen}/): **≥70% line coverage**
- Screens (lib/screens/): **≥60% line coverage**
- All news components must be tested
- **Overall project: ≥80% line coverage**

**MUST generate tests for:**
- Every component created : states, models, widgets, screens, and other types of dart and flutter components
- Every public method in State classes
- Every validation rule in spec.md
- Every interactive component in plan.md
- All serialization (toJson/fromJson) in Models
- All navigation triggers

**FAIL immediately if:**
- Any State class < 100% coverage (blocks build)
- Any Model class < 100% coverage (blocks build)
- Any interactive component lacks tests (blocks build)
- Overall coverage < 80% (blocks build)
- G-09 guardrail violated (blocks build)

---

## Test Organization and file structure

**MUST mirror lib/ structure:**
```
test/
  state/
    {screen}_state_test.dart          (100% coverage required)
  models/
    {model}_test.dart                 (100% coverage required)
  widgets/
    {screen}/
      {widget}_test.dart              (≥90% coverage target)
  screens/
    {screen}_screen_test.dart         (≥60% coverage target)
```

**MUST:**
- Use descriptive test names: `'should increment when button pressed'`
- Group related tests with `group()` blocks
- Use `setUp()` for common initialization
- Include stable keys on all testable widgets: `Key('{screenId}__{compId}')`
- Keep tests deterministic (no random values, no current time dependencies)
- Test files must mirror lib/ structure 1:1: every .dart file in lib/ must have corresponding *_test.dart file in test/ with identical path structure

**MUST NOT:**
- Mix test types in the same file (separate unit/widget/integration)
- Skip test files for public widgets/screens
- Use hardcoded strings for widget keys (use keys from plan.md)
- Create tests without clear assertions

**Shared Test Helpers:**
- Generate `test/helpers/widget_test_helpers.dart` with common setup functions
- Use `createMockState()`, `createTestApp()` to reduce boilerplate
- All widget tests must import and use shared helpers

---

## Test Types (Auto-Generated)

### 1. State Unit Tests (Priority: CRITICAL)

**For each State class, generate tests for:**

✅ **Initial Values:**
- Test defaults (hardcoded or loaded from persistence)
- Test initial state after construction

✅ **Public Methods:**
- Nominal case: precondition → action → postcondition
- Boundary values: min/max constraints
- Edge cases: empty lists, null handling, validation failures

✅ **State Mutations:**
- Verify `notifyListeners()` is called (use listener mock)
- Verify field values changed correctly
- Verify side effects triggered (persistence, etc.)

✅ **Persistence:**
- Round-trip test: save → load → equals
- Test with missing/corrupted data
- Test with default values

✅ **Computed Properties:**
- Test getters with logic (formatters, calculations, etc.)
- Test conditional properties (canStart, isValid, etc.)

**Example test structure:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:interval_counter/state/example_state.dart';

void main() {
  group('ExampleState', () {
    late ExampleState state;
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      state = ExampleState(mockPrefs);
    });

    test('initial values are correct', () {
      expect(state.counter, 0);
      expect(state.isValid, true);
    });

    test('increment increases counter by 1', () {
      state.increment();
      expect(state.counter, 1);
    });

    test('increment does not exceed maxCounter', () {
      // Set to max
      for (int i = 0; i < 100; i++) {
        state.increment();
      }
      expect(state.counter, ExampleState.maxCounter);
      
      // Try to exceed
      state.increment();
      expect(state.counter, ExampleState.maxCounter);
    });

    test('increment calls notifyListeners', () {
      var notified = false;
      state.addListener(() => notified = true);
      
      state.increment();
      expect(notified, true);
    });
  });
}
```

**Coverage Target:** 100% lines, 100% branches

---

### 2. Domain Unit Tests (Priority: CRITICAL)

**For each Domain class in lib/domain/, generate tests for:**

✅ **Pure Business Logic:**
- All calculations, validators, state transitions
- Boundary conditions, edge cases
- No side effects (no I/O, no async)

✅ **Performance:**
- Tests must be ultra-fast (<1ms per test)
- No Flutter dependencies (pure Dart)

**Example test structure:**
```dart
import 'package:test/test.dart';
import 'package:interval_counter/domain/workout_engine.dart';

void main() {
  group('WorkoutEngine', () {
    test('tick decrements remaining time', () {
      final engine = WorkoutEngine(preset: testPreset);
      final initial = engine.remainingTime;
      
      engine.tick();
      
      expect(engine.remainingTime, initial - 1);
    });
    
    test('shouldPlayBeep is true when time <= 3', () {
      final engine = WorkoutEngine(preset: testPreset);
      engine.remainingTime = 3;
      
      expect(engine.shouldPlayBeep, true);
    });
  });
}
```

**Coverage Target:** 100% lines, 100% branches

---

### 3. Service Implementation Tests (Priority: HIGH)

**For each service implementation in lib/services/impl/, generate tests for:**

✅ **Integration with real dependencies:**
- Test actual behavior (e.g., Timer fires, Sound plays)
- Mock external systems only (filesystem, network)

✅ **Interface compliance:**
- Verify all interface methods implemented
- Verify contract behavior

**Example:**
```dart
testWidgets('SystemAudioService plays sound', (tester) async {
  final service = SystemAudioService();
  
  // Test doesn't crash (actual sound requires device)
  expect(() => service.playBeep(), returnsNormally);
});
```

**Coverage Target:** ≥80% lines

---

### 4. Model Unit Tests (Priority: CRITICAL)

**For each Model class, generate tests for:**

✅ **Serialization:**
- Valid JSON → fromJson → toJson → equals original JSON
- Missing optional fields → default values
- Invalid types → exception or graceful fallback

✅ **Immutability:**
- copyWith with null params → unchanged fields
- copyWith with values → only specified fields change

✅ **Equality:**
- Two instances with same values → equals true
- Same instances → same hashCode
- Different values → equals false

✅ **toString:**
- Verify format for debugging

**Example test structure:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/models/preset.dart';

void main() {
  group('Preset', () {
    test('fromJson creates valid object', () {
      final json = {
        'id': '123',
        'name': 'Test',
        'reps': 16,
        'workSeconds': 44,
        'restSeconds': 15,
      };
      
      final preset = Preset.fromJson(json);
      
      expect(preset.id, '123');
      expect(preset.name, 'Test');
      expect(preset.reps, 16);
    });

    test('toJson returns correct map', () {
      final preset = Preset(
        id: '123',
        name: 'Test',
        reps: 16,
        workSeconds: 44,
        restSeconds: 15,
      );
      
      final json = preset.toJson();
      
      expect(json['id'], '123');
      expect(json['name'], 'Test');
      expect(json['reps'], 16);
    });

    test('copyWith changes only specified fields', () {
      final preset = Preset(id: '123', name: 'Test', reps: 16, workSeconds: 44, restSeconds: 15);
      final updated = preset.copyWith(name: 'Updated');
      
      expect(updated.id, '123'); // unchanged
      expect(updated.name, 'Updated'); // changed
      expect(updated.reps, 16); // unchanged
    });

    test('equality works correctly', () {
      final preset1 = Preset(id: '123', name: 'Test', reps: 16, workSeconds: 44, restSeconds: 15);
      final preset2 = Preset(id: '123', name: 'Test', reps: 16, workSeconds: 44, restSeconds: 15);
      
      expect(preset1, equals(preset2));
      expect(preset1.hashCode, equals(preset2.hashCode));
    });
  });
}
```

**Coverage Target:** 100% lines, 100% branches

---

### 5. Widget Tests (Priority: HIGH)

**For each interactive component in plan.md, generate:**

✅ **Rendering:**
- Widget renders with correct key
- Widget displays correct data from State

✅ **Interaction:**
- Tapping/dragging triggers correct State method
- Callback parameters are correct

✅ **State Integration:**
- Widget updates when State changes (via Provider)
- Enabled/disabled states work correctly

❌ **Do not create semantic tests**

**Example test structure:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/widgets/value_control.dart';
import 'package:interval_counter/state/example_state.dart';

void main() {
  group('ValueControl', () {
    Widget createTestWidget(ExampleState state) {
      return ChangeNotifierProvider.value(
        value: state,
        child: MaterialApp(
          home: Scaffold(
            body: ValueControl(
              label: 'RÉPÉTITIONS',
              value: state.counter.toString(),
              onDecrease: state.decrement,
              onIncrease: state.increment,
              decreaseKey: 'test__decrease',
              valueKey: 'test__value',
              increaseKey: 'test__increase',
            ),
          ),
        ),
      );
    }

    testWidgets('renders with correct keys', (tester) async {
      final state = ExampleState(MockSharedPreferences());
      await tester.pumpWidget(createTestWidget(state));

      expect(find.byKey(const Key('test__decrease')), findsOneWidget);
      expect(find.byKey(const Key('test__value')), findsOneWidget);
      expect(find.byKey(const Key('test__increase')), findsOneWidget);
    });

    testWidgets('increment button calls onIncrease', (tester) async {
      final state = ExampleState(MockSharedPreferences());
      await tester.pumpWidget(createTestWidget(state));

      final initialValue = state.counter;
      await tester.tap(find.byKey(const Key('test__increase')));
      await tester.pumpAndSettle();

      expect(state.counter, initialValue + 1);
    });

    testWidgets('displays correct value from state', (tester) async {
      final state = ExampleState(MockSharedPreferences());
      state.setCounter(42);
      await tester.pumpWidget(createTestWidget(state));

      expect(find.text('42'), findsOneWidget);
    });
  });
}
```

**Coverage Target:** ≥90% for generic widgets, ≥70% for screen-specific widgets

---

### 6. Screen Integration Tests (Priority: MEDIUM)

**For each screen, generate:**

✅ **Component Presence:**
- All key components present (by Key from plan.md)
- Main sections visible

✅ **User Flow:**
- One critical flow from spec.md scenarios
- Example: increment → display updates → save works

✅ **Navigation:**
- Navigation triggers work
- Back button navigation works

✅ **Provider Integration:**
- Screen consumes State correctly via Provider
- State updates trigger UI updates

**Example test structure:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/screens/home_screen.dart';
import 'package:interval_counter/state/home_state.dart';

void main() {
  group('HomeScreen Integration Tests', () {
    Widget createTestWidget() {
      return ChangeNotifierProvider(
        create: (_) => HomeState(MockSharedPreferences()),
        child: const MaterialApp(home: HomeScreen()),
      );
    }

    testWidgets('all main components are present', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home__button_start')), findsOneWidget);
      expect(find.byKey(const Key('home__slider_volume')), findsOneWidget);
      expect(find.byKey(const Key('home__card_quick_start')), findsOneWidget);
    });

    testWidgets('user can increment reps and see update', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('16'), findsOneWidget);

      await tester.tap(find.byKey(const Key('home__button_increment_reps')));
      await tester.pumpAndSettle();

      expect(find.text('17'), findsOneWidget);
    });
  });
}
```

**Coverage Target:** ≥60% lines

---

## Test Generation Process

### In 04_BUILD_SCREEN.prompt, Step 10:

**After generating all lib/ files:**

1. **Parse plan.md § Test Generation Plan** (if present)
2. **Generate Domain tests** for each Domain class (lib/domain/):
   - Pure Dart tests (no Flutter)
   - 100% coverage required
   - Ultra-fast tests
3. **Generate Service tests** for each service implementation (lib/services/impl/):
   - Integration tests with real dependencies
   - ≥80% coverage
4. **Generate State tests** for each State class:
   - Extract all public methods
   - Generate test for each method (nominal + boundaries)
   - Generate persistence tests
   - Generate notifyListeners tests
5. **Generate Model tests** for each Model class:
   - Generate fromJson/toJson round-trip tests
   - Generate copyWith tests
   - Generate equality tests
6. **Generate Widget tests** for interactive components:
   - Extract from plan.md widget breakdown
   - Filter components with keys
   - Generate render + interaction tests
7. **Generate Screen integration test**:
   - Verify all key components present
   - Test one critical flow

**Verification:**
- Run `flutter test --coverage`
- Parse `coverage/lcov.info`
- Verify thresholds met
- If fails → emit error with gaps

---

## Verification Checklist

Before marking tests as complete:

- [ ] All Domain classes have tests (100% coverage)
- [ ] All Service implementations have tests (≥80% coverage)
- [ ] All State methods have tests (100% coverage)
- [ ] All Models have serialization tests (100% coverage)
- [ ] All interactive components (from plan.md) have widget tests
- [ ] Screen integration test covers main flow
- [ ] Golden tests exist for styled components (if applicable)
- [ ] `flutter test --coverage/lcov.info --output-directory coverage/html` succeeds (exit code 0)
- [ ] Coverage thresholds met:
  - [ ] Domain: 100%
  - [ ] State: 100%
  - [ ] Model: 100%
  - [ ] Services: ≥80%
  - [ ] Overall: ≥80%
- [ ] No untested public methods in State
- [ ] test_report.md generated with coverage stats

---

## Acceptance Criteria

✅ **PASS** if:
- All test files generated in correct structure
- `flutter test` exit code == 0
- Coverage ≥ 80% overall
- State coverage == 100%
- Model coverage == 100%
- All plan.md interactive components tested
- G-09 guardrail satisfied

❌ **FAIL** if:
- Any test file missing for State/Model
- Any test failure
- Coverage < thresholds
- Untested State methods
- Untested interactive components

---

## Assumptions

**Tests assume the generated code follows:**
- ✅ ARCHITECTURE_CONTRACT.md (domain layer, service interfaces, State as coordinator)
- ✅ PROJECT_CONTRACT.md State pattern (DI, getters, notifyListeners)
- ✅ PROJECT_CONTRACT.md Widget pattern (keys, callbacks via params)
- ✅ PROJECT_CONTRACT.md Testability rules (dual constructors, pure logic)
- ✅ UI_MAPPING_GUIDE.md stable keys (for find.byKey())

**If code violates these contracts:**
→ Tests will fail
→ Fix code first (not tests)
→ Re-run test generation

---

## Best practices
**Use specific test data** - avoid duplicate values that can cause test ambiguity
- **Set proper locale** - always use `locale: const Locale('fr')` for French localization in tests
**Avoid fragile tests**: No tests for framework-generated semantics

---

## Exemptions

**Allow <80% coverage for:**
- `main.dart` (app entry point - test in integration)
- Generated code (if any)
- Purely decorative widgets with no logic or interaction
  - Must be marked in plan.md as `testPriority: none`
  - Rationale required in plan

**Never exempt:**
- State classes
- Models
- Interactive widgets
- Navigation logic
- Validation logic

---

## See Also
- `contracts/PROJECT_CONTRACT.md` — Architecture patterns
- `guides/BEST_PRACTICES.md` — Common pitfalls to avoid
- `guides/UI_MAPPING_GUIDE.md` — UI rendering rules
