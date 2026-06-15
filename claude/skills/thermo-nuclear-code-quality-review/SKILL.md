---
name: thermo-nuclear-code-quality-review
description: Run an extremely strict maintainability review for abstraction quality, giant files, and spaghetti-condition growth. Use for a thermo-nuclear code quality review, thermonuclear review, deep code quality audit, or especially harsh maintainability review.
---

# Thermo-Nuclear Code Quality Review

Use this skill for an unusually strict review focused on implementation quality, maintainability, abstraction quality, and codebase health.

This is not a normal polish pass. Push for ambitious structural simplification. Actively look for code-judo moves: behavior-preserving restructurings that make the implementation dramatically simpler, smaller, more direct, and more inevitable in hindsight.

Do not delegate the review to another model or sub-agent as a substitute for reading the diff yourself. The point of this skill is a direct, rigorous maintainability judgment grounded in the actual code.

## Baseline Prompt

Start from this baseline:

```text
Perform a deep code quality audit of the current branch's changes.
Rethink how to structure / implement the changes to meaningfully improve code quality without impacting behavior.
Work to improve abstractions, modularity, reduce spaghetti code, improve succinctness and legibility.
Be ambitious. If there is a clear path to improving the implementation that involves restructuring some of the codebase, go for it.
Be extremely thorough and rigorous. Measure twice, cut once.
```

## Non-Negotiable Standards

### 1. Be ambitious about structural simplification

Do not stop at "this could be cleaner." Search for ways to delete whole branches, helpers, modes, conditionals, or layers.

Prefer the design that makes the implementation feel obvious after the fact. If there is a path to delete complexity instead of rearranging it, push hard for that path.

### 2. Block unjustified 1000-line file crossings

Do not let a PR push a file from under 1000 lines to over 1000 lines without a very strong reason.

Treat this as a code-quality smell by default. Prefer extracting helpers, subcomponents, modules, or local abstractions instead of letting a file sprawl. If the diff crosses the threshold, explicitly ask whether the code should be decomposed first.

Only waive this when there is a compelling structural reason and the resulting file is still clearly organized.

### 3. Reject spaghetti growth

Be highly suspicious of ad-hoc conditionals, scattered special cases, one-off flags, nullable modes, or branches inserted into unrelated flows.

If a change adds weird `if` statements in random places, treat that as a design problem, not a stylistic nit. Prefer a dedicated abstraction, helper, state machine, policy object, or separate module.

Call out changes that make surrounding code harder to reason about, even when they technically work.

### 4. Prefer cleaner design over working mess

Do not approve code merely because behavior appears correct. If behavior can stay the same while the structure becomes meaningfully cleaner, push for the cleaner version.

Strongly prefer simplifications that remove moving pieces altogether over refactors that spread the same complexity around.

### 5. Prefer direct, boring code

Treat brittle, ad-hoc, or magical behavior as a maintainability problem.

Be skeptical of generic mechanisms that hide simple data-shape assumptions. Flag thin abstractions, identity wrappers, and pass-through helpers that add indirection without buying clarity.

### 6. Push on type and boundary cleanliness

Question unnecessary optionality, `unknown`, `any`, casts, silent fallbacks, and loosely-shaped objects when a clearer boundary could exist.

Prefer explicit typed models or shared contracts. If control flow relies on a fallback that papers over an unclear invariant, ask whether the invariant should be modeled directly.

### 7. Keep logic in the canonical layer

Call out feature logic leaking into shared paths or implementation details leaking through APIs.

Prefer existing canonical utilities over bespoke one-offs. Push logic toward the package, service, or module that already owns the concept.

### 8. Treat avoidable orchestration complexity as design debt

If independent work is serialized for no good reason, ask whether the flow should run in parallel.

If related updates can leave state half-applied, push for a more atomic structure. Do not over-index on micro-optimizations, but flag orchestration that makes the implementation more brittle.

## Primary Review Questions

For every meaningful change, ask:

- Is there a code-judo move that would make this dramatically simpler?
- Can the change be reframed so fewer concepts, branches, or helper layers are needed?
- Does this improve or worsen the local architecture?
- Did the diff add branching complexity where a better abstraction should exist?
- Did a cohesive module become more coupled, more stateful, or harder to scan?
- Is the logic living in the right file and layer?
- Did this enlarge a file or component past a healthy size boundary?
- Are repeated conditionals signaling a missing model or helper?
- Is the implementation direct and legible, or does it rely on special cases and incidental control flow?
- Is the abstraction earning its keep, or is it just a wrapper?
- Did the diff introduce casts, optionality, or ad-hoc object shapes that obscure the real invariant?
- Is the logic in the canonical layer, or did details leak across a boundary?
- Is orchestration more sequential or less atomic than it needs to be?

## What To Flag Aggressively

Escalate findings when you see:

- A complicated implementation where cleaner reframing could delete whole categories of complexity.
- Refactors that move code around without reducing the concepts a reader must hold.
- A file crossing 1000 lines due to the PR.
- New conditionals bolted onto unrelated code paths.
- One-off booleans, nullable modes, or flags complicating control flow.
- Feature-specific logic leaking into general-purpose modules.
- Generic magic that hides simple structure.
- Thin wrappers or identity abstractions that add indirection without simplifying anything.
- Unnecessary casts, `any`, `unknown`, or optional params muddying the contract.
- Copy-pasted logic instead of extracted helpers.
- Narrow edge-case handling in an already busy function.
- Refactors that pass tests but make the code less modular or less readable.
- Temporary branching likely to become permanent debt.
- Bespoke helpers where a canonical utility already exists.
- Logic in the wrong layer or package.
- Sequential async flow where independent work could stay clearer with parallel execution.
- Partial-update logic that leaves state less atomic than necessary.

## Preferred Remedies

Prefer remedies that remove or isolate complexity:

- Delete a whole layer of indirection rather than polishing it.
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
- Reuse canonical helpers instead of introducing near-duplicates.
- Make type boundaries explicit enough that control flow gets simpler.
- Move logic to the package, module, or layer that owns the concept.
- Parallelize independent work when that also simplifies orchestration.
- Restructure related updates into a more atomic flow.

Do not be satisfied with rename-level feedback when the real issue is structural. Do not accept a cleaner version of the same messy idea when there is a plausible path to a much simpler idea.

## Review Tone

Be direct, serious, and demanding about quality.

Do not be rude, but do not soften major maintainability issues into mild suggestions. If the code is making the codebase messier, say so clearly. If the implementation missed an opportunity for dramatic simplification, say that clearly too.

Useful phrasing:

- `this pushes the file past 1k lines. can we decompose this first?`
- `this adds another special-case branch into an already busy flow. can we move this behind its own abstraction?`
- `this works, but it makes the surrounding code more spaghetti. let's keep the behavior and restructure the implementation.`
- `this feels like feature logic leaking into a shared path. can we isolate it?`
- `this abstraction seems unnecessary. can we just keep the direct flow?`
- `why does this need a cast / optional here? can we make the boundary more explicit instead?`
- `this looks like a bespoke helper for something we already have elsewhere. can we reuse the canonical one?`
- `i think there's a code-judo move here that makes this much simpler. can we reframe this so these branches disappear?`
- `this refactor moves complexity around, but doesn't really delete it. is there a way to make the model itself simpler?`

## Output Shape

Prioritize findings in this order:

1. Structural code-quality regressions
2. Missed opportunities for dramatic simplification or code-judo restructuring
3. Spaghetti and branching-complexity increases
4. Boundary, abstraction, and type-contract problems that make code harder to reason about
5. File-size and decomposition concerns
6. Modularity and abstraction issues
7. Legibility and maintainability concerns

Do not flood the review with low-value nits when larger structural issues exist. Prefer a smaller number of high-conviction comments over a long list of cosmetic notes.

When responding, use this shape:

```md
### Findings

- [Severity] File/path:line - Direct statement of the structural problem.
  Explain why it makes the design worse, then give the cleanest behavior-preserving remedy.

### Open Questions

- Questions whose answers could change the maintainability judgment.

### Approval Bar

Approved / Not approved.

State the reason in terms of structural regression, simplification opportunity, file-size growth, spaghetti growth, abstraction quality, type/boundary cleanliness, canonical-layer placement, or decomposition.
```

## Approval Bar

Do not approve merely because behavior seems correct.

Approval requires:

- No clear structural regression.
- No obvious missed opportunity to make the implementation dramatically simpler.
- No unjustified file-size explosion.
- No obvious spaghetti growth from special-case branching.
- No hacky or magical abstraction that makes the code harder to reason about.
- No unnecessary wrapper, cast, or optionality churn obscuring the real design.
- No clear architecture-boundary leak or avoidable canonical-helper duplication.
- No missed opportunity for obvious decomposition that would materially improve maintainability.

Treat these as presumptive blockers unless the author can justify them clearly:

- The PR preserves incidental complexity when a plausible code-judo move would delete it.
- The PR pushes a file from below 1000 lines to above 1000 lines.
- The PR adds ad-hoc branching that tangles an existing flow.
- The PR solves a local problem by scattering feature checks across shared code.
- The PR adds an unnecessary abstraction, wrapper, or cast-heavy contract that makes the design more indirect.
- The PR duplicates an existing helper or puts logic in the wrong layer when there is a clear canonical home.

If the bar is not met, leave explicit, actionable feedback and push for cleaner decomposition.
