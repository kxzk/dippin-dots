---
name: commit
description: Enforce the commit-message rules before each git commit. Use for direct commit requests and for workflows that create a commit.
---

# Commit Policy

Apply this skill before each `git commit` operation.

## Rule

- If this is the first commit on a Linear feature branch, use this title format: `[<ISSUE-ID>] <Issue Title>`.
- A Linear feature branch contains a name like `feature/ml-<number>-description`.
- In all other cases, use a Conventional Commit message.

## Branch Check

1. Resolve the default base branch from `origin/HEAD`.
2. Count commits on the current branch since the merge base with that default branch.
3. If the count is `0`, this is the first commit on the branch.
4. Check if the current branch is a Linear feature branch. It usually contains `feature/ml-<number>-description`.
5. Extract a Linear issue key from the branch name with this regex: `([A-Za-z]+-[0-9]+)`.
6. Apply the message format:
   - first commit plus Linear feature branch: `[<ISSUE-ID>] <Issue Title>`
   - all other cases: Conventional Commit

## Conventional Commit Format

- `<type>(<optional-scope>): <description>`
- Example: `feat(auth): add token refresh`
