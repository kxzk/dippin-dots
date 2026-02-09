---
name: ship
description: Executes a Linear issue end-to-end — reads the issue, creates a branch, implements the work, commits, opens a PR, and returns to main. Use when the user provides a Linear issue identifier and wants it implemented.
---

# Ship Issue

Takes a Linear issue identifier, implements it, and ships a PR — all in one shot.

## When to Use

- User says `/ship ML-123` or "ship ML-123"
- User provides a Linear issue ID and wants it implemented

## Input

A Linear issue identifier (e.g. `ML-123`). Passed as the argument.

## Workflow

### Step 1: Read the Issue

Use the `mcp__linear-server__get_issue` tool with the provided issue identifier to fetch:
- Title
- Description
- Git branch name

Store these — they drive everything downstream.

### Step 2: Create and Checkout Branch

```bash
git checkout main
git pull origin main
git checkout -b <branch-name-from-linear>
```

Use the `branchName` field from the Linear issue response. If no branch name exists, derive one: `<issue-id-lowercase>/<slugified-title>` (e.g. `ml-123/add-retry-logic`).

### Step 3: Implement the Issue

Read the issue description carefully. It contains the requirements.

- Explore the codebase to understand the relevant code
- Implement the changes described in the issue
- Follow all project conventions from CLAUDE.md
- Run the project's lint and test commands to verify

This is the core work — take as much latitude as needed to do it well.

### Step 4: Commit

Stage and commit all changes. The commit message format is:

```
[<ISSUE-ID>] <issue title>
```

Extract both from the branch name: the issue ID is the prefix (e.g. `ML-123` from `feature/ml-123-add-retry-logic`), and the title is the rest, un-slugified.

Example: branch `feature/ml-496-add-to-langfuse-method` → commit message `[ML-496] Add to langfuse method`

```bash
git add <specific-files>
git commit -m "[<ISSUE-ID>] <issue title>"
```

### Step 5: Push and Open PR

```bash
git push -u origin <branch-name>
```

Create the PR with the same title as the commit.

Before generating the body, check if the repo has a pull request template at any of these paths:
- `.github/pull_request_template.md`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `docs/pull_request_template.md`
- `PULL_REQUEST_TEMPLATE.md`

If a template exists, read it and use its structure as the PR body — fill in each section with the relevant details from the issue and implementation.

Before creating the PR, select the most appropriate GitHub label by running `gh label list` and matching against the nature of the change:

- **bug** — the issue fixes broken behavior
- **enhancement** — the issue adds new functionality or improves existing behavior
- **documentation** — the issue is purely docs changes

Default to `enhancement` if the issue doesn't clearly fit another category. Use a single label — don't over-tag.

If no template exists, fall back to the default body:

```bash
gh pr create --title "[<ISSUE-ID>] <issue title>" --label "<label>" --body "$(cat <<'EOF'
## Summary
<brief description of what was done>

## Linear Issue
<ISSUE-ID>
EOF
)"
```

### Step 6: Return to Main

```bash
git checkout main
```

### Step 7: Update Linear Issue Status

Use `mcp__linear-server__update_issue` to move the issue to "In Review" state (or equivalent review state for the team).

## Rules

- Commit message and PR title MUST be identical: `[ISSUE-ID] Title`
- Always return to `main` when done, even if a step fails
- Run lint + tests before committing — don't ship broken code
- Stage specific files, not `git add .`
