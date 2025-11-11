# Snapshot2App – Agent Context Pack

**Purpose:** Provide deterministic, tool-agnostic context so an agent (Cursor, Cline, Claude Code, etc.) can
generate a Flutter app **screen-by-screen** from:
- a design file (`design.json`, *mini‑Figma enriched*) and
- a functional spec (`spec.md`).

This pack contains: prompts, mapping guides, best practices, evaluation rubrics, runbooks, CI templates, and guardrails.
It **does not** contain generated Flutter code. Agents will consume these files and produce code in the project
workspace under `lib/`, `test/`, etc.

> Canonical example inputs in `examples/home/` come from the user’s latest files for the **quick_start_timer** screen.

## Golden Rules
1. **Determinism over creativity**: follow schema + mapping, no invention without an explicit assumption entry.
2. **Separation of concerns**: context files guide, agent generates code.
3. **One-screen increments**: treat each screen independently; share tokens and navigation only via explicit specs.
4. **Traceability**: every change is linked back to design/spec; produce an `agent_report.md` per run.

## Typical Flow (per screen)
1. Validate `design.json` against `schema/minifigma.schema.json` and the **Design Contract** checklist.
2. Read `spec.md` and derive **behavioral contracts** (validation rules, actions, navigation).
3. Plan the file diff (no code yet): list widgets, state endpoints, keys, and tests to generate.
4. Generate code (by the agent) in a separate step, using these contracts and the mapping guide.
5. Run the Evaluation rubric and produce `agent_report.md`.

See `runbooks/` for detailed step-by-step playbooks per tool.

## Typical commands for the agent


### Buid screen from scratch (eg, first screen)
Run 00_ORCHESTRATOR.prompt
Input: design.json: sources/home/home_design.json
Report folder: reports/home

### Build screen, starting at specific step
#### It allows the user to edit generated files manually before carrying on
Run 00_ORCHESTRATOR.prompt, starting step 02 and up to the last step
Inputs:
 - design.json: sources/home/home_design.json
 - spec_complement.md: sources/home/home_spec_complement.md
 - validation_report.md in reports/home
Report folder: reports/home

### Build screen, starting at specific step
#### It allows the user to edit generated files manually before carrying on
Run 00_ORCHESTRATOR.prompt, starting step 03 and up to the last step
Inputs:
 - design.json: sources/home/home_design.json
 - validation_report.md ans spec.md in reports/home
Report folder: reports/home

### Build new screen, using previous screen generation as reference
Run 00_ORCHESTRATOR.prompt
Inputs:
 - design.json: sources/new_preset/preset_editor_design_simple.json
 - spec_complement.md: sources/new_preset/preset_editor_design_simple_spec_complement.md
Refer to code already present in lib/ directory as a reference.
Report folder: reports/new_preset

### Generate spec, using code already generated as reference
Run 00_ORCHESTRATOR.prompt, up to step 2 "Generate Specification"
Inputs:
 - design.json: sources/workout/workout_design.json
 - spec_complement.md: sources/workout/workout_spec_complement.md
Refer to :
 - code already present in lib/ directory as a reference, especially existing widgets
 - existing specification if necessary, especially Home spec in reports/home/spec.md
Report folder: reports/workout

### Start with build plan up to the build phase, using code already generated as reference
Run 00_ORCHESTRATOR.prompt, from step 2 "Generate Specification" up to step 4 "Build Screen"
Inputs:
 - design.json: sources/workout/workout_design.json
 - spec.md: reports/workout/spec.md
Refer to code already present in lib/ directory as a reference, especially existing widgets, styles and theme
Report folder: reports/workout


### Generate spec, using code already generated as reference
Run 00_ORCHESTRATOR.prompt
Inputs:
 - design.json: sources/workout/workout_design.json
 - spec_complement.md: sources/workout/workout_spec_complement.md
Refer to :
 - code already present in lib/ directory as a reference, especially existing widgets, styles and theme
 - existing specification if necessary, especially Home spec in reports/home/spec.md
Report folder: reports/workout


### Generate spec, using code already generated as reference
### => used for fully refactoring Workout state after iteration #1 (iteration #1 bis)
Run 00_ORCHESTRATOR.prompt starting step 2 "Generate spec" up to the last step
For plan, build and test steps, keep existing workout layouts and views (screen, widgets), refactor state and business logic to match ARCHITECTURE_CONTRACT.md.
Inputs:
 - design.json: sources/workout/workout_design.json
 - spec_complement.md: sources/workout/workout_spec_complement.md
 - existing workout screen code and workout widgets in lib/screens and lib/widgets/workout
Refer to :
 - code already present in lib/ directory as a reference, especially existing widgets, styles and theme
 - existing specification if necessary, especially Home spec in reports/home/spec.md
Report folder: reports/workout_refacor
If steps or actions are note clear, please ask me 2 to 5 questions before starting.

### Generate spec, using code already generated as reference
### => used for refactoring Workout screen - internationalisation, tests, new rules in spec (iteration #2)
Run 00_ORCHESTRATOR.prompt starting step 2 "Generate spec" up to the last step
For plan, build and test steps : 
1. keep most existing workout layouts and views (screen, widgets) ; refactor WorkoutScreen to reuse VolumeHeader from Home screen and make it a generic widget in /lib/widgets/volume_header.dart,
2. refactor state and business logic to match ARCHITECTURE_CONTRACT.md,
3. refactor tests accordingly.
Inputs:
 - design.json: sources/workout/workout_design.json
 - spec_complement.md: sources/workout/workout_spec_complement.md
 - existing workout screen code and workout widgets in lib/screens and lib/widgets/workout
Refer to :
 - code already present in lib/ directory as a reference, especially existing widgets, styles and theme
 - existing specification if necessary, especially Home spec in reports/home/spec.md
Report folder: reports/workout_refactor_18ln_volume-header
If steps or actions are note clear, please ask me 2 to 5 questions before starting.

### Generate workout spec, workout business objects, workout tests but keep all the views
Run 00_ORCHESTRATOR.prompt starting step 2 "Generate spec" up to the last step
For plan, build and test steps : 
1. keep all existing workout views (screen, widgets), do not modify the views
2. build workout state, business logic, business objects and tests ; adapt widgets to these news objects ; match requirements in ARCHITECTURE_CONTRACT.md, PROJECT_CONTRACT.md and TEST_CONTRACT.md
Inputs:
 - design.json: sources/workout/workout_design.json
 - spec_complement.md: sources/workout/workout_spec_complement.md
 - existing workout widgets in lib/screens/workout_screen.dart and lib/widgets/workout/
Refer to :
 - code already present in lib/ directory as a reference, especially existing widgets, styles and theme
 - existing specification if necessary, especially Home spec in reports/home/spec.md
Report folder: reports/workout_refactor_it3
If steps or actions are note clear, please ask me 2 to 5 questions before starting.