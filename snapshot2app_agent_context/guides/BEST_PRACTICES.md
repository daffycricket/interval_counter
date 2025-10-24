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

## When to Update This File
- After fixing a recurring error during orchestration
- After discovering a Flutter-specific pitfall
- After identifying a pattern that breaks tests

---

*Last updated: 2025-10-24*

