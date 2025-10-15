# UI Mapping Guide
Audience: Builder, Planner, Test runner

## Principles
- Single source of truth for **rendering rules**.
- Each rule has a **stable ID** used in `plan.md` (`buildStrategy` column).
- No prose outside rule definitions; deterministic behavior only.

---

## Rule Index
- rule:text/transform
- rule:button/cta
- rule:button/primary
- rule:button/secondary
- rule:button/ghost
- rule:iconButton/shaped
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

## rule:text/transform
**Input**: `node.text`, `node.style.transform`, `tokens.typography`, `node.typographyRef`  
**Output**: `Text` widget with transformed copy and resolved style.  
**Deterministic Steps**:
1. `copy = applyTransform(node.text, node.style?.transform or "none")`
2. `style = resolveTextStyle(node.typographyRef, tokens) // no substitutions`
3. `return Text(copy, key: Key('{screenId}__{node.id}'), style: style)`

---

## rule:button/cta
**When** `node.type == "Button" && node.variant == "cta"`  
**Map to** `ElevatedButton` (or `.icon` if `leadingIcon` present)  
**Colors**: `bg = tokens.colors.cta or tokens.colors.primary`; `fg = tokens.colors.onPrimary`  
**Deterministic Steps**:
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
- Every widget uses `Key('{screenId}__{node.id}')` for stability and testing.  
- Apply on all **interactive** and **test-targeted** widgets at minimum.
- Decorative nodes that are intentionally kept (e.g., `role:"indicator"`) must still receive a stable key; otherwise filtered out nodes are **not** keyed.

---

## rule:pattern/valueControl
When:
- A horizontal `Row` or `Frame` contains **exactly three children** ordered as:
  1. icon or button “−”
  2. text-like element (value or label)
  3. icon or button “+”
- All items share the same vertical alignment (baseline or center)

Then:
- Map to existing widget `ValueControl` (import from `lib/widgets/value_control.dart`)
- Main props:
  - `label`: middle title,
  - `value`: middle child text
  - `onIncrease`, `onDecrease`: inherited from the actions
  - `decreaseKey`, `valueKey`, `increaseKey`, `decreaseKey`: `{screenId}__{type}-{index}`
  - `decreaseSemanticLabel`, `increaseSemanticLabel`: semantic labels
- Do **not** generate a new widget
- Mark `buildStrategy: rule:pattern/customStepper`


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

---

## rule:font/size
1. Always use the characteristics below for the fonts you identify
2. If possible, infer the other font charasterics using these as a reference
3. Never override a predefined style with specific characteristics, such as fontSize or fontWeight. If no predefined style corresponds exactly to the text at hand, choose the one whose font whose size is the closest to the text at hand :
  - forbidden to override font style with `style: AppTextStyles.title.copyWith(fontSize: 16)`
  - stick always with `style: AppTextStyles.titleLarge`


Font characteristics : 
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

**Example**:
```dart
Card(
  key: Key('{screenId}__{node.id}'),
  color: node.style.backgroundColor ?? AppColors.surface,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(2),
    side: BorderSide(
      color: node.style.borderColor ?? AppColors.divider,
      width: node.style.borderWidth ?? 1,
    ),
  ),
  margin: const EdgeInsets.symmetric(horizontal: 6),
  child: Padding(
    padding: const EdgeInsets.all(12)
      child: node.hasInteractiveChild 
      ? InkWell(
          onTap: handler,
          borderRadius: BorderRadius.circular(2),
          child: content,
        )
      : content,
  )
)
```

---

## rule:keys/testable

**For all interactive widgets:**
- Apply stable key: `Key('{screenId}__{node.id}')`
- Key must match plan.md component ID
- Never generate random or dynamic keys
- Keys enable deterministic testing with find.byKey()

**Interactive components requiring keys:**
- Button, IconButton, TextButton, ElevatedButton, OutlinedButton
- TextField, TextFormField
- Slider
- Switch, Checkbox, Radio
- Card (if has onTap/onPressed)
- InkWell, GestureDetector
- Any widget with callbacks (onPressed, onChange, onTap, etc.)

**Deterministic Steps:**
1. Extract `node.id` from design.json component
2. Extract `screenId` from design.json meta or spec.md
3. Generate: `key: Key('{screenId}__{node.id}')`
4. Record in plan.md Widget Breakdown for test generation reference
5. Never use: `find.text()` or `find.byType()` in tests (fragile, breaks on i18n/refactor)
6. Always use: `find.byKey(const Key('specific_id'))` in tests (deterministic)

**For non-interactive components:**
- Keys optional (use only if test needs to verify by key)
- Text widgets: key if test verifies specific text instance
- Icon widgets: key if test verifies specific icon instance
- Container/Padding/Decoration: usually not keyed

**Rationale:**
- ✅ Tests are deterministic and survive text changes (i18n)
- ✅ Tests are precise (target specific widget, not first match)
- ✅ Tests are maintainable (key stays stable, implementation can change)
- ✅ Aligns with Flutter testing best practices

---

## Implementation Notes (non-normative)
- `resolveTextStyle(ref, tokens)` must be a pure function (no runtime randomness).
- Avoid implicit animations unless specified by `spec.md`.
- Any missing token/color/style ⇒ build must fail (guardrail).

---

## Test Hints
For each rule, provide at least one widget test ensuring:
- deterministic key (via rule:keys/testable),  
- mapping to expected widget class,  
- correct theme resolution,  
- behavior hooks present when applicable.
