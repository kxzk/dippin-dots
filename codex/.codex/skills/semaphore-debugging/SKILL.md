---
name: semaphore-debugging
description: Debug and triage Semaphore CI pipelines/jobs with `sem-ai`, falling back to the legacy `sem` CLI only for interactive attach/debug flows that `sem-ai` does not cover.
---

# Semaphore Debugging

Use this skill for CI troubleshooting, stuck pipelines, flaky jobs, log
inspection, and safe recovery actions.

Prefer `sem-ai` for structured inspection and mutation. Use the legacy `sem`
CLI only when there is no equivalent `sem-ai` command, mainly interactive job
shells.

## Trigger

- CI is failing, flaky, stuck, or slow.
- The request mentions Semaphore, CI status, pipeline/workflow/job ids, logs,
  test failures, reruns, stops, promotions, or deployment state.
- You need real Semaphore runtime state before taking action.

## Session Start

```bash
sem-ai connect simplepractice.semaphoreci.com "$SEMAPHORE_API_TOKEN"
sem-ai context show
```

Fallback if env var is missing:

```bash
sem-ai connect simplepractice.semaphoreci.com <YOUR_API_TOKEN>
```

`sem-ai` shares the same `~/.sem.yaml` context file as the legacy `sem` CLI.

## Fast Incident Workflow

```bash
# Let sem-ai collect the first pass of evidence.
sem-ai diagnose <workflow-id>

# If the workflow id is not known yet:
sem-ai status --project simplepractice --branch <branch>
sem-ai workflow list --project simplepractice --branch <branch>

# Drill down when diagnose is not enough.
sem-ai workflow show <workflow-id>
sem-ai pipeline show <pipeline-id>
sem-ai job log <job-id>
sem-ai test summary --pipeline <pipeline-id>

# Recovery after inspection.
sem-ai pipeline rebuild <pipeline-id>
sem-ai workflow rerun <workflow-id>
sem-ai watch <workflow-id>
```

## Command Quick Reference

```bash
# Discovery
sem-ai status --project simplepractice --branch <branch>
sem-ai workflow list --project simplepractice
sem-ai pipeline list --project simplepractice
sem-ai job list

# Inspection
sem-ai workflow show <workflow-id>
sem-ai pipeline show <pipeline-id>
sem-ai pipeline topology <pipeline-id>
sem-ai job show <job-id>
sem-ai job log <job-id>
sem-ai test summary --pipeline <pipeline-id>
sem-ai test report --pipeline <pipeline-id>
sem-ai blast-radius <pipeline-id>
sem-ai critical-path <pipeline-id>

# Recovery
sem-ai job stop <job-id>
sem-ai pipeline stop <pipeline-id>
sem-ai pipeline rebuild <pipeline-id>
sem-ai workflow rerun <workflow-id>
sem-ai rerun-failed <pipeline-id>
sem-ai watch <workflow-id>
```

## Legacy `sem` Fallback

Use `sem` only when the needed workflow is not available in `sem-ai`.

```bash
# Running jobs only.
sem attach <job-id>

# Finished jobs only; then source the reproduced command environment.
sem debug <job-id>
source ~/commands.sh
```

Do not use `sem get` or `sem logs` by default anymore. The equivalent
inspection path is `sem-ai workflow show`, `sem-ai pipeline show`, and
`sem-ai job log`.

## Guardrails

- Read before mutate: inspect with `sem-ai diagnose`, `sem-ai workflow show`,
  `sem-ai pipeline show`, or `sem-ai job log` before stop/rerun/rebuild.
- `sem-ai` defaults to JSON. Use `--format table` for human scanning and JSON
  for scripts.
- Promotion commands require `--confirm`; do not add it until the target,
  parameters, and pipeline id have been verified.
- If command shape is unclear, run `sem-ai <command> --help` or
  `sem-ai discover` before guessing.

## Repo-Aware Check

CI behavior is defined by repo files. Confirm before assumptions:

- `<app-repo>/.semaphore/ci.yml`
- `<app-repo>/.semaphore/*.sh`
- `<app-repo>/scripts/*ci*`

For `simplepractice`, treat `change_in` and branch-specific rules as the source
of truth from CI config.

Reference: `https://docs.semaphore.io/reference/sem-ai-cli`
