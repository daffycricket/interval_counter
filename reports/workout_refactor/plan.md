---
# Deterministic Build Plan — Workout (Refactored with Clean Architecture)

screenId: workout
planVersion: 2
generatedAt: 2025-10-25T00:00:00Z
sources:
  - workout_design.json
  - workout_spec_complement.md
  - spec.md
  - ARCHITECTURE_CONTRACT.md
---

# 1. Sources & Prerequisites

## 1.1 Design & Spec
| artifact | path | commit/version | role |
|----------|------|----------------|------|
| design.json | sources/workout/workout_design.json | — | Layout, styling, tokens, bboxes |
| spec_complement | sources/workout/workout_spec_complement.md | — | Business rules, transitions, visual details |
| spec | reports/workout_refactor/spec.md | v2 | Complete functional spec |

## 1.2 Contracts & Guides
| artifact | role |
|----------|------|
| DESIGN_CONTRACT.md | Design.json structure validation |
| SPEC_CONTRACT.md | Spec.md structure validation |
| PROJECT_CONTRACT.md | File organization, naming conventions |
| ARCHITECTURE_CONTRACT.md | Clean Architecture patterns, DIP, layer separation |
| UI_MAPPING_GUIDE.md | Component mapping rules |
| BEST_PRACTICES.md | Flutter code quality |
| GUARDRAILS.md | Automated verification |

## 1.3 Existing Code References
| artifact | path | role |
|----------|------|------|
| home_state.dart | lib/state/home_state.dart | Reference state pattern (to be improved later) |
| preset.dart | lib/models/preset.dart | Preset model |
| app_colors.dart | lib/theme/app_colors.dart | Theme colors |
| existing workout code | lib/screens/workout_screen.dart, lib/widgets/workout/ | Current implementation (to be refactored) |

---

# 2. Architecture & File Generation Plan

## 2.1 Layer Overview

This build follows **Clean Architecture** as per `ARCHITECTURE_CONTRACT.md`:

```
lib/
├── domain/                     # Pure business logic (no Flutter deps)
│   └── workout_engine.dart     # State machine & transitions
├── services/                   # Service interfaces (abstractions)
│   ├── ticker_service.dart     # Timer abstraction
│   ├── audio_service.dart      # Sound abstraction
│   └── preferences_repository.dart  # Persistence abstraction
├── services/impl/              # Service implementations
│   ├── system_ticker_service.dart
│   ├── system_audio_service.dart
│   └── shared_prefs_repository.dart
├── state/                      # Thin coordinators
│   └── workout_state.dart      # Orchestrates domain + services
├── screens/
│   └── workout_screen.dart     # Updated to use new state
└── widgets/workout/
    ├── volume_controls.dart    # Keep existing (minimal changes)
    ├── navigation_controls.dart
    ├── workout_display.dart
    └── pause_button.dart
```

## 2.2 Generated Files & Responsibilities

### 2.2.1 Domain Layer (Pure Business Logic)

| file | path | responsibility | external deps | test coverage |
|------|------|----------------|---------------|---------------|
| WorkoutEngine | lib/domain/workout_engine.dart | State machine for workout phases, step transitions, beep logic | none (pure Dart) | 100% |

**WorkoutEngine responsibilities:**
- Manage current step (preparation, work, rest, cooldown)
- Track remaining time and reps
- Determine next/previous step logic
- Calculate when to play beep (remainingTime ≤ 3)
- Skip logic for zero-duration steps
- Skip last rest logic

### 2.2.2 Service Interfaces (Abstractions)

| interface | path | methods | purpose |
|-----------|------|---------|---------|
| TickerService | lib/services/ticker_service.dart | `Stream<int> createTicker(Duration interval)`, `void dispose()` | Abstract timer dependency |
| AudioService | lib/services/audio_service.dart | `void playBeep()`, `void setVolume(double volume)`, `bool get isEnabled`, `set isEnabled(bool)` | Abstract audio dependency |
| PreferencesRepository | lib/services/preferences_repository.dart | `T? get<T>(String key)`, `Future<void> set<T>(String key, T value)` | Abstract persistence dependency |

### 2.2.3 Service Implementations

| implementation | path | interface | concrete deps | test coverage |
|----------------|------|-----------|---------------|---------------|
| SystemTickerService | lib/services/impl/system_ticker_service.dart | TickerService | dart:async Timer | ≥80% |
| SystemAudioService | lib/services/impl/system_audio_service.dart | AudioService | flutter/services SystemSound | ≥80% |
| SharedPrefsRepository | lib/services/impl/shared_prefs_repository.dart | PreferencesRepository | shared_preferences | ≥80% |

### 2.2.4 Application Layer (State)

| file | path | responsibility | dependencies | LOC target | test coverage |
|------|------|----------------|--------------|------------|---------------|
| WorkoutState | lib/state/workout_state.dart | Thin coordinator: orchestrate domain + services, expose UI-ready data | WorkoutEngine, TickerService, AudioService, PreferencesRepository, Preset | <200 | 100% |

**WorkoutState responsibilities:**
- Inject domain engine and service interfaces via constructor
- Subscribe to ticker stream, delegate tick to engine
- Call audio service when engine indicates beep needed
- Format time for UI (MM:SS)
- Manage controls visibility (auto-hide 1500ms)
- Delegate to engine for next/previous/toggle pause
- Persist volume/soundEnabled via PreferencesRepository
- Call onWorkoutComplete callback when engine signals end

### 2.2.5 Presentation Layer (Screens & Widgets)

| file | path | changes | notes |
|------|------|---------|-------|
| workout_screen.dart | lib/screens/workout_screen.dart | Update factory to inject services into WorkoutState | Use SystemTickerService(), SystemAudioService(), SharedPrefsRepository() |
| volume_controls.dart | lib/widgets/workout/volume_controls.dart | Minimal changes (keep existing UI) | — |
| navigation_controls.dart | lib/widgets/workout/navigation_controls.dart | Minimal changes (keep existing UI) | — |
| workout_display.dart | lib/widgets/workout/workout_display.dart | Minimal changes (keep existing UI) | — |
| pause_button.dart | lib/widgets/workout/pause_button.dart | Minimal changes (keep existing UI) | — |

---

# 3. Design Token Extraction

## 3.1 Colors
| token | hex | usage |
|-------|-----|-------|
| workColor | #4CD27E | Background pour étape Travail |
| restColor | #2196F3 | Background pour étape Repos |
| prepareColor | #FFCC00 | Background pour étape Préparation |
| cooldownColor | #CB80D8 | Background pour étape Refroidissement |
| sliderActive | #000000 | Slider active track |
| sliderInactive | #E0E0E0 | Slider inactive track |
| sliderThumb | #000000 | Slider thumb |
| ghostButtonBg | #555555 | Button secondary background |
| textPrimary | #000000 | Texte principal (chrono, compteur) |
| textSecondary | #FFFFFF | Texte secondaire (libellé étape) |

## 3.2 Typography
| ref | fontSize | fontWeight | usage |
|-----|----------|------------|-------|
| value | 120 | bold | Chronomètre principal |
| title | 48 | bold | Libellé étape (TRAVAIL, REPOS, etc.) |
| label | 16 | medium | Bouton "Maintenir pour sortir" |

## 3.3 Spacing & Radius
| token | value | usage |
|-------|-------|-------|
| md | 16 | Padding containers |
| lg | 24 | Gap vertical entre éléments |
| xl | 24 | Border radius boutons |

---

# 4. Component Mapping (Design → Widgets)

## 4.1 Widgets to Generate

| compId | type | variant | key | widget name | path | parent | buildStrategy | reason |
|--------|------|---------|-----|-------------|------|--------|---------------|--------|
| container-1 | Container | — | workout__container-1 | _WorkoutScreenContent.GestureDetector | inline in workout_screen.dart | — | direct | Main container with tap handler |
| iconbutton-1 | IconButton | ghost | workout__iconbutton-1 | VolumeControls (volume icon) | widgets/workout/volume_controls.dart | VolumeControls | keep existing | Volume toggle button |
| slider-1 | Slider | — | workout__slider-1 | VolumeControls (slider) | widgets/workout/volume_controls.dart | VolumeControls | keep existing | Volume slider |
| icon-1 | Icon | — | workout__icon-1 | VolumeControls (circle icon) | widgets/workout/volume_controls.dart | VolumeControls | rule:slider/normalizeSiblings(drop) | Thumb-like sibling near slider |
| container-2 | Container | — | workout__container-2 | NavigationControls | widgets/workout/navigation_controls.dart | NavigationControls | keep existing | Navigation controls container |
| iconbutton-2 | IconButton | ghost | workout__iconbutton-2 | NavigationControls (previous) | widgets/workout/navigation_controls.dart | NavigationControls | keep existing | Previous step button |
| button-1 | Button | secondary | workout__button-1 | NavigationControls (exit) | widgets/workout/navigation_controls.dart | NavigationControls | keep existing | Long press exit button |
| iconbutton-3 | IconButton | ghost | workout__iconbutton-3 | NavigationControls (next) | widgets/workout/navigation_controls.dart | NavigationControls | keep existing | Next step button |
| text-1 | Text | — | workout__text-1 | WorkoutDisplay (reps counter) | widgets/workout/workout_display.dart | WorkoutDisplay | keep existing | Repetitions counter |
| text-2 | Text | — | workout__text-2 | WorkoutDisplay (timer) | widgets/workout/workout_display.dart | WorkoutDisplay | keep existing | Timer display (MM:SS) |
| text-3 | Text | — | workout__text-3 | WorkoutDisplay (step label) | widgets/workout/workout_display.dart | WorkoutDisplay | keep existing | Step label (TRAVAIL, REPOS, etc.) |
| iconbutton-4 | IconButton | ghost | workout__iconbutton-4 | PauseButton | widgets/workout/pause_button.dart | PauseButton | keep existing | Pause/play FAB |

---

# 5. State Model & Actions

## 5.1 State Properties (WorkoutState)

| property | type | default | source | visibility | persistence |
|----------|------|---------|--------|------------|-------------|
| preset | Preset | (constructor param) | spec § 6.1 | public | no |
| _engine | WorkoutEngine | (injected) | domain | private | no |
| _tickerService | TickerService | (injected) | service | private | no |
| _audioService | AudioService | (injected) | service | private | no |
| _prefsRepo | PreferencesRepository | (injected) | service | private | no |
| _tickerSubscription | StreamSubscription? | null | impl | private | no |
| _controlsHideTimer | Timer? | null | impl | private | no |
| _controlsVisible | bool | true | spec § 6.1 | private | no |
| onWorkoutComplete | VoidCallback? | (constructor param) | spec § 6.2 | public | no |

**Computed properties (exposed to UI):**
- `currentStep` → _engine.currentStep
- `remainingTime` → _engine.remainingTime
- `remainingReps` → _engine.remainingReps
- `isPaused` → _engine.isPaused
- `formattedTime` → _formatTime(_engine.remainingTime)
- `stepLabel` → _getStepLabel(_engine.currentStep)
- `shouldShowRepsCounter` → _engine.shouldShowRepsCounter
- `volume` → _audioService.volume (if applicable) or local state
- `soundEnabled` → _audioService.isEnabled
- `controlsVisible` → _controlsVisible

## 5.2 Actions (WorkoutState public methods)

| method | params | return | spec ref | responsibility |
|--------|--------|--------|----------|----------------|
| tick() | — | void | § 6.2 | Delegate to _engine.tick(), play beep if needed, notifyListeners() |
| togglePause() | — | void | § 6.2 | Toggle pause: start/stop ticker subscription |
| nextStep() | — | void | § 6.2 | Delegate to _engine.nextStep() |
| previousStep() | — | void | § 6.2 | Delegate to _engine.previousStep() |
| onVolumeChange(double value) | value | void | § 6.2 | Update audio service volume, persist |
| toggleSound() | — | void | § 6.2 | Toggle audio service enabled, persist |
| onScreenTap() | — | void | § 6.2 | Show controls, schedule auto-hide after 1500ms |
| exitWorkout() | — | void | § 6.2 | Stop ticker, call onWorkoutComplete |
| dispose() | — | void | lifecycle | Cancel timers, dispose subscriptions |

---

# 6. Interaction Wiring

| compId | widget | event | state method | state changes | notes |
|--------|--------|-------|--------------|---------------|-------|
| iconbutton-1 | VolumeControls | onPressed | toggleSound() | soundEnabled | Toggle volume icon |
| slider-1 | VolumeControls | onChanged | onVolumeChange(value) | volume | Update audio service |
| iconbutton-2 | NavigationControls | onPressed | previousStep() | currentStep, remainingTime, remainingReps | Previous step |
| button-1 | NavigationControls | onLongPress | exitWorkout() | — | Exit after 1s hold |
| iconbutton-3 | NavigationControls | onPressed | nextStep() | currentStep, remainingTime, remainingReps | Next step |
| iconbutton-4 | PauseButton | onPressed | togglePause() | isPaused | Toggle pause/play |
| container-1 | _WorkoutScreenContent | onTap | onScreenTap() | controlsVisible | Show/hide controls |

---

# 7. Navigation & Routing

## 7.1 Inbound Navigation
| trigger | source screen | route | params |
|---------|---------------|-------|--------|
| Button COMMENCER | Home | Navigator.push(WorkoutScreen(preset: preset)) | Preset |
| Tap preset card | Home | Navigator.push(WorkoutScreen(preset: preset)) | Preset |

## 7.2 Outbound Navigation
| trigger | target screen | route | params |
|---------|---------------|-------|--------|
| Long press button-1 | Home | Navigator.pop() | — |
| Back button | Home | Navigator.pop() | — |
| Workout complete | Home | Navigator.pop() (via onWorkoutComplete) | — |

---

# 8. Theme & Styling

## 8.1 Color Usage
| widget | property | token | value |
|--------|----------|-------|-------|
| WorkoutScreen | backgroundColor | dynamic | Based on currentStep (workColor, restColor, prepareColor, cooldownColor) |
| VolumeControls slider | activeColor | sliderActive | #000000 |
| VolumeControls slider | inactiveColor | sliderInactive | #E0E0E0 |
| VolumeControls slider | thumbColor | sliderThumb | #000000 |
| NavigationControls button-1 | backgroundColor | ghostButtonBg | #555555 |
| WorkoutDisplay text-2 | color | textPrimary | #000000 |
| WorkoutDisplay text-3 | color | textSecondary | #FFFFFF |

## 8.2 Typography
| widget | property | typographyRef | fontSize | fontWeight |
|--------|----------|---------------|----------|------------|
| WorkoutDisplay text-1 | style | value | 100 | w400 |
| WorkoutDisplay text-2 | style | value | 160 | w400 |
| WorkoutDisplay text-3 | style | title | 80 | bold |
| NavigationControls button-1 | style | label | 16 | medium |

---

# 9. Accessibility

| compId | widget | semanticLabel | role | notes |
|--------|--------|---------------|------|-------|
| iconbutton-1 | VolumeControls | Activer ou désactiver le son | button | — |
| slider-1 | VolumeControls | Contrôle du volume | slider | — |
| iconbutton-2 | NavigationControls | Précédent | button | — |
| button-1 | NavigationControls | Maintenir pour sortir | button | Long press |
| iconbutton-3 | NavigationControls | Suivant | button | — |
| iconbutton-4 | PauseButton | Mettre en pause / Reprendre | button | Dynamic label based on isPaused |

---

# 10. Test Generation Plan

## 10.1 Domain Tests

| class | path | methods to test | coverage target | notes |
|-------|------|-----------------|-----------------|-------|
| WorkoutEngine | test/domain/workout_engine_test.dart | constructor, tick(), nextStep(), previousStep(), shouldPlayBeep, shouldShowRepsCounter | 100% | State machine logic, all transitions |

**Test scenarios:**
- T1: Initialize with preset 5/3x(40/20)/10 → currentStep=preparation, remainingTime=5
- T2: Initialize with preset 0/3x(40/20)/0 → currentStep=work, remainingTime=40
- T3: tick() at remainingTime=1, currentStep=preparation → nextStep to work
- T4: tick() at remainingTime=1, currentStep=work, remainingReps=3 → nextStep to rest, remainingReps=2
- T5: tick() at remainingTime=1, currentStep=work, remainingReps=1 → nextStep to cooldown
- T6: tick() at remainingTime=3 → shouldPlayBeep=true
- T7: previousStep() from work → back to preparation
- T8: Skip zero-duration steps

## 10.2 Service Tests

| implementation | path | methods to test | coverage target | notes |
|----------------|------|-----------------|-----------------|-------|
| SystemTickerService | test/services/impl/system_ticker_service_test.dart | createTicker(), dispose() | ≥80% | Timer.periodic wrapper |
| SystemAudioService | test/services/impl/system_audio_service_test.dart | playBeep(), setVolume(), isEnabled | ≥80% | SystemSound wrapper |
| SharedPrefsRepository | test/services/impl/shared_prefs_repository_test.dart | get(), set() | ≥80% | SharedPreferences wrapper |

## 10.3 State Tests

| class | path | methods to test | coverage target | mocks |
|-------|------|-----------------|-----------------|-------|
| WorkoutState | test/state/workout_state_test.dart | All public methods from § 5.2 | 100% | MockWorkoutEngine, MockTickerService, MockAudioService, MockPreferencesRepository |

**Test scenarios (with mocks):**
- tick() → verify _engine.tick() called, beep if needed
- togglePause() → verify ticker start/stop
- onVolumeChange() → verify audio service called, prefs saved
- onScreenTap() → verify controlsVisible=true, auto-hide after 1500ms
- exitWorkout() → verify onWorkoutComplete callback

## 10.4 Widget Tests

| widget | path | test cases | notes |
|--------|------|------------|-------|
| WorkoutScreen | test/screens/workout_screen_test.dart | Factory pattern, dependency injection, background color changes | Mock services |
| VolumeControls | test/widgets/workout/volume_controls_test.dart | Slider interaction, volume icon toggle | — |
| NavigationControls | test/widgets/workout/navigation_controls_test.dart | Previous, next, long press exit | — |
| WorkoutDisplay | test/widgets/workout/workout_display_test.dart | Counter visibility, formatted time, step label | — |
| PauseButton | test/widgets/workout/pause_button_test.dart | Icon toggle pause/play | — |

**1:1 mapping verification:**
- § 4.1 has 5 distinct widgets (excluding inline and dropped)
- § 10.4 has 5 test files
- Mapping complete ✓

## 10.5 Accessibility Tests

| widget | test | oracle |
|--------|------|--------|
| VolumeControls | semanticsLabel present | "Activer ou désactiver le son", "Contrôle du volume" |
| NavigationControls | semanticsLabel present | "Précédent", "Maintenir pour sortir", "Suivant" |
| PauseButton | semanticsLabel present | Dynamic based on isPaused |

## 10.6 Golden Tests

| widget | path | scenarios | notes |
|--------|------|-----------|-------|
| WorkoutScreen | test/screens/workout_screen_golden_test.dart | preparation, work, rest, cooldown, controls visible/hidden | — |

## 10.7 Integration Tests

| scenario | path | steps | oracle |
|----------|------|-------|--------|
| Complete workout flow | integration_test/workout_flow_test.dart | Start preset, wait for transitions, verify end | Full cycle 5/3x(40/20)/10 |

## 10.8 Shared Helpers

| helper | path | purpose |
|--------|------|---------|
| widget_test_helpers.dart | test/helpers/widget_test_helpers.dart | pumpUntilFound, mockPreset, mockWorkoutState |

---

# 11. Risks & Mitigations

| risk | severity | mitigation |
|------|----------|------------|
| Timer precision (drift over long sessions) | Medium | Use Stream-based ticker, test with fast-forward |
| SystemSound.play() volume control limitation | Medium | Document limitation, consider custom audio player if needed |
| Background mode (timer continues?) | Medium | Out of scope for this iteration, document in spec § 11.3 |
| State initialization race condition | Low | Use FutureBuilder in WorkoutScreen as in existing code |
| Auto-hide timer conflicts | Low | Cancel previous timer before scheduling new one |

---

# 12. Verification Checklist

Before marking build as PASSED:

- [ ] No `Timer.periodic()`, `SystemSound.play()`, `SharedPreferences` in WorkoutState directly
- [ ] All external dependencies injected via constructor (service interfaces)
- [ ] Service interfaces defined in `lib/services/`
- [ ] Service implementations in `lib/services/impl/`
- [ ] WorkoutEngine in `lib/domain/` with no Flutter imports (except foundation)
- [ ] WorkoutState is <200 lines
- [ ] WorkoutState has ≤5 dependencies (4 actual: engine, ticker, audio, prefs)
- [ ] Domain tests achieve 100% coverage
- [ ] State tests achieve 100% coverage with mocks
- [ ] Widget tests updated for all 5 widgets
- [ ] All tests pass: `flutter test`
- [ ] Coverage report generated: `flutter test --coverage`

---

# 13. Build Order

1. **Domain layer** (lib/domain/workout_engine.dart)
2. **Service interfaces** (lib/services/*.dart)
3. **Service implementations** (lib/services/impl/*.dart)
4. **State refactor** (lib/state/workout_state.dart)
5. **Screen update** (lib/screens/workout_screen.dart)
6. **Widget updates** (lib/widgets/workout/*.dart) - minimal changes
7. **Domain tests** (test/domain/workout_engine_test.dart)
8. **Service tests** (test/services/impl/*_test.dart)
9. **State tests** (test/state/workout_state_test.dart)
10. **Widget tests** (test/widgets/workout/*_test.dart, test/screens/workout_screen_test.dart)

---

# 14. Dependencies

## 14.1 New Dependencies
— (None, all required packages already in pubspec.yaml)

## 14.2 Existing Dependencies
| package | version | usage |
|---------|---------|-------|
| provider | — | State management |
| shared_preferences | — | Persistence |
| flutter/services | — | SystemSound |

---

# 15. Success Criteria

✓ All files generated per § 2.2
✓ ARCHITECTURE_CONTRACT.md compliance verified
✓ All tests pass (flutter test)
✓ Coverage ≥95% for domain and state layers
✓ No linter errors
✓ Existing workout widgets still render correctly
✓ 1500ms auto-hide delay for controls
✓ Evaluation report generated with status=PASSED









