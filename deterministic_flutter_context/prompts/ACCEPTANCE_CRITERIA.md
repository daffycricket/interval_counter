# ACCEPTANCE_CRITERIA.md — PR Gates

- Visual fidelity: labels, hierarchy, widget types, colors match design.
- A11y: Semantics/Tooltip present when ariaLabel known.
- Reusables: repeated patterns extracted to `lib/components/**` with clear APIs.
- Static code: **no runtime I/O or JSON parsing**; tokens/styles as const.
- Quality: `dart analyze` clean; tests present & green.
- Scope: only files under `lib/components`, `lib/screens`, `lib/theme`, `lib/domain`, `test`.
