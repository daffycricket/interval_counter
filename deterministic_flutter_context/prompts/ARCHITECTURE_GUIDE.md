# ARCHITECTURE_GUIDE.md — Decoupling

- Layers:
  - UI (widgets) — composition only; no business logic.
  - Controllers (ChangeNotifier/use cases) — state & intents, testable.
  - Data (repos/clients) — mockable.
  - Theme — tokens & styles const.
- Flow: Widgets ↔ Controller ↔ UseCases ↔ Repos.
- DI: constructor/Provider; clock/IDs injected for tests.
