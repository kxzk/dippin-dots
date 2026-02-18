---
name: adk-release
description: Cuts a new release of ai-sdk — creates a Linear issue, branches, bumps version, updates changelog, runs checks, commits, opens a PR, and returns to main. Merging the PR triggers CI to auto-tag. Use when the user wants to release a new version of the ai_sdk gem.
---

# AI SDK Release

Cuts a release of the ai_sdk gem end-to-end: Linear issue → branch → version bump + changelog → PR. Merging the PR to main triggers CI to auto-tag. There is no manual tagging or gem publishing step.

## When to Use

- User says `/adk-release 0.2.0` or "release ai-sdk"
- User wants to cut a new version of the gem

## Input

A semver version string (e.g. `0.2.0`). Passed as the argument.

## Paths

All operations happen in `/Users/kade.killary/dev/ai-sdk/`.

## Workflow

### Step 1: Create Linear Issue

Use `mcp__linear-server__create_issue` to create an issue:

- **Team**: Machine Learning
- **Project**: AI SDK | Ruby Gem
- **Title**: `Bump version to X.Y.Z`
- **Description**: `Bump AI::VERSION to X.Y.Z and update CHANGELOG.md for release.`
- **Assignee**: Kade Killary
- **Estimate**: 1 (XS)

Store the issue identifier (e.g. `ML-700`) and branch name from the response.

### Step 2: Create and Checkout Branch

```bash
cd /Users/kade.killary/dev/ai-sdk
git checkout main
git pull origin main
git checkout -b <branch-name-from-linear>
```

Use the `branchName` field from the Linear issue response. If no branch name exists, derive one: `<issue-id-lowercase>/bump-version-to-X-Y-Z`.

### Step 3: Determine What's Unreleased

Find the latest tag and gather all commits since it:

```bash
cd /Users/kade.killary/dev/ai-sdk
LATEST_TAG=$(git describe --tags --abbrev=0)
git log ${LATEST_TAG}..HEAD --oneline
```

Also pull the PR numbers and conventional-commit prefixes. Categorize each commit into Keep a Changelog sections:

| Prefix | Section |
|--------|---------|
| `feat` | **Added** |
| `fix` | **Fixed** |
| `refactor`, `perf` | **Changed** |
| `docs` | **Documentation** |
| `chore`, `ci`, `test`, `build` | Omit unless notable |

If there are zero meaningful commits, stop and tell the user there's nothing to release.

### Step 4: Draft the Changelog Entry

Read `CHANGELOG.md`. Build the new version section using today's date:

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- Description of feature (#PR)

### Fixed
- Description of fix (#PR)

### Changed
- Description of change (#PR)
```

Rules for the entry:
- Only include sections that have items (don't add empty `### Fixed` etc.)
- Each line item should be a human-readable description, not the raw commit message — rewrite if the commit message is unclear
- Include PR number in parentheses when available: `(#42)`
- Place the new section between `## [Unreleased]` and the previous release
- Leave `## [Unreleased]` empty (no subsections)

Update the comparison links at the bottom of `CHANGELOG.md`:
- Change the `[Unreleased]` link to compare against the new tag: `[Unreleased]: https://github.com/simplepractice/ai-sdk/compare/vX.Y.Z...HEAD`
- Add a new line for this version: `[X.Y.Z]: https://github.com/simplepractice/ai-sdk/compare/vPREVIOUS...vX.Y.Z`

### Step 5: Bump the Version

Edit `lib/ai/version.rb` line 2 — update the `VERSION` constant:

```ruby
VERSION = "X.Y.Z".freeze
```

### Step 6: Run Checks

Run the required checks before committing:

```bash
cd /Users/kade.killary/dev/ai-sdk
bundle exec rubocop
bundle exec rspec
```

If either fails, stop and surface the error. Do not commit broken code.

### Step 7: Commit

Stage exactly two files and commit:

```bash
cd /Users/kade.killary/dev/ai-sdk
git add CHANGELOG.md lib/ai/version.rb
git commit -m "[<ISSUE-ID>] Bump version to X.Y.Z"
```

The commit message follows the repo's `[ISSUE-ID] Title` pattern — identical to the PR title.

### Step 8: Push and Open PR

```bash
cd /Users/kade.killary/dev/ai-sdk
git push -u origin <branch-name>
```

Create the PR using the repo's PR template and conventions:

```bash
gh pr create --title "[<ISSUE-ID>] Bump version to X.Y.Z" --label "enhancement" --body "$(cat <<'EOF'
### Summary
- Bump `AI::VERSION` to X.Y.Z
- Update CHANGELOG.md with all changes since vPREVIOUS

### [Contributing guide](https://www.notion.so/simplepractice/Contributing-Guide-13ef2f8242f18099971adbc5c9caad84?pvs=4) checklist:
- [x] The PR has a label
- [x] The PR title follows the format `[$ISSUE_ID] $ISSUE_TITLE`
- [x] The first commit follows the format `[$ISSUE_ID] $ISSUE_TITLE`
- [x] This change does not introduce an API breaking change
- [x] Code has appropriate test coverage
- [x] I have performed a self-review of this code
- [ ] I have requested 2 reviewers
- [x] I have added an assignee

## Linear Issue
<ISSUE-ID>
EOF
)"
```

### Step 9: Return to Main

```bash
cd /Users/kade.killary/dev/ai-sdk
git checkout main
```

### Step 10: Update Linear Issue Status

Use `mcp__linear-server__update_issue` to move the issue to "In Review" state.

### Step 11: Confirm

Tell the user:

> Release PR created. Once merged to main, CI will automatically create and push the `vX.Y.Z` tag (see the "Tag Release" job).
>
> There is no gem publish step — this repo only creates a Git tag.

Print the PR URL.

## Rules

- Commit message and PR title MUST be identical: `[ISSUE-ID] Bump version to X.Y.Z`
- Tag format is `vX.Y.Z` (prefixed with `v`) — but CI creates it on merge, not this workflow
- Only stage the two release files (`CHANGELOG.md`, `lib/ai/version.rb`) — nothing else
- Do NOT manually create or push tags — CI handles tagging via the "Tag Release" job
- Do NOT run `gem push` — there is no gem publishing step in this repo
- Always return to `main` when done, even if a step fails
- Run rubocop + rspec before committing — don't ship broken code
- If any step fails, stop and surface the error. Do not retry silently
- Changelog descriptions should be concise and user-facing — strip internal jargon
