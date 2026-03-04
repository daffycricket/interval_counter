# TEST_CONTRACT — Testing Requirements

## Purpose
Mandatory testing standards for generated Flutter code.
Code must follow `CODE_CONTRACT.md` (DI, domain layer, State as coordinator).

---

## Coverage Thresholds

Coverage thresholds (build-blocking where indicated):

| Layer | Target | Blocks build? |
|---|---|---|
| Domain (`lib/domain/`) | 100% line + branch | Yes |
| State (`lib/state/`) | 100% line + branch | Yes |
| Models (`lib/models/`) | 100% line + branch | Yes |
| Services (`lib/services/impl/`) | ≥80% | No |
| Generic widgets (`lib/widgets/*.dart`) | ≥90% | No |
| Screen-specific widgets | ≥70% | No |
| Screens (`lib/screens/`) | ≥60% | No |
| **Overall project** | **≥80%** | **Yes** |

---

## Test File Structure

Mirror `lib/` 1:1 in `test/` — every production file must have a test file:
```
test/
  domain/{feature}_test.dart
  state/{screen}_state_test.dart
  models/{model}_test.dart
  services/impl/{service}_test.dart
  widgets/{screen}/{widget}_test.dart
  screens/{screen}_screen_test.dart
  helpers/widget_test_helpers.dart
```

---

## What to Test Per Layer

### Domain (CRITICAL — 100%)
- All calculations, validators, state transitions
- Boundary conditions, edge cases
- Pure Dart only, no Flutter dependencies, ultra-fast (<1ms/test)

### State (CRITICAL — 100%)
- Initial values and defaults
- Every public method: precondition → action → postcondition
- Boundary values (min/max constraints)
- `notifyListeners()` called after mutations
- Persistence round-trip: save → load → equals
- Computed properties and getters

### Models (CRITICAL — 100%)
- `fromJson` → `toJson` round-trip equals original
- `copyWith` changes only specified fields
- Equality: same values → equals true, different → false
- `toString()` format

### Services (HIGH — ≥80%)
- Interface compliance (all methods implemented)
- Actual behavior with real dependencies

### Widgets (HIGH)
- Renders with correct key
- Interaction triggers correct State method
- Updates when State changes via Provider
- Do NOT create semantic tests

### Screens (MEDIUM — ≥60%)
- All key components present (by Key from plan.md)
- One critical user flow from spec.md
- Navigation triggers work
- Provider integration

---

## Test Conventions

- Descriptive names: `'increment does not exceed maxReps'`
- Group with `group()`, initialize with `setUp()`
- Find widgets by `Key`, never by `find.text()` (fragile with i18n)
- Deterministic: no random values, no time dependencies
- Set locale: `locale: const Locale('fr')` for French tests
- Use specific test data (avoid duplicate values causing ambiguity)

---

## Shared Test Helpers

Generate `test/helpers/widget_test_helpers.dart` with:
- Mock state factories (`createMockState()`)
- Test widget wrappers with Provider + localization (`createTestApp()`)
- Common setup utilities

---

## Integration Tests (E2E)

Location: `integration_test/`
- `app_test.dart` — single entry point (imports all flow files)
- `{screen}_flow_test.dart` — one file per screen/flow

**Rules:**
- Every new feature MUST add integration tests for its user-facing flows
- Existing integration test files MUST NOT be modified unless the spec_complement explicitly documents a behavior change on that screen
- All integration tests MUST pass for the pipeline to succeed (gate)
- Use `find.byKey()` with stable keys only — never `find.text()` or `find.byIcon()`

**Run:** `flutter test integration_test/app_test.dart`

---

## Exemptions

**Exempt from coverage:**
- `main.dart`, generated code, purely decorative widgets (marked `testPriority: none` in plan.md)

**Never exempt:**
- State, Models, Domain, Interactive widgets, Navigation logic, Validation logic
