---
screenName: Workout
screenId: workout
designSnapshotRef: b039e6bc-74d9-4ca5-a4c6-93d67f2fb6b0.png
planVersion: 2
generatedAt: 2026-03-03T00:00:00Z
generator: spec2plan
language: fr
---

# 0. Invariants & Sources
- Sources: `workout_design.json` (layout/styling), `spec.md` (logic/state/navigation/a11y)
- Rule: **design.json wins for layout**, **spec.md wins for behavior**
- Refactor scope: keep existing views, refactor state and business logic to match CODE_CONTRACT.md
- Keys: `workout__{compId}`

---

# 1. Meta
| field             | value |
|-------------------|-------|
| screenId          | workout |
| designSnapshotRef | b039e6bc-74d9-4ca5-a4c6-93d67f2fb6b0.png |

---

# 2. Files to Generate
## 2.1 Widgets (existing — keep as-is, minor fixes only)
| widgetName         | filePath                                      | purpose (fr court)               | components (compIds)              | notes |
|--------------------|-----------------------------------------------|----------------------------------|-----------------------------------|-------|
| WorkoutDisplay     | lib/widgets/workout/workout_display.dart      | Affichage chrono/reps/étape      | text-1, text-2, text-3            | Exists — keep |
| NavigationControls | lib/widgets/workout/navigation_controls.dart  | Contrôles nav + sortie           | iconbutton-2, button-1, iconbutton-3 | Fix hardcoded string |
| PauseButton        | lib/widgets/workout/pause_button.dart         | FAB pause/start                  | iconbutton-4                      | Exists — keep |
| VolumeHeader       | lib/widgets/volume_header.dart                | Slider volume réutilisé          | iconbutton-1, slider-1            | Exists — shared widget |

## 2.2 State
| filePath                      | pattern          | exposes (fields/actions)                                                                     | persistence | notes |
|-------------------------------|------------------|----------------------------------------------------------------------------------------------|-------------|-------|
| lib/state/workout_state.dart  | ChangeNotifier   | currentStep, remainingTime, remainingReps, formattedTime, isPaused, isExiting, isComplete, controlsVisible, volume; tick, togglePause, nextStep, previousStep, onScreenTap, onVolumeChange, onLongPress | volume only | NEW — <200 lines |

## 2.2.1 Service Dependencies

**Service Interfaces & Implementations (existing — no changes):**
| interfacePath                              | implPath                                          | reason                    | methods                          |
|--------------------------------------------|---------------------------------------------------|---------------------------|----------------------------------|
| lib/services/audio_service.dart            | lib/services/impl/beep_audio_service.dart         | Audio playback            | playBeep(), setVolume(), volume, dispose() |
| lib/services/ticker_service.dart           | lib/services/impl/system_ticker_service.dart      | Periodic timer            | createTicker(Duration), dispose() |
| lib/services/preferences_repository.dart   | lib/services/impl/shared_prefs_repository.dart    | Key-value persistence     | get<T>(), set<T>(), remove(), clear() |

**Domain Classes (Pure Business Logic) — NEW:**
| domainPath                         | purpose                                              | extracted from (State logic) |
|------------------------------------|------------------------------------------------------|------------------------------|
| lib/domain/step_type.dart          | Enum des types d'étapes                              | — |
| lib/domain/workout_engine.dart     | Logique métier pure : séquence d'étapes, countdown, bips, reps, navigation | WorkoutState business logic |

## 2.3 Routes (existing — no changes)
| routeName | filePath                    | params | created/uses | notes |
|-----------|-----------------------------|--------|-------------|-------|
| /workout  | lib/routes/app_routes.dart  | Preset | uses         | — |

## 2.4 Themes/Tokens (existing — no changes)
| tokenType | name          | required | notes |
|----------|---------------|----------|-------|
| color    | workColor     | yes      | #4CD27E |
| color    | restColor     | yes      | #2196F3 |
| color    | prepareColor  | yes      | #FFCC00 |
| color    | cooldownColor | yes      | rgba(203,128,216) |
| color    | ghostButtonBg | yes      | #555555 |

## 2.5 Tests

### Domain Tests — 100% coverage
| className      | testFilePath                          | covers |
|----------------|---------------------------------------|--------|
| StepType       | test/domain/step_type_test.dart       | Enum values |
| WorkoutEngine  | test/domain/workout_engine_test.dart  | Step generation, tick, beep logic, reps, navigation |

### State Tests — 100% coverage
| className    | testFilePath                          | covers |
|-------------|---------------------------------------|--------|
| WorkoutState | test/state/workout_state_test.dart    | All public methods, notifyListeners, DI |

### Widget Tests — 1:1 with § 2.1
| widgetName         | testFilePath                                          | covers (components)                    |
|--------------------|-------------------------------------------------------|----------------------------------------|
| WorkoutDisplay     | test/widgets/workout/workout_display_test.dart        | text-1, text-2, text-3                 |
| NavigationControls | test/widgets/workout/navigation_controls_test.dart    | iconbutton-2, button-1, iconbutton-3   |
| PauseButton        | test/widgets/workout/pause_button_test.dart           | iconbutton-4                           |

### Screen Tests
| screenName    | testFilePath                              | covers |
|---------------|-------------------------------------------|--------|
| WorkoutScreen | test/screens/workout_screen_test.dart     | Provider setup, navigation, background colors |

### Shared Test Helpers
| filePath                             | purpose              |
|--------------------------------------|----------------------|
| test/helpers/mock_services.dart      | Manual mock services |

---

# 3. Existing components to reuse
| componentName   | filePath                            | purpose of reuse         | notes |
|-----------------|-------------------------------------|--------------------------|-------|
| VolumeHeader    | lib/widgets/volume_header.dart      | Slider volume partagé    | onMenuPressed: null pour Workout |
| AppColors       | lib/theme/app_colors.dart           | Couleurs des étapes      | — |
| Preset          | lib/models/preset.dart              | Modèle d'entrée         | — |

---

# 4. Widget Breakdown (existing widgets — no new widgets)
| compId       | type       | variant   | key                     | widgetName         | filePath                                      | buildStrategy          | notes |
|-------------|------------|-----------|-------------------------|--------------------|-----------------------------------------------|------------------------|-------|
| iconbutton-1 | IconButton | ghost     | workout__iconbutton-1   | VolumeHeader       | lib/widgets/volume_header.dart               | rule:iconButton/shaped | reuse |
| slider-1     | Slider     | —         | workout__slider-1       | VolumeHeader       | lib/widgets/volume_header.dart               | rule:slider/theme      | reuse |
| icon-1       | Icon       | —         | —                       | —                  | —                                             | rule:slider/normalizeSiblings(drop) | thumb-like sibling |
| iconbutton-2 | IconButton | ghost     | workout__iconbutton-2   | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:iconButton/shaped | — |
| button-1     | Button     | secondary | workout__button-1       | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:button/secondary  | long-press |
| iconbutton-3 | IconButton | ghost     | workout__iconbutton-3   | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:iconButton/shaped | — |
| text-1       | Text       | —         | workout__text-1         | WorkoutDisplay     | lib/widgets/workout/workout_display.dart     | rule:text/transform    | reps counter |
| text-2       | Text       | —         | workout__text-2         | WorkoutDisplay     | lib/widgets/workout/workout_display.dart     | rule:text/transform    | timer |
| text-3       | Text       | —         | workout__text-3         | WorkoutDisplay     | lib/widgets/workout/workout_display.dart     | rule:text/transform    | step label, uppercase |
| iconbutton-4 | IconButton | ghost     | workout__iconbutton-4   | PauseButton        | lib/widgets/workout/pause_button.dart        | rule:iconButton/shaped | FAB |

---

# 5. Layout Composition (existing — no changes)
## 5.1 Hierarchy
- root: Scaffold (backgroundColor: dynamic per step)
  - body: GestureDetector (onTap → show controls)
    - SafeArea
      - Stack
        - Column
          - AnimatedOpacity → VolumeHeader
          - AnimatedOpacity → NavigationControls
          - Spacer
          - WorkoutDisplay
          - Spacer
        - AnimatedPositioned → PauseButton (FAB bottom-right)

---

# 6. Interaction Wiring (from spec)
| compId       | actionName       | stateImpact                              | navigation | a11y (ariaLabel)       | notes |
|-------------|------------------|------------------------------------------|-----------|------------------------|-------|
| slider-1     | onVolumeChange   | volume → new value, prefs saved          | —         | Volume slider          | — |
| iconbutton-2 | previousStep     | currentStep, remainingTime reset         | —         | Précédent              | — |
| button-1     | onLongPress      | isExiting → true                         | pop→Home  | Maintenir pour sortir  | long-press 1s |
| iconbutton-3 | nextStep         | currentStep, remainingTime reset         | —         | Suivant                | — |
| iconbutton-4 | togglePause      | isPaused toggled                         | —         | Mettre en pause        | Toggle icon |
| container-1  | onScreenTap      | controlsVisible → true, restart hide timer | —       | —                      | — |

---

# 7. State Model & Actions (from spec §6)
## 7.1 Fields
| key              | type     | default              | persistence | notes |
|------------------|----------|---------------------|-------------|-------|
| currentStep      | StepType | (first step)        | non         | From engine |
| remainingTime    | int      | (step duration)     | non         | From engine |
| remainingReps    | int      | preset.repetitions  | non         | From engine |
| formattedTime    | String   | (computed)          | non         | MM:SS format |
| isPaused         | bool     | false               | non         | — |
| isExiting        | bool     | false               | non         | — |
| isComplete       | bool     | false               | non         | — |
| controlsVisible  | bool     | true                | non         | Auto-hide 1500ms |
| volume           | double   | (from prefs)        | oui         | Shared key with Home |

## 7.2 Actions
| name            | input         | output | errors | description |
|-----------------|---------------|--------|--------|-------------|
| tick            | —             | —      | —      | Delegate to engine.tick(), play beep if needed, check completion |
| togglePause     | —             | —      | —      | Toggle isPaused, manage ticker subscription |
| nextStep        | —             | —      | —      | Delegate to engine.moveToNext(), reset timer |
| previousStep    | —             | —      | —      | Delegate to engine.moveToPrevious(), reset timer |
| onScreenTap     | —             | —      | —      | Show controls, restart 1500ms hide timer |
| onVolumeChange  | double value  | —      | —      | Update volume, audio.setVolume, save to prefs |
| onLongPress     | —             | —      | —      | Set isExiting = true |

---

# 8. Accessibility Plan
| order | compId       | role   | ariaLabel              | focusable | shortcut | notes |
|------:|-------------|--------|------------------------|-----------|----------|-------|
| 1     | iconbutton-1 | button | Activer ou désactiver le son | true | — | — |
| 2     | slider-1     | slider | Volume slider          | true      | —        | — |
| 3     | iconbutton-2 | button | Précédent              | true      | —        | — |
| 4     | button-1     | button | Maintenir pour sortir  | true      | —        | Long-press |
| 5     | iconbutton-3 | button | Suivant                | true      | —        | — |
| 6     | iconbutton-4 | button | Mettre en pause        | true      | —        | Toggle |

---

# 9. Testing Plan
| testId | preconditions              | steps (concise)                | oracle (expected)                                |
|--------|----------------------------|--------------------------------|--------------------------------------------------|
| T1     | Preset 5/3x(40/20)/10     | Build engine, check steps      | [prep(5), work(40), rest(20), work(40), rest(20), work(40), cooldown(10)] |
| T2     | Engine, step with time=3   | tick() ×4                      | Beeps at 2,1,0; advance to next step             |
| T3     | Engine, work→rest→work     | Advance through                | Reps decremented only on rest→work               |
| T4     | Preset 0/3x(40/20)/0      | Build engine                   | No prep/cooldown steps in list                   |
| T5     | WorkoutState               | togglePause()                  | isPaused=true, notifyListeners                   |
| T6     | WorkoutState               | onVolumeChange(0.5)            | volume=0.5, audio.setVolume(0.5)                 |
| T7     | WorkoutState               | onLongPress()                  | isExiting=true                                   |
| T8     | WorkoutDisplay, work step  | Render                         | text-1 visible, text-3 = localized "WORK"        |
| T9     | PauseButton, not paused    | Render                         | Icon = Icons.pause                               |
| T10    | NavigationControls         | tap previous                   | previousStep() called on state                   |

---

# 10. Test Generation Plan

## 10.1 Domain Tests

### StepType (`test/domain/step_type_test.dart`)
| Test Case | Priority | Coverage Type |
|-----------|----------|---------------|
| All enum values exist | CRITICAL | Unit |

### WorkoutEngine (`test/domain/workout_engine_test.dart`)
| Method | Test Case | Priority | Coverage Type |
|--------|-----------|----------|---------------|
| constructor | Generates correct step list from preset | CRITICAL | Unit |
| constructor | Skips 0-second steps | CRITICAL | Boundary |
| constructor | Skips last rest | CRITICAL | Unit |
| constructor | Single repetition preset | HIGH | Boundary |
| tick() | Decrements remainingTime | CRITICAL | Unit |
| tick() | Returns shouldBeep=true at 2,1,0 | CRITICAL | Unit |
| tick() | Advances to next step at 0 | CRITICAL | Unit |
| tick() | Decrements reps on rest→work | CRITICAL | Unit |
| tick() | Sets isComplete at end | CRITICAL | Unit |
| moveToNext() | Advances step index | HIGH | Unit |
| moveToNext() | At last step, sets isComplete | HIGH | Boundary |
| moveToPrevious() | Decrements step index | HIGH | Unit |
| moveToPrevious() | At first step, stays | HIGH | Boundary |
| formattedTime | Formats MM:SS correctly | HIGH | Unit |
| currentStep | Returns correct StepType | HIGH | Unit |
| remainingReps | Returns correct count | HIGH | Unit |

**Coverage Target:** 100% lines, 100% branches

## 10.2 State Tests (`test/state/workout_state_test.dart`)

| Method | Test Case | Priority | Coverage Type |
|--------|-----------|----------|---------------|
| constructor | Initial values from engine | CRITICAL | Unit |
| constructor | Loads volume from prefs | CRITICAL | Unit |
| tick() | Delegates to engine, calls notifyListeners | CRITICAL | Unit |
| tick() | Plays beep when engine.shouldBeep | CRITICAL | Integration |
| tick() | Sets isComplete when engine complete | CRITICAL | Unit |
| togglePause() | Toggles isPaused | CRITICAL | Unit |
| togglePause() | Calls notifyListeners | CRITICAL | Unit |
| nextStep() | Delegates to engine.moveToNext | HIGH | Unit |
| previousStep() | Delegates to engine.moveToPrevious | HIGH | Unit |
| onScreenTap() | Sets controlsVisible=true | HIGH | Unit |
| onVolumeChange() | Updates volume | HIGH | Unit |
| onVolumeChange() | Calls audio.setVolume | HIGH | Integration |
| onVolumeChange() | Saves to prefs | HIGH | Integration |
| onLongPress() | Sets isExiting=true | HIGH | Unit |
| formattedTime | Delegates to engine | HIGH | Unit |
| dispose() | Cleans up resources | HIGH | Unit |

**Coverage Target:** 100% lines, 100% branches

## 10.3 Widget Tests (existing — update to use new State)

| Widget | Component Key | Test Case | Expected Behavior |
|--------|---------------|-----------|-------------------|
| WorkoutDisplay | workout__text-1 | Reps visible during work | Visibility.visible=true |
| WorkoutDisplay | workout__text-2 | Timer shows formattedTime | Correct text |
| WorkoutDisplay | workout__text-3 | Step label localized | PRÉPARER/TRAVAIL/REPOS/REFROIDIR |
| NavigationControls | workout__iconbutton-2 | Tap calls previousStep | State method invoked |
| NavigationControls | workout__button-1 | Long-press calls onLongPress | State method invoked |
| PauseButton | workout__iconbutton-4 | Shows pause/play icon | Correct icon per isPaused |

## 10.4 Components excluded from tests
| Component | Reason |
|-----------|--------|
| icon-1 | Dropped (slider thumb sibling) |
| VolumeHeader | Tested separately (shared widget, not in scope) |

---

# 11. Risks / Unknowns
- —

---

# 12. Check Gates
- [x] Analyzer/lint pass
- [x] Unique keys check
- [x] Controlled vocabulary validation
- [x] A11y labels presence
- [x] Routes exist and compile
- [x] Token usage present in theme
- [x] Test coverage thresholds (State/Domain: 100%, Overall: ≥80%)

---

# 13. Checklist
- [x] Keys assigned on interactive widgets
- [x] Texts verbatim + transform
- [x] Variants/placement/widthMode valid
- [x] Actions wired to state methods
- [x] Test generation plan complete
