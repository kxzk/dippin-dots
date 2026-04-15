---
name: ship
description: "Ship a Linear issue end-to-end: read issue, create Linear branch, implement, commit, push, open PR, and move issue to In Review. Trigger when the user provides a Linear issue ID (for example `ML-123`) and asks to implement/ship."
---

# Ship Issue

Execute a Linear issue from input to PR with one default flow.

## Input

- Required: Linear issue identifier like `ML-123`.

## Default Mode (Only Mode)

- Branch name: use Linear branch name as-is.
- Commit title: `[<ISSUE-ID>] <Issue Title>`.
- PR title: match the commit title.

## Workflow

### Step 1: Read issue

Fetch issue details from Linear:

- title
- description
- branch name

### Step 2: Create branch

```bash
git checkout main
git pull origin main
git checkout -b <resolved-branch-name>
```

### Step 3: Implement

Use the issue description as scope.

### Step 4: Commit

- Stage relevant files.
- Use commit title format: `[<ISSUE-ID>] <Issue Title>`.

### Step 5: Push and open PR

```bash
git push -u origin <branch-name>
```

If a PR template exists, apply it first and append the generated summary after template content.

Choose a PR label. First, consult the repo's existing labels (`gh label list`) for a match based on issue type or content. If no suitable label is found, ignore label assignment.

### Step 6: Return to main

```bash
git checkout main
```

### Step 7: Update issue state

Move the Linear issue to `In Review` after PR creation.

## Rules

- Commit and PR titles must match.
- Always return to `main` at the end.
- Always move issue to `In Review`.
- Run lint/tests before commit when possible.
