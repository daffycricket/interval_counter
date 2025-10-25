# Best Practices & Common Pitfalls

*Lessons learned from code generation iterations*

## Common Issues to Avoid

### Layout Issues
- ❌ **DON'T** use `Spacer()` inside `SingleChildScrollView`
  - **WHY**: Causes "RenderBox was not laid out" errors
  - ✅ **DO**: Use `SizedBox(height: X)` instead

### Code Quality
- ❌ **DON'T** reference undefined `AppColors` constants
  - **WHY**: Causes compilation errors
  - ✅ **DO**: Check theme files first, use existing constants

- ❌ **DON'T** keep unused fields in classes
  - **WHY**: Triggers linting warnings
  - ✅ **DO**: Remove unused fields immediately

- ❌ **DON'T** call instance methods as static
  - **WHY**: Compilation error "can't access using static access"
  - ✅ **DO**: Check method signatures in target class

### Flutter-Specific
- ❌ **DON'T** wrap IconButton in manual Semantics()
  - **WHY**: Framework-generated semantics override it
  - ✅ **DO**: Use `tooltip` parameter instead

### Architecture Anti-patterns

- ❌ **DON'T** use `Timer.periodic()` in State classes
  - **WHY**: Final class, cannot be mocked, slow tests
  - ✅ **DO**: Create `TickerService` interface, inject in State

- ❌ **DON'T** call `SystemSound.play()` or `HapticFeedback` in State
  - **WHY**: Platform-specific, not mockable, violates DIP
  - ✅ **DO**: Create `AudioService`/`HapticsService` interface

- ❌ **DON'T** keep complex business logic in State (>50 lines)
  - **WHY**: Hard to test, violates SRP, State becomes bloated
  - ✅ **DO**: Extract to `lib/domain/{Feature}Engine` (pure Dart)

- ❌ **DON'T** inject concrete classes (Timer, HttpClient, File)
  - **WHY**: Tight coupling, hard to mock, not testable
  - ✅ **DO**: Create interfaces in `lib/services/`, implementations in `lib/services/impl/`

- ❌ **DON'T** have State classes >200 lines
  - **WHY**: Too many responsibilities, hard to maintain
  - ✅ **DO**: Split into domain classes + service interfaces

## When to Update This File
- After fixing a recurring error during orchestration
- After discovering a Flutter-specific pitfall
- After identifying a pattern that breaks tests

---

*Last updated: 2025-10-24*

