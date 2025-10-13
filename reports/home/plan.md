---
# Deterministic Build Plan — Écran d'Accueil

# YAML front matter for machine-readability
screenName: IntervalTimerHome
screenId: interval_timer_home
designSnapshotRef: 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png
planVersion: 2
generatedAt: 2025-10-13T00:00:00Z
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
| field            | value |
|------------------|-------|
| screenId         | interval_timer_home |
| designSnapshotRef| 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png |
| inputsHash       | <computed at runtime> |

---

# 2. Files to Generate
## 2.1 Widgets
| widgetName           | filePath                                      | purpose (fr court)          | components (compIds) | notes |
|----------------------|-----------------------------------------------|-----------------------------|----------------------|-------|
| VolumeHeader         | lib/widgets/home/volume_header.dart           | En-tête avec contrôle volume | Container-1, IconButton-2, Slider-3, Icon-4, IconButton-5 | Icon-4 est un thumb visuel, à ignorer (rule:slider/normalizeSiblings) |
| QuickStartCard       | lib/widgets/home/quick_start_card.dart        | Configuration rapide d'intervalle | Card-6, Container-7, Text-8, IconButton-9, Text-10 à Text-21, Button-22, Button-23 | Contient 3 ValueControl patterns |
| QuickStartHeader     | lib/widgets/home/quick_start_header.dart      | Entête section Démarrage rapide | Container-7, Text-8, IconButton-9 | —     |
| PresetsHeader        | lib/widgets/home/presets_header.dart          | Barre de titre préréglages | Container-24, Text-25, IconButton-26, Button-27 | —     |
| PresetCard           | lib/widgets/home/preset_card.dart             | Carte préréglage individuel | Card-28, Container-29, Text-30 à Text-34 | Réutilisable pour liste |
| IntervalTimerHomeScreen | lib/screens/interval_timer_home_screen.dart | Écran principal home | Tous composants | Point d'entrée |

## 2.2 State
| filePath                                      | pattern            | exposes (fields/actions)            | persistence | notes |
|-----------------------------------------------|--------------------|-------------------------------------|-------------|-------|
| lib/state/interval_timer_home_state.dart      | ChangeNotifier     | reps, workSeconds, restSeconds, volume, quickStartExpanded, presetsEditMode, presets; incrementReps, decrementReps, incrementWorkTime, decrementWorkTime, incrementRestTime, decrementRestTime, onVolumeChange, toggleQuickStartSection, saveCurrentAsPreset, loadPreset, startInterval, createNewPreset, enterEditMode, deletePreset | SharedPreferences | État de l'écran home |

## 2.3 Routes
| routeName      | filePath                       | params       | created/uses | notes |
|----------------|--------------------------------|--------------|-------------|-------|
| /home          | lib/routes/app_routes.dart     | —            | uses        | Route principale |
| /timer_running | lib/routes/app_routes.dart     | reps, workSeconds, restSeconds | uses | Navigation depuis Button-23 |
| /preset_editor | lib/routes/app_routes.dart     | mode, presetId? | uses | Navigation depuis Button-27 ou Card-28 long-press |
| /settings      | lib/routes/app_routes.dart     | —            | uses | Navigation depuis IconButton-5 menu |

## 2.4 Themes/Tokens
| tokenType | name       | required | notes |
|----------|------------|----------|-------|
| color    | primary | yes | #607D8B |
| color    | onPrimary | yes | #FFFFFF |
| color    | background | yes | #F2F2F2 |
| color    | surface | yes | #FFFFFF |
| color    | textPrimary | yes | #212121 |
| color    | textSecondary | yes | #616161 |
| color    | divider | yes | #E0E0E0 |
| color    | accent | yes | #FFC107 |
| color    | sliderActive | yes | #FFFFFF |
| color    | sliderInactive | yes | #90A4AE |
| color    | sliderThumb | yes | #FFFFFF |
| color    | border | yes | #DDDDDD |
| color    | cta | yes | #607D8B |
| color    | headerBackgroundDark | yes | #455A64 |
| color    | presetCardBg | yes | #FAFAFA |
| typo     | titleLarge | yes | Titre "Démarrage rapide" (fontSize: 22, bold) |
| typo     | label | yes | Labels uppercase (fontSize: 14, medium) |
| typo     | value | yes | Valeurs numériques (fontSize: 22, bold) |
| typo     | title | yes | Titres sections (fontSize: 22, bold) |
| typo     | body | yes | Détails préréglages (fontSize: 14, regular) |

## 2.5 Tests (to be generated in steps 05/06)

### Widget Tests - 1:1 with § 2.1
| widgetName           | testFilePath                                          | covers (components from that widget) |
|----------------------|-------------------------------------------------------|--------------------------------------|
| VolumeHeader         | test/widgets/home/volume_header_test.dart             | Container-1, IconButton-2, Slider-3, IconButton-5 |
| QuickStartCard       | test/widgets/home/quick_start_card_test.dart          | Card-6, Container-7, Text-8, IconButton-9, Text-10 à Text-21, Button-22, Button-23 |
| QuickStartHeader     | test/widgets/home/quick_start_header_test.dart        | Container-7, Text-8, IconButton-9 |
| PresetsHeader        | test/widgets/home/presets_header_test.dart            | Container-24, Text-25, IconButton-26, Button-27 |
| PresetCard           | test/widgets/home/preset_card_test.dart               | Card-28, Container-29, Text-30 à Text-34 |
| IntervalTimerHomeScreen | test/screens/interval_timer_home_screen_test.dart  | Tous composants |

**Rule:** count(rows above) == count(rows in § 2.1 Widgets) ✓ (6 == 6)

### State Tests
| testFilePath                                          | covers |
|-------------------------------------------------------|--------|
| test/state/interval_timer_home_state_test.dart        | Toutes les actions et champs d'état |

### Shared Test Helpers
| filePath                          | purpose                    |
|-----------------------------------|----------------------------|
| test/helpers/widget_test_helpers.dart | Common setup functions, mock state, pump functions |

---

# 3. Existing components to reuse
| componentName        | filePath                         | purpose of reuse (fr court) | components (compIds) | notes |
|----------------------|----------------------------------|-----------------------------|----------------------|-------|
| ValueControl         | lib/widgets/value_control.dart   | Contrôle +/- avec valeur centrale | IconButton-11, Text-12, IconButton-13 (et similaires pour work/rest) | Pattern détecté 3× dans QuickStartCard |

# 4. Widget Breakdown (from design.json + UI Mapping Guide)
| compId | type   | variant | key                       | widgetName | filePath                                 | buildStrategy (mapping rule id) | notes |
|--------|--------|---------|---------------------------|------------|------------------------------------------|---------------------------------|-------|
| Container-1 | Container | — | interval_timer_home__Container-1 | VolumeHeader | lib/widgets/home/volume_header.dart | rule:group/alignment | Fond headerBackgroundDark, flex row |
| IconButton-2 | IconButton | ghost | interval_timer_home__IconButton-2 | VolumeHeader | lib/widgets/home/volume_header.dart | rule:button/ghost | Icône volume_up |
| Slider-3 | Slider | — | interval_timer_home__Slider-3 | VolumeHeader | lib/widgets/home/volume_header.dart | rule:slider/theme | valueNormalized: 0.62 |
| Icon-4 | Icon | — | — | — | — | rule:slider/normalizeSiblings(drop) | Thumb visuel du slider, à ignorer |
| IconButton-5 | IconButton | ghost | interval_timer_home__IconButton-5 | VolumeHeader | lib/widgets/home/volume_header.dart | rule:button/ghost | Icône more_vert |
| Card-6 | Card | — | interval_timer_home__Card-6 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:card/style | Carte principale Démarrage rapide |
| Container-7 | Container | — | interval_timer_home__Container-7 | QuickStartHeader | lib/widgets/home/quick_start_header.dart | rule:group/alignment | Row header avec titre et toggle |
| Text-8 | Text | — | interval_timer_home__Text-8 | QuickStartHeader | lib/widgets/home/quick_start_header.dart | rule:text/transform | "Démarrage rapide" |
| IconButton-9 | IconButton | ghost | interval_timer_home__IconButton-9 | QuickStartHeader | lib/widgets/home/quick_start_header.dart | rule:button/ghost | expand_less, toggle section |
| Text-10 | Text | — | interval_timer_home__Text-10 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:text/transform | "RÉPÉTITIONS" (uppercase) |
| IconButton-11 | IconButton | ghost | interval_timer_home__IconButton-11 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:pattern/valueControl | Diminuer répétitions (ValueControl) |
| Text-12 | Text | — | interval_timer_home__Text-12 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:pattern/valueControl | Valeur répétitions "16" (ValueControl) |
| IconButton-13 | IconButton | ghost | interval_timer_home__IconButton-13 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:pattern/valueControl | Augmenter répétitions (ValueControl) |
| Text-14 | Text | — | interval_timer_home__Text-14 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:text/transform | "TRAVAIL" (uppercase) |
| IconButton-15 | IconButton | ghost | interval_timer_home__IconButton-15 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:pattern/valueControl | Diminuer temps travail (ValueControl) |
| Text-16 | Text | — | interval_timer_home__Text-16 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:pattern/valueControl | Valeur temps travail "00 : 44" (ValueControl) |
| IconButton-17 | IconButton | ghost | interval_timer_home__IconButton-17 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:pattern/valueControl | Augmenter temps travail (ValueControl) |
| Text-18 | Text | — | interval_timer_home__Text-18 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:text/transform | "REPOS" (uppercase) |
| IconButton-19 | IconButton | ghost | interval_timer_home__IconButton-19 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:pattern/valueControl | Diminuer temps repos (ValueControl) |
| Text-20 | Text | — | interval_timer_home__Text-20 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:pattern/valueControl | Valeur temps repos "00 : 15" (ValueControl) |
| IconButton-21 | IconButton | ghost | interval_timer_home__IconButton-21 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:pattern/valueControl | Augmenter temps repos (ValueControl) |
| Button-22 | Button | ghost | interval_timer_home__Button-22 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:button/ghost | "SAUVEGARDER", leadingIcon save, placement: end |
| Button-23 | Button | cta | interval_timer_home__Button-23 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:button/cta | "COMMENCER", leadingIcon bolt, widthMode: fill |
| Container-24 | Container | — | interval_timer_home__Container-24 | PresetsHeader | lib/widgets/home/presets_header.dart | rule:group/alignment | Row header préréglages |
| Text-25 | Text | — | interval_timer_home__Text-25 | PresetsHeader | lib/widgets/home/presets_header.dart | rule:text/transform | "VOS PRÉRÉGLAGES" (uppercase) |
| IconButton-26 | IconButton | ghost | interval_timer_home__IconButton-26 | PresetsHeader | lib/widgets/home/presets_header.dart | rule:button/ghost | edit, mode édition |
| Button-27 | Button | secondary | interval_timer_home__Button-27 | PresetsHeader | lib/widgets/home/presets_header.dart | rule:button/secondary | "+ AJOUTER", leadingIcon add, placement: end |
| Card-28 | Card | — | interval_timer_home__Card-28 | PresetCard | lib/widgets/home/preset_card.dart | rule:card/style | Carte préréglage avec onTap |
| Container-29 | Container | — | interval_timer_home__Container-29 | PresetCard | lib/widgets/home/preset_card.dart | rule:group/alignment | Row entête préréglage |
| Text-30 | Text | — | interval_timer_home__Text-30 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform | Nom préréglage "gainage" |
| Text-31 | Text | — | interval_timer_home__Text-31 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform | Durée totale "14:22" |
| Text-32 | Text | — | interval_timer_home__Text-32 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform | "RÉPÉTITIONS 20x" |
| Text-33 | Text | — | interval_timer_home__Text-33 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform | "TRAVAIL 00:40" |
| Text-34 | Text | — | interval_timer_home__Text-34 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform | "REPOS 00:03" |

---

# 5. Layout Composition (design.json is authoritative)
## 5.1 Hierarchy
- root: Scaffold
  - appBar: —
  - body: SingleChildScrollView (scrollable: true)
    - Column
      - section s_header → VolumeHeader
      - SizedBox (height: 8)
      - section s_quick_start → QuickStartCard
      - SizedBox (height: 16)
      - section s_presets_header → PresetsHeader
      - SizedBox (height: 8)
      - section s_presets_list → ListView.builder (PresetCard × presets.length)

## 5.2 Constraints & Placement
| container | child (widgetName) | flex | alignment (placement) | widthMode | spacing | scrollable |
|-----------|---------------------|------|------------------------|-----------|---------|------------|
| body      | VolumeHeader        | —    | stretch                | fill      | 0       | false      |
| body      | QuickStartCard      | —    | stretch                | fill      | 16      | false      |
| body      | PresetsHeader       | —    | stretch                | fill      | 8       | false      |
| body      | PresetCard (list)   | —    | stretch                | fill      | 8       | true       |

---

# 6. Interaction Wiring (from spec)
| compId | actionName   | stateImpact          | navigation | a11y (ariaLabel) | notes |
|--------|--------------|----------------------|-----------|------------------|-------|
| IconButton-2 | toggleVolumePanel | volumePanelVisible | — | Régler le volume | Futur feature (non implémenté v1) |
| Slider-3 | onVolumeChange | volume (0.0-1.0) | — | Curseur de volume | Persiste dans SharedPreferences |
| IconButton-5 | showContextMenu | — | Menu contextuel | Plus d'options | Futur feature (Settings) |
| IconButton-9 | toggleQuickStartSection | quickStartExpanded | — | Replier la section Démarrage rapide | Animation collapse/expand |
| IconButton-11 | decrementReps | reps (min: 1) | — | Diminuer les répétitions | Limite min, haptic feedback |
| IconButton-13 | incrementReps | reps (max: 99) | — | Augmenter les répétitions | Limite max, haptic feedback |
| IconButton-15 | decrementWorkTime | workSeconds (min: 5) | — | Diminuer le temps de travail | Incrément 5s, limite min |
| IconButton-17 | incrementWorkTime | workSeconds (max: 3600) | — | Augmenter le temps de travail | Incrément 5s, limite max |
| IconButton-19 | decrementRestTime | restSeconds (min: 0) | — | Diminuer le temps de repos | Incrément 5s, limite min |
| IconButton-21 | incrementRestTime | restSeconds (max: 3600) | — | Augmenter le temps de repos | Incrément 5s, limite max |
| Button-22 | saveCurrentAsPreset | presets | Dialogue nom | Sauvegarder le préréglage rapide | Dialogue saisie nom, puis sauvegarde |
| Button-23 | startInterval | — | → TimerRunning screen | Démarrer l'intervalle | Navigation avec paramètres {reps, workSeconds, restSeconds} |
| IconButton-26 | enterEditMode | presetsEditMode | — | Éditer les préréglages | Affiche icônes suppression |
| Button-27 | createNewPreset | — | → PresetEditor screen | Ajouter un préréglage | Mode création |
| Card-28 | loadPreset | reps, workSeconds, restSeconds | — | Sélectionner préréglage gainage | Charge config dans QuickStart, scroll vers Card-6 |

---

# 7. State Model & Actions (from spec §6)
## 7.1 Fields
| key          | type | default | persistence | notes |
|--------------|------|---------|-------------|-------|
| reps | int | 16 | SharedPreferences (quick_start) | Nombre de répétitions (min: 1, max: 99) |
| workSeconds | int | 44 | SharedPreferences (quick_start) | Temps de travail en secondes (min: 5, max: 3600) |
| restSeconds | int | 15 | SharedPreferences (quick_start) | Temps de repos en secondes (min: 0, max: 3600) |
| volume | double | 0.62 | SharedPreferences | 0.0 à 1.0 |
| volumePanelVisible | bool | false | non | Affichage panneau volume étendu (futur) |
| quickStartExpanded | bool | true | SharedPreferences | Section Démarrage rapide dépliée |
| presetsEditMode | bool | false | non | Mode édition liste préréglages |
| presets | List\<Preset\> | [] | SharedPreferences (JSON) | Liste des préréglages sauvegardés |

## 7.2 Actions
| name        | input | output | errors | description |
|-------------|-------|--------|--------|-------------|
| incrementReps | — | void | — | reps++, max 99, haptic feedback si limite |
| decrementReps | — | void | — | reps--, min 1, haptic feedback si limite |
| incrementWorkTime | — | void | — | workSeconds += 5, max 3600 |
| decrementWorkTime | — | void | — | workSeconds -= 5, min 5 |
| incrementRestTime | — | void | — | restSeconds += 5, max 3600 |
| decrementRestTime | — | void | — | restSeconds -= 5, min 0 |
| onVolumeChange | double value | void | — | volume = value, persiste dans SharedPreferences |
| toggleQuickStartSection | — | void | — | quickStartExpanded = !quickStartExpanded, persiste |
| saveCurrentAsPreset | String name | Future\<void\> | StorageException | Dialogue nom, puis Preset(name, reps, work, rest), persiste |
| loadPreset | String presetId | void | — | Charge reps/work/rest depuis preset, scroll vers Card-6, haptic |
| startInterval | — | void | — | Navigate vers /timer_running avec {reps, workSeconds, restSeconds} |
| createNewPreset | — | void | — | Navigate vers /preset_editor(mode: create) |
| enterEditMode | — | void | — | presetsEditMode = true, affiche icônes suppression |
| deletePreset | String presetId | Future\<void\> | StorageException | Supprime preset, persiste, SnackBar confirmation |

---

# 8. Accessibility Plan
| order | compId | role        | ariaLabel    | focusable | shortcut | notes |
|------:|--------|-------------|--------------|-----------|----------|-------|
| 1 | IconButton-2 | button | Régler le volume | true | — | Valeur volume annoncée |
| 2 | Slider-3 | slider | Curseur de volume | true | ←/→ | Valeur en % annoncée |
| 3 | IconButton-5 | button | Plus d'options | true | — | Menu contextuel |
| 4 | IconButton-9 | button | Replier la section Démarrage rapide | true | — | État expanded/collapsed |
| 5 | IconButton-11 | button | Diminuer les répétitions | true | — | "16 répétitions" après action |
| 6 | Text-12 | text (value) | — | false | — | "16 répétitions" |
| 7 | IconButton-13 | button | Augmenter les répétitions | true | — | "17 répétitions" après action |
| 8 | IconButton-15 | button | Diminuer le temps de travail | true | — | "39 secondes" après action |
| 9 | Text-16 | text (value) | — | false | — | "44 secondes de travail" |
| 10 | IconButton-17 | button | Augmenter le temps de travail | true | — | "49 secondes" après action |
| 11 | IconButton-19 | button | Diminuer le temps de repos | true | — | "10 secondes" après action |
| 12 | Text-20 | text (value) | — | false | — | "15 secondes de repos" |
| 13 | IconButton-21 | button | Augmenter le temps de repos | true | — | "20 secondes" après action |
| 14 | Button-22 | button | Sauvegarder le préréglage rapide | true | — | — |
| 15 | Button-23 | button (primary) | Démarrer l'intervalle | true | Enter | Action principale |
| 16 | IconButton-26 | button | Éditer les préréglages | true | — | Mode édition |
| 17 | Button-27 | button | Ajouter un préréglage | true | — | — |
| 18 | Card-28 | button | Sélectionner préréglage gainage | true | — | Nom + durée totale annoncés |

---

# 9. Testing Plan (traceability to spec §10)
| testId | preconditions | steps (concise)       | oracle (expected)                                  | finder strategy |
|--------|----------------|-----------------------|----------------------------------------------------|-----------------|
| T1 | valeurs par défaut (reps=16) | tap interval_timer_home__Button-23 | Navigation vers /timer_running avec {reps:16, work:44, rest:15} | find.byKey |
| T2 | reps=16 | tap interval_timer_home__IconButton-13 | Text-12 affiche "17" | find.byKey |
| T3 | reps=1 | tap interval_timer_home__IconButton-11 | Text-12 reste "1", SnackBar erreur | find.byKey |
| T4 | workSeconds=44 | tap interval_timer_home__IconButton-17 2× | Text-16 affiche "00 : 54" | find.byKey |
| T5 | valeurs par défaut | tap interval_timer_home__Button-22, saisir "test" | Nouveau preset "test" dans liste | find.byKey + find.text |
| T6 | preset "gainage" existe | tap Card-28 | Text-12="20", Text-16="00 : 40", Text-20="00 : 03" | find.byKey |
| T7 | quickStartExpanded=true | tap interval_timer_home__IconButton-9 | Card-6 collapse (hauteur réduite), IconButton-9 rotate 180° | find.byKey |
| T8 | volume=0.62 | drag Slider-3 vers 0.8 | volume state=0.8, persisté | find.byKey |
| T9 | valeurs par défaut | render écran | Match golden snapshot | golden test |
| T10 | quickStartExpanded=false | render écran | Card-6 collapsed, match golden | golden test |
| T11 | reps=99 | incrementReps() | reps reste 99 | unit test |
| T12 | workSeconds=5 | decrementWorkTime() | workSeconds reste 5 | unit test |
| T13 | liste vide | ouvrir app, créer preset "test", tap COMMENCER | Timer démarre avec config preset | integration test |

---

# 10. Test Generation Plan

## 10.1 State Tests (`test/state/interval_timer_home_state_test.dart`)

| Component | Method | Test Case | Priority | Coverage Type |
|-----------|--------|-----------|----------|---------------|
| IntervalTimerHomeState | incrementReps | Incrementer de 16 à 17 | CRITICAL | Unit |
| IntervalTimerHomeState | incrementReps | Bloquer à max 99 | CRITICAL | Boundary |
| IntervalTimerHomeState | decrementReps | Décrémenter de 16 à 15 | CRITICAL | Unit |
| IntervalTimerHomeState | decrementReps | Bloquer à min 1 | CRITICAL | Boundary |
| IntervalTimerHomeState | incrementWorkTime | Incrementer de 44 à 49 (+5s) | CRITICAL | Unit |
| IntervalTimerHomeState | incrementWorkTime | Bloquer à max 3600 | HIGH | Boundary |
| IntervalTimerHomeState | decrementWorkTime | Décrémenter de 44 à 39 (-5s) | CRITICAL | Unit |
| IntervalTimerHomeState | decrementWorkTime | Bloquer à min 5 | HIGH | Boundary |
| IntervalTimerHomeState | incrementRestTime | Incrementer de 15 à 20 (+5s) | CRITICAL | Unit |
| IntervalTimerHomeState | incrementRestTime | Bloquer à max 3600 | HIGH | Boundary |
| IntervalTimerHomeState | decrementRestTime | Décrémenter de 15 à 10 (-5s) | CRITICAL | Unit |
| IntervalTimerHomeState | decrementRestTime | Bloquer à min 0 | HIGH | Boundary |
| IntervalTimerHomeState | onVolumeChange | Changer volume de 0.62 à 0.8 | HIGH | Unit |
| IntervalTimerHomeState | toggleQuickStartSection | Basculer de true à false | HIGH | Unit |
| IntervalTimerHomeState | saveCurrentAsPreset | Sauvegarder nouveau preset | CRITICAL | Integration |
| IntervalTimerHomeState | loadPreset | Charger preset existant | CRITICAL | Integration |
| IntervalTimerHomeState | deletePreset | Supprimer preset existant | HIGH | Integration |

**Coverage Target:** 100% lines, 100% branches

---

## 10.2 Widget Tests

| Widget | Component Key | Test Case | Expected Behavior |
|--------|---------------|-----------|-------------------|
| VolumeHeader | interval_timer_home__IconButton-2 | Tap volume icon | Callback déclenché |
| VolumeHeader | interval_timer_home__Slider-3 | Drag slider | onVolumeChange appelé avec valeur |
| VolumeHeader | interval_timer_home__IconButton-5 | Tap more_vert | showContextMenu appelé |
| QuickStartCard | interval_timer_home__Button-23 | Tap COMMENCER | startInterval appelé |
| QuickStartCard | interval_timer_home__Button-22 | Tap SAUVEGARDER | saveCurrentAsPreset appelé |
| QuickStartCard | interval_timer_home__IconButton-11 | Tap diminuer reps | decrementReps appelé |
| QuickStartCard | interval_timer_home__IconButton-13 | Tap augmenter reps | incrementReps appelé |
| QuickStartCard | interval_timer_home__Text-12 | Render avec reps=16 | Affiche "16" |
| QuickStartCard | interval_timer_home__IconButton-15 | Tap diminuer work | decrementWorkTime appelé |
| QuickStartCard | interval_timer_home__IconButton-17 | Tap augmenter work | incrementWorkTime appelé |
| QuickStartCard | interval_timer_home__Text-16 | Render avec workSeconds=44 | Affiche "00 : 44" |
| QuickStartCard | interval_timer_home__IconButton-19 | Tap diminuer rest | decrementRestTime appelé |
| QuickStartCard | interval_timer_home__IconButton-21 | Tap augmenter rest | incrementRestTime appelé |
| QuickStartCard | interval_timer_home__Text-20 | Render avec restSeconds=15 | Affiche "00 : 15" |
| QuickStartHeader | interval_timer_home__IconButton-9 | Tap expand_less | toggleQuickStartSection appelé |
| QuickStartHeader | interval_timer_home__Text-8 | Render | Affiche "Démarrage rapide" |
| PresetsHeader | interval_timer_home__Button-27 | Tap + AJOUTER | createNewPreset appelé |
| PresetsHeader | interval_timer_home__IconButton-26 | Tap edit | enterEditMode appelé |
| PresetsHeader | interval_timer_home__Text-25 | Render | Affiche "VOS PRÉRÉGLAGES" |
| PresetCard | interval_timer_home__Card-28 | Tap card | loadPreset appelé avec presetId |
| PresetCard | interval_timer_home__Text-30 | Render avec nom="gainage" | Affiche "gainage" |
| PresetCard | interval_timer_home__Text-31 | Render avec durée="14:22" | Affiche "14:22" |
| IntervalTimerHomeScreen | interval_timer_home__Button-23 | Tap avec valeurs défaut | Navigation vers /timer_running |
| IntervalTimerHomeScreen | (golden) | Render initial | Match snapshot |

**Coverage Target:** ≥90% for generic widgets, ≥70% for screen-specific widgets

---

## 10.3 Accessibility Tests

| Widget | Component Key | Semantic Label | Role | State |
|--------|---------------|----------------|------|-------|
| VolumeHeader | interval_timer_home__IconButton-2 | Régler le volume | button | enabled |
| VolumeHeader | interval_timer_home__Slider-3 | Curseur de volume | slider | enabled |
| VolumeHeader | interval_timer_home__IconButton-5 | Plus d'options | button | enabled |
| QuickStartHeader | interval_timer_home__IconButton-9 | Replier la section Démarrage rapide | button | enabled |
| QuickStartCard | interval_timer_home__IconButton-11 | Diminuer les répétitions | button | enabled (si reps > 1) |
| QuickStartCard | interval_timer_home__IconButton-13 | Augmenter les répétitions | button | enabled (si reps < 99) |
| QuickStartCard | interval_timer_home__IconButton-15 | Diminuer le temps de travail | button | enabled (si workSeconds > 5) |
| QuickStartCard | interval_timer_home__IconButton-17 | Augmenter le temps de travail | button | enabled (si workSeconds < 3600) |
| QuickStartCard | interval_timer_home__IconButton-19 | Diminuer le temps de repos | button | enabled (si restSeconds > 0) |
| QuickStartCard | interval_timer_home__IconButton-21 | Augmenter le temps de repos | button | enabled (si restSeconds < 3600) |
| QuickStartCard | interval_timer_home__Button-22 | Sauvegarder le préréglage rapide | button | enabled |
| QuickStartCard | interval_timer_home__Button-23 | Démarrer l'intervalle | button | enabled |
| PresetsHeader | interval_timer_home__IconButton-26 | Éditer les préréglages | button | enabled |
| PresetsHeader | interval_timer_home__Button-27 | Ajouter un préréglage | button | enabled |
| PresetCard | interval_timer_home__Card-28 | Sélectionner préréglage gainage | button | enabled |

---

## 10.4 Components excluded from tests

| Component | Reason        |
|-----------|---------------|
| Icon-4 | Thumb visuel du slider, ignoré (rule:slider/normalizeSiblings) |

---

# 11. Risks / Unknowns (from spec §11.3)
- **Format d'affichage du temps** : "00 : 44" (avec espaces) vs "00:44" (sans espaces) — design montre espaces, à confirmer si intentionnel
- **Limite maximale de préréglages** : aucune limite spécifiée, arbitraire ? (assume 100 max pour perf)
- **Comportement long-press sur Card-28** : menu contextuel (éditer/supprimer) supposé, pas visible dans snapshot
- **Icône material.circle (Icon-4)** : rôle exact (indicateur visuel vs élément interactif) → traité comme thumb visuel, ignoré
- **Haptic feedback** : intensité et pattern non spécifiés (assume HapticFeedback.lightImpact())
- **Animation collapse/expand Card-6** : durée et easing non spécifiés (assume AnimatedSize, 300ms, Curves.easeInOut)
- **Dialogue nom préréglage** : design non fourni, assume TextField simple avec validation
- **Menu contextuel IconButton-5** : contenu non spécifié, assume navigation vers /settings uniquement
- **Écrans cibles** : /timer_running, /preset_editor, /settings non implémentés dans ce build

---

# 12. Check Gates
- Analyzer/lint pass ✓
- Unique keys check ✓
- Controlled vocabulary validation ✓
- A11y labels presence ✓
- Routes exist and compile (stubbed for v1)
- Token usage present in theme ✓
- Test coverage thresholds (State/Model: 100%, Overall: ≥80%)

---

# 13. Checklist (subset of PR_CHECKLIST)
- [ ] Keys assigned on interactive widgets (all 34 components mapped)
- [ ] Texts verbatim + transform (uppercase applied where needed)
- [ ] Variants/placement/widthMode valid (cta, primary, secondary, ghost; start, center, end, stretch; hug, fill, fixed)
- [ ] Actions wired to state methods (all 14 actions mapped)
- [ ] Golden-ready (stable layout, no randoms)
- [ ] Test generation plan complete (17 state methods, 23 widget test cases, 15 a11y tests)
- [ ] ValueControl pattern detected and reused (3× dans QuickStartCard)
- [ ] Icon-4 (slider thumb) excluded per rule:slider/normalizeSiblings
- [ ] Card styling follows rule:card/style (elevation:0, radius:2, margin:6, padding:12)
- [ ] Font sizes follow rule:font/size (no copyWith overrides, use closest predefined style)

