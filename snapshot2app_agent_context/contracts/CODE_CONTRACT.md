# CODE_CONTRACT — Code Organization, Architecture & Patterns

## Purpose
Mandatory structure, patterns, and architecture for generated Flutter code.
Ensures deterministic, maintainable, testable code with clean layer separation.

---

## 1. File Organization

```
lib/
  screens/{screen_name}_screen.dart        # One screen per file
  widgets/{widget_name}.dart               # Generic (used ≥2 screens)
  widgets/{screen_name}/{widget_name}.dart  # Screen-specific
  state/{context}_state.dart               # ChangeNotifier classes
  models/{model_name}.dart                 # Immutable data classes
  domain/{feature}_engine.dart             # Pure business logic
  domain/{feature}_calculator.dart         # Pure computations
  domain/{feature}_validator.dart          # Business rules
  services/{service_name}.dart             # Abstract interfaces
  services/impl/{service_name}_impl.dart   # Concrete implementations
  theme/app_colors.dart                    # Design tokens
  theme/app_text_styles.dart
  l10n/app_en.arb, app_fr.arb             # Localization
```

Max 2 levels in `widgets/`. No hardcoded strings in UI (use `AppLocalizations`).

---

## 2. Layer Separation

| Layer | Path | Allowed imports | Coverage |
|---|---|---|---|
| Domain | `lib/domain/` | Pure Dart + `foundation` for `@immutable` | 100%, <1ms/test |
| Services | `lib/services/` (interfaces), `lib/services/impl/` | Interfaces = pure Dart; Impls = Flutter APIs | ≥80% |
| State | `lib/state/` | Domain + Service interfaces + `ChangeNotifier` | 100% |
| Presentation | `lib/screens/`, `lib/widgets/` | Anything | See GUARDRAILS.md |

---

## 3. Domain Layer

**Extract to `lib/domain/` when:** business logic >50 lines OR complex calculations.

- Pure Dart only (no `package:flutter` except `foundation`)
- No side effects (no I/O, no navigation, no notifications)
- Deterministic: same input → same output
- 100% unit testable, <1ms per test

---

## 4. Service Interfaces (Dependency Inversion)

**State MUST NOT use concrete Flutter classes for external services.**

| Prohibited in State | Use instead |
|---|---|
| `Timer.periodic()` | `TickerService` interface |
| `SystemSound.play()` | `AudioService` interface |
| `HapticFeedback.vibrate()` | `HapticsService` interface |
| `http.Client()` | `ApiClient` interface |
| Platform channels | Service abstraction |

**Pattern:**
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
```

---

## 5. State Management

**Provider + ChangeNotifier exclusively.** No BLoC, Riverpod, GetX, Redux.

### State as thin coordinator
- Inject domain classes + service interfaces via constructor
- Delegate business logic to domain, I/O to services
- **<200 lines**, **≤5 constructor dependencies**
- Call `notifyListeners()` after every mutation

### Dependency injection — dual constructors
```dart
class WorkoutState extends ChangeNotifier {
  final WorkoutEngine _engine;       // Domain
  final AudioService _audio;         // Service interface
  final PreferencesRepository _prefs; // Service interface

  // Production (async)
  static Future<WorkoutState> create(Preset preset) async {
    final engine = WorkoutEngine(preset: preset);
    final audio = SystemAudioService();
    final prefs = SharedPrefsRepository(await SharedPreferences.getInstance());
    return WorkoutState(engine, audio, prefs);
  }

  // Test (sync, accepts mocks)
  WorkoutState(this._engine, this._audio, this._prefs);

  void tick() {
    _engine.tick();                          // Delegate to domain
    if (_engine.shouldPlayBeep) _audio.playBeep(); // Delegate to service
    notifyListeners();
  }
}
```

### Localization in State
- **PROHIBITED:** State returning localized strings
- **CORRECT:** State returns enum/primitive; widget translates via `AppLocalizations.of(context)`

---

## 6. Widget Decomposition

- Extract if **>50 lines** OR used **≥2 times**
- `const` constructors when no mutable state
- Named parameters, include `Key`: `const MyWidget({super.key, ...})`
- Naming: `{Purpose}{WidgetType}` (e.g., `PresetCard`, `VolumeHeader`)
- 1 screen only → `lib/widgets/{screen_name}/`; ≥2 screens → `lib/widgets/`

---

## 7. Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Files | `snake_case.dart` | `workout_engine.dart` |
| Classes | `PascalCase` | `WorkoutEngine` |
| Private members | `_camelCase` | `_remainingTime` |
| Public members | `camelCase` | `remainingTime` |
| State classes | `{Context}State` | `WorkoutState` |
| Screens | `{ScreenName}Screen` | `WorkoutScreen` |
| Constants | `camelCase` | `const maxReps = 999` |

No abbreviations (OK: `id`, `url`; NOT: `rep`, `btn`).

---

## 8. Model Structure

Immutable data classes with `final` fields and `const` constructor.

**Required methods:** `fromJson()`, `toJson()`, `copyWith()`, `operator ==`, `hashCode`, `toString()`.

---

## 9. Test Organization

Mirror `lib/` structure in `test/`:
```
test/
  domain/{feature}_test.dart         # 100% coverage
  state/{screen}_state_test.dart     # 100% coverage
  models/{model}_test.dart           # 100% coverage
  services/impl/{service}_test.dart  # ≥80% coverage
  widgets/{screen}/{widget}_test.dart
  screens/{screen}_screen_test.dart
  helpers/widget_test_helpers.dart    # Shared setup
```

See `TEST_CONTRACT.md` for detailed testing requirements.

---

## Verification Checklist

- [ ] File paths follow §1 organization
- [ ] No Flutter imports in `lib/domain/` (except `foundation`)
- [ ] State classes <200 lines, ≤5 dependencies
- [ ] No `Timer.periodic()`, `SystemSound.play()`, platform channels in State
- [ ] All external dependencies injected via constructor
- [ ] State returns enums/primitives, not localized strings
- [ ] Widget decomposition respected (>50 lines extracted)
- [ ] Naming conventions followed (§7)
- [ ] Models have all required methods (§8)
- [ ] All UI text uses `AppLocalizations` (no hardcoded strings)

Any violation → **FAIL** with specific rule citation.
