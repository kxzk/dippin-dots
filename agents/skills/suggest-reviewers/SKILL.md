---
name: suggest-reviewers
description: Suggest the top 3 PR reviewers by analyzing commit history for files changed on a branch, then filter to active maintainers. Use when asked for suggested reviewers, best reviewers for a PR, or likely owners for changed files.
---

# Suggest Reviewers

Rank reviewer candidates using commit recency and frequency for files changed between base and head, then return the top 3 active reviewers.

## Inputs

- A checked-out git branch in the target repository.
- Optional `gh` authentication for collaborator access checks on GitHub remotes.
- Optional explicit `--base` (default auto-detects from `origin/HEAD`).

## Workflow

1. Run the reviewer suggestion script.
2. Return up to 3 reviewers in ranked order with a short reason.
3. If fewer than 3 are available, state why instead of padding with weak suggestions.

## Command

```bash
uv run --script scripts/suggest_reviewers.py --top 3
```

```bash
uv run --script scripts/suggest_reviewers.py \
  --base origin/main \
  --head HEAD \
  --activity-days 180 \
  --exclude @my-handle \
  --json
```

## Selection Rules

- Score candidates by commit frequency and recency on changed files.
- Exclude bots and branch authors by default.
- Keep only candidates active in this repository within `--activity-days`.
- If `gh` is available and remote is GitHub, check collaborator access and drop non-collaborators.

## Guardrails

- Do not suggest inactive reviewers to fill a quota.
- Prefer candidates with GitHub logins because PR reviewers need assignable handles.
- If there are no changed files vs base, report no suggestions instead of guessing.
