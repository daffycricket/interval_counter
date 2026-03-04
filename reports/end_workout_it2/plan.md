---
screenName: end_workout
screenId: end_workout
designSnapshotRef: c6581509-e5b9-4306-9f04-0faf619e3f6c
planVersion: 3
generatedAt: 2026-03-04T00:00:00Z
generator: spec2plan-it2
language: fr
iteration: 2
---

# 0. Invariants & Sources
- Sources: `design.json` (layout/styling), `spec.md` (logic/navigation/a11y)
- design.json wins for layout; spec.md wins for behavior
- Keys: `end_workout__{compId}` — IDs from qa.inventory index (text-2, iconbutton-4, iconbutton-6)

---

# 1. Meta
| field             | value |
|-------------------|-------|
| screenId          | end_workout |
| designSnapshotRef | c6581509-e5b9-4306-9f04-0faf619e3f6c |
| iteration         | 2 (fresh build, it1 reset by commit 5604100) |

---

# 2. Context — Existing files (do NOT regenerate)

| file | status | notes |
|------|--------|-------|
| `lib/routes/app_routes.dart` | EXISTS — route `/end_workout` configured | Already imports EndWorkoutScreen |
| `lib/screens/workout_screen.dart` | EXISTS — pushReplacementNamed to `/end_workout` | Already wired |
| `lib/l10n/app_en.arb` | EXISTS — endWorkoutTitle, endWorkoutStopLabel, endWorkoutRestartLabel | Déjà générés |
| `lib/l10n/app_fr.arb` | EXISTS — same keys | Déjà générés |
| `lib/l10n/app_localizations*.dart` | EXISTS — already has endWorkoutTitle, endWorkoutStopLabel, endWorkoutRestartLabel | |
| `integration_test/end_workout_flow_test.dart` | EXISTS — 4 E2E tests | DO NOT modify |
| `integration_test/app_test.dart` | EXISTS — imports end_workout | DO NOT modify |

---

# 3. Files to Generate

## 3.1 Widgets (screens)
| widgetName           | filePath                                        | purpose                          | components              | notes |
|----------------------|-------------------------------------------------|----------------------------------|-------------------------|-------|
| EndWorkoutScreen     | lib/screens/end_workout_screen.dart             | Écran de fin de workout          | container-1, text-2, container-3, iconbutton-4, iconbutton-6 | StatelessWidget |
| _ActionButton        | lib/screens/end_workout_screen.dart             | Bouton icône stylé (réutilisé x2) | iconbutton-4, iconbutton-6 | Extrait car >50 lignes total |

## 3.2 State
| filePath | pattern | notes |
|----------|---------|-------|
| —        | —       | Aucun état — écran purement stateless |

## 3.2.1 Service Dependencies
- **Service Interfaces:** Aucune — navigation pure.
- **Domain Classes:** Aucune — pas de logique métier.

## 3.3 Routes (already exist)
| routeName   | filePath                   | params  | status |
|-------------|----------------------------|---------|--------|
| /end_workout | lib/routes/app_routes.dart | Preset  | EXISTS |

## 3.4 Themes/Tokens
| tokenType | name               | value   | source |
|-----------|--------------------|---------|--------|
| color     | endWorkoutBg       | #008290 | tokens.colors.background |
| color     | endWorkoutButtonBg | #546F78 | tokens.colors.buttonBackground |
| color     | endWorkoutText     | #212121 | tokens.colors.textPrimary |
| color     | endWorkoutIcon     | #FFFFFF | tokens.colors.iconWhite |

## 3.5 Tests

### Widget/Screen Tests — 1:1 avec § 3.1
| widgetName       | testFilePath                                  | covers |
|------------------|-----------------------------------------------|--------|
| EndWorkoutScreen | test/screens/end_workout_screen_test.dart     | T1, T2, T3 + nav + a11y |

---

# 4. Widget Breakdown
| compId       | type       | variant   | key                              | widgetName       | buildStrategy           | notes |
|--------------|------------|-----------|----------------------------------|------------------|-------------------------|-------|
| container-1  | Container  | —         | (Scaffold body, no key)         | EndWorkoutScreen | Scaffold + SafeArea + Center + Column | backgroundColor #008290 |
| text-2       | Text       | —         | end_workout__text-2             | EndWorkoutScreen | rule:text/transform     | l10n.endWorkoutTitle, fontSize 48, bold, color #212121 |
| container-3  | Container  | —         | end_workout__container-3        | EndWorkoutScreen | rule:group/distribution | Row, MainAxisAlignment.center |
| iconbutton-4 | IconButton | secondary | end_workout__iconbutton-4       | _ActionButton    | rule:iconButton/shaped  | 100x100, radius 4, Icons.stop |
| icon-5       | Icon       | —         | —                               | _ActionButton    | child décoratif         | Icons.stop, size 46 |
| iconbutton-6 | IconButton | secondary | end_workout__iconbutton-6       | _ActionButton    | rule:iconButton/shaped  | 100x100, radius 4, Icons.replay |
| icon-7       | Icon       | —         | —                               | _ActionButton    | child décoratif         | Icons.replay, size 46 |

---

# 5. Layout Composition
## 5.1 Hierarchy
```
Scaffold(backgroundColor: Color(0xFF008290))
  body: SafeArea
    child: Column
      Spacer(flex: 3)  // ~30% top
      Key('end_workout__text-2'): Text(l10n.endWorkoutTitle)
      Spacer(flex: 4)  // ~40% middle (large gap)
      Row(key: Key('end_workout__container-3'), mainAxisAlignment: center)
        _ActionButton(key: Key('end_workout__iconbutton-4'), Icons.stop)
        SizedBox(width: 24)  // spacing.lg
        _ActionButton(key: Key('end_workout__iconbutton-6'), Icons.replay)
      Spacer(flex: 3)  // ~30% bottom
```

**Layout strategy:** Spacer(flex: 3:4:3) positions:
- Title at ~30% screen height (matches bbox y=448 / height=1506)
- Buttons at ~70% screen height (matches bbox y=958 / height=1506)

## 5.2 _ActionButton layout
```
Semantics(label: semanticLabel, button: true)
  Tooltip(message: semanticLabel)
    InkWell(onTap: onPressed, borderRadius: BorderRadius.circular(4))
      Container(64x64, color: #546F78, borderRadius: 4)
        Icon(icon, color: white, size: 32)
```

---

# 6. Interaction Wiring
| compId       | actionName | stateImpact | navigation                                    | a11y            | notes |
|--------------|------------|-------------|-----------------------------------------------|-----------------|-------|
| iconbutton-4 | onStop     | —           | Navigator.of(context).pop()                   | "Stop timer"    | tooltip visible |
| iconbutton-6 | onRestart  | —           | Navigator.of(context).pushReplacementNamed(AppRoutes.workout, arguments: preset) | "Restart timer" | tooltip visible |

---

# 7. State Model & Actions
Aucun état — StatelessWidget pur.

---

# 8. Accessibility Plan
| order | compId       | role   | ariaLabel       | focusable | implementation |
|------:|--------------|--------|-----------------|-----------|----------------|
| 1     | iconbutton-4 | button | "Stop timer"    | true      | Semantics(label: l10n.endWorkoutStopLabel, button: true) + Tooltip |
| 2     | iconbutton-6 | button | "Restart timer" | true      | Semantics(label: l10n.endWorkoutRestartLabel, button: true) + Tooltip |

---

# 9. Test Plan
| testId | type    | steps                    | oracle                                           |
|--------|---------|--------------------------|--------------------------------------------------|
| T1     | widget  | find text-2              | find.byKey('end_workout__text-2') findsOneWidget |
| T2     | widget  | find iconbutton-4        | find.byKey('end_workout__iconbutton-4') findsOneWidget |
| T3     | widget  | find iconbutton-6        | find.byKey('end_workout__iconbutton-6') findsOneWidget |
| T4     | widget  | scaffold background      | Color(0xFF008290) |
| T5     | widget  | a11y iconbutton-4        | bySemanticsLabel('Stop timer') findsOneWidget |
| T6     | widget  | a11y iconbutton-6        | bySemanticsLabel('Restart timer') findsOneWidget |
| T7     | widget  | tap stop → pop           | EndWorkoutScreen absent après pop |
| T8     | widget  | tap restart → workout    | find.text('WorkoutScreen') findsOneWidget |

---

# 10. Components excluded from tests
| Component | Reason |
|-----------|--------|
| icon-5    | Décoratif, enfant de _ActionButton |
| icon-7    | Décoratif, enfant de _ActionButton |

---

# 11. Check Gates
- flutter analyze pass
- 1:1 test ratio: end_workout_screen → end_workout_screen_test ✅
- E2E: end_workout_flow_test.dart présent + importé dans app_test.dart ✅
- verify.sh: e2e-tests-per-screen PASS

---

# 12. Risks
- confidenceGlobal=0.78 → bboxes approximées → mode dégradé accepté
- Button background: #546F78 (peut être rgba semi-transparent sur #008290)
