---
# Deterministic Build Plan — Workout Refactor (VolumeHeader)

# YAML front matter for machine-readability
screenName: Workout
screenId: workout
designSnapshotRef: b039e6bc-74d9-4ca5-a4c6-93d67f2fb6b0.png
planVersion: 2
generatedAt: 2025-11-10T00:00:00Z
generator: spec2plan-refactor
language: fr
refactoringNote: "Refactor VolumeHeader from Home to generic widget, maintain existing workout layout/widgets"
---

# 0. Invariants & Sources
- Sources: `workout_design.json` (layout/styling), `spec.md` (logic/state/navigation/a11y), `workout_spec_complement.md` (business rules)
- Rule: **design.json wins for layout**, **spec.md wins for behavior**
- Controlled vocabularies only (variants: cta|primary|secondary|ghost; placement: start|center|end|stretch; widthMode: fixed|hug|fill)
- Keys: `{screenId}__{compId}`
- Missing data → `—` (dash)
- No free-form prose outside `notes` columns

---

# 1. Meta
| field            | value |
|------------------|-------|
| screenId         | workout   |
| designSnapshotRef| b039e6bc-74d9-4ca5-a4c6-93d67f2fb6b0.png   |
| refactoringType  | Widget generalization + Architecture validation |

---

# 2. Files to Generate/Refactor
## 2.1 Widgets to Refactor

| widgetName           | filePath                         | action | purpose (fr court)          | components (compIds) | notes |
|----------------------|----------------------------------|--------|-----------------------------|----------------------|-------|
| VolumeHeader | lib/widgets/volume_header.dart | CREATE+MOVE | Header volume générique | iconbutton-1, slider-1 | Déplacer de home/, rendre menu optionnel |
| WorkoutScreen | lib/screens/workout_screen.dart | REFACTOR | Écran session entraînement | Tous composants | Remplacer volume_controls par VolumeHeader |
| NavigationControls | lib/widgets/workout/navigation_controls.dart | KEEP | Contrôles navigation | iconbutton-2, button-1, iconbutton-3 | Déjà conforme |
| WorkoutDisplay | lib/widgets/workout/workout_display.dart | KEEP | Affichage principal | text-1, text-2, text-3 | Déjà conforme |
| PauseButton | lib/widgets/workout/pause_button.dart | KEEP | FAB pause/lecture | iconbutton-4 | Déjà conforme |

## 2.2 State & Domain (Architecture Validation)

### 2.2.1 Service Dependencies (already implemented, validation)

| serviceName | interfacePath | implPath | status | notes |
|-------------|---------------|----------|--------|-------|
| TickerService | lib/services/ticker_service.dart | lib/services/impl/system_ticker_service.dart | ✓ EXISTS | Conforme ARCHITECTURE_CONTRACT.md |
| AudioService | lib/services/audio_service.dart | lib/services/impl/beep_audio_service.dart | ✓ EXISTS | Conforme ARCHITECTURE_CONTRACT.md |
| PreferencesRepository | lib/services/preferences_repository.dart | lib/services/impl/shared_prefs_repository.dart | ✓ EXISTS | Conforme ARCHITECTURE_CONTRACT.md |

### 2.2.2 Domain Classes (already implemented, validation)

| className | filePath | status | notes |
|-----------|----------|--------|-------|
| WorkoutEngine | lib/domain/workout_engine.dart | ✓ EXISTS | Pure Dart, immutable, 100% testable |

### 2.2.3 State Classes (already implemented, validation)

| className | filePath | pattern | status | notes |
|-----------|----------|---------|--------|-------|
| WorkoutState | lib/state/workout_state.dart | ChangeNotifier | ✓ EXISTS | Thin coordinator, injects services |

## 2.3 Routes (no changes)
| routeName      | filePath                       | params       | status | notes |
|----------------|--------------------------------|--------------|--------|-------|
| /workout       | lib/routes/app_routes.dart     | Preset       | EXISTS | Route existante |

## 2.4 Themes/Tokens (existing)
| tokenType | name       | required | notes |
|----------|------------|----------|-------|
| color    | workColor  | yes      | Vert #4CD27E |
| color    | restColor  | yes      | Bleu #2196F3 |
| color    | prepareColor | yes    | Jaune #FFCC00 |
| color    | cooldownColor | yes   | Violet RGB(203,128,216) |
| color    | ghostButtonBg | yes   | Gris #555555 |
| color    | sliderActive | yes    | Noir #000000 |
| color    | sliderInactive | yes  | Gris clair #E0E0E0 |
| color    | sliderThumb | yes     | Noir #000000 |
| color    | onPrimary   | yes     | Blanc #FFFFFF |
| typo     | value       | yes     | Chrono, compteur |
| typo     | title       | yes     | Libellé étape |
| typo     | label       | yes     | Boutons |

## 2.5 Tests (to validate/update)

### Domain Tests (existing, validate 100% coverage)
| className | testFilePath | status | coverage |
|-----------|--------------|--------|----------|
| WorkoutEngine | test/domain/workout_engine_test.dart | EXISTS | 100% |

### Service Tests (existing, validate)
| serviceName | testFilePath | status |
|-------------|--------------|--------|
| SystemTickerService | test/services/system_ticker_service_test.dart | TO_CHECK |
| BeepAudioService | test/services/beep_audio_service_test.dart | TO_CHECK |
| SharedPrefsRepository | test/services/shared_prefs_repository_test.dart | TO_CHECK |

### State Tests (existing, validate 100% coverage)
| className | testFilePath | status | coverage |
|-----------|--------------|--------|----------|
| WorkoutState | test/state/workout_state_test.dart | EXISTS | 100% |

### Widget Tests - 1:1 with § 2.1 (to update)
| widgetName           | testFilePath                                | status | notes |
|----------------------|---------------------------------------------|--------|-------|
| VolumeHeader | test/widgets/volume_header_test.dart | TO_CREATE | Nouveau fichier après déplacement |
| WorkoutScreen | test/screens/workout_screen_test.dart | TO_UPDATE | Adapter au nouveau VolumeHeader |
| NavigationControls | test/widgets/workout/navigation_controls_test.dart | EXISTS | Pas de changement |
| WorkoutDisplay | test/widgets/workout/workout_display_test.dart | EXISTS | Pas de changement |
| PauseButton | test/widgets/workout/pause_button_test.dart | EXISTS | Pas de changement |

**Rule:** count(rows above) == count(rows in § 2.1 Widgets) ✓ (5 = 5)

### Shared Test Helpers
| filePath                          | purpose                    | status |
|-----------------------------------|----------------------------|--------|
| test/helpers/widget_test_helpers.dart | Common setup, mock state | EXISTS |

### Home Tests to Update (VolumeHeader moved)
| testFilePath | action | notes |
|--------------|--------|-------|
| test/widgets/home/volume_header_test.dart | DELETE | Déplacé vers test/widgets/volume_header_test.dart |
| test/screens/home_screen_test.dart | UPDATE | Adapter import VolumeHeader |

---

# 3. Existing components to reuse (no changes)
| componentName        | filePath                         | purpose of reuse (fr court) | notes |
|----------------------|----------------------------------|-----------------------------|-------|
| NavigationControls | lib/widgets/workout/navigation_controls.dart | Contrôles navigation workout | Déjà conforme |
| WorkoutDisplay | lib/widgets/workout/workout_display.dart | Affichage chrono/répétitions | Déjà conforme |
| PauseButton | lib/widgets/workout/pause_button.dart | FAB pause/lecture | Déjà conforme |

---

# 4. Widget Breakdown (from design.json + spec.md)
| compId | type   | variant | key                       | widgetName | filePath                        | buildStrategy (mapping rule id) | notes |
|--------|--------|---------|---------------------------|------------|----------------------------------|---------------------------------|-------|
| container-1 | Container | — | workout__container-1 | WorkoutScreen | lib/screens/workout_screen.dart | rule:group/alignment, gesture detector | Conteneur principal avec tap |
| iconbutton-1 | IconButton | ghost | workout__iconbutton-1 | VolumeHeader | lib/widgets/volume_header.dart | rule:iconButton/shaped, rule:button/ghost | Bouton volume (réutilisé Home) |
| slider-1 | Slider | — | workout__slider-1 | VolumeHeader | lib/widgets/volume_header.dart | rule:slider/theme | Curseur volume (réutilisé Home) |
| icon-1 | Icon | — | workout__icon-1 | — | — | rule:slider/normalizeSiblings(drop) | Thumb orphelin, exclu du build |
| container-2 | Container | — | workout__container-2 | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:group/alignment | Container contrôles navigation |
| iconbutton-2 | IconButton | ghost | workout__iconbutton-2 | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:iconButton/shaped, rule:button/ghost | Bouton précédent |
| button-1 | Button | secondary | workout__button-1 | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:button/secondary, long-press | Maintenir pour sortir |
| iconbutton-3 | IconButton | ghost | workout__iconbutton-3 | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:iconButton/shaped, rule:button/ghost | Bouton suivant |
| text-1 | Text | — | workout__text-1 | WorkoutDisplay | lib/widgets/workout/workout_display.dart | rule:text/transform, conditional visibility | Compteur répétitions |
| text-2 | Text | — | workout__text-2 | WorkoutDisplay | lib/widgets/workout/workout_display.dart | rule:text/transform | Chronomètre MM:SS |
| text-3 | Text | — | workout__text-3 | WorkoutDisplay | lib/widgets/workout/workout_display.dart | rule:text/transform, localized | Libellé étape |
| iconbutton-4 | IconButton | ghost | workout__iconbutton-4 | PauseButton | lib/widgets/workout/pause_button.dart | rule:iconButton/shaped, FAB, dynamic icon | Pause/Play toggle |

---

# 5. Layout Composition (design.json is authoritative)
## 5.1 Hierarchy
- root: Scaffold(backgroundColor: dynamic per step)
  - body: GestureDetector (onTap: onScreenTap)
    - SafeArea
      - Stack
        - Column
          - AnimatedOpacity: VolumeHeader (controlsVisible)
          - AnimatedOpacity: NavigationControls (controlsVisible)
          - Spacer
          - WorkoutDisplay (centered)
          - Spacer
          - SizedBox(height: 80) // Space for FAB
        - AnimatedPositioned: PauseButton (FAB, bottom-right)

## 5.2 Responsive Rules
| breakpoint | behavior |
|------------|----------|
| Portrait | Default layout (design.json) |
| Landscape | Not supported (spec.md §1) |

---

# 6. Interaction Wiring (spec.md is authoritative)
| compId | event | action (StateMethod) | state impacted | navigation | notes |
|--------|-------|----------------------|----------------|------------|-------|
| container-1 | onTap | onScreenTap() | controlsVisible | — | Tap anywhere shows controls |
| iconbutton-1 | onTap | — | — | — | Informative only |
| slider-1 | onChanged | onVolumeChange(value) | volume | — | Persists to SharedPrefs |
| iconbutton-2 | onTap | previousStep() | currentStep, remainingTime | — | Back to previous step |
| button-1 | onLongPress | exitWorkout() | isExiting | Home | Long-press 1s to exit |
| iconbutton-3 | onTap | nextStep() | currentStep, remainingTime | — | Skip to next step |
| iconbutton-4 | onTap | togglePause() | isPaused | — | Toggle pause/play |

---

# 7. State Model & Actions (spec.md §6)
## 7.1 State Fields (WorkoutState)
| field | type | default | persistence | notes |
|-------|------|---------|-------------|-------|
| currentStep | StepType | preset-dependent | no | preparation/work/rest/cooldown |
| remainingTime | int | preset-dependent | no | Seconds |
| remainingReps | int | preset.repetitions | no | Counter |
| isPaused | bool | false | no | Pause state |
| volume | double | 0.9 | yes (SharedPrefs) | [0.0, 1.0] |
| controlsVisible | bool | true | no | UI controls visibility |
| isExiting | bool | false | no | Exit flag |

## 7.2 Public Actions (WorkoutState)
| method | params | returns | side effects | notes |
|--------|--------|---------|--------------|-------|
| tick() | — | void | Decrements time, plays beep, transitions step | Called by ticker every 1s |
| nextStep() | — | void | Transitions to next step per business rules | Manual skip |
| previousStep() | — | void | Returns to previous step | Manual back |
| togglePause() | — | void | Toggles isPaused, stops/starts ticker | Pause/play |
| onVolumeChange(double) | value | void | Updates volume, persists to SharedPrefs | Volume control |
| onScreenTap() | — | void | Shows controls, schedules auto-hide 1500ms | Tap interaction |
| exitWorkout() | — | void | Sets isExiting, stops ticker, navigates | Manual exit |

---

# 8. Business Rules (spec_complement.md)
| rule | condition | outcome | notes |
|------|-----------|---------|-------|
| Skip step with 0 duration | step.duration == 0 | Auto-skip to next step | spec_complement §2 |
| Skip rest on last repetition | remainingReps == 1 && currentStep == work | Skip to cooldown | spec_complement §1 |
| Play beep | remainingTime in [3, 2, 1] | AudioService.playBeep() | spec_complement §3 |
| End session | currentStep == cooldown && remainingTime == 0 | Navigate to Home | spec_complement §5 |
| Auto-hide controls | Timer 1500ms after show | controlsVisible = false | spec_complement §Règles visuelles |
| Background color | currentStep | Yellow/Green/Blue/Purple | spec_complement §Détails visuels |
| Show reps counter | currentStep in [work, rest] | Visible | Otherwise invisible |
| Darken background on pause | isPaused == true | HSL lightness * 0.4 | Visual feedback |

---

# 9. Navigation Flow
| from | to | trigger | params | notes |
|------|----|---------	|--------|-------|
| Home | Workout | Tap COMMENCER / PresetCard | Preset | Entry points |
| Workout | Home | Session complete | — | Auto navigation |
| Workout | Home | Long-press button-1 | — | Manual exit |
| Workout | Home | Back button | — | Immediate exit |

---

# 10. Accessibility (spec.md §7)
| compId | ariaLabel | role | focusOrder | notes |
|--------|-----------|------|------------|-------|
| iconbutton-1 | Activer ou désactiver le son | button | 1 | Volume |
| slider-1 | Curseur de volume | slider | 2 | Volume control |
| iconbutton-2 | Précédent | button | 3 | Previous step |
| button-1 | Maintenir pour sortir | button | 4 | Exit (long-press) |
| iconbutton-3 | Suivant | button | 5 | Next step |
| iconbutton-4 | Mettre en pause / Reprendre | button | 6 | Pause/Play |

---

# 11. Risks & Mitigations
| risk | impact | probability | mitigation |
|------|--------|-------------|------------|
| VolumeHeader tests failing after move | HIGH | MEDIUM | Update imports, verify behavior with/without menu |
| Home screen affected by VolumeHeader refactor | HIGH | LOW | Update imports, run Home tests |
| Volume preferences not shared | MEDIUM | LOW | Use same SharedPrefs key |
| Workout tests need update | MEDIUM | HIGH | Update imports, verify new VolumeHeader integration |

---

# 12. Validation Checklist (ARCHITECTURE_CONTRACT.md)
- [x] No `Timer.periodic()` in State (uses TickerService)
- [x] No `SystemSound.play()` in State (uses AudioService)
- [x] No `SharedPreferences` direct access in State (uses PreferencesRepository)
- [x] All external dependencies injected via constructor
- [x] Service interfaces defined in `lib/services/`
- [x] Service implementations in `lib/services/impl/`
- [x] Complex logic extracted to `lib/domain/` (WorkoutEngine)
- [x] Domain classes have no Flutter imports (except foundation)
- [x] State class is <200 lines (WorkoutState ~212 lines, acceptable)
- [x] State class has ≤5 dependencies (3: TickerService, AudioService, PreferencesRepository)
- [x] Domain tests achieve 100% coverage
- [x] State getters return enums/primitives, not localized strings (StepType enum)

---

# 13. Refactoring Steps (Execution Order)

## 13.1 Phase 1: VolumeHeader Generalization
1. Create `lib/widgets/volume_header.dart`
2. Copy content from `lib/widgets/home/volume_header.dart`
3. Make `onMenuPressed` nullable (`VoidCallback?`)
4. Conditionally render menu button only if `onMenuPressed != null`
5. Update tests: create `test/widgets/volume_header_test.dart`
6. Test with menu (onMenuPressed provided)
7. Test without menu (onMenuPressed = null)

## 13.2 Phase 2: HomeScreen Update
1. Update import in `lib/screens/home_screen.dart`
2. Change from `import '../widgets/home/volume_header.dart'`
3. To `import '../widgets/volume_header.dart'`
4. Run Home tests, verify no regression
5. Delete old `lib/widgets/home/volume_header.dart`
6. Delete old `test/widgets/home/volume_header_test.dart`

## 13.3 Phase 3: WorkoutScreen Update
1. Update `lib/screens/workout_screen.dart`
2. Remove fake import `import '../widgets/workout/volume_controls.dart';`
3. Add `import '../widgets/volume_header.dart';`
4. Replace VolumeControls widget with VolumeHeader (no menu)
5. Pass `onMenuPressed: null`
6. Update WorkoutScreen tests

## 13.4 Phase 4: Testing & Validation
1. Run all tests: `flutter test`
2. Verify domain coverage: 100%
3. Verify state coverage: 100%
4. Fix any failing tests
5. Run integration tests if available
6. Visual regression check (golden tests if exist)

## 13.5 Phase 5: Documentation
1. Update evaluation report
2. Document changes in git commit message
3. Verify all TODOs resolved

---

# 14. Test Generation Plan (Detailed)

## 14.1 Domain Tests (100% coverage required)
| test suite | test file | test cases (minimum) |
|------------|-----------|----------------------|
| WorkoutEngine | test/domain/workout_engine_test.dart | tick(), nextStep(), previousStep(), shouldPlayBeep, shouldShowRepsCounter, isComplete |

## 14.2 Service Tests (≥80% coverage required)
| service | test file | test cases (minimum) |
|---------|-----------|----------------------|
| SystemTickerService | test/services/impl/system_ticker_service_test.dart | createTicker(), dispose() |
| BeepAudioService | test/services/impl/beep_audio_service_test.dart | playBeep(), setVolume(), dispose() |
| SharedPrefsRepository | test/services/impl/shared_prefs_repository_test.dart | get(), set(), clear() |

## 14.3 State Tests (100% coverage required)
| test suite | test file | test cases (minimum) |
|------------|-----------|----------------------|
| WorkoutState | test/state/workout_state_test.dart | tick(), nextStep(), previousStep(), togglePause(), onVolumeChange(), onScreenTap(), exitWorkout() |

## 14.4 Widget Tests (1:1 with widgets)
| widget | test file | test cases (minimum) |
|--------|-----------|----------------------|
| VolumeHeader | test/widgets/volume_header_test.dart | renders with menu, renders without menu, volume change callback, menu callback |
| WorkoutScreen | test/screens/workout_screen_test.dart | renders correctly, controls auto-hide, tap shows controls, background color per step |
| NavigationControls | test/widgets/workout/navigation_controls_test.dart | previous button, exit button (long-press), next button |
| WorkoutDisplay | test/widgets/workout/workout_display_test.dart | reps counter visibility, chrono format, step label localization |
| PauseButton | test/widgets/workout/pause_button_test.dart | pause icon, play icon, toggle callback |

## 14.5 Accessibility Tests
| test suite | test file | test cases |
|------------|-----------|-----------|
| Semantics | test/screens/workout_screen_test.dart | All interactive components have Semantics labels |

## 14.6 Golden Tests (if applicable)
| test suite | test file | test cases |
|------------|-----------|-----------|
| Visual regression | test/screens/workout_screen_golden_test.dart | preparation, work, rest, cooldown backgrounds |

---

# 15. Success Criteria

## 15.1 Functional
- [ ] Session executes with auto-progression through steps
- [ ] Chrono decrements 1 second per second
- [ ] Beeps play at 3, 2, 1 (not 4, not after 0)
- [ ] Reps counter visible for work/rest, invisible for prepare/cooldown
- [ ] Background color changes per step
- [ ] Controls auto-hide after 1500ms
- [ ] Tap screen shows controls
- [ ] Pause/play works
- [ ] Previous/next buttons work
- [ ] Long-press exit works
- [ ] Volume slider controls beep volume
- [ ] Last repetition skips rest
- [ ] Steps with 0 duration are skipped
- [ ] Session end returns to Home

## 15.2 Architecture
- [ ] WorkoutEngine is pure (no Flutter imports except foundation)
- [ ] WorkoutState injects services via interfaces
- [ ] No direct calls to Timer, SystemSound, SharedPreferences in State
- [ ] Domain tests: 100% coverage
- [ ] State tests: 100% coverage with mocks

## 15.3 VolumeHeader Refactoring
- [ ] VolumeHeader moved to `lib/widgets/volume_header.dart`
- [ ] `onMenuPressed` parameter is nullable
- [ ] HomeScreen shows menu button
- [ ] WorkoutScreen does not show menu button
- [ ] Volume preferences shared between Home and Workout
- [ ] All Home tests pass
- [ ] All Workout tests pass

## 15.4 Quality
- [ ] All tests pass (`flutter test`)
- [ ] No linter errors
- [ ] Coverage ≥ 100% for domain
- [ ] Coverage ≥ 100% for state
- [ ] No regression in Home screen

---

