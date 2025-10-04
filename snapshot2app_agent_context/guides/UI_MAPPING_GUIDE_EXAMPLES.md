# UI Mapping Guide — Examples

> **Important — Non normatif**  
> La référence exécutable est **`UI_MAPPING_GUIDE`** (ruleset canonique avec IDs `rule:*`).  
> Ce document contient des **exemples pédagogiques** pour illustrer l'application des règles.

Ce guide montre comment mapper le **mini‑Figma enrichi** `design.json` vers des widgets Flutter **à titre d'exemple**.  

---

## 1) Theme from tokens
_Règles associées : `rule:theme/colorScheme`, `rule:typography/resolve`_

Construire `ThemeData` depuis `tokens` — **ne jamais deviner** les couleurs ou tailles de police.

```dart
ThemeData buildTheme(DesignTokens t) { // ex.
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
`typographyRef` doit résoudre une entrée du `TextTheme`; appliquer `transform` en code.

| typographyRef | Maps to                  | Notes |
|---|---|---|
| `titleLarge`  | `textTheme.titleLarge`  | weight via `fontWeight` |
| `title`       | `textTheme.titleMedium` |  |
| `subtitle`    | `textTheme.titleSmall`  |  |
| `label`       | `textTheme.labelLarge`  |  |
| `body`        | `textTheme.bodyMedium`  |  |
| `muted`       | `textTheme.bodySmall`   | contraste réduit |
| `value`       | `textTheme.headlineSmall` (+ mono en option) | valeurs numériques/temps |

---

## 2) Buttons by `variant`
_Règles associées : `rule:button/cta`, `rule:button/primary`, `rule:button/secondary`, `rule:button/ghost`, `rule:icon/resolve`_

Mapper sans règles spécifiques à l'écran :

- `cta` → `ElevatedButton` (plein). **bg** = `tokens.colors.cta` (fallback : `primary`).  
- `primary` → `ElevatedButton` (plein). **bg** = `tokens.colors.primary`.  
- `secondary` → `OutlinedButton`. **border** = `style.borderColor` / `tokens.colors.border`.  
- `ghost` → `TextButton`. **fg** = `style.color` ou `colorScheme.primary`.

Si `leadingIcon` existe, utiliser le constructeur `.icon(...)` et résoudre l'icône depuis `iconName`.

```dart
Widget buildButton(Comp c, Tokens t) { // ex.
  final label = Text(applyTransform(c.text, c.style.transform));
  final icon = c.leadingIcon != null ? buildIcon(c.leadingIcon, t) : null;

  switch (c.variant) {
    case "cta":
      return ElevatedButton.icon(
        key: Key('${screenId}__${c.id}'),
        onPressed: (){},
        icon: icon ?? const SizedBox.shrink(),
        label: label,
        style: ElevatedButton.styleFrom(
          backgroundColor: t.colorOr("cta", t.color("primary")),
          foregroundColor: t.color("onPrimary"),
        ),
      );
    case "primary":
      return ElevatedButton(
        key: Key('${screenId}__${c.id}'),
        onPressed: (){},
        style: ElevatedButton.styleFrom(
          backgroundColor: t.color("primary"),
          foregroundColor: t.color("onPrimary"),
        ),
        child: label,
      );
    case "secondary":
      return OutlinedButton(
        key: Key('${screenId}__${c.id}'),
        onPressed: (){},
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: c.style.borderColorOr(t.color("border")),
            width: (c.style.borderWidth ?? 1).toDouble(),
          ),
        ),
        child: label,
      );
    default: // ghost
      return TextButton(
        key: Key('${screenId}__${c.id}'),
        onPressed: (){},
        style: TextButton.styleFrom(foregroundColor: c.style.colorOr(t.color("primary"))),
        child: label,
      );
  }
}
```

---

## 3) Placement & width
_Règles associées : `rule:layout/placement`, `rule:layout/widthMode`_

Utiliser des conteneurs pour respecter `placement` & `widthMode` **dans le parent** :

```dart
Widget place(Widget w, Comp c) { // ex.
  final isHug = c.widthMode == "hug"; // alias de "intrinsic"
  final placed = switch (c.placement) {
    "end" => Align(alignment: Alignment.centerRight, child: w),
    "center" => Align(alignment: Alignment.center, child: w),
    "stretch" => Align(alignment: Alignment.centerLeft, child: SizedBox.expand(child: w)),
    _ => Align(alignment: Alignment.centerLeft, child: w),
  };
  return isHug ? placed : Expanded(child: placed); // widthMode: fill → Expanded
}
```

- `widthMode: fill` → wrapper avec `Expanded`.  
- `widthMode: hug` (alias `intrinsic`) → taille au contenu (**pas** d'`Expanded`).

---

## 4) Text `transform`
_Règle associée : `rule:text/transform`_

Appliquer la transformation **avant** de construire `Text` :

```dart
String applyTransform(String s, String? transform) { // ex.
  switch (transform) {
    case "uppercase": return s.toUpperCase();
    case "lowercase": return s.toLowerCase();
    default: return s;
  }
}
```

---

## 5) Group alignment & maxWidth
_Règles associées : `rule:group/alignment`, `rule:group/maxWidth`, `rule:group/distribution`_

Lorsque `group.alignment:"center"` et `maxWidth` est défini : centrer et contraindre.

```dart
Widget groupWrap(Widget child, Group g) { // ex.
  Widget wrapped = child;
  if (g.maxWidth != null && g.maxWidth! > 0) {
    wrapped = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: g.maxWidth!.toDouble()),
      child: wrapped,
    );
  }
  return switch (g.alignment) {
    "center" => Center(child: wrapped),
    "end" => Align(alignment: Alignment.centerRight, child: wrapped),
    _ => wrapped,
  };
}
```

Dans un `Row`, honorer `group.distribution` avec `MainAxisAlignment.start|spaceBetween|spaceAround|end`.

---

## 6) IconButtons with shape
_Règle associée : `rule:iconButton/shaped`_

Si `IconButton` porte `borderWidth/radius/size`, composer la forme :

```dart
Widget shapedIconButton(Comp c, Tokens t) { // ex.
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

## 7) Predefined patterns
_Règle associée : `rule:pattern/valueControl`_

Si le pattern + / value / - est identifié, instancier le widget `libs/widgets/value_control.dart`

```dart
    // Contrôle RÉPÉTITIONS
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
    );
```

```dart
    // Contrôle REPOS
    ValueControl(
      label: 'REPOS',
      value: DurationFormatter.formatDurationWithSpaces(_restDuration),
      onDecrease: _onDecreaseRest,
      onIncrease: _onIncreaseRest,
      decreaseKey: 'interval_timer_home__IconButton-19',
      valueKey: 'interval_timer_home__Text-20',
      increaseKey: 'interval_timer_home__IconButton-21',
      decreaseSemanticLabel: 'Diminuer le temps de repos',
      increaseSemanticLabel: 'Augmenter le temps de repos',
      decreaseEnabled: _restDuration > _minRestDuration,
      increaseEnabled: _restDuration < _maxDuration,
    );
```

---

## 7) Keys for testability
_Règle associée : `rule:keys/stable`_

Assigner une `Key` stable à chaque composant rendu :

```dart
Key compKey(String screenId, Comp c) => Key('${screenId}__${c.id}'); // ex.
```
