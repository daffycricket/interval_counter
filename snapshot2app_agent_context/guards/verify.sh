#!/usr/bin/env bash
# verify.sh — Deterministic architecture & structure checks
# Run from project root. Exit code: 0 = all pass, 1 = violations found.
# Output: structured report to stdout.

set -euo pipefail

PASS=0
FAIL=0
VIOLATIONS=""

check() {
  local name="$1"
  local result="$2"  # "pass" or "fail"
  local detail="${3:-}"

  if [ "$result" = "pass" ]; then
    PASS=$((PASS + 1))
    echo "  PASS  $name"
  else
    FAIL=$((FAIL + 1))
    VIOLATIONS="${VIOLATIONS}\n  FAIL  $name: $detail"
    echo "  FAIL  $name: $detail"
  fi
}

echo "=== Architecture & Structure Verification ==="
echo ""

# --- 0. Localization files exist ---
if [ -f "l10n.yaml" ]; then
  if [ -f "lib/l10n/app_localizations.dart" ]; then
    check "l10n-files-exist" "pass"
  else
    check "l10n-files-exist" "fail" "lib/l10n/app_localizations.dart missing — run: flutter gen-l10n"
  fi
fi

# --- 1. No Timer.periodic / SystemSound / HapticFeedback in State ---
BANNED_IN_STATE=$(grep -rn "Timer\.periodic\|SystemSound\.play\|HapticFeedback\." lib/state/ 2>/dev/null || true)
if [ -z "$BANNED_IN_STATE" ]; then
  check "no-banned-apis-in-state" "pass"
else
  check "no-banned-apis-in-state" "fail" "$(echo "$BANNED_IN_STATE" | head -5)"
fi

# --- 2. No Flutter imports in domain (except foundation) ---
FLUTTER_IN_DOMAIN=$(grep -rn "package:flutter" lib/domain/ 2>/dev/null | grep -v "foundation" || true)
if [ -z "$FLUTTER_IN_DOMAIN" ]; then
  check "domain-pure-dart" "pass"
else
  check "domain-pure-dart" "fail" "$(echo "$FLUTTER_IN_DOMAIN" | head -5)"
fi

# --- 3. State classes < 200 lines ---
if [ -d "lib/state" ]; then
  LARGE_STATES=""
  for f in lib/state/*.dart; do
    [ -f "$f" ] || continue
    LINES=$(wc -l < "$f" | tr -d ' ')
    if [ "$LINES" -gt 200 ]; then
      LARGE_STATES="$LARGE_STATES $f($LINES lines)"
    fi
  done
  if [ -z "$LARGE_STATES" ]; then
    check "state-under-200-lines" "pass"
  else
    check "state-under-200-lines" "fail" "$LARGE_STATES"
  fi
else
  check "state-under-200-lines" "pass" "(no lib/state/ dir)"
fi

# --- 4. 1:1 file-to-test ratio ---
# Count production files (excluding generated/theme/l10n/main)
PROD_COUNT=0
MISSING_TESTS=""
for dir in lib/widgets lib/screens lib/state lib/models lib/domain lib/services/impl; do
  [ -d "$dir" ] || continue
  for f in $(find "$dir" -name "*.dart" -not -name "*.g.dart"); do
    PROD_COUNT=$((PROD_COUNT + 1))
    # Derive expected test path
    REL="${f#lib/}"
    TEST_FILE="test/${REL%.dart}_test.dart"
    if [ ! -f "$TEST_FILE" ]; then
      MISSING_TESTS="$MISSING_TESTS $TEST_FILE"
    fi
  done
done

TEST_COUNT=$(find test/ -name "*_test.dart" 2>/dev/null | wc -l | tr -d ' ')

if [ -z "$MISSING_TESTS" ]; then
  check "1-to-1-test-ratio" "pass" "($PROD_COUNT prod, $TEST_COUNT tests)"
else
  check "1-to-1-test-ratio" "fail" "missing:$MISSING_TESTS"
fi

# --- 5. No hardcoded user-facing strings (heuristic) ---
# Look for Text('...' or Text("..." patterns not using AppLocalizations
HARDCODED=$(grep -rn "Text(['\"]" lib/screens/ lib/widgets/ 2>/dev/null | grep -v "Key(" | grep -v "AppLocalizations" | grep -v "//" | grep -v "_test.dart" || true)
if [ -z "$HARDCODED" ]; then
  check "no-hardcoded-strings" "pass"
else
  check "no-hardcoded-strings" "fail" "$(echo "$HARDCODED" | wc -l | tr -d ' ') occurrences (first: $(echo "$HARDCODED" | head -1))"
fi

# --- 6. State does not return localized strings ---
LOCALIZED_IN_STATE=$(grep -rn "AppLocalizations\|\.of(context)" lib/state/ 2>/dev/null || true)
if [ -z "$LOCALIZED_IN_STATE" ]; then
  check "state-no-localization" "pass"
else
  check "state-no-localization" "fail" "$(echo "$LOCALIZED_IN_STATE" | head -3)"
fi

# --- 7. Service interfaces exist for implementations ---
if [ -d "lib/services/impl" ]; then
  ORPHAN_IMPLS=""
  for impl in lib/services/impl/*.dart; do
    [ -f "$impl" ] || continue
    BASE=$(basename "$impl" | sed 's/_impl\.dart/.dart/')
    if [ ! -f "lib/services/$BASE" ]; then
      ORPHAN_IMPLS="$ORPHAN_IMPLS $impl"
    fi
  done
  if [ -z "$ORPHAN_IMPLS" ]; then
    check "service-interfaces-exist" "pass"
  else
    check "service-interfaces-exist" "fail" "no interface for:$ORPHAN_IMPLS"
  fi
fi

# --- 8. Integration tests exist for each screen ---
if [ -d "lib/screens" ] && [ -d "integration_test" ]; then
  MISSING_E2E=""
  for screen in lib/screens/*_screen.dart; do
    [ -f "$screen" ] || continue
    BASE=$(basename "$screen" _screen.dart)
    E2E_FILE="integration_test/${BASE}_flow_test.dart"
    if [ ! -f "$E2E_FILE" ]; then
      MISSING_E2E="$MISSING_E2E $E2E_FILE"
    elif ! grep -q "${BASE}_flow_test\|${BASE}/" integration_test/app_test.dart 2>/dev/null; then
      MISSING_E2E="$MISSING_E2E ${E2E_FILE}(not imported in app_test.dart)"
    fi
  done
  if [ -z "$MISSING_E2E" ]; then
    check "e2e-tests-per-screen" "pass"
  else
    check "e2e-tests-per-screen" "fail" "missing:$MISSING_E2E"
  fi

  # Run integration tests
  E2E_OUTPUT=$(flutter test integration_test/app_test.dart 2>&1 || true)
  if echo "$E2E_OUTPUT" | grep -q "All tests passed"; then
    E2E_COUNT=$(echo "$E2E_OUTPUT" | grep -oE "\+[0-9]+" | tail -1 | tr -d '+')
    check "e2e-tests-pass" "pass" "($E2E_COUNT tests)"
  else
    FAIL_SUMMARY=$(echo "$E2E_OUTPUT" | grep -E "FAILED|Some tests failed" | head -3)
    check "e2e-tests-pass" "fail" "integration tests failed — $FAIL_SUMMARY"
  fi
fi

# --- 9. Coverage report exists ---
if [ -f "coverage/lcov.info" ]; then
  if [ -f "coverage/html/index.html" ]; then
    check "coverage-report" "pass"
  else
    check "coverage-report" "fail" "coverage/html/index.html missing — run: genhtml coverage/lcov.info --output-directory coverage/html"
  fi
else
  check "coverage-report" "fail" "coverage/lcov.info missing — run: flutter test --coverage"
fi

# --- 9. App compiles (flutter analyze) ---
ANALYZE_OUTPUT=$(flutter analyze 2>&1 || true)
if echo "$ANALYZE_OUTPUT" | grep -q "No issues found"; then
  check "app-compiles" "pass"
else
  ERRORS=$(echo "$ANALYZE_OUTPUT" | grep -c "error •" || true)
  WARNINGS=$(echo "$ANALYZE_OUTPUT" | grep -c "warning •" || true)
  if [ "$ERRORS" -gt 0 ]; then
    check "app-compiles" "fail" "$ERRORS errors, $WARNINGS warnings (first: $(echo "$ANALYZE_OUTPUT" | grep "error •" | head -1))"
  else
    check "app-compiles" "pass" "($WARNINGS warnings)"
  fi
fi

# --- Summary ---
echo ""
echo "=== Summary ==="
TOTAL=$((PASS + FAIL))
echo "  $PASS/$TOTAL checks passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  echo ""
  echo "=== Violations ==="
  echo -e "$VIOLATIONS"
  exit 1
else
  echo "  STATUS: ALL CHECKS PASSED"
  exit 0
fi
