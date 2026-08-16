---
name: ship
description: Ship one Linear issue from start to PR. Read the issue, create the Linear branch, implement, commit, push, open a PR, and move the issue to In Review. Use when the user gives a Linear issue ID, such as `ML-123`, and asks to implement or ship it.
---

# Ship Issue

Ship a Linear issue from input to PR with one default flow.

## Input

- Required: Linear issue ID such as `ML-123`.

## Default Mode

This skill has one mode.

- Branch name: use the Linear branch name without edits.
- Commit title: `[<ISSUE-ID>] <Issue Title>`.
- PR title: use the same title as the commit.

## Workflow

### Step 1: Read Issue

Fetch issue details from Linear:

- title
- description
- branch name

### Step 2: Create Branch

```bash
git checkout main
git pull origin main
git checkout -b <resolved-branch-name>
```

### Step 3: Implement

Use the issue description as the work scope.

### Step 4: Commit

- Stage the relevant files.
- Use this commit title format: `[<ISSUE-ID>] <Issue Title>`.

### Step 5: Push And Open PR

```bash
git push -u origin <branch-name>
```

If a PR template exists, apply it first. Then append the generated summary after the template content.

Choose a PR label. First, check the repo labels with `gh label list`. Select a label that matches the issue type or content. If no good label exists, skip label assignment.

### Step 6: Return To Main

```bash
git checkout main
```

### Step 7: Update Issue State

Move the Linear issue to `In Review` after PR creation.

## Rules

- Commit title and PR title must match.
- Always return to `main` at the end.
- Always move the issue to `In Review`.
- Run lint and tests before commit when possible.
