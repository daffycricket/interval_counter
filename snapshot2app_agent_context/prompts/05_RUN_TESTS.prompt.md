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
flutter analyze
flutter test --reporter expanded --coverage
```

### 3. Coverage report
```bash
genhtml coverage/lcov.info --output-directory coverage/html
```

### 4. Outputs
- `verify_report.txt` — output of verify.sh (architecture checks)
- `test_report.md` — stdout/stderr of flutter test
- `coverage/lcov.info`
- `coverage/html/index.html` (MANDATORY — if missing → FAIL)

### 5. Routing
- If **both** verify.sh exit 0 AND flutter test exit 0 → status = **tests_passed**, proceed to evaluation.
- If flutter test fails → status = **tests_failed**, forward to 06_AUTOFIX_TESTS.prompt.
- If verify.sh fails but tests pass → status = **architecture_violations**, forward verify_report.txt to 06_AUTOFIX_TESTS.prompt.
