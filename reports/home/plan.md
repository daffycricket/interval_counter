---
# Deterministic Build Plan — IntervalTimerHome

# YAML front matter for machine-readability
screenName: IntervalTimerHome
screenId: interval_timer_home
designSnapshotRef: 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png
planVersion: 2
generatedAt: 2025-10-12T00:00:00Z
generator: spec2plan
language: fr
inputsHash: edf30b66815ca811ddec68a3dd383cc78e5e4641ecfe0c7261d22e683a3eeef2
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
| inputsHash       | edf30b66815ca811ddec68a3dd383cc78e5e4641ecfe0c7261d22e683a3eeef2 |

---

# 2. Files to Generate
## 2.1 Widgets
| widgetName | filePath | purpose (fr court) | components (compIds) | notes |
|------------|----------|-------------------|---------------------|-------|
| IntervalTimerHomeScreen | lib/screens/interval_timer_home_screen.dart | Écran principal | Tous (orchestration) | Stateful, contient state local |
| VolumeHeader | lib/widgets/home/volume_header.dart | En-tête avec contrôle volume | Container-1, IconButton-2, Slider-3, Icon-4, IconButton-5 | Icon-4 sera exclu (thumb) |
| QuickStartCard | lib/widgets/home/quick_start_card.dart | Carte configuration rapide | Card-6, Text-8, IconButton-9, ValueControls, Button-22/23 | Utilise ValueControl (existant) |
| PresetCard | lib/widgets/home/preset_card.dart | Carte préréglage | Card-28, Text-30/31/32/33/34 | Tapable, charge préréglage |

## 2.2 State
| filePath | pattern | exposes (fields/actions) | persistence | notes |
|----------|---------|-------------------------|-------------|-------|
| lib/state/interval_timer_home_state.dart | ChangeNotifier | reps, workSeconds, restSeconds, volume, quickStartExpanded, presets; incrementReps, decrementReps, incrementWorkTime, decrementWorkTime, incrementRestTime, decrementRestTime, updateVolume, saveQuickStartAsPreset, loadPreset, toggleQuickStartSection | SharedPreferences | Gère état de l'écran home |
| lib/state/presets_state.dart | ChangeNotifier | presets, presetsEditMode; addPreset, deletePreset, loadPresets, savePresets, enterEditMode, exitEditMode | SharedPreferences (JSON) | Gère les préréglages |

## 2.3 Routes
| routeName | filePath | params | created/uses | notes |
|-----------|----------|--------|-------------|-------|
| / | lib/routes/app_routes.dart | — | uses | Route racine vers IntervalTimerHomeScreen |
| /timer | lib/routes/app_routes.dart | {reps, workSeconds, restSeconds, volume} | uses | Vers TimerRunningScreen (hors scope) |
| /preset-editor | lib/routes/app_routes.dart | {mode, presetId?} | uses | Vers PresetEditorScreen (hors scope) |

## 2.4 Themes/Tokens
| tokenType | name | required | notes |
|-----------|------|----------|-------|
| color | primary | yes | #607D8B |
| color | onPrimary | yes | #FFFFFF |
| color | cta | yes | #607D8B |
| color | accent | yes | #FFC107 |
| color | background | yes | #F2F2F2 |
| color | surface | yes | #FFFFFF |
| color | textPrimary | yes | #212121 |
| color | textSecondary | yes | #616161 |
| color | divider | yes | #E0E0E0 |
| color | border | yes | #DDDDDD |
| color | headerBackgroundDark | yes | #455A64 |
| color | presetCardBg | yes | #FAFAFA |
| color | sliderActive | yes | #FFFFFF |
| color | sliderInactive | yes | #90A4AE |
| color | sliderThumb | yes | #FFFFFF |
| typo | titleLarge | yes | 22px, bold, h=1.4 |
| typo | title | yes | 22px, bold, h=1.25 |
| typo | label | yes | 14px, medium, h=1.33 |
| typo | body | yes | 14px, regular |
| typo | value | yes | 24px, bold |

## 2.5 Tests (to be generated in steps 05/06)
| testId | type (widget/golden/unit) | filePath | purpose | notes |
|--------|---------------------------|----------|---------|-------|
| T1 | widget | test/widgets/home/increment_reps_test.dart | Incrémenter répétitions | Tap IconButton-13 → reps++ |
| T2 | widget | test/widgets/home/decrement_reps_test.dart | Décrémenter répétitions | Tap IconButton-11 → reps-- |
| T3 | widget | test/widgets/home/min_reps_test.dart | Limite min répétitions | reps=1, tap IconButton-11 → reste 1 |
| T4 | widget | test/widgets/home/start_button_test.dart | Bouton commencer | Tap Button-23 → navigation |
| T5 | widget | test/widgets/home/save_preset_test.dart | Sauvegarder préréglage | Tap Button-22 → dialog |
| T6 | widget | test/widgets/home/load_preset_test.dart | Charger préréglage | Tap Card-28 → charge valeurs |
| T7 | widget | test/widgets/home/volume_slider_test.dart | Slider volume | Drag Slider-3 → volume update |
| T8 | golden | test/widgets/home/golden_initial_test.dart | Snapshot initial | Capture état initial |
| T9 | golden | test/widgets/home/golden_empty_presets_test.dart | Snapshot empty state | presets = [] |
| T10 | unit | test/state/min_reps_unit_test.dart | Validation min reps | decrementReps() à min |
| T11 | unit | test/state/max_reps_unit_test.dart | Validation max reps | incrementReps() à max |
| T12 | unit | test/state/min_work_unit_test.dart | Validation min work | decrementWorkTime() à min |
| T13 | unit | test/state/total_duration_test.dart | Calcul durée totale | 20 reps, 40s work, 3s rest |

---

# 3. Existing components to reuse
| componentName | filePath | purpose of reuse (fr court) | components (compIds) | notes |
|---------------|----------|----------------------------|---------------------|-------|
| ValueControl | lib/widgets/value_control.dart | Contrôle incr/décr avec valeur | IconButton-11/13 + Text-12 (reps), IconButton-15/17 + Text-16 (work), IconButton-19/21 + Text-20 (rest) | Existant, ne pas regénérer |

# 4. Widget Breakdown (from design.json + UI Mapping Guide)
| compId | type | variant | key | widgetName | filePath | buildStrategy (mapping rule id) | notes |
|--------|------|---------|-----|------------|----------|--------------------------------|-------|
| Container-1 | Container | — | interval_timer_home__container_1 | VolumeHeader | lib/widgets/home/volume_header.dart | rule:group/alignment, rule:group/distribution | Row, alignment=center, distribution=between |
| IconButton-2 | IconButton | ghost | interval_timer_home__icon_button_2 | VolumeHeader | lib/widgets/home/volume_header.dart | rule:button/ghost, rule:icon/resolve | material.volume_up |
| Slider-3 | Slider | — | interval_timer_home__slider_3 | VolumeHeader | lib/widgets/home/volume_header.dart | rule:slider/theme, rule:slider/normalizeSiblings | valueNormalized=0.62 |
| Icon-4 | Icon | — | — | — | — | rule:slider/normalizeSiblings(drop) | Thumb-like sibling, exclu du build |
| IconButton-5 | IconButton | ghost | interval_timer_home__icon_button_5 | VolumeHeader | lib/widgets/home/volume_header.dart | rule:button/ghost, rule:icon/resolve | material.more_vert |
| Card-6 | Card | — | interval_timer_home__card_6 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:card/style | elevation=0, radius=2, margin=6, padding=12 |
| Container-7 | Container | — | interval_timer_home__container_7 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:group/alignment, rule:group/distribution | Row header, distribution=between |
| Text-8 | Text | — | interval_timer_home__text_8 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:text/transform, rule:font/size | "Démarrage rapide", titleLarge |
| IconButton-9 | IconButton | ghost | interval_timer_home__icon_button_9 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:button/ghost, rule:icon/resolve | material.expand_less, toggle |
| Text-10 | Text | — | interval_timer_home__text_10 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:text/transform, rule:font/size | "RÉPÉTITIONS", label, uppercase |
| IconButton-11 | IconButton | ghost | interval_timer_home__icon_button_11 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Décrémenter reps |
| Text-12 | Text | — | interval_timer_home__text_12 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Valeur reps |
| IconButton-13 | IconButton | ghost | interval_timer_home__icon_button_13 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Incrémenter reps |
| Text-14 | Text | — | interval_timer_home__text_14 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:text/transform, rule:font/size | "TRAVAIL", label, uppercase |
| IconButton-15 | IconButton | ghost | interval_timer_home__icon_button_15 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Décrémenter workSeconds |
| Text-16 | Text | — | interval_timer_home__text_16 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Valeur workSeconds |
| IconButton-17 | IconButton | ghost | interval_timer_home__icon_button_17 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Incrémenter workSeconds |
| Text-18 | Text | — | interval_timer_home__text_18 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:text/transform, rule:font/size | "REPOS", label, uppercase |
| IconButton-19 | IconButton | ghost | interval_timer_home__icon_button_19 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Décrémenter restSeconds |
| Text-20 | Text | — | interval_timer_home__text_20 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Valeur restSeconds |
| IconButton-21 | IconButton | ghost | interval_timer_home__icon_button_21 | ValueControl | lib/widgets/value_control.dart | rule:pattern/valueControl | Incrémenter restSeconds |
| Button-22 | Button | ghost | interval_timer_home__button_22 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:button/ghost, rule:layout/widthMode, rule:layout/placement | "SAUVEGARDER", leadingIcon=save, placement=end, widthMode=hug |
| Button-23 | Button | cta | interval_timer_home__button_23 | QuickStartCard | lib/widgets/home/quick_start_card.dart | rule:button/cta, rule:layout/widthMode, rule:layout/placement | "COMMENCER", leadingIcon=bolt, placement=start, widthMode=fill |
| Container-24 | Container | — | interval_timer_home__container_24 | IntervalTimerHomeScreen | lib/screens/interval_timer_home_screen.dart | rule:group/alignment, rule:group/distribution | Row header préréglages, distribution=between |
| Text-25 | Text | — | interval_timer_home__text_25 | IntervalTimerHomeScreen | lib/screens/interval_timer_home_screen.dart | rule:text/transform, rule:font/size | "VOS PRÉRÉGLAGES", title, uppercase |
| IconButton-26 | IconButton | ghost | interval_timer_home__icon_button_26 | IntervalTimerHomeScreen | lib/screens/interval_timer_home_screen.dart | rule:button/ghost, rule:icon/resolve | material.edit |
| Button-27 | Button | secondary | interval_timer_home__button_27 | IntervalTimerHomeScreen | lib/screens/interval_timer_home_screen.dart | rule:button/secondary, rule:layout/widthMode, rule:layout/placement | "+ AJOUTER", leadingIcon=add, placement=end, widthMode=hug |
| Card-28 | Card | — | interval_timer_home__card_28 | PresetCard | lib/widgets/home/preset_card.dart | rule:card/style | Tapable avec InkWell |
| Container-29 | Container | — | interval_timer_home__container_29 | PresetCard | lib/widgets/home/preset_card.dart | rule:group/alignment, rule:group/distribution | Row header préréglage |
| Text-30 | Text | — | interval_timer_home__text_30 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform, rule:font/size | Nom préréglage, title |
| Text-31 | Text | — | interval_timer_home__text_31 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform, rule:font/size | Durée totale |
| Text-32 | Text | — | interval_timer_home__text_32 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform, rule:font/size | Détail répétitions |
| Text-33 | Text | — | interval_timer_home__text_33 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform, rule:font/size | Détail travail |
| Text-34 | Text | — | interval_timer_home__text_34 | PresetCard | lib/widgets/home/preset_card.dart | rule:text/transform, rule:font/size | Détail repos |

---

# 5. Layout Composition (design.json is authoritative)
## 5.1 Hierarchy
- root: Scaffold
  - appBar: — (none, volume header is in body)
  - body: SafeArea → SingleChildScrollView → Column
    - VolumeHeader (Container-1)
    - SizedBox(height: 8) // gap
    - QuickStartCard (Card-6)
    - SizedBox(height: 8) // gap
    - Container-24 (header préréglages)
    - ListView.builder (presets) → PresetCard per item

## 5.2 Constraints & Placement
| container | child (widgetName) | flex | alignment (placement) | widthMode | spacing | scrollable |
|-----------|-------------------|------|----------------------|-----------|---------|------------|
| Scaffold.body | SafeArea | — | stretch | fill | — | false |
| SafeArea | SingleChildScrollView | — | stretch | fill | — | true |
| SingleChildScrollView | Column | — | stretch | fill | 8 | false |
| Column | VolumeHeader | — | center | fill | — | false |
| Column | QuickStartCard | — | stretch | fill | — | false |
| Column | Container-24 | — | stretch | fill | — | false |
| Column | ListView.builder | 1 | stretch | fill | — | true (shrinkWrap) |

---

# 6. Interaction Wiring (from spec)
| compId | actionName | stateImpact | navigation | a11y (ariaLabel) | notes |
|--------|------------|-------------|-----------|------------------|-------|
| IconButton-2 | toggleVolumeControl | volumeControlVisible (hors scope) | — | "Régler le volume" | Optionnel, peut être no-op |
| Slider-3 | updateVolume | volume | — | "Curseur de volume" | onChanged callback |
| IconButton-5 | showOptionsMenu | — | Menu contextuel | "Plus d'options" | showMenu/showModalBottomSheet |
| IconButton-9 | toggleQuickStartSection | quickStartExpanded | — | "Replier la section Démarrage rapide" | Toggle expand/collapse |
| IconButton-11 | decrementReps | reps-- | — | "Diminuer les répétitions" | Min 1 |
| IconButton-13 | incrementReps | reps++ | — | "Augmenter les répétitions" | Max 99 |
| IconButton-15 | decrementWorkTime | workSeconds -= step | — | "Diminuer le temps de travail" | Min 1, step=5 |
| IconButton-17 | incrementWorkTime | workSeconds += step | — | "Augmenter le temps de travail" | Max 3599, step=5 |
| IconButton-19 | decrementRestTime | restSeconds -= step | — | "Diminuer le temps de repos" | Min 0, step=5 |
| IconButton-21 | incrementRestTime | restSeconds += step | — | "Augmenter le temps de repos" | Max 3599, step=5 |
| Button-22 | saveQuickStartAsPreset | presets (add) | — | "Sauvegarder le préréglage rapide" | Show dialog for name |
| Button-23 | startInterval | — | /timer | "Démarrer l'intervalle" | Navigator.push avec params |
| IconButton-26 | enterEditMode | presetsEditMode | — | "Éditer les préréglages" | Toggle edit mode |
| Button-27 | createNewPreset | — | /preset-editor | "Ajouter un préréglage" | Navigator.push |
| Card-28 | loadPreset | reps, workSeconds, restSeconds | — | "Charger préréglage {name}" | onTap on InkWell |

---

# 7. State Model & Actions (from spec §6)
## 7.1 Fields
| key | type | default | persistence | notes |
|-----|------|---------|-------------|-------|
| reps | int | 16 | SharedPreferences | Min 1, Max 99 |
| workSeconds | int | 44 | SharedPreferences | Min 1, Max 3599 |
| restSeconds | int | 15 | SharedPreferences | Min 0, Max 3599 |
| volume | double | 0.62 | SharedPreferences | [0.0-1.0] |
| quickStartExpanded | bool | true | non | Toggle section |
| presets | List<Preset> | [] | SharedPreferences (JSON) | Liste préréglages |
| presetsEditMode | bool | false | non | Mode édition |

## 7.2 Actions
| name | input | output | errors | description |
|------|-------|--------|--------|-------------|
| incrementReps | — | void | — | reps = min(reps + 1, 99) |
| decrementReps | — | void | — | reps = max(reps - 1, 1) |
| incrementWorkTime | — | void | — | workSeconds = min(workSeconds + 5, 3599) |
| decrementWorkTime | — | void | — | workSeconds = max(workSeconds - 5, 1) |
| incrementRestTime | — | void | — | restSeconds = min(restSeconds + 5, 3599) |
| decrementRestTime | — | void | — | restSeconds = max(restSeconds - 5, 0) |
| updateVolume | double value | void | — | volume = value, persist |
| saveQuickStartAsPreset | String name | void | StorageError | Crée Preset, ajoute, persiste |
| loadPreset | String presetId | void | — | Charge reps/workSeconds/restSeconds |
| toggleQuickStartSection | — | void | — | quickStartExpanded = !quickStartExpanded |
| enterEditMode | — | void | — | presetsEditMode = true |
| startInterval | — | void | ValidationError | Valide, navigue vers /timer |

---

# 8. Accessibility Plan
| order | compId | role | ariaLabel | focusable | shortcut | notes |
|------:|--------|------|-----------|-----------|----------|-------|
| 1 | IconButton-2 | button | "Régler le volume" | true | — | — |
| 2 | Slider-3 | slider | "Curseur de volume" | true | — | — |
| 3 | IconButton-5 | button | "Plus d'options" | true | — | — |
| 4 | IconButton-9 | button | "Replier la section Démarrage rapide" | true | — | — |
| 5 | IconButton-11 | button | "Diminuer les répétitions" | true | — | ValueControl |
| 6 | Text-12 | text | — | false | — | — |
| 7 | IconButton-13 | button | "Augmenter les répétitions" | true | — | ValueControl |
| 8 | IconButton-15 | button | "Diminuer le temps de travail" | true | — | ValueControl |
| 9 | Text-16 | text | — | false | — | — |
| 10 | IconButton-17 | button | "Augmenter le temps de travail" | true | — | ValueControl |
| 11 | IconButton-19 | button | "Diminuer le temps de repos" | true | — | ValueControl |
| 12 | Text-20 | text | — | false | — | — |
| 13 | IconButton-21 | button | "Augmenter le temps de repos" | true | — | ValueControl |
| 14 | Button-22 | button | "Sauvegarder le préréglage rapide" | true | — | — |
| 15 | Button-23 | button | "Démarrer l'intervalle" | true | Enter | Action primaire |
| 16 | IconButton-26 | button | "Éditer les préréglages" | true | — | — |
| 17 | Button-27 | button | "Ajouter un préréglage" | true | — | — |
| 18+ | Card-28 | button | "Charger préréglage {name}" | true | — | Per preset |

---

# 9. Testing Plan (traceability to spec §10)
| testId | preconditions | steps (concise) | oracle (expected) | finder strategy |
|--------|---------------|-----------------|-------------------|-----------------|
| T1 | reps=16 | Tap IconButton-13 | Text-12 displays "17" | find.byKey('interval_timer_home__icon_button_13') |
| T2 | reps=16 | Tap IconButton-11 | Text-12 displays "15" | find.byKey('interval_timer_home__icon_button_11') |
| T3 | reps=1 | Tap IconButton-11 | Text-12 stays "1" | find.byKey('interval_timer_home__icon_button_11') |
| T4 | Initial state | Tap Button-23 | Navigates to /timer | find.byKey('interval_timer_home__button_23') |
| T5 | Initial state | Tap Button-22 | Dialog appears | find.byKey('interval_timer_home__button_22') |
| T6 | presets=[gainage] | Tap Card-28 | reps=20, workSeconds=40, restSeconds=3 loaded | find.byKey('interval_timer_home__card_28') |
| T7 | volume=0.62 | Drag Slider-3 to 0.8 | volume becomes 0.8 | find.byKey('interval_timer_home__slider_3') |
| T8 | Initial state | — | Golden snapshot matches | — |
| T9 | presets=[] | — | Empty state message visible | — |
| T10 | reps=1 | Call decrementReps() | reps stays 1 | Unit test |
| T11 | reps=99 | Call incrementReps() | reps stays 99 | Unit test |
| T12 | workSeconds=1 | Call decrementWorkTime() | workSeconds stays 1 | Unit test |
| T13 | 20 reps, 40s work, 3s rest | Calculate totalDuration | Returns 860 seconds | Unit test |

---

# 10. Risks / Unknowns (from spec §11.3)
- Le bouton "Plus d'options" (IconButton-5) : navigation vers paramètres ou menu contextuel ? → **Assumption**: menu contextuel (showMenu)
- Format de temps "00 : 44" avec espaces : volontaire ou erreur ? → **Keep verbatim** per contract
- Dialogue de confirmation lors du chargement d'un préréglage ? → **Assumption**: pas de confirmation (spec silent)
- Mode édition préréglages (IconButton-26) : in-place ou écran dédié ? → **Assumption**: toggle presetsEditMode in-place
- Icon-4 identifié comme thumb-like sibling du slider → **Excluded** per rule:slider/normalizeSiblings
- Valeurs min/max pour reps/work/rest : configurables ou fixes ? → **Fixed** (spec §4.1)
- Step incrément/décrément temps : 1s ou 5s ? → **Assumption**: 5s (UX standard pour minuteurs)

---

# 11. Check Gates
- Analyzer/lint pass (flutter analyze --no-fatal-infos)
- Unique keys check (tous les interactifs ont des clés stables)
- Controlled vocabulary validation (variants, placement, widthMode)
- A11y labels presence (14 éléments interactifs)
- Routes exist and compile (/timer, /preset-editor déclarées)
- Token usage present in theme (15 couleurs, 5 typos)
- ValueControl widget exists at lib/widgets/value_control.dart
- No orphan thumb rendered (Icon-4 excluded)

---

# 12. Checklist (subset of PR_CHECKLIST)
- [ ] Keys assigned on interactive widgets (14 keys)
- [ ] Texts verbatim + transform applied (13 textes)
- [ ] Variants/placement/widthMode valid (cta|primary|secondary|ghost, start|center|end|stretch, fixed|hug|fill)
- [ ] Actions wired to state methods (12 actions)
- [ ] Golden-ready (stable layout, deterministic state, no random values)
- [ ] Icon-4 excluded from build (orphan thumb)
- [ ] ValueControl reused (not regenerated)
- [ ] Card styling follows rule:card/style (elevation=0, radius=2, margin=6, padding=12)
- [ ] Slider theme applied (activeTrack, inactiveTrack, thumbColor, trackHeight)
- [ ] Accessibility labels on all interactive components
- [ ] SharedPreferences persistence for reps, workSeconds, restSeconds, volume, presets
- [ ] Min/max validation enforced (reps 1-99, workSeconds 1-3599, restSeconds 0-3599, volume 0.0-1.0)
- [ ] Navigation params passed correctly to /timer
- [ ] Empty state handled for presets list

