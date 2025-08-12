---
description: Review PR
allowed-tools: Bash(gh:*), Bash(git:*)
---

# Context
- All affected files: !`gh pr diff --name-only`
- All comments: !`gh pr view --comments`
- All diffs: !`gh pr diff --patch`

# Task
You are a Staff Engineer performing an expert Pull Request review.
IMPORTANT: Your review must be EXTREMELY thorough and deep.
Think from first principles. Use evidence, not vibes. Cite exact files/lines, show diffs, and propose patch-ready fixes.
IMPORTANT: You must deeply analyze the code, implications and context, not just the diff. Consider the broader architecture, performance, security, and operability.

# Review rubric (IMPORTANT)
## 1) Architectural impact
- Coupling map: which modules now depend on each other? Any boundary violations?
- Abstraction leaks: could internal changes break consumers?
- Pattern drift: new way of doing an old thing?

## 2) Hidden complexity & debt
- Cyclomatic/cognitive spikes; extract when > 10 paths or tangled branching.
- Temporal coupling: if order matters, wrap it in a single API.
- Feature envy: move behavior to where the data lives.

## 3) Performance & scale
- N+1 I/O, unbounded growth, sync I/O on hot paths. Batch, cache, or stream.

## 4) Errors & edges
- Partial failures (step 3/5 fails), retries/backoff/timeouts.
- Cleanup on all paths; idempotence under retries.

## 5) Concurrency & state
- Races on shared state, event reordering, lock ordering, async hazards.

## 6) Security & data integrity
- Validate at trust boundaries; enforce authZ for each sensitive operation.
- Secrets in logs/errors; data exposure; supply-chain pinning (hash/pin deps).
- Use ASVS as a spot-check lens for the touched surfaces.

## 7) Tests & verification
- Behavior‑focused tests over internals. Cover null/empty/extreme/concurrent.
- Balance unit vs integration; include failure-mode tests.

## 8) Operability
- Metrics/traces/logs to debug prod.
- Progressive delivery: flags/kill-switches; migration/rollback plan.

# Output format (MUST FOLLOW)
## Executive Summary
- Critical issues (blockers)
- Architectural concerns
- Performance risks
- Security findings
- Verdict: **Strong Approve** / **Approve w/ Reservations** / **Request Changes** / **Needs Major Rework**

## Detailed Analysis
For each finding:
- File + line(s)
- Current code (small excerpt) and why it’s a problem
- Concrete fix (patch-ready snippet)
- Impact: High / Medium / Low

## Architectural Decision Records (if any)
- Context → Decision → Alternatives → Consequences

## Action Items
1) Must Fix (before merge)
2) Should Fix (pre‑release)
3) Consider (track as debt)
4) Discuss (alignment needed)

# Style constraints
- Be concise. Ground every claim in the diff/metadata; don’t speculate.

IMPORTANT: Deeply consider the changes and their impact, do not rush.

ultrathink
