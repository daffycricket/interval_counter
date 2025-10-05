---
# Deterministic Build Plan — IntervalTimerHome

# YAML front matter for machine-readability
screenName: IntervalTimerHome
screenId: interval_timer_home
designSnapshotRef: 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png
planVersion: 2
generatedAt: 2025-10-05T00:00:00Z
generator: spec2plan
language: fr
inputsHash: sha256_placeholder_for_design_and_spec
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
| field            | value                                         |
|------------------|-----------------------------------------------|
| screenId         | interval_timer_home                           |
| designSnapshotRef| 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png      |
| inputsHash       | sha256_placeholder_for_design_and_spec        |

---

# 2. Files to Generate
## 2.1 Widgets
| widgetName                 | filePath                                           | purpose (fr court)                    | components (compIds)                                | notes                                           |
|----------------------------|----------------------------------------------------|---------------------------------------|-----------------------------------------------------|------------------------------------------------|
| IntervalTimerHomeScreen    | lib/screens/interval_timer_home_screen.dart        | Écran principal                       | ALL                                                 | Main screen widget (StatefulWidget)             |
| QuickStartCard             | lib/widgets/home/quick_start_card.dart             | Carte de démarrage rapide             | Card-6,Container-7,Text-8,IconButton-9,ValueControl*3,Button-22,Button-23 | Contient les 3 ValueControls + boutons         |
| PresetCard                 | lib/widgets/home/preset_card.dart                  | Carte de préréglage                   | Card-28,Container-29,Text-30,Text-31,Text-32,Text-33,Text-34 | Widget réutilisable pour chaque préréglage     |
| VolumeHeader               | lib/widgets/home/volume_header.dart                | En-tête avec volume                   | Container-1,IconButton-2,Slider-3,IconButton-5      | Exclut Icon-4 (thumb orphelin)                  |

## 2.2 State
| filePath                                       | pattern            | exposes (fields/actions)                                                                          | persistence | notes                                           |
|------------------------------------------------|--------------------|---------------------------------------------------------------------------------------------------|-------------|-------------------------------------------------|
| lib/state/interval_timer_home_state.dart       | ChangeNotifier     | repetitions,workSeconds,restSeconds,volumeLevel,quickStartExpanded;incrementReps,decrementReps,incrementWork,decrementWork,incrementRest,decrementRest,setVolume,toggleQuickStartSection,saveQuickStartPreset,startInterval,selectPreset | oui (SharedPrefs) | État principal de l'écran                      |
| lib/state/presets_state.dart                   | ChangeNotifier     | presets;loadPresets,createPreset,deletePreset,updatePreset                                        | oui (SharedPrefs) | Gestion des préréglages                        |

## 2.3 Routes
| routeName              | filePath                       | params                        | created/uses | notes                                           |
|------------------------|--------------------------------|-------------------------------|--------------|------------------------------------------------|
| /                      | lib/routes/app_routes.dart     | —                             | uses         | Route par défaut vers IntervalTimerHomeScreen   |
| /timer                 | lib/routes/app_routes.dart     | {reps,work,rest}              | uses         | Navigation vers TimerScreen                     |
| /preset-editor         | lib/routes/app_routes.dart     | {mode,presetId?}              | uses         | Navigation vers PresetEditor                    |

## 2.4 Themes/Tokens
| tokenType | name                | required | notes                                           |
|-----------|---------------------|----------|------------------------------------------------|
| color     | primary             | yes      | #607D8B                                         |
| color     | onPrimary           | yes      | #FFFFFF                                         |
| color     | background          | yes      | #F2F2F2                                         |
| color     | surface             | yes      | #FFFFFF                                         |
| color     | textPrimary         | yes      | #212121                                         |
| color     | textSecondary       | yes      | #616161                                         |
| color     | divider             | yes      | #E0E0E0                                         |
| color     | accent              | yes      | #FFC107                                         |
| color     | sliderActive        | yes      | #FFFFFF                                         |
| color     | sliderInactive      | yes      | #90A4AE                                         |
| color     | sliderThumb         | yes      | #FFFFFF                                         |
| color     | border              | yes      | #DDDDDD                                         |
| color     | cta                 | yes      | #607D8B                                         |
| color     | headerBackgroundDark| yes      | #455A64                                         |
| color     | presetCardBg        | yes      | #FAFAFA                                         |
| typo      | titleLarge          | yes      | size:20, weight:bold, height:28                 |
| typo      | label               | yes      | size:12, weight:medium, height:16, uppercase    |
| typo      | value               | yes      | size:24, weight:bold, height:28                 |
| typo      | title               | yes      | size:16/20, weight:bold, height:20/28           |
| typo      | body                | yes      | size:14, weight:regular, height:20              |

## 2.5 Tests (to be generated in steps 05/06)
| testId | type (widget/golden/unit) | filePath                                              | purpose                                          | notes                                           |
|-------|---------------------------|-------------------------------------------------------|--------------------------------------------------|-------------------------------------------------|
| T1    | widget                    | test/widgets/home/t1_increment_reps_test.dart         | Tester incrémentation répétitions                | tap IconButton-13, vérifier Text-12             |
| T2    | widget                    | test/widgets/home/t2_decrement_reps_test.dart         | Tester décrémentation répétitions                | tap IconButton-11, vérifier Text-12             |
| T3    | widget                    | test/widgets/home/t3_min_reps_boundary_test.dart      | Tester limite min répétitions                    | reps=1, tap decrement, vérifier disabled        |
| T4    | widget                    | test/widgets/home/t4_start_interval_test.dart         | Tester démarrage intervalle                      | tap Button-23, vérifier navigation              |
| T5    | widget                    | test/widgets/home/t5_select_preset_test.dart          | Tester sélection préréglage                      | tap Card-28, vérifier chargement valeurs        |
| T6    | widget                    | test/widgets/home/t6_save_preset_test.dart            | Tester sauvegarde préréglage                     | tap Button-22, vérifier création + snackbar     |
| T7    | widget                    | test/widgets/home/t7_volume_slider_test.dart          | Tester slider de volume                          | drag Slider-3, vérifier volumeLevel             |
| T8    | widget                    | test/widgets/home/t8_toggle_quick_start_test.dart     | Tester repliement section rapide                 | tap IconButton-9, vérifier collapse             |
| T9    | golden                    | test/golden/home/t9_full_screen_golden_test.dart      | Test golden complet de l'écran                   | snapshot conforme au design                     |
| T10   | unit                      | test/unit/home/t10_calculate_duration_test.dart       | Tester calcul durée totale                       | reps*sum(work,rest)                             |
| T11   | widget                    | test/widgets/home/t11_add_preset_button_test.dart     | Tester bouton ajouter préréglage                 | tap Button-27, vérifier navigation              |
| T12   | widget                    | test/widgets/home/t12_min_work_boundary_test.dart     | Tester limite min temps travail                  | work=1, tap decrement, vérifier disabled        |
| T13   | a11y                      | test/a11y/home/t13_start_button_enter_test.dart       | Tester Enter sur bouton COMMENCER                | focus Button-23, press Enter, vérifier action   |
| T14   | widget                    | test/widgets/home/t14_menu_button_test.dart           | Tester bouton menu                               | tap IconButton-5, vérifier menu                 |

---

# 3. Existing components to reuse
| componentName        | filePath                         | purpose of reuse (fr court)                    | components (compIds)                   | notes                                           |
|----------------------|----------------------------------|------------------------------------------------|----------------------------------------|-------------------------------------------------|
| ValueControl         | lib/widgets/value_control.dart   | Contrôle de valeur avec +/- et label           | IconButton-11,Text-12,IconButton-13 (x3 patterns) | Pattern détecté 3 fois (RÉPÉTITIONS, TRAVAIL, REPOS) |

# 4. Widget Breakdown (from design.json + UI Mapping Guide)
| compId        | type       | variant   | key                                    | widgetName                 | filePath                                           | buildStrategy (mapping rule id)      | notes                                           |
|---------------|------------|-----------|----------------------------------------|----------------------------|----------------------------------------------------|--------------------------------------|-------------------------------------------------|
| Container-1   | Container  | —         | interval_timer_home__Container-1       | VolumeHeader               | lib/widgets/home/volume_header.dart                | rule:group/alignment                 | Header container, flex row                      |
| IconButton-2  | IconButton | ghost     | interval_timer_home__IconButton-2      | VolumeHeader               | lib/widgets/home/volume_header.dart                | rule:button/ghost + rule:iconButton/shaped | volume_up icon                                  |
| Slider-3      | Slider     | —         | interval_timer_home__Slider-3          | VolumeHeader               | lib/widgets/home/volume_header.dart                | rule:slider/theme                    | Volume slider, valueNormalized=0.62             |
| Icon-4        | Icon       | —         | —                                      | —                          | —                                                  | rule:slider/normalizeSiblings(drop)  | Thumb-like sibling, EXCLUDED from build         |
| IconButton-5  | IconButton | ghost     | interval_timer_home__IconButton-5      | VolumeHeader               | lib/widgets/home/volume_header.dart                | rule:button/ghost + rule:iconButton/shaped | more_vert icon                                  |
| Card-6        | Card       | —         | interval_timer_home__Card-6            | QuickStartCard             | lib/widgets/home/quick_start_card.dart             | rule:group/alignment                 | Main card container                             |
| Container-7   | Container  | —         | interval_timer_home__Container-7       | QuickStartCard             | lib/widgets/home/quick_start_card.dart             | rule:group/alignment                 | Header row inside card                          |
| Text-8        | Text       | —         | —                                      | QuickStartCard             | lib/widgets/home/quick_start_card.dart             | rule:text/transform                  | "Démarrage rapide"                              |
| IconButton-9  | IconButton | ghost     | interval_timer_home__IconButton-9      | QuickStartCard             | lib/widgets/home/quick_start_card.dart             | rule:button/ghost + rule:iconButton/shaped | expand_less icon, toggle collapse               |
| Text-10       | Text       | —         | —                                      | QuickStartCard             | lib/widgets/home/quick_start_card.dart             | rule:text/transform                  | "RÉPÉTITIONS" label                             |
| IconButton-11 | IconButton | ghost     | interval_timer_home__IconButton-11     | ValueControl (reps)        | lib/widgets/value_control.dart                     | rule:pattern/valueControl            | Part of RÉPÉTITIONS ValueControl                |
| Text-12       | Text       | —         | interval_timer_home__Text-12           | ValueControl (reps)        | lib/widgets/value_control.dart                     | rule:pattern/valueControl            | Value "16" for RÉPÉTITIONS                      |
| IconButton-13 | IconButton | ghost     | interval_timer_home__IconButton-13     | ValueControl (reps)        | lib/widgets/value_control.dart                     | rule:pattern/valueControl            | Part of RÉPÉTITIONS ValueControl                |
| Text-14       | Text       | —         | —                                      | QuickStartCard             | lib/widgets/home/quick_start_card.dart             | rule:text/transform                  | "TRAVAIL" label                                 |
| IconButton-15 | IconButton | ghost     | interval_timer_home__IconButton-15     | ValueControl (work)        | lib/widgets/value_control.dart                     | rule:pattern/valueControl            | Part of TRAVAIL ValueControl                    |
| Text-16       | Text       | —         | interval_timer_home__Text-16           | ValueControl (work)        | lib/widgets/value_control.dart                     | rule:pattern/valueControl            | Value "00 : 44" for TRAVAIL                     |
| IconButton-17 | IconButton | ghost     | interval_timer_home__IconButton-17     | ValueControl (work)        | lib/widgets/value_control.dart                     | rule:pattern/valueControl            | Part of TRAVAIL ValueControl                    |
| Text-18       | Text       | —         | —                                      | QuickStartCard             | lib/widgets/home/quick_start_card.dart             | rule:text/transform                  | "REPOS" label                                   |
| IconButton-19 | IconButton | ghost     | interval_timer_home__IconButton-19     | ValueControl (rest)        | lib/widgets/value_control.dart                     | rule:pattern/valueControl            | Part of REPOS ValueControl                      |
| Text-20       | Text       | —         | interval_timer_home__Text-20           | ValueControl (rest)        | lib/widgets/value_control.dart                     | rule:pattern/valueControl            | Value "00 : 15" for REPOS                       |
| IconButton-21 | IconButton | ghost     | interval_timer_home__IconButton-21     | ValueControl (rest)        | lib/widgets/value_control.dart                     | rule:pattern/valueControl            | Part of REPOS ValueControl                      |
| Button-22     | Button     | ghost     | interval_timer_home__Button-22         | QuickStartCard             | lib/widgets/home/quick_start_card.dart             | rule:button/ghost + rule:layout/placement | "SAUVEGARDER", placement=end, widthMode=hug     |
| Button-23     | Button     | cta       | interval_timer_home__Button-23         | QuickStartCard             | lib/widgets/home/quick_start_card.dart             | rule:button/cta + rule:layout/widthMode | "COMMENCER", widthMode=fill, with leadingIcon   |
| Container-24  | Container  | —         | interval_timer_home__Container-24      | IntervalTimerHomeScreen    | lib/screens/interval_timer_home_screen.dart        | rule:group/alignment                 | Presets section header row                      |
| Text-25       | Text       | —         | —                                      | IntervalTimerHomeScreen    | lib/screens/interval_timer_home_screen.dart        | rule:text/transform                  | "VOS PRÉRÉGLAGES"                               |
| IconButton-26 | IconButton | ghost     | interval_timer_home__IconButton-26     | IntervalTimerHomeScreen    | lib/screens/interval_timer_home_screen.dart        | rule:button/ghost + rule:iconButton/shaped | edit icon                                       |
| Button-27     | Button     | secondary | interval_timer_home__Button-27         | IntervalTimerHomeScreen    | lib/screens/interval_timer_home_screen.dart        | rule:button/secondary + rule:layout/placement | "+ AJOUTER", placement=end, widthMode=hug       |
| Card-28       | Card       | —         | interval_timer_home__Card-28           | PresetCard                 | lib/widgets/home/preset_card.dart                  | rule:group/alignment                 | Preset card container                           |
| Container-29  | Container  | —         | interval_timer_home__Container-29      | PresetCard                 | lib/widgets/home/preset_card.dart                  | rule:group/alignment                 | Preset header row                               |
| Text-30       | Text       | —         | —                                      | PresetCard                 | lib/widgets/home/preset_card.dart                  | rule:text/transform                  | "gainage" - preset name                         |
| Text-31       | Text       | —         | —                                      | PresetCard                 | lib/widgets/home/preset_card.dart                  | rule:text/transform                  | "14:22" - total duration                        |
| Text-32       | Text       | —         | —                                      | PresetCard                 | lib/widgets/home/preset_card.dart                  | rule:text/transform                  | "RÉPÉTITIONS 20x"                               |
| Text-33       | Text       | —         | —                                      | PresetCard                 | lib/widgets/home/preset_card.dart                  | rule:text/transform                  | "TRAVAIL 00:40"                                 |
| Text-34       | Text       | —         | —                                      | PresetCard                 | lib/widgets/home/preset_card.dart                  | rule:text/transform                  | "REPOS 00:03"                                   |

---

# 5. Layout Composition (design.json is authoritative)
## 5.1 Hierarchy
```
IntervalTimerHomeScreen (Scaffold)
├── body: SafeArea → Column(scrollable: true)
    ├── VolumeHeader (Container-1)
    │   ├── IconButton-2 (volume_up)
    │   ├── Expanded → Slider-3
    │   └── IconButton-5 (more_vert)
    │   [Icon-4 EXCLUDED - thumb orphan]
    ├── Padding(vertical: 8)
    ├── QuickStartCard (Card-6)
    │   ├── Column
    │       ├── Container-7 (header row)
    │       │   ├── Text-8 ("Démarrage rapide")
    │       │   └── IconButton-9 (expand_less)
    │       ├── SizedBox(height: 16)
    │       ├── ValueControl(label: "RÉPÉTITIONS", value: "16", ...)
    │       ├── SizedBox(height: 16)
    │       ├── ValueControl(label: "TRAVAIL", value: "00 : 44", ...)
    │       ├── SizedBox(height: 16)
    │       ├── ValueControl(label: "REPOS", value: "00 : 15", ...)
    │       ├── SizedBox(height: 16)
    │       ├── Align(alignment: end) → Button-22 ("SAUVEGARDER")
    │       ├── SizedBox(height: 16)
    │       └── Button-23 ("COMMENCER", fill width)
    ├── SizedBox(height: 16)
    ├── Container-24 (presets header row)
    │   ├── Text-25 ("VOS PRÉRÉGLAGES")
    │   ├── IconButton-26 (edit)
    │   └── Button-27 ("+ AJOUTER")
    └── ListView.builder (presets)
        └── PresetCard(preset: each) × N
            ├── Container-29 (header row)
            │   ├── Text-30 (name)
            │   └── Text-31 (duration)
            ├── Text-32 (reps)
            ├── Text-33 (work)
            └── Text-34 (rest)
```

## 5.2 Constraints & Placement
| container                | child (widgetName)    | flex | alignment (placement) | widthMode | spacing | scrollable |
|--------------------------|-----------------------|------|-----------------------|-----------|---------|------------|
| IntervalTimerHomeScreen  | VolumeHeader          | —    | stretch               | fill      | 0       | false      |
| IntervalTimerHomeScreen  | QuickStartCard        | —    | stretch               | fill      | 16      | false      |
| IntervalTimerHomeScreen  | Container-24          | —    | stretch               | fill      | 16      | false      |
| IntervalTimerHomeScreen  | ListView              | 1    | stretch               | fill      | 8       | true       |
| VolumeHeader             | IconButton-2          | —    | center                | hug       | 8       | false      |
| VolumeHeader             | Slider-3              | 1    | center                | fill      | 0       | false      |
| VolumeHeader             | IconButton-5          | —    | center                | hug       | 8       | false      |
| QuickStartCard           | ValueControl (reps)   | —    | stretch               | fill      | 16      | false      |
| QuickStartCard           | ValueControl (work)   | —    | stretch               | fill      | 16      | false      |
| QuickStartCard           | ValueControl (rest)   | —    | stretch               | fill      | 16      | false      |
| QuickStartCard           | Button-22             | —    | end                   | hug       | 16      | false      |
| QuickStartCard           | Button-23             | —    | stretch               | fill      | 16      | false      |

---

# 6. Interaction Wiring (from spec)
| compId        | actionName                    | stateImpact                      | navigation | a11y (ariaLabel)                         | notes                                           |
|---------------|-------------------------------|----------------------------------|------------|------------------------------------------|-------------------------------------------------|
| IconButton-2  | toggleVolumeSettings          | showVolumeSlider=toggle          | —          | Régler le volume                         | —                                               |
| Slider-3      | setVolume                     | volumeLevel=value                | —          | Curseur de volume                        | —                                               |
| IconButton-5  | openMenu                      | —                                | Menu       | Plus d'options                           | —                                               |
| IconButton-9  | toggleQuickStartSection       | quickStartExpanded=toggle        | —          | Replier la section Démarrage rapide      | —                                               |
| IconButton-11 | decrementReps                 | repetitions-=1                   | —          | Diminuer les répétitions                 | min=1                                           |
| IconButton-13 | incrementReps                 | repetitions+=1                   | —          | Augmenter les répétitions                | max=999                                         |
| IconButton-15 | decrementWork                 | workSeconds-=1                   | —          | Diminuer le temps de travail             | min=1                                           |
| IconButton-17 | incrementWork                 | workSeconds+=1                   | —          | Augmenter le temps de travail            | max=3599                                        |
| IconButton-19 | decrementRest                 | restSeconds-=1                   | —          | Diminuer le temps de repos               | min=0                                           |
| IconButton-21 | incrementRest                 | restSeconds+=1                   | —          | Augmenter le temps de repos              | max=3599                                        |
| Button-22     | saveQuickStartPreset          | presets+=[current]               | —          | Sauvegarder le préréglage rapide         | Show snackbar confirmation                      |
| Button-23     | startInterval                 | —                                | →Timer     | Démarrer l'intervalle                    | Pass {reps,work,rest} params                    |
| IconButton-26 | enterEditMode                 | editMode=true                    | —          | Éditer les préréglages                   | —                                               |
| Button-27     | createNewPreset               | —                                | →Editor    | Ajouter un préréglage                    | mode=create                                     |
| Card-28       | selectPreset                  | load preset→(reps,work,rest)     | —          | —                                        | Tap gesture, load preset values                 |

---

# 7. State Model & Actions (from spec §6)
## 7.1 Fields
| key                  | type           | default | persistence | notes                                           |
|----------------------|----------------|---------|-------------|-------------------------------------------------|
| repetitions          | int            | 16      | oui         | min=1, max=999                                  |
| workSeconds          | int            | 44      | oui         | min=1, max=3599                                 |
| restSeconds          | int            | 15      | oui         | min=0, max=3599                                 |
| volumeLevel          | double         | 0.62    | oui         | [0.0-1.0]                                       |
| quickStartExpanded   | bool           | true    | oui         | toggle card visibility                          |
| editMode             | bool           | false   | non         | presets edit mode                               |
| presets              | List<Preset>   | []      | oui         | stored as JSON in SharedPrefs                   |

## 7.2 Actions
| name                    | input          | output | errors               | description                                     |
|-------------------------|----------------|--------|----------------------|-------------------------------------------------|
| incrementReps           | —              | —      | max_reached          | repetitions++, max 999                          |
| decrementReps           | —              | —      | min_reached          | repetitions--, min 1                            |
| incrementWork           | —              | —      | max_reached          | workSeconds++, max 3599                         |
| decrementWork           | —              | —      | min_reached          | workSeconds--, min 1                            |
| incrementRest           | —              | —      | max_reached          | restSeconds++, max 3599                         |
| decrementRest           | —              | —      | min_reached          | restSeconds--, min 0                            |
| setVolume               | double value   | —      | —                    | volumeLevel=value                               |
| toggleQuickStartSection | —              | —      | —                    | quickStartExpanded=!quickStartExpanded          |
| saveQuickStartPreset    | —              | Preset | save_failed          | Add current config to presets, save to prefs    |
| startInterval           | —              | —      | invalid_config       | Navigate to /timer with {reps,work,rest}        |
| selectPreset            | String id      | —      | preset_not_found     | Load preset into current config                 |
| createNewPreset         | —              | —      | —                    | Navigate to /preset-editor?mode=create          |
| enterEditMode           | —              | —      | —                    | editMode=true                                   |
| openMenu                | —              | —      | —                    | Show menu (not implemented in this screen)      |

---

# 8. Accessibility Plan
| order | compId        | role        | ariaLabel                                | focusable | shortcut | notes                                           |
|------:|---------------|-------------|------------------------------------------|-----------|----------|-------------------------------------------------|
| 1     | IconButton-2  | button      | Régler le volume                         | true      | —        | —                                               |
| 2     | Slider-3      | slider      | Curseur de volume                        | true      | ←→       | keyboard arrows                                 |
| 3     | IconButton-5  | button      | Plus d'options                           | true      | —        | —                                               |
| 4     | IconButton-9  | button      | Replier la section Démarrage rapide      | true      | —        | —                                               |
| 5     | IconButton-11 | button      | Diminuer les répétitions                 | true      | —        | —                                               |
| 6     | Text-12       | text        | —                                        | false     | —        | Announced by screenreader                       |
| 7     | IconButton-13 | button      | Augmenter les répétitions                | true      | —        | —                                               |
| 8     | IconButton-15 | button      | Diminuer le temps de travail             | true      | —        | —                                               |
| 9     | Text-16       | text        | —                                        | false     | —        | Announced by screenreader                       |
| 10    | IconButton-17 | button      | Augmenter le temps de travail            | true      | —        | —                                               |
| 11    | IconButton-19 | button      | Diminuer le temps de repos               | true      | —        | —                                               |
| 12    | Text-20       | text        | —                                        | false     | —        | Announced by screenreader                       |
| 13    | IconButton-21 | button      | Augmenter le temps de repos              | true      | —        | —                                               |
| 14    | Button-22     | button      | Sauvegarder le préréglage rapide         | true      | —        | —                                               |
| 15    | Button-23     | button      | Démarrer l'intervalle                    | true      | Enter    | Primary action                                  |
| 16    | IconButton-26 | button      | Éditer les préréglages                   | true      | —        | —                                               |
| 17    | Button-27     | button      | Ajouter un préréglage                    | true      | —        | —                                               |

---

# 9. Testing Plan (traceability to spec §10)
| testId | preconditions                   | steps (concise)                             | oracle (expected)                                                 | finder strategy              |
|-------|----------------------------------|---------------------------------------------|-------------------------------------------------------------------|------------------------------|
| T1    | reps=16                          | tap IconButton-13                           | Text-12 displays "17"                                             | find.byKey                   |
| T2    | reps=16                          | tap IconButton-11                           | Text-12 displays "15"                                             | find.byKey                   |
| T3    | reps=1                           | tap IconButton-11                           | reps stays 1, IconButton-11 disabled                              | find.byKey                   |
| T4    | default state                    | tap Button-23                               | Navigate to /timer with {reps:16,work:44,rest:15}                 | find.byKey + verify route    |
| T5    | preset "gainage" loaded          | tap Card-28                                 | Values loaded: reps=20, work=40, rest=3                           | find.byKey                   |
| T6    | modified config                  | tap Button-22                               | New preset created, snackbar shown                                | find.byKey + find.text       |
| T7    | default state                    | drag Slider-3 to 0.8                        | volumeLevel=0.8, slider visual updated                            | find.byKey                   |
| T8    | quickStartExpanded=true          | tap IconButton-9                            | Section collapsed, icon changes to expand_more                    | find.byKey                   |
| T9    | default state                    | render full screen                          | Golden snapshot matches design.json                               | matchesGoldenFile            |
| T10   | reps=16,work=44,rest=15          | call calculateTotalDuration()               | returns 944 seconds (15:44)                                       | unit test                    |
| T11   | default state                    | tap Button-27                               | Navigate to /preset-editor?mode=create                            | find.byKey + verify route    |
| T12   | work=1                           | tap IconButton-15                           | work stays 1, IconButton-15 disabled                              | find.byKey                   |
| T13   | Button-23 focused                | press Enter key                             | startInterval() called, navigate to /timer                        | a11y test                    |
| T14   | default state                    | tap IconButton-5                            | Menu displayed                                                    | find.byKey                   |

---

# 10. Risks / Unknowns (from spec §11.3)
- **Question**: Quel est le comportement exact du tap sur IconButton-2 (volume) ? → Assume: toggle visibility du slider (or do nothing)
- **Question**: Y a-t-il une limite au nombre de préréglages ? → Assume: pas de limite pour v1
- **Question**: Le menu IconButton-5 donne accès à quelles fonctionnalités ? → Assume: menu générique (non implémenté dans ce screen)
- **Question**: Le préréglage "gainage" est-il par défaut ? → Assume: exemple de préréglage existant

---

# 11. Check Gates
- [ ] Analyzer/lint pass (zero errors/warnings)
- [ ] Unique keys check (all interactive widgets have stable keys)
- [ ] Controlled vocabulary validation (variants, placement, widthMode)
- [ ] A11y labels presence (all interactive widgets have semanticLabel)
- [ ] Routes exist and compile (/timer, /preset-editor routes defined)
- [ ] Token usage present in theme (all 15 color tokens + 5 typo tokens defined)
- [ ] Icon-4 excluded from build (thumb orphan)
- [ ] ValueControl widget reused 3 times (RÉPÉTITIONS, TRAVAIL, REPOS)
- [ ] All texts verbatim from design.json

---

# 12. Checklist (subset of PR_CHECKLIST)
- [ ] Keys assigned on interactive widgets (14 interactive components keyed)
- [ ] Texts verbatim + transform applied (16 text nodes)
- [ ] Variants/placement/widthMode valid (all button variants: cta/ghost/secondary)
- [ ] Actions wired to state methods (12 actions defined)
- [ ] Golden-ready (stable layout, no randoms, deterministic rendering)