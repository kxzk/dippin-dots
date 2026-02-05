---
name: linear-update
description: Generates a weekly project update from git history using a PM framework. Use when the user wants a summary of the past week's changes, a stakeholder update, or a team status report.
---

# Weekly Update from Git History

Analyzes the past week of commits, PRs, and diffs to produce a structured update suitable for stakeholders, standups, or async status threads.

## When to Use

- User asks for a weekly update, status report, or changelog
- User wants to summarize recent work for a team or stakeholder
- User says "linear-update" or "/linear-update"

## Workflow

### Step 1: Gather Raw Data

Run these commands to collect the past week of activity:

```bash
# Commits from the last 7 days (all authors)
git log --since="7 days ago" --pretty=format:"%h %s (%an, %ad)" --date=short

# Stat summary of changes
git diff --stat "$(git log --since='7 days ago' --format='%H' | tail -1)^"..HEAD 2>/dev/null || git diff --stat HEAD~20..HEAD

# Merged PRs (if gh is available)
gh pr list --state merged --search "merged:>=$(date -v-7d +%Y-%m-%d 2>/dev/null || date -d '7 days ago' +%Y-%m-%d)" --limit 30 --json number,title,author,labels,mergedAt 2>/dev/null

# Open PRs (context for "in progress")
gh pr list --state open --json number,title,author,labels,isDraft 2>/dev/null
```

If the repo has no commits in the past 7 days, skip directly to Step 3 and produce a "no movement" update. Do NOT expand the window to pull in older commits — a quiet week is a valid status.

### Step 2: Analyze and Categorize

Group changes using this classification:

| Category | What belongs here |
|----------|-------------------|
| **Shipped** | Merged PRs, completed features, bug fixes now on main |
| **In Progress** | Open PRs, partially landed feature branches |
| **Removed / Deprecated** | Deleted code, removed features, sunset functionality |
| **Technical Health** | Refactors, dependency updates, CI/CD changes, test improvements |

For each item, extract:
- **What** changed (one line, user-facing language where possible)
- **Why** it matters (impact, not implementation detail)
- **Scope** — estimate: small / medium / large based on files changed and diff size

### Step 3: Produce the Update

Write in a **conversational, human tone** — like a quick Slack post to your team, not a formal report. No headers with `#`. Use plain text with light markdown (bold for emphasis, bullets for lists). It should read like a person wrote it, not a template filled it in.

Use this structure as a guide (adapt naturally, don't copy rigidly):

```
Hey team — here's what happened in [repo] this past week ([date range]).

**What shipped**
- [Thing] — [why it matters in one sentence]
- [Thing] — [impact]

**Still in flight**
- [Thing] — [what's left / blockers]

**Housekeeping**
- [Refactors, deps, CI, cleanup — keep it brief]

**Removed**
- [Anything deprecated or deleted, with rationale if evident]

Quick stats: N commits, N PRs merged, +N/-N lines across N files.

**Coming up**
[Infer from open PRs, draft PRs, or recent branch activity. If nothing is inferrable, drop this section.]
```

### Step 4: Copy to Clipboard

After generating the update, copy the final text to the clipboard using `pbcopy` so the user can paste directly into Linear.

## Formatting Rules

- Write like you're talking to a teammate — casual, clear, no corporate filler
- Lead with outcomes, not implementation details
- Use active voice: "Added search filtering" not "Search filtering was added"
- Collapse noisy commits (typo fixes, merge commits, lint) into housekeeping or omit entirely
- If a single feature spans multiple commits/PRs, roll them up into one line item
- Keep the entire update under 30 lines — brevity is the feature
- No markdown headers (`#`, `##`) — this is going into a Linear comment, not a doc

## Edge Cases

- **Monorepo**: If the repo has distinct packages/services, group by area before categorizing
- **Solo dev**: Drop the Contributors line, simplify to a personal changelog
- **No PRs** (no GitHub remote or gh unavailable): Build entirely from commit log — that's fine
- **Empty week**: Say so honestly. "No changes landed this week." is a valid update. Do not backfill with older commits to make the update look fuller — silence is signal
