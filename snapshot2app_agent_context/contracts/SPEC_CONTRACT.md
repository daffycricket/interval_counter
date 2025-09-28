# SPEC_CONTRACT — Updated

## Goal
Ensure the functional specification derived from `design.json` is actionable and consistent with the UI semantics.

## Must include
- User-visible copy **verbatim** from `components.Text.text` (with `transform` applied).  
- Interaction model for each interactive component (`Button`, `IconButton`, `Slider`, inputs...).  
- Accessibility behavior mapping `a11y.ariaLabel` to semantics.  
- Non-visual roles implied by variants:  
  - `cta` = primary flow action,  
  - `secondary` = supportive action,  
  - `ghost` = low-emphasis action.
- Layout intentions where they impact behavior: centered groups, actions aligned to end.
- Theming dependencies: reference to semantic tokens used by actions (`cta`, `success`, etc.).

## Out of scope
- Pixel-perfect values beyond what `design.json` already encodes.
