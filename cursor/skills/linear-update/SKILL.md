---
name: linear-update
description: Generate a weekly project update from git history with a PM framework. Use when the user wants a summary of the past week's changes, a stakeholder update, or a team status report.
---

# Weekly Update From Git History

Analyze the past week of commits, PRs, and diffs. Produce a structured update for stakeholders, standups, or async status threads.

## When To Use

- The user says "linear-update" or `/linear-update <project-name>`.

## Arguments

The skill accepts an optional project name argument: `/linear-update <project-name>`.

- If the user provides a project name, use it directly as the `project` parameter when posting to Linear. Skip project selection in Step 4.
- If the user omits the project name, map from the current repo name to the Linear project:
  - `amadeus` -> `Amadeus | LLM Gateway`
  - `ai-sdk` -> `AI SDK | Ruby Gem`
  - `langfuse-rb` -> `Langfuse | Ruby Gem`

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

If the repo has no commits in the past 7 days, skip directly to Step 3. Produce a "no movement" update. Do not expand the window to include older commits. A quiet week is valid status.

### Step 2: Analyze And Categorize

Group changes with this classification:

| Category | What belongs here |
|----------|-------------------|
| **Shipped** | Merged PRs, completed features, and bug fixes now on main |
| **In Progress** | Open PRs and partially landed feature branches |
| **Removed / Deprecated** | Deleted code, removed features, and retired functionality |
| **Technical Health** | Refactors, dependency updates, CI/CD changes, and test improvements |

For each item, extract:

- What changed. Use one line. Use user-facing language when possible.
- Why it matters. State the impact, not only the implementation detail.
- Scope. Estimate small, medium, or large from files changed and diff size.

### Step 3: Produce The Update

Write in a conversational tone. Make it sound like a quick Slack post to the team, not a formal report.

Do not use `#` headers. Use plain text with light markdown. Use bold text for emphasis. Use bullets for lists.

Use this structure as a guide. Adapt it naturally. Do not copy it rigidly.

```text
What happened in [repo] this past week ([date range]).

**What shipped**
- [Thing] - [why it matters in one sentence]
- [Thing] - [impact]

**Still in flight**
- [Thing] - [what is left / blockers]

**Housekeeping**
- [Refactors, deps, CI, cleanup. Keep it brief.]

**Removed**
- [Anything deprecated or deleted, with rationale if evident]

Quick stats: N commits, N PRs merged, +N/-N lines across N files.

**Coming up**
[Infer from open PRs, draft PRs, or recent branch activity. If nothing is inferable, drop this section.]
```

### Step 4: Post To Linear

After you generate the update, post it directly to Linear as a project status update.

1. Identify the project. Use the project name passed as an argument, for example `/linear-update My Project`. If the user did not provide an argument, derive the repo name from the current working directory. Then map it to the Linear project with the repo-to-project mapping in Arguments.
2. Determine health. Always set health to `onTrack` unless the user explicitly specifies otherwise.
3. Post the update. Call `mcp__linear-server__save_status_update` with:
   - `type`: `"project"`
   - `project`: the project name or ID from step 1
   - `body`: the markdown update from Step 3
   - `health`: the health status from step 2

## Formatting Rules

- Write like you are talking to a teammate.
- Keep the text casual and clear.
- Do not add corporate filler.
- Lead with outcomes, not implementation details.
- Use active voice. Example: "Added search filtering" instead of "Search filtering was added".
- Collapse noisy commits into housekeeping, or omit them. This includes typo fixes, merge commits, and lint-only commits.
- If one feature spans multiple commits or PRs, roll them into one line item.
- Keep the full update under 30 lines. Brevity is part of the output quality.
- Do not use markdown headers such as `#` or `##`. This text goes into a Linear comment, not a document.

## Edge Cases

- Monorepo: If the repo has distinct packages or services, group by area before categorizing.
- Solo developer: Drop the Contributors line. Simplify to a personal changelog.
- No PRs: If there is no GitHub remote or `gh` is unavailable, build the update from the commit log.
- Empty week: Say so honestly. "No changes landed this week." is a valid update. Do not backfill with older commits to make the update look fuller. Silence is signal.
