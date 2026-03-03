# Guardrails

- **G-01**: Never invent widgets or texts not present in design/spec.
- **G-02**: Abort if coverage < 1.0 or a11y missing on interactives.
- **G-03**: Treat estimates as assumptions with confidence and list them.
- **G-04**: No code in planning; code only in build phase.
- **G-05**: All outputs must be deterministic and re-runnable.
- **G-06**: File paths and organization must conform to CODE_CONTRACT.md §1.
- **G-07**: State management must use Provider + ChangeNotifier pattern only (CODE_CONTRACT.md §5).
- **G-08**: All generated code must follow naming conventions in CODE_CONTRACT.md §7.
- **G-09**: Test coverage must be ≥80% overall AND State/Model/Domain = 100%.
- **G-10**: Test coverage report must be generated in coverage/html.
- **G-11**: Every file in lib/widgets/, lib/screens/, lib/models/, lib/state/, lib/domain/ must have corresponding test file. 1:1 ratio.
- **G-12**: All user-facing text must use AppLocalizations. ARB files for en/fr. No hardcoded strings.
- **G-13**: State MUST NOT call Timer.periodic(), SystemSound.play(), or platform channels. Use service interfaces (CODE_CONTRACT.md §4).
- **G-14**: Non-mockable dependencies MUST be abstracted via interfaces in lib/services/.
- **G-15**: Business logic >50 lines MUST be extracted to lib/domain/ (CODE_CONTRACT.md §3).
- **G-16**: State classes MUST have ≤5 constructor dependencies.
- **G-17**: lib/domain/ MUST be pure Dart (no package:flutter except foundation).
- **G-18**: State MUST NOT return localized strings. Return enums/primitives; widgets translate.
