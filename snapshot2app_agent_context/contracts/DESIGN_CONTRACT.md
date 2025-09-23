# Design Contract – mini‑Figma enriched (v2)

**Goal:** Ensure `design.json` is exhaustive, measurable, and deterministic.

## Mandatory Top-Level Keys
- `meta`, `tokens`, `screen`, `components`, `qa`

## Component-Level Requirements
- `id` (kebab or fixed from extractor): deterministic, stable
- `type`: one of allowed primitives (Text, Button, Icon, IconButton, Slider, Container, Card, Image, Input, Divider, etc.)
- `bbox` and `sourceRect`: `[x,y,width,height]` integers (px)
- `style`: explicit colors (hex), typography refs, radius, spacing
- `layout`: `type` (flex/grid/absolute), direction, gap, align, justify
- `a11y.ariaLabel` for interactive components
- Texts **verbatim** (accents, punctuation, spaces)

## QA Fields (must exist)
- `qa.inventory` ordered top-left → bottom-right
- `qa.countsByType`
- `qa.textCoverage.found/missing`
- `qa.colorsUsed`
- `qa.assumptions` (with confidence ∈ [0.6;0.9]) for any estimate
- `qa.coverageRatio` ≥ 1.0 and `qa.confidenceGlobal` ≥ 0.85

## Failure Modes (abort generation)
- Missing any mandatory top-level key
- `bbox` or `sourceRect` with non-integers or negative
- `coverageRatio` < 1.0 or `textCoverage.missing` non-empty
- Interactive components without `a11y.ariaLabel`
