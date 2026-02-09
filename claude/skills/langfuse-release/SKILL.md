---
name: langfuse-release
description: Cuts a new release of langfuse-rb — gathers unreleased commits, updates changelog, bumps version, commits, tags, and pushes. Use when the user wants to release a new version of the langfuse-rb gem.
---

# Langfuse Release

Cuts a release of the langfuse-rb gem from all commits since the last tag.

## When to Use

- User says `/langfuse-release 0.4.0` or "release langfuse-rb"
- User wants to cut a new version of the gem

## Input

A semver version string (e.g. `0.4.0`). Passed as the argument.

## Paths

All operations happen in `/Users/kade.killary/dev/langfuse-rb/`.

## Workflow

### Step 0: Pre-flight — Detect Untagged Release Commit

Before anything else, check if the last release was partially completed (commit pushed but tag forgotten):

```bash
cd /Users/kade.killary/dev/langfuse-rb
git log --oneline --grep="chore(release): bump version" -1
```

If a `chore(release): bump version to X.Y.Z` commit exists and the corresponding `vX.Y.Z` tag does **not** exist:

1. Extract the version and commit SHA from the log line
2. Create the tag on that commit: `git tag vX.Y.Z <sha>`
3. Push only the tag: `git push origin vX.Y.Z`
4. Tell the user the tag was retroactively applied and stop — the release is now complete

If the tag already exists, or no orphaned release commit is found, continue with Step 1.

### Step 1: Determine What's Unreleased

Find the latest tag and gather all commits since it:

```bash
cd /Users/kade.killary/dev/langfuse-rb
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

### Step 2: Draft the Changelog Entry

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
- Change the `[Unreleased]` link to compare against the new tag: `[Unreleased]: https://github.com/simplepractice/langfuse-rb/compare/vX.Y.Z...HEAD`
- Add a new line for this version: `[X.Y.Z]: https://github.com/simplepractice/langfuse-rb/compare/vPREVIOUS...vX.Y.Z`

### Step 3: Bump the Version

Edit `lib/langfuse/version.rb` — update the `VERSION` constant:

```ruby
VERSION = "X.Y.Z"
```

### Step 4: Update Gemfile.lock

```bash
cd /Users/kade.killary/dev/langfuse-rb && bundle install
```

This picks up the version change from the gemspec.

### Step 5: Commit

Stage exactly three files and commit:

```bash
git add CHANGELOG.md lib/langfuse/version.rb Gemfile.lock
git commit -m "chore(release): bump version to X.Y.Z"
```

### Step 6: Tag and Push

Create the tag and push both the commit and the tag. Use an explicit `git push origin vX.Y.Z` — do NOT rely on `--follow-tags` (it silently skips lightweight tags).

```bash
git tag vX.Y.Z
git push origin main
git push origin vX.Y.Z
```

### Step 7: Remind User to Publish

Do NOT run `gem push` — the user must do this manually for MFA.

Build the gem, then tell the user to publish it:

```bash
cd /Users/kade.killary/dev/langfuse-rb && gem build langfuse.gemspec
```

Print a message like:

> Release is ready. Run the following to publish and clean up:
>
> ```
> cd /Users/kade.killary/dev/langfuse-rb && gem push langfuse-rb-X.Y.Z.gem && rm langfuse-rb-X.Y.Z.gem
> ```

## Rules

- Commit message MUST be exactly `chore(release): bump version to X.Y.Z` — this matches the existing release history
- Tag MUST be `vX.Y.Z` (prefixed with `v`)
- Only stage the three release files — nothing else
- If any step fails, stop and surface the error. Do not retry silently
- Changelog descriptions should be concise and user-facing — strip internal jargon
