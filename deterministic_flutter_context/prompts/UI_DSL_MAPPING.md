# UI_DSL_MAPPING.md — Deterministic Mapping (Design → Flutter static)

- `Text`       → `Text` with `TextStyle` from tokens.
- `Button`     → `FilledButton`/`ElevatedButton` (bg/fg from tokens/style), exact label.
- `IconButton` → `IconButton(Icon(Icons.*))`, tooltip/Semantics from aria.
- `Input`      → `TextField` (controller only if spec needs entry).
- `Slider`/`Checkbox`/`Radio`/`Switch` → Material widgets (init values only if spec states them).
- `Link`       → `TextButton`.
- `Container`  → `Row/Column/Container` + `SizedBox` gaps.
- `Card`       → `Container/Card` with `BoxDecoration` (bg/border/radius/shadow).
- `Image/Icon` → `Image.asset|network` / `Icon` (fallback `Icons.help_outline`).
- `Divider`    → `Divider`.
- **bbox** is ignored for layout (QA only). Use `layout + padding + gap` for structure.
- Unknown types → local `PlaceholderBox` (dotted border + id label). No invention.
