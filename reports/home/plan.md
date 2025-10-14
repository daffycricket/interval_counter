---
# Deterministic Build Plan — IntervalTimerHome Screen

# YAML front matter for machine-readability
screenName: IntervalTimerHome
screenId: interval_timer_home
designSnapshotRef: 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png
planVersion: 2
generatedAt: 2025-10-14T00:00:00Z
generator: spec2plan
language: fr
inputsHash: sha256(design.json||spec.md)
---

# 0. Invariants & Sources
- Sources: `home_design.json` (layout/styling), `spec.md` (logic/state/navigation/a11y)
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
| inputsHash       | sha256(design.json||spec.md) |

---

# 2. Files to Generate
## 2.1 Widgets
| widgetName           | filePath                         | purpose (fr court)          | components (compIds) | notes |
|----------------------|----------------------------------|-----------------------------|----------------------|-------|
| IntervalTimerHomeScreen | lib/screens/interval_timer_home_screen.dart | Écran principal d'accueil | All components | Main screen StatefulWidget |
| VolumeHeader | lib/widgets/interval_timer_home/volume_header.dart | En-tête avec contrôle volume | Container-1, IconButton-2, Slider-3, IconButton-5 | Icon-4 excluded per slider/normalizeSiblings |
| QuickStartSection | lib/widgets/interval_timer_home/quick_start_section.dart | Section configuration rapide | Card-6, Container-7, Text-8, IconButton-9 | Collapsible card |
| ValueControl | lib/widgets/value_control.dart | Contrôle de valeur générique | Text-10 to Text-21 (3 instances) | REUSED existing widget |
| PresetCard | lib/widgets/interval_timer_home/preset_card.dart | Carte de préréglage | Card-28, Container-29, Text-30 to Text-34 | Tap to load, long-press for menu |
| PresetsSection | lib/widgets/interval_timer_home/presets_section.dart | Section liste préréglages | Container-24, Text-25, IconButton-26, Button-27 | Header with add button |

## 2.2 State
| filePath                         | pattern            | exposes (fields/actions)            | persistence | notes |
|----------------------------------|--------------------|-------------------------------------|-------------|-------|
| lib/state/interval_timer_home_state.dart | ChangeNotifier | reps, workSeconds, restSeconds, volume, volumePanelVisible, quickStartExpanded, presetsEditMode, presets; incrementReps, decrementReps, incrementWorkTime, decrementWorkTime, incrementRestTime, decrementRestTime, onVolumeChange, toggleQuickStartSection, saveCurrentAsPreset, loadPreset, startInterval, createNewPreset, enterEditMode, deletePreset | SharedPreferences | Dual constructors: create() + testable(prefs) |

## 2.3 Routes
| routeName      | filePath                       | params       | created/uses | notes |
|----------------|--------------------------------|--------------|-------------|-------|
| /home          | lib/routes/app_routes.dart     | —            | uses        | Entry screen |
| /timer_running | lib/routes/app_routes.dart     | reps, workSeconds, restSeconds | uses | Target for startInterval |
| /preset_editor | lib/routes/app_routes.dart     | mode, presetId | uses | Target for createNewPreset |

## 2.4 Themes/Tokens
| tokenType | name       | required | notes |
|----------|------------|----------|-------|
| color    | primary        | yes | #607D8B |
| color    | onPrimary      | yes | #FFFFFF |
| color    | background     | yes | #F2F2F2 |
| color    | surface        | yes | #FFFFFF |
| color    | textPrimary    | yes | #212121 |
| color    | textSecondary  | yes | #616161 |
| color    | divider        | yes | #E0E0E0 |
| color    | accent         | yes | #FFC107 |
| color    | sliderActive   | yes | #FFFFFF |
| color    | sliderInactive | yes | #90A4AE |
| color    | sliderThumb    | yes | #FFFFFF |
| color    | border         | yes | #DDDDDD |
| color    | cta            | yes | #607D8B |
| color    | headerBackgroundDark | yes | #455A64 |
| color    | presetCardBg   | yes | #FAFAFA |
| typo     | titleLarge | yes | Démarrage rapide |
| typo     | label      | yes | RÉPÉTITIONS, TRAVAIL, REPOS, buttons |
| typo     | value      | yes | 16, 00:44, 00:15, 14:22 |
| typo     | title      | yes | VOS PRÉRÉGLAGES, gainage |
| typo     | body       | yes | RÉPÉTITIONS 20x, etc. |

## 2.5 Tests (to be generated in steps 05/06)

### Widget Tests - 1:1 with § 2.1
| widgetName           | testFilePath                                | covers (components from that widget) |
|----------------------|---------------------------------------------|--------------------------------------|
| IntervalTimerHomeScreen | test/screens/interval_timer_home_screen_test.dart | All components integration |
| VolumeHeader | test/widgets/interval_timer_home/volume_header_test.dart | Container-1, IconButton-2, Slider-3, IconButton-5 |
| QuickStartSection | test/widgets/interval_timer_home/quick_start_section_test.dart | Card-6, Container-7, Text-8, IconButton-9 |
| ValueControl | test/widgets/value_control_test.dart | Text-10 to Text-21 (3 instances) |
| PresetCard | test/widgets/interval_timer_home/preset_card_test.dart | Card-28, Container-29, Text-30 to Text-34 |
| PresetsSection | test/widgets/interval_timer_home/presets_section_test.dart | Container-24, Text-25, IconButton-26, Button-27 |

**Rule:** count(rows above) == 6 widgets = count(rows in § 2.1 Widgets)

### Shared Test Helpers
| filePath                          | purpose                    |
|-----------------------------------|----------------------------|
| test/helpers/widget_test_helpers.dart | Common setup functions, mock state, pump wrappers |

---

# 3. Existing components to reuse
| componentName        | filePath                         | purpose of reuse (fr court) | components (compIds) | notes |
|----------------------|----------------------------------|-----------------------------|----------------------|-------|
| ValueControl       | lib/widgets/value_control.dart | Contrôle incrémentiel avec label, valeur, boutons +/− | Text-10+IconButton-11+Text-12+IconButton-13 (RÉPÉTITIONS), Text-14+IconButton-15+Text-16+IconButton-17 (TRAVAIL), Text-18+IconButton-19+Text-20+IconButton-21 (REPOS) | Per rule:pattern/valueControl |

---

# 4. Widget Breakdown (from design.json + UI Mapping Guide)
| compId | type   | variant | key                       | widgetName | filePath                        | buildStrategy (mapping rule id) | notes |
|--------|--------|---------|---------------------------|------------|----------------------------------|---------------------------------|-------|
| Container-1 | Container | — | interval_timer_home__Container-1 | VolumeHeader | lib/widgets/interval_timer_home/volume_header.dart | rule:group/alignment, rule:group/distribution | Row with spaceBetween, center aligned |
| IconButton-2 | IconButton | ghost | interval_timer_home__IconButton-2 | VolumeHeader | lib/widgets/interval_timer_home/volume_header.dart | rule:button/ghost, rule:iconButton/shaped | Toggle volume panel |
| Slider-3 | Slider | — | interval_timer_home__Slider-3 | VolumeHeader | lib/widgets/interval_timer_home/volume_header.dart | rule:slider/theme | activeTrack=#FFFFFF, inactiveTrack=#90A4AE, thumbColor=#FFFFFF, trackHeight=4, valueNormalized=0.62 |
| Icon-4 | Icon | — | interval_timer_home__Icon-4 | — | — | rule:slider/normalizeSiblings(drop) | EXCLUDED: slider thumb sibling, material.circle, color=#FFFFFF |
| IconButton-5 | IconButton | ghost | interval_timer_home__IconButton-5 | VolumeHeader | lib/widgets/interval_timer_home/volume_header.dart | rule:button/ghost, rule:iconButton/shaped | More options menu |
| Card-6 | Card | — | interval_timer_home__Card-6 | QuickStartSection | lib/widgets/interval_timer_home/quick_start_section.dart | rule:card/style | Main quick start card, radius=lg |
| Container-7 | Container | — | interval_timer_home__Container-7 | QuickStartSection | lib/widgets/interval_timer_home/quick_start_section.dart | rule:group/alignment, rule:group/distribution | Row header with title and collapse button |
| Text-8 | Text | — | interval_timer_home__Text-8 | QuickStartSection | lib/widgets/interval_timer_home/quick_start_section.dart | rule:text/transform, rule:font/size | "Démarrage rapide", typographyRef=titleLarge |
| IconButton-9 | IconButton | ghost | interval_timer_home__IconButton-9 | QuickStartSection | lib/widgets/interval_timer_home/quick_start_section.dart | rule:button/ghost, rule:iconButton/shaped | Toggle section collapse/expand |
| Text-10 | Text | — | interval_timer_home__Text-10 | ValueControl | lib/widgets/value_control.dart | rule:text/transform, rule:pattern/valueControl | "RÉPÉTITIONS" label, transform=uppercase |
| IconButton-11 | IconButton | ghost | interval_timer_home__IconButton-11 | ValueControl | lib/widgets/value_control.dart | rule:button/ghost, rule:iconButton/shaped, rule:pattern/valueControl | Decrease reps |
| Text-12 | Text | — | interval_timer_home__Text-12 | ValueControl | lib/widgets/value_control.dart | rule:text/transform, rule:pattern/valueControl | "16" value display |
| IconButton-13 | IconButton | ghost | interval_timer_home__IconButton-13 | ValueControl | lib/widgets/value_control.dart | rule:button/ghost, rule:iconButton/shaped, rule:pattern/valueControl | Increase reps |
| Text-14 | Text | — | interval_timer_home__Text-14 | ValueControl | lib/widgets/value_control.dart | rule:text/transform, rule:pattern/valueControl | "TRAVAIL" label, transform=uppercase |
| IconButton-15 | IconButton | ghost | interval_timer_home__IconButton-15 | ValueControl | lib/widgets/value_control.dart | rule:button/ghost, rule:iconButton/shaped, rule:pattern/valueControl | Decrease work time |
| Text-16 | Text | — | interval_timer_home__Text-16 | ValueControl | lib/widgets/value_control.dart | rule:text/transform, rule:pattern/valueControl | "00 : 44" value display |
| IconButton-17 | IconButton | ghost | interval_timer_home__IconButton-17 | ValueControl | lib/widgets/value_control.dart | rule:button/ghost, rule:iconButton/shaped, rule:pattern/valueControl | Increase work time |
| Text-18 | Text | — | interval_timer_home__Text-18 | ValueControl | lib/widgets/value_control.dart | rule:text/transform, rule:pattern/valueControl | "REPOS" label, transform=uppercase |
| IconButton-19 | IconButton | ghost | interval_timer_home__IconButton-19 | ValueControl | lib/widgets/value_control.dart | rule:button/ghost, rule:iconButton/shaped, rule:pattern/valueControl | Decrease rest time |
| Text-20 | Text | — | interval_timer_home__Text-20 | ValueControl | lib/widgets/value_control.dart | rule:text/transform, rule:pattern/valueControl | "00 : 15" value display |
| IconButton-21 | IconButton | ghost | interval_timer_home__IconButton-21 | ValueControl | lib/widgets/value_control.dart | rule:button/ghost, rule:iconButton/shaped, rule:pattern/valueControl | Increase rest time |
| Button-22 | Button | ghost | interval_timer_home__Button-22 | QuickStartSection | lib/widgets/interval_timer_home/quick_start_section.dart | rule:button/ghost, rule:layout/placement | "SAUVEGARDER", placement=end, widthMode=intrinsic, leadingIcon=material.save |
| Button-23 | Button | cta | interval_timer_home__Button-23 | QuickStartSection | lib/widgets/interval_timer_home/quick_start_section.dart | rule:button/cta, rule:layout/widthMode | "COMMENCER", widthMode=fill, leadingIcon=material.bolt |
| Container-24 | Container | — | interval_timer_home__Container-24 | PresetsSection | lib/widgets/interval_timer_home/presets_section.dart | rule:group/alignment, rule:group/distribution | Row header for presets section |
| Text-25 | Text | — | interval_timer_home__Text-25 | PresetsSection | lib/widgets/interval_timer_home/presets_section.dart | rule:text/transform | "VOS PRÉRÉGLAGES", transform=uppercase |
| IconButton-26 | IconButton | ghost | interval_timer_home__IconButton-26 | PresetsSection | lib/widgets/interval_timer_home/presets_section.dart | rule:button/ghost, rule:iconButton/shaped | Enter edit mode |
| Button-27 | Button | secondary | interval_timer_home__Button-27 | PresetsSection | lib/widgets/interval_timer_home/presets_section.dart | rule:button/secondary, rule:layout/placement | "+ AJOUTER", placement=end, widthMode=intrinsic, leadingIcon=material.add |
| Card-28 | Card | — | interval_timer_home__Card-28 | PresetCard | lib/widgets/interval_timer_home/preset_card.dart | rule:card/style | Preset card, tap to load |
| Container-29 | Container | — | interval_timer_home__Container-29 | PresetCard | lib/widgets/interval_timer_home/preset_card.dart | rule:group/alignment, rule:group/distribution | Row header with name and duration |
| Text-30 | Text | — | interval_timer_home__Text-30 | PresetCard | lib/widgets/interval_timer_home/preset_card.dart | rule:text/transform | "gainage" preset name |
| Text-31 | Text | — | interval_timer_home__Text-31 | PresetCard | lib/widgets/interval_timer_home/preset_card.dart | rule:text/transform | "14:22" total duration |
| Text-32 | Text | — | interval_timer_home__Text-32 | PresetCard | lib/widgets/interval_timer_home/preset_card.dart | rule:text/transform | "RÉPÉTITIONS 20x" detail |
| Text-33 | Text | — | interval_timer_home__Text-33 | PresetCard | lib/widgets/interval_timer_home/preset_card.dart | rule:text/transform | "TRAVAIL 00:40" detail |
| Text-34 | Text | — | interval_timer_home__Text-34 | PresetCard | lib/widgets/interval_timer_home/preset_card.dart | rule:text/transform | "REPOS 00:03" detail |

---

# 5. Layout Composition (design.json is authoritative)
## 5.1 Hierarchy
- root: Column (safeArea: true, scrollable: true)
  - VolumeHeader (Container-1)
  - QuickStartSection (Card-6 with ValueControl instances and action buttons)
  - PresetsSection (Container-24 header)
  - PresetCard (Card-28, repeatable via ListView.builder for presets list)

## 5.2 Constraints & Placement
| container | child (widgetName) | flex | alignment (placement) | widthMode | spacing | scrollable |
|----------|---------------------|------|------------------------|-----------|---------|------------|
| root     | VolumeHeader        | —    | stretch                | fill      | 0       | false      |
| root     | QuickStartSection   | —    | stretch                | fill      | 16      | false      |
| root     | PresetsSection      | —    | stretch                | fill      | 16      | false      |
| root     | PresetCard (list)   | —    | stretch                | fill      | 12      | true       |
| Container-1 | IconButton-2     | —    | start                  | hug       | 12      | false      |
| Container-1 | Slider-3         | 1    | center                 | fill      | 0       | false      |
| Container-1 | IconButton-5     | —    | end                    | hug       | 0       | false      |
| Card-6   | Container-7         | —    | stretch                | fill      | 0       | false      |
| Card-6   | ValueControl (3×)   | —    | stretch                | fill      | 16      | false      |
| Card-6   | Button-22           | —    | end                    | intrinsic | 16      | false      |
| Card-6   | Button-23           | —    | stretch                | fill      | 16      | false      |
| Container-24 | Text-25         | —    | start                  | hug       | 0       | false      |
| Container-24 | IconButton-26   | —    | start                  | hug       | 12      | false      |
| Container-24 | Button-27       | —    | end                    | intrinsic | 0       | false      |

---

# 6. Interaction Wiring (from spec)
| compId | actionName   | stateImpact          | navigation | a11y (ariaLabel) | notes |
|--------|--------------|----------------------|-----------|------------------|-------|
| IconButton-2 | toggleVolumePanel | volumePanelVisible | — | Régler le volume | Toggle volume panel visibility |
| Slider-3 | onVolumeChange | volume | — | Curseur de volume | Update volume 0.0-1.0, persist |
| IconButton-5 | showContextMenu | — | Menu contextuel | Plus d'options | Context menu overlay |
| IconButton-9 | toggleQuickStartSection | quickStartExpanded | — | Replier la section Démarrage rapide | Collapse/expand Card-6 |
| IconButton-11 | decrementReps | reps (min: 1) | — | Diminuer les répétitions | reps--, persist |
| IconButton-13 | incrementReps | reps (max: 99) | — | Augmenter les répétitions | reps++, persist |
| IconButton-15 | decrementWorkTime | workSeconds (min: 5) | — | Diminuer le temps de travail | workSeconds -= 5, persist |
| IconButton-17 | incrementWorkTime | workSeconds (max: 3600) | — | Augmenter le temps de travail | workSeconds += 5, persist |
| IconButton-19 | decrementRestTime | restSeconds (min: 0) | — | Diminuer le temps de repos | restSeconds -= 5, persist |
| IconButton-21 | incrementRestTime | restSeconds (max: 3600) | — | Augmenter le temps de repos | restSeconds += 5, persist |
| Button-22 | saveCurrentAsPreset | presets | Dialogue | Sauvegarder le préréglage rapide | Show dialog, save preset |
| Button-23 | startInterval | — | /timer_running | Démarrer l'intervalle | Navigate with {reps, workSeconds, restSeconds} |
| IconButton-26 | enterEditMode | presetsEditMode | — | Éditer les préréglages | Enable edit mode |
| Button-27 | createNewPreset | — | /preset_editor | Ajouter un préréglage | Navigate with {mode: 'create'} |
| Card-28 | loadPreset | reps, workSeconds, restSeconds | — | Sélectionner préréglage gainage | Load preset into quick start |

---

# 7. State Model & Actions (from spec §6)
## 7.1 Fields
| key          | type | default | persistence | notes |
|--------------|------|---------|-------------|-------|
| reps | int | 16 | SharedPreferences (quick_start) | 1 ≤ reps ≤ 99 |
| workSeconds | int | 44 | SharedPreferences (quick_start) | 5 ≤ workSeconds ≤ 3600 |
| restSeconds | int | 15 | SharedPreferences (quick_start) | 0 ≤ restSeconds ≤ 3600 |
| volume | double | 0.62 | SharedPreferences | 0.0 ≤ volume ≤ 1.0 |
| volumePanelVisible | bool | false | non | UI state only |
| quickStartExpanded | bool | true | SharedPreferences | Section collapsed/expanded |
| presetsEditMode | bool | false | non | UI state only |
| presets | List\<Preset\> | [] | SharedPreferences (JSON) | Saved presets |

## 7.2 Actions
| name        | input | output | errors | description |
|-------------|-------|--------|--------|-------------|
| incrementReps | — | void | — | reps++, clamp to 99, notifyListeners, persist |
| decrementReps | — | void | — | reps--, clamp to 1, notifyListeners, persist |
| incrementWorkTime | — | void | — | workSeconds += 5, clamp to 3600, notifyListeners, persist |
| decrementWorkTime | — | void | — | workSeconds -= 5, clamp to 5, notifyListeners, persist |
| incrementRestTime | — | void | — | restSeconds += 5, clamp to 3600, notifyListeners, persist |
| decrementRestTime | — | void | — | restSeconds -= 5, clamp to 0, notifyListeners, persist |
| onVolumeChange | double value | void | — | volume = value, notifyListeners, persist |
| toggleQuickStartSection | — | void | — | quickStartExpanded = !quickStartExpanded, notifyListeners, persist |
| toggleVolumePanel | — | void | — | volumePanelVisible = !volumePanelVisible, notifyListeners |
| saveCurrentAsPreset | String name | Future\<void\> | StorageException | Create Preset(name, reps, work, rest), add to presets, notifyListeners, persist |
| loadPreset | String presetId | void | — | Load preset data into reps/work/rest, notifyListeners, scroll to Card-6 |
| startInterval | — | void | — | Navigate to /timer_running with {reps, workSeconds, restSeconds} |
| createNewPreset | — | void | — | Navigate to /preset_editor with {mode: 'create'} |
| enterEditMode | — | void | — | presetsEditMode = true, notifyListeners |
| deletePreset | String presetId | Future\<void\> | StorageException | Remove preset from list, notifyListeners, persist |

---

# 8. Accessibility Plan
| order | compId | role        | ariaLabel    | focusable | shortcut | notes |
|------:|--------|-------------|--------------|-----------|----------|-------|
| 1 | IconButton-2 | button | Régler le volume | true | — | Volume icon |
| 2 | Slider-3 | slider | Curseur de volume | true | Arrows | Announce value as % |
| 3 | IconButton-5 | button | Plus d'options | true | — | Context menu |
| 4 | IconButton-9 | button | Replier la section Démarrage rapide | true | — | Announce expanded/collapsed |
| 5 | IconButton-11 | button | Diminuer les répétitions | true | — | Announce value after action |
| 6 | Text-12 | text | — | false | — | Announced as "16 répétitions" |
| 7 | IconButton-13 | button | Augmenter les répétitions | true | — | Announce value after action |
| 8 | IconButton-15 | button | Diminuer le temps de travail | true | — | Announce duration after action |
| 9 | Text-16 | text | — | false | — | Announced as "44 secondes de travail" |
| 10 | IconButton-17 | button | Augmenter le temps de travail | true | — | Announce duration after action |
| 11 | IconButton-19 | button | Diminuer le temps de repos | true | — | Announce duration after action |
| 12 | Text-20 | text | — | false | — | Announced as "15 secondes de repos" |
| 13 | IconButton-21 | button | Augmenter le temps de repos | true | — | Announce duration after action |
| 14 | Button-22 | button | Sauvegarder le préréglage rapide | true | — | Save preset action |
| 15 | Button-23 | button (primary) | Démarrer l'intervalle | true | Enter | Main CTA |
| 16 | IconButton-26 | button | Éditer les préréglages | true | — | Enable edit mode |
| 17 | Button-27 | button | Ajouter un préréglage | true | — | Create new preset |
| 18 | Card-28 | button | Sélectionner préréglage gainage | true | — | Announce name + duration |

---

# 9. Testing Plan (traceability to spec §10)
| testId | preconditions | steps (concise)       | oracle (expected)                                  | finder strategy |
|-------|----------------|-----------------------|----------------------------------------------------|-----------------|
| T1 | presets empty, defaults | tap interval_timer_home__Button-23 | Navigation to TimerRunning with {reps:16, work:44, rest:15} | find.byKey |
| T2 | reps=16 | tap interval_timer_home__IconButton-13 | Text-12 displays "17" | find.byKey |
| T3 | reps=1 | tap interval_timer_home__IconButton-11 | Text-12 remains "1", SnackBar error shown | find.byKey |
| T4 | workSeconds=44 | tap interval_timer_home__IconButton-17 2× | Text-16 displays "00 : 54" | find.byKey |
| T5 | defaults | tap interval_timer_home__Button-22, enter "test" | New preset "test" appears in list | find.byKey |
| T6 | preset "gainage" exists | tap Card-28 | Text-12="20", Text-16="00 : 40", Text-20="00 : 03" | find.byKey |
| T7 | — | tap interval_timer_home__IconButton-9 | Card-6 collapses, IconButton-9 rotates 180° | find.byKey |
| T8 | volume=0.62 | drag Slider-3 to 0.8 | volume state=0.8, persisted in SharedPreferences | find.byKey |
| T9 | golden | defaults | render screen | Match snapshot |
| T10 | golden | quickStartExpanded=false | render screen | Card-6 collapsed, match snapshot |
| T11 | unit | — | incrementReps() with reps=99 | reps remains 99 |
| T12 | unit | — | decrementWorkTime() with workSeconds=5 | workSeconds remains 5 |
| T13 | integration | list empty | open app, create preset "test", tap COMMENCER | Timer starts with preset config |

---

# 10. Test Generation Plan

## 10.1 State Tests (`test/state/interval_timer_home_state_test.dart`)

| Component | Method | Test Case | Priority | Coverage Type |
|-----------|--------|-----------|----------|---------------|
| IntervalTimerHomeState | incrementReps | Should increment reps from 16 to 17 | CRITICAL | Unit |
| IntervalTimerHomeState | incrementReps | Should not exceed max (99) | CRITICAL | Boundary |
| IntervalTimerHomeState | decrementReps | Should decrement reps from 16 to 15 | CRITICAL | Unit |
| IntervalTimerHomeState | decrementReps | Should not go below min (1) | CRITICAL | Boundary |
| IntervalTimerHomeState | incrementWorkTime | Should increment by 5 seconds | CRITICAL | Unit |
| IntervalTimerHomeState | incrementWorkTime | Should not exceed max (3600) | CRITICAL | Boundary |
| IntervalTimerHomeState | decrementWorkTime | Should decrement by 5 seconds | CRITICAL | Unit |
| IntervalTimerHomeState | decrementWorkTime | Should not go below min (5) | CRITICAL | Boundary |
| IntervalTimerHomeState | incrementRestTime | Should increment by 5 seconds | CRITICAL | Unit |
| IntervalTimerHomeState | incrementRestTime | Should not exceed max (3600) | CRITICAL | Boundary |
| IntervalTimerHomeState | decrementRestTime | Should decrement by 5 seconds | CRITICAL | Unit |
| IntervalTimerHomeState | decrementRestTime | Should allow 0 (min) | CRITICAL | Boundary |
| IntervalTimerHomeState | onVolumeChange | Should update volume and persist | CRITICAL | Unit |
| IntervalTimerHomeState | onVolumeChange | Should clamp to [0.0, 1.0] | CRITICAL | Boundary |
| IntervalTimerHomeState | toggleQuickStartSection | Should toggle expanded state | HIGH | Unit |
| IntervalTimerHomeState | toggleQuickStartSection | Should persist state | HIGH | Integration |
| IntervalTimerHomeState | toggleVolumePanel | Should toggle panel visibility | HIGH | Unit |
| IntervalTimerHomeState | saveCurrentAsPreset | Should add preset to list | CRITICAL | Unit |
| IntervalTimerHomeState | saveCurrentAsPreset | Should persist preset | CRITICAL | Integration |
| IntervalTimerHomeState | saveCurrentAsPreset | Should handle storage errors | HIGH | Integration |
| IntervalTimerHomeState | loadPreset | Should load preset values into current state | CRITICAL | Unit |
| IntervalTimerHomeState | loadPreset | Should handle missing preset | HIGH | Integration |
| IntervalTimerHomeState | deletePreset | Should remove preset from list | CRITICAL | Unit |
| IntervalTimerHomeState | deletePreset | Should persist changes | CRITICAL | Integration |
| IntervalTimerHomeState | constructor | Should load defaults when no saved state | CRITICAL | Unit |
| IntervalTimerHomeState | constructor | Should load saved state from SharedPreferences | CRITICAL | Integration |
| IntervalTimerHomeState | constructor | Should validate and clamp loaded values | HIGH | Boundary |

**Coverage Target:** 100% lines, 100% branches

---

## 10.2 Widget Tests

| Widget | Component Key | Test Case | Expected Behavior |
|--------|---------------|-----------|-------------------|
| VolumeHeader | interval_timer_home__IconButton-2 | Tap volume button | toggleVolumePanel() called |
| VolumeHeader | interval_timer_home__Slider-3 | Drag slider | onVolumeChange(value) called with new value |
| VolumeHeader | interval_timer_home__IconButton-5 | Tap more options | showContextMenu() called |
| VolumeHeader | interval_timer_home__Icon-4 | Not rendered | Component excluded (slider thumb sibling) |
| QuickStartSection | interval_timer_home__Text-8 | Render | Displays "Démarrage rapide" |
| QuickStartSection | interval_timer_home__IconButton-9 | Tap collapse button | toggleQuickStartSection() called, card collapses |
| QuickStartSection | interval_timer_home__Button-22 | Tap save button | saveCurrentAsPreset() called, dialog shown |
| QuickStartSection | interval_timer_home__Button-23 | Tap start button | startInterval() called, navigation triggered |
| ValueControl | interval_timer_home__IconButton-11 | Tap decrease reps | decrementReps() called |
| ValueControl | interval_timer_home__Text-12 | Render reps | Displays current reps value |
| ValueControl | interval_timer_home__IconButton-13 | Tap increase reps | incrementReps() called |
| ValueControl | interval_timer_home__IconButton-15 | Tap decrease work | decrementWorkTime() called |
| ValueControl | interval_timer_home__Text-16 | Render work time | Displays formatted time "00 : 44" |
| ValueControl | interval_timer_home__IconButton-17 | Tap increase work | incrementWorkTime() called |
| ValueControl | interval_timer_home__IconButton-19 | Tap decrease rest | decrementRestTime() called |
| ValueControl | interval_timer_home__Text-20 | Render rest time | Displays formatted time "00 : 15" |
| ValueControl | interval_timer_home__IconButton-21 | Tap increase rest | incrementRestTime() called |
| ValueControl | interval_timer_home__Text-10 | Render label | Displays "RÉPÉTITIONS" uppercase |
| ValueControl | interval_timer_home__Text-14 | Render label | Displays "TRAVAIL" uppercase |
| ValueControl | interval_timer_home__Text-18 | Render label | Displays "REPOS" uppercase |
| PresetsSection | interval_timer_home__Text-25 | Render title | Displays "VOS PRÉRÉGLAGES" uppercase |
| PresetsSection | interval_timer_home__IconButton-26 | Tap edit button | enterEditMode() called |
| PresetsSection | interval_timer_home__Button-27 | Tap add button | createNewPreset() called, navigation triggered |
| PresetCard | interval_timer_home__Text-30 | Render preset name | Displays preset name "gainage" |
| PresetCard | interval_timer_home__Text-31 | Render duration | Displays formatted duration "14:22" |
| PresetCard | interval_timer_home__Text-32 | Render reps detail | Displays "RÉPÉTITIONS 20x" |
| PresetCard | interval_timer_home__Text-33 | Render work detail | Displays "TRAVAIL 00:40" |
| PresetCard | interval_timer_home__Text-34 | Render rest detail | Displays "REPOS 00:03" |
| PresetCard | interval_timer_home__Card-28 | Tap card | loadPreset(presetId) called |
| PresetCard | interval_timer_home__Card-28 | Long press card | Context menu shown with edit/delete |
| IntervalTimerHomeScreen | — | Golden test defaults | Screen renders matching baseline |
| IntervalTimerHomeScreen | — | Golden test collapsed | Quick start section collapsed matches baseline |
| IntervalTimerHomeScreen | — | Empty presets | Shows empty state message |
| IntervalTimerHomeScreen | — | Multiple presets | ListView renders all preset cards |

**Coverage Target:** ≥90% for generic widgets (ValueControl), ≥70% for screen-specific widgets

---

## 10.3 Accessibility Tests

| Widget | Component Key | Semantic Label | Role | State |
|--------|---------------|----------------|------|-------|
| VolumeHeader | interval_timer_home__IconButton-2 | Régler le volume | button | enabled |
| VolumeHeader | interval_timer_home__Slider-3 | Curseur de volume | slider | enabled |
| VolumeHeader | interval_timer_home__IconButton-5 | Plus d'options | button | enabled |
| QuickStartSection | interval_timer_home__IconButton-9 | Replier la section Démarrage rapide | button | enabled |
| ValueControl | interval_timer_home__IconButton-11 | Diminuer les répétitions | button | enabled/disabled (min) |
| ValueControl | interval_timer_home__IconButton-13 | Augmenter les répétitions | button | enabled/disabled (max) |
| ValueControl | interval_timer_home__IconButton-15 | Diminuer le temps de travail | button | enabled/disabled (min) |
| ValueControl | interval_timer_home__IconButton-17 | Augmenter le temps de travail | button | enabled/disabled (max) |
| ValueControl | interval_timer_home__IconButton-19 | Diminuer le temps de repos | button | enabled/disabled (min) |
| ValueControl | interval_timer_home__IconButton-21 | Augmenter le temps de repos | button | enabled/disabled (max) |
| QuickStartSection | interval_timer_home__Button-22 | Sauvegarder le préréglage rapide | button | enabled |
| QuickStartSection | interval_timer_home__Button-23 | Démarrer l'intervalle | button | enabled |
| PresetsSection | interval_timer_home__IconButton-26 | Éditer les préréglages | button | enabled |
| PresetsSection | interval_timer_home__Button-27 | Ajouter un préréglage | button | enabled |
| PresetCard | interval_timer_home__Card-28 | Sélectionner préréglage gainage | button | enabled |

---

## 10.4 Components excluded from tests

| Component | Reason        |
|-----------|---------------|
| Icon-4 (material.circle) | Slider thumb sibling, excluded per rule:slider/normalizeSiblings(drop) |

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
| Text-8 | "Démarrage rapide" | quickStartTitle | Quick start section title |
| Text-10 | "RÉPÉTITIONS" | repsLabel | Repetitions label |
| Text-14 | "TRAVAIL" | workLabel | Work time label |
| Text-18 | "REPOS" | restLabel | Rest time label |
| Button-22 | "SAUVEGARDER" | saveButton | Save preset button |
| Button-23 | "COMMENCER" | startButton | Start interval button |
| Text-25 | "VOS PRÉRÉGLAGES" | presetsTitle | Presets section title |
| Button-27 | "+ AJOUTER" | addButton | Add preset button |
| IconButton-2 | "Régler le volume" | volumeButtonLabel | Volume button a11y label |
| Slider-3 | "Curseur de volume" | volumeSliderLabel | Volume slider a11y label |
| IconButton-5 | "Plus d'options" | moreOptionsLabel | More options button a11y label |
| IconButton-9 | "Replier la section Démarrage rapide" | collapseQuickStartLabel | Collapse quick start a11y label |
| IconButton-11 | "Diminuer les répétitions" | decreaseRepsLabel | Decrease reps a11y label |
| IconButton-13 | "Augmenter les répétitions" | increaseRepsLabel | Increase reps a11y label |
| IconButton-15 | "Diminuer le temps de travail" | decreaseWorkLabel | Decrease work time a11y label |
| IconButton-17 | "Augmenter le temps de travail" | increaseWorkLabel | Increase work time a11y label |
| IconButton-19 | "Diminuer le temps de repos" | decreaseRestLabel | Decrease rest time a11y label |
| IconButton-21 | "Augmenter le temps de repos" | increaseRestLabel | Increase rest time a11y label |
| Button-22 | "Sauvegarder le préréglage rapide" | savePresetLabel | Save preset a11y label |
| Button-23 | "Démarrer l'intervalle" | startIntervalLabel | Start interval a11y label |
| IconButton-26 | "Éditer les préréglages" | editPresetsLabel | Edit presets a11y label |
| Button-27 | "Ajouter un préréglage" | addPresetLabel | Add preset a11y label |
| Card-28 | "Sélectionner préréglage {name}" | selectPresetLabel | Select preset a11y label |
| — | "Aucun préréglage sauvegardé.\nAppuyez sur + AJOUTER pour créer." | emptyPresetsMessage | Empty state message |
| — | "Préréglage sauvegardé" | presetSavedSnackbar | Success message |
| — | "Échec de la sauvegarde. Réessayez." | saveFailed | Error message |
| — | "Les répétitions doivent être entre 1 et 99" | repsValidationError | Validation error |
| — | "Le temps de travail doit être entre 00:05 et 60:00" | workTimeValidationError | Validation error |
| — | "Le temps de repos doit être entre 00:00 et 60:00" | restTimeValidationError | Validation error |
| — | "Le nom du préréglage ne peut pas être vide" | presetNameEmptyError | Validation error |
| — | "Maximum 99 répétitions" | maxRepsError | Boundary error |
| — | "Minimum 5 secondes de travail" | minWorkTimeError | Boundary error |
| — | "Impossible de charger les préréglages" | loadPresetsError | Error message |

### i18n Configuration
- File: `lib/l10n/l10n.yaml`
- Template: `app_fr.arb` (French as source language)
- Output: `app_localizations.dart`
- Generate synthetic package: true

### main.dart Setup
- Import: `import 'package:flutter_localizations/flutter_localizations.dart';`
- Import: `import 'package:interval_counter/l10n/app_localizations.dart';`
- Delegates in MaterialApp:
  - `AppLocalizations.delegate`
  - `GlobalMaterialLocalizations.delegate`
  - `GlobalWidgetsLocalizations.delegate`
  - `GlobalCupertinoLocalizations.delegate`
- Supported locales: `[const Locale('en'), const Locale('fr')]`
- Locale resolution: prefer French, fallback to English

---

# 11. Risks / Unknowns (from spec §11.3)
- Format d'affichage du temps "00 : 44" (avec espaces) vs "00:44" (sans espaces) — design montre espaces, supposé intentionnel
- Limite maximale de préréglages non spécifiée (arbitraire)
- Comportement long-press sur Card-28 supposé (menu contextuel éditer/supprimer) — non visible dans snapshot
- Icône material.circle (Icon-4) rôle exact confirmé comme indicateur visuel (slider thumb sibling) — exclu per normalization rule
- Haptic feedback intensité et pattern non spécifiés (à définir en implémentation)
- Animation collapse/expand Card-6 durée et easing non spécifiés (défaut Material Design)

---

# 12. Check Gates
- [ ] Analyzer/lint pass (flutter analyze --no-fatal-infos)
- [ ] Unique keys check (all interactive widgets keyed)
- [ ] Controlled vocabulary validation (variants: cta|primary|secondary|ghost)
- [ ] A11y labels presence (all interactive components have ariaLabel)
- [ ] Routes exist and compile (/home, /timer_running, /preset_editor)
- [ ] Token usage present in theme (all colors/typography referenced)
- [ ] Test coverage thresholds (State: 100%, Widgets: ≥80%, Overall: ≥80%)
- [ ] No hardcoded strings (all text via AppLocalizations)
- [ ] SharedPreferences persistence working (reps, work, rest, volume, presets, quickStartExpanded)
- [ ] Dual constructor pattern on State (create() + testable constructor)
- [ ] ValueControl widget reused (not regenerated)
- [ ] Icon-4 excluded from build (validated via widget tree dump)

---

# 13. Checklist (subset of PR_CHECKLIST)
- [x] Keys assigned on interactive widgets (all 18 interactive components keyed)
- [x] Texts verbatim + transform (uppercase applied to labels per design.json)
- [x] Variants/placement/widthMode valid (cta, primary, secondary, ghost; start, center, end; fill, hug, intrinsic)
- [x] Actions wired to state methods (all 14 actions mapped to IntervalTimerHomeState methods)
- [x] Golden-ready (stable layout, deterministic keys, no random values)
- [x] Test generation plan complete (27 state tests, 32 widget tests, 15 a11y tests)
- [x] ValueControl pattern identified (3 instances: RÉPÉTITIONS, TRAVAIL, REPOS)
- [x] Icon-4 excluded via rule:slider/normalizeSiblings(drop)
- [x] Translations plan complete (29 ARB entries, l10n.yaml config, main.dart setup)
- [x] File organization follows PROJECT_CONTRACT (screens/, widgets/, state/, l10n/)
- [x] State uses Provider + ChangeNotifier pattern (dual constructors for testability)
- [x] Widget decomposition justified (6 widgets, all <200 lines, clear single responsibility)
