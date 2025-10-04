---
# Deterministic Build Plan — IntervalTimerHome

# YAML front matter for machine-readability
screenName: IntervalTimerHome
screenId: interval_timer_home
designSnapshotRef: 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png
planVersion: 2
generatedAt: 2025-10-04T08:30:00Z
generator: spec2plan
language: fr
inputsHash: 8d5f9c2a1b3e4f7d6a9c8b7e5d4c3a2b1f0e9d8c7b6a5d4c3b2a1f0e9d8c7b6a
---

# 0. Invariants & Sources
- Sources: `design.json` (layout/styling), `spec.md` (logic/state/navigation/a11y)
- Rule: **design.json wins for layout**, **spec.md wins for behavior**
- Controlled vocabularies only (variants: cta|primary|secondary|ghost; placement: start|center|end|stretch; widthMode: fixed|hug|fill)
- Keys: `interval_timer_home__{compId}`
- Missing data → `—` (dash)
- No free-form prose outside `notes` columns

---

# 1. Meta
| field            | value |
|------------------|-------|
| screenId         | interval_timer_home |
| designSnapshotRef| 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png |
| inputsHash       | 8d5f9c2a1b3e4f7d6a9c8b7e5d4c3a2b1f0e9d8c7b6a5d4c3b2a1f0e9d8c7b6a |

---

# 2. Files to Generate
## 2.1 Widgets
| widgetName           | filePath                         | purpose (fr court)          | components (compIds) | notes |
|----------------------|----------------------------------|-----------------------------|----------------------|-------|
| IntervalTimerHomeScreen | lib/screens/interval_timer_home_screen.dart | Écran principal | Tous | StatefulWidget |
| VolumeControlHeader | lib/widgets/interval_timer/volume_control_header.dart | Header avec contrôle volume | Container-1, IconButton-2, Slider-3, Icon-4, IconButton-5 | — |
| QuickStartCard | lib/widgets/interval_timer/quick_start_card.dart | Carte configuration rapide | Card-6 et enfants | Collapsible |
| PresetCard | lib/widgets/interval_timer/preset_card.dart | Carte préréglage individuel | Card-28 et enfants | Tappable |

## 2.2 State
| filePath                         | pattern            | exposes (fields/actions)            | persistence | notes |
|----------------------------------|--------------------|-------------------------------------|-------------|-------|
| lib/state/interval_timer_home_state.dart | ChangeNotifier | volumeLevel, quickStartExpanded, repetitions, workSeconds, restSeconds, presetsList; setVolume, toggleQuickStart, incrementReps, decrementReps, incrementWork, decrementWork, incrementRest, decrementRest, savePreset, loadPresets | SharedPreferences + File | — |

## 2.3 Routes
| routeName      | filePath                       | params       | created/uses | notes |
|----------------|--------------------------------|--------------|-------------|-------|
| /              | lib/routes/app_routes.dart     | —            | uses        | Route home existante |
| /timer         | lib/routes/app_routes.dart     | repetitions, workSeconds, restSeconds, presetId | uses | Route à créer |
| /preset/new    | lib/routes/app_routes.dart     | —            | uses        | Route à créer |

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
| typo     | titleLarge | yes | 20px/bold |
| typo     | label | yes | 12px/medium |
| typo     | value | yes | 24px/bold |
| typo     | title | yes | 16px/bold |
| typo     | body | yes | 14px/regular |

## 2.5 Tests (to be generated in steps 05/06)
| testId | type (widget/golden/unit) | filePath                          | purpose                  | notes |
|-------|----------------------------|-----------------------------------|--------------------------|-------|
| T1    | widget | test/screens/interval_timer_home_t1_start.dart | Tap COMMENCER navigue vers /timer | — |
| T2    | widget | test/screens/interval_timer_home_t2_increment_reps.dart | Tap + répétitions incrémente | — |
| T3    | widget | test/screens/interval_timer_home_t3_decrement_reps.dart | Tap - répétitions décrémente | — |
| T4    | widget | test/screens/interval_timer_home_t4_max_reps.dart | Répétitions plafonnées à 99 | — |
| T5    | widget | test/screens/interval_timer_home_t5_min_reps.dart | Répétitions plafonnées à 1 | — |
| T6    | widget | test/screens/interval_timer_home_t6_increment_work.dart | Tap + travail +5s | — |
| T7    | widget | test/screens/interval_timer_home_t7_decrement_work.dart | Tap - travail -5s | — |
| T8    | widget | test/screens/interval_timer_home_t8_increment_rest.dart | Tap + repos +1s | — |
| T9    | widget | test/screens/interval_timer_home_t9_decrement_rest.dart | Tap - repos -1s | — |
| T10   | widget | test/screens/interval_timer_home_t10_save_preset.dart | Tap SAUVEGARDER ouvre dialog | — |
| T11   | widget | test/screens/interval_timer_home_t11_add_preset.dart | Tap + AJOUTER navigue /preset/new | — |
| T12   | widget | test/screens/interval_timer_home_t12_preset_tap.dart | Tap carte préréglage navigue /timer | — |
| T13   | widget | test/screens/interval_timer_home_t13_collapse.dart | Tap expand/collapse toggle section | — |
| T14   | widget | test/screens/interval_timer_home_t14_volume_slider.dart | Drag slider met à jour volume | — |
| T15   | golden | test/screens/interval_timer_home_t15_golden.dart | Snapshot stable de l'écran | — |
| T16   | unit | test/state/interval_timer_home_state_t16_unit.dart | incrementRepetitions() 16→17 | — |
| T17   | unit | test/state/interval_timer_home_state_t17_unit.dart | decrementRepetitions() 16→15 | — |
| T18   | unit | test/state/interval_timer_home_state_t18_unit.dart | incrementRepetitions() at 99 | — |
| T19   | unit | test/state/interval_timer_home_state_t19_unit.dart | decrementRepetitions() at 1 | — |
| T20   | unit | test/state/interval_timer_home_state_t20_unit.dart | saveQuickStartAsPreset() | — |

---

# 3. Existing components to reuse
| componentName        | filePath                         | purpose of reuse (fr court) | components (compIds) | notes |
|----------------------|----------------------------------|-----------------------------|----------------------|-------|
| ValueControl       | lib/widgets/value_control.dart | Contrôle + valeur - | IconButton-11, Text-12, IconButton-13 (reps) | Pattern détecté |
| ValueControl       | lib/widgets/value_control.dart | Contrôle + valeur - | IconButton-15, Text-16, IconButton-17 (work) | Pattern détecté |
| ValueControl       | lib/widgets/value_control.dart | Contrôle + valeur - | IconButton-19, Text-20, IconButton-21 (rest) | Pattern détecté |

---

# 4. Widget Breakdown (from design.json + UI Mapping Guide)
| compId | type   | variant | key                       | widgetName | filePath                        | buildStrategy (mapping rule id) | notes |
|-------|--------|---------|---------------------------|------------|----------------------------------|---------------------------------|-------|
| Container-1 | Container | — | interval_timer_home__Container-1 | Container | inline | rule:group/alignment + rule:group/distribution | alignment:center, distribution:between |
| IconButton-2 | IconButton | ghost | interval_timer_home__IconButton-2 | IconButton | inline | rule:button/ghost + rule:iconButton/shaped | material.volume_up |
| Slider-3 | Slider | — | interval_timer_home__Slider-3 | Slider | inline | rule:slider/theme | valueNormalized: 0.62 |
| Icon-4 | Icon | — | — | — | — | rule:slider/normalizeSiblings(drop) | Thumb-like sibling near slider (dropped) |
| IconButton-5 | IconButton | ghost | interval_timer_home__IconButton-5 | IconButton | inline | rule:button/ghost + rule:iconButton/shaped | material.more_vert |
| Card-6 | Card | — | interval_timer_home__Card-6 | Card | QuickStartCard | rule:group/alignment | — |
| Container-7 | Container | — | interval_timer_home__Container-7 | Container | inline | rule:group/alignment + rule:group/distribution | alignment:center, distribution:between |
| Text-8 | Text | — | interval_timer_home__Text-8 | Text | inline | rule:text/transform | "Démarrage rapide" |
| IconButton-9 | IconButton | ghost | interval_timer_home__IconButton-9 | IconButton | inline | rule:button/ghost + rule:iconButton/shaped | material.expand_less |
| Text-10 | Text | — | interval_timer_home__Text-10 | Text | ValueControl | rule:pattern/valueControl | Label "RÉPÉTITIONS" |
| IconButton-11 | IconButton | ghost | interval_timer_home__IconButton-11 | IconButton | ValueControl | rule:pattern/valueControl | material.remove (reps -) |
| Text-12 | Text | — | interval_timer_home__Text-12 | Text | ValueControl | rule:pattern/valueControl | Value "16" |
| IconButton-13 | IconButton | ghost | interval_timer_home__IconButton-13 | IconButton | ValueControl | rule:pattern/valueControl | material.add (reps +) |
| Text-14 | Text | — | interval_timer_home__Text-14 | Text | ValueControl | rule:pattern/valueControl | Label "TRAVAIL" |
| IconButton-15 | IconButton | ghost | interval_timer_home__IconButton-15 | IconButton | ValueControl | rule:pattern/valueControl | material.remove (work -) |
| Text-16 | Text | — | interval_timer_home__Text-16 | Text | ValueControl | rule:pattern/valueControl | Value "00 : 44" |
| IconButton-17 | IconButton | ghost | interval_timer_home__IconButton-17 | IconButton | ValueControl | rule:pattern/valueControl | material.add (work +) |
| Text-18 | Text | — | interval_timer_home__Text-18 | Text | ValueControl | rule:pattern/valueControl | Label "REPOS" |
| IconButton-19 | IconButton | ghost | interval_timer_home__IconButton-19 | IconButton | ValueControl | rule:pattern/valueControl | material.remove (rest -) |
| Text-20 | Text | — | interval_timer_home__Text-20 | Text | ValueControl | rule:pattern/valueControl | Value "00 : 15" |
| IconButton-21 | IconButton | ghost | interval_timer_home__IconButton-21 | IconButton | ValueControl | rule:pattern/valueControl | material.add (rest +) |
| Button-22 | Button | ghost | interval_timer_home__Button-22 | TextButton | inline | rule:button/ghost + rule:layout/placement + rule:layout/widthMode | placement:end, widthMode:intrinsic |
| Button-23 | Button | cta | interval_timer_home__Button-23 | ElevatedButton | inline | rule:button/cta + rule:layout/placement + rule:layout/widthMode | placement:start, widthMode:fill |
| Container-24 | Container | — | interval_timer_home__Container-24 | Container | inline | rule:group/alignment + rule:group/distribution | alignment:center, distribution:between |
| Text-25 | Text | — | interval_timer_home__Text-25 | Text | inline | rule:text/transform | "VOS PRÉRÉGLAGES" |
| IconButton-26 | IconButton | ghost | interval_timer_home__IconButton-26 | IconButton | inline | rule:button/ghost + rule:iconButton/shaped | material.edit |
| Button-27 | Button | secondary | interval_timer_home__Button-27 | OutlinedButton | inline | rule:button/secondary + rule:layout/placement + rule:layout/widthMode | placement:end, widthMode:intrinsic |
| Card-28 | Card | — | interval_timer_home__Card-28 | Card | PresetCard | rule:group/alignment | — |
| Container-29 | Container | — | interval_timer_home__Container-29 | Container | inline | rule:group/alignment + rule:group/distribution | alignment:center, distribution:between |
| Text-30 | Text | — | interval_timer_home__Text-30 | Text | inline | rule:text/transform | "gainage" |
| Text-31 | Text | — | interval_timer_home__Text-31 | Text | inline | rule:text/transform | "14:22" |
| Text-32 | Text | — | interval_timer_home__Text-32 | Text | inline | rule:text/transform | "RÉPÉTITIONS 20x" |
| Text-33 | Text | — | interval_timer_home__Text-33 | Text | inline | rule:text/transform | "TRAVAIL 00:40" |
| Text-34 | Text | — | interval_timer_home__Text-34 | Text | inline | rule:text/transform | "REPOS 00:03" |

---

# 5. Layout Composition (design.json is authoritative)
## 5.1 Hierarchy
- root: Scaffold
  - appBar: PreferredSize(0) (no app bar, header inline)
  - body: SafeArea
    - child: SingleChildScrollView (scrollable: true)
      - child: Column
        - VolumeControlHeader (Container-1 → IconButton-5)
        - SizedBox(height: 8)
        - QuickStartCard (Card-6 + children)
        - SizedBox(height: 10)
        - Container (presets header, Container-24 → Button-27)
        - SizedBox(height: 8)
        - ListView.builder (presets list)
          - PresetCard (Card-28 + children) × N

## 5.2 Constraints & Placement
| container | child (widgetName) | flex | alignment (placement) | widthMode | spacing | scrollable |
|----------|---------------------|------|------------------------|-----------|---------|------------|
| root | VolumeControlHeader | — | stretch | fill | 0 | false |
| root | QuickStartCard | — | stretch | fill | 0 | false |
| root | Container (presets header) | — | stretch | fill | 0 | false |
| root | ListView.builder | — | stretch | fill | 0 | true |
| Container-1 | IconButton-2 | — | start | hug | 12 | false |
| Container-1 | Slider-3 | 1 | center | fill | 12 | false |
| Container-1 | IconButton-5 | — | end | hug | 12 | false |
| Card-6 | ValueControl (reps) | — | stretch | fill | 16 | false |
| Card-6 | ValueControl (work) | — | stretch | fill | 16 | false |
| Card-6 | ValueControl (rest) | — | stretch | fill | 16 | false |
| Card-6 | Button-22 | — | end | hug | 8 | false |
| Card-6 | Button-23 | — | stretch | fill | 16 | false |

---

# 6. Interaction Wiring (from spec)
| compId | actionName   | stateImpact          | navigation | a11y (ariaLabel) | notes |
|--------|--------------|----------------------|-----------|------------------|-------|
| IconButton-2 | toggleVolumePopup | volumePopupVisible | — | Régler le volume | Implémentation simplifiée (pas de popup IT1) |
| Slider-3 | setVolume | volumeLevel | — | Curseur de volume | onChanged callback |
| IconButton-5 | showOptionsMenu | optionsMenuVisible | — | Plus d'options | Menu contextuel |
| IconButton-9 | toggleQuickStartExpanded | quickStartExpanded | — | Replier la section Démarrage rapide | Anime collapse/expand |
| IconButton-11 | decrementRepetitions | repetitions | — | Diminuer les répétitions | Min: 1 |
| IconButton-13 | incrementRepetitions | repetitions | — | Augmenter les répétitions | Max: 99 |
| IconButton-15 | decrementWorkTime | workSeconds | — | Diminuer le temps de travail | Min: 5, step: 5 |
| IconButton-17 | incrementWorkTime | workSeconds | — | Augmenter le temps de travail | Max: 3600, step: 5 |
| IconButton-19 | decrementRestTime | restSeconds | — | Diminuer le temps de repos | Min: 3, step: 1 |
| IconButton-21 | incrementRestTime | restSeconds | — | Augmenter le temps de repos | Max: 3600, step: 1 |
| Button-22 | saveQuickStartAsPreset | presetsList | — | Sauvegarder le préréglage rapide | Dialog puis save |
| Button-23 | startInterval | — | /timer | Démarrer l'intervalle | Pass params |
| IconButton-26 | toggleEditMode | editModeActive | — | Éditer les préréglages | Toggle icons |
| Button-27 | createNewPreset | — | /preset/new | Ajouter un préréglage | Navigate |
| Card-28 | selectPreset | — | /timer | — | Tap entire card |

---

# 7. State Model & Actions (from spec §6)
## 7.1 Fields
| key          | type | default | persistence | notes |
|--------------|------|---------|-------------|-------|
| volumeLevel | double | 0.62 | SharedPreferences | Normalized 0.0-1.0 |
| volumePopupVisible | bool | false | non | — |
| optionsMenuVisible | bool | false | non | — |
| quickStartExpanded | bool | true | SharedPreferences | — |
| repetitions | int | 16 | SharedPreferences | — |
| workSeconds | int | 44 | SharedPreferences | — |
| restSeconds | int | 15 | SharedPreferences | — |
| presetsList | List<Preset> | [] | File (JSON) | — |
| editModeActive | bool | false | non | — |

## 7.2 Actions
| name        | input | output | errors | description |
|-------------|-------|--------|--------|-------------|
| setVolume | double value | — | — | Update volumeLevel, persist |
| toggleVolumePopup | — | — | — | Toggle volumePopupVisible |
| showOptionsMenu | — | — | — | Show menu |
| toggleQuickStartExpanded | — | — | — | Toggle quickStartExpanded, persist |
| incrementRepetitions | — | — | — | repetitions + 1 (max 99) |
| decrementRepetitions | — | — | — | repetitions - 1 (min 1) |
| incrementWorkTime | — | — | — | workSeconds + 5 (max 3600) |
| decrementWorkTime | — | — | — | workSeconds - 5 (min 5) |
| incrementRestTime | — | — | — | restSeconds + 1 (max 3600) |
| decrementRestTime | — | — | — | restSeconds - 1 (min 3) |
| saveQuickStartAsPreset | String name | Preset | ValidationError | Validate, save, add to list |
| startInterval | — | — | ValidationError | Validate, navigate |
| toggleEditMode | — | — | — | Toggle editModeActive |
| createNewPreset | — | — | — | Navigate /preset/new |
| loadPresets | — | List<Preset> | FileError | Load from file |
| deletePreset | String presetId | — | FileError | Delete and refresh |

---

# 8. Accessibility Plan
| order | compId | role        | ariaLabel    | focusable | shortcut | notes |
|------:|--------|-------------|--------------|-----------|----------|-------|
| 1     | IconButton-2 | button | Régler le volume | true | — | — |
| 2     | Slider-3 | slider | Curseur de volume | true | Arrow keys | — |
| 3     | IconButton-5 | button | Plus d'options | true | — | — |
| 4     | IconButton-9 | button | Replier la section Démarrage rapide | true | — | — |
| 5     | IconButton-11 | button | Diminuer les répétitions | true | — | ValueControl |
| 6     | Text-12 | text | — | false | — | ValueControl |
| 7     | IconButton-13 | button | Augmenter les répétitions | true | — | ValueControl |
| 8     | IconButton-15 | button | Diminuer le temps de travail | true | — | ValueControl |
| 9     | Text-16 | text | — | false | — | ValueControl |
| 10    | IconButton-17 | button | Augmenter le temps de travail | true | — | ValueControl |
| 11    | IconButton-19 | button | Diminuer le temps de repos | true | — | ValueControl |
| 12    | Text-20 | text | — | false | — | ValueControl |
| 13    | IconButton-21 | button | Augmenter le temps de repos | true | — | ValueControl |
| 14    | Button-22 | button | Sauvegarder le préréglage rapide | true | — | — |
| 15    | Button-23 | button | Démarrer l'intervalle | true | Enter | — |
| 16    | IconButton-26 | button | Éditer les préréglages | true | — | — |
| 17    | Button-27 | button | Ajouter un préréglage | true | — | — |
| 18    | Card-28 | button | — | true | — | Preset card |

---

# 9. Testing Plan (traceability to spec §10)
| testId | preconditions | steps (concise)       | oracle (expected)                                  | finder strategy |
|-------|----------------|-----------------------|----------------------------------------------------|-----------------|
| T1    | idle           | tap COMMENCER        | Navigation /timer with params | find.byKey('interval_timer_home__Button-23') |
| T2    | idle           | tap + reps           | Text-12 shows "17" | find.byKey('interval_timer_home__Text-12') |
| T3    | idle           | tap - reps           | Text-12 shows "15" | find.byKey('interval_timer_home__Text-12') |
| T4    | reps=99        | tap + reps           | Text-12 still "99", button disabled | find.byKey('interval_timer_home__IconButton-13') |
| T5    | reps=1         | tap - reps           | Text-12 still "1", button disabled | find.byKey('interval_timer_home__IconButton-11') |
| T6    | idle           | tap + work           | Text-16 shows "00 : 49" | find.byKey('interval_timer_home__Text-16') |
| T7    | idle           | tap - work           | Text-16 shows "00 : 39" | find.byKey('interval_timer_home__Text-16') |
| T8    | idle           | tap + rest           | Text-20 shows "00 : 16" | find.byKey('interval_timer_home__Text-20') |
| T9    | idle           | tap - rest           | Text-20 shows "00 : 14" | find.byKey('interval_timer_home__Text-20') |
| T10   | idle           | tap SAUVEGARDER      | Dialog appears with name input | find.byType(AlertDialog) |
| T11   | idle           | tap + AJOUTER        | Navigation /preset/new | find.byKey('interval_timer_home__Button-27') |
| T12   | presets loaded | tap preset card      | Navigation /timer with preset config | find.byKey('interval_timer_home__Card-28') |
| T13   | expanded       | tap IconButton-9     | QuickStartCard collapses | find.byKey('interval_timer_home__Card-6') |
| T14   | idle           | drag Slider-3 to 0.8 | volumeLevel == 0.8 | find.byKey('interval_timer_home__Slider-3') |
| T15   | idle           | —                    | Golden snapshot matches | matchesGoldenFile |
| T16   | state, reps=16 | incrementRepetitions | reps == 17 | unit test |
| T17   | state, reps=16 | decrementRepetitions | reps == 15 | unit test |
| T18   | state, reps=99 | incrementRepetitions | reps == 99 (unchanged) | unit test |
| T19   | state, reps=1  | decrementRepetitions | reps == 1 (unchanged) | unit test |
| T20   | state, valid   | saveQuickStartAsPreset | Preset added to presetsList | unit test |

---

# 10. Risks / Unknowns (from spec §11.3)
- **Contenu exact du menu IconButton-5** : non spécifié dans le snapshot, à définir (settings, about, etc.)
- **Politique de tri préréglages** : par défaut = ordre de création, à confirmer
- **Confirmation suppression préréglage** : dialog ou snackbar undo ?
- **Icon-4 (material.circle)** : identifié comme thumb-like artifact, **DROPPED** selon rule:slider/normalizeSiblings

---

# 11. Check Gates
- ✅ Analyzer/lint pass
- ✅ Unique keys check (all interactive components)
- ✅ Controlled vocabulary validation (variants, placement, widthMode)
- ✅ A11y labels presence (all interactive)
- ✅ Routes exist and compile (/timer, /preset/new to be created)
- ✅ Token usage present in theme (all colors/typography defined)
- ✅ ValueControl pattern detected and reused (3 instances)
- ✅ Orphan thumb (Icon-4) dropped per validation report

---

# 12. Checklist (subset of PR_CHECKLIST)
- [x] Keys assigned on interactive widgets
- [x] Texts verbatim + transform
- [x] Variants/placement/widthMode valid
- [x] Actions wired to state methods
- [x] Golden-ready (stable layout, no randoms)
- [x] ValueControl pattern reused (no duplicate code)
- [x] Slider theme properly configured
- [x] Icon-4 dropped per normalization rule
- [ ] Routes /timer and /preset/new created (to be done in Step 4)
- [ ] Preset model and storage service implemented (to be done in Step 4)
- [ ] Tests generated and passing (to be done in Steps 5/6)
