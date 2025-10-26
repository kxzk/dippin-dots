---
description: Extract focused context for a new task thread
argument-hint: <goal for new thread>
---

# Context Handoff

You are analyzing the current conversation to prepare a handoff to a fresh thread. Write final results in `handoff.md`.

## Goal for New Thread

$ARGUMENTS

## Your Task

1. **Analyze the current thread** for context relevant to the stated goal above

2. **Extract only what matters:**
   - Core decisions or patterns already established
   - File paths and their role (not entire contents)
   - Active constraints or requirements
   - Context that would be costly to lose

3. **Generate a draft prompt** for the new thread that:
   - States the goal explicitly
   - Provides necessary context without rehashing history
   - Lists relevant files with brief purpose statements
   - Sets clear boundaries for the new task

## Output Format

Present your analysis as a ready-to-use starting prompt:

```
# New Thread: [Goal]

## Context

[Only essential background - 2-3 sentences max]

## Task

[Clear, actionable description of what needs to happen]

## Relevant Files

- path/to/file.ext - [why it matters for this specific task]
- path/to/other.ext - [its role in the new goal]

## Constraints

[Explicit assumptions, dependencies, or limitations]
```

Write final prompt to handoff.md

## Principles

- **Focused over comprehensive**: Include only what serves the new goal
- **Explicit over implicit**: Surface hidden assumptions
- **Forward-looking over historical**: Frame for action, not recap
- **Minimal viable context**: Less is more—trust the model to reason

## Anti-patterns to Avoid

- Don't summarize the entire conversation
- Don't include tangential discussions
- Don't preserve solved problems
- Don't copy-paste large code blocks

The goal is to create a **fresh thread with a narrow aperture**, not to preserve everything.
