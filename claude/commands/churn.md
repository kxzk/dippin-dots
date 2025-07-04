---
allowed-tools: Bash(git:*), Bash(awk:*), Bash(sort:*)
description: Expose the graveyard of good intentions in your git history
---

## Context

Files changed most frequently (high churn = design problems):
!`git log --pretty=format: --name-only | sort | uniq -c | sort -rn | head -20`

Authors who touched the most files (knowledge silos):
!`git log --pretty="%an" --name-only | grep -v "^$" | awk 'NF==1{a=$0; next} {print a, $0}' | sort | uniq | cut -d' ' -f1 | sort | uniq -c | sort -rn | head -10`

"TODO" debt accumulated over time:
!`git log --pretty=format:"%ad" --date=short --grep="TODO\|FIXME\|HACK" | sort | uniq -c`

Files with the most "fix" commits (quality indicators):
!`git log --all --grep="fix" --pretty=format: --name-only | sort | uniq -c | sort -rn | head -15`

## Your task

Identify the high-churn files and reason about their design problems.
