# DESIGN_CONTRACT — Updated

## Purpose
Define minimum quality and completeness for `design.json` produced from a snapshot.

## Pass/Fail Criteria
- **Coverage**: `qa.coverageRatio == 1.0`.
- **Measurements**: all components have integer `bbox` AND `sourceRect` (no `unknown`).
- **A11y**: interactive components have `a11y.ariaLabel`.
- **Colors**: every color used in styles exists in `tokens.colors` (no stray hex).
- **Semantics (IT3)**: presence of the following when visually applicable:
  - `variant` on `Button`/`IconButton`.
  - `placement` + `widthMode` for non-fullwidth actions inside groups.
  - `group.alignment`, `group.distribution`, optional `group.maxWidth`.
  - `typographyRef` and `style.transform` for label casing.
  - `leadingIcon` when an icon is visually paired with a label.
- **Confidence**: `qa.confidenceGlobal ≥ 0.85` (configurable). If below, generation may proceed only in **degraded** mode with a warning.

## Deliverables
- Single valid JSON (`UTF‑8`), no comments or extra text.
- `qa` section includes `assumptions` per estimation with confidence ∈ [0.6;0.9].
