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

❌ **MUST NOT:**
- Mix screen-specific widgets in generic `lib/widgets/`
- Create state files outside `lib/state/`
- Duplicate theme definitions across files
- Create deeply nested folder structures (max 2 levels in widgets/)

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

---

## Deliverable

Generated code that:
- ✅ Follows all file organization rules
- ✅ Uses Provider + ChangeNotifier exclusively
- ✅ Has properly decomposed widgets (<50 lines or justified)
- ✅ Follows all naming conventions
- ✅ Includes complete model implementations
- ✅ Has tests organized correctly

Any violation → **FAIL** with specific rule citation.