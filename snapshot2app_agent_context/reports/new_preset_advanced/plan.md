---
# Deterministic Build Plan — Preset Editor Advanced

screenName: Interval Timer – Advanced Edit
screenId: preset_editor_advanced
designSnapshotRef: Screenshot_20260304_110158_Interval_Timer.jpg
planVersion: 2
generatedAt: 2026-03-04T12:00:00Z
generator: spec2plan
language: fr
inputsHash: —
---

# 0. Invariants & Sources
- Sources: `design.json` (layout/styling), `spec.md` (logic/state/navigation/a11y)
- Rule: **design.json wins for layout**, **spec.md wins for behavior**
- Controlled vocabularies only (variants: cta|primary|secondary|ghost; placement: start|center|end|stretch; widthMode: fixed|hug|fill)
- Keys: `preset_editor_advanced__{compId}`
- Missing data → `—` (dash)
- No free-form prose outside `notes` columns

---

# 1. Meta
| field            | value                                                  |
|------------------|--------------------------------------------------------|
| screenId         | preset_editor_advanced                                 |
| designSnapshotRef| Screenshot_20260304_110158_Interval_Timer.jpg          |
| inputsHash       | —                                                      |

---

# 2. Files to Generate

## 2.1 Widgets

| widgetName                    | filePath                                                         | purpose (fr court)                         | components (compIds)                                 | notes                |
|-------------------------------|------------------------------------------------------------------|--------------------------------------------|------------------------------------------------------|----------------------|
| AdvancedGroupCard             | lib/widgets/preset_editor/advanced_group_card.dart               | Carte groupe (reps + liste d'étapes)       | card-0, text-4, iconbutton-3..4, text-5              | Réutilisé N fois     |
| AdvancedStepCard              | lib/widgets/preset_editor/advanced_step_card.dart                | Carte étape (nom, TIME/REPS, contrôles)    | card-1, text-6..9, iconbutton-5..9, button-2         | Réutilisé par groupe |
| StepModeToggle                | lib/widgets/preset_editor/step_mode_toggle.dart                  | Toggle TIME/REPS                           | text-7, text-8 (text-11, text-12, etc.)              | Générique            |
| StepValueControl              | lib/widgets/preset_editor/step_value_control.dart                | Contrôle ±/valeur pour étape (temps/reps)  | iconbutton-6..7, text-9                              | Réutilise pattern    |
| StepActionBar                 | lib/widgets/preset_editor/step_action_bar.dart                   | Barre actions : COLOR, dupliquer, supprimer | button-2, iconbutton-8, iconbutton-9                | Générique            |
| AddStepButton                 | lib/widgets/preset_editor/add_step_button.dart                   | Bouton "+" ajouter étape + sous-total      | iconbutton-19, text-16                               | Bas de chaque groupe |
| AddGroupButton                | lib/widgets/preset_editor/add_group_button.dart                  | Bouton "+" ajouter groupe + TOTAL          | iconbutton-40, text-31                               | Bas de la liste      |
| FinishCard                    | lib/widgets/preset_editor/finish_card.dart                       | Carte FINISH (couleur + alarme)            | card-7, text-32..34, button-6, icon-4                | —                    |
| AdvancedParamsPanel           | lib/widgets/preset_editor/advanced_params_panel.dart             | Panneau principal mode ADVANCED            | Orchestre tous les widgets ci-dessus                  | Remplace placeholder |
| ColorPickerDialog             | lib/widgets/preset_editor/color_picker_dialog.dart               | Dialog de sélection couleur                | —                                                    | —                    |

## 2.2 State

| filePath                                         | pattern            | exposes (fields/actions)                                             | persistence | notes                      |
|--------------------------------------------------|--------------------|----------------------------------------------------------------------|-------------|-----------------------------|
| lib/state/preset_editor_state.dart (EXTEND)      | ChangeNotifier     | groups, finishColor, finishAlarmBeeps; addGroup, removeGroup, addStep, removeStep, duplicateStep, reorderStep, toggleStepMode, increment/decrementStepValue, setStepColor, setFinishColor, save (extended) | oui | Extend existing state |

## 2.2.1 Service Dependencies

**Service Interfaces & Implementations:**

| interfacePath | implPath | reason | methods |
|---------------|----------|--------|---------|
| — | — | No new services needed | — |

**Domain Classes (Pure Business Logic):**

| domainPath                                    | purpose                                  | extracted from (State logic)              |
|-----------------------------------------------|------------------------------------------|-------------------------------------------|
| lib/domain/step_mode.dart                     | Enum for step mode: time, reps           | PresetEditorState step toggle             |
| lib/models/workout_group.dart                 | Immutable WorkoutGroup model             | State groups field                        |
| lib/models/advanced_step.dart                 | Immutable AdvancedStep model             | State step management                     |
| lib/domain/advanced_preset_calculator.dart    | Total duration calc for advanced presets | PresetEditorState formattedTotal          |

## 2.3 Routes

| routeName       | filePath                       | params       | created/uses | notes                             |
|-----------------|--------------------------------|--------------|-------------|-----------------------------------|
| /preset_editor  | lib/routes/app_routes.dart     | viewMode?    | uses (extend)| Add viewMode param support        |

## 2.4 Themes/Tokens

| tokenType | name              | required | notes                                  |
|-----------|-------------------|----------|----------------------------------------|
| color     | stepMagenta       | yes      | #CC1177 — new token                    |
| color     | stepLavender      | yes      | #B39DDB — new token                    |
| color     | stepGreen         | yes      | #388E3C — new token                    |
| color     | stepRed           | yes      | #D32F2F — new token                    |
| color     | finishYellow      | yes      | #CDDC39 — new token                    |
| color     | addButtonBg       | yes      | #FFFFFF — new token                    |
| color     | addButtonFg       | yes      | #000000 — new token                    |
| color     | advancedBg        | yes      | #000000 — dark background for ADVANCED |
| color     | advancedCardBg    | yes      | #1C1C1C — card background for ADVANCED |
| color     | advancedInputBorder| yes     | #555555 — input border for ADVANCED    |

## 2.5 Tests (to be generated in steps 05/06)

### Widget Tests - 1:1 with § 2.1

| widgetName              | testFilePath                                                    | covers (components)                              |
|-------------------------|-----------------------------------------------------------------|--------------------------------------------------|
| AdvancedGroupCard       | test/widgets/preset_editor/advanced_group_card_test.dart        | card-0, reps ±, group header                     |
| AdvancedStepCard        | test/widgets/preset_editor/advanced_step_card_test.dart         | card-1/2, step display, TIME/REPS mode           |
| StepModeToggle          | test/widgets/preset_editor/step_mode_toggle_test.dart           | text-7/8 toggle, bold/muted states               |
| StepValueControl        | test/widgets/preset_editor/step_value_control_test.dart         | ± buttons, value display, bounds                 |
| StepActionBar           | test/widgets/preset_editor/step_action_bar_test.dart            | COLOR, duplicate, delete buttons                 |
| AddStepButton           | test/widgets/preset_editor/add_step_button_test.dart            | + button, subtotal text                          |
| AddGroupButton          | test/widgets/preset_editor/add_group_button_test.dart           | + button, TOTAL text                             |
| FinishCard              | test/widgets/preset_editor/finish_card_test.dart                | FINISH title, COLOR button, ALARM display        |
| AdvancedParamsPanel     | test/widgets/preset_editor/advanced_params_panel_test.dart      | Full panel integration                           |
| ColorPickerDialog       | test/widgets/preset_editor/color_picker_dialog_test.dart        | Dialog display, color selection                  |

**Rule:** count(rows above) = 10 == count(rows in § 2.1 Widgets) = 10 ✓

### Shared Test Helpers

| filePath                           | purpose                                 |
|------------------------------------|-----------------------------------------|
| test/helpers/mock_services.dart    | Common setup (existing, may extend)     |

---

# 3. Existing components to reuse

| componentName          | filePath                                              | purpose of reuse (fr court)                    | notes                            |
|------------------------|-------------------------------------------------------|------------------------------------------------|----------------------------------|
| PresetEditorHeader     | lib/widgets/preset_editor/preset_editor_header.dart   | Header SIMPLE/ADVANCED + Close/Save            | Réutilisé tel quel               |
| PresetNameInput        | lib/widgets/preset_editor/preset_name_input.dart      | Champ nom du preset                            | Réutilisé tel quel               |
| PresetTotalDisplay     | lib/widgets/preset_editor/preset_total_display.dart   | Affichage total en bas (adapté mode ADVANCED)  | Adapter calcul pour advanced     |
| ModeToggleButton       | lib/widgets/preset_editor/mode_toggle_button.dart     | Bouton toggle SIMPLE/ADVANCED dans header      | Réutilisé tel quel               |
| ValueControl           | lib/widgets/value_control.dart                        | Pattern de référence pour ± controls           | Inspiration, pas réutilisation directe (style différent en ADVANCED) |
| PresetEditorState      | lib/state/preset_editor_state.dart                    | State existant à étendre                       | Ajouter champs/méthodes ADVANCED |
| AppColors              | lib/theme/app_colors.dart                             | Tokens couleur existants                       | Ajouter nouveaux tokens          |
| AppTextStyles          | lib/theme/app_text_styles.dart                        | Styles texte existants                         | Ajouter style muted si absent    |
| TimeFormatter          | lib/domain/time_formatter.dart                        | Formatage mm:ss                                | Réutilisé pour affichage durées  |
| ViewMode               | lib/domain/view_mode.dart                             | Enum simple/advanced                           | Réutilisé tel quel               |

---

# 4. Widget Breakdown (from design.json + UI Mapping Guide)

| compId        | type       | variant   | key                                        | widgetName             | buildStrategy                      | notes                         |
|---------------|------------|-----------|---------------------------------------------|------------------------|------------------------------------|-------------------------------|
| iconbutton-0  | IconButton | ghost     | preset_editor_advanced__iconbutton-0       | PresetEditorHeader     | rule:reuse/existing                | Existing                      |
| button-0      | Button     | ghost     | preset_editor_advanced__button-0           | PresetEditorHeader     | rule:reuse/existing                | Existing                      |
| button-1      | Button     | secondary | preset_editor_advanced__button-1           | PresetEditorHeader     | rule:reuse/existing                | Existing                      |
| iconbutton-1  | IconButton | ghost     | preset_editor_advanced__iconbutton-1       | PresetEditorHeader     | rule:reuse/existing                | Existing                      |
| text-2/text-3 | Text       | —         | preset_editor_advanced__text-2             | PresetNameInput        | rule:reuse/existing                | Existing                      |
| card-0        | Card       | —         | preset_editor_advanced__card-0             | AdvancedGroupCard      | rule:card/group                    | —                             |
| text-4        | Text       | —         | preset_editor_advanced__text-4             | AdvancedGroupCard      | rule:text/label                    | "RÉPÉTITIONS"                 |
| iconbutton-3  | IconButton | secondary | preset_editor_advanced__iconbutton-3       | AdvancedGroupCard      | rule:button/secondary              | Diminuer reps                 |
| text-5        | Text       | —         | preset_editor_advanced__text-5             | AdvancedGroupCard      | rule:text/value                    | Reps count display            |
| iconbutton-4  | IconButton | secondary | preset_editor_advanced__iconbutton-4       | AdvancedGroupCard      | rule:button/secondary              | Augmenter reps                |
| card-1        | Card       | —         | preset_editor_advanced__card-1             | AdvancedStepCard       | rule:card/step                     | —                             |
| text-6        | Text       | —         | preset_editor_advanced__text-6             | AdvancedStepCard       | rule:text/body                     | "Étape 1"                    |
| iconbutton-5  | IconButton | ghost     | preset_editor_advanced__iconbutton-5       | AdvancedStepCard       | rule:button/dragHandle             | ReorderableDragStartListener  |
| text-7/text-8 | Text       | —         | preset_editor_advanced__text-7             | StepModeToggle         | rule:text/toggle                   | TIME (active) / REPS (muted) |
| iconbutton-6  | IconButton | secondary | preset_editor_advanced__iconbutton-6       | StepValueControl       | rule:button/secondary              | −                             |
| text-9        | Text       | —         | preset_editor_advanced__text-9             | StepValueControl       | rule:text/value/custom             | "00 : 05" (22px)             |
| iconbutton-7  | IconButton | secondary | preset_editor_advanced__iconbutton-7       | StepValueControl       | rule:button/secondary              | +                             |
| button-2      | Button     | ghost     | preset_editor_advanced__button-2           | StepActionBar          | rule:button/ghost/leadingIcon      | COLOR                         |
| iconbutton-8  | IconButton | ghost     | preset_editor_advanced__iconbutton-8       | StepActionBar          | rule:button/ghost                  | Dupliquer                     |
| iconbutton-9  | IconButton | ghost     | preset_editor_advanced__iconbutton-9       | StepActionBar          | rule:button/ghost                  | Supprimer                     |
| iconbutton-19 | IconButton | ghost     | preset_editor_advanced__iconbutton-19      | AddStepButton          | rule:button/ghost/circle           | + ajouter étape               |
| text-16       | Text       | —         | preset_editor_advanced__text-16            | AddStepButton          | rule:text/label                    | Sous-total "00:35"           |
| iconbutton-40 | IconButton | ghost     | preset_editor_advanced__iconbutton-40      | AddGroupButton         | rule:button/ghost/circle           | + ajouter groupe              |
| text-31       | Text       | —         | preset_editor_advanced__text-31            | AddGroupButton         | rule:text/label                    | "TOTAL 03:35"                |
| card-7        | Card       | —         | preset_editor_advanced__card-7             | FinishCard             | rule:card/finish                   | —                             |
| text-32       | Text       | —         | preset_editor_advanced__text-32            | FinishCard             | rule:text/titleLarge               | "FINISH"                     |
| button-6      | Button     | ghost     | preset_editor_advanced__button-6           | FinishCard             | rule:button/ghost/leadingIcon      | COLOR                         |
| text-33       | Text       | —         | preset_editor_advanced__text-33            | FinishCard             | rule:text/label                    | "ALARM"                      |
| icon-4        | Icon       | —         | preset_editor_advanced__icon-4             | FinishCard             | rule:icon/decorative               | notifications_active          |
| text-34       | Text       | —         | preset_editor_advanced__text-34            | FinishCard             | rule:text/label                    | "BEEP X3"                    |

**Excluded from build:**
| compId        | buildStrategy                            | reason                              |
|---------------|------------------------------------------|-------------------------------------|
| container-0   | rule:system/exclude                      | Status bar                          |
| iconbutton-2  | rule:user/excludeFromBuild               | more_vert — excluded per user       |
| iconbutton-10 | rule:user/excludeFromBuild               | settings — excluded per user        |
| iconbutton-18 | rule:user/excludeFromBuild               | settings — excluded per user        |
| iconbutton-20 | rule:user/excludeFromBuild               | more_vert — excluded per user       |
| iconbutton-24 | rule:user/excludeFromBuild               | more_vert — excluded per user       |
| iconbutton-32 | rule:user/excludeFromBuild               | settings — excluded per user        |
| iconbutton-38 | rule:user/excludeFromBuild               | settings — excluded per user        |
| icon-3        | rule:user/excludeFromBuild               | trending_down — feature deferred    |

---

# 5. Layout Composition (design.json is authoritative)

## 5.1 Hierarchy

```
- root: Scaffold (backgroundColor: advancedBg #000000)
  - appBar: PresetEditorHeader (existing, reused)
  - body: Column
    - Expanded: SingleChildScrollView
      - Column
        - PresetNameInput (existing, reused — adapt styling for dark theme)
        - if viewMode == advanced:
          - AdvancedParamsPanel
            - for each group in groups:
              - AdvancedGroupCard
                - GroupHeader (RÉPÉTITIONS label + ± buttons)
                - ReorderableListView
                  - for each step in group.steps:
                    - AdvancedStepCard
                      - StepHeader (name + drag handle)
                      - StepModeToggle (TIME / REPS)
                      - StepValueControl (± value, depends on mode)
                      - if mode == REPS: StepValueControl (± duration, secondary)
                      - StepActionBar (COLOR, duplicate, delete)
                - AddStepButton (+ subtotal)
            - AddGroupButton (+ TOTAL)
            - FinishCard
    - PresetTotalDisplay (existing, adapt for advanced total calc)
```

## 5.2 Constraints & Placement

| container          | child (widgetName)      | flex | alignment (placement) | widthMode | spacing | scrollable |
|--------------------|-------------------------|------|-----------------------|-----------|---------|------------|
| root.body          | Expanded (scroll)       | 1    | stretch               | fill      | 0       | true       |
| root.body          | PresetTotalDisplay      | —    | stretch               | fill      | 0       | false      |
| AdvancedGroupCard  | GroupHeader             | —    | stretch               | fill      | 8       | false      |
| AdvancedGroupCard  | RepsControl             | —    | center                | hug       | 8       | false      |
| AdvancedGroupCard  | ReorderableListView     | —    | stretch               | fill      | 8       | false      |
| AdvancedGroupCard  | AddStepButton           | —    | center                | fill      | 8       | false      |
| AdvancedStepCard   | StepHeader              | —    | stretch               | fill      | 8       | false      |
| AdvancedStepCard   | StepModeToggle          | —    | start                 | hug       | 8       | false      |
| AdvancedStepCard   | StepValueControl        | —    | center                | fill      | 8       | false      |
| AdvancedStepCard   | StepActionBar           | —    | stretch               | fill      | 8       | false      |

---

# 6. Interaction Wiring (from spec)

| compId        | actionName                    | stateImpact                          | navigation | a11y (ariaLabel)               | notes |
|---------------|-------------------------------|--------------------------------------|-----------|--------------------------------|-------|
| iconbutton-0  | close                         | —                                    | Pop       | Fermer                         | —     |
| button-0      | switchToSimple                | viewMode→simple                      | —         | Mode simple                    | —     |
| button-1      | switchToAdvanced              | viewMode→advanced                    | —         | Mode avancé                    | —     |
| iconbutton-1  | save                          | presets list updated                 | Pop       | Enregistrer                    | —     |
| iconbutton-3  | decrementGroupReps(groupIdx)  | group.repeatCount−1                  | —         | Diminuer répétitions           | —     |
| iconbutton-4  | incrementGroupReps(groupIdx)  | group.repeatCount+1                  | —         | Augmenter répétitions          | —     |
| iconbutton-5  | beginReorder(stepIdx)         | drag state                           | —         | Réorganiser étape              | drag  |
| text-7/text-8 | toggleStepMode(g,s)           | step.mode=TIME↔REPS                  | —         | —                              | tap   |
| iconbutton-6  | decrementStepValue(g,s)       | step.value−1                         | —         | Diminuer temps/reps étape      | —     |
| iconbutton-7  | incrementStepValue(g,s)       | step.value+1                         | —         | Augmenter temps/reps étape     | —     |
| button-2      | openColorPicker(g,s)          | step.color                           | Dialog    | Choisir couleur étape          | —     |
| iconbutton-8  | duplicateStep(g,s)            | steps list (insert after)            | —         | Dupliquer étape                | —     |
| iconbutton-9  | deleteStep(g,s)               | steps list (remove)                  | —         | Supprimer étape                | —     |
| iconbutton-19 | addStep(groupIdx)             | steps list (append)                  | —         | Ajouter étape au groupe        | —     |
| iconbutton-40 | addGroup()                    | groups list (append)                 | —         | Ajouter un nouveau groupe      | —     |
| button-6      | openFinishColorPicker()       | finishColor                          | Dialog    | Choisir couleur finish         | —     |

---

# 7. State Model & Actions (from spec §6)

## 7.1 Fields

| key              | type                  | default            | persistence | notes                                    |
|------------------|-----------------------|--------------------|-------------|------------------------------------------|
| name             | String                | ""                 | oui         | Existing field                           |
| viewMode         | ViewMode              | simple             | non         | Existing field                           |
| editMode         | bool                  | false              | non         | Existing field                           |
| presetId         | String?               | null               | non         | Existing field                           |
| groups           | List\<WorkoutGroup\>  | [defaultGroup]     | oui         | **NEW** — ADVANCED mode groups           |
| finishColor      | Color                 | #CDDC39            | oui         | **NEW** — FINISH card color              |
| finishAlarmBeeps | int                   | 3                  | oui         | **NEW** — Beep count at finish           |
| prepareSeconds   | int                   | 5                  | oui         | Existing (SIMPLE mode only)              |
| repetitions      | int                   | 10                 | oui         | Existing (SIMPLE mode only)              |
| workSeconds      | int                   | 40                 | oui         | Existing (SIMPLE mode only)              |
| restSeconds      | int                   | 20                 | oui         | Existing (SIMPLE mode only)              |
| cooldownSeconds  | int                   | 30                 | oui         | Existing (SIMPLE mode only)              |

## 7.2 Actions

| name                    | input                          | output | errors       | description                                   |
|-------------------------|--------------------------------|--------|--------------|-----------------------------------------------|
| switchToSimple          | —                              | —      | —            | Existing                                      |
| switchToAdvanced        | —                              | —      | —            | Existing                                      |
| onNameChange            | String                         | —      | —            | Existing                                      |
| addGroup                | —                              | —      | —            | **NEW** Append default group                  |
| removeGroup             | int groupIdx                   | —      | min 1 group  | **NEW** Remove group at index                 |
| incrementGroupReps      | int groupIdx                   | —      | max 999      | **NEW** group.repeatCount + 1                 |
| decrementGroupReps      | int groupIdx                   | —      | min 1        | **NEW** group.repeatCount − 1                 |
| addStep                 | int groupIdx                   | —      | —            | **NEW** Append default step to group          |
| removeStep              | int groupIdx, int stepIdx      | —      | —            | **NEW** Remove step from group                |
| duplicateStep           | int groupIdx, int stepIdx      | —      | —            | **NEW** Copy step after original              |
| reorderStep             | int groupIdx, int old, int new | —      | —            | **NEW** Move step within group                |
| toggleStepMode          | int groupIdx, int stepIdx      | —      | —            | **NEW** Toggle time ↔ reps                    |
| incrementStepValue      | int groupIdx, int stepIdx      | —      | max bound    | **NEW** +1 on active value                    |
| decrementStepValue      | int groupIdx, int stepIdx      | —      | min bound    | **NEW** −1 on active value                    |
| incrementStepDuration   | int groupIdx, int stepIdx      | —      | max 3599     | **NEW** +1 on duration (REPS mode)            |
| decrementStepDuration   | int groupIdx, int stepIdx      | —      | min 0        | **NEW** −1 on duration (REPS mode)            |
| setStepColor            | int g, int s, Color            | —      | —            | **NEW** Set step color                        |
| setFinishColor          | Color                          | —      | —            | **NEW** Set finish color                      |
| save                    | —                              | bool   | nom vide     | **EXTEND** Save for both SIMPLE and ADVANCED  |
| close                   | —                              | —      | —            | Existing                                      |

---

# 8. Accessibility Plan

| order | compId        | role      | ariaLabel                      | focusable | shortcut | notes |
|------:|---------------|-----------|--------------------------------|-----------|----------|-------|
| 1     | iconbutton-0  | button    | Fermer                         | true      | —        | —     |
| 2     | button-0      | button    | Mode simple                    | true      | —        | —     |
| 3     | button-1      | button    | Mode avancé                    | true      | —        | —     |
| 4     | iconbutton-1  | button    | Enregistrer                    | true      | —        | —     |
| 5     | iconbutton-3  | button    | Diminuer répétitions           | true      | —        | per group |
| 6     | iconbutton-4  | button    | Augmenter répétitions          | true      | —        | per group |
| 7     | iconbutton-5  | button    | Réorganiser étape              | true      | —        | drag  |
| 8     | iconbutton-6  | button    | Diminuer temps/reps étape      | true      | —        | per step |
| 9     | iconbutton-7  | button    | Augmenter temps/reps étape     | true      | —        | per step |
| 10    | button-2      | button    | Choisir couleur étape          | true      | —        | per step |
| 11    | iconbutton-8  | button    | Dupliquer étape                | true      | —        | per step |
| 12    | iconbutton-9  | button    | Supprimer étape                | true      | —        | per step |
| 13    | iconbutton-19 | button    | Ajouter étape au groupe        | true      | —        | per group |
| 14    | iconbutton-40 | button    | Ajouter un nouveau groupe      | true      | —        | —     |
| 15    | button-6      | button    | Choisir couleur finish         | true      | —        | —     |

---

# 9. Testing Plan (traceability to spec §10)

| testId | preconditions                    | steps (concise)                      | oracle (expected)                                      | finder strategy    |
|--------|----------------------------------|--------------------------------------|--------------------------------------------------------|--------------------|
| T1     | ADVANCED, 1 group, 0 steps      | Tap add step (+)                     | 1 step card appears                                    | find.byType        |
| T2     | Step in TIME mode                | Tap REPS label                       | Mode switches, bold on REPS, muted on TIME             | find.text + style  |
| T3     | Step TIME, 00:05                 | Tap + button                         | Displays 00:06                                         | find.text          |
| T4     | Group reps = 1                   | Tap + reps                           | Reps = 2                                               | find.text          |
| T5     | Name + groups valid              | Tap save                             | Navigator.pop called                                   | mock verify        |
| T6     | Name empty                       | Tap save                             | SnackBar error                                         | find.byType        |
| T7     | 2 groups, 2 steps each           | —                                    | Total = correct sum                                    | unit test          |
| T8     | 2 steps                          | Tap duplicate step 1                 | 3 steps, copy at index 1                               | find.byType count  |
| T9     | 2 steps                          | Tap delete step 1                    | 1 step remaining                                       | find.byType count  |
| T10    | FINISH card visible              | Tap COLOR button                     | Color picker dialog opens                              | find.byType        |

---

# 10. Test Generation Plan

## 10.1 State Tests (`test/state/preset_editor_state_test.dart` — EXTEND)

| Component          | Method                  | Test Case                                | Priority | Coverage Type |
|--------------------|-------------------------|------------------------------------------|----------|---------------|
| PresetEditorState  | addGroup                | Adds group to list                       | CRITICAL | Unit          |
| PresetEditorState  | removeGroup             | Removes group, enforces min 1            | CRITICAL | Unit+Boundary |
| PresetEditorState  | incrementGroupReps      | Increments, enforces max 999             | HIGH     | Unit+Boundary |
| PresetEditorState  | decrementGroupReps      | Decrements, enforces min 1              | HIGH     | Unit+Boundary |
| PresetEditorState  | addStep                 | Adds step to specific group              | CRITICAL | Unit          |
| PresetEditorState  | removeStep              | Removes step from group                  | CRITICAL | Unit          |
| PresetEditorState  | duplicateStep           | Duplicates step after original           | HIGH     | Unit          |
| PresetEditorState  | reorderStep             | Reorders step within group               | HIGH     | Unit          |
| PresetEditorState  | toggleStepMode          | Toggles TIME ↔ REPS                     | CRITICAL | Unit          |
| PresetEditorState  | incrementStepValue      | +1 on active value (time or reps)        | HIGH     | Unit+Boundary |
| PresetEditorState  | decrementStepValue      | −1 on active value                       | HIGH     | Unit+Boundary |
| PresetEditorState  | incrementStepDuration   | +1 on duration (REPS mode)               | HIGH     | Unit+Boundary |
| PresetEditorState  | decrementStepDuration   | −1 on duration (REPS mode)               | HIGH     | Unit+Boundary |
| PresetEditorState  | setStepColor            | Updates step color                       | HIGH     | Unit          |
| PresetEditorState  | setFinishColor          | Updates finish color                     | HIGH     | Unit          |
| PresetEditorState  | save (advanced)         | Saves advanced preset with groups/steps  | CRITICAL | Unit          |
| PresetEditorState  | formattedTotal (adv)    | Correct total for advanced groups        | CRITICAL | Unit          |

**Coverage Target:** 100% lines, 100% branches

## 10.2 Domain Tests

| Component                  | Test File                                              | Test Cases                             | Coverage |
|----------------------------|--------------------------------------------------------|----------------------------------------|----------|
| StepMode enum              | test/domain/step_mode_test.dart                        | Enum values, toggle                    | 100%     |
| AdvancedPresetCalculator   | test/domain/advanced_preset_calculator_test.dart        | Total calc, group subtotal, edge cases | 100%     |

## 10.3 Model Tests

| Component      | Test File                              | Test Cases                                        | Coverage |
|----------------|----------------------------------------|---------------------------------------------------|----------|
| WorkoutGroup   | test/models/workout_group_test.dart    | Create, copyWith, fromJson, toJson, ==, hashCode  | 100%     |
| AdvancedStep   | test/models/advanced_step_test.dart    | Create, copyWith, fromJson, toJson, ==, hashCode  | 100%     |

## 10.4 Widget Tests

| Widget                | Component Key                           | Test Case                                   | Expected Behavior                   |
|-----------------------|-----------------------------------------|---------------------------------------------|-------------------------------------|
| AdvancedGroupCard     | preset_editor_advanced__card-0          | Renders group header + reps ±               | Label, value, buttons visible       |
| AdvancedStepCard      | preset_editor_advanced__card-1          | Renders step in TIME mode                   | Name, time, controls visible        |
| AdvancedStepCard      | preset_editor_advanced__card-2          | Renders step in REPS mode                   | Name, reps x, duration visible      |
| StepModeToggle        | preset_editor_advanced__text-7          | Tap switches mode                           | Bold/muted toggle                   |
| StepValueControl      | preset_editor_advanced__iconbutton-6    | Tap ± changes value                         | Value updates                       |
| StepActionBar         | preset_editor_advanced__button-2        | Tap COLOR opens picker                      | Dialog shown                        |
| StepActionBar         | preset_editor_advanced__iconbutton-8    | Tap duplicate triggers callback             | Callback called                     |
| StepActionBar         | preset_editor_advanced__iconbutton-9    | Tap delete triggers callback                | Callback called                     |
| AddStepButton         | preset_editor_advanced__iconbutton-19   | Tap triggers addStep                        | Callback called                     |
| AddGroupButton        | preset_editor_advanced__iconbutton-40   | Tap triggers addGroup                       | Callback called                     |
| FinishCard            | preset_editor_advanced__card-7          | Renders FINISH title + COLOR + ALARM        | All elements visible                |
| AdvancedParamsPanel   | —                                       | Full integration with groups/steps          | Correct layout, interactions work   |

**Coverage Target:** ≥70% for screen-specific widgets

## 10.5 Accessibility Tests

| Widget              | Component Key                           | Semantic Label                 | Role   | State   |
|---------------------|-----------------------------------------|--------------------------------|--------|---------|
| AdvancedGroupCard   | preset_editor_advanced__iconbutton-3    | Diminuer répétitions           | button | enabled |
| AdvancedGroupCard   | preset_editor_advanced__iconbutton-4    | Augmenter répétitions          | button | enabled |
| AdvancedStepCard    | preset_editor_advanced__iconbutton-5    | Réorganiser étape              | button | enabled |
| AdvancedStepCard    | preset_editor_advanced__iconbutton-6    | Diminuer temps étape           | button | enabled |
| StepActionBar       | preset_editor_advanced__button-2        | Choisir couleur étape          | button | enabled |
| StepActionBar       | preset_editor_advanced__iconbutton-8    | Dupliquer étape                | button | enabled |
| StepActionBar       | preset_editor_advanced__iconbutton-9    | Supprimer étape                | button | enabled |
| AddStepButton       | preset_editor_advanced__iconbutton-19   | Ajouter étape au groupe        | button | enabled |
| AddGroupButton      | preset_editor_advanced__iconbutton-40   | Ajouter un nouveau groupe      | button | enabled |
| FinishCard          | preset_editor_advanced__button-6        | Choisir couleur finish         | button | enabled |

---

## 2.6 Translations Plan

### ARB Files to Update

| File              | Locale | Purpose                     |
|-------------------|--------|-----------------------------|
| lib/l10n/app_en.arb | en  | English translations (extend) |
| lib/l10n/app_fr.arb | fr  | French translations (extend)  |

### Text Extraction from Design

| Component  | Text Content       | ARB Key                        | Description                                |
|------------|--------------------|---------------------------------|--------------------------------------------|
| text-4     | RÉPÉTITIONS        | advancedRepsLabel               | Group repetitions header label             |
| text-7     | TIME               | advancedTimeLabel               | Step mode: time                            |
| text-8     | REPS               | advancedStepRepsLabel           | Step mode: reps                            |
| button-2   | COLOR              | advancedColorLabel              | Color picker button text                   |
| text-32    | FINISH             | advancedFinishLabel             | Finish section title                       |
| text-33    | ALARM              | advancedAlarmLabel              | Alarm label                                |
| text-34    | BEEP X3            | advancedAlarmBeepsFormat        | Alarm beeps display (parameterized)        |
| text-31    | TOTAL 03:35        | advancedTotalFormat             | Total display (parameterized)              |
| text-2     | Nom prédéfini      | presetNamePlaceholder           | Existing key                               |
| —          | Étape {n}          | advancedStepDefaultName         | Default step name (parameterized)          |
| —          | Ajouter une étape  | advancedAddStepLabel            | Add step a11y label                        |
| —          | Ajouter un groupe  | advancedAddGroupLabel           | Add group a11y label                       |
| —          | Dupliquer          | advancedDuplicateLabel          | Duplicate a11y label                       |
| —          | Supprimer          | advancedDeleteLabel             | Delete a11y label                          |
| —          | Réorganiser        | advancedReorderLabel            | Reorder a11y label                         |
| —          | Diminuer           | advancedDecreaseLabel           | Decrease a11y label                        |
| —          | Augmenter          | advancedIncreaseLabel           | Increase a11y label                        |
| —          | Choisir couleur    | advancedChooseColorLabel        | Choose color a11y label                    |

### i18n Configuration
- File: `lib/l10n/l10n.yaml` (existing)
- Template: `app_en.arb` (extend)
- Output: `app_localizations.dart` (regenerate)

### main.dart Setup
- No changes needed (localization already configured)

---

## 10.6 Components excluded from tests

| Component    | Reason                                          |
|--------------|-------------------------------------------------|
| container-0  | System status bar, not part of app              |
| iconbutton-2 | more_vert — excluded from build per user        |
| iconbutton-10| settings — excluded from build per user         |
| iconbutton-18| settings — excluded from build per user         |
| iconbutton-20| more_vert — excluded from build per user        |
| iconbutton-24| more_vert — excluded from build per user        |
| iconbutton-32| settings — excluded from build per user         |
| iconbutton-38| settings — excluded from build per user         |
| icon-3       | trending_down — feature deferred                |

---

# 11. Risks / Unknowns (from spec §11.3)

| # | risk                                                        | severity | mitigation                                           |
|---|-------------------------------------------------------------|----------|------------------------------------------------------|
| 1 | Color picker: no existing widget, need external package     | Medium   | Use flutter_colorpicker or simple predefined palette |
| 2 | Preset model evolution: need backward-compatible JSON schema| High     | Add `groups` field alongside existing flat fields     |
| 3 | ReorderableListView performance with many steps             | Low      | Limit to ~50 steps, use itemExtent                   |
| 4 | Text contrast on arbitrary step colors                      | Medium   | Use computeLuminance() for auto black/white text     |
| 5 | confidenceGlobal 0.74 — design colors may need adjustment  | Low      | Colors user-adjustable via color picker               |

---

# 12. Check Gates
- [x] Analyzer/lint pass
- [x] Unique keys check
- [x] Controlled vocabulary validation
- [x] A11y labels presence
- [x] Routes exist and compile
- [x] Token usage present in theme
- [ ] Test coverage thresholds (State/Model: 100%, Overall: ≥80%)

---

# 13. Checklist (subset of PR_CHECKLIST)
- [x] Keys assigned on interactive widgets
- [x] Texts verbatim + transform
- [x] Variants/placement/widthMode valid
- [x] Actions wired to state methods
- [ ] Golden-ready (stable layout, no randoms)
- [x] Test generation plan complete (all State methods, interactive components listed)
