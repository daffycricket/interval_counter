# PROJECT_CONTRACT — Code Organization & Architecture

## Purpose
Define mandatory structure, patterns, and organization for generated Flutter code.
This contract ensures deterministic, maintainable, and testable code across all generated screens.

## Pass/Fail Criteria

### File Organization

✅ **MUST:**
- Screen widgets → `lib/screens/{screen_name}_screen.dart`
  - Main screen widget (StatefulWidget or StatelessWidget)
  - One screen per file
- Reusable/generic widgets → `lib/widgets/{widget_name}.dart`
  - Widgets used across multiple screens
  - Widgets with no screen-specific logic
- Screen-specific widgets → `lib/widgets/{screen_name}/{widget_name}.dart`
  - Widgets used only within a specific screen
  - Example: `lib/widgets/home/preset_card.dart` for home screen only
- State management → `lib/state/{context}_state.dart`
  - All ChangeNotifier classes
  - Example: `interval_timer_home_state.dart`, `presets_state.dart`
- Data models → `lib/models/{model_name}.dart`
  - Plain data classes
  - Immutable models with business logic
- Theme tokens → `lib/theme/app_{colors|text_styles|...}.dart`
  - Design system tokens
  - Centralized styling constants
- Internationalization → `lib/l10n/`
  - ARB files: `app_en.arb`, `app_fr.arb`
  - Configuration: `l10n.yaml`
  - Generated classes: `app_localizations.dart`

❌ **MUST NOT:**
- Mix screen-specific widgets in generic `lib/widgets/`
- Create state files outside `lib/state/`
- Duplicate theme definitions across files
- Create deeply nested folder structures (max 2 levels in widgets/)
- Use hardcoded strings in UI (must use AppLocalizations)

**See also:** `guides/BEST_PRACTICES.md` for common pitfalls to avoid.

---

### State Management Pattern

✅ **MUST:**
- Use **Provider + ChangeNotifier** pattern exclusively
- State classes **extend ChangeNotifier**
- Private fields with underscore prefix: `_fieldName`
- Public getters for read-only access: `get fieldName => _fieldName;`
- Mutations only via public methods
- Call `notifyListeners()` after every state mutation
- Use `SharedPreferences` for persistence when specified in spec
- Load initial state in constructor or `init()` method
- Validate data on load (clamp values, handle missing data)

**Example structure:**
```dart
class ExampleState extends ChangeNotifier {
  int _counter = 0;
  
  int get counter => _counter;
  
  void increment() {
    _counter++;
    notifyListeners();
    _saveState();
  }
  
  Future<void> _saveState() async { /* persistence */ }
}
```

❌ **MUST NOT:**
- Use BLoC, Riverpod, GetX, Redux, or any other state management pattern
- Expose mutable state directly (no public setters on collections)
- Mix business logic in widget build methods
- Forget to call `notifyListeners()` after mutations
- Use `setState` in StatefulWidget for business state (only for local UI state)

---

### Testability & Dependency Injection

✅ **MUST for State classes:**
- Accept **all external dependencies** via constructor parameters
  - **Mockable dependencies** (SharedPreferences with setMockInitialValues) → inject directly
  - **Non-mockable dependencies** (Timer, SystemSound, platform channels) → inject via service interface
  - Never instantiate dependencies inside State class methods
- See `ARCHITECTURE_CONTRACT.md` for service interface pattern
- Provide **dual constructors** for flexibility:
  - Production: `MyState.create()` — instantiates real dependencies
  - Testing: `MyState(deps)` — accepts mock dependencies
- Keep logic **pure and synchronous** when possible
  - Separate async I/O from business logic
  - Makes unit testing deterministic

**Example testable State:**
```dart
class IntervalTimerHomeState extends ChangeNotifier {
  final PreferencesRepository _prefs;  // Interface (not concrete class)
  final AudioService _audio;           // Service interface
  
  // Production constructor (async, instantiates dependencies)
  static Future<IntervalTimerHomeState> create() async {
    final prefsRepo = SharedPrefsRepository(await SharedPreferences.getInstance());
    final audio = SystemAudioService();
    return IntervalTimerHomeState(prefsRepo, audio);
  }
  
  // Test constructor (sync, accepts dependencies)
  IntervalTimerHomeState(this._prefs, this._audio) {
    _loadState();
  }
  
  void _loadState() {
    _reps = _prefs.get<int>('reps') ?? 16;
    // Pure logic, no async, no I/O
  }
  
  void incrementReps() {
    if (_reps < maxReps) {
      _reps++;
      _audio.playBeep();
      notifyListeners();
      _saveState();
    }
  }
  
  Future<void> _saveState() async {
    await _prefs.set('reps', _reps);
  }
}
```

**Example in main.dart:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final homeState = await IntervalTimerHomeState.create();
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: homeState),
    ],
    child: MyApp(),
  ));
}
```

**Example in tests:**
```dart
test('loads reps from preferences', () {
  final mockPrefs = MockPreferencesRepository();
  final mockAudio = MockAudioService();
  when(mockPrefs.get<int>('reps')).thenReturn(42);
  
  final state = IntervalTimerHomeState(mockPrefs, mockAudio);
  expect(state.reps, 42);
});
```

❌ **MUST NOT:**
- Instantiate dependencies inside State: `SharedPreferences.getInstance()` in methods ❌
- Use global singletons: `static final prefs = ...` ❌
- Call `Timer.periodic()`, `SystemSound.play()`, platform channels directly ❌
- Mix async I/O with business logic in the same method
- Hard-code dependencies without constructor injection

**Rationale:**
- ✅ Unit tests can inject mocks (no real file I/O)
- ✅ Tests run fast and deterministically
- ✅ State logic is isolated and independently testable
- ✅ Follows SOLID principles (Dependency Inversion)

---

### Widget Decomposition

✅ **MUST:**
- Extract widget if **>50 lines** OR used **≥2 times** in the same screen
- Use `const` constructors when widget has no mutable state
- Pass dependencies via constructor parameters
- Use named parameters for clarity
- Include `Key` parameter: `const MyWidget({super.key, ...})`
- Follow naming pattern: `{Purpose}{WidgetType}`
  - Examples: `PresetCard`, `QuickStartSection`, `VolumeHeader`
  - NOT: `Widget1`, `MyWidget`, `CustomThing`

**Reusability decision tree:**
- Used in 1 screen only → `lib/widgets/{screen_name}/`
- Used in ≥2 screens OR generic purpose → `lib/widgets/`
- Threshold: if in doubt, start screen-specific, refactor to generic when second use appears

❌ **MUST NOT:**
- Create monolithic widgets >200 lines
- Use anonymous widgets (wrap with named widget class)
- Mix data fetching in widget (delegate to state)
- Create widgets without clear single responsibility

---

### Naming Conventions

✅ **MUST:**
- **Files**: `snake_case.dart`
  - Examples: `interval_timer_home_screen.dart`, `preset_card.dart`
- **Classes**: `PascalCase`
  - Examples: `IntervalTimerHomeScreen`, `PresetCard`, `PresetsState`
- **Private members**: `_camelCase`
  - Examples: `_repetitions`, `_loadPresets()`, `_saveState()`
- **Public members**: `camelCase`
  - Examples: `repetitions`, `loadPresets()`, `formattedTime`
- **State classes**: `{Context}State`
  - Examples: `IntervalTimerHomeState`, `PresetsState`, `TimerRunningState`
- **Screen widgets**: `{ScreenName}Screen`
  - Examples: `IntervalTimerHomeScreen`, `PresetEditorScreen`
- **Constants**: `camelCase` for private, `lowerCamelCase` for public
  - Examples: `const minReps = 1;`, `static const int maxReps = 999;`

❌ **MUST NOT:**
- Use abbreviations unless universally known (OK: `id`, `url`; NOT: `rep`, `btn`)
- Mix naming conventions (consistency is critical)
- Use Hungarian notation or prefixes (NOT: `strName`, `intCount`)

---

### Model Structure

✅ **MUST:**
- Immutable data classes with `final` fields
- Include `const` constructor when all fields are immutable
- Implement required methods:
  - `fromJson(Map<String, dynamic> json)` factory constructor
  - `toJson()` → `Map<String, dynamic>`
  - `copyWith({...})` for immutability
  - `operator ==` and `hashCode` for value equality
  - `toString()` for debugging
- Use proper types (avoid `dynamic` when possible)
- Document field purposes with inline comments if not obvious

**Example structure:**
```dart
class Example {
  final String id;
  final String name;
  
  const Example({required this.id, required this.name});
  
  factory Example.fromJson(Map<String, dynamic> json) { /* ... */ }
  Map<String, dynamic> toJson() { /* ... */ }
  Example copyWith({String? id, String? name}) { /* ... */ }
  
  @override
  bool operator ==(Object other) { /* ... */ }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() => 'Example(id: $id, name: $name)';
}
```

❌ **MUST NOT:**
- Use mutable fields (no non-final fields)
- Skip any of the required methods
- Use `dynamic` without justification
- Forget null-safety annotations

---

### Test Organization

✅ **MUST:**
- Mirror `lib/` structure in `test/`
  - `lib/screens/home_screen.dart` → `test/screens/home_screen_test.dart`
  - `lib/widgets/value_control.dart` → `test/widgets/value_control_test.dart`
- Organize by test type:
  - `test/unit/` → Unit tests (models, utilities, pure functions)
  - `test/widgets/` → Widget tests (individual widgets, integration)
  - `test/state/` → State management tests (ChangeNotifier behavior)
  - `integration_test/` → End-to-end tests (full user flows)
- Use descriptive test names: `'should increment counter when button pressed'`
- Group related tests with `group()` blocks
- Include keys on testable widgets: `Key('{screenId}__{compId}')`

❌ **MUST NOT:**
- Mix test types in the same file
- Skip test files for public widgets/screens
- Use hardcoded strings for widget keys (use constants or spec-defined keys)
- Create tests without clear assertions

---

## Verification Steps

When generating or validating code, verify:

1. **File paths match rules:**
   - Check all files are in correct directories
   - Verify no screen-specific widgets in generic `lib/widgets/`
   
2. **State pattern compliance:**
   - All state classes extend `ChangeNotifier`
   - Private fields with public getters
   - Mutations call `notifyListeners()`
   
3. **Widget decomposition:**
   - No widgets >200 lines
   - Extracted widgets follow naming conventions
   - Reusability decisions are justified
   
4. **Naming consistency:**
   - Files are snake_case
   - Classes are PascalCase
   - Members follow conventions
   
5. **Model completeness:**
   - All required methods present (fromJson, toJson, copyWith, ==, hashCode, toString)
   - Fields are immutable (`final`)
   
6. **Test coverage:**
   - Test files mirror lib/ structure
   - Tests are organized by type
   - All public widgets have tests
   
7. **Internationalization:**
   - All UI text uses AppLocalizations
   - ARB files contain all user-facing strings
   - No hardcoded strings in widgets
   - English and French locales supported

---

## Deliverable

Generated code that:
- ✅ Follows all file organization rules
- ✅ Uses Provider + ChangeNotifier exclusively
- ✅ Has properly decomposed widgets (<50 lines or justified)
- ✅ Follows all naming conventions
- ✅ Includes complete model implementations
- ✅ Has tests organized correctly
- ✅ Has full internationalization support

Any violation → **FAIL** with specific rule citation.