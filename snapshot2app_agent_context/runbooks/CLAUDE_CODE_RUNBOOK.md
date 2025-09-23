# Runbook – Claude Code

- Provide `prompts/00_ORCHESTRATOR.prompt` as system message.
- Paste `design.json` and `spec.md` (or point to `examples/...`).
- Ask Claude to output only the planned files list first (`plan.md`), then the code.
- Use the evaluation prompt to iterate until rubric passes.
