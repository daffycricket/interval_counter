---
# Deterministic Build Plan — Template

# YAML front matter for machine-readability
screenName: XXX
screenId: XXX
designSnapshotRef: XXX
planVersion: 2
generatedAt: 2025-10-04T08:16:08Z
generator: spec2plan
language: fr
inputsHash: <sha256(design.json||spec.md)>
---

# 0. Invariants & Sources
- Sources: `design.json` (layout/styling), `spec.md` (logic/state/navigation/a11y)
- Rule: **design.json wins for layout**, **spec.md wins for behavior**
- Controlled vocabularies only (variants: cta|primary|secondary|ghost; placement: start|center|end|stretch; widthMode: fixed|hug|fill)
- Keys: `{screenId}__{compId}`
- Missing data → `—` (dash)
- No free-form prose outside `notes` columns

---

# 1. Meta
| field            | value |
|------------------|-------|
| screenId         | XXX   |
| designSnapshotRef| XXX   |
| inputsHash       | XXX   |

---

# 2. Files to Generate
## 2.1 Widgets
| widgetName           | filePath                         | purpose (fr court)          | components (compIds) | notes |
|----------------------|----------------------------------|-----------------------------|----------------------|-------|
| XXXHeader            | lib/widgets/xxx/xxx_header.dart  | En-tête                     | c_010,c_011          | —     |
| …                    | …                                | …                           | …                    | …     |

## 2.2 State
| filePath                         | pattern            | exposes (fields/actions)            | persistence | notes |
|----------------------------------|--------------------|-------------------------------------|-------------|-------|
| lib/state/xxx_screen_state.dart  | ChangeNotifier     | timerState,durationSecs;startTimer  | non         | —     |

## 2.3 Routes
| routeName      | filePath                       | params       | created/uses | notes |
|----------------|--------------------------------|--------------|-------------|-------|
| /xxx           | lib/routes/app_routes.dart     | —            | uses        | —     |

## 2.4 Themes/Tokens
| tokenType | name       | required | notes |
|----------|------------|----------|-------|
| color    | cta        | yes      | —     |
| typo     | titleLarge | yes      | —     |

## 2.5 Tests (to be generated in steps 05/06)

### Widget Tests - 1:1 with § 2.1
| widgetName           | testFilePath                                | covers (components from that widget) |
|----------------------|---------------------------------------------|--------------------------------------|
| (copy from § 2.1)    | test/widgets/{path}_test.dart               | (list component IDs from that widget)|

**Rule:** count(rows above) == count(rows in § 2.1 Widgets)

### Shared Test Helpers
| filePath                          | purpose                    |
|-----------------------------------|----------------------------|
| test/helpers/widget_test_helpers.dart | Common setup functions    |

---

# 3. Existing components to reuse
| componentName        | filePath                         | purpose of reuse (fr court) | components (compIds) | notes |
|----------------------|----------------------------------|-----------------------------|----------------------|-------|
| ReusableWidget       | lib/widgets/reusable_widget.dart | Super  carré dans un rong   | c_010,c_011          | —     |
| …                    | …                                | …                           | …                    | …     |

# 4. Widget Breakdown (from design.json + UI Mapping Guide)
| compId | type   | variant | key                       | widgetName | filePath                        | buildStrategy (mapping rule id) | notes |
|-------|--------|---------|---------------------------|------------|----------------------------------|---------------------------------|-------|
| c_001 | Button | cta     | {screenId}__c_001       | XXXCtaBtn  | lib/widgets/xxx/xxx_cta_btn.dart| rule:button/cta                 | —     |
| …     | …      | …       | …                         | …          | …                                | …                               | …     |

---

# 5. Layout Composition (design.json is authoritative)
## 5.1 Hierarchy
- root: Column (safeArea: true)
  - section s_header → XXXHeader
  - section s_body   → XXXBody

## 5.2 Constraints & Placement
| container | child (widgetName) | flex | alignment (placement) | widthMode | spacing | scrollable |
|----------|---------------------|------|------------------------|-----------|---------|------------|
| root     | XXXHeader           | —    | center                 | hug       | 16      | false      |
| root     | XXXBody             | 1    | stretch                | fill      | 0       | true       |

---

# 6. Interaction Wiring (from spec)
| compId | actionName   | stateImpact          | navigation | a11y (ariaLabel) | notes |
|--------|--------------|----------------------|-----------|------------------|-------|
| c_001  | startTimer   | timerState→running   | —         | "Démarrer"       | —     |
| …      | …            | …                    | …         | …                | …     |

---

# 7. State Model & Actions (from spec §6)
## 7.1 Fields
| key          | type | default | persistence | notes |
|--------------|------|---------|-------------|-------|
| timerState   | enum | idle    | non         | idle|running|paused|finished |

## 7.2 Actions
| name        | input | output | errors | description |
|-------------|-------|--------|--------|-------------|
| startTimer  | —     | —      | —      | Passe à running, désactive CTA |

---

# 8. Accessibility Plan
| order | compId | role        | ariaLabel    | focusable | shortcut | notes |
|------:|--------|-------------|--------------|-----------|----------|-------|
| 1     | c_001  | button      | "Démarrer"   | true      | Enter    | —     |

---

# 9. Testing Plan (traceability to spec §10)
| testId | preconditions | steps (concise)       | oracle (expected)                                  | finder strategy |
|-------|----------------|-----------------------|----------------------------------------------------|-----------------|
| T1    | idle           | tap "DÉMARRER"        | key {screenId}__c_001 becomes disabled after tap | find.byKey      |

---

# 10. Test Generation Plan

## 10.1 State Tests (`test/state/{screen}_state_test.dart`)

| Component | Method | Test Case | Priority | Coverage Type |
|-----------|--------|-----------|----------|---------------|
| {componentName} | {methodName} | ... | CRITICAL|HIGH | Unit|Boundary|Integration |

**Coverage Target:** 100% lines, 100% branches

---

## 10.2 Widget Tests

| Widget | Component Key | Test Case | Expected Behavior |
|--------|---------------|-----------|-------------------|
| {widgetName} | {screenId}__{compId} | ... | ... |

**Coverage Target:** ≥90% for generic widgets, ≥70% for screen-specific widgets

---

## 10.3 Accessibility Tests

| Widget | Component Key | Semantic Label | Role | State |
|--------|---------------|----------------|------|-------|
| {widgetName} | {screenId}__{compId} | "..." | button, slider ... | enabled |

---

## 10.4 Components excluded from tests

| Component | Reason        |
|-----------|---------------|
| {componentName} | ...     |

---

# 11. Risks / Unknowns (from spec §11.3)
- —

---

# 12. Check Gates
- Analyzer/lint pass
- Unique keys check
- Controlled vocabulary validation
- A11y labels presence
- Routes exist and compile
- Token usage present in theme
- Test coverage thresholds (State/Model: 100%, Overall: ≥80%)

---

# 13. Checklist (subset of PR_CHECKLIST)
- [ ] Keys assigned on interactive widgets
- [ ] Texts verbatim + transform
- [ ] Variants/placement/widthMode valid
- [ ] Actions wired to state methods
- [ ] Golden-ready (stable layout, no randoms)
- [ ] Test generation plan complete (all State methods, interactive components listed)
