---
# Deterministic Build Plan — Workout Refactor Iteration 3

# YAML front matter for machine-readability
screenName: ChronometreTravail
screenId: workout
designSnapshotRef: b039e6bc-74d9-4ca5-a4c6-93d67f2fb6b0.png
planVersion: 2
generatedAt: 2025-11-11T00:00:00Z
generator: spec2plan
language: fr
inputsHash: workout_design_v1_spec_v2

---

# 0. Invariants & Sources
- Sources: `workout_design.json` (layout/styling), `spec.md` (logic/state/navigation/a11y)
- Rule: **design.json wins for layout**, **spec.md wins for behavior**
- Controlled vocabularies only (variants: cta|primary|secondary|ghost; placement: start|center|end|stretch; widthMode: fixed|hug|fill)
- Keys: `{screenId}__{compId}`
- Missing data → `—` (dash)
- No free-form prose outside `notes` columns
- **Constraint: Keep existing workout widgets visual structure, adapt to new business objects**

---

# 1. Meta
| field            | value |
|------------------|-------|
| screenId         | workout   |
| designSnapshotRef| b039e6bc-74d9-4ca5-a4c6-93d67f2fb6b0.png   |
| inputsHash       | workout_design_v1_spec_v2   |

---

# 2. Files to Generate
## 2.1 Widgets

**Widgets to keep (already exist, adapt to new objects):**
| widgetName           | filePath                         | purpose (fr court)          | components (compIds) | notes |
|----------------------|----------------------------------|-----------------------------|----------------------|-------|
| NavigationControls   | lib/widgets/workout/navigation_controls.dart | Contrôles de navigation (précédent/sortir/suivant) | iconbutton-2, button-1, iconbutton-3 | Adapter aux méthodes WorkoutState |
| WorkoutDisplay       | lib/widgets/workout/workout_display.dart | Affichage principal (compteur répétitions, chronomètre, libellé étape) | text-1, text-2, text-3 | Adapter aux getters WorkoutState |
| PauseButton          | lib/widgets/workout/pause_button.dart | FAB pause/play | iconbutton-4 | Adapter à togglePause() |

**Note:** VolumeHeader est partagé entre Home et Workout, pas de modification nécessaire.

## 2.2 State
| filePath                         | pattern            | exposes (fields/actions)            | persistence | notes |
|----------------------------------|--------------------|-------------------------------------|-------------|-------|
| lib/state/workout_state.dart     | ChangeNotifier     | currentStep,remainingTime,remainingReps,isPaused,volume,controlsVisible;tick,nextStep,previousStep,togglePause,onVolumeChange,onScreenTap,onLongPress | volume (oui) | Thin coordinator, delegates to WorkoutEngine |

## 2.2.1 Service Dependencies

**Service Interfaces (Already Exist - Reuse):**
| interfacePath                      | implPath                                          | reason                          | methods                 |
|------------------------------------|---------------------------------------------------|---------------------------------|-------------------------|
| lib/services/ticker_service.dart   | lib/services/impl/system_ticker_service.dart      | Non-mockable Timer.periodic     | createTicker(Duration), dispose() |
| lib/services/audio_service.dart    | lib/services/impl/beep_audio_service.dart         | Non-mockable SystemSound        | playBeep(), setVolume(double), get volume, dispose() |
| lib/services/preferences_repository.dart | lib/services/impl/shared_prefs_repository.dart | Mockable SharedPreferences      | get<T>(String), set<T>(String, T), remove(String), clear() |

**Domain Classes (Pure Business Logic - To Create):**
| domainPath                         | purpose                         | extracted from (State logic)    |
|------------------------------------|--------------------------------|---------------------------------|
| lib/domain/workout_engine.dart     | Step progression, timer logic, transition rules | WorkoutState tick/nextStep/previousStep |
| lib/domain/step_type.dart          | Enum for step types             | StepType enum (preparation, work, rest, cooldown) |

## 2.3 Routes
| routeName      | filePath                       | params       | created/uses | notes |
|----------------|--------------------------------|--------------|-------------|-------|
| /workout       | lib/routes/app_routes.dart     | Preset preset | uses        | Already exists |

## 2.4 Themes/Tokens
| tokenType | name       | required | notes |
|----------|------------|----------|-------|
| color    | primary    | yes      | #4CD27E (vert) |
| color    | onPrimary  | yes      | #FFFFFF |
| color    | textPrimary | yes     | #000000 |
| color    | textSecondary | yes   | #FFFFFF |
| color    | prepareColor | yes    | #FFCC00 (jaune) |
| color    | workColor  | yes      | #4CD27E (vert) |
| color    | restColor  | yes      | #2196F3 (bleu) |
| color    | cooldownColor | yes   | rgb(203, 128, 216) (violet) |
| color    | ghostButtonBg | yes   | #555555 |
| color    | sliderActiveDark | yes | #000000 |
| color    | sliderInactiveDark | yes | #E0E0E0 |

## 2.5 Tests (to be generated in steps 05/06)

### Domain Tests
| domainClass           | testFilePath                                | coverage requirement |
|-----------------------|---------------------------------------------|----------------------|
| WorkoutEngine         | test/domain/workout_engine_test.dart        | 100% lines, 100% branches |
| StepType              | test/domain/step_type_test.dart             | 100% lines, 100% branches |

### State Tests
| stateClass            | testFilePath                                | coverage requirement |
|-----------------------|---------------------------------------------|----------------------|
| WorkoutState          | test/state/workout_state_test.dart          | 100% lines, 100% branches |

### Widget Tests - 1:1 with § 2.1
| widgetName           | testFilePath                                | covers (components from that widget) |
|----------------------|---------------------------------------------|--------------------------------------|
| NavigationControls   | test/widgets/workout/navigation_controls_test.dart | iconbutton-2, button-1, iconbutton-3 |
| WorkoutDisplay       | test/widgets/workout/workout_display_test.dart | text-1, text-2, text-3 |
| PauseButton          | test/widgets/workout/pause_button_test.dart | iconbutton-4 |

**Rule:** count(rows above) == 3 (all existing widgets)

### Screen Tests
| screenName           | testFilePath                                | coverage requirement |
|----------------------|---------------------------------------------|----------------------|
| WorkoutScreen        | test/screens/workout_screen_test.dart       | ≥60% lines |

### Shared Test Helpers
| filePath                          | purpose                    |
|-----------------------------------|----------------------------|
| test/helpers/widget_test_helpers.dart | Common setup functions (already exists) |

---

# 3. Existing components to reuse
| componentName        | filePath                         | purpose of reuse (fr court) | components (compIds) | notes |
|----------------------|----------------------------------|-----------------------------|----------------------|-------|
| VolumeHeader         | lib/widgets/volume_header.dart   | Contrôle volume partagé Home/Workout | iconbutton-1, slider-1, icon-1 | Volume persisté avec même clé que Home |
| Preset               | lib/models/preset.dart           | Modèle de préréglage d'entraînement | — | Déjà complet avec tous les champs |

---

# 4. Widget Breakdown (from design.json + UI Mapping Guide)
| compId | type   | variant | key                       | widgetName | filePath                        | buildStrategy (mapping rule id) | notes |
|--------|--------|---------|---------------------------|------------|----------------------------------|---------------------------------|-------|
| container-1 | Container | — | workout__container-1 | GestureDetector (screen tap) | lib/screens/workout_screen.dart | rule:container/tap-detector | Wrap tout l'écran pour détecter tap |
| iconbutton-1 | IconButton | ghost | workout__iconbutton-1 | VolumeHeader | lib/widgets/volume_header.dart | rule:reuse/existing | Réutilisé depuis Home |
| slider-1 | Slider | — | workout__slider-1 | VolumeHeader | lib/widgets/volume_header.dart | rule:reuse/existing | Réutilisé depuis Home |
| icon-1 | Icon | — | workout__icon-1 | VolumeHeader | lib/widgets/volume_header.dart | rule:reuse/existing | Thumb du slider |
| container-2 | Container | — | workout__container-2 | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:container/row | Row avec justifyContent:spaceBetween |
| iconbutton-2 | IconButton | ghost | workout__iconbutton-2 | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:iconbutton/ghost | Précédent (skip_previous) |
| button-1 | Button | secondary | workout__button-1 | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:button/long-press | Long press pour sortir |
| iconbutton-3 | IconButton | ghost | workout__iconbutton-3 | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:iconbutton/ghost | Suivant (skip_next) |
| text-1 | Text | — | workout__text-1 | WorkoutDisplay | lib/widgets/workout/workout_display.dart | rule:text/conditional | Compteur répétitions (visible si work/rest) |
| text-2 | Text | — | workout__text-2 | WorkoutDisplay | lib/widgets/workout/workout_display.dart | rule:text/formatted | Chronomètre MM:SS |
| text-3 | Text | — | workout__text-3 | WorkoutDisplay | lib/widgets/workout/workout_display.dart | rule:text/uppercase | Libellé étape (PRÉPARER/TRAVAIL/REPOS/REFROIDIR) |
| iconbutton-4 | IconButton | ghost | workout__iconbutton-4 | PauseButton | lib/widgets/workout/pause_button.dart | rule:fab/conditional-icon | FAB pause/play selon état |

---

# 5. Layout Composition (design.json is authoritative)
## 5.1 Hierarchy
- root: Scaffold (backgroundColor: dynamic selon currentStep)
  - body: GestureDetector (onTap: onScreenTap)
    - SafeArea
      - Stack
        - Column (mainContent)
          - AnimatedOpacity (controlsVisible) → VolumeHeader
          - AnimatedOpacity (controlsVisible) → NavigationControls
          - Spacer
          - WorkoutDisplay
          - Spacer
          - SizedBox(height: 80) // Espace pour FAB
        - AnimatedPositioned (FAB)
          - PauseButton

## 5.2 Constraints & Placement
| container | child (widgetName) | flex | alignment (placement) | widthMode | spacing | scrollable |
|-----------|---------------------|------|------------------------|-----------|---------|------------|
| Column    | VolumeHeader        | —    | stretch                | fill      | 0       | false      |
| Column    | NavigationControls  | —    | center                 | hug       | 0       | false      |
| Column    | WorkoutDisplay      | —    | center                 | hug       | 0       | false      |
| Stack     | PauseButton         | —    | bottom-right           | fixed     | 16      | false      |

---

# 6. Interaction Wiring (from spec)
| compId | actionName   | stateImpact          | navigation | a11y (ariaLabel) | notes |
|--------|--------------|----------------------|-----------|------------------|-------|
| iconbutton-1 | toggleMute | volume | — | Activer ou désactiver le son | Via VolumeHeader |
| slider-1 | onVolumeChange | volume | — | Curseur de volume | Via VolumeHeader |
| iconbutton-2 | previousStep | currentStep, remainingTime | — | Précédent | Revient à l'étape précédente |
| button-1 | onLongPress | isExiting | Home (pop) | Maintenir pour sortir | Long press 1 seconde |
| iconbutton-3 | nextStep | currentStep, remainingTime | — | Suivant | Passe à l'étape suivante |
| iconbutton-4 | togglePause | isPaused | — | Mettre en pause / Démarrer | Pause/play chrono |
| container-1 | onScreenTap | controlsVisible | — | — | Affiche/masque contrôles |

---

# 7. State Model & Actions (from spec §6)
## 7.1 Fields
| key          | type | default | persistence | notes |
|--------------|------|---------|-------------|-------|
| preset       | Preset | (param) | non | Configuration de la session |
| currentStep  | StepType | preparation | non | Étape actuelle |
| remainingTime | int | preset.prepareSeconds | non | Temps restant pour l'étape |
| remainingReps | int | preset.repetitions | non | Répétitions restantes |
| isPaused     | bool | false | non | Chronomètre en pause |
| volume       | double | (loaded) | oui | Volume [0.0, 1.0], clé: 'home_volume' |
| controlsVisible | bool | true | non | Contrôles visibles/masqués |
| isExiting    | bool | false | non | Demande de sortie manuelle |
| _controlsTimer | Timer? | null | non | Timer pour masquer contrôles après 1500ms |

## 7.2 Actions
| name        | input | output | errors | description |
|-------------|-------|--------|--------|-------------|
| tick        | — | — | — | Décrémente remainingTime, joue bip si nécessaire, passe à l'étape suivante si 0 |
| nextStep    | — | — | — | Passe à l'étape suivante (délégué à WorkoutEngine) |
| previousStep | — | — | — | Revient à l'étape précédente (délégué à WorkoutEngine) |
| togglePause | — | — | — | Inverse isPaused, arrête/reprend ticker |
| onVolumeChange | double value | — | — | Met à jour volume, persiste, audioService.setVolume() |
| onScreenTap | — | — | — | Affiche contrôles, lance timer 1500ms |
| onLongPress | — | — | — | Met isExiting=true, déclenche navigation |
| toggleMute  | — | — | — | Toggle volume 0/valeur précédente |
| dispose     | — | — | — | Libère ressources (ticker, audio, timer) |

---

# 8. Accessibility Plan
| order | compId | role        | ariaLabel    | focusable | shortcut | notes |
|------:|--------|-------------|--------------|-----------|----------|-------|
| 1     | iconbutton-1 | button | Activer ou désactiver le son | true | — | — |
| 2     | slider-1 | slider | Curseur de volume | true | — | — |
| 3     | iconbutton-2 | button | Précédent | true | — | — |
| 4     | button-1 | button | Maintenir pour sortir | true | — | Long press requis |
| 5     | iconbutton-3 | button | Suivant | true | — | — |
| 6     | iconbutton-4 | button | Mettre en pause / Démarrer | true | — | Label dynamique |
| —     | text-1 | text | — | false | — | Lecteur d'écran lit compteur |
| —     | text-2 | text | — | false | — | Lecteur d'écran lit chrono |
| —     | text-3 | text | — | false | — | Lecteur d'écran lit étape |

---

# 9. Testing Plan (traceability to spec §10)
| testId | preconditions | steps (concise)       | oracle (expected)                                  | finder strategy |
|--------|----------------|-----------------------|----------------------------------------------------|-----------------|
| T1     | preset=5/3x(40/20)/10 | initialize | currentStep=preparation, remainingTime=5 | unit test |
| T2     | currentStep=preparation, remainingTime=1 | tick() | currentStep=work, remainingTime=40 | unit test |
| T3     | currentStep=work, remainingTime=1, remainingReps=3 | tick() | currentStep=rest, remainingTime=20 | unit test |
| T4     | currentStep=rest, remainingTime=1, remainingReps=3 | tick() | currentStep=work, remainingReps=2 | unit test |
| T5     | currentStep=work, remainingTime=1, remainingReps=1 | tick() | currentStep=cooldown (pas de rest) | unit test |
| T6     | remainingTime=2 | tick() | bip sonore joué | unit test (mock audio) |
| T7     | remainingTime=1 | tick() | bip sonore joué | unit test (mock audio) |
| T8     | remainingTime=0 | tick() | bip sonore joué + transition | unit test (mock audio) |
| T9     | isPaused=false | togglePause() | isPaused=true, ticker stopped | unit test |
| T10    | isPaused=true | togglePause() | isPaused=false, ticker resumed | unit test |
| T11    | currentStep=work | nextStep() | currentStep=rest, remainingTime reset | unit test |
| T12    | currentStep=rest | previousStep() | currentStep=work, remainingTime reset | unit test |
| T13    | volume=0.5 | onVolumeChange(0.8) | volume=0.8, persisted | unit test (mock prefs) |
| T14    | controlsVisible=false | onScreenTap() | controlsVisible=true, timer 1500ms lancé | unit test |
| T15    | preset.prepareSeconds=0 | initialize | currentStep=work (préparation ignorée) | unit test |
| T16    | preset.cooldownSeconds=0, remainingReps=1 | tick() until end | session terminée, navigation Home | unit test |
| T17    | — | render | find.byKey('workout__text-2') exists | widget test |
| T18    | currentStep=work | render | backgroundColor=#4CD27E | widget test |
| T19    | isPaused=false | tap iconbutton-4 | isPaused=true | widget test |
| T20    | — | long press button-1 | navigation pop | widget test |
| T21    | controlsVisible=false | tap screen | contrôles visibles | widget test |
| T22    | — | a11y scan | all interactive components have Semantics | a11y test |

---

# 10. Test Generation Plan

## 10.1 Domain Tests (`test/domain/`)

**WorkoutEngine Tests:**
| Component | Method | Test Case | Priority | Coverage Type |
|-----------|--------|-----------|----------|---------------|
| WorkoutEngine | constructor | Initialize with preset 5/3x(40/20)/10 → currentStep=preparation, remainingTime=5 | CRITICAL | Unit |
| WorkoutEngine | constructor | Initialize with preset 0/3x(40/20)/0 → currentStep=work (skip preparation) | CRITICAL | Boundary |
| WorkoutEngine | tick | preparation, remainingTime=1 → tick → work, remainingTime=40 | CRITICAL | Unit |
| WorkoutEngine | tick | work, remainingTime=1, remainingReps=3 → tick → rest, remainingTime=20 | CRITICAL | Unit |
| WorkoutEngine | tick | rest, remainingTime=1, remainingReps=3 → tick → work, remainingReps=2 | CRITICAL | Unit |
| WorkoutEngine | tick | work, remainingTime=1, remainingReps=1 → tick → cooldown (skip rest) | CRITICAL | Boundary |
| WorkoutEngine | tick | cooldown, remainingTime=1 → tick → finished | CRITICAL | Unit |
| WorkoutEngine | tick | remainingTime=0 → tick → no change (guard) | CRITICAL | Edge |
| WorkoutEngine | shouldPlayBeep | remainingTime=3 → false | CRITICAL | Boundary |
| WorkoutEngine | shouldPlayBeep | remainingTime=2 → true | CRITICAL | Boundary |
| WorkoutEngine | shouldPlayBeep | remainingTime=1 → true | CRITICAL | Boundary |
| WorkoutEngine | shouldPlayBeep | remainingTime=0 → true | CRITICAL | Boundary |
| WorkoutEngine | nextStep | work → rest (if not last rep) | CRITICAL | Unit |
| WorkoutEngine | nextStep | work → cooldown (if last rep) | CRITICAL | Boundary |
| WorkoutEngine | previousStep | rest → work | CRITICAL | Unit |
| WorkoutEngine | previousStep | work → preparation | CRITICAL | Unit |
| WorkoutEngine | previousStep | preparation → no change (guard) | CRITICAL | Edge |

**StepType Tests:**
| Component | Method | Test Case | Priority | Coverage Type |
|-----------|--------|-----------|----------|---------------|
| StepType | enum values | All values defined (preparation, work, rest, cooldown) | CRITICAL | Unit |

**Coverage Target:** 100% lines, 100% branches

---

## 10.2 State Tests (`test/state/workout_state_test.dart`)

| Component | Method | Test Case | Priority | Coverage Type |
|-----------|--------|-----------|----------|---------------|
| WorkoutState | constructor | Initialize with preset → fields correct | CRITICAL | Unit |
| WorkoutState | load volume | Load volume from SharedPreferences | CRITICAL | Unit |
| WorkoutState | load volume | Missing volume → default 0.62 | CRITICAL | Boundary |
| WorkoutState | tick | Delegates to engine.tick() | CRITICAL | Unit |
| WorkoutState | tick | Calls audioService.playBeep() if shouldPlayBeep | CRITICAL | Integration |
| WorkoutState | tick | Calls notifyListeners() | CRITICAL | Unit |
| WorkoutState | nextStep | Delegates to engine.nextStep() | CRITICAL | Unit |
| WorkoutState | nextStep | Calls notifyListeners() | CRITICAL | Unit |
| WorkoutState | previousStep | Delegates to engine.previousStep() | CRITICAL | Unit |
| WorkoutState | previousStep | Calls notifyListeners() | CRITICAL | Unit |
| WorkoutState | togglePause | isPaused false → true, stops ticker | CRITICAL | Unit |
| WorkoutState | togglePause | isPaused true → false, resumes ticker | CRITICAL | Unit |
| WorkoutState | togglePause | Calls notifyListeners() | CRITICAL | Unit |
| WorkoutState | onVolumeChange | Updates volume, persists, setVolume on audioService | CRITICAL | Integration |
| WorkoutState | onVolumeChange | Calls notifyListeners() | CRITICAL | Unit |
| WorkoutState | onScreenTap | Sets controlsVisible=true | CRITICAL | Unit |
| WorkoutState | onScreenTap | Launches 1500ms timer | CRITICAL | Unit |
| WorkoutState | onScreenTap | Timer expires → controlsVisible=false | CRITICAL | Integration |
| WorkoutState | onScreenTap | isPaused=true → no auto-hide | CRITICAL | Boundary |
| WorkoutState | onLongPress | Sets isExiting=true | CRITICAL | Unit |
| WorkoutState | onLongPress | Calls notifyListeners() | CRITICAL | Unit |
| WorkoutState | toggleMute | volume>0 → volume=0 | CRITICAL | Unit |
| WorkoutState | toggleMute | volume=0 → restore previous | CRITICAL | Unit |
| WorkoutState | dispose | Disposes all services | CRITICAL | Unit |
| WorkoutState | formattedTime | 80 seconds → "01:20" | CRITICAL | Unit |
| WorkoutState | formattedTime | 0 seconds → "00:00" | CRITICAL | Boundary |
| WorkoutState | backgroundColor | preparation → prepareColor | CRITICAL | Unit |
| WorkoutState | backgroundColor | work → workColor | CRITICAL | Unit |
| WorkoutState | backgroundColor | rest → restColor | CRITICAL | Unit |
| WorkoutState | backgroundColor | cooldown → cooldownColor | CRITICAL | Unit |
| WorkoutState | stepLabel | Returns correct localized label | CRITICAL | Unit |

**Coverage Target:** 100% lines, 100% branches

---

## 10.3 Widget Tests

**NavigationControls (`test/widgets/workout/navigation_controls_test.dart`):**
| Widget | Component Key | Test Case | Expected Behavior |
|--------|---------------|-----------|-------------------|
| NavigationControls | workout__iconbutton-2 | Render | Icon skip_previous visible |
| NavigationControls | workout__button-1 | Render | Text "Maintenir pour sortir" visible |
| NavigationControls | workout__iconbutton-3 | Render | Icon skip_next visible |
| NavigationControls | workout__iconbutton-2 | Tap | Calls state.previousStep() |
| NavigationControls | workout__iconbutton-3 | Tap | Calls state.nextStep() |
| NavigationControls | workout__button-1 | Long press | Calls state.onLongPress() |

**WorkoutDisplay (`test/widgets/workout/workout_display_test.dart`):**
| Widget | Component Key | Test Case | Expected Behavior |
|--------|---------------|-----------|-------------------|
| WorkoutDisplay | workout__text-1 | Render work | Displays remainingReps |
| WorkoutDisplay | workout__text-1 | Render preparation | Not visible |
| WorkoutDisplay | workout__text-2 | Render | Displays formattedTime |
| WorkoutDisplay | workout__text-3 | Render | Displays step label in uppercase |
| WorkoutDisplay | workout__text-3 | work step | Displays "TRAVAIL" |
| WorkoutDisplay | workout__text-3 | rest step | Displays "REPOS" |

**PauseButton (`test/widgets/workout/pause_button_test.dart`):**
| Widget | Component Key | Test Case | Expected Behavior |
|--------|---------------|-----------|-------------------|
| PauseButton | workout__iconbutton-4 | Render isPaused=false | Icon pause visible |
| PauseButton | workout__iconbutton-4 | Render isPaused=true | Icon play_arrow visible |
| PauseButton | workout__iconbutton-4 | Tap | Calls state.togglePause() |

**WorkoutScreen (`test/screens/workout_screen_test.dart`):**
| Screen | Component Key | Test Case | Expected Behavior |
|--------|---------------|-----------|-------------------|
| WorkoutScreen | workout__container-1 | Render | All main widgets present |
| WorkoutScreen | workout__container-1 | Tap screen | Calls state.onScreenTap() |
| WorkoutScreen | — | Background color | Matches currentStep color |
| WorkoutScreen | — | Controls visibility | AnimatedOpacity matches controlsVisible |

**Coverage Target:** ≥90% for widget-specific, ≥70% for screen, ≥60% for integration

---

## 10.4 Accessibility Tests

| Widget | Component Key | Semantic Label | Role | State |
|--------|---------------|----------------|------|-------|
| VolumeHeader | workout__iconbutton-1 | Activer ou désactiver le son | button | enabled |
| VolumeHeader | workout__slider-1 | Curseur de volume | slider | enabled |
| NavigationControls | workout__iconbutton-2 | Précédent | button | enabled |
| NavigationControls | workout__button-1 | Maintenir pour sortir | button | enabled |
| NavigationControls | workout__iconbutton-3 | Suivant | button | enabled |
| PauseButton | workout__iconbutton-4 | Mettre en pause / Démarrer | button | enabled |

---

## 10.5 Components excluded from tests

| Component | Reason        |
|-----------|---------------|
| Icon-1 (slider thumb) | Decorative, handled by Slider widget |
| Container-1 | Structural only, tested via screen test |
| Container-2 | Structural only, tested via NavigationControls |

---

## 10.6 Translations Plan

### ARB Files to Update
| File | Locale | Purpose |
|------|--------|---------|
| lib/l10n/app_fr.arb | fr | Add Workout screen labels |

### Text Extraction from Design + Spec
| Component | Text Content | ARB Key | Description |
|-----------|--------------|---------|-------------|
| text-3 (preparation) | "PRÉPARER" | workout_step_prepare | Label for preparation step |
| text-3 (work) | "TRAVAIL" | workout_step_work | Label for work step |
| text-3 (rest) | "REPOS" | workout_step_rest | Label for rest step |
| text-3 (cooldown) | "REFROIDIR" | workout_step_cooldown | Label for cooldown step |
| button-1 | "Maintenir pour sortir" | workout_hold_to_exit | Button label to exit workout |
| iconbutton-1 | "Activer ou désactiver le son" | workout_toggle_sound | Accessibility label for volume toggle |
| iconbutton-2 | "Précédent" | workout_previous | Accessibility label for previous button |
| iconbutton-3 | "Suivant" | workout_next | Accessibility label for next button |
| iconbutton-4 (pause) | "Mettre en pause" | workout_pause | Accessibility label for pause button |
| iconbutton-4 (play) | "Démarrer" | workout_resume | Accessibility label for resume button |

### i18n Configuration
- File: `lib/l10n/l10n.yaml` (already exists)
- Template: `app_fr.arb` (primary locale)
- Output: `app_localizations.dart` (already generated)

---

# 11. Risks / Unknowns (from spec §11.3)
- **Lifecycle management:** Comportement si l'app passe en background pendant une session ? (hors périmètre itération 3)
- **State persistence:** Session non sauvegardée, reprend au démarrage ? (hors périmètre itération 3)
- **SystemTickerService evaluation:** Vérifier si implémentation actuelle est conforme aux besoins (tick précis à la seconde)

---

# 12. Check Gates
- [ ] Analyzer/lint pass (`flutter analyze --no-fatal-infos`)
- [ ] Unique keys check (no duplicate keys across widgets)
- [ ] Controlled vocabulary validation (variants, placement, widthMode)
- [ ] A11y labels presence (all interactive components)
- [ ] Routes exist and compile (`/workout` route)
- [ ] Token usage present in theme (prepareColor, workColor, restColor, cooldownColor)
- [ ] Test coverage thresholds:
  - [ ] Domain: 100% lines, 100% branches
  - [ ] State: 100% lines, 100% branches
  - [ ] Widgets: ≥90% lines (generic), ≥70% lines (screen-specific)
  - [ ] Overall: ≥80% lines
- [ ] Volume shared correctly between Home and Workout (same SharedPreferences key)
- [ ] No modifications to VolumeHeader widget
- [ ] No modifications to BeepAudioService
- [ ] No modifications to SharedPrefsRepository

---

# 13. Checklist (subset of PR_CHECKLIST)
- [ ] Keys assigned on interactive widgets (workout__{compId})
- [ ] Texts verbatim + transform (PRÉPARER, TRAVAIL, REPOS, REFROIDIR)
- [ ] Variants/placement/widthMode valid
- [ ] Actions wired to state methods (tick, nextStep, previousStep, togglePause, etc.)
- [ ] Domain layer extracted (WorkoutEngine pure business logic)
- [ ] State as thin coordinator (delegates to WorkoutEngine)
- [ ] Service interfaces injected via constructor (TickerService, AudioService, PreferencesRepository)
- [ ] Test generation plan complete (all methods listed)
- [ ] Existing widgets adapted (not rewritten)
- [ ] Visual structure preserved

