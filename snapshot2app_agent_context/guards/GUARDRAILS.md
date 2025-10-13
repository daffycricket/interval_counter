# Guardrails & Failure Taxonomy

- **G-01**: Never invent widgets or texts not present in design/spec.
- **G-02**: Abort if coverage < 1.0 or a11y missing on interactives.
- **G-03**: Treat estimates as assumptions with confidence and list them.
- **G-04**: No code in planning; code only in build phase.
- **G-05**: All outputs must be deterministic and re-runnable.
- **G-06**: File paths and organization must conform to PROJECT_CONTRACT.md.
- **G-07**: State management must use Provider + ChangeNotifier pattern only.
- **G-08**: All generated code must follow naming conventions in PROJECT_CONTRACT.md.
- **G-09**: Test coverage must be ≥ 80% overall AND any State/Model class = 100%.
- **G-10**: Test coverage report must be generated in coverage/html
- **G-11**: Every file in lib/widgets/, lib/screens/, lib/models/, lib/state/ must have corresponding test file. Widget-to-test ratio must be 1:1.
- **G-12**: All user-facing text must use AppLocalizations. ARB files must be generated for English and French. No hardcoded strings in UI widgets.