---
description: Create draft PR
allowed-tools: Bash(git:*)
---

# Context
- Get current branch name: !`git branch --show-current`

# Task
Your goal is to commit all changes made in this branch and create a draft pull request (PR) on GitHub.

# Steps
1. Figure out current branch name
2. Convert the branch name to Linear format (see examples below)
3. Write commit message in the format `[<issue number>] <branch name in title case>`
4. Create a draft PR with the title and body in the format `[<issue number>] <branch name in title case>`
5. Create a comment on the PR with a description of the changes made in the PR

<example>
Example branch name: `feature/p4m-892-improve-sidekiq-memory-instrumentation-and-rotation`
Example commit message: `[P4M-892] Improve sidekiq memory instrumentation and rotation`
Example PR title: `[P4M-892] Improve sidekiq memory instrumentation and rotation`
</example>

# PR Comment (Format)
- Write a brief summary of the changes
- Create an ASCII diagram of the changes made

# Links
- https://cli.github.com/manual/gh_pr_create
- https://cli.github.com/manual/gh_pr_list
- https://cli.github.com/manual/gh_pr_comment

# Command Reference

- Create draft PR: `gh pr create --draft --title "<PR_TITLE>"`
- List PRs: `gh pr list`
- Create comment: `gh pr comment <PR_NUMBER> --body "Hi from GitHub CLI"`

ultrathink
