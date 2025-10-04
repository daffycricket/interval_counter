# Snapshot2App – Agent Context Pack

**Purpose:** Provide deterministic, tool-agnostic context so an agent (Cursor, Cline, Claude Code, etc.) can
generate a Flutter app **screen-by-screen** from:
- a design file (`design.json`, *mini‑Figma enriched*) and
- a functional spec (`spec.md`).

This pack contains: prompts, mapping guides, evaluation rubrics, runbooks, CI templates, and guardrails.
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
5. Run the Evaluation rubric and produce `reports/agent_report.md`.

See `runbooks/` for detailed step-by-step playbooks per tool.
