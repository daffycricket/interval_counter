# Validation Report — preset_editor_design_advanced_2.json

**Date:** 2026-03-04
**Source:** `sources/new_preset/preset_editor_design_advanced_2.json`
**Contract:** `contracts/DESIGN_CONTRACT.md`

---

## 1. Summary

| Check                    | Result       | Details                                      |
|--------------------------|-------------|----------------------------------------------|
| coverageRatio            | **PASS**    | 1.0                                          |
| confidenceGlobal         | **DEGRADED**| 0.74 (< 0.85 threshold)                     |
| bbox/sourceRect integers | **PASS**    | All values are integers                      |
| textCoverage             | **PASS**    | 0 missing texts                              |
| a11y on interactives     | **PASS**    | All Button/IconButton have ariaLabel         |
| Colors in tokens         | **WARN**    | 1 stray hex (#888888)                        |
| Semantics                | **PASS**    | Variants, placement, widthMode, groups OK    |
| Typography coherence     | **WARN**    | 8 fontSize/typographyRef mismatches          |
| Layout/bbox coherence    | **WARN**    | 5 justify/distribution mismatches            |
| Orphan thumbs            | **N/A**     | No sliders in design                         |

**Verdict: PASS (DEGRADED MODE)** — Pipeline may proceed with warnings.

---

## 2. Findings

### 2.1 Confidence — DEGRADED

`qa.confidenceGlobal = 0.74` is below the 0.85 threshold. Major uncertainty sources:
- a7: All bbox values estimated visually (confidence 0.65)
- a3: stepLavender color estimated (confidence 0.70)
- a2: stepMagenta color estimated (confidence 0.72)
- a8: trending_down icon uncertain (confidence 0.73)

**Action:** Proceed in degraded mode. Flag in spec.md § Hypothèses.

### 2.2 Stray Color — #888888

**Location:** `text-11` (TIME label in Étape 2, muted state), `style.color: "#888888"`

`#888888` is not in `tokens.colors`. The QA section maps it to `textSecondary` but `tokens.colors.textSecondary` = `#AAAAAA`.

**Normalized diff:**
```json
{ "op": "replace", "path": "/components/[text-11]/style/color", "value": "#AAAAAA" }
```
**Assumption:** text-11 uses `textSecondary` token; the #888888 value is an estimation artifact. Confidence: 0.70.

### 2.3 Typography Mismatches

The following components have `typographyRef` that does not match the known token size mapping (titleLarge=22, label=14, body=14|16, value=24, muted=12):

| compId   | typographyRef | fontSize | expected | action                       |
|----------|---------------|----------|----------|------------------------------|
| text-0   | label         | 12       | 14       | Set typographyRef: "muted"   |
| text-2   | muted         | 10       | 12       | Set typographyRef: "custom"  |
| text-3   | body          | 16       | 14(spec)/16(app) | Keep as-is (matches app) |
| text-5   | value         | 28       | 24       | Set typographyRef: "custom"  |
| text-9   | value         | 22       | 24       | Set typographyRef: "custom"  |
| text-13  | value         | 28       | 24       | Set typographyRef: "custom"  |
| text-15  | value         | 22       | 24       | Set typographyRef: "custom"  |
| text-16  | value         | 14       | 24       | Set typographyRef: "label"   |

**Note:** In the existing app, `body = 16px` and `value = 24px`. Texts using `value` ref but with 28px or 22px fontSize are design-specific overrides for the ADVANCED screen (larger reps counter, smaller time displays). The build should use explicit fontSize rather than token ref for these.

**Normalized diffs:**
```json
[
  { "op": "replace", "path": "/components/[text-0]/style/typographyRef", "value": "muted" },
  { "op": "replace", "path": "/components/[text-2]/style/typographyRef", "value": "custom" },
  { "op": "replace", "path": "/components/[text-5]/style/typographyRef", "value": "custom" },
  { "op": "replace", "path": "/components/[text-9]/style/typographyRef", "value": "custom" },
  { "op": "replace", "path": "/components/[text-13]/style/typographyRef", "value": "custom" },
  { "op": "replace", "path": "/components/[text-15]/style/typographyRef", "value": "custom" },
  { "op": "replace", "path": "/components/[text-16]/style/typographyRef", "value": "label" }
]
```

### 2.4 Layout / Bbox Coherence

Several containers use `layout.justify: "center"` but children are widely spread across the axis, which is inconsistent:

| containerId   | justify  | children spread (% of axis) | suggested        |
|---------------|----------|-----------------------------|------------------|
| container-6   | center   | 87% (reps ± buttons grp1)   | spaceAround      |
| container-9   | center   | 93% (time ± buttons step1)  | spaceAround      |
| container-13  | center   | 80% (reps ± buttons step2)  | spaceAround      |
| container-14  | center   | 93% (time ± buttons step2)  | spaceAround      |
| container-19  | center   | 87% (reps ± buttons grp2)   | spaceAround      |

**Note:** These containers all have `group.distribution: "around"` which contradicts `layout.justify: "center"`. The group distribution is authoritative for the build.

**Normalized diffs:**
```json
[
  { "op": "replace", "path": "/components/[container-6]/layout/justify", "value": "spaceAround" },
  { "op": "replace", "path": "/components/[container-9]/layout/justify", "value": "spaceAround" },
  { "op": "replace", "path": "/components/[container-13]/layout/justify", "value": "spaceAround" },
  { "op": "replace", "path": "/components/[container-14]/layout/justify", "value": "spaceAround" },
  { "op": "replace", "path": "/components/[container-19]/layout/justify", "value": "spaceAround" }
]
```

### 2.5 Excluded from Pipeline Scope (User Decisions)

The following components are **present in design.json** but **excluded from build** per user decision:

| compId        | reason                                             |
|---------------|----------------------------------------------------|
| container-0   | System status bar — not part of app UI             |
| icon-3        | trending_down icon — feature deferred              |
| iconbutton-2  | more_vert (group 1) — excluded from build          |
| iconbutton-10 | settings (step 1) — excluded from build            |
| iconbutton-18 | settings (step 2) — excluded from build            |
| iconbutton-20 | more_vert (group 2) — excluded from build          |
| iconbutton-24 | more_vert (group 3) — excluded from build          |
| iconbutton-32 | settings (step 3) — excluded from build            |
| iconbutton-38 | settings (step 3 bis) — excluded from build        |

---

## 3. Counts by Type

| Type        | Count | Notes                |
|-------------|-------|----------------------|
| Text        | 35    |                      |
| Button      | 7     | Includes COLOR btns  |
| Icon        | 5     | Includes trending_down (deferred) |
| IconButton  | 41    | 7 excluded (settings/more_vert) |
| Container   | 35    |                      |
| Card        | 8     |                      |
| Slider      | 0     |                      |
| Placeholder | 0     |                      |

---

## 4. Assumptions Carried Forward

| id | field | confidence | note |
|----|-------|-----------|------|
| a1 | screen.size 304x1404 | 0.75 | Estimated from image |
| a2 | stepMagenta #CC1177 | 0.72 | Visual estimate |
| a3 | stepLavender #B39DDB | 0.70 | Visual estimate |
| a4 | stepGreen #388E3C | 0.78 | Material green 700 |
| a5 | stepRed #D32F2F | 0.78 | Material red 700 |
| a6 | finishYellow #CDDC39 | 0.80 | Material lime 400 |
| a7 | all bbox values | 0.65 | Visual estimation |
| a8 | trending_down icon | 0.73 | Deferred — excluded from build |
| a9 | typographyRef:value for time | 0.90 | Confirmed pattern |

---

## 5. Open Questions

1. ~~Exact pixel dimensions of source image~~ — Not blocking (bbox are guide only).
2. ~~trending_down icon identity~~ — Deferred per user decision.

---

## 6. Conclusion

**Design validation: PASS (degraded mode)**

The design.json meets all hard requirements (coverageRatio = 1.0, a11y labels present, bbox/sourceRect integers). Warnings on confidence (0.74), 1 stray color, typography mismatches, and layout justify/distribution conflicts are documented with normalized diffs. Pipeline may proceed to Step 2.
