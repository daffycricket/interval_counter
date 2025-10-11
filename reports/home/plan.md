---
# Deterministic Build Plan — IntervalTimerHome

# YAML front matter for machine-readability
screenName: IntervalTimerHome
screenId: interval_timer_home
designSnapshotRef: 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png
planVersion: 2
generatedAt: 2025-10-11T00:00:00Z
generator: spec2plan
language: fr
inputsHash: a7f3c9d1e6b2f8a4c3d7e9f1a2b4c6d8e0f2a4b6c8d0e2f4a6b8c0d2e4f6a8b0
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
| field              | value                                                       |
|--------------------|-------------------------------------------------------------|
| screenId           | interval_timer_home                                         |
| designSnapshotRef  | 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png                    |
| inputsHash         | a7f3c9d1e6b2f8a4c3d7e9f1a2b4c6d8e0f2a4b6c8d0e2f4a6b8c0d2e4 |

---

# 2. Files to Generate
## 2.1 Widgets
| widgetName                  | filePath                                             | purpose (fr court)                    | components (compIds)                                      | notes                           |
|-----------------------------|------------------------------------------------------|---------------------------------------|-----------------------------------------------------------|---------------------------------|
| IntervalTimerHomeScreen     | lib/screens/interval_timer_home_screen.dart          | Écran principal                       | Tous                                                      | Scaffold principal              |
| VolumeHeader                | lib/widgets/home/volume_header.dart                  | En-tête avec contrôle volume          | Container-1, IconButton-2, Slider-3, IconButton-5         | Icon-4 exclu (thumb orphelin)   |
| QuickStartCard              | lib/widgets/home/quick_start_card.dart               | Carte de configuration rapide         | Card-6, Container-7...Button-23                           | —                               |
| ValueControl                | lib/widgets/value_control.dart                       | Contrôle +/- avec valeur              | IconButton-11, Text-12, IconButton-13 (réutilisable)      | Composant réutilisable          |
| PresetCard                  | lib/widgets/home/preset_card.dart                    | Carte de préréglage                   | Card-28, Container-29, Text-30...Text-34                  | —                               |

## 2.2 State
| filePath                                    | pattern            | exposes (fields/actions)                                                          | persistence | notes                         |
|---------------------------------------------|--------------------|-----------------------------------------------------------------------------------|-------------|-------------------------------|
| lib/state/interval_timer_home_state.dart    | ChangeNotifier     | reps, workSeconds, restSeconds, volume, quickStartExpanded; increment/decrement   | SharedPrefs | État de l'écran home          |
| lib/state/presets_state.dart                | ChangeNotifier     | presets; savePreset, loadPreset, deletePreset                                     | SharedPrefs | Gestion des préréglages       |

## 2.3 Routes
| routeName         | filePath                       | params                            | created/uses | notes                           |
|-------------------|--------------------------------|-----------------------------------|--------------|---------------------------------|
| /home             | lib/routes/app_routes.dart     | —                                 | uses         | Route par défaut                |
| /timer            | lib/routes/app_routes.dart     | reps, workSeconds, restSeconds    | uses         | Navigation vers Timer           |
| /preset_editor    | lib/routes/app_routes.dart     | mode, presetId (optional)         | uses         | Navigation vers éditeur         |

## 2.4 Themes/Tokens
| tokenType | name                  | required | notes                                    |
|-----------|-----------------------|----------|------------------------------------------|
| color     | primary               | yes      | #607D8B                                  |
| color     | onPrimary             | yes      | #FFFFFF                                  |
| color     | background            | yes      | #F2F2F2                                  |
| color     | surface               | yes      | #FFFFFF                                  |
| color     | textPrimary           | yes      | #212121                                  |
| color     | textSecondary         | yes      | #616161                                  |
| color     | divider               | yes      | #E0E0E0                                  |
| color     | accent                | yes      | #FFC107                                  |
| color     | border                | yes      | #DDDDDD                                  |
| color     | cta                   | yes      | #607D8B                                  |
| color     | headerBackgroundDark  | yes      | #455A64                                  |
| color     | presetCardBg          | yes      | #FAFAFA                                  |
| color     | sliderActive          | yes      | #FFFFFF                                  |
| color     | sliderInactive        | yes      | #90A4AE                                  |
| color     | sliderThumb           | yes      | #FFFFFF                                  |
| typo      | titleLarge            | yes      | fontSize 20, bold                        |
| typo      | title                 | yes      | fontSize 16-20, bold                     |
| typo      | label                 | yes      | fontSize 12-14, medium                   |
| typo      | body                  | yes      | fontSize 14, regular                     |
| typo      | value                 | yes      | fontSize 16-24, bold/medium              |

## 2.5 Tests (to be generated in steps 05/06)
| testId | type (widget/golden/unit) | filePath                                      | purpose                                  | notes |
|--------|---------------------------|-----------------------------------------------|------------------------------------------|-------|
| T1     | widget                    | test/widgets/home/t1_increment_reps_test.dart | Incrémenter répétitions                  | —     |
| T2     | widget                    | test/widgets/home/t2_decrement_reps_test.dart | Décrémenter répétitions                  | —     |
| T3     | widget                    | test/widgets/home/t3_reps_min_test.dart       | Limite min répétitions                   | —     |
| T4     | widget                    | test/widgets/home/t4_increment_work_test.dart | Incrémenter temps travail                | —     |
| T5     | widget                    | test/widgets/home/t5_decrement_work_test.dart | Décrémenter temps travail                | —     |
| T6     | widget                    | test/widgets/home/t6_increment_rest_test.dart | Incrémenter temps repos                  | —     |
| T7     | widget                    | test/widgets/home/t7_decrement_rest_test.dart | Décrémenter temps repos                  | —     |
| T8     | widget                    | test/widgets/home/t8_rest_min_test.dart       | Limite min repos                         | —     |
| T9     | widget                    | test/widgets/home/t9_volume_slider_test.dart  | Curseur de volume                        | —     |
| T10    | widget                    | test/widgets/home/t10_start_button_test.dart  | Bouton COMMENCER                         | —     |
| T11    | widget                    | test/widgets/home/t11_save_preset_test.dart   | Sauvegarder préréglage                   | —     |
| T12    | widget                    | test/widgets/home/t12_load_preset_test.dart   | Charger préréglage                       | —     |
| T13    | widget                    | test/widgets/home/t13_toggle_section_test.dart| Replier/déplier section                  | —     |
| T14    | golden                    | test/golden/home_test.dart                    | Snapshot visuel                          | —     |
| T15    | unit                      | test/unit/home/t15_calculate_duration_test.dart| Calcul durée totale                     | —     |
| T16    | unit                      | test/unit/home/t16_calculate_duration2_test.dart| Calcul durée totale (cas 2)            | —     |
| T17    | widget                    | test/widgets/home/t17_add_preset_button_test.dart| Bouton + AJOUTER                      | —     |
| T18    | widget                    | test/widgets/home/t18_edit_mode_test.dart     | Mode édition préréglages                 | —     |

---

# 3. Existing components to reuse
| componentName | filePath                         | purpose of reuse (fr court)     | components (compIds) | notes                                 |
|---------------|----------------------------------|---------------------------------|----------------------|---------------------------------------|
| ValueControl  | lib/widgets/value_control.dart   | Contrôle +/- réutilisable       | multiple             | Existe déjà, à réutiliser 3 fois     |

---

# 4. Widget Breakdown (from design.json + UI Mapping Guide)
| compId        | type       | variant     | key                                  | widgetName              | filePath                                   | buildStrategy (mapping rule id)     | notes                                     |
|---------------|------------|-------------|--------------------------------------|-------------------------|--------------------------------------------|------------------------------------|-------------------------------------------|
| Container-1   | Container  | —           | interval_timer_home__Container-1     | VolumeHeader            | lib/widgets/home/volume_header.dart        | rule:container/flex-row            | En-tête avec background dark              |
| IconButton-2  | IconButton | ghost       | interval_timer_home__IconButton-2    | IconButton              | (inline dans VolumeHeader)                 | rule:iconbutton/ghost              | Icône volume_up                           |
| Slider-3      | Slider     | —           | interval_timer_home__Slider-3        | Slider                  | (inline dans VolumeHeader)                 | rule:slider/material               | valueNormalized=0.62                      |
| Icon-4        | Icon       | —           | —                                    | —                       | —                                          | rule:slider/normalizeSiblings(drop)| **EXCLU** (thumb-like sibling near slider)|
| IconButton-5  | IconButton | ghost       | interval_timer_home__IconButton-5    | IconButton              | (inline dans VolumeHeader)                 | rule:iconbutton/ghost              | Icône more_vert                           |
| Card-6        | Card       | —           | interval_timer_home__Card-6          | QuickStartCard          | lib/widgets/home/quick_start_card.dart     | rule:card/elevated                 | Carte principale Démarrage rapide         |
| Container-7   | Container  | —           | interval_timer_home__Container-7     | Row                     | (inline dans QuickStartCard)               | rule:container/flex-row            | En-tête de la carte                       |
| Text-8        | Text       | —           | interval_timer_home__Text-8          | Text                    | (inline dans QuickStartCard)               | rule:text/title                    | "Démarrage rapide"                        |
| IconButton-9  | IconButton | ghost       | interval_timer_home__IconButton-9    | IconButton              | (inline dans QuickStartCard)               | rule:iconbutton/ghost              | expand_less/expand_more toggle            |
| Text-10       | Text       | —           | interval_timer_home__Text-10         | Text                    | (inline dans ValueControl)                 | rule:text/label                    | "RÉPÉTITIONS"                             |
| IconButton-11 | IconButton | ghost       | interval_timer_home__IconButton-11   | IconButton              | (inline dans ValueControl)                 | rule:iconbutton/ghost              | remove (décrémenter)                      |
| Text-12       | Text       | —           | interval_timer_home__Text-12         | Text                    | (inline dans ValueControl)                 | rule:text/value                    | Valeur dynamique (16)                     |
| IconButton-13 | IconButton | ghost       | interval_timer_home__IconButton-13   | IconButton              | (inline dans ValueControl)                 | rule:iconbutton/ghost              | add (incrémenter)                         |
| Text-14       | Text       | —           | interval_timer_home__Text-14         | Text                    | (inline dans ValueControl)                 | rule:text/label                    | "TRAVAIL"                                 |
| IconButton-15 | IconButton | ghost       | interval_timer_home__IconButton-15   | IconButton              | (inline dans ValueControl)                 | rule:iconbutton/ghost              | remove (décrémenter work)                 |
| Text-16       | Text       | —           | interval_timer_home__Text-16         | Text                    | (inline dans ValueControl)                 | rule:text/value                    | Valeur dynamique (00 : 44)                |
| IconButton-17 | IconButton | ghost       | interval_timer_home__IconButton-17   | IconButton              | (inline dans ValueControl)                 | rule:iconbutton/ghost              | add (incrémenter work)                    |
| Text-18       | Text       | —           | interval_timer_home__Text-18         | Text                    | (inline dans ValueControl)                 | rule:text/label                    | "REPOS"                                   |
| IconButton-19 | IconButton | ghost       | interval_timer_home__IconButton-19   | IconButton              | (inline dans ValueControl)                 | rule:iconbutton/ghost              | remove (décrémenter rest)                 |
| Text-20       | Text       | —           | interval_timer_home__Text-20         | Text                    | (inline dans ValueControl)                 | rule:text/value                    | Valeur dynamique (00 : 15)                |
| IconButton-21 | IconButton | ghost       | interval_timer_home__IconButton-21   | IconButton              | (inline dans ValueControl)                 | rule:iconbutton/ghost              | add (incrémenter rest)                    |
| Button-22     | Button     | ghost       | interval_timer_home__Button-22       | TextButton              | (inline dans QuickStartCard)               | rule:button/ghost-with-icon        | leadingIcon save, placement=end           |
| Button-23     | Button     | cta         | interval_timer_home__Button-23       | ElevatedButton          | (inline dans QuickStartCard)               | rule:button/cta-with-icon          | leadingIcon bolt, widthMode=fill          |
| Container-24  | Container  | —           | interval_timer_home__Container-24    | Row                     | (inline dans Screen)                       | rule:container/flex-row            | Barre de titre préréglages                |
| Text-25       | Text       | —           | interval_timer_home__Text-25         | Text                    | (inline dans Screen)                       | rule:text/title                    | "VOS PRÉRÉGLAGES"                         |
| IconButton-26 | IconButton | ghost       | interval_timer_home__IconButton-26   | IconButton              | (inline dans Screen)                       | rule:iconbutton/ghost              | edit                                      |
| Button-27     | Button     | secondary   | interval_timer_home__Button-27       | OutlinedButton          | (inline dans Screen)                       | rule:button/secondary-with-icon    | leadingIcon add, placement=end            |
| Card-28       | Card       | —           | interval_timer_home__Card-28         | PresetCard              | lib/widgets/home/preset_card.dart          | rule:card/elevated                 | Carte de préréglage                       |
| Container-29  | Container  | —           | interval_timer_home__Container-29    | Row                     | (inline dans PresetCard)                   | rule:container/flex-row            | En-tête de la carte preset                |
| Text-30       | Text       | —           | interval_timer_home__Text-30         | Text                    | (inline dans PresetCard)                   | rule:text/title                    | Nom du préréglage                         |
| Text-31       | Text       | —           | interval_timer_home__Text-31         | Text                    | (inline dans PresetCard)                   | rule:text/value                    | Durée totale                              |
| Text-32       | Text       | —           | interval_timer_home__Text-32         | Text                    | (inline dans PresetCard)                   | rule:text/body                     | "RÉPÉTITIONS 20x"                         |
| Text-33       | Text       | —           | interval_timer_home__Text-33         | Text                    | (inline dans PresetCard)                   | rule:text/body                     | "TRAVAIL 00:40"                           |
| Text-34       | Text       | —           | interval_timer_home__Text-34         | Text                    | (inline dans PresetCard)                   | rule:text/body                     | "REPOS 00:03"                             |

---

# 5. Layout Composition (design.json is authoritative)
## 5.1 Hierarchy
- root: Scaffold
  - appBar: —
  - backgroundColor: background
  - body: SafeArea → SingleChildScrollView → Column
    - VolumeHeader (Container-1)
    - SizedBox(height: 8)
    - QuickStartCard (Card-6)
    - SizedBox(height: 18)
    - Container-24 (barre titre préréglages)
    - SizedBox(height: 10)
    - PresetCard (Card-28) [dynamique, ListView.builder]

## 5.2 Constraints & Placement
| container       | child (widgetName)  | flex | alignment (placement) | widthMode | spacing | scrollable |
|-----------------|---------------------|------|-----------------------|-----------|---------|------------|
| body Column     | VolumeHeader        | —    | stretch               | fill      | —       | false      |
| body Column     | QuickStartCard      | —    | stretch               | fill      | —       | false      |
| body Column     | Container-24        | —    | stretch               | fill      | —       | false      |
| body Column     | PresetCard(s)       | —    | stretch               | fill      | —       | false      |
| VolumeHeader    | IconButton-2        | —    | start                 | hug       | 8       | false      |
| VolumeHeader    | Slider-3            | 1    | center                | fill      | 8       | false      |
| VolumeHeader    | IconButton-5        | —    | end                   | hug       | —       | false      |
| QuickStartCard  | Content Column      | —    | stretch               | fill      | 16      | false      |
| Container-7     | Text-8              | 1    | start                 | hug       | —       | false      |
| Container-7     | IconButton-9        | —    | end                   | hug       | —       | false      |
| Container-24    | Text-25             | 1    | start                 | hug       | —       | false      |
| Container-24    | IconButton-26       | —    | center                | hug       | —       | false      |
| Container-24    | Button-27           | —    | end                   | hug       | —       | false      |

---

# 6. Interaction Wiring (from spec)
| compId        | actionName              | stateImpact                  | navigation        | a11y (ariaLabel)                        | notes                          |
|---------------|-------------------------|------------------------------|-------------------|-----------------------------------------|--------------------------------|
| IconButton-2  | toggleVolumeControls    | showVolumeSlider             | —                 | Régler le volume                        | —                              |
| Slider-3      | onVolumeChanged         | volume                       | —                 | Curseur de volume                       | —                              |
| IconButton-5  | showOptionsMenu         | —                            | /options          | Plus d'options                          | —                              |
| IconButton-9  | toggleQuickStartSection | quickStartExpanded           | —                 | Replier la section Démarrage rapide     | Change icône expand_less/more  |
| IconButton-11 | decrementReps           | reps                         | —                 | Diminuer les répétitions                | Min=1                          |
| IconButton-13 | incrementReps           | reps                         | —                 | Augmenter les répétitions               | Max=999                        |
| IconButton-15 | decrementWorkTime       | workSeconds                  | —                 | Diminuer le temps de travail            | Min=1                          |
| IconButton-17 | incrementWorkTime       | workSeconds                  | —                 | Augmenter le temps de travail           | Max=3600                       |
| IconButton-19 | decrementRestTime       | restSeconds                  | —                 | Diminuer le temps de repos              | Min=0                          |
| IconButton-21 | incrementRestTime       | restSeconds                  | —                 | Augmenter le temps de repos             | Max=3600                       |
| Button-22     | saveCurrentConfig       | presets                      | —                 | Sauvegarder le préréglage rapide        | Ouvre dialogue de nom          |
| Button-23     | startTimer              | —                            | /timer            | Démarrer l'intervalle                   | Params: reps, work, rest       |
| IconButton-26 | enterEditMode           | presetsEditMode              | —                 | Éditer les préréglages                  | —                              |
| Button-27     | createNewPreset         | —                            | /preset_editor    | Ajouter un préréglage                   | Mode création                  |
| Card-28       | loadPreset              | reps, workSeconds, restSeconds| —                | —                                       | Charge config du preset        |

---

# 7. State Model & Actions (from spec §6)
## 7.1 Fields
| key                  | type          | default | persistence | notes                                      |
|----------------------|---------------|---------|-------------|--------------------------------------------|
| reps                 | int           | 16      | SharedPrefs | Nombre de répétitions                      |
| workSeconds          | int           | 44      | SharedPrefs | Temps de travail en secondes               |
| restSeconds          | int           | 15      | SharedPrefs | Temps de repos en secondes                 |
| volume               | double        | 0.62    | SharedPrefs | Volume normalisé [0.0-1.0]                 |
| quickStartExpanded   | bool          | true    | SharedPrefs | État de dépli de la section                |
| showVolumeSlider     | bool          | true    | non         | Affichage du slider de volume              |
| presetsEditMode      | bool          | false   | non         | Mode édition des préréglages               |
| presets              | List<Preset>  | []      | SharedPrefs | Liste des préréglages sauvegardés          |

## 7.2 Actions
| name                     | input              | output | errors          | description                                       |
|--------------------------|-------------------|--------|-----------------|---------------------------------------------------|
| incrementReps            | —                 | —      | max reached     | Incrémente reps de 1 (max 999)                    |
| decrementReps            | —                 | —      | min reached     | Décrémente reps de 1 (min 1)                      |
| incrementWorkTime        | —                 | —      | max reached     | Incrémente workSeconds de 1 (max 3600)            |
| decrementWorkTime        | —                 | —      | min reached     | Décrémente workSeconds de 1 (min 1)               |
| incrementRestTime        | —                 | —      | max reached     | Incrémente restSeconds de 1 (max 3600)            |
| decrementRestTime        | —                 | —      | min reached     | Décrémente restSeconds de 1 (min 0)               |
| onVolumeChanged          | double value      | —      | —               | Met à jour le volume et persiste                  |
| saveCurrentConfig        | —                 | Preset | storage error   | Crée un nouveau préréglage                        |
| startTimer               | —                 | —      | validation      | Valide les paramètres et navigue vers Timer       |
| loadPreset               | String presetId   | —      | not found       | Charge un préréglage                              |
| toggleQuickStartSection  | —                 | —      | —               | Inverse quickStartExpanded                        |
| createNewPreset          | —                 | —      | —               | Navigue vers Editor en mode création              |
| enterEditMode            | —                 | —      | —               | Active presetsEditMode                            |

---

# 8. Accessibility Plan
| order | compId        | role        | ariaLabel                                | focusable | shortcut | notes                           |
|------:|---------------|-------------|------------------------------------------|-----------|----------|---------------------------------|
| 1     | IconButton-2  | button      | Régler le volume                         | true      | —        | —                               |
| 2     | Slider-3      | slider      | Curseur de volume                        | true      | ←/→      | Ajustable au clavier            |
| 3     | IconButton-5  | button      | Plus d'options                           | true      | —        | —                               |
| 4     | IconButton-9  | button      | Replier la section Démarrage rapide      | true      | —        | État expand/collapse annoncé    |
| 5     | IconButton-11 | button      | Diminuer les répétitions                 | true      | —        | Annonce la nouvelle valeur      |
| 6     | IconButton-13 | button      | Augmenter les répétitions                | true      | —        | Annonce la nouvelle valeur      |
| 7     | IconButton-15 | button      | Diminuer le temps de travail             | true      | —        | Annonce la nouvelle valeur      |
| 8     | IconButton-17 | button      | Augmenter le temps de travail            | true      | —        | Annonce la nouvelle valeur      |
| 9     | IconButton-19 | button      | Diminuer le temps de repos               | true      | —        | Annonce la nouvelle valeur      |
| 10    | IconButton-21 | button      | Augmenter le temps de repos              | true      | —        | Annonce la nouvelle valeur      |
| 11    | Button-22     | button      | Sauvegarder le préréglage rapide         | true      | —        | —                               |
| 12    | Button-23     | button      | Démarrer l'intervalle                    | true      | Enter    | Focus principal, CTA            |
| 13    | IconButton-26 | button      | Éditer les préréglages                   | true      | —        | —                               |
| 14    | Button-27     | button      | Ajouter un préréglage                    | true      | —        | —                               |
| 15    | Card-28       | button      | —                                        | true      | —        | Carte cliquable, rôle button    |

---

# 9. Testing Plan (traceability to spec §10)
| testId | preconditions          | steps (concise)                        | oracle (expected)                                          | finder strategy |
|--------|------------------------|----------------------------------------|------------------------------------------------------------|-----------------|
| T1     | reps=16                | tap IconButton-13                      | Text-12 affiche "17"                                       | find.byKey      |
| T2     | reps=16                | tap IconButton-11                      | Text-12 affiche "15"                                       | find.byKey      |
| T3     | reps=1                 | tap IconButton-11                      | Text-12 reste à "1" (min atteint)                          | find.byKey      |
| T4     | workSeconds=44         | tap IconButton-17                      | Text-16 affiche "00 : 45"                                  | find.byKey      |
| T5     | workSeconds=44         | tap IconButton-15                      | Text-16 affiche "00 : 43"                                  | find.byKey      |
| T6     | restSeconds=15         | tap IconButton-21                      | Text-20 affiche "00 : 16"                                  | find.byKey      |
| T7     | restSeconds=15         | tap IconButton-19                      | Text-20 affiche "00 : 14"                                  | find.byKey      |
| T8     | restSeconds=0          | tap IconButton-19                      | Text-20 reste à "00 : 00" (min atteint)                    | find.byKey      |
| T9     | volume=0.5             | drag Slider-3 to 0.8                   | volume state = 0.8                                         | find.byKey      |
| T10    | config valide          | tap Button-23                          | navigation vers /timer avec params corrects                | find.byKey      |
| T11    | —                      | tap Button-22                          | dialogue de nom de préréglage s'affiche                    | find.byKey      |
| T12    | preset "gainage" existe| tap Card-28                            | reps=20, workSeconds=40, restSeconds=3 chargés             | find.byKey      |
| T13    | quickStartExpanded=true| tap IconButton-9                       | Card-6 se replie, iconName devient expand_more             | find.byKey      |
| T14    | état initial           | —                                      | snapshot correspond à home_design.json                     | golden          |
| T15    | reps=16, work=44, rest=15| calculateTotalDuration()             | retourne 944 secondes (15:44)                              | unit test       |
| T16    | reps=20, work=40, rest=3 | calculateTotalDuration()             | retourne 860 secondes (14:20)                              | unit test       |
| T17    | —                      | tap Button-27                          | navigation vers /preset_editor en mode création            | find.byKey      |
| T18    | —                      | tap IconButton-26                      | presetsEditMode=true, checkboxes d'édition s'affichent    | find.byKey      |

---

# 10. Risks / Unknowns (from spec §11.3)
- Aucun

---

# 11. Check Gates
- Analyzer/lint pass
- Unique keys check
- Controlled vocabulary validation
- A11y labels presence (Semantics widgets)
- Routes exist and compile
- Token usage present in theme
- Icon-4 excluded from widget tree (thumb-like sibling)

---

# 12. Checklist (subset of PR_CHECKLIST)
- [ ] Keys assigned on interactive widgets (format: interval_timer_home__{compId})
- [ ] Texts verbatim + transform (uppercase pour labels)
- [ ] Variants/placement/widthMode valid (contrôlés)
- [ ] Actions wired to state methods (via Provider/ChangeNotifier)
- [ ] Golden-ready (stable layout, no randoms)
- [ ] Icon-4 explicitly excluded from build (orphan thumb)
- [ ] Slider-3 uses default Flutter Slider thumb (no custom thumb widget)
- [ ] SharedPreferences persistence implemented for reps, workSeconds, restSeconds, volume, quickStartExpanded
- [ ] Navigation routes implemented (/timer, /preset_editor)
- [ ] Preset model defined with serialization/deserialization
- [ ] ValueControl widget reusable (accepts label, value, callbacks)
- [ ] A11y: Semantics labels on all interactive widgets
- [ ] A11y: Semantic announcement on value changes
- [ ] Theme tokens defined and used consistently
- [ ] No hardcoded colors or typography (use theme tokens)

