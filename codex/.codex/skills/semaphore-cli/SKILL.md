---
name: semaphore-cli
description: Debug and triage Semaphore CI pipelines/jobs for SimplePractice with `sem` (pipelines, workflows, jobs, logs, attach/debug, stop/rebuild). Trigger when CI is failing, flaky, stuck, queued, or when pipeline/workflow/job IDs must be inspected.
---

# Semaphore CI Debugging (SimplePractice)

Use this skill for CI troubleshooting only.

## Trigger

- CI is failing, flaky, stuck, or slow.
- The request mentions `sem`, pipeline/workflow/job IDs, logs, attach/debug, stop, or rebuild.
- You need real Semaphore runtime state before taking action.

## Out Of Scope

- Generic Semaphore admin (secrets, dashboards, deployment targets) unless explicitly requested.
- Authoring `.semaphore/*.yml` without live CI operations.
- Local build/test work unrelated to Semaphore state.

## Session Start

```bash
sem connect simplepractice.semaphoreci.com "$SEMAPHORE_API_TOKEN"
sem context
```

Fallback if env var is missing:

```bash
sem connect simplepractice.semaphoreci.com <YOUR_API_TOKEN>
```

Expected: `sem context` shows `simplepractice.semaphoreci.com` with `*`.

## Command Quick Reference

```bash
# Discovery
sem get pipelines -p simplepractice
sem get workflows -p simplepractice
sem get workflow <workflow-id>
sem get pipeline <pipeline-id>
sem get jobs

# Debugging
sem logs <job-id>
sem attach <job-id>   # running jobs only
sem debug <job-id>    # finished jobs
# then in debug shell:
source ~/commands.sh

# Recovery
sem stop job <job-id>
sem stop pipeline <pipeline-id>
sem rebuild pipeline <pipeline-id>
sem rebuild pipeline <pipeline-id> --follow
sem rebuild workflow <workflow-id>
```

## Fast Incident Workflow

1. `sem get pipelines -p simplepractice`
2. `sem get pipeline <pipeline-id>`
3. `sem logs <job-id>`
4. `sem debug <job-id>` then `source ~/commands.sh`
5. `sem rebuild pipeline <pipeline-id> --follow`

## Guardrails

- Read before mutate: inspect with `sem get`/`sem logs` before stop/rebuild.
- `sem attach` only works on running jobs.
- `sem debug` is for finished jobs; run `source ~/commands.sh` before reproducing.
- `rebuild pipeline` reruns failed jobs only.
- `rebuild workflow` reruns all jobs.
- If flags are unclear, run `sem help <command>` first.

## Repo-Aware Check

- CI behavior is defined by repo files. Confirm before assumptions:
  - `<app-repo>/.semaphore/ci.yml`
  - `<app-repo>/.semaphore/*.sh`
  - `<app-repo>/scripts/*ci*`
- For `simplepractice`, treat `change_in` and branch-specific rules as the source of truth from CI config.

Reference: `https://docs.semaphore.io/reference/semaphore-cli`
