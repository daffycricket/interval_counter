---
# Deterministic Build Plan — Home Refactor Iteration 1

screenName: Home
screenId: home
designSnapshotRef: 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png
planVersion: 2
generatedAt: 2026-03-04T00:00:00Z
generator: snapshot2app-refactor
language: fr
inputsHash: —
---

# 0. Invariants & Sources
- Sources: `design.json` (layout/styling), `reports/home/spec.md` (logic/state/navigation/a11y)
- Rule: **views unchanged** — only state and domain layers refactored
- Controlled vocabularies only (variants: cta|primary|secondary|ghost)
- Keys: `{screenId}__{compId}` — unchanged
- Missing data → `—`

---

# 1. Meta
| field             | value |
|-------------------|-------|
| screenId          | home  |
| designSnapshotRef | 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png |
| inputsHash        | — |
| refactorType      | state + domain extraction (views kept) |
| iteration         | it1 |

---

# 2. Violations Identified (CODE_CONTRACT)

| # | rule | violation | location | fix |
|---|------|-----------|----------|-----|
| V1 | §4 State MUST NOT use concrete Flutter persistence class | `HomeState` injects `SharedPreferences` directly | `lib/state/home_state.dart:9` | Inject `PreferencesRepository` interface |
| V2 | §3 Business logic extracted to domain | `HomeState.formatTime()` static method (pure computation) in state | `lib/state/home_state.dart:214` | Extract to `lib/domain/time_formatter.dart` |
| V3 | §5 State <200 lines | `HomeState` is 237 lines | `lib/state/home_state.dart` | Refactor reduces to ~160 lines |
| V4 | §7 Naming conventions | Constant `maxWorkSeconds = 1` used as minimum | `lib/state/home_state.dart:15` | Rename to `minWorkSeconds` |
| V5 | TEST_CONTRACT: 1:1 test mirror | Missing test files for 3 home widgets + screen | `test/` | Add missing test files |

---

# 2. Files to Generate

## 2.1 New Files

| filePath | type | purpose |
|----------|------|---------|
| `lib/domain/time_formatter.dart` | Domain | Pure time formatting function extracted from HomeState |
| `test/domain/time_formatter_test.dart` | Test | 100% coverage for TimeFormatter |
| `test/screens/home_screen_test.dart` | Test | ≥60% coverage for HomeScreen |
| `test/widgets/home/preset_card_test.dart` | Test | ≥70% coverage for PresetCard |
| `test/widgets/home/presets_header_test.dart` | Test | ≥70% coverage for PresetsHeader |
| `reports/home_refactor_it1/plan.md` | Doc | This plan |
| `reports/home_refactor_it1/evaluation_report.md` | Doc | Post-test evaluation |

## 2.2 Files to Modify

| filePath | change | reason |
|----------|--------|--------|
| `lib/state/home_state.dart` | Inject `PreferencesRepository`; remove `formatTime()`; rename `maxWorkSeconds`→`minWorkSeconds` | V1, V2, V3, V4 |
| `lib/screens/home_screen.dart` | Update reference `HomeState.maxWorkSeconds` → `HomeState.minWorkSeconds` | V4 cascade |
| `test/state/home_state_test.dart` | Switch from `SharedPreferences` to `MockPreferencesRepository`; move formatTime tests | V1 test update |

## 2.2.1 Service Dependencies

**Existing (reused, no change):**
| interfacePath | implPath | status |
|---|---|---|
| `lib/services/preferences_repository.dart` | `lib/services/impl/shared_prefs_repository.dart` | Exists — inject into HomeState |

**New Domain Classes:**
| domainPath | purpose | extracted from |
|---|---|---|
| `lib/domain/time_formatter.dart` | Format seconds as "mm : ss" with spaces | `HomeState.formatTime()` |

## 2.3 Views (NO CHANGE)

| file | status |
|------|--------|
| `lib/screens/home_screen.dart` | Kept — 1 line changed (constant ref) |
| `lib/widgets/home/quick_start_card.dart` | Unchanged |
| `lib/widgets/home/presets_header.dart` | Unchanged |
| `lib/widgets/home/preset_card.dart` | Unchanged |
| `lib/widgets/volume_header.dart` | Unchanged |
| `lib/widgets/value_control.dart` | Unchanged |

---

# 3. State Model (refactored)

## 3.1 HomeState — after refactor

| field | type | default | persistence | notes |
|-------|------|---------|-------------|-------|
| reps | int | 10 | yes | via `_repo.set<int>` |
| workSeconds | int | 40 | yes | via `_repo.set<int>` |
| restSeconds | int | 20 | yes | via `_repo.set<int>` |
| volume | double | 0.62 | yes | via `_repo.set<double>` |
| quickStartExpanded | bool | true | no | — |
| presets | List<Preset> | [] | yes | JSON via `_repo.set<String>` |
| editMode | bool | false | no | — |

## 3.2 Constructor pattern (CODE_CONTRACT §5)

```
// Production
static Future<HomeState> create() async {
  final prefs = await SharedPreferences.getInstance();
  return HomeState(SharedPrefsRepository(prefs));
}

// Test (sync, accepts mock)
HomeState(this._repo) { _loadState(); }
```

## 3.3 Constants (fixed naming)

| name | value | was |
|------|-------|-----|
| minReps | 1 | minReps |
| maxReps | 999 | maxReps |
| minSeconds | 0 | minSeconds |
| minWorkSeconds | 1 | **maxWorkSeconds** (bug fixed) |
| maxSeconds | 3599 | maxSeconds |

---

# 4. Domain Layer

## 4.1 TimeFormatter

**File:** `lib/domain/time_formatter.dart`
**Pattern:** pure static Dart function — no Flutter imports
**Method:** `TimeFormatter.format(int seconds) → String`
**Format:** `"mm : ss"` for <1h, `"hh : mm : ss"` for ≥1h (spaces around colons)
**Source:** extracted verbatim from `HomeState.formatTime()`

---

# 5. Test Generation Plan

## 5.1 Domain Tests
| class | file | coverage target |
|-------|------|----------------|
| TimeFormatter | `test/domain/time_formatter_test.dart` | 100% |

## 5.2 State Tests (updated)
| class | file | coverage target | change |
|-------|------|----------------|--------|
| HomeState | `test/state/home_state_test.dart` | 100% | Switch to MockPreferencesRepository |

## 5.3 Widget Tests (new)
| widgetName | testFilePath | covers |
|------------|-------------|--------|
| PresetCard | `test/widgets/home/preset_card_test.dart` | Card-28, Text-30..34 |
| PresetsHeader | `test/widgets/home/presets_header_test.dart` | Container-24, IconButton-26, Button-27 |

## 5.4 Screen Tests (new)
| screen | file | coverage target |
|--------|------|----------------|
| HomeScreen | `test/screens/home_screen_test.dart` | ≥60% |

## 5.5 Widget Tests (1:1 with widgets)
| widgetName | testFilePath | status |
|------------|-------------|--------|
| QuickStartCard | `test/widgets/home/quick_start_card_test.dart` | Exists |
| PresetCard | `test/widgets/home/preset_card_test.dart` | **New** |
| PresetsHeader | `test/widgets/home/presets_header_test.dart` | **New** |

---

# 6. Risks

| # | type | description | mitigation |
|---|------|-------------|------------|
| R1 | Low | `home_state_test.dart` references `HomeState.formatTime()` — those tests must migrate | Move to `time_formatter_test.dart` |
| R2 | Low | `home_screen.dart` references `HomeState.maxWorkSeconds` — rename cascade | Update reference in screen |
| R3 | Low | `MockPreferencesRepository._storage` uses plain `Map` — clamp must still work | `_loadState()` clamping logic unchanged |
