# Validation Report — end_workout

## Summary
| field              | value |
|--------------------|-------|
| screenName         | end_workout |
| snapshotRef        | c6581509-e5b9-4306-9f04-0faf619e3f6c |
| coverageRatio      | 1.0 ✅ |
| confidenceGlobal   | 0.74 ⚠️ (< 0.85 → degraded mode) |
| status             | PASS (degraded) |

## Checks
| check                        | result | detail |
|------------------------------|--------|--------|
| coverageRatio == 1.0         | ✅ PASS | 1.0 |
| bbox/sourceRect integers     | ✅ PASS | All integers |
| a11y on interactives         | ✅ PASS | iconbutton-4 "Stop timer", iconbutton-6 "Restart timer" |
| colors in tokens             | ✅ PASS | #0F7C82, #6F7F86, #E6E6E6, #1A1A1A all declared |
| variants on IconButtons      | ✅ PASS | both secondary |
| placement + widthMode        | ✅ PASS | both center / intrinsic |
| typographyRef                | ✅ PASS | text-2: titleLarge |
| transform for uppercase      | ✅ PASS | text-2: uppercase |
| sliders / orphan thumbs      | ✅ N/A | no sliders |
| confidenceGlobal ≥ 0.85      | ⚠️ WARN | 0.74 — bboxes approximated visually |

## Findings
### flags
- hasOrphanThumb: false

## Assumptions
| item | confidence |
|------|------------|
| background color teal approximated from image | 0.75 |
| button gray color approximated | 0.75 |
| icon names inferred as material.stop and material.refresh | 0.80 |
| bbox positions approximated visually from screenshot | 0.70 |

## Decision
Pipeline proceeds in **degraded mode**. No blocking issues found.
