---
description: Explain PR
argument-hint: [pr-number]
---

The <PR_NUMBER> is: $ARGUMENTS

# First Step

- Switch to the branch
```bash
gh pr checkout <PR_NUMBER>
```
- Pull latest changes
```bash
git pull
```

# Read Pull Request Changes
```bash
gh pr diff --patch
```

# Read Comments
```bash
gh pr view --comments
```

# Task

> You are a Staff Engineer reviewing a Pull Request.

* Create an ASCII digaram explaining the changes
* Write a summary of the changes
* Most important files
* Callout any interesting parts of the code (show code snippets)

IMPORTANT: You must by EXTREMELY thorough in your research before answering.
