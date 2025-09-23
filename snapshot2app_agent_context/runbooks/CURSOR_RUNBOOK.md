# Runbook – Cursor

1. Open `examples/quick_start_timer/` (or the relevant screen folder in your project).
2. Run `00_ORCHESTRATOR.prompt` with system context set to repository root.
3. Feed `01_VALIDATE_DESIGN.prompt` → produce `reports/validation_report.md`.
4. If spec exists, skip `02_GENERATE_SPEC.prompt`. Else, run it.
5. Run `03_PLAN_BUILD.prompt` to emit `plan.md` (no code yet).
6. Run `04_BUILD_SCREEN.prompt` to generate files.
7. Run `05_EVALUATE_OUTPUT.prompt` and fix issues iteratively.
