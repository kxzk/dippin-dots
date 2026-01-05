---
description: Review code changes for quality issues.
---

Review all changes for slop—code that adds noise, duplication, or false confidence. Before evaluating, scan the codebase for existing patterns, utilities, base classes, and conventions.

## Dead weight

- **Dead code** — unused functions, unreachable branches, stale imports, commented-out code that should be deleted
- **Vestigial parameters** — args that are passed but never used, or always passed the same value
- **Redundant logic** — null checks on values that can't be null, conditions that are always true/false
- **Copy-paste artifacts** — leftover variable names, comments, or logic from wherever this was copied from

## DRY violations

- **Reinvented utilities** — reimplementing helpers, constants, or patterns that already exist in the codebase
- **Inline duplication** — same logic repeated that should be extracted
- **Config/constants scattered** — magic literals that should reference centralized definitions
- **Missed abstractions** — boilerplate that existing base classes, mixins, decorators, or factories already handle

## Shallow tests

- **No-op tests** — no meaningful assertion, tautological checks (mock returns what you told it to)
- **Assertion-free paths** — conditional logic where some branches don't assert anything
- **Mock overload** — mocking so much you're testing the test setup, not the code
- **Snapshot abuse** — giant snapshots where changes won't get meaningful review
- **Test pollution** — shared mutable state, order-dependent tests

## Hazards

- **Swallowed errors** — overly broad `except Exception` / `catch (e)` hiding real bugs
- **Silent failures** — functions that return null/empty on error instead of surfacing the problem
- **Stringly typed** — string literals that should be enums, constants, or types
- **Implicit coupling** — code that assumes external state, ordering, or timing without making it explicit

## Output format

For each issue:
- **Severity**: 🔴 block merge / 🟡 fix before shipping / 🟢 nitpick
- **Location**: file and line/function
- **Problem**: one sentence
- **Fix**: concrete suggestion, referencing existing infra when applicable

Flag uncertain calls as uncertain. No preamble, no padding. If the code is clean, say "LGTM" and stop.
