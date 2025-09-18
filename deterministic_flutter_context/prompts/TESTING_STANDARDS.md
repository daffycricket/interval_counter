# TESTING_STANDARDS.md — Strategy & Rules

## Pyramid
- Unit (TU): 60–70% — pure logic & controllers.
- Integration (TI): 20–30% — widgets/flows with mocks.
- E2E: 5–10% — critical journeys only.

## Rules
- No I/O in tests — use stubs/mocks/fakes.
- Deterministic: fixed seeds/clock; no sleeps (wait for conditions).
- Names: `should_doX_when_Y`.

## Unit
- Test controllers/use cases. Assert state transitions & outputs.

## Integration (widget)
- Pump screens with mocked deps; assert key texts (from design), tap/click changes.

## Golden (optional)
- Fix DPR & size; embed fonts; store under `test/goldens/`.

## E2E
- Tool of the stack (Flutter `integration_test`, Appium, Detox…). Cover smoke & core flows.
