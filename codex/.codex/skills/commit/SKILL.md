---
name: commit
description: Enforce commit message policy whenever a commit is requested or about to be performed. Trigger for direct commit requests and any workflow step that creates a commit.
---

# Commit Policy

Apply this skill before every `git commit` operation.

## Rule

- If this is the first commit on a Linear feature branch (contains feature/ml-<number>-description), use the commit title format: `[<ISSUE-ID>] <Issue Title>`.
- Otherwise, use a Conventional Commit message.

## Branch check

1. Resolve the default base branch from `origin/HEAD`.
2. Count commits on the current branch since the merge base with that default branch.
3. If the count is `0`, this is the first commit on the branch.
4. Detect whether the current branch is a Linear feature branch by extracting a Linear issue key from the branch name with regex `([A-Za-z]+-[0-9]+)`.
5. Apply message format:
   - first commit + Linear feature branch: `[<ISSUE-ID>] <Issue Title>`
   - all other cases: Conventional Commit

## Conventional Commit format

- `<type>(<optional-scope>): <description>`
- Example: `feat(auth): add token refresh`
