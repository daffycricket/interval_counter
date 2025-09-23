# Spec Contract – functional behaviors (v2)

**Objective:** Align generated code behavior to a stable, tool-agnostic spec.

## Spec must cover
- Identification: screen name, tech id
- Purpose & type
- Structure: sections/fields (inputs, buttons, lists)
- Actions: user intents and outcomes
- Validation rules and constraints
- Navigation: sources/targets
- Scenarios: nominal, alternative, exceptional
- Accessibility notes

## Agent obligations
- Do not infer missing rules silently. Surface `assumptions` and `openQuestions` in `reports/agent_report.md`.
- Apply validation strictly (e.g., formats like `mm:ss`).
- Keep state local unless the spec mandates persistence or services.
