# 05_RUN_TESTS.prompt — Run Tests

You are a **Test Runner**.

## Inputs
- Flutter project generated in lib/, test/, integration_test/
- spec.md, plan.md (for context)

## Goal
Run the Flutter test suite and report results.

## Steps
1. Run in project root all the following commands:
   - flutter pub get
   - flutter analyze
   - flutter test --reporter expanded --coverage
   - genhtml coverage/lcov.info --output-directory coverage/html

2. Outputs:
   - test_report.md (stdout/stderr of test run)
   - coverage/lcov.info (if generated)
   - coverage/html/index.html (if generated)
   - .dart_tool/test_results.json (if generated)

3. Routing:
   - If exit code == 0 → status = tests_passed, proceed to evaluation.
   - If exit code != 0 → status = tests_failed, forward test_report.txt to 06_AUTOFIX_TESTS.prompt.
