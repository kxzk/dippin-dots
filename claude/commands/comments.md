---
description: Grab Pull Request comments and analyze.
---

Fetch and analyze all comments from the current Pull Request.

## Instructions

1. Run `!comments` to fetch all PR comments
2. Parse each comment to identify:
   - **File path** and line range
   - **Reviewer** (Copilot, human, etc.)
   - **Issue type**: namespace/encapsulation, missing test coverage, dependency ordering, null safety, naming
   - **Suggested fix** (if provided)

3. Group comments by:
   - **Severity**: blocking vs. nitpick vs. suggestion
   - **File**: cluster related feedback
   - **Pattern**: identify repeated issues (e.g., "constants at wrong scope" appears twice)

4. For each comment, determine:
   - Do I agree with the feedback? If not, why?
   - Is the suggested fix correct and complete?
   - Are there related issues the reviewer missed?

5. Output a summary:
```
   ## PR Comment Analysis

   ### Patterns Detected
   - [pattern]: [count] occurrences → [recommendation]

   ### By File
   - [file]: [n] comments
     - [ ] [issue summary] — [agree/disagree/partial] — [action]

   ### Recommended Order of Operations
   1. [highest-impact or dependency-first fix]
   2. ...
```

6. Ask me before making any changes. Present the proposed fixes and let me approve, modify, or skip each one.

## Context

The `!comments` command outputs reviewer comments in this format:
- Reviewer name → file:lines
- Description of issue
- Optional code suggestion in markdown fence

Treat Copilot suggestions as reasonable defaults but not gospel—validate the reasoning before accepting.
