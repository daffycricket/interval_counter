# Snapshot2App — Agent Context Pack

Deterministic, tool-agnostic context for generating a Flutter app **screen-by-screen** from:
- a design file (`design.json`, mini-Figma enriched)
- a functional spec (`spec.md`)

Agents consume these files and produce code in `lib/`, `test/`, etc.

## Golden Rules
1. **Determinism over creativity** — follow schema + mapping, no invention without explicit assumption.
2. **Separation of concerns** — context files guide, agent generates code.
3. **One-screen increments** — each screen independently.
4. **Traceability** — every change linked to design/spec; produce `agent_report.md` per run.

## File Map

| Folder | Contents |
|---|---|
| `prompts/` | 00_ORCHESTRATOR through 07_EVALUATE |
| `contracts/` | CODE_CONTRACT, TEST_CONTRACT, DESIGN_CONTRACT, SPEC_CONTRACT |
| `guides/` | UI_MAPPING_GUIDE, BEST_PRACTICES |
| `guards/` | verify.sh (deterministic architecture checks) |
| `templates/` | spec_template, plan_template, validation_report, agent_report |
| `schema/` | minifigma.schema.json |
| `sources/` | Design JSON + spec complements per screen |
| `rubrics/` | EVALUATION_RUBRIC, PR_CHECKLIST |
| `runbooks/` | Per-tool instructions (Claude Code, Cursor, Cline) |

## Template Commands

### From scratch
```
Run 00_ORCHESTRATOR.prompt
Input: design.json: sources/{screen}/{screen}_design.json
Report folder: reports/{screen}
```

### Start at specific step (allows manual editing between steps)
```
Run 00_ORCHESTRATOR.prompt, starting step {N} up to last step
Inputs:
  - design.json: sources/{screen}/{screen}_design.json
  - Previously generated artifacts in reports/{screen}/
Report folder: reports/{screen}
```

### New screen using existing code as reference
```
Run 00_ORCHESTRATOR.prompt
Inputs:
  - design.json: sources/{screen}/{screen}_design.json
  - spec_complement.md: sources/{screen}/{screen}_spec_complement.md
Refer to code already present in lib/ as reference.
Report folder: reports/{screen}
```

### Refactor iteration (keep views, rebuild state/domain)
```
Run 00_ORCHESTRATOR.prompt starting step 2 up to last step
For plan, build and test: keep existing views, refactor state and business logic
to match CODE_CONTRACT.md and TEST_CONTRACT.md.
Inputs:
  - design.json: sources/{screen}/{screen}_design.json
  - spec_complement.md: sources/{screen}/{screen}_spec_complement.md
  - existing screen code in lib/screens/ and lib/widgets/{screen}/
Refer to code in lib/ as reference.
Report folder: reports/{screen}_refactor_{label}
If unclear, ask 2-5 questions before starting.
```

---

## Execution History

### Home screen
- **reports/home/** — Full pipeline, from scratch. All tests passing.

### PresetEditor screen
- **reports/new_preset/** — Mode Simple. 141/141 tests. Mode Advanced not yet implemented.

### Workout screen — 4 iterations
1. **reports/workout/** — First generation. 46/51 tests (5 layout overflow, cosmetic).
2. **reports/workout_refactor/** — Clean Architecture applied. Widget tests partially adapted.
3. **reports/workout_refactor_18ln_volume-header/** — VolumeHeader made generic + shared. 176/206 tests.
4. **reports/workout_refactor_it3/** — Full compliance: domain layer, StepType enum, 72/72 tests.
5. **reports/workout_refactor_it4/** — Iteration 4 planned but not completed (domain/state files missing on current branch).
