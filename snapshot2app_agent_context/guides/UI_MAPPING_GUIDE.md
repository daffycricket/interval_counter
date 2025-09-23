# UI Mapping Guide – mini‑Figma → Flutter (conceptual)

**Purpose:** Convert `components[]` into Flutter widgets consistently (**no code here**).

## General
- Use tokens for colors/typography/spacing.
- Generate a `Key('<screen>__<component-id>')` per component for testability.
- Stick to composition: split reusable patterns (rows, cards).

## Primitive mappings (conceptual)
- `Text` → `Text` with style from `style.typographyRef` (title/label/body)
- `Button` → Elevated/Outlined (depending on `style.backgroundColor` vs ghost)
- `IconButton` → `IconButton` with semantic label from `a11y.ariaLabel`
- `Slider` → Material `Slider` with active/inactive/trackHeight
- `Container`/`Card` → `Container`/`Card` with padding/radius/shadow
- Lists of cards → `ListView` or `Column` + `SingleChildScrollView`

## Layout
- `layout.type=flex` + `direction` → Row/Column
- `gap` → `SizedBox` spacers using token spacing
- `align`/`justify` → MainAxis/CrossAxis alignment

## Accessibility
- Map `a11y.ariaLabel` to `Semantics(label: ...)` and tooltips where relevant.
