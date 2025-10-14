# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an **Interval Counter** Flutter application generated from JSON screen specifications using an AI-driven "snapshot2app" workflow. The app is localized for English and French, and implements a Provider-based state management architecture with dependency injection for testability.

The project follows a **screen-by-screen generation workflow** where each screen is built from:
- A design file (`design.json`) following the mini-Figma schema
- A functional specification (`spec.md`)

## Key Commands

### Development
```bash
# Run the app
flutter run

# Run on a specific device
flutter run -d <device-id>

# Hot reload (press 'r' in terminal)
# Hot restart (press 'R' in terminal)
```

### Testing
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/path/to/test_file.dart
```

### Build & Lint
```bash
# Analyze code (linting)
flutter analyze

# Build for specific platform
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
flutter build macos        # macOS
```

### Dependencies
```bash
# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Clean build artifacts
flutter clean
```

## Code Architecture

### State Management Pattern

**CRITICAL:** This project exclusively uses **Provider + ChangeNotifier** pattern.

**State class structure:**
- All state classes extend `ChangeNotifier`
- Located in `lib/state/{context}_state.dart`
- Private fields with underscore prefix: `_fieldName`
- Public getters for read-only access
- Mutations only via public methods that call `notifyListeners()`
- Uses `SharedPreferences` for persistence when needed

**Dependency Injection for Testability:**
- All external dependencies (SharedPreferences, APIs, Services) injected via constructor
- Dual constructor pattern:
  - Production: `MyState.create()` - async factory that instantiates real dependencies
  - Testing: `MyState(deps)` - sync constructor accepting mock dependencies
- Never instantiate dependencies inside state methods
- Separate async I/O from pure business logic

Example:
```dart
class IntervalTimerHomeState extends ChangeNotifier {
  final SharedPreferences _prefs;

  // Production constructor
  static Future<IntervalTimerHomeState> create() async {
    final prefs = await SharedPreferences.getInstance();
    return IntervalTimerHomeState(prefs);
  }

  // Test constructor
  IntervalTimerHomeState(this._prefs) {
    _loadState();  // Pure, synchronous
  }

  void incrementReps() {
    if (_reps < maxReps) {
      _reps++;
      notifyListeners();
      _saveState();  // Async I/O separate
    }
  }
}
```

### File Organization

```
lib/
├── main.dart                          # App entry point
├── screens/                           # Screen widgets (one per file)
│   └── {screen_name}_screen.dart
├── widgets/                           # Reusable widgets
│   ├── {widget_name}.dart             # Generic (used across screens)
│   └── {screen_name}/                 # Screen-specific widgets
│       └── {widget_name}.dart
├── state/                             # State management (ChangeNotifier)
│   └── {context}_state.dart
├── models/                            # Data models
│   └── {model_name}.dart
├── theme/                             # Design system tokens
│   ├── app_colors.dart
│   └── app_text_styles.dart
└── l10n/                              # Internationalization
    ├── app_en.arb
    └── app_fr.arb

test/                                  # Mirrors lib/ structure
├── state/                             # 100% coverage required
├── models/                            # 100% coverage required
├── widgets/                           # ≥90% coverage for generic
└── screens/                           # ≥60% coverage
```

**Test Coverage Requirements:**
- State classes: **100% line and branch coverage** (CRITICAL)
- Model classes: **100% line and branch coverage** (CRITICAL)
- Generic widgets: ≥90%
- Screen-specific widgets: ≥70%
- Screens: ≥60%
- **Overall project: ≥80%**

### Model Structure

All models are immutable data classes with:
- `final` fields only
- `const` constructor
- `fromJson(Map<String, dynamic>)` factory
- `toJson()` method
- `copyWith({...})` for immutability
- `operator ==` and `hashCode` for value equality
- `toString()` for debugging

### Widget Decomposition Rules

- Extract widget if **>50 lines** OR used **≥2 times**
- Use `const` constructors when no mutable state
- Pass dependencies via constructor parameters
- Include `Key` parameter: `const MyWidget({super.key, ...})`
- Naming: `{Purpose}{WidgetType}` (e.g., `PresetCard`, `QuickStartSection`)

**Reusability decision:**
- Used in 1 screen only → `lib/widgets/{screen_name}/`
- Used in ≥2 screens → `lib/widgets/`

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Private members**: `_camelCase`
- **Public members**: `camelCase`
- **State classes**: `{Context}State`
- **Screen widgets**: `{ScreenName}Screen`

### Internationalization

- **NEVER** use hardcoded strings in UI
- All user-facing text must use `AppLocalizations.of(context)`
- ARB files located in `lib/l10n/` (once generated)
- Supported locales: English (`app_en.arb`) and French (`app_fr.arb`)
- Generated localization classes via `flutter gen-l10n`

## Snapshot2App Workflow

This project uses a deterministic agent-based workflow to generate Flutter screens from design specifications.

### Context Files Location

All workflow context is in `snapshot2app_agent_context/`:
- `contracts/` - Architecture rules (PROJECT_CONTRACT.md, TEST_CONTRACT.md, etc.)
- `prompts/` - Agent prompts for each workflow step
- `guides/` - UI mapping guides and examples
- `examples/` - Reference designs and specs (home screen, preset editor)
- `schema/` - JSON schema for design files (minifigma.schema.json)

### Typical Workflow Commands

**Build screen from scratch:**
```
Run 00_ORCHESTRATOR.prompt
Input: examples/home/home_design.json
Report folder: reports/home
```

**Build screen starting at specific step (allows manual editing between steps):**
```
Run 00_ORCHESTRATOR.prompt, starting step 03 through last step
Inputs:
  - design.json: examples/home/home_design.json
  - validation_report.md and spec.md in reports/home
Report folder: reports/home
```

**Build new screen using previous screen as reference:**
```
Run 00_ORCHESTRATOR.prompt
Inputs:
  - design.json: examples/new_preset/preset_editor_design.json
  - Reference spec.md from reports/home
Report folder: reports/new_preset
```

### Golden Rules for Development

1. **Determinism over creativity** - Follow schema and mapping guides; no invention without explicit assumptions
2. **Separation of concerns** - Context files guide, agents generate code
3. **One-screen increments** - Treat each screen independently
4. **Traceability** - Every change linked to design/spec; produce `agent_report.md` per run

### Workflow Steps (per screen)

1. Validate `design.json` against schema and Design Contract
2. Read `spec.md` and derive behavioral contracts
3. Plan the file diff (widgets, state, keys, tests to generate)
4. Generate code following contracts and mapping guide
5. Run Evaluation rubric and produce `agent_report.md`

See `snapshot2app_agent_context/runbooks/CLAUDE_CODE_RUNBOOK.md` for detailed instructions.

## Testing Philosophy

**Every new component MUST be tested.** Tests are generated alongside production code.

### Test Generation Requirements

For each screen generation, tests must cover:
- Every public method in State classes
- Every validation rule in spec.md
- Every interactive component in plan.md
- All serialization (toJson/fromJson) in Models
- All navigation triggers
- All accessibility labels from design.json

### Widget Test Keys

All testable widgets include stable keys following pattern: `Key('{screenId}__{compId}')`

Example:
```dart
Button(
  key: const Key('home__button_start'),
  onPressed: () => state.startTimer(),
  child: Text('Start'),
)
```

This allows tests to find components reliably:
```dart
expect(find.byKey(const Key('home__button_start')), findsOneWidget);
```

## Important Notes

### DO NOT Use

- BLoC, Riverpod, GetX, Redux, or any state management pattern other than Provider
- Mutable public state (no public setters on collections)
- `setState` in StatefulWidget for business state (Provider only)
- Global singletons for dependencies
- Hardcoded UI strings (must use AppLocalizations)

### DO Use

- Provider + ChangeNotifier exclusively
- Dependency injection for all external dependencies
- `const` constructors wherever possible
- Named parameters for clarity
- Descriptive variable and function names
- flutter_lints (already configured in analysis_options.yaml)

## Current Project State

This project is in active development. The main screen (IntervalTimerHomeScreen) is being built. Currently generated files:
- `lib/main.dart` - App entry point with Provider setup
- `lib/widgets/value_control.dart` - Reusable value control widget with +/- buttons

The project follows an iterative generation workflow with reports stored in `reports/` directory.
