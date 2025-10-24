---
# Deterministic Build Plan — PresetEditor

# YAML front matter for machine-readability
screenName: PresetEditor
screenId: preset_editor
designSnapshotRef: e1cb6394-36df-45ff-8766-c9d4db68dd37.png
planVersion: 2
generatedAt: 2025-10-23T00:00:00Z
generator: spec2plan
language: fr
inputsHash: a2f8e3d7c1b4a9e6f2d3c8b1a4e7f9d2c5b8a3e6f1d4c7b0a9e2f5d8c1b4a7e0
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
| field            | value |
|------------------|-------|
| screenId         | preset_editor |
| designSnapshotRef| e1cb6394-36df-45ff-8766-c9d4db68dd37.png |
| inputsHash       | a2f8e3d7c1b4a9e6f2d3c8b1a4e7f9d2c5b8a3e6f1d4c7b0a9e2f5d8c1b4a7e0 |

---

# 2. Files to Generate
## 2.1 Widgets
| widgetName           | filePath                         | purpose (fr court)          | components (compIds) | notes |
|----------------------|----------------------------------|-----------------------------|----------------------|-------|
| PresetEditorScreen | lib/screens/preset_editor_screen.dart | Écran édition préréglage | Tous composants | StatefulWidget principal |
| PresetEditorHeader | lib/widgets/preset_editor/preset_editor_header.dart | Barre outils et navigation | container-1, iconbutton-2, button-3, button-4, iconbutton-5 | Header avec modes SIMPLE/ADVANCED |
| PresetNameInput | lib/widgets/preset_editor/preset_name_input.dart | Champ saisie nom | input-6 | TextField pour nom préréglage |
| PresetParamsPanel | lib/widgets/preset_editor/preset_params_panel.dart | Panneau paramètres (mode SIMPLE) | container-7, text-8 à text-27 | Configuration paramètres |
| PresetTotalDisplay | lib/widgets/preset_editor/preset_total_display.dart | Affichage temps total | text-28 | Calcul et affichage TOTAL |

## 2.2 State
| filePath                         | pattern            | exposes (fields/actions)            | persistence | notes |
|----------------------------------|--------------------|-------------------------------------|-------------|-------|
| lib/state/preset_editor_state.dart | ChangeNotifier | name,prepareSeconds,repetitions,workSeconds,restSeconds,cooldownSeconds,viewMode,editMode,presetId;incrementPrepare,decrementPrepare,incrementReps,decrementReps,incrementWork,decrementWork,incrementRest,decrementRest,incrementCooldown,decrementCooldown,onNameChange,switchToSimple,switchToAdvanced,save,close,calculateTotal | via sauvegarde | State PresetEditor |

## 2.3 Routes
| routeName      | filePath                       | params       | created/uses | notes |
|----------------|--------------------------------|--------------|-------------|-------|
| /preset_editor | lib/routes/app_routes.dart     | mode,preset?,workSeconds?,restSeconds?,reps? | created | Nouvelle route |
| /home          | lib/routes/app_routes.dart     | —            | uses | Destination retour |

## 2.4 Themes/Tokens
| tokenType | name       | required | notes |
|----------|------------|----------|-------|
| color    | primary        | yes      | Couleur principale #000000 |
| color    | onPrimary      | yes      | Texte sur primary #FFFFFF |
| color    | background     | yes      | Fond écran #F5F5F5 |
| color    | surface        | yes      | Fond surface #FFFFFF |
| color    | textPrimary    | yes      | Texte principal #000000 |
| color    | textSecondary  | yes      | Texte secondaire #666666 |
| color    | divider        | yes      | Séparateurs #CCCCCC |
| color    | accent         | yes      | Accent #3F51B5 |
| color    | border         | yes      | Bordures #999999 |
| color    | headerBackground | yes    | Fond header #607D8B |
| typo     | label          | yes      | Labels contrôles (14px medium) |
| typo     | body           | yes      | Texte corps (16px regular) |
| typo     | value          | yes      | Valeurs numériques (28px bold) |

## 2.5 Tests (to be generated in steps 05/06)

### Widget Tests - 1:1 with § 2.1
| widgetName           | testFilePath                                | covers (components from that widget) |
|----------------------|---------------------------------------------|--------------------------------------|
| PresetEditorScreen | test/screens/preset_editor_screen_test.dart | Tous composants (intégration) |
| PresetEditorHeader | test/widgets/preset_editor/preset_editor_header_test.dart | iconbutton-2, button-3, button-4, iconbutton-5 |
| PresetNameInput | test/widgets/preset_editor/preset_name_input_test.dart | input-6 |
| PresetParamsPanel | test/widgets/preset_editor/preset_params_panel_test.dart | container-7, tous les contrôles ValueControl |
| PresetTotalDisplay | test/widgets/preset_editor/preset_total_display_test.dart | text-28 |

**Rule:** count(rows above) == count(rows in § 2.1 Widgets) ✓ (5 = 5)

### Shared Test Helpers
| filePath                          | purpose                    |
|-----------------------------------|----------------------------|
| test/helpers/widget_test_helpers.dart | Common setup, mock state, pump utilities (réutilisé de Home) |

---

# 3. Existing components to reuse
| componentName        | filePath                         | purpose of reuse (fr court) | components (compIds) | notes |
|----------------------|----------------------------------|-----------------------------|----------------------|-------|
| ValueControl | lib/widgets/value_control.dart | Contrôle +/− avec valeur centrale | iconbutton-9,text-10,iconbutton-11 (et 4 autres instances) | Pattern réutilisé 5x (préparer, reps, travail, repos, refroidir) |

---

# 4. Widget Breakdown (from design.json + UI Mapping Guide)
| compId | type   | variant | key                       | widgetName | filePath                        | buildStrategy (mapping rule id) | notes |
|--------|--------|---------|---------------------------|------------|----------------------------------|---------------------------------|-------|
| container-1 | Container | — | preset_editor__container-1 | PresetEditorHeader | lib/widgets/preset_editor/preset_editor_header.dart | rule:group/alignment | Header container |
| iconbutton-2 | IconButton | ghost | preset_editor__iconbutton-2 | PresetEditorHeader | lib/widgets/preset_editor/preset_editor_header.dart | rule:iconButton/shaped, rule:button/ghost | Bouton fermer |
| button-3 | Button | primary | preset_editor__button-3 | PresetEditorHeader | lib/widgets/preset_editor/preset_editor_header.dart | rule:button/primary | Mode SIMPLE |
| button-4 | Button | ghost | preset_editor__button-4 | PresetEditorHeader | lib/widgets/preset_editor/preset_editor_header.dart | rule:button/ghost | Mode ADVANCED |
| iconbutton-5 | IconButton | ghost | preset_editor__iconbutton-5 | PresetEditorHeader | lib/widgets/preset_editor/preset_editor_header.dart | rule:iconButton/shaped, rule:button/ghost | Bouton sauvegarder |
| input-6 | Input | — | preset_editor__input-6 | PresetNameInput | lib/widgets/preset_editor/preset_name_input.dart | rule:input/textField | Champ nom |
| container-7 | Container | — | preset_editor__container-7 | PresetParamsPanel | lib/widgets/preset_editor/preset_params_panel.dart | rule:group/alignment | Container paramètres |
| text-8 | Text | — | preset_editor__text-8 | PresetParamsPanel (ValueControl) | lib/widgets/preset_editor/preset_params_panel.dart | rule:text/transform | Label PRÉPARER |
| iconbutton-9 | IconButton | ghost | preset_editor__iconbutton-9 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton - préparer |
| text-10 | Text | — | preset_editor__text-10 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Valeur préparer |
| iconbutton-11 | IconButton | ghost | preset_editor__iconbutton-11 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton + préparer |
| text-12 | Text | — | preset_editor__text-12 | PresetParamsPanel (ValueControl) | lib/widgets/preset_editor/preset_params_panel.dart | rule:text/transform | Label RÉPÉTITIONS |
| iconbutton-13 | IconButton | ghost | preset_editor__iconbutton-13 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton - reps |
| text-14 | Text | — | preset_editor__text-14 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Valeur reps |
| iconbutton-15 | IconButton | ghost | preset_editor__iconbutton-15 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton + reps |
| text-16 | Text | — | preset_editor__text-16 | PresetParamsPanel (ValueControl) | lib/widgets/preset_editor/preset_params_panel.dart | rule:text/transform | Label TRAVAIL |
| iconbutton-17 | IconButton | ghost | preset_editor__iconbutton-17 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton - travail |
| text-18 | Text | — | preset_editor__text-18 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Valeur travail |
| iconbutton-19 | IconButton | ghost | preset_editor__iconbutton-19 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton + travail |
| text-20 | Text | — | preset_editor__text-20 | PresetParamsPanel (ValueControl) | lib/widgets/preset_editor/preset_params_panel.dart | rule:text/transform | Label REPOS |
| iconbutton-21 | IconButton | ghost | preset_editor__iconbutton-21 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton - repos |
| text-22 | Text | — | preset_editor__text-22 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Valeur repos |
| iconbutton-23 | IconButton | ghost | preset_editor__iconbutton-23 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton + repos |
| text-24 | Text | — | preset_editor__text-24 | PresetParamsPanel (ValueControl) | lib/widgets/preset_editor/preset_params_panel.dart | rule:text/transform | Label REFROIDIR |
| iconbutton-25 | IconButton | ghost | preset_editor__iconbutton-25 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton - refroidir |
| text-26 | Text | — | preset_editor__text-26 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Valeur refroidir |
| iconbutton-27 | IconButton | ghost | preset_editor__iconbutton-27 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton + refroidir |
| text-28 | Text | — | preset_editor__text-28 | PresetTotalDisplay | lib/widgets/preset_editor/preset_total_display.dart | rule:text/transform | TOTAL calculé |

---

# 5. Layout Composition (design.json is authoritative)
## 5.1 Hierarchy
- root: Scaffold(backgroundColor: AppColors.background)
  - appBar: PresetEditorHeader (custom PreferredSize)
  - body: Column (scrollable via SingleChildScrollView)
    - SizedBox(height: 20) — spacing
    - PresetNameInput
    - SizedBox(height: 30) — spacing
    - PresetParamsPanel (visible si viewMode == simple)
      - 5× ValueControl instances (préparer, reps, travail, repos, refroidir)
    - Container (visible si viewMode == advanced) — placeholder vide
    - Spacer()
    - PresetTotalDisplay
    - SizedBox(height: 20) — spacing

## 5.2 Constraints & Placement
| container | child (widgetName) | flex | alignment (placement) | widthMode | spacing | scrollable |
|----------|---------------------|------|------------------------|-----------|---------|------------|
| Scaffold.appBar | PresetEditorHeader | — | stretch | fill | — | false |
| body Column | PresetNameInput | — | center | hug | 30 | false |
| body Column | PresetParamsPanel | — | center | hug | 0 | false |
| body Column | PresetTotalDisplay | — | end | hug | 20 | false |
| PresetParamsPanel | ValueControl (×5) | — | center | hug | 16 | false |

---

# 6. Interaction Wiring (from spec)
| compId | actionName   | stateImpact          | navigation | a11y (ariaLabel) | notes |
|--------|--------------|----------------------|-----------|------------------|-------|
| iconbutton-2 | close | — | Home | Fermer | Retour Home sans sauvegarder |
| button-3 | switchToSimple | viewMode | — | Mode simple | Bascule vue SIMPLE |
| button-4 | switchToAdvanced | viewMode | — | Mode avancé | Bascule vue ADVANCED |
| iconbutton-5 | save | preset | Home | Enregistrer | Sauvegarde et retour Home |
| input-6 | onNameChange | name | — | Nom prédéfini | Saisie nom préréglage |
| iconbutton-9 | decrementPrepare | prepareSeconds | — | Diminuer préparer | Décrémente prepareSeconds (min 0) |
| iconbutton-11 | incrementPrepare | prepareSeconds | — | Augmenter préparer | Incrémente prepareSeconds |
| iconbutton-13 | decrementReps | repetitions | — | Diminuer répétitions | Décrémente repetitions (min 1) |
| iconbutton-15 | incrementReps | repetitions | — | Augmenter répétitions | Incrémente repetitions |
| iconbutton-17 | decrementWork | workSeconds | — | Diminuer travail | Décrémente workSeconds (min 0) |
| iconbutton-19 | incrementWork | workSeconds | — | Augmenter travail | Incrémente workSeconds |
| iconbutton-21 | decrementRest | restSeconds | — | Diminuer repos | Décrémente restSeconds (min 0) |
| iconbutton-23 | incrementRest | restSeconds | — | Augmenter repos | Incrémente restSeconds |
| iconbutton-25 | decrementCooldown | cooldownSeconds | — | Diminuer refroidir | Décrémente cooldownSeconds (min 0) |
| iconbutton-27 | incrementCooldown | cooldownSeconds | — | Augmenter refroidir | Incrémente cooldownSeconds |

---

# 7. State Model & Actions (from spec §6)
## 7.1 Fields
| key          | type | default | persistence | notes |
|--------------|------|---------|-------------|-------|
| name | String | "" | via sauvegarde | Nom du préréglage |
| prepareSeconds | int | 5 | via sauvegarde | Temps de préparation (mode création) |
| repetitions | int | 10 | via sauvegarde | Nombre de répétitions (mode création) |
| workSeconds | int | 40 | via sauvegarde | Temps de travail (mode création) |
| restSeconds | int | 20 | via sauvegarde | Temps de repos (mode création) |
| cooldownSeconds | int | 30 | via sauvegarde | Temps de refroidissement (mode création) |
| viewMode | String | "simple" | non | simple|advanced |
| editMode | bool | false | non | false = création, true = modification |
| presetId | String? | null | non | ID du préréglage en cours d'édition |

## 7.2 Actions
| name        | input | output | errors | description |
|-------------|-------|--------|--------|-------------|
| incrementPrepare | — | — | — | Augmente prepareSeconds de 1 |
| decrementPrepare | — | — | — | Diminue prepareSeconds de 1 (min 0) |
| incrementReps | — | — | — | Augmente repetitions de 1 |
| decrementReps | — | — | — | Diminue repetitions de 1 (min 1) |
| incrementWork | — | — | — | Augmente workSeconds de 1 |
| decrementWork | — | — | — | Diminue workSeconds de 1 (min 0) |
| incrementRest | — | — | — | Augmente restSeconds de 1 |
| decrementRest | — | — | — | Diminue restSeconds de 1 (min 0) |
| incrementCooldown | — | — | — | Augmente cooldownSeconds de 1 |
| decrementCooldown | — | — | — | Diminue cooldownSeconds de 1 (min 0) |
| onNameChange | String text | — | — | Met à jour name |
| switchToSimple | — | — | — | Met viewMode à "simple" |
| switchToAdvanced | — | — | — | Met viewMode à "advanced" |
| save | — | — | nom vide | Sauvegarde le préréglage et retourne à Home |
| close | — | — | — | Ferme l'écran sans sauvegarder |
| calculateTotal | — | String | — | Calcule et formate le temps total |

---

# 8. Accessibility Plan
| order | compId | role        | ariaLabel    | focusable | shortcut | notes |
|------:|--------|-------------|--------------|-----------|----------|-------|
| 1 | iconbutton-2 | button | Fermer | true | — | — |
| 2 | button-3 | button | Mode simple | true | — | — |
| 3 | button-4 | button | Mode avancé | true | — | — |
| 4 | iconbutton-5 | button | Enregistrer | true | — | — |
| 5 | input-6 | textField | Nom prédéfini | true | — | — |
| 6 | iconbutton-9 | button | Diminuer préparer | true | — | — |
| 7 | iconbutton-11 | button | Augmenter préparer | true | — | — |
| 8 | iconbutton-13 | button | Diminuer répétitions | true | — | — |
| 9 | iconbutton-15 | button | Augmenter répétitions | true | — | — |
| 10 | iconbutton-17 | button | Diminuer travail | true | — | — |
| 11 | iconbutton-19 | button | Augmenter travail | true | — | — |
| 12 | iconbutton-21 | button | Diminuer repos | true | — | — |
| 13 | iconbutton-23 | button | Augmenter repos | true | — | — |
| 14 | iconbutton-25 | button | Diminuer refroidir | true | — | — |
| 15 | iconbutton-27 | button | Augmenter refroidir | true | — | — |

---

# 9. Testing Plan (traceability to spec §10)
| testId | preconditions | steps (concise)       | oracle (expected)                                  | finder strategy |
|--------|----------------|-----------------------|----------------------------------------------------|-----------------|
| T1 | prepareSeconds=5 | tap preset_editor__iconbutton-11 | find.byKey('preset_editor__text-10') text = "00 : 06" | find.byKey |
| T2 | prepareSeconds=0 | tap preset_editor__iconbutton-9 | find.byKey('preset_editor__text-10') text = "00 : 00", iconbutton-9 disabled | find.byKey |
| T3 | repetitions=1 | tap preset_editor__iconbutton-13 | find.byKey('preset_editor__text-14') text = "1", iconbutton-13 disabled | find.byKey |
| T4 | repetitions=10 | tap preset_editor__iconbutton-15 | find.byKey('preset_editor__text-14') text = "11" | find.byKey |
| T5 | workSeconds=40 | tap preset_editor__iconbutton-19 | find.byKey('preset_editor__text-18') text = "00 : 41" | find.byKey |
| T6 | restSeconds=20 | tap preset_editor__iconbutton-23 | find.byKey('preset_editor__text-22') text = "00 : 21" | find.byKey |
| T7 | cooldownSeconds=30 | tap preset_editor__iconbutton-27 | find.byKey('preset_editor__text-26') text = "00 : 31" | find.byKey |
| T8 | viewMode=simple | tap preset_editor__button-4 | viewMode=advanced, button-4 variant=primary | find.byKey |
| T9 | viewMode=advanced | tap preset_editor__button-3 | viewMode=simple, button-3 variant=primary | find.byKey |
| T10 | name="", all params set | tap preset_editor__iconbutton-5 | error message "Veuillez saisir un nom" | find.byKey |
| T11 | name="Test", all params set | tap preset_editor__iconbutton-5 | preset saved, navigates to Home | find.byKey + navigation |
| T12 | modifications not saved | tap preset_editor__iconbutton-2 | navigates to Home without saving | find.byKey + navigation |
| T13 | prepare=5, reps=10, work=40, rest=20, cooldown=30 | — | find.byKey('preset_editor__text-28') text = "TOTAL 11:35" | find.byKey |
| T14 | — | — | all interactive components have Semantics with label | a11y test |
| T15 | default state simple mode | — | matches golden file | golden test |

---

# 10. Test Generation Plan

## 10.1 State Tests (`test/state/preset_editor_state_test.dart`)

| Component | Method | Test Case | Priority | Coverage Type |
|-----------|--------|-----------|----------|---------------|
| PresetEditorState | incrementPrepare | increments from default (5) to 6 | CRITICAL | Unit |
| PresetEditorState | decrementPrepare | decrements from 5 to 4 | CRITICAL | Unit |
| PresetEditorState | decrementPrepare | stops at minimum (0) | CRITICAL | Boundary |
| PresetEditorState | incrementReps | increments from default (10) to 11 | CRITICAL | Unit |
| PresetEditorState | decrementReps | decrements from 10 to 9 | CRITICAL | Unit |
| PresetEditorState | decrementReps | stops at minimum (1) | CRITICAL | Boundary |
| PresetEditorState | incrementWork | increments from default (40) to 41 | CRITICAL | Unit |
| PresetEditorState | decrementWork | decrements from 40 to 39 | CRITICAL | Unit |
| PresetEditorState | decrementWork | stops at minimum (0) | CRITICAL | Boundary |
| PresetEditorState | incrementRest | increments from default (20) to 21 | CRITICAL | Unit |
| PresetEditorState | decrementRest | decrements from 20 to 19 | CRITICAL | Unit |
| PresetEditorState | decrementRest | stops at minimum (0) | CRITICAL | Boundary |
| PresetEditorState | incrementCooldown | increments from default (30) to 31 | CRITICAL | Unit |
| PresetEditorState | decrementCooldown | decrements from 30 to 29 | CRITICAL | Unit |
| PresetEditorState | decrementCooldown | stops at minimum (0) | CRITICAL | Boundary |
| PresetEditorState | onNameChange | updates name to "Test" | CRITICAL | Unit |
| PresetEditorState | switchToSimple | sets viewMode to "simple" | HIGH | Unit |
| PresetEditorState | switchToAdvanced | sets viewMode to "advanced" | HIGH | Unit |
| PresetEditorState | save | saves preset with valid name | CRITICAL | Unit |
| PresetEditorState | save | rejects empty name | CRITICAL | Unit |
| PresetEditorState | close | closes without saving | HIGH | Unit |
| PresetEditorState | calculateTotal | calculates correct total (5 + 10×(40+20) + 30 = 635s = 10:35) | CRITICAL | Unit |
| PresetEditorState | calculateTotal | formats as "TOTAL mm:ss" | CRITICAL | Unit |
| PresetEditorState | formatTime | formats 5 seconds as "00 : 05" | CRITICAL | Unit |
| PresetEditorState | formatTime | formats 89 seconds as "01 : 29" | HIGH | Unit |
| PresetEditorState | formatTime | formats 0 seconds as "00 : 00" | HIGH | Boundary |

**Coverage Target:** 100% lines, 100% branches

---

## 10.2 Widget Tests

| Widget | Component Key | Test Case | Expected Behavior |
|--------|---------------|-----------|-------------------|
| PresetEditorScreen | preset_editor__iconbutton-5 | renders SAVE button | button is visible |
| PresetEditorScreen | preset_editor__iconbutton-2 | taps CLOSE button | navigates to /home without saving |
| PresetEditorHeader | preset_editor__button-3 | renders SIMPLE button | button is visible, variant=primary |
| PresetEditorHeader | preset_editor__button-4 | renders ADVANCED button | button is visible, variant=ghost |
| PresetEditorHeader | preset_editor__button-4 | taps ADVANCED button | switchToAdvanced called, button-4 becomes primary |
| PresetEditorHeader | preset_editor__iconbutton-5 | taps SAVE button | save action called |
| PresetNameInput | preset_editor__input-6 | renders name input | input is visible |
| PresetNameInput | preset_editor__input-6 | enters text "Test" | onNameChange called with "Test" |
| PresetParamsPanel | preset_editor__text-8 | renders PRÉPARER label | "PRÉPARER" visible |
| PresetParamsPanel | preset_editor__iconbutton-9 | taps decrement prepare | decrementPrepare called, value updates |
| PresetParamsPanel | preset_editor__iconbutton-11 | taps increment prepare | incrementPrepare called, value updates |
| PresetParamsPanel | preset_editor__text-10 | displays prepare value | shows formatted time (e.g., "00 : 05") |
| PresetParamsPanel | preset_editor__iconbutton-13 | taps decrement reps | decrementReps called, value updates |
| PresetParamsPanel | preset_editor__iconbutton-15 | taps increment reps | incrementReps called, value updates |
| PresetParamsPanel | preset_editor__text-14 | displays reps value | shows current reps (e.g., "1") |
| PresetParamsPanel | preset_editor__iconbutton-17 | taps decrement work | decrementWork called, value updates |
| PresetParamsPanel | preset_editor__iconbutton-19 | taps increment work | incrementWork called, value updates |
| PresetParamsPanel | preset_editor__text-18 | displays work time | shows formatted time (e.g., "01 : 29") |
| PresetParamsPanel | preset_editor__iconbutton-21 | taps decrement rest | decrementRest called, value updates |
| PresetParamsPanel | preset_editor__iconbutton-23 | taps increment rest | incrementRest called, value updates |
| PresetParamsPanel | preset_editor__text-22 | displays rest time | shows formatted time (e.g., "00 : 30") |
| PresetParamsPanel | preset_editor__iconbutton-25 | taps decrement cooldown | decrementCooldown called, value updates |
| PresetParamsPanel | preset_editor__iconbutton-27 | taps increment cooldown | incrementCooldown called, value updates |
| PresetParamsPanel | preset_editor__text-26 | displays cooldown time | shows formatted time (e.g., "00 : 00") |
| PresetTotalDisplay | preset_editor__text-28 | displays total duration | shows "TOTAL 01:34" |
| PresetTotalDisplay | preset_editor__text-28 | updates on param change | total recalculates automatically |
| ValueControl | preset_editor__iconbutton-13 | button disabled at minimum | decrementReps button disabled when reps=1 |
| ValueControl | preset_editor__iconbutton-9 | button disabled at minimum | decrementPrepare button disabled when prepareSeconds=0 |

**Coverage Target:** ≥90% for generic widgets (ValueControl), ≥70% for screen-specific widgets

---

## 10.3 Accessibility Tests

| Widget | Component Key | Semantic Label | Role | State |
|--------|---------------|----------------|------|-------|
| PresetEditorHeader | preset_editor__iconbutton-2 | Fermer | button | enabled |
| PresetEditorHeader | preset_editor__button-3 | Mode simple | button | enabled |
| PresetEditorHeader | preset_editor__button-4 | Mode avancé | button | enabled |
| PresetEditorHeader | preset_editor__iconbutton-5 | Enregistrer | button | enabled |
| PresetNameInput | preset_editor__input-6 | Nom prédéfini | textField | enabled |
| PresetParamsPanel | preset_editor__iconbutton-9 | Diminuer préparer | button | enabled/disabled |
| PresetParamsPanel | preset_editor__iconbutton-11 | Augmenter préparer | button | enabled |
| PresetParamsPanel | preset_editor__iconbutton-13 | Diminuer répétitions | button | enabled/disabled |
| PresetParamsPanel | preset_editor__iconbutton-15 | Augmenter répétitions | button | enabled |
| PresetParamsPanel | preset_editor__iconbutton-17 | Diminuer travail | button | enabled/disabled |
| PresetParamsPanel | preset_editor__iconbutton-19 | Augmenter travail | button | enabled |
| PresetParamsPanel | preset_editor__iconbutton-21 | Diminuer repos | button | enabled/disabled |
| PresetParamsPanel | preset_editor__iconbutton-23 | Augmenter repos | button | enabled |
| PresetParamsPanel | preset_editor__iconbutton-25 | Diminuer refroidir | button | enabled/disabled |
| PresetParamsPanel | preset_editor__iconbutton-27 | Augmenter refroidir | button | enabled |

---

## 10.4 Components excluded from tests

| Component | Reason        |
|-----------|---------------|
| container-1, container-7 | Layout containers (no interaction, tested via parent widgets) |
| text-8, text-12, text-16, text-20, text-24 | Static labels (tested via ValueControl parent) |

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
| button-3 | SIMPLE | simpleModeButton | Simple mode button text |
| button-4 | ADVANCED | advancedModeButton | Advanced mode button text |
| input-6 | Nom prédéfini | presetNamePlaceholder | Preset name input placeholder |
| text-8 | PRÉPARER | prepareLabel | Prepare time label |
| text-12 | RÉPÉTITIONS | repsLabel | Repetitions label |
| text-16 | TRAVAIL | workLabel | Work time label |
| text-20 | REPOS | restLabel | Rest time label |
| text-24 | REFROIDIR | cooldownLabel | Cooldown time label |
| text-28 | TOTAL 01:34 | totalLabel | Total duration label (with placeholder) |
| iconbutton-2 | Fermer | closeButtonLabel | Close button semantic label |
| iconbutton-5 | Enregistrer | saveButtonLabel | Save button semantic label |
| iconbutton-9 | Diminuer préparer | decreasePrepareLabel | Decrease prepare button semantic label |
| iconbutton-11 | Augmenter préparer | increasePrepareLabel | Increase prepare button semantic label |
| iconbutton-13 | Diminuer répétitions | decreaseRepsLabel | Decrease reps button semantic label |
| iconbutton-15 | Augmenter répétitions | increaseRepsLabel | Increase reps button semantic label |
| iconbutton-17 | Diminuer travail | decreaseWorkLabel | Decrease work button semantic label |
| iconbutton-19 | Augmenter travail | increaseWorkLabel | Increase work button semantic label |
| iconbutton-21 | Diminuer repos | decreaseRestLabel | Decrease rest button semantic label |
| iconbutton-23 | Augmenter repos | increaseRestLabel | Increase rest button semantic label |
| iconbutton-25 | Diminuer refroidir | decreaseCooldownLabel | Decrease cooldown button semantic label |
| iconbutton-27 | Augmenter refroidir | increaseCooldownLabel | Increase cooldown button semantic label |
| — | Veuillez saisir un nom | presetNameError | Validation error for empty preset name |
| button-3 | Mode simple | simpleModeLabel | Simple mode button semantic label |
| button-4 | Mode avancé | advancedModeLabel | Advanced mode button semantic label |
| input-6 | Nom prédéfini | presetNameLabel | Preset name input semantic label |

### i18n Configuration
- File: `l10n.yaml`
- Template: `app_en.arb`
- Output directory: `lib/l10n/`
- Generated classes: `app_localizations.dart`

### main.dart Setup
- Import: `flutter_localizations`
- Delegates: `AppLocalizations.delegate`, `GlobalMaterialLocalizations.delegate`, `GlobalWidgetsLocalizations.delegate`, `GlobalCupertinoLocalizations.delegate`
- Supported locales: `[Locale('en'), Locale('fr')]`
- Locale resolution: fallback to English if unsupported locale

---

# 11. Risks / Unknowns (from spec §11.3)
- Confirmation de sortie sans sauvegarde : actuellement non implémentée (ferme immédiatement)
- Limite maximale des valeurs : pas définie dans spec, implémenté avec limites raisonnables (reps max 999, time max 3599 secondes)
- Vue ADVANCED : hors périmètre pour cette itération (placeholder vide)
- Extension du modèle Preset : nécessite ajout de prepareSeconds et cooldownSeconds (BLOCKING - doit être fait en Step 4)
- Navigation depuis Home : plusieurs points d'entrée possibles (Button-27, Button-22, PresetCard) avec paramètres différents

---

# 12. Check Gates
- Analyzer/lint pass
- Unique keys check (all interactive widgets have keys)
- Controlled vocabulary validation (variants, placement, widthMode)
- A11y labels presence (all interactive components)
- Routes exist and compile (/preset_editor created, /home exists)
- Token usage present in theme (all colors and typography defined)
- Test coverage thresholds (State/Model: 100%, Overall: ≥80%)
- i18n completeness (all UI strings in ARB files, no hardcoded text)
- Preset model extension (prepareSeconds, cooldownSeconds added)

---

# 13. Checklist (subset of PR_CHECKLIST)
- [x] Keys assigned on interactive widgets (all keys follow preset_editor__{compId} pattern)
- [x] Texts verbatim + transform (SIMPLE, ADVANCED, PRÉPARER, etc. uppercase via transform)
- [x] Variants/placement/widthMode valid (primary|ghost, center|end, fill|hug)
- [x] Actions wired to state methods (all 15 actions mapped)
- [x] Golden-ready (stable layout, deterministic rendering)
- [x] Test generation plan complete (all State methods and interactive components listed)
- [x] ValueControl pattern reused (5 instances: prepare, reps, work, rest, cooldown)
- [x] i18n plan complete (24 text keys extracted, ARB files defined)
- [x] Preset model extension identified (prepareSeconds, cooldownSeconds to be added in Step 4)

