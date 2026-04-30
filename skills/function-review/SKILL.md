---
name: function-review
description: Validate function quality against best practices checklist - use when evaluating or reviewing function implementations
---

# Function Review Checklist

When evaluating a function implementation, systematically check:

## Checklist

1. **Readability First** - Can you HONESTLY easily follow what it's doing? If yes, STOP HERE.

2. **Cyclomatic Complexity** - Count independent paths (nested if-else as proxy). High complexity = sketchy.

3. **Data Structures** - Would parsers, trees, stacks/queues make this clearer and more robust?

4. **Unused Parameters** - Remove any unused function parameters.

5. **Type Casts** - Move unnecessary type casts to function arguments.

6. **Testability** - Can you test without mocking core features (SQL, Redis)? If not, can it be integration tested?

7. **Hidden Dependencies** - Are there untested dependencies that should be arguments instead?

8. **Function Naming** - Brainstorm 3 better names. Is current name best and consistent with codebase?

## Refactoring Decision

**Only extract a separate function if:**
- Used in multiple places, OR
- Enables unit testing that's otherwise impossible AND no other testing approach works, OR
- Drastically improves readability of opaque code (not just preference)

## Output Format

For each function reviewed, provide:
- ✅ Passes / ⚠️ Issues found
- Specific issues by checklist number
- Concrete recommendations (if issues found)
