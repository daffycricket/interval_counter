# UI Mapping Guide
Audience: Builder, Planner, Test runner

## Principles
- Single source of truth for **rendering rules**.
- Each rule has a **stable ID** used in `plan.md` (`buildStrategy` column).
- No prose outside rule definitions; deterministic behavior only.

---

## Rule Index
- rule:theme/resolve
- rule:text/transform
- rule:button/cta
- rule:button/primary
- rule:button/secondary
- rule:button/ghost
- rule:iconButton/shaped
- rule:iconButton/size
- rule:layout/placement
- rule:layout/widthMode
- rule:group/alignment
- rule:group/maxWidth
- rule:group/distribution
- rule:slider/theme
- rule:slider/normalizeSiblings
- rule:icon/resolve
- rule:keys/stable
- rule:pattern/valueControl
- rule:card/style
- rule:font/size

---

## rule:theme/resolve
**Input**: `tokens.colors`, `tokens.typography`
**Output**: `ThemeData` built exclusively from tokens — never guess colors or font sizes.

**Typography mapping** (`typographyRef` → `TextTheme`):

| typographyRef | Maps to                   | Notes |
|---|---|---|
| `titleLarge`  | `textTheme.titleLarge`    | weight via `fontWeight` |
| `title`       | `textTheme.titleMedium`   |  |
| `subtitle`    | `textTheme.titleSmall`    |  |
| `label`       | `textTheme.labelLarge`    |  |
| `body`        | `textTheme.bodyMedium`    |  |
| `muted`       | `textTheme.bodySmall`     | reduced contrast |
| `value`       | `textTheme.headlineSmall` | numeric/time values |

---

## rule:text/transform
**Input**: `node.text`, `node.style.transform`, `tokens.typography`, `node.typographyRef`
**Output**: `Text` widget with transformed copy and resolved style.
**Deterministic Steps**:
1. `copy = applyTransform(node.text, node.style?.transform or "none")`
2. `style = resolveTextStyle(node.typographyRef, tokens)`
3. `return Text(copy, key: Key('{screenId}__{node.id}'), style: style)`

```dart
String applyTransform(String s, String? transform) {
  switch (transform) {
    case "uppercase": return s.toUpperCase();
    case "lowercase": return s.toLowerCase();
    default: return s;
  }
}
```

---

## rule:button/cta
**When** `node.type == "Button" && node.variant == "cta"`
**Map to** `ElevatedButton` (or `.icon` if `leadingIcon` present)
**Colors**: `bg = tokens.colors.cta or tokens.colors.primary`; `fg = tokens.colors.onPrimary`
**Steps**:
1. `child = node.leadingIcon ? Row(Icon(resolveIconData), Text(copy)) : Text(copy)`
2. Return `ElevatedButton(style: bg/fg from tokens, onPressed: handler, child: child)`

---

## rule:button/primary
Same as CTA but **bg = tokens.colors.primary**, **fg = tokens.colors.onPrimary**.

---

## rule:button/secondary
Map to `OutlinedButton`.
**Border**: `color = node.style.borderColor or tokens.colors.border`; `width = node.style.borderWidth or 1`.

---

## rule:button/ghost
Map to `TextButton`.
**Foreground**: `node.style.color or colorScheme.primary`.

---

## rule:iconButton/shaped
- If shape attributes present (`style.radius` and/or `style.borderWidth`/`borderColor`), wrap `IconButton` in a `Container` with decoration enforcing size/border/radius.
- Do not render `IconButton` if `iconName` is missing. Treat as validation error.

```dart
Widget shapedIconButton(Comp c, Tokens t) {
  final size = (c.bbox?.height ?? 36).toDouble();
  return Container(
    width: size, height: size,
    decoration: BoxDecoration(
      color: c.style.backgroundColorOr(Colors.transparent),
      border: (c.style.borderWidth ?? 0) > 0
        ? Border.all(color: c.style.borderColorOr(t.color("border")),
                     width: (c.style.borderWidth ?? 1).toDouble())
        : null,
      borderRadius: BorderRadius.circular(t.radius(c.style.radius)),
    ),
    child: IconButton(onPressed: (){}, icon: buildIcon(c, t), splashRadius: size/2),
  );
}
```

---

## rule:iconButton/size
**Purpose**: Derive `iconSize` from design.json bbox so icons render at the intended visual size.
**Deterministic Steps**:
1. If the `IconButton` node has a child `Icon` with its own `bbox` → `iconSize = childIcon.bbox[3]` (height)
2. Else → `iconSize = (node.bbox[3] * 0.5).round()` (50% of container height)
3. Pass `iconSize` to `IconButton(iconSize: ...)` or `Icon(size: ...)`

```dart
double resolveIconSize(Comp iconButton) {
  final iconChild = iconButton.children?.firstWhereOrNull((c) => c.type == "Icon");
  if (iconChild != null && iconChild.bbox != null) {
    return iconChild.bbox![3].toDouble();
  }
  return ((iconButton.bbox?[3] ?? 48) * 0.5).roundToDouble();
}
```

---

## rule:layout/widthMode
- `fill` → wrap with `Expanded`
- `hug` (intrinsic) → size to content
- `fixed` → use `SizedBox(width: node.size.w, height: node.size.h)` when provided

---

## rule:layout/placement
Inside the parent axis:
- `start|center|end` → `Align(alignment: Alignment.(centerLeft|center|centerRight))`
- `stretch` → expand to max cross-axis (`Expanded`/`SizedBox.expand` per parent constraints)

```dart
Widget place(Widget w, Comp c) {
  final placed = switch (c.placement) {
    "end" => Align(alignment: Alignment.centerRight, child: w),
    "center" => Align(alignment: Alignment.center, child: w),
    "stretch" => Align(alignment: Alignment.centerLeft, child: SizedBox.expand(child: w)),
    _ => Align(alignment: Alignment.centerLeft, child: w),
  };
  return c.widthMode == "hug" ? placed : Expanded(child: placed);
}
```

---

## rule:group/alignment
For containers/cards with a `group` block:
- `alignment: "center"` → wrap with `Center`
- `alignment: "end"` → `Align(alignment: Alignment.centerRight)`

---

## rule:group/maxWidth
If `group.maxWidth > 0` → `ConstrainedBox(BoxConstraints(maxWidth: ...))` around the group container.

---

## rule:group/distribution
Map to `MainAxisAlignment`:
- `start` → `start`
- `center` → `center`
- `spaceBetween` → `spaceBetween`
- `spaceAround` → `spaceAround`
- `end` → `end`

---

## rule:slider/theme
- Use a `SliderTheme` where available.
- `activeTrack`, `inactiveTrack`, `thumbColor`, `trackHeight` from `node.style` if provided.
- Initial `value` from `valueNormalized` in [0,1] when present.
- Set track height to 1 `trackHeight: 1`.
- Set `trackShape: RectangularSliderTrackShape()`.
- The thumb must **never** be rendered by a separate Icon/Container.
- Any visual thumb customization must go through `SliderThemeData` (thumb/track colors, trackHeight).
- When a sibling matches a likely-thumb pattern (square-ish bbox, diameter within [thumb−2; thumb+6], color in {`sliderThumb`, `onPrimary`, `#FFFFFF`}, within 24 px of the slider end), it must be **ignored** at build time and flagged during validation.

---

## rule:slider/normalizeSiblings
  - In a `Row` containing a `Slider`, drop non-interactive siblings that are solid circles (max border radius, no text, no `iconName` OR `iconName` equals `material.circle`) and color in {`sliderThumb`, `onPrimary`, `#FFFFFF`}.
  - Exception: keep only if `role == "indicator"` is explicitly set on the node.
  - Record the decision in plan.md `buildStrategy` as `rule:slider/normalizeSiblings(drop)`.

---

## rule:icon/resolve
- If `iconName` starts with `material.` → map to `Icons.*`
- Else → resolve via `IconRegistry` (project-defined).

---

## rule:keys/stable
**Purpose**: Deterministic, stable keys for testing and widget identity.
**Pattern**: `Key('{screenId}__{node.id}')`

**Applies to all interactive widgets:**
- Button, IconButton, TextButton, ElevatedButton, OutlinedButton
- TextField, TextFormField, Slider, Switch, Checkbox, Radio
- Card (if has onTap/onPressed), InkWell, GestureDetector
- Any widget with callbacks (onPressed, onChange, onTap, etc.)

**Also applies to:**
- Decorative nodes with `role:"indicator"` (intentionally kept)
- Text/Icon widgets only if tests verify specific instances

**Filtered-out nodes are NOT keyed.**

**Deterministic Steps**:
1. Extract `node.id` from design.json, `screenId` from meta
2. Generate: `key: Key('{screenId}__{node.id}')`
3. Record in plan.md Widget Breakdown for test reference
4. In tests: always `find.byKey(const Key('x'))` — never `find.text()` or `find.byType()`

---

## rule:pattern/valueControl
When:
- A horizontal `Row` or `Frame` contains **exactly three children** ordered as:
  1. icon or button "−"
  2. text-like element (value or label)
  3. icon or button "+"
- All items share the same vertical alignment (baseline or center)

Then:
- Map to existing widget `ValueControl` (import from `lib/widgets/value_control.dart`)
- Main props: `label`, `value`, `onIncrease`, `onDecrease`, `decreaseKey`, `valueKey`, `increaseKey`, `decreaseSemanticLabel`, `increaseSemanticLabel`
- Do **not** generate a new widget
- Mark `buildStrategy: rule:pattern/customStepper`

```dart
ValueControl(
  label: 'RÉPÉTITIONS',
  value: _reps.toString(),
  onDecrease: _onDecreaseReps,
  onIncrease: _onIncreaseReps,
  decreaseKey: 'interval_timer_home__IconButton-11',
  valueKey: 'interval_timer_home__Text-12',
  increaseKey: 'interval_timer_home__IconButton-13',
  decreaseSemanticLabel: 'Diminuer les répétitions',
  increaseSemanticLabel: 'Augmenter les répétitions',
  decreaseEnabled: _reps > _minReps,
  increaseEnabled: _reps < _maxReps,
),
```

---

## rule:font/size
1. Always use the characteristics below for the fonts you identify
2. If possible, infer the other font characteristics using these as a reference
3. Never override a predefined style with specific characteristics — always use the closest match:
  - forbidden: `style: AppTextStyles.title.copyWith(fontSize: 16)`
  - correct: `style: AppTextStyles.titleLarge`
4. If `typographyRef == "custom"` → do **not** use `AppTextStyles`. Build a raw `TextStyle` from `node.style.fontSize`, `node.style.fontWeight`, and `node.style.color`:
  - correct: `style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))`
  - forbidden: `style: AppTextStyles.titleLarge.copyWith(fontSize: 40)`

Font characteristics:
- titleLarge: fontSize = 22, fontWeight = FontWeight.bold, height: 1.4
- title: fontSize = 22, fontWeight = FontWeight.bold, height = 1.25
- label: fontSize = 14, fontWeight = FontWeight.w500, height = 1.33

---

## rule:card/style
**When** `node.type == "Card"`
**Map to** `Card` widget with standardized styling
**Deterministic Steps**:
1. Always set `elevation: 0`
2. Apply `shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))`
3. Apply `margin: const EdgeInsets.symmetric(horizontal: 6)`.
4. Apply `Padding(padding: const EdgeInsets.all(12)` to child within Card.
5. Use `node.style.backgroundColor` or `tokens.colors.surface` for `color`
6. Use `node.style.borderColor` or `tokens.colors.divider` for border color (width: 1)
7. If Card contains interactive child → wrap child with `InkWell(borderRadius: BorderRadius.circular(2))`

**Style override hierarchy**:
- Radius: always `2` (ignore `node.style.radius` or tokens)
- Elevation: always `0` (ignore `node.style.shadow`)
- Margin: always `6` and symmetric
- Padding for child: always `12`
- Border: use `node.style.borderColor/borderWidth` if present, else default `divider/1`

---

## Implementation Notes (non-normative)
- `resolveTextStyle(ref, tokens)` must be a pure function (no runtime randomness).
- Avoid implicit animations unless specified by `spec.md`.
- Any missing token/color/style ⇒ build must fail (guardrail).

---

## Test Hints
For each rule, provide at least one widget test ensuring:
- deterministic key (via rule:keys/stable),
- mapping to expected widget class,
- correct theme resolution,
- behavior hooks present when applicable.
