# PROJECT_ORGANIZATION.md — Structure & Extraction Rules

## Layout
```
lib/
  components/           # reusable, generic components
    buttons/
    inputs/
    layout/
  screens/              # screen composites (static)
  theme/                # tokens & text styles
  domain/               # controllers, use cases (testable)
test/
  goldens/              # optional golden images
  domain/               # unit tests for domain controllers
```

## Naming
- Screens: `home_screen.dart` (class `HomeScreen`).
- Components: file `snake_case.dart`, class `PascalCase` (public).

## When to extract a component
Extract to `lib/components/**` if **≥2 occurrences** OR clearly generic, **and** API can be props + callbacks (no tight screen coupling).
