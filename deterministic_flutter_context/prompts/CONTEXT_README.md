# Project Context — Deterministic UI Build

## Goals
- Deterministic, reproducible builds of **static Flutter screens** from:
  - a design file (mini‑Figma JSON) and
  - a functional spec (Markdown).
- No runtime discovery of design; **everything is compiled into widgets**.
- No invented UI/logic: only what design/spec state.

## Repository layout
```
prompts/
  CONTEXT_README.md
  FLUTTER_STANDARDS.md
  PROJECT_ORGANIZATION.md
  UI_DSL_MAPPING.md
  ACCEPTANCE_CRITERIA.md
  TESTING_STANDARDS.md
  ARCHITECTURE_GUIDE.md
  TEMPLATE_BUILD_STATIC_SCREEN.prompt
  tasks/
    HOME_BUILD.prompt
schemas/
  minifigma.schema.json
design/
  home_design.json        # source of truth (not loaded at runtime)
specs/
  home_specification.md   # source of truth for behavior
lib/
  components/
  screens/
  theme/
  domain/
test/
  goldens/
  domain/
.tooling/
  llm_settings.json
  preflight.sh
  make_targets.sh
```

## Build protocol
1. **Preflight**
   - Validate `design/<screen>_design.json` against `schemas/minifigma.schema.json` (in CI).
   - Compute & log SHA256 for design + spec.
2. **Codegen (static)**
   - Read design/spec from workspace and **generate static code**:
     - `lib/screens/<screen>_screen.dart`
     - plus reusable components under `lib/components/**` if patterns repeat
3. **Lint & Tests**
   - `flutter analyze` clean.
   - Add/update tests under `test/**` (render + interaction if specified).
4. **Acceptance gates**
   - Schema valid, no diff beyond generated files, lint OK, tests green, no network calls.

## File naming & IDs
- Screens: `lib/screens/<screen>_screen.dart`, tests: `test/<screen>_screen_test.dart`.
- Components reusable → `lib/components/**` (public classes).
- Use component IDs from design for wiring & test finders.
