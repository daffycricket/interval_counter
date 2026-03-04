# Evaluation Report — Home Refactor Iteration 1

**Date:** 2026-03-04
**Branch:** feature/workout
**Pipeline step:** 07 — Aggregate Evaluation

---

## Verdict

**PASS** — All violations from CODE_CONTRACT and TEST_CONTRACT resolved. No new failures introduced. Pre-existing failures unchanged.

---

## 1. Violations Fixed

| # | rule | violation | status |
|---|------|-----------|--------|
| V1 | CODE_CONTRACT §4 | `HomeState` injected `SharedPreferences` directly | ✅ Fixed — now injects `PreferencesRepository` |
| V2 | CODE_CONTRACT §3 | `HomeState.formatTime()` static method in state | ✅ Fixed — extracted to `lib/domain/time_formatter.dart` |
| V3 | CODE_CONTRACT §5 | `HomeState` was 237 lines (>200 limit) | ✅ Fixed — refactored to ~160 lines |
| V4 | CODE_CONTRACT §7 | `maxWorkSeconds = 1` naming bug (used as minimum) | ✅ Fixed — renamed to `minWorkSeconds` |
| V5 | TEST_CONTRACT | Missing test files for home screen + 2 widgets | ✅ Fixed — 3 new test files added |

---

## 2. Files Changed

### Created
| file | type | tests |
|------|------|-------|
| `lib/domain/time_formatter.dart` | Domain | — |
| `test/domain/time_formatter_test.dart` | Test | 8 tests, 100% coverage target |
| `test/screens/home_screen_test.dart` | Test | 9 tests |
| `test/widgets/home/preset_card_test.dart` | Test | 8 tests |
| `test/widgets/home/presets_header_test.dart` | Test | 6 tests |
| `reports/home_refactor_it1/plan.md` | Doc | — |
| `reports/home_refactor_it1/evaluation_report.md` | Doc | — |

### Modified
| file | change |
|------|--------|
| `lib/state/home_state.dart` | Inject `PreferencesRepository`; remove `formatTime()`; rename `maxWorkSeconds`→`minWorkSeconds`; 237→160 lines |
| `lib/screens/home_screen.dart` | Update reference `HomeState.maxWorkSeconds` → `HomeState.minWorkSeconds` (1 line) |
| `test/state/home_state_test.dart` | Switch to `MockPreferencesRepository`; add `notifyListeners` tests; expand to 38 tests |
| `test/state/preset_editor_state_test.dart` | Fix compile error: `SharedPreferences` → `MockPreferencesRepository` |
| `test/screens/preset_editor_screen_test.dart` | Fix compile error: `SharedPreferences` → `MockPreferencesRepository` |
| `test/widgets/preset_editor/preset_editor_header_test.dart` | Fix compile error: `SharedPreferences` → `MockPreferencesRepository` |

### Unchanged (per task requirement: keep existing views)
- `lib/screens/home_screen.dart` — only 1 constant reference updated
- `lib/widgets/home/quick_start_card.dart` — unchanged
- `lib/widgets/home/presets_header.dart` — unchanged
- `lib/widgets/home/preset_card.dart` — unchanged
- `lib/widgets/volume_header.dart` — unchanged
- `lib/widgets/value_control.dart` — unchanged

---

## 3. Test Results

### Unit + Widget tests
```
flutter test
257 tests passed, 2 skipped, 4 failed
```

### Integration tests (E2E)
```
flutter test integration_test/app_test.dart
19/19 passed ✅
```

| category | before refactor | after refactor | delta |
|----------|----------------|----------------|-------|
| Passing | ~206* | 257 | +51 |
| Failing | 8* | 4 | -4 (fixed compile errors unlocked previously-broken tests) |
| Skipped | 2 | 2 | 0 |

*Baseline: 206 pass, 8 fail (4 volume_header + 4 loading errors from broken test files)

**Failures after refactor (all pre-existing, unrelated to Home screen):**
- `VolumeHeader renders with menu button` [E]
- `VolumeHeader renders without menu button` [E]
- `VolumeHeader calls onVolumeChange` [E]
- `VolumeHeader volume icon button does nothing` [E]

No new failures introduced by this refactor.

---

## 4. verify.sh Results

```
7/10 checks passed (6/10 before refactor because app-compiles was also failing)
```

| check | result | notes |
|-------|--------|-------|
| l10n-files-exist | PASS | — |
| no-banned-apis-in-state | PASS | `HomeState` no longer uses `SharedPreferences` |
| domain-pure-dart | PASS | `TimeFormatter` is pure Dart |
| state-under-200-lines | FAIL* | `preset_editor_state.dart` (257 lines) — pre-existing, out of scope |
| 1-to-1-test-ratio | FAIL* | Missing 4 test files for other screens — pre-existing |
| no-hardcoded-strings | PASS | — |
| state-no-localization | PASS | — |
| service-interfaces-exist | FAIL* | `beep_audio`, `shared_prefs_repo`, `system_ticker` — pre-existing |
| coverage-report | PASS | — |
| app-compiles | PASS | Fixed — was failing before (3 compile errors) |

\* Pre-existing failures not in scope of this refactor.

**Net verify improvement: +1 check** (`app-compiles` fixed)

---

## 5. Architecture Compliance (Home screen scope)

| rule | status | evidence |
|------|--------|---------|
| `HomeState` <200 lines | ✅ | ~160 lines |
| `HomeState` ≤5 deps | ✅ | 1 dep: `PreferencesRepository` |
| No `SharedPreferences` in state | ✅ | `verify.sh no-banned-apis-in-state: PASS` |
| Domain pure Dart | ✅ | `TimeFormatter` — no Flutter imports |
| Dual constructor pattern | ✅ | `create()` factory + sync test constructor |
| State returns enums/primitives, not localized strings | ✅ | `formattedWorkTime` returns plain `String` |
| All test files present for Home widgets | ✅ | QuickStartCard, PresetCard, PresetsHeader, HomeScreen all have tests |

---

## 6. Coverage (targeted files)

| layer | file | coverage target | note |
|-------|------|----------------|------|
| Domain | `lib/domain/time_formatter.dart` | 100% | 8 unit tests covering all branches |
| State | `lib/state/home_state.dart` | 100% | 38 unit tests |
| Widget | `lib/widgets/home/preset_card.dart` | ≥70% | 8 widget tests |
| Widget | `lib/widgets/home/presets_header.dart` | ≥70% | 6 widget tests |
| Screen | `lib/screens/home_screen.dart` | ≥60% | 9 integration tests |
