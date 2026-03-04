---
screenName: end_workout
screenId: end_workout
designSnapshotRef: c6581509-e5b9-4306-9f04-0faf619e3f6c
planVersion: 2
generatedAt: 2026-03-04T00:00:00Z
generator: spec2plan
language: fr
---

# 0. Invariants & Sources
- Sources: `design.json` (layout/styling), `spec.md` (logic/navigation/a11y)
- design.json wins for layout; spec.md wins for behavior
- Keys: `end_workout__{compId}`

---

# 1. Meta
| field             | value |
|-------------------|-------|
| screenId          | end_workout |
| designSnapshotRef | c6581509-e5b9-4306-9f04-0faf619e3f6c |
| inputsHash        | — |

---

# 2. Files to Generate

## 2.1 Widgets
| widgetName           | filePath                                        | purpose                          | components              | notes |
|----------------------|-------------------------------------------------|----------------------------------|-------------------------|-------|
| EndWorkoutScreen     | lib/screens/end_workout_screen.dart             | Écran de fin de workout          | container-1, text-2, container-3, iconbutton-4, iconbutton-6 | StatelessWidget |

## 2.2 State
| filePath | pattern | exposes | persistence | notes |
|----------|---------|---------|-------------|-------|
| —        | —       | —       | —           | Aucun état — écran stateless |

## 2.2.1 Service Dependencies
**Service Interfaces & Implementations:** Aucune — navigation pure.

**Domain Classes:** Aucune — pas de logique métier.

## 2.3 Routes
| routeName   | filePath                   | params  | created/uses | notes |
|-------------|----------------------------|---------|-------------|-------|
| /end_workout | lib/routes/app_routes.dart | Preset  | created     | Modifie le fichier existant |

## 2.4 Themes/Tokens
| tokenType | name       | required | notes |
|-----------|------------|----------|-------|
| color     | background | yes      | #0F7C82 fond écran |
| color     | surface    | yes      | #6F7F86 fond boutons |
| color     | onPrimary  | yes      | #E6E6E6 couleur icônes |
| color     | textPrimary | yes     | #1A1A1A couleur texte |
| typo      | titleLarge | yes      | text-2 |

## 2.5 Tests

### Widget Tests — 1:1 avec § 2.1
| widgetName       | testFilePath                                  | covers |
|------------------|-----------------------------------------------|--------|
| EndWorkoutScreen | test/screens/end_workout_screen_test.dart     | text-2, iconbutton-4, iconbutton-6 |

### Shared Test Helpers
| filePath                              | purpose |
|---------------------------------------|---------|
| test/helpers/mock_services.dart       | Mocks existants (réutilisés) |

---

# 3. Existing components to reuse
| componentName  | filePath                       | purpose de réutilisation | notes |
|----------------|--------------------------------|--------------------------|-------|
| AppTextStyles  | lib/theme/app_text_styles.dart | titleLarge pour text-2   | rule:font/size |
| AppColors      | lib/theme/app_colors.dart      | tokens couleurs          | — |
| AppRoutes      | lib/routes/app_routes.dart     | Routes (modifié)         | Ajout /end_workout |

---

# 4. Widget Breakdown
| compId       | type       | variant   | key                              | widgetName           | filePath                            | buildStrategy           | notes |
|--------------|------------|-----------|----------------------------------|----------------------|-------------------------------------|-------------------------|-------|
| container-1  | Container  | —         | end_workout__container-1        | EndWorkoutScreen     | lib/screens/end_workout_screen.dart | rule:group/alignment    | Scaffold + SafeArea + Center |
| text-2       | Text       | —         | end_workout__text-2             | EndWorkoutScreen     | lib/screens/end_workout_screen.dart | rule:text/transform     | uppercase, titleLarge |
| container-3  | Container  | —         | end_workout__container-3        | EndWorkoutScreen     | lib/screens/end_workout_screen.dart | rule:group/distribution | Row, MainAxisAlignment.center |
| iconbutton-4 | IconButton | secondary | end_workout__iconbutton-4       | EndWorkoutScreen     | lib/screens/end_workout_screen.dart | rule:iconButton/shaped  | 100x100, radius 6, material.stop |
| icon-5       | Icon       | —         | —                               | —                    | —                                   | — (child de iconbutton-4) | Icons.stop |
| iconbutton-6 | IconButton | secondary | end_workout__iconbutton-6       | EndWorkoutScreen     | lib/screens/end_workout_screen.dart | rule:iconButton/shaped  | 100x100, radius 6, material.refresh |
| icon-7       | Icon       | —         | —                               | —                    | —                                   | — (child de iconbutton-6) | Icons.refresh |

---

# 5. Layout Composition
## 5.1 Hierarchy
- root: Scaffold (backgroundColor: #0F7C82)
  - SafeArea
    - Center
      - Column (mainAxisAlignment: center, gap: xl=40)
        - Text "FINI" (text-2)
        - SizedBox(height: 40)
        - Row (container-3, mainAxisAlignment: center, gap: lg=24)
          - _IconActionButton (iconbutton-4: stop)
          - SizedBox(width: 24)
          - _IconActionButton (iconbutton-6: restart)

## 5.2 Constraints & Placement
| container   | child            | flex | alignment | widthMode | spacing | scrollable |
|-------------|------------------|------|-----------|-----------|---------|------------|
| Column      | text-2           | 0    | center    | hug       | 0       | false |
| Column      | Row              | 0    | center    | hug       | 40 (gap xl) | false |
| Row         | iconbutton-4     | 0    | center    | intrinsic | 24 (gap lg) | false |
| Row         | iconbutton-6     | 0    | center    | intrinsic | 0       | false |

---

# 6. Interaction Wiring
| compId       | actionName | stateImpact | navigation                                    | a11y            | notes |
|--------------|------------|-------------|-----------------------------------------------|-----------------|-------|
| iconbutton-4 | onStop     | —           | Navigator.pop() → Home                        | "Stop timer"    | tooltip |
| iconbutton-6 | onRestart  | —           | pushReplacementNamed('/workout', args: preset) | "Restart timer" | tooltip |

**Modification WorkoutScreen requise:**
- Quand `isComplete` → `Navigator.pushReplacementNamed('/end_workout', arguments: preset)`
- Passer `preset` à `_WorkoutScreenContent` comme paramètre

---

# 7. State Model & Actions
## 7.1 Fields
| clé | type | défaut | persistence | notes |
|-----|------|--------|-------------|-------|
| —   | —    | —      | —           | Aucun état |

## 7.2 Actions
| nom       | input  | output | description |
|-----------|--------|--------|-------------|
| onStop    | —      | —      | Navigator.pop() |
| onRestart | —      | —      | pushReplacementNamed('/workout', arguments: preset) |

---

# 8. Accessibility Plan
| order | compId       | role   | ariaLabel       | focusable | notes |
|------:|--------------|--------|-----------------|-----------|-------|
| 1     | iconbutton-4 | button | "Stop timer"    | true      | Semantics tooltip |
| 2     | iconbutton-6 | button | "Restart timer" | true      | Semantics tooltip |

---

# 9. Testing Plan
| testId | preconditions    | steps                    | oracle                                           | finder |
|--------|-----------------|--------------------------|--------------------------------------------------|--------|
| T1     | screen affiché  | find text-2              | find.byKey('end_workout__text-2') findsOneWidget | byKey |
| T2     | screen affiché  | find iconbutton-4        | find.byKey('end_workout__iconbutton-4') findsOneWidget | byKey |
| T3     | screen affiché  | find iconbutton-6        | find.byKey('end_workout__iconbutton-6') findsOneWidget | byKey |
| T4     | e2e: workout → fin | tap stop             | retour home (find.byKey('home__Button-23'))      | byKey |
| T5     | e2e: workout → fin | tap restart          | nouveau workout démarre                          | byKey |

---

# 10. Test Generation Plan

## 10.1 State Tests
Aucun — pas de state class.

## 10.2 Widget Tests
| Widget           | Component Key                    | Test Case                              | Expected |
|------------------|----------------------------------|----------------------------------------|---------|
| EndWorkoutScreen | end_workout__text-2              | texte FINI présent                     | findsOneWidget |
| EndWorkoutScreen | end_workout__iconbutton-4        | bouton stop présent                    | findsOneWidget |
| EndWorkoutScreen | end_workout__iconbutton-6        | bouton restart présent                 | findsOneWidget |
| EndWorkoutScreen | end_workout__iconbutton-4        | tap stop → pop                         | navigation |
| EndWorkoutScreen | end_workout__iconbutton-6        | tap restart → pushReplacement workout  | navigation |

**Coverage target:** ≥60% (screen)

## 10.3 Accessibility Tests
| Widget           | Component Key             | Semantic Label  | Role   |
|------------------|---------------------------|-----------------|--------|
| EndWorkoutScreen | end_workout__iconbutton-4 | "Stop timer"    | button |
| EndWorkoutScreen | end_workout__iconbutton-6 | "Restart timer" | button |

## 2.6 Translations Plan
| Key                    | EN              | FR          |
|------------------------|-----------------|-------------|
| endWorkoutTitle        | FINI            | FINI        |
| endWorkoutStopLabel    | Stop timer      | Arrêter     |
| endWorkoutRestartLabel | Restart timer   | Reprendre   |

---

# 10.4 Components excluded from tests
| Component | Reason |
|-----------|--------|
| icon-5    | Décoratif, enfant de iconbutton-4 |
| icon-7    | Décoratif, enfant de iconbutton-6 |

---

# 11. Risks / Unknowns
- confidenceGlobal=0.74 → bboxes approximées → mode dégradé accepté

---

# 12. Check Gates
- flutter analyze pass
- 1:1 test ratio (end_workout_screen → end_workout_screen_test)
- E2E: integration_test/end_workout_flow_test.dart importé dans app_test.dart
- verify.sh: e2e-tests-per-screen PASS

---

# 13. Checklist
- [x] Keys sur widgets interactifs
- [x] Textes verbatim + transform
- [x] Variants/placement/widthMode valides
- [x] Actions câblées (navigation)
- [x] Tests E2E planifiés
