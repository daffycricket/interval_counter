# UI Mapping Guide — Updated (IT3-ready)

This guide describes how to map the **mini‑Figma enriched** `design.json` into Flutter widgets.
It **consumes** the new semantics introduced in IT3: `variant`, `placement`, `widthMode`, `group`, `typographyRef/transform`, and semantic color tokens (`cta`, `success`, `warning`, `info`, `headerBackgroundDark`).

---

## 1) Theme from tokens

Build `ThemeData` directly from `tokens` — do **not** guess colors or font sizes.

```dart
ThemeData buildTheme(DesignTokens t) {
  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: t.color("primary"),
    onPrimary: t.color("onPrimary"),
    surface: t.color("surface"),
    onSurface: t.color("textPrimary"),
    background: t.color("background"),
    onBackground: t.color("textPrimary"),
    secondary: t.colorOr("accent", t.color("primary")),
    onSecondary: t.color("onPrimary"),
    error: t.colorOr("warning", const Color(0xFFB00020)),
    onError: Colors.white,
  );

  return ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: t.color("background"),
    appBarTheme: AppBarTheme(
      backgroundColor: t.colorOr("headerBackgroundDark", colorScheme.primary),
      foregroundColor: t.color("onPrimary"),
      elevation: 0,
    ),
    textTheme: buildTextTheme(t),
    sliderTheme: SliderThemeData(
      activeTrackColor: t.color("sliderActive"),
      inactiveTrackColor: t.color("sliderInactive"),
      thumbColor: t.color("sliderThumb"),
      trackHeight: t.doubleOr("sliderTrackHeight", 4),
    ),
    useMaterial3: false,
  );
}
```

### Text theme mapping
`typographyRef` must resolve to the text style below; apply `transform` in code (see §4).

| typographyRef | Maps to                  | Notes |
|---|---|---|
| `titleLarge`  | `textTheme.titleLarge`  | weight from `fontWeight` |
| `title`       | `textTheme.titleMedium` |  |
| `subtitle`    | `textTheme.titleSmall`  |  |
| `label`       | `textTheme.labelLarge`  |  |
| `body`        | `textTheme.bodyMedium`  |  |
| `muted`       | `textTheme.bodySmall`   | lower contrast |
| `value`       | `textTheme.headlineSmall` + optional monospace | numeric/time values |

---

## 2) Buttons by `variant`

Map variants **without screen‑specific rules**:

- `cta` → `ElevatedButton` (filled). Background = `tokens.colors.cta` (fallback: `primary`).  
- `primary` → `ElevatedButton` (filled). Background = `tokens.colors.primary`.  
- `secondary` → `OutlinedButton`. Border = `style.borderColor`/`tokens.colors.border`.  
- `ghost` → `TextButton`. Text color = `style.color` or `colorScheme.primary`.

If `leadingIcon` exists, use the `.icon(...)` constructor and render the icon from `iconName`.

```dart
Widget buildButton(Comp c, Tokens t) {
  final child = c.leadingIcon != null
    ? _buttonChildWithIcon(c)
    : Text(applyTransform(c.text, c.style.transform));

  switch (c.variant) {
    case "cta":
      return ElevatedButton.icon(
        onPressed: (){},
        icon: buildIcon(c.leadingIcon, t),
        label: Text(applyTransform(c.text, c.style.transform)),
        style: ElevatedButton.styleFrom(
          backgroundColor: t.colorOr("cta", t.color("primary")),
          foregroundColor: t.color("onPrimary"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(t.radius(c.style.radius)),
          ),
        ),
      );
    case "primary":
      return ElevatedButton(
        onPressed: (){},
        style: ElevatedButton.styleFrom(
          backgroundColor: t.color("primary"),
          foregroundColor: t.color("onPrimary"),
        ),
        child: child,
      );
    case "secondary":
      return OutlinedButton(
        onPressed: (){},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: t.colorOr("border", t.color("primary")),
                           width: (c.style.borderWidth ?? 1).toDouble()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(t.radius(c.style.radius)),
          ),
        ),
        child: child,
      );
    default: // ghost
      return TextButton(
        onPressed: (){},
        style: TextButton.styleFrom(foregroundColor: c.style.colorOr(t.color("primary"))),
        child: child,
      );
  }
}
```

---

## 3) Placement & width

Use container widgets to honor `placement` & `widthMode` **inside the parent layout**:

```dart
Widget place(Widget w, Comp c) {
  final intrinsic = c.widthMode == "intrinsic";
  final placed = switch (c.placement) {
    "end" => Align(alignment: Alignment.centerRight, child: w),
    "center" => Align(alignment: Alignment.center, child: w),
    _ => Align(alignment: Alignment.centerLeft, child: w),
  };
  return intrinsic ? placed : Expanded(child: placed);
}
```

- `widthMode: fill` → wrap with `Expanded`.  
- `widthMode: intrinsic` → size to content (no `Expanded`).

---

## 4) Text `transform`

Apply transformation in code before building `Text`:

```dart
String applyTransform(String s, String? transform) {
  if (s == null) return "";
  switch (transform) {
    case "uppercase": return s.toUpperCase();
    case "lowercase": return s.toLowerCase();
    default: return s;
  }
}
```

---

## 5) Group alignment & maxWidth

When a container has `group.alignment:"center"` and optional `maxWidth`, center and constrain:

```dart
Widget groupWrap(Widget child, Group g) {
  Widget wrapped = child;
  if (g.maxWidth != null && g.maxWidth! > 0) {
    wrapped = ConstrainedBox(constraints: BoxConstraints(maxWidth: g.maxWidth!.toDouble()), child: wrapped);
  }
  return switch (g.alignment) {
    "center" => Center(child: wrapped),
    "end" => Align(alignment: Alignment.centerRight, child: wrapped),
    _ => wrapped,
  };
}
```

Within the row, honor `group.distribution` with `MainAxisAlignment.start|spaceBetween|spaceAround|end`.

---

## 6) IconButtons with shape

If `IconButton` carries `borderWidth/radius/size`, compose shape:

```dart
Widget shapedIconButton(Comp c, Tokens t) {
  final icon = buildIcon(c, t);
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
    child: IconButton(onPressed: (){}, icon: icon, splashRadius: size/2),
  );
}
```

---

## 7) Keys for testability

Every rendered component should get a stable `Key`:

```dart
Key compKey(Screen s, Comp c) => Key('${s.name}__${c.id}');
```

---

## 8) Guardrails

- If `qa.confidenceGlobal < 0.85`, emit a build warning (or stop if the contract requires it).  
- Never invent colors: any style color must map to `tokens.colors`.
