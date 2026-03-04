# 05_RUN_TESTS.prompt — Run Tests & Verification

You are a **Test Runner**.

## Inputs
- Flutter project generated in lib/, test/, integration_test/
- spec.md, plan.md (for context)

## Goal
Run the Flutter test suite AND deterministic architecture checks. Report results.

## Steps

### 1. Architecture verification
Run from project root:
```bash
bash snapshot2app_agent_context/guards/verify.sh
```
Capture output. If exit code != 0 → record violations for evaluation report.

### 2. Flutter checks
Run in project root:
```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test --reporter expanded --coverage
```

### 3. Integration tests (E2E gate)
```bash
flutter test integration_test/app_test.dart
```
**All existing integration tests MUST pass.** This is the final gate.

### 4. Coverage report
```bash
genhtml coverage/lcov.info --output-directory coverage/html
```

### 5. Outputs
- `verify_report.txt` — output of verify.sh (architecture checks)
- `test_report.md` — stdout/stderr of unit tests
- `integration_test_report.md` — stdout/stderr of integration tests
- `coverage/lcov.info`
- `coverage/html/index.html` (MANDATORY — if missing → FAIL)

### 6. Routing
- If **all three** pass (verify.sh + unit tests + integration tests) → status = **tests_passed**, proceed to evaluation.
- If unit tests fail → status = **tests_failed**, forward to 06_AUTOFIX_TESTS.prompt.
- If integration tests fail → status = **integration_tests_failed**, forward to 06_AUTOFIX_TESTS.prompt. **Do not modify existing integration test files** — fix the production code instead.
- If verify.sh fails but tests pass → status = **architecture_violations**, forward verify_report.txt to 06_AUTOFIX_TESTS.prompt.
