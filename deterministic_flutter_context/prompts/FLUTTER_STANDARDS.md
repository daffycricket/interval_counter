# FLUTTER_STANDARDS.md — Code Standards

- Flutter stable, null‑safety, `dart analyze` = 0 issues.
- **Static screens only**: no runtime JSON, no loaders, no codegen.
- Prefer `const` for tokens, styles, paddings; `final` for controllers.
- Small, focused widgets. `StatelessWidget` by default; `StatefulWidget` only if spec requires state.
- Extract **reusable components** to `lib/components/**` (public classes).
- Accessibility: map known `ariaLabel` to `Semantics(label: ...)` / `Tooltip(message: ...)`.
- Layout: `Row/Column` + `SizedBox` gaps; `Container/Card` + `BoxDecoration` (bg/border/radius/shadow).
- No external packages unless spec mandates; prefer SDK & Material.
- Tests mandatory: render tests; interaction tests if spec defines behavior.
