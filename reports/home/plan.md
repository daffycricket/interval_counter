---
# Deterministic Build Plan — Home

# YAML front matter for machine-readability
screenName: Home
screenId: home
designSnapshotRef: 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png
planVersion: 2
generatedAt: 2025-10-19T00:00:00Z
generator: spec2plan
language: fr
inputsHash: 437d72fde961ff5747ef82a85650cff2679df838027edbb372930d59efc468c6
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
| screenId         | home   |
| designSnapshotRef| 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png   |
| inputsHash       | 437d72fde961ff5747ef82a85650cff2679df838027edbb372930d59efc468c6   |

---

# 2. Files to Generate
## 2.1 Widgets
| widgetName           | filePath                         | purpose (fr court)          | components (compIds) | notes |
|----------------------|----------------------------------|-----------------------------|----------------------|-------|
| HomeScreen | lib/screens/home_screen.dart | Écran principal | Tous composants | StatefulWidget principal |
| VolumeHeader | lib/widgets/home/volume_header.dart | Barre volume et menu | IconButton-2, Slider-3, IconButton-5 | Header avec contrôle volume |
| QuickStartCard | lib/widgets/home/quick_start_card.dart | Carte démarrage rapide | Card-6, Container-7, Text-8, IconButton-9, Text-10 à Text-21, Button-22 | Configuration rapide |
| PresetsHeader | lib/widgets/home/presets_header.dart | En-tête section préréglages | Container-24, Text-25, IconButton-26, Button-27 | Barre titre + bouton ajouter |
| PresetCard | lib/widgets/home/preset_card.dart | Carte d'un préréglage | Card-28, Container-29, Text-30 à Text-34 | Affichage préréglage individuel |

## 2.2 State
| filePath                         | pattern            | exposes (fields/actions)            | persistence | notes |
|----------------------------------|--------------------|-------------------------------------|-------------|-------|
| lib/state/home_state.dart  | ChangeNotifier     | reps,workSeconds,restSeconds,volume,quickStartExpanded,presets,editMode;incrementReps,decrementReps,incrementWork,decrementWork,incrementRest,decrementRest,onVolumeChange,toggleQuickStart,savePreset,addPreset,deletePreset,editPresets  | oui (reps,workSeconds,restSeconds,volume,presets) | State principal Home |

## 2.3 Routes
| routeName      | filePath                       | params       | created/uses | notes |
|----------------|--------------------------------|--------------|-------------|-------|
| /home          | lib/routes/app_routes.dart     | —            | uses        | Route principale |
| /timer         | lib/routes/app_routes.dart     | reps,workSeconds,restSeconds | uses | Destination COMMENCER |

## 2.4 Themes/Tokens
| tokenType | name       | required | notes |
|----------|------------|----------|-------|
| color    | primary        | yes      | Couleur principale #607D8B |
| color    | onPrimary      | yes      | Texte sur primary #FFFFFF |
| color    | background     | yes      | Fond écran #F2F2F2 |
| color    | surface        | yes      | Fond cartes #FFFFFF |
| color    | textPrimary    | yes      | Texte principal #212121 |
| color    | textSecondary  | yes      | Texte secondaire #616161 |
| color    | divider        | yes      | Séparateurs #E0E0E0 |
| color    | accent         | yes      | Accent #FFC107 |
| color    | sliderActive   | yes      | Piste slider active #FFFFFF |
| color    | sliderInactive | yes      | Piste slider inactive #90A4AE |
| color    | sliderThumb    | yes      | Curseur slider #FFFFFF |
| color    | border         | yes      | Bordures #DDDDDD |
| color    | cta            | yes      | Bouton CTA #607D8B |
| color    | headerBackgroundDark | yes | Fond header #455A64 |
| color    | presetCardBg   | yes      | Fond carte préréglage #FAFAFA |
| typo     | titleLarge     | yes      | Titres section |
| typo     | title          | yes      | Titres carte |
| typo     | label          | yes      | Labels contrôles |
| typo     | body           | yes      | Texte corps |
| typo     | value          | yes      | Valeurs numériques |

## 2.5 Tests (to be generated in steps 05/06)

### Widget Tests - 1:1 with § 2.1
| widgetName           | testFilePath                                | covers (components from that widget) |
|----------------------|---------------------------------------------|--------------------------------------|
| HomeScreen | test/screens/home_screen_test.dart | Tous composants (intégration) |
| VolumeHeader | test/widgets/home/volume_header_test.dart | IconButton-2, Slider-3, IconButton-5 |
| QuickStartCard | test/widgets/home/quick_start_card_test.dart | Card-6, Text-8, IconButton-9, ValueControls, Button-22 |
| PresetsHeader | test/widgets/home/presets_header_test.dart | Text-25, IconButton-26, Button-27 |
| PresetCard | test/widgets/home/preset_card_test.dart | Card-28, Text-30 à Text-34 |

**Rule:** count(rows above) == count(rows in § 2.1 Widgets) ✓ (5 = 5)

### Shared Test Helpers
| filePath                          | purpose                    |
|-----------------------------------|----------------------------|
| test/helpers/widget_test_helpers.dart | Common setup, mock state, pump utilities |

---

# 3. Existing components to reuse
| componentName        | filePath                         | purpose of reuse (fr court) | components (compIds) | notes |
|----------------------|----------------------------------|-----------------------------|----------------------|-------|
| ValueControl | lib/widgets/value_control.dart | Contrôle +/− avec valeur centrale | IconButton-11,Text-12,IconButton-13 (et équivalents) | Pattern identifié 3x |

---

# 4. Widget Breakdown (from design.json + UI Mapping Guide)
| compId | type   | variant | key                       | widgetName | filePath                        | buildStrategy (mapping rule id) | notes |
|--------|--------|---------|---------------------------|------------|----------------------------------|---------------------------------|-------|
| Container-1 | Container | — | home__Container-1 | VolumeHeader | lib/widgets/home/volume_header.dart | rule:group/alignment | Header container |
| IconButton-2 | IconButton | ghost | home__IconButton-2 | VolumeHeader | lib/widgets/home/volume_header.dart | rule:iconButton/shaped, rule:button/ghost | Bouton volume |
| Slider-3 | Slider | — | home__Slider-3 | VolumeHeader | lib/widgets/home/volume_header.dart | rule:slider/theme, rule:slider/normalizeSiblings(drop Icon-4) | Curseur volume |
| Icon-4 | Icon | — | — | — | — | rule:slider/normalizeSiblings(drop) | Thumb orphelin, exclu du build |
| IconButton-5 | IconButton | ghost | home__IconButton-5 | VolumeHeader | lib/widgets/home/volume_header.dart | rule:iconButton/shaped, rule:button/ghost | Menu options |
| Card-6 | Card | — | home__Card-6 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:card/style | Carte démarrage rapide |
| Container-7 | Container | — | home__Container-7 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:group/alignment | En-tête carte |
| Text-8 | Text | — | home__Text-8 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:text/transform, rule:font/size | Titre "Démarrage rapide" |
| IconButton-9 | IconButton | ghost | home__IconButton-9 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:iconButton/shaped, rule:button/ghost | Bouton replier |
| Text-10 | Text | — | home__Text-10 | QuickStartCard (ValueControl) | lib/widgets/home/quick_start_card.dart | rule:text/transform | Label RÉPÉTITIONS |
| IconButton-11 | IconButton | ghost | home__IconButton-11 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton - reps |
| Text-12 | Text | — | home__Text-12 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Valeur reps |
| IconButton-13 | IconButton | ghost | home__IconButton-13 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton + reps |
| Text-14 | Text | — | home__Text-14 | QuickStartCard (ValueControl) | lib/widgets/home/quick_start_card.dart | rule:text/transform | Label TRAVAIL |
| IconButton-15 | IconButton | ghost | home__IconButton-15 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton - work |
| Text-16 | Text | — | home__Text-16 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Valeur work |
| IconButton-17 | IconButton | ghost | home__IconButton-17 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton + work |
| Text-18 | Text | — | home__Text-18 | QuickStartCard (ValueControl) | lib/widgets/home/quick_start_card.dart | rule:text/transform | Label REPOS |
| IconButton-19 | IconButton | ghost | home__IconButton-19 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton - rest |
| Text-20 | Text | — | home__Text-20 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Valeur rest |
| IconButton-21 | IconButton | ghost | home__IconButton-21 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Bouton + rest |
| Button-22 | Button | ghost | home__Button-22 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:button/ghost, rule:layout/placement(end), rule:layout/widthMode(hug) | Bouton SAUVEGARDER |
| Button-23 | Button | cta | home__Button-23 | HomeScreen | lib/screens/home_screen.dart | rule:button/cta, rule:layout/placement(start), rule:layout/widthMode(fill) | Bouton COMMENCER |
| Container-24 | Container | — | home__Container-24 | PresetsHeader | lib/widgets/home/presets_header.dart | rule:group/alignment | Container barre préréglages |
| Text-25 | Text | — | home__Text-25 | PresetsHeader | lib/widgets/home/presets_header.dart | rule:text/transform | Titre VOS PRÉRÉGLAGES |
| IconButton-26 | IconButton | ghost | home__IconButton-26 | PresetsHeader | lib/widgets/home/presets_header.dart | rule:iconButton/shaped, rule:button/ghost | Bouton éditer |
| Button-27 | Button | secondary | home__Button-27 | PresetsHeader | lib/widgets/home/presets_header.dart | rule:button/secondary, rule:layout/placement(end), rule:layout/widthMode(hug) | Bouton + AJOUTER |
| Card-28 | Card | — | home__Card-28 | PresetCard | lib/widgets/home/preset_card.dart | rule:card/style | Carte préréglage |
| Container-29 | Container | — | home__Container-29 | PresetCard | lib/widgets/home/preset_card.dart | rule:group/alignment | En-tête préréglage |
| Text-30 | Text | — | home__Text-30 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform | Nom préréglage |
| Text-31 | Text | — | home__Text-31 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform | Durée totale |
| Text-32 | Text | — | home__Text-32 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform | Détail répétitions |
| Text-33 | Text | — | home__Text-33 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform | Détail travail |
| Text-34 | Text | — | home__Text-34 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform | Détail repos |

---

# 5. Layout Composition (design.json is authoritative)
## 5.1 Hierarchy
- root: Scaffold(backgroundColor: AppColors.background)
  - appBar: VolumeHeader (custom PreferredSize)
  - body: Column (scrollable via SingleChildScrollView)
    - QuickStartCard
    - SizedBox(height: 8) — spacing
    - Button-23 (COMMENCER) — widthMode:fill, placement:start
    - SizedBox(height: 12) — spacing
    - PresetsHeader
    - SizedBox(height: 8) — spacing
    - Expanded → ListView.builder(presets) → PresetCard (Dismissible for swipe)

## 5.2 Constraints & Placement
| container | child (widgetName) | flex | alignment (placement) | widthMode | spacing | scrollable |
|----------|---------------------|------|------------------------|-----------|---------|------------|
| Scaffold.appBar | VolumeHeader | — | stretch | fill | — | false |
| body Column | QuickStartCard | — | center | hug | 12 | false |
| body Column | Button-23 | — | start | fill | 12 | false |
| body Column | PresetsHeader | — | center | hug | 8 | false |
| body Column | ListView | 1 | stretch | fill | 0 | true |

---

# 6. Interaction Wiring (from spec)
| compId | actionName   | stateImpact          | navigation | a11y (ariaLabel) | notes |
|--------|--------------|----------------------|-----------|------------------|-------|
| IconButton-2 | adjustVolume | — | — | Régler le volume | Action informative |
| Slider-3 | onVolumeChange | volume | — | Curseur de volume | Met à jour volume |
| IconButton-5 | openMenu | — | Menu | Plus d'options | Navigation menu |
| IconButton-9 | toggleQuickStart | quickStartExpanded | — | Replier la section Démarrage rapide | Toggle section |
| IconButton-11 | decrementReps | reps | — | Diminuer les répétitions | Décrémente reps (min 1) |
| IconButton-13 | incrementReps | reps | — | Augmenter les répétitions | Incrémente reps |
| IconButton-15 | decrementWork | workSeconds | — | Diminuer le temps de travail | Décrémente workSeconds (min 1) |
| IconButton-17 | incrementWork | workSeconds | — | Augmenter le temps de travail | Incrémente workSeconds |
| IconButton-19 | decrementRest | restSeconds | — | Diminuer le temps de repos | Décrémente restSeconds (min 0) |
| IconButton-21 | incrementRest | restSeconds | — | Augmenter le temps de repos | Incrémente restSeconds |
| Button-22 | savePreset | presets | Dialog | Sauvegarder le préréglage rapide | Ouvre dialog, puis sauvegarde |
| Button-23 | startInterval | — | Timer | Démarrer l'intervalle | Navigation /timer avec params |
| IconButton-26 | editPresets | editMode | — | Éditer les préréglages | Toggle mode édition |
| Button-27 | addPreset | presets | Dialog | Ajouter un préréglage | Ouvre dialog, puis sauvegarde |
| Card-28 (swipe) | deletePreset | presets | — | Supprimer préréglage | Swipe pour supprimer |

---

# 7. State Model & Actions (from spec §6)
## 7.1 Fields
| key          | type | default | persistence | notes |
|--------------|------|---------|-------------|-------|
| reps | int | 10 | oui | Répétitions (min 1) |
| workSeconds | int | 40 | oui | Temps de travail en secondes (min 1) |
| restSeconds | int | 20 | oui | Temps de repos en secondes (min 0) |
| volume | double | 0.62 | oui | Volume normalisé [0.0, 1.0] |
| quickStartExpanded | bool | true | non | Section démarrage rapide dépliée |
| presets | List<Preset> | [] | oui | Liste des préréglages (JSON) |
| editMode | bool | false | non | Mode édition préréglages |

## 7.2 Actions
| name        | input | output | errors | description |
|-------------|-------|--------|--------|-------------|
| incrementReps | — | — | — | Augmente reps de 1 |
| decrementReps | — | — | — | Diminue reps de 1 (min 1) |
| incrementWork | — | — | — | Augmente workSeconds de 1 |
| decrementWork | — | — | — | Diminue workSeconds de 1 (min 1) |
| incrementRest | — | — | — | Augmente restSeconds de 1 |
| decrementRest | — | — | — | Diminue restSeconds de 1 (min 0) |
| onVolumeChange | double value | — | — | Met à jour volume |
| toggleQuickStart | — | — | — | Inverse quickStartExpanded |
| savePreset | String name | — | nom vide | Crée nouveau préréglage avec valeurs actuelles |
| addPreset | — | — | — | Ouvre dialog puis appelle savePreset |
| deletePreset | String id | — | — | Supprime préréglage de la liste |
| startInterval | — | — | — | Navigation vers Timer avec params |
| editPresets | — | — | — | Toggle editMode |
| openMenu | — | — | — | Navigation vers Menu |
| adjustVolume | — | — | — | Action informative (UI déjà présente via Slider) |

---

# 8. Accessibility Plan
| order | compId | role        | ariaLabel    | focusable | shortcut | notes |
|------:|--------|-------------|--------------|-----------|----------|-------|
| 1 | IconButton-2 | button | Régler le volume | true | — | — |
| 2 | Slider-3 | slider | Curseur de volume | true | — | — |
| 3 | IconButton-5 | button | Plus d'options | true | — | — |
| 4 | IconButton-9 | button | Replier la section Démarrage rapide | true | — | — |
| 5 | IconButton-11 | button | Diminuer les répétitions | true | — | — |
| 6 | IconButton-13 | button | Augmenter les répétitions | true | — | — |
| 7 | IconButton-15 | button | Diminuer le temps de travail | true | — | — |
| 8 | IconButton-17 | button | Augmenter le temps de travail | true | — | — |
| 9 | IconButton-19 | button | Diminuer le temps de repos | true | — | — |
| 10 | IconButton-21 | button | Augmenter le temps de repos | true | — | — |
| 11 | Button-22 | button | Sauvegarder le préréglage rapide | true | — | — |
| 12 | Button-23 | button | Démarrer l'intervalle | true | Enter | Action principale |
| 13 | IconButton-26 | button | Éditer les préréglages | true | — | — |
| 14 | Button-27 | button | Ajouter un préréglage | true | — | — |

---

# 9. Testing Plan (traceability to spec §10)
| testId | preconditions | steps (concise)       | oracle (expected)                                  | finder strategy |
|--------|----------------|-----------------------|----------------------------------------------------|-----------------|
| T1 | reps=10 | tap home__IconButton-13 | find.byKey('home__Text-12') text = "11" | find.byKey |
| T2 | reps=10 | tap home__IconButton-11 9 fois | find.byKey('home__Text-12') text = "1", IconButton-11 disabled | find.byKey |
| T3 | workSeconds=40 | tap home__IconButton-17 4 fois | find.byKey('home__Text-16') text = "00 : 44" | find.byKey |
| T4 | restSeconds=20 | tap home__IconButton-19 5 fois | find.byKey('home__Text-20') text = "00 : 15" | find.byKey |
| T5 | presets=[] | tap home__Button-27 | dialog appears | find.byType |
| T6 | state.reps=10 | incrementReps() | state.reps = 11 | unit test |
| T7 | state.reps=1 | decrementReps() | state.reps = 1 | unit test |
| T8 | state.workSeconds=1 | decrementWork() | state.workSeconds = 1 | unit test |
| T9 | state.restSeconds=0 | decrementRest() | state.restSeconds = 0 | unit test |
| T10 | presets=[] | — | find.text('Aucun préréglage') | find.text |
| T11 | presets=[gainage] | swipe home__Card-28 | presets.length = 0 | find.byKey + drag |
| T12 | — | — | all interactive components have Semantics with label | a11y test |
| T13 | default state | — | matches golden file | golden test |

---

# 10. Test Generation Plan

## 10.1 State Tests (`test/state/home_state_test.dart`)

| Component | Method | Test Case | Priority | Coverage Type |
|-----------|--------|-----------|----------|---------------|
| HomeState | incrementReps | increments from default (10) to 11 | CRITICAL | Unit |
| HomeState | incrementReps | increments from 998 to 999 (boundary) | HIGH | Boundary |
| HomeState | decrementReps | decrements from 10 to 9 | CRITICAL | Unit |
| HomeState | decrementReps | stops at minimum (1) | CRITICAL | Boundary |
| HomeState | incrementWork | increments from default (40) to 41 | CRITICAL | Unit |
| HomeState | decrementWork | decrements from 40 to 39 | CRITICAL | Unit |
| HomeState | decrementWork | stops at minimum (1) | CRITICAL | Boundary |
| HomeState | incrementRest | increments from default (20) to 21 | CRITICAL | Unit |
| HomeState | decrementRest | decrements from 20 to 19 | CRITICAL | Unit |
| HomeState | decrementRest | stops at minimum (0) | CRITICAL | Boundary |
| HomeState | onVolumeChange | updates volume to 0.5 | CRITICAL | Unit |
| HomeState | onVolumeChange | clamps volume to [0.0, 1.0] | HIGH | Boundary |
| HomeState | toggleQuickStart | toggles from true to false | HIGH | Unit |
| HomeState | toggleQuickStart | toggles from false to true | HIGH | Unit |
| HomeState | savePreset | adds preset with valid name | CRITICAL | Unit |
| HomeState | savePreset | rejects empty name | CRITICAL | Unit |
| HomeState | deletePreset | removes existing preset | CRITICAL | Unit |
| HomeState | deletePreset | handles non-existent preset | HIGH | Unit |
| HomeState | _loadState | loads from SharedPreferences | CRITICAL | Integration |
| HomeState | _saveState | persists to SharedPreferences | CRITICAL | Integration |
| HomeState | formatTime | formats 44 seconds as "00 : 44" | CRITICAL | Unit |
| HomeState | formatTime | formats 0 seconds as "00 : 00" | HIGH | Boundary |
| HomeState | formatTime | formats 3661 seconds as "01 : 01 : 01" | HIGH | Boundary |

**Coverage Target:** 100% lines, 100% branches

---

## 10.2 Widget Tests

| Widget | Component Key | Test Case | Expected Behavior |
|--------|---------------|-----------|-------------------|
| HomeScreen | home__Button-23 | renders START button | button is visible and enabled |
| HomeScreen | home__Button-23 | taps START button | navigates to /timer with params |
| VolumeHeader | home__IconButton-2 | renders volume icon button | button is visible |
| VolumeHeader | home__Slider-3 | slider value changes | onVolumeChange called with new value |
| VolumeHeader | home__IconButton-5 | taps menu button | openMenu action called |
| QuickStartCard | home__Text-8 | renders title | "Démarrage rapide" visible |
| QuickStartCard | home__IconButton-9 | taps collapse button | toggleQuickStart called |
| QuickStartCard | home__IconButton-11 | taps decrement reps | decrementReps called, value updates |
| QuickStartCard | home__IconButton-13 | taps increment reps | incrementReps called, value updates |
| QuickStartCard | home__Text-12 | displays reps value | shows current reps (e.g., "16") |
| QuickStartCard | home__IconButton-15 | taps decrement work | decrementWork called, value updates |
| QuickStartCard | home__IconButton-17 | taps increment work | incrementWork called, value updates |
| QuickStartCard | home__Text-16 | displays work time | shows formatted time (e.g., "00 : 44") |
| QuickStartCard | home__IconButton-19 | taps decrement rest | decrementRest called, value updates |
| QuickStartCard | home__IconButton-21 | taps increment rest | incrementRest called, value updates |
| QuickStartCard | home__Text-20 | displays rest time | shows formatted time (e.g., "00 : 15") |
| QuickStartCard | home__Button-22 | taps SAVE button | savePreset action called, dialog appears |
| PresetsHeader | home__Text-25 | renders title | "VOS PRÉRÉGLAGES" visible |
| PresetsHeader | home__IconButton-26 | taps edit button | editPresets called, mode toggles |
| PresetsHeader | home__Button-27 | taps ADD button | addPreset called, dialog appears |
| PresetCard | home__Card-28 | renders preset name | shows preset name (e.g., "gainage") |
| PresetCard | home__Text-31 | displays total duration | shows duration (e.g., "14:22") |
| PresetCard | home__Card-28 | swipe to delete | deletePreset called, card removed |
| ValueControl | home__IconButton-11 | button disabled at minimum | decrementReps button disabled when reps=1 |
| ValueControl | home__IconButton-19 | button disabled at minimum | decrementRest button disabled when restSeconds=0 |

**Coverage Target:** ≥90% for generic widgets (ValueControl), ≥70% for screen-specific widgets

---

## 10.3 Accessibility Tests

| Widget | Component Key | Semantic Label | Role | State |
|--------|---------------|----------------|------|-------|
| VolumeHeader | home__IconButton-2 | Régler le volume | button | enabled |
| VolumeHeader | home__Slider-3 | Curseur de volume | slider | enabled |
| VolumeHeader | home__IconButton-5 | Plus d'options | button | enabled |
| QuickStartCard | home__IconButton-9 | Replier la section Démarrage rapide | button | enabled |
| QuickStartCard | home__IconButton-11 | Diminuer les répétitions | button | enabled/disabled |
| QuickStartCard | home__IconButton-13 | Augmenter les répétitions | button | enabled |
| QuickStartCard | home__IconButton-15 | Diminuer le temps de travail | button | enabled/disabled |
| QuickStartCard | home__IconButton-17 | Augmenter le temps de travail | button | enabled |
| QuickStartCard | home__IconButton-19 | Diminuer le temps de repos | button | enabled/disabled |
| QuickStartCard | home__IconButton-21 | Augmenter le temps de repos | button | enabled |
| QuickStartCard | home__Button-22 | Sauvegarder le préréglage rapide | button | enabled |
| HomeScreen | home__Button-23 | Démarrer l'intervalle | button | enabled |
| PresetsHeader | home__IconButton-26 | Éditer les préréglages | button | enabled |
| PresetsHeader | home__Button-27 | Ajouter un préréglage | button | enabled |

---

## 10.4 Components excluded from tests

| Component | Reason        |
|-----------|---------------|
| Icon-4 | Orphan thumb decoration (dropped per rule:slider/normalizeSiblings) |
| Container-1, Container-7, Container-24, Container-29 | Layout containers (no interaction, tested via parent widgets) |

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
| Text-8 | Démarrage rapide | quickStartTitle | Quick start section title |
| Text-10 | RÉPÉTITIONS | repsLabel | Repetitions label |
| Text-14 | TRAVAIL | workLabel | Work time label |
| Text-18 | REPOS | restLabel | Rest time label |
| Button-22 | SAUVEGARDER | saveButton | Save button text |
| Button-23 | COMMENCER | startButton | Start button text |
| Text-25 | VOS PRÉRÉGLAGES | presetsTitle | Presets section title |
| Button-27 | + AJOUTER | addButton | Add button text |
| — | Aucun préréglage | noPresetsMessage | Empty state message |
| — | Veuillez saisir un nom | presetNameError | Validation error for empty preset name |
| IconButton-2 | Régler le volume | volumeButtonLabel | Volume button semantic label |
| Slider-3 | Curseur de volume | volumeSliderLabel | Volume slider semantic label |
| IconButton-5 | Plus d'options | menuButtonLabel | Menu button semantic label |
| IconButton-9 | Replier la section Démarrage rapide | collapseQuickStartLabel | Collapse button semantic label |
| IconButton-11 | Diminuer les répétitions | decreaseRepsLabel | Decrease reps button semantic label |
| IconButton-13 | Augmenter les répétitions | increaseRepsLabel | Increase reps button semantic label |
| IconButton-15 | Diminuer le temps de travail | decreaseWorkLabel | Decrease work button semantic label |
| IconButton-17 | Augmenter le temps de travail | increaseWorkLabel | Increase work button semantic label |
| IconButton-19 | Diminuer le temps de repos | decreaseRestLabel | Decrease rest button semantic label |
| IconButton-21 | Augmenter le temps de repos | increaseRestLabel | Increase rest button semantic label |
| Button-22 | Sauvegarder le préréglage rapide | savePresetLabel | Save preset button semantic label |
| Button-23 | Démarrer l'intervalle | startIntervalLabel | Start interval button semantic label |
| IconButton-26 | Éditer les préréglages | editPresetsLabel | Edit presets button semantic label |
| Button-27 | Ajouter un préréglage | addPresetLabel | Add preset button semantic label |

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
- Format de la durée totale du préréglage (14:22) : interprété comme mm:ss (calcul basé sur répétitions * (travail + repos))
- Confirmation de suppression d'un préréglage : pas de confirmation supplémentaire selon spec (swipe suffit)
- Limite maximale des valeurs : pas définie dans spec, implémenté avec limites raisonnables (reps max 999, time max 3599 secondes)
- Navigation vers Menu/Settings : route non définie dans spec, laissée pour implémentation future
- Écran Timer : non implémenté dans ce plan, destination de navigation seulement

---

# 12. Check Gates
- Analyzer/lint pass
- Unique keys check (all interactive widgets have keys)
- Controlled vocabulary validation (variants, placement, widthMode)
- A11y labels presence (all interactive components)
- Routes exist and compile (/home defined, /timer placeholder)
- Token usage present in theme (all colors and typography defined)
- Test coverage thresholds (State/Model: 100%, Overall: ≥80%)
- i18n completeness (all UI strings in ARB files, no hardcoded text)

---

# 13. Checklist (subset of PR_CHECKLIST)
- [x] Keys assigned on interactive widgets (all keys follow home__{compId} pattern)
- [x] Texts verbatim + transform (RÉPÉTITIONS, TRAVAIL, REPOS uppercase via transform)
- [x] Variants/placement/widthMode valid (cta|ghost|secondary, start|center|end, fill|hug)
- [x] Actions wired to state methods (all 15 actions mapped)
- [x] Golden-ready (stable layout, deterministic rendering)
- [x] Test generation plan complete (all State methods and interactive components listed)
- [x] Icon-4 excluded from build (orphan thumb per validation_report.md flag)
- [x] ValueControl pattern identified and reused (3 instances: reps, work, rest)
- [x] i18n plan complete (24 text keys extracted, ARB files defined)

