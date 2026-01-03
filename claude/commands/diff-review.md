---
description: Review staged changes for issues before commit
argument-hint: [focus area]
---

Analyze git changes as a Staff Engineer doing a pre-commit review.

!`git diff`

## Review Checklist

1. **Breaking Changes** - API signature changes, removed exports, changed return types, renamed public interfaces
2. **Security Issues** - Injection vectors, auth gaps, secrets exposure, unsafe deserialization, OWASP top 10
3. **Performance Regressions** - N+1 queries, unbounded loops, missing indexes, memory leaks, blocking in async
4. **Logic Errors** - Off-by-one, null/undefined handling, race conditions, incorrect boolean logic
5. **Missing Tests** - Changed behavior without test coverage, edge cases unhandled
6. **Incomplete Changes** - TODOs left behind, commented-out code, debug statements, partial refactors

## Output Format

For each issue found:
```
[SEVERITY] Category
File: path/to/file.ext:line
Problem: What's wrong
Impact: Why it matters
Fix: Concrete suggestion
```

Severity: 🔴 BLOCKER | 🟠 WARNING | 🟡 NITPICK

If changes look good, say "LGTM" with a one-line summary of what the diff does.

$ARGUMENTS
