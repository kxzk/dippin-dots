---
name: adk-release
description: "Make a new release of the ai_sdk gem. Create the Linear release issue, branch, bump AI::VERSION, update CHANGELOG.md, run checks, commit, push, open a PR, and return to main. Use when the user wants to release a new ai-sdk version."
---

# AI SDK Release

Make an ai-sdk gem release through a PR.

Merging the PR to `main` starts the GitHub Actions `Tag Release` job. That job creates and pushes the `vX.Y.Z` tag.

There is no manual tag step. There is no manual gem-publish step.

## When To Use

- The user says `adk-release 0.7.0`.
- The user asks to release ai-sdk or make a new ai_sdk gem version.
- The user gives a target semver version for `/Users/kade.killary/dev/ai-sdk`.

## Required Input

- A semver version string without a leading `v`. Example: `0.7.0`.

Reject unclear input. Do not guess the version.

## Paths

All release operations happen in:

```bash
/Users/kade.killary/dev/ai-sdk
```

Edit and stage only these files:

- `CHANGELOG.md`
- `lib/ai/version.rb`

## Preconditions

1. Validate the version string:

   ```bash
   case "<version>" in
     [0-9]*.[0-9]*.[0-9]*) ;;
     *) echo "Version must be semver without a leading v" && exit 1 ;;
   esac
   ```

2. Inspect repository state before you change branches:

   ```bash
   cd /Users/kade.killary/dev/ai-sdk
   git status --short
   git branch --show-current
   git fetch origin main --tags
   ```

3. Stop if the worktree is dirty, unless the only changes are known release edits from this same run.

4. Do not overwrite user changes.

5. Do not carry user changes across branches.

6. Stop if the release tag already exists:

   ```bash
   git rev-parse -q --verify "refs/tags/v<version>"
   ```

## Workflow

### 1. Create Linear Issue

Use the Linear connector. If the Linear tool is not loaded, discover it with tool search before you use the Linear API or ask the user.

Create an issue with:

- Team: `Applied AI`
- Title: `Bump version to X.Y.Z`
- Description: `Bump AI::VERSION to X.Y.Z and update CHANGELOG.md for release.`
- Assignee: `Kade Killary`
- Label: `ai-sdk`
- Estimate: `1`

Store the issue ID, for example `AAI-123`.

Store the Linear branch name from the response.

### 2. Create Branch

Use the branch name returned by Linear. If the response has no branch name, derive one:

```text
<issue-id-lowercase>/bump-version-to-X-Y-Z
```

Then create the branch:

```bash
cd /Users/kade.killary/dev/ai-sdk
git checkout main
git pull --ff-only origin main
git checkout -b <branch-name>
```

### 3. Determine Unreleased Changes

Find the latest reachable tag. Then inspect commits since that tag:

```bash
cd /Users/kade.killary/dev/ai-sdk
LATEST_TAG="$(git describe --tags --abbrev=0)"
git log "${LATEST_TAG}..HEAD" --oneline --decorate
```

Also read the current `## [Unreleased]` section in `CHANGELOG.md`.

Put meaningful changes into Keep a Changelog sections:

| Commit Prefix | Changelog Section |
| --- | --- |
| `feat` | `Added` |
| `fix` | `Fixed` |
| `refactor`, `perf` | `Changed` |
| `docs` | `Documentation` |
| `chore`, `ci`, `test`, `build` | Omit unless user-facing or operationally notable |

If there are no meaningful unreleased changes, stop. Tell the user there is nothing to release.

### 4. Update CHANGELOG.md

Move the current unreleased notes into a new section. Use the current local date:

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- Human-readable release note (#PR)
```

Rules:

- Keep `## [Unreleased]` present and empty after you move the release section.
- Include only sections that have items.
- Rewrite raw commit messages into concise user-facing release notes.
- Include PR numbers when known. Example: `(#139)`.
- Place `## [X.Y.Z] - YYYY-MM-DD` between `## [Unreleased]` and the previous release.
- Update comparison links at the bottom:
  - `[Unreleased]: https://github.com/simplepractice/ai-sdk/compare/vX.Y.Z...HEAD`
  - `[X.Y.Z]: https://github.com/simplepractice/ai-sdk/compare/vPREVIOUS...vX.Y.Z`

### 5. Bump Version

Edit `lib/ai/version.rb` to match the existing style:

```ruby
module AI
  VERSION = "X.Y.Z"
end
```

Do not add `.freeze` unless the file already uses it.

### 6. Run Checks

Run both checks before you commit:

```bash
cd /Users/kade.killary/dev/ai-sdk
bundle exec rubocop
bundle exec rspec
```

If local Ruby resolution fails because the default Ruby is unstable, retry with the known-good local runtime:

```bash
RBENV_VERSION=3.4.8 rbenv exec bundle exec rubocop
RBENV_VERSION=3.4.8 rbenv exec bundle exec rspec
```

If either check fails because of code or docs, stop and show the failure. Do not commit broken release changes.

### 7. Commit

Stage exactly the release files:

```bash
cd /Users/kade.killary/dev/ai-sdk
git add CHANGELOG.md lib/ai/version.rb
git diff --cached --name-only
```

The staged file list must be exactly:

```text
CHANGELOG.md
lib/ai/version.rb
```

Commit with a title identical to the PR title:

```bash
git commit -m "[<ISSUE-ID>] Bump version to X.Y.Z"
```

### 8. Push And Open PR

Push the branch:

```bash
cd /Users/kade.killary/dev/ai-sdk
git push -u origin <branch-name>
```

Create the PR against `main` with this title:

```text
[<ISSUE-ID>] Bump version to X.Y.Z
```

Use the repo PR template if present. If you create the body manually, use this shape:

```markdown
### Summary
- Bump `AI::VERSION` to X.Y.Z
- Update `CHANGELOG.md` with changes since vPREVIOUS

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
```

Apply the `enhancement` label if it exists. If it does not exist, do not fail PR creation only because of the label.

### 9. Move Linear Issue To In Review

After the PR exists, update the Linear issue state to `In Review`.

### 10. Return To Main

After clean PR creation, run:

```bash
cd /Users/kade.killary/dev/ai-sdk
git checkout main
git pull --ff-only origin main
```

If a failure leaves uncommitted release edits, do not force checkout. Preserve the branch. Report the exact `git status --short` output.

### 11. Slack Announcement

After the PR exists, post to Slack by default.

The user will merge the PR separately. Use released wording even if the tag does not exist yet.

Rewrite the changelog entry into a concise Slack message:

```text
:package: *ai-sdk vX.Y.Z released*

- New durable Agent/Session/Step APIs - multi-turn agent loops that survive process restarts
- Human-in-the-loop tool approval - gated tools pause the loop instead of executing
- Better API status errors - AuthenticationError, RateLimitError, InvalidRequestError, and ServerError expose HTTP status and response body
```

Keep the message short. Group related items. Omit trivial CI-only and test-only changes.

Do not include PR status wording. Do not include a PR link in the Slack announcement.

Post through the `slack` CLI:

```bash
slack < /tmp/ai-sdk-release-slack.txt
```

The `slack` command defaults to `#ask-ai-team`. It requires `SLACK_BOT_TOKEN`.

If the token is missing or the post fails, warn the user. Do not treat the release PR as failed.

## Confirmation

Tell the user:

```text
Release PR created: <PR URL>

Once merged to main, CI will create and push the vX.Y.Z tag via the Tag Release job.
There is no gem publish step.
```

## Rules

- Commit message and PR title must be identical: `[ISSUE-ID] Bump version to X.Y.Z`.
- The release tag format is `vX.Y.Z`.
- CI creates the tag on merge. Do not manually create or push release tags.
- Do not run `gem push`.
- Do not edit or stage files other than `CHANGELOG.md` and `lib/ai/version.rb`.
- Do not carry unrelated dirty worktree changes across branch checkouts.
- Run RuboCop and RSpec before you commit.
- If a step fails, stop and report the exact failure.
- Keep changelog descriptions concise and user-facing.
- Remove internal jargon from changelog descriptions.
