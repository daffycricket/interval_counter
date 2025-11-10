# ARCHITECTURE_CONTRACT — Clean Architecture & Layered Design

## Purpose
Define architectural patterns ensuring loose coupling, testability, and maintainability.
State classes must be thin coordinators, not implementation holders.

---

## 1. Dependency Inversion Principle (DIP)

### Core Rule
**State classes MUST NOT depend on concrete Flutter framework classes for external services.**

❌ **PROHIBITED in State:**
- `Timer.periodic()` — use `TickerService` interface
- `SystemSound.play()` — use `AudioService` interface
- `HapticFeedback.vibrate()` — use `HapticsService` interface
- `http.Client()` — use `ApiClient` interface
- Platform channels — use service abstraction

✅ **ALLOWED in State:**
- `ChangeNotifier` (base class for state management)
- Pure Dart types (int, String, List, Map, DateTime)
- Domain classes (lib/domain/)
- Service interfaces (lib/services/)

### Service Interface Pattern

**When State needs external dependency:**
1. Create abstract interface: `lib/services/{service_name}.dart`
2. Create implementation: `lib/services/impl/{service_name}_impl.dart`
3. State constructor accepts interface only

**Example:**
```dart
// lib/services/audio_service.dart
abstract class AudioService {
  void playBeep();
  void setVolume(double volume);
}

// lib/services/impl/system_audio_service.dart
class SystemAudioService implements AudioService {
  @override
  void playBeep() => SystemSound.play(SystemSoundType.click);
}

// State uses interface
class MyState extends ChangeNotifier {
  final AudioService _audio;
  MyState(this._audio);
  
  void onCountdownEnd() => _audio.playBeep();
}
```

---

## 2. Domain Layer (Pure Business Logic)

### Extraction Rule
**Business logic >50 lines OR complex calculations MUST be extracted to domain layer.**

**Domain classes characteristics:**
- Pure Dart (no `package:flutter` imports, except `foundation` for immutability)
- No side effects (I/O, navigation, notifications)
- Deterministic (same input → same output)
- 100% unit testable (<1ms per test)

**File organization:**
- `lib/domain/{feature}_engine.dart` — state machines, workflows
- `lib/domain/{feature}_calculator.dart` — pure functions, computations
- `lib/domain/{feature}_validator.dart` — business rules, constraints

**Example:**
```dart
// lib/domain/workout_engine.dart
class WorkoutEngine {
  StepType currentStep;
  int remainingTime;
  
  bool get shouldPlayBeep => remainingTime <= 3 && remainingTime > 0;
  
  void tick() {
    if (remainingTime > 0) {
      remainingTime--;
    } else {
      nextStep();
    }
  }
  
  void nextStep() { /* pure state transition logic */ }
}
```

---

## 3. State as Thin Coordinator

### Responsibility
**State = orchestrate domain logic + services, expose UI-ready data.**

✅ **State SHOULD:**
- Inject domain classes and service interfaces
- Delegate business logic to domain layer
- Coordinate calls to services (audio, persistence, etc.)
- Transform domain data for UI (formatters, computed properties)
- Call `notifyListeners()` after state changes
- Be <200 lines of code
- Have ≤5 constructor dependencies

❌ **State SHOULD NOT:**
- Implement complex business logic (extract to domain)
- Directly call platform APIs (use services)
- Perform I/O operations inline (delegate to repositories)
- Contain >50 lines methods (extract pure functions)

**Example:**
```dart
class WorkoutState extends ChangeNotifier {
  final WorkoutEngine _engine;
  final AudioService _audio;
  final PreferencesRepository _prefs;
  
  WorkoutState(this._engine, this._audio, this._prefs);
  
  String get formattedTime => _formatTime(_engine.remainingTime);
  
  void tick() {
    _engine.tick();  // Delegate to domain
    if (_engine.shouldPlayBeep) {
      _audio.playBeep();  // Delegate to service
    }
    notifyListeners();
  }
  
  String _formatTime(int seconds) { /* simple formatting */ }
}
```

---

## 4. Localization in State

### Core Rule
**State classes MUST NOT return localized strings.**

❌ **PROHIBITED:**
```dart
class MyCustomState extends ChangeNotifier {
  String get specificLabel {
    switch (currentStatus) {
      case StatusType.active: return 'ACTIF'; // Hardcoded French!
    }
  }
}
```

✅ **CORRECT:**
```dart
// State returns enum/primitive
class MyCustomState extends ChangeNotifier {
  StatusType get currentStatus => _engine.currentStatus;
}

// Widget translates
class MyCustomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyCustomState>();
    final l10n = AppLocalizations.of(context)!;
    
    return Text(_getLabel(state.currentStatus, l10n));
  }
  
  String _getLabel(StatusType status, AppLocalizations l10n) {
    switch (status) {
      case StatusType.active: return l10n.statusActive;
      case StatusType.inactive: return l10n.statusInactive;
    }
  }
}

// OR using extension for reusability:
extension StatusTypeLocalization on StatusType {
  String localize(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      StatusType.active => l10n.statusActive,
      StatusType.inactive => l10n.statusInactive,
    };
  }
}
// Usage: Text(state.currentStatus.localize(context))
```

### Test Impact
```dart
// State tests: no i18n needed ✅
test('currentStatus returns correct enum', () {
  final state = MyCustomState(config: testConfig);
  expect(state.currentStatus, StatusType.active); // No BuildContext!
});

// Widget tests: include i18n setup
testWidgets('displays translated label', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: [Locale('fr')],
      home: MyCustomWidget(),
    ),
  );
  expect(find.text('ACTIF'), findsOneWidget);
});
```

---

## 5. Layer Separation

### Domain Layer
- **Path:** `lib/domain/`
- **Imports:** Pure Dart only, `package:flutter/foundation.dart` for `@immutable`
- **Tests:** `test/domain/` — 100% coverage, ultra-fast (<1ms/test)

### Application Layer (State)
- **Path:** `lib/state/`
- **Imports:** Domain + Service interfaces + `ChangeNotifier`
- **Tests:** `test/state/` — 100% coverage with mocked services

### Infrastructure Layer
- **Path:** `lib/services/` (interfaces), `lib/services/impl/` (implementations)
- **Imports:** Interfaces = pure Dart; Implementations = Flutter APIs allowed
- **Tests:** `test/services/impl/` — integration tests with real dependencies

### Presentation Layer
- **Path:** `lib/screens/`, `lib/widgets/`
- **Imports:** Anything (UI layer)
- **Tests:** `test/screens/`, `test/widgets/` — widget tests

---

## 6. Common Service Interfaces

### TickerService (for timers)
```dart
abstract class TickerService {
  Stream<int> createTicker(Duration interval);
  void dispose();
}
```

### AudioService (for sounds)
```dart
abstract class AudioService {
  void playBeep();
  void playSound(String assetPath);
  void setVolume(double volume);
}
```

### PreferencesRepository (for persistence)
```dart
abstract class PreferencesRepository {
  T? get<T>(String key);
  Future<void> set<T>(String key, T value);
  Future<void> clear();
}
```

### ApiClient (for HTTP)
```dart
abstract class ApiClient {
  Future<T> get<T>(String endpoint);
  Future<T> post<T>(String endpoint, Map<String, dynamic> body);
}
```

---

## Verification Checklist

Before marking build as PASSED:

- [ ] No `Timer.periodic()`, `SystemSound.play()`, or platform channels in State files
- [ ] All external dependencies injected via constructor
- [ ] Service interfaces defined in `lib/services/`
- [ ] Service implementations in `lib/services/impl/`
- [ ] Complex logic (>50 lines) extracted to `lib/domain/`
- [ ] Domain classes have no Flutter imports (except `foundation`)
- [ ] State classes are <200 lines
- [ ] State classes have ≤5 dependencies
- [ ] Domain tests achieve 100% coverage
- [ ] Domain tests run in <100ms total
- [ ] State getters return enums/primitives, not localized strings
- [ ] Enum localization extensions in lib/domain/ if pattern used

---

## Code Generation Rules

When agent generates State classes:

1. **Scan spec.md** for external dependencies (timers, audio, HTTP, persistence)
2. **Generate service interfaces** first (lib/services/)
3. **Generate implementations** (lib/services/impl/)
4. **Extract domain logic** (lib/domain/) if State would be >200 lines
5. **Generate State** as coordinator injecting interfaces
6. **Generate tests** for each layer (domain 100%, state 100%, services ≥80%)

---

## Migration Strategy (for existing code)

If generated State violates this contract:

1. Identify external dependencies (Timer, SystemSound, etc.)
2. Create service interface for each
3. Create implementation in impl/
4. Extract business logic to domain/ if State >200 lines
5. Update State constructor to accept interfaces
6. Update initialization code (main.dart, screens)
7. Update tests to use mocks
8. Verify: `flutter test --coverage`

---

## See Also
- `PROJECT_CONTRACT.md` — File organization, naming conventions
- `TEST_CONTRACT.md` — Testing requirements per layer
- `GUARDRAILS.md` — Automated verification rules

