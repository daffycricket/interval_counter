# CLAUDE.md

## Project

**Interval Counter** — Flutter app for interval training workouts (timers, reps, work/rest/cooldown phases, audio cues). Also serves as a test bench for the **snapshot2app** pipeline: an agent-driven workflow that generates Flutter screens from JSON design specs.

Screens: Home (preset config), PresetEditor, Workout (session execution).

## Environment

- **Flutter:** 3.38.3 (stable) — Dart 3.10.1
- **Localization:** generated in `lib/l10n/` via `output-dir: lib/l10n` in `l10n.yaml`. Import: `package:interval_counter/l10n/app_localizations.dart`. **Never** use `package:flutter_gen/gen_l10n/...` (removed in Flutter 3.27+). If missing, run `flutter gen-l10n`.
- **State management:** Provider + ChangeNotifier exclusively. No BLoC/Riverpod/GetX.

## Commands

```bash
flutter run                    # Run app
flutter test                   # Run all tests
flutter test --coverage        # Tests + coverage
flutter analyze                # Lint
flutter gen-l10n               # Regenerate localization files
flutter pub get                # Get dependencies
```

## Architecture (quick reference)

All rules in `snapshot2app_agent_context/contracts/`:
- **CODE_CONTRACT.md** — File organization, layers, state pattern, naming, DI, widget decomposition
- **TEST_CONTRACT.md** — Coverage thresholds, test types, conventions
- **DESIGN_CONTRACT.md** — design.json quality criteria
- **SPEC_CONTRACT.md** — Functional spec completeness

Key constraints:
- State as thin coordinator: <200 lines, ≤5 deps, injects service interfaces
- Domain layer (`lib/domain/`): pure Dart, no Flutter imports
- No hardcoded UI strings — use `AppLocalizations.of(context)`
- Tests mirror `lib/` structure 1:1. State/Model/Domain = 100% coverage.

## Snapshot2App Pipeline

Context files in `snapshot2app_agent_context/`:
```
prompts/      00_ORCHESTRATOR → 07_EVALUATE (7 steps)
contracts/    CODE_CONTRACT, TEST_CONTRACT, DESIGN_CONTRACT, SPEC_CONTRACT
guides/       UI_MAPPING_GUIDE, BEST_PRACTICES
guards/       GUARDRAILS (G-01 to G-18), FAILURE_TAXONOMY
templates/    spec_template, plan_template, validation_report, agent_report
schema/       minifigma.schema.json
sources/      Design JSON + spec complements per screen
```

See `snapshot2app_agent_context/README.md` for usage commands and workflow history.
