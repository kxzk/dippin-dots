---
name: thermo-nuclear-code-quality-review
description: Run an extremely strict maintainability review for abstraction quality, giant files, and tangled conditional growth. Use for a thermo-nuclear code quality review, thermonuclear review, deep code quality audit, or especially strict maintainability review.
---

# Thermo-Nuclear Code Quality Review

Use this skill for an unusually strict review of implementation quality, maintainability, abstraction quality, and codebase health.

This is not a normal surface cleanup pass. Push for major structural simplification. Look for behavior-preserving restructures that make the implementation much simpler, smaller, more direct, and easier to understand later.

Do not delegate the review to another model or sub-agent instead of reading the diff yourself. This skill requires a direct and rigorous maintainability judgment based on the actual code.

## Baseline Prompt

Start from this baseline:

```text
Perform a deep code quality audit of the current branch's changes.
Rethink how to structure / implement the changes to meaningfully improve code quality without impacting behavior.
Work to improve abstractions and modularity. Reduce tangled code. Improve brevity and legibility.
Be ambitious. If there is a clear path to improve the implementation by restructuring some of the codebase, use that path.
Be extremely thorough and rigorous. Inspect carefully before you recommend changes.
```

## Non-Negotiable Standards

### 1. Be Ambitious About Structural Simplification

Do not stop at "this could be cleaner." Search for ways to delete whole branches, helpers, modes, conditionals, or layers.

Prefer the design that makes the implementation obvious after the change. If you can delete complexity instead of move it around, push hard for that path.

### 2. Block Unjustified 1000-Line File Crossings

Do not let a PR push a file from under 1000 lines to over 1000 lines without a very strong reason.

Treat this as a code-quality warning sign by default. Prefer extracting helpers, subcomponents, modules, or local abstractions instead of letting a file grow without structure.

If the diff crosses the threshold, explicitly ask whether the code must be decomposed first.

Waive this only when there is a compelling structural reason and the resulting file is still clearly organized.

### 3. Reject Tangled Conditional Growth

Be highly suspicious of ad hoc conditionals, scattered special cases, one-off flags, nullable modes, or branches inserted into unrelated flows.

If a change adds strange `if` statements in random places, treat that as a design problem, not a style comment. Prefer a dedicated abstraction, helper, state machine, policy object, or separate module.

Call out changes that make surrounding code harder to reason about, even when they work.

### 4. Prefer Clean Design Over Working Mess

Do not approve code only because behavior appears correct. If behavior can stay the same while the structure becomes meaningfully cleaner, push for the cleaner version.

Prefer simplifications that remove moving pieces over refactors that spread the same complexity across more places.

### 5. Prefer Direct, Plain Code

Treat brittle, ad hoc, implicit, or surprising behavior as a maintainability problem.

Be skeptical of generic mechanisms that hide simple data-shape assumptions. Flag thin abstractions, identity wrappers, and pass-through helpers that add indirection without adding clarity.

### 6. Push On Type And Boundary Cleanliness

Question unnecessary optionality, `unknown`, `any`, casts, silent fallbacks, and loose object shapes when a clearer boundary could exist.

Prefer explicit typed models or shared contracts. If control flow relies on a fallback that hides an unclear invariant, ask whether the invariant must be modeled directly.

### 7. Keep Logic In The Canonical Layer

Call out feature logic that leaks into shared paths. Call out implementation details that leak through APIs.

Prefer existing canonical utilities over custom one-off helpers. Push logic toward the package, service, or module that already owns the concept.

### 8. Treat Avoidable Orchestration Complexity As Design Debt

If independent work runs in sequence for no good reason, ask whether the flow can run in parallel.

If related updates can leave state partly applied, push for a more atomic structure. Do not focus too much on micro-optimizations. Flag orchestration that makes the implementation more brittle.

## Primary Review Questions

For every meaningful change, ask:

- Is there a behavior-preserving restructure that would make this much simpler?
- Can the change use fewer concepts, branches, or helper layers?
- Does this improve or worsen the local architecture?
- Did the diff add branching complexity where a better abstraction is needed?
- Did a cohesive module become more coupled, more stateful, or harder to scan?
- Is the logic in the right file and layer?
- Did this enlarge a file or component past a healthy size boundary?
- Do repeated conditionals signal a missing model or helper?
- Is the implementation direct and legible?
- Does the implementation rely on special cases and incidental control flow?
- Does the abstraction earn its cost?
- Is it only a wrapper?
- Did the diff introduce casts, optionality, or ad hoc object shapes that obscure the real invariant?
- Is the logic in the canonical layer?
- Did details leak across a boundary?
- Is orchestration more sequential or less atomic than it needs to be?

## What To Flag Aggressively

Escalate findings when you see:

- A complicated implementation where a cleaner structure could delete whole categories of complexity.
- Refactors that move code around without reducing the concepts a reader must hold.
- A file crossing 1000 lines because of the PR.
- New conditionals inserted into unrelated code paths.
- One-off booleans, nullable modes, or flags that complicate control flow.
- Feature-specific logic leaking into general-purpose modules.
- Generic behavior that hides simple structure.
- Thin wrappers or identity abstractions that add indirection without simplifying anything.
- Unnecessary casts, `any`, `unknown`, or optional params that muddy the contract.
- Copy-pasted logic instead of extracted helpers.
- Narrow edge-case handling in an already busy function.
- Refactors that pass tests but make the code less modular or less readable.
- Temporary branching that is likely to become permanent debt.
- Custom helpers where a canonical utility already exists.
- Logic in the wrong layer or package.
- Sequential async flow where independent work could stay clearer with parallel execution.
- Partial-update logic that leaves state less atomic than necessary.

## Preferred Remedies

Prefer remedies that remove or isolate complexity:

- Delete a whole layer of indirection instead of polishing it.
- Reframe the state model so conditionals disappear.
- Change ownership boundaries so the feature becomes a natural extension of an existing abstraction.
- Turn special-case logic into a simpler default flow with fewer exceptions.
- Extract a helper or pure function.
- Split large files into focused modules.
- Move feature-specific logic behind a dedicated abstraction.
- Replace condition chains with a typed model or explicit dispatcher.
- Separate orchestration from business logic.
- Collapse duplicate branches into one clearer flow.
- Delete wrappers that do not clarify the API.
- Reuse canonical helpers instead of creating near-duplicates.
- Make type boundaries explicit enough that control flow gets simpler.
- Move logic to the package, module, or layer that owns the concept.
- Parallelize independent work when that also simplifies orchestration.
- Restructure related updates into a more atomic flow.

Do not settle for rename-level feedback when the real issue is structural. Do not accept a cleaner version of the same messy idea when there is a plausible path to a much simpler idea.

## Review Tone

Be direct, serious, and demanding about quality.

Do not be rude. Also do not soften major maintainability issues into mild suggestions. If the code makes the codebase messier, say so clearly. If the implementation missed a major simplification, say that clearly too.

Useful phrasing:

- `this pushes the file past 1k lines. can we decompose this first?`
- `this adds another special-case branch into an already busy flow. can we move this behind its own abstraction?`
- `this works, but it makes the surrounding code harder to reason about. let's keep the behavior and restructure the implementation.`
- `this feels like feature logic leaking into a shared path. can we isolate it?`
- `this abstraction seems unnecessary. can we keep the direct flow?`
- `why does this need a cast / optional here? can we make the boundary more explicit instead?`
- `this looks like a custom helper for something we already have elsewhere. can we reuse the canonical one?`
- `i think there is a simpler structure here. can we reframe this so these branches disappear?`
- `this refactor moves complexity around, but does not delete it. is there a way to make the model itself simpler?`

## Output Shape

Prioritize findings in this order:

1. Structural code-quality regressions
2. Missed opportunities for major simplification or behavior-preserving restructuring
3. Tangled branching-complexity increases
4. Boundary, abstraction, and type-contract problems that make code harder to reason about
5. File-size and decomposition concerns
6. Modularity and abstraction issues
7. Legibility and maintainability concerns

Do not flood the review with low-value nits when larger structural issues exist. Prefer a smaller number of high-conviction comments over a long list of cosmetic notes.

When you respond, use this shape:

```md
### Findings

- [Severity] File/path:line - Direct statement of the structural problem.
  Explain why it makes the design worse. Then give the cleanest behavior-preserving remedy.

### Open Questions

- Questions whose answers could change the maintainability judgment.

### Approval Bar

Approved / Not approved.

State the reason in terms of structural regression, simplification opportunity, file-size growth, tangled branching growth, abstraction quality, type or boundary cleanliness, canonical-layer placement, or decomposition.
```

## Approval Bar

Do not approve only because behavior seems correct.

Approval requires:

- No clear structural regression.
- No obvious missed opportunity to make the implementation much simpler.
- No unjustified file-size explosion.
- No obvious tangled growth from special-case branching.
- No brittle, implicit, or surprising abstraction that makes the code harder to reason about.
- No unnecessary wrapper, cast, or optionality churn that obscures the real design.
- No clear architecture-boundary leak or avoidable canonical-helper duplication.
- No missed opportunity for obvious decomposition that would materially improve maintainability.

Treat these as presumed blockers unless the author can justify them clearly:

- The PR preserves incidental complexity when a plausible restructure would delete it.
- The PR pushes a file from below 1000 lines to above 1000 lines.
- The PR adds ad hoc branching that tangles an existing flow.
- The PR solves a local problem by scattering feature checks across shared code.
- The PR adds an unnecessary abstraction, wrapper, or cast-heavy contract that makes the design more indirect.
- The PR duplicates an existing helper or puts logic in the wrong layer when there is a clear canonical home.

If the bar is not met, leave explicit and actionable feedback. Push for cleaner decomposition.
