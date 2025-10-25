---
# Deterministic Build Plan — Workout

# YAML front matter for machine-readability
screenName: Workout
screenId: workout
designSnapshotRef: b039e6bc-74d9-4ca5-a4c6-93d67f2fb6b0.png
planVersion: 2
generatedAt: 2025-10-24T00:00:00Z
generator: spec2plan
language: fr
inputsHash: <sha256(design.json||spec.md)>
---

# 0. Invariants & Sources
- Sources: `design.json` (layout/styling), `spec.md` (logic/state/navigation/a11y)
- Rule: **design.json wins for layout**, **spec.md wins for behavior**
- Controlled vocabularies only (variants: cta|primary|secondary|ghost; placement: start|center|end|stretch; widthMode: fixed|hug|fill)
- Keys: `{screenId}__{compId}`
- Missing data → `—` (dash)
- No free-form prose outside `notes` columns

---

# 1. Meta
| field | value |
|-------|-------|
| screenId | workout |
| designSnapshotRef | b039e6bc-74d9-4ca5-a4c6-93d67f2fb6b0.png |
| inputsHash | <to-be-computed> |

---

# 2. Files to Generate
## 2.1 Widgets
| widgetName | filePath | purpose (fr court) | components (compIds) | notes |
|------------|----------|-------------------|----------------------|-------|
| WorkoutScreen | lib/screens/workout_screen.dart | Écran principal Workout | container-1, iconbutton-1, slider-1, container-2, iconbutton-2, button-1, iconbutton-3, text-1, text-2, text-3, iconbutton-4 | Écran complet avec timer |
| VolumeControls | lib/widgets/workout/volume_controls.dart | Contrôles de volume | iconbutton-1, slider-1, icon-1 | Haut de l'écran |
| NavigationControls | lib/widgets/workout/navigation_controls.dart | Boutons navigation | iconbutton-2, button-1, iconbutton-3 | Barre de contrôle |
| WorkoutDisplay | lib/widgets/workout/workout_display.dart | Affichage chronomètre et étape | text-1, text-2, text-3 | Centre de l'écran |
| PauseButton | lib/widgets/workout/pause_button.dart | FAB Pause/Play | iconbutton-4 | FAB en bas à droite |

## 2.2 State
| filePath | pattern | exposes (fields/actions) | persistence | notes |
|----------|---------|--------------------------|-------------|-------|
| lib/state/workout_state.dart | ChangeNotifier | preset, currentStep, remainingTime, remainingReps, isPaused, volume, soundEnabled, controlsVisible; startTimer, stopTimer, tick, nextStep, previousStep, togglePause, onVolumeChange, toggleSound, exitWorkout, onScreenTap, hideControlsAfterDelay, playBeep | volume, soundEnabled persistent | Gère le timer et les étapes |

## 2.3 Routes
| routeName | filePath | params | created/uses | notes |
|-----------|----------|--------|-------------|-------|
| /workout | lib/routes/app_routes.dart | Preset preset | creates | Route vers l'écran Workout |

## 2.4 Themes/Tokens
| tokenType | name | required | notes |
|-----------|------|----------|-------|
| color | primary | yes | Vert #4CD27E |
| color | onPrimary | yes | Blanc #FFFFFF |
| color | background | yes | Dynamique selon étape |
| color | textPrimary | yes | Noir #000000 |
| color | textSecondary | yes | Blanc #FFFFFF |
| color | ghostButtonBg | yes | Gris foncé #555555 |
| color | sliderActive | yes | Noir #000000 |
| color | sliderInactive | yes | Gris #E0E0E0 |
| color | sliderThumb | yes | Noir #000000 |
| color | workColor | yes | Vert #4CD27E (ajout) |
| color | restColor | yes | Bleu #2196F3 (ajout) |
| color | prepareColor | yes | Jaune #FFCC00 (ajout) |
| color | cooldownColor | yes | Jaune #FFCC00 (ajout) |
| typo | label | yes | Boutons |
| typo | value | yes | Chronomètre et compteur |
| typo | title | yes | Libellé étape |

## 2.5 Tests

### Widget Tests - 1:1 with § 2.1
| widgetName | testFilePath | covers (components from that widget) |
|------------|--------------|--------------------------------------|
| WorkoutScreen | test/screens/workout_screen_test.dart | Tous les composants de l'écran |
| VolumeControls | test/widgets/workout/volume_controls_test.dart | iconbutton-1, slider-1 |
| NavigationControls | test/widgets/workout/navigation_controls_test.dart | iconbutton-2, button-1, iconbutton-3 |
| WorkoutDisplay | test/widgets/workout/workout_display_test.dart | text-1, text-2, text-3 |
| PauseButton | test/widgets/workout/pause_button_test.dart | iconbutton-4 |

### State Tests
| testFilePath | covers |
|--------------|--------|
| test/state/workout_state_test.dart | WorkoutState (toutes les méthodes) |

### Shared Test Helpers
| filePath | purpose |
|----------|---------|
| test/helpers/widget_test_helpers.dart | Common setup functions |

---

# 3. Existing components to reuse
| componentName | filePath | purpose of reuse (fr court) | components (compIds) | notes |
|---------------|----------|----------------------------|----------------------|-------|
| Aucun | — | — | — | Nouvel écran, pas de composants existants à réutiliser |

# 4. Widget Breakdown (from design.json + UI Mapping Guide)
| compId | type | variant | key | widgetName | filePath | buildStrategy (mapping rule id) | notes |
|--------|------|---------|-----|------------|----------|--------------------------------|-------|
| container-1 | Container | — | workout__container-1 | WorkoutScreen | lib/screens/workout_screen.dart | rule:container/flex-column | Conteneur racine |
| iconbutton-1 | IconButton | ghost | workout__iconbutton-1 | VolumeControls | lib/widgets/workout/volume_controls.dart | rule:iconbutton/ghost | Toggle son |
| slider-1 | Slider | — | workout__slider-1 | VolumeControls | lib/widgets/workout/volume_controls.dart | rule:slider/standard | Contrôle volume |
| icon-1 | Icon | — | workout__icon-1 | — | — | rule:slider/normalizeSiblings(drop) | Thumb-like sibling, exclure |
| container-2 | Container | — | workout__container-2 | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:container/flex-row | Barre contrôles |
| iconbutton-2 | IconButton | ghost | workout__iconbutton-2 | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:iconbutton/ghost | Étape précédente |
| button-1 | Button | secondary | workout__button-1 | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:button/secondary-longpress | Long-press pour sortir |
| iconbutton-3 | IconButton | ghost | workout__iconbutton-3 | NavigationControls | lib/widgets/workout/navigation_controls.dart | rule:iconbutton/ghost | Étape suivante |
| text-1 | Text | — | workout__text-1 | WorkoutDisplay | lib/widgets/workout/workout_display.dart | rule:text/value | Compteur répétitions |
| text-2 | Text | — | workout__text-2 | WorkoutDisplay | lib/widgets/workout/workout_display.dart | rule:text/value | Chronomètre |
| text-3 | Text | — | workout__text-3 | WorkoutDisplay | lib/widgets/workout/workout_display.dart | rule:text/title-uppercase | Libellé étape |
| iconbutton-4 | IconButton | ghost | workout__iconbutton-4 | PauseButton | lib/widgets/workout/pause_button.dart | rule:iconbutton/fab | FAB pause/play |

---

# 5. Layout Composition (design.json is authoritative)
## 5.1 Hierarchy
- root: Stack (safeArea: false, full screen)
  - Background Container (couleur dynamique)
  - Column (main content)
    - section s_volume_controls → VolumeControls
    - section s_navigation_controls → NavigationControls
    - Spacer
    - section s_workout_display → WorkoutDisplay (center)
    - Spacer
  - section s_pause_control → PauseButton (positioned bottom-right)

## 5.2 Constraints & Placement
| container | child (widgetName) | flex | alignment (placement) | widthMode | spacing | scrollable |
|-----------|-------------------|------|-----------------------|-----------|---------|------------|
| root | Background | — | stretch | fill | 0 | false |
| root | Column | — | stretch | fill | 0 | false |
| Column | VolumeControls | — | start | fill | 0 | false |
| Column | NavigationControls | — | center | hug | 8 | false |
| Column | WorkoutDisplay | 1 | center | hug | 24 | false |
| root | PauseButton | — | end | hug | 16 | false |

---

# 6. Interaction Wiring (from spec)
| compId | actionName | stateImpact | navigation | a11y (ariaLabel) | notes |
|--------|------------|-------------|------------|------------------|-------|
| iconbutton-1 | toggleSound | soundEnabled | — | Activer ou désactiver le son | Toggle audio |
| slider-1 | onVolumeChange | volume | — | Curseur de volume | Ajuste volume [0.0, 1.0] |
| iconbutton-2 | previousStep | currentStep, remainingTime | — | Précédent | Revient à l'étape précédente |
| button-1 | exitWorkout | — | Home | Maintenir pour sortir | onLongPress (1s) |
| iconbutton-3 | nextStep | currentStep, remainingTime | — | Suivant | Passe à l'étape suivante |
| iconbutton-4 | togglePause | isPaused | — | Mettre en pause | Toggle pause/play, change icône |
| screen_tap | onScreenTap | controlsVisible | — | — | Toggle visibilité contrôles |

---

# 7. State Model & Actions (from spec §6)
## 7.1 Fields
| key | type | default | persistence | notes |
|-----|------|---------|-------------|-------|
| preset | Preset | (param) | non | Configuration session |
| currentStep | StepType | preparation | non | preparation, work, rest, cooldown |
| remainingTime | int | preset.preparationDuration | non | Secondes restantes |
| remainingReps | int | preset.repetitions | non | Répétitions restantes |
| isPaused | bool | false | non | État pause |
| volume | double | 0.9 | oui | Volume [0.0, 1.0] |
| soundEnabled | bool | true | oui | Audio on/off |
| controlsVisible | bool | true | non | Visibilité contrôles |
| lastTapTime | DateTime? | null | non | Timestamp dernier tap |

## 7.2 Actions
| name | input | output | errors | description |
|------|-------|--------|--------|-------------|
| startTimer | — | — | — | Démarre timer, tick 1s |
| stopTimer | — | — | — | Arrête timer |
| tick | — | — | — | Décrémente time, bip si <=3, next step si 0 |
| nextStep | — | — | — | Passe étape suivante (logique métier) |
| previousStep | — | — | — | Revient étape précédente |
| togglePause | — | — | — | Toggle isPaused, start/stop timer |
| onVolumeChange | double value | — | — | Met à jour volume |
| toggleSound | — | — | — | Toggle soundEnabled |
| exitWorkout | — | — | — | Navigation Home |
| onScreenTap | — | — | — | Show controls, update lastTapTime |
| hideControlsAfterDelay | — | — | — | Hide controls après 1s |
| playBeep | — | — | — | Émet bip au volume configuré |

---

# 8. Accessibility Plan
| order | compId | role | ariaLabel | focusable | shortcut | notes |
|-------|--------|------|-----------|-----------|----------|-------|
| 1 | iconbutton-1 | button | Activer ou désactiver le son | true | — | Toggle audio |
| 2 | slider-1 | slider | Curseur de volume | true | — | Volume control |
| 3 | iconbutton-2 | button | Précédent | true | — | Previous step |
| 4 | button-1 | button | Maintenir pour sortir | true | — | Long-press exit |
| 5 | iconbutton-3 | button | Suivant | true | — | Next step |
| 6 | iconbutton-4 | button | Mettre en pause | true | Space | Toggle pause |
| — | text-1 | text | — | false | — | Compteur |
| — | text-2 | text | — | false | — | Chronomètre |
| — | text-3 | text | — | false | — | Libellé étape |

---

# 9. Testing Plan (traceability to spec §10)
| testId | preconditions | steps (concise) | oracle (expected) | finder strategy |
|--------|---------------|-----------------|-------------------|-----------------|
| T1 | preset "5/3x(40/20)/10", step=preparation, time=0 | tick() | currentStep=work, remainingTime=40 | unit test |
| T2 | step=work, remainingReps=3, time=0 | tick() | currentStep=rest, remainingTime=20 | unit test |
| T3 | step=rest, remainingReps=1, time=0 | tick() | currentStep=cooldown | unit test |
| T4 | step=work, isPaused=false | togglePause() | isPaused=true | unit test |
| T5 | remainingTime=3 | tick() | playBeep() called | unit test |
| T6 | remainingTime=4 | tick() | playBeep() not called | unit test |
| T7 | preset "0/3x(40/20)/0" | initial state | currentStep=work | unit test |
| T8 | default state | tap iconbutton-4 | find.byIcon(Icons.play_arrow) | find.byKey |
| T9 | isPaused=true | tap iconbutton-4 | find.byIcon(Icons.pause) | find.byKey |
| T10 | — | long-press button-1 | navigation to Home | find.byKey |
| T11 | — | tap iconbutton-3 | nextStep() called | find.byKey |
| T12 | — | tap iconbutton-2 | previousStep() called | find.byKey |
| T13 | — | — | all interactive Semantics with label | a11y test |
| T14 | step=work | — | matches golden (green bg) | golden test |
| T15 | step=rest | — | matches golden (blue bg) | golden test |

---

# 10. Test Generation Plan

## 10.1 State Tests (`test/state/workout_state_test.dart`)

| Component | Method | Test Case | Priority | Coverage Type |
|-----------|--------|-----------|----------|---------------|
| WorkoutState | tick | Décrémente remainingTime | CRITICAL | Unit |
| WorkoutState | tick | Passe à step suivant quand time=0 | CRITICAL | Boundary |
| WorkoutState | tick | Émet bip quand time<=3 | HIGH | Unit |
| WorkoutState | tick | N'émet pas bip quand time>3 | HIGH | Unit |
| WorkoutState | nextStep | Passe preparation→work | CRITICAL | Unit |
| WorkoutState | nextStep | Passe work→rest | CRITICAL | Unit |
| WorkoutState | nextStep | Passe rest→work (si reps>1) | CRITICAL | Boundary |
| WorkoutState | nextStep | Skip rest si lastRep | CRITICAL | Boundary |
| WorkoutState | nextStep | Skip step si duration=0 | HIGH | Boundary |
| WorkoutState | previousStep | Revient work→preparation | HIGH | Unit |
| WorkoutState | previousStep | Revient rest→work | HIGH | Unit |
| WorkoutState | togglePause | Toggle isPaused true→false | CRITICAL | Unit |
| WorkoutState | togglePause | Toggle isPaused false→true | CRITICAL | Unit |
| WorkoutState | onVolumeChange | Met à jour volume | HIGH | Unit |
| WorkoutState | toggleSound | Toggle soundEnabled | HIGH | Unit |
| WorkoutState | onScreenTap | Show controls | HIGH | Unit |
| WorkoutState | hideControlsAfterDelay | Hide controls après 1s | HIGH | Integration |
| WorkoutState | playBeep | Joue son au volume configuré | HIGH | Unit |
| WorkoutState | initial values | Preset params correctement initialisés | CRITICAL | Unit |
| WorkoutState | persistence | volume et soundEnabled sauvegardés | HIGH | Integration |

**Coverage Target:** 100% lines, 100% branches

---

## 10.2 Widget Tests

| Widget | Component Key | Test Case | Expected Behavior |
|--------|---------------|-----------|-------------------|
| WorkoutScreen | workout__container-1 | Renders all sections | All child widgets present |
| WorkoutScreen | — | Background color changes | Correct color per step |
| VolumeControls | workout__iconbutton-1 | Toggle sound | soundEnabled toggles |
| VolumeControls | workout__slider-1 | Slider interaction | volume updates |
| NavigationControls | workout__iconbutton-2 | Tap previous | previousStep() called |
| NavigationControls | workout__button-1 | Long-press exit | navigates to Home |
| NavigationControls | workout__iconbutton-3 | Tap next | nextStep() called |
| WorkoutDisplay | workout__text-1 | Reps counter | Shows correct reps |
| WorkoutDisplay | workout__text-1 | Hide in preparation | Not visible in prep step |
| WorkoutDisplay | workout__text-2 | Timer format | Shows "MM:SS" format |
| WorkoutDisplay | workout__text-3 | Step label | Shows correct label (uppercase) |
| PauseButton | workout__iconbutton-4 | Toggle pause | Icon changes pause↔play |
| PauseButton | workout__iconbutton-4 | FAB position | Positioned bottom-right |

**Coverage Target:** ≥90% for generic widgets, ≥70% for screen-specific widgets

---

## 10.3 Accessibility Tests

| Widget | Component Key | Semantic Label | Role | State |
|--------|---------------|----------------|------|-------|
| VolumeControls | workout__iconbutton-1 | Activer ou désactiver le son | button | enabled |
| VolumeControls | workout__slider-1 | Curseur de volume | slider | enabled |
| NavigationControls | workout__iconbutton-2 | Précédent | button | enabled |
| NavigationControls | workout__button-1 | Maintenir pour sortir | button | enabled |
| NavigationControls | workout__iconbutton-3 | Suivant | button | enabled |
| PauseButton | workout__iconbutton-4 | Mettre en pause | button | enabled |

---

## 10.4 Components excluded from tests

| Component | Reason |
|-----------|--------|
| icon-1 | Thumb-like sibling near slider, excluded per validation report |

---

## 2.6 Translations Plan

### ARB Files to Generate
| File | Locale | Purpose |
|------|--------|---------|
| lib/l10n/app_en.arb | en | English translations (default) |
| lib/l10n/app_fr.arb | fr | French translations |

### Text Extraction from Design
| Component | Text Content | ARB Key | Description |
|-----------|--------------|---------|-------------|
| button-1 | Maintenir pour sortir | workoutExitButton | Long-press to exit button |
| text-3 (work) | TRAVAIL | workoutStepWork | Work step label |
| text-3 (rest) | REPOS | workoutStepRest | Rest step label |
| text-3 (prepare) | PRÉPARER | workoutStepPrepare | Prepare step label |
| text-3 (cooldown) | REFROIDIR | workoutStepCooldown | Cooldown step label |
| iconbutton-1 | Activer ou désactiver le son | workoutToggleSound | Toggle sound button label |
| iconbutton-2 | Précédent | workoutPrevious | Previous step button |
| iconbutton-3 | Suivant | workoutNext | Next step button |
| iconbutton-4 | Mettre en pause | workoutPause | Pause button |
| iconbutton-4 (play) | Reprendre | workoutResume | Resume button |

### i18n Configuration
- File: `l10n.yaml` (already exists)
- Template: `app_en.arb`
- Output: `app_localizations.dart`

### main.dart Setup
- Import: `flutter_localizations` (already configured)
- Delegates: Already configured in main.dart
- Supported locales: Already configured `[Locale('en'), Locale('fr')]`

---

# 11. Risks / Unknowns (from spec §11.3)
- Type exact de bip sonore (fréquence, durée) : utiliser un son système par défaut
- Comportement si app en arrière-plan : timer continue (à tester)
- Animation transition entre étapes : pas d'animation pour v1, transition instantanée

---

# 12. Check Gates
- Analyzer/lint pass
- Unique keys check (workout__{compId})
- Controlled vocabulary validation (variants, placement, widthMode)
- A11y labels presence (tous les interactifs)
- Routes exist and compile (/workout avec param Preset)
- Token usage present in theme (toutes les couleurs step)
- Test coverage thresholds (State/Model: 100%, Overall: ≥80%)
- Widget-to-test ratio 1:1 verified (5 widgets = 5 test files)

---

# 13. Checklist (subset of PR_CHECKLIST)
- [ ] Keys assigned on interactive widgets (workout__{compId})
- [ ] Texts verbatim + transform (TRAVAIL, REPOS, PRÉPARER, REFROIDIR en uppercase)
- [ ] Variants/placement/widthMode valid (ghost, secondary selon design)
- [ ] Actions wired to state methods (tous les callbacks vers WorkoutState)
- [ ] Golden-ready (stable layout, couleur dynamique selon step)
- [ ] Test generation plan complete (tous les State methods listés, tous les widgets ont test)
- [ ] Icon-1 excluded from build (thumb sibling)
- [ ] Long-press handler on button-1 (1s delay)
- [ ] Timer tick every 1s
- [ ] Beep on last 3 seconds
- [ ] Controls auto-hide after 1s
- [ ] Controls show on screen tap
- [ ] Background color changes per step
- [ ] FAB icon toggles pause/play
- [ ] Navigation to Home on exit
- [ ] Skip steps with duration=0
- [ ] Skip last rep rest step

