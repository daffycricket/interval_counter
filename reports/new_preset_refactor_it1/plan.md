---
# Deterministic Build Plan — PresetEditor Refactor Iteration 1

screenName: PresetEditor
screenId: preset_editor
designSnapshotRef: e1cb6394-36df-45ff-8766-c9d4db68dd37.png
planVersion: 2
generatedAt: 2026-03-04T00:00:00Z
generator: snapshot2app-refactor
language: fr
inputsHash: refactor-it1
---

# 0. Invariants & Sources
- Sources: `sources/new_preset/new_preset_design.json` (layout/styling), `reports/new_preset/spec.md` (logic/state/navigation/a11y)
- Rule: **design.json wins for layout**, **spec.md wins for behavior**
- **Scope:** Keep existing views (screen + widgets unchanged structurally). Refactor state and business logic to match CODE_CONTRACT.md and TEST_CONTRACT.md.

---

# 1. Meta
| field             | value |
|-------------------|-------|
| screenId          | preset_editor |
| designSnapshotRef | e1cb6394-36df-45ff-8766-c9d4db68dd37.png |
| inputsHash        | refactor-it1 |

---

# 2. CODE_CONTRACT Violations Identified

| # | Violation | Rule | Location | Fix |
|---|-----------|------|----------|-----|
| V1 | `formatTime()` duplicated in state | §3 Domain layer: business logic in domain | `lib/state/preset_editor_state.dart:39` | Remove; delegate to `TimeFormatter.format()` |
| V2 | `_viewMode` typed as `String` | §5 State as thin coordinator: return enums/primitives | `lib/state/preset_editor_state.dart:23` | Extract `ViewMode` enum to `lib/domain/view_mode.dart` |
| V3 | State >200 lines (257 lines) | §5 State <200 lines | `lib/state/preset_editor_state.dart` | Extract `PresetCalculator`, remove duplicate `formatTime`, compact constructor |
| V4 | `formattedTotal` calculation inline in state | §3 Complex calculations in domain | `lib/state/preset_editor_state.dart:58` | Extract `PresetCalculator.formatTotal()` to domain |
| V5 | No dual constructor pattern | §5 Dependency injection — dual constructors | `lib/state/preset_editor_state.dart` | Add `create()` static factory |

---

# 3. Files to Generate / Modify

## 3.1 New Files (Domain)
| filePath | purpose | notes |
|----------|---------|-------|
| `lib/domain/view_mode.dart` | `enum ViewMode { simple, advanced }` — replaces String viewMode | Pure Dart |
| `lib/domain/preset_calculator.dart` | `PresetCalculator.calculateTotal()` + `formatTotal()` | Pure Dart, extracted from state |

## 3.2 New Test Files
| filePath | covers | coverage target |
|----------|--------|----------------|
| `test/domain/view_mode_test.dart` | ViewMode enum values | 100% (1:1 ratio) |
| `test/domain/preset_calculator_test.dart` | `calculateTotal()`, `formatTotal()`, boundary conditions | 100% |

## 3.3 Modified Files
| filePath | change summary |
|----------|----------------|
| `lib/state/preset_editor_state.dart` | Use `ViewMode` enum; delegate `formatTime` → `TimeFormatter.format()`; delegate total → `PresetCalculator.formatTotal()`; add `create()` factory; <200 lines |
| `lib/screens/preset_editor_screen.dart` | `state.viewMode == 'simple'` → `state.viewMode == ViewMode.simple` |
| `lib/widgets/preset_editor/preset_editor_header.dart` | Same enum comparison update |
| `test/state/preset_editor_state_test.dart` | Update `viewMode` assertions: `'simple'` → `ViewMode.simple`, `'advanced'` → `ViewMode.advanced` |

## 3.4 Unchanged (views kept as-is)
- `lib/screens/preset_editor_screen.dart` — structure unchanged (only enum comparison)
- `lib/widgets/preset_editor/preset_editor_header.dart` — structure unchanged
- `lib/widgets/preset_editor/preset_name_input.dart` — no change
- `lib/widgets/preset_editor/preset_params_panel.dart` — no change
- `lib/widgets/preset_editor/preset_total_display.dart` — no change
- `lib/widgets/preset_editor/mode_toggle_button.dart` — no change

---

# 4. Domain Design

## 4.1 `lib/domain/view_mode.dart`
```dart
enum ViewMode { simple, advanced }
```

## 4.2 `lib/domain/preset_calculator.dart`
```
PresetCalculator._()  // private constructor — utility class
static int calculateTotal({prepareSeconds, repetitions, workSeconds, restSeconds, cooldownSeconds})
  → int: prepareSeconds + (repetitions × (workSeconds + restSeconds)) + cooldownSeconds
static String formatTotal({...same params...})
  → String: 'TOTAL mm:ss' (no spaces around colon, unlike TimeFormatter)
```

---

# 5. State Design (refactored)

## 5.1 Fields
| key | type | default | persistence | notes |
|-----|------|---------|-------------|-------|
| name | String | "" | via sauvegarde | — |
| prepareSeconds | int | 5 | via sauvegarde | — |
| repetitions | int | 10 | via sauvegarde | — |
| workSeconds | int | 40 | via sauvegarde | — |
| restSeconds | int | 20 | via sauvegarde | — |
| cooldownSeconds | int | 30 | via sauvegarde | — |
| viewMode | **ViewMode** | ViewMode.simple | non | Was String |
| editMode | bool | false | non | — |
| presetId | String? | null | non | — |

## 5.2 Computed Getters (delegated)
| getter | delegates to | format |
|--------|-------------|--------|
| formattedPrepareTime | `TimeFormatter.format(_prepareSeconds)` | "mm : ss" |
| formattedWorkTime | `TimeFormatter.format(_workSeconds)` | "mm : ss" |
| formattedRestTime | `TimeFormatter.format(_restSeconds)` | "mm : ss" |
| formattedCooldownTime | `TimeFormatter.format(_cooldownSeconds)` | "mm : ss" |
| formattedTotal | `PresetCalculator.formatTotal(...)` | "TOTAL mm:ss" |

## 5.3 Constructors
| constructor | type | purpose |
|-------------|------|---------|
| `PresetEditorState(homeState, {...})` | sync | Test constructor — accepts mocks |
| `PresetEditorState.create(homeState, {...})` | static factory | Production — same (no async deps) |

---

# 6. Test Generation Plan

## 6.1 Domain Tests — 100% coverage
| file | test cases |
|------|-----------|
| `test/domain/view_mode_test.dart` | enum has simple and advanced values |
| `test/domain/preset_calculator_test.dart` | calculateTotal default (635s), reps×work+rest formula, all zeros, boundary; formatTotal prefix "TOTAL", mm:ss format |

## 6.2 State Tests — 100% coverage (update existing)
| change | location |
|--------|---------|
| `expect(state.viewMode, 'simple')` → `expect(state.viewMode, ViewMode.simple)` | all viewMode assertions |
| `expect(state.viewMode, 'advanced')` → `expect(state.viewMode, ViewMode.advanced)` | switchToAdvanced tests |
| formatTime group: rename, assertions remain valid (delegates still return same format) | formatTime group |

---

# 7. Check Gates
- [ ] `flutter analyze` — no errors
- [ ] `verify.sh` — all 9 checks pass (incl. state-under-200-lines)
- [ ] `flutter test --coverage` — all tests pass, overall ≥80%
- [ ] State 100% coverage, Domain 100% coverage

---

# 8. Risks
| # | risk | severity | mitigation |
|---|------|----------|-----------|
| R1 | Widget tests referencing `state.viewMode == 'simple'` string | Medium | Update all comparison sites to enum |
| R2 | `formattedTotal` format change (if tests expect specific string) | Low | Verify existing test expectations match `'TOTAL mm:ss'` format |
| R3 | State line count still >200 after refactor | Low | Compact constructor body, remove doc comments on trivial methods |
