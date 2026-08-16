---
name: semaphore-debugging
description: Debug and triage Semaphore CI pipelines and jobs with `sem-ai`. Use old `sem` only for interactive attach or debug flows that `sem-ai` does not cover.
---

# Semaphore Debugging

Use this skill for CI troubleshooting, stuck pipelines, flaky jobs, log inspection, and safe recovery actions.

Use `sem-ai` for structured inspection and mutation. Use the old `sem` CLI only when no equivalent `sem-ai` command exists. This mainly applies to interactive job shells.

## Trigger

- CI is failing, flaky, stuck, or slow.
- The request mentions Semaphore, CI status, pipeline IDs, workflow IDs, job IDs, logs, test failures, reruns, or stops.
- You need real Semaphore runtime state before you act.

## Session Start

```bash
sem-ai context show
```

Connect only when no valid context exists:

```bash
sem-ai connect simplepractice.semaphoreci.com "$SEMAPHORE_API_TOKEN"
```

`sem-ai` uses the same `~/.sem.yaml` context file as the old `sem` CLI.

## Fast Incident Workflow

```bash
# Find CI for the current commit and branch.
sem-ai status

# Use the pull request when that is the requested scope.
sem-ai status --pr <pull-request-number>

# Collect the first evidence pass. The workflow ID is optional.
sem-ai diagnose
sem-ai diagnose <workflow-id>

# Drill down when diagnose is not enough.
sem-ai workflow show <workflow-id>
sem-ai pipeline show <pipeline-id>
sem-ai test summary --pipeline <pipeline-id>
sem-ai job log <job-id>

# If the user asks for recovery, retry failed blocks after you identify the cause.
sem-ai rerun-failed <pipeline-id>

# Capture the returned IDs. Then wait and verify the new run.
sem-ai watch <workflow-id>
sem-ai status
sem-ai test summary --pipeline <new-pipeline-id>
```

## 1. Identify the Exact Run

```bash
sem-ai status
sem-ai status --pr <pull-request-number>
sem-ai status --project <project> --branch <branch>
sem-ai workflow list --project <project> --branch <branch>
```

Run `sem-ai status` from the repository checkout. It detects the project, branch, and current commit.

- Prefer a result with `matched_by: "commit_sha"`.
- If the result uses `matched_by: "latest_on_branch"`, state that the match is not exact.
- If the result has `multiple_projects: true`, set `--project` and run the command again.
- Use `--pr` when the request is about a pull request. It takes priority over `--branch`.
- Do not use a branch-only match when several runs can exist for the same branch.

Use `--exit-code` for automation:

```text
0 = passed
8 = pending
1 = failed
2 = ambiguous
3 = no workflow
```

## 2. Diagnose Before You Change State

Start with the compound diagnosis:

```bash
sem-ai diagnose
sem-ai diagnose <workflow-id>
sem-ai diagnose --project <project> --branch <branch>
```

Use the detailed commands only when you need more evidence:

```bash
sem-ai workflow show <workflow-id>
sem-ai pipeline show <pipeline-id>
sem-ai job show <job-id>
sem-ai job log <job-id>
sem-ai test summary --pipeline <pipeline-id>
sem-ai test report --pipeline <pipeline-id>
```

Classify the failure before you select a recovery action:

```bash
# Test failure or missing test detail.
sem-ai test summary --pipeline <pipeline-id>
sem-ai test report --pipeline <pipeline-id>

# Possible intermittent test failure.
sem-ai test flaky --project <project> --branch <branch> --count 10

# Stuck run, agent problem, or server-side problem.
sem-ai troubleshoot workflow <workflow-id>
sem-ai troubleshoot pipeline <pipeline-id>
sem-ai troubleshoot job <job-id>

# Slow pipeline or blocked dependency path.
sem-ai pipeline topology <pipeline-id>
sem-ai critical-path <pipeline-id>
sem-ai blast-radius <pipeline-id>
```

Separate these facts in the result:

- The code and commit that Semaphore ran.
- The failed workflow, pipeline, block, job, and command.
- The direct log or test evidence.
- Whether the cause is confirmed or inferred.
- Whether the failure is reproducible.

## 3. Inspect Repository CI Rules

CI behavior comes from repository files. Inspect the applicable files before you change code or CI configuration:

- `<app-repo>/.semaphore/semaphore.yml`
- `<app-repo>/.semaphore/*.yml`
- `<app-repo>/.semaphore/*.sh`
- `<app-repo>/scripts/*ci*`

For `simplepractice`, treat `change_in` and branch-specific rules in CI configuration as the source of truth.

If you change Semaphore YAML, validate it before you push or rerun:

```bash
sem-ai yaml validate --file .semaphore/semaphore.yml
```

## 4. Recover and Verify

Use a retry only after you identify the cause. Do not retry a deterministic code failure before you fix it, unless the user explicitly asks for a retry.

```bash
# Preferred partial retry. It returns a new pipeline ID.
sem-ai rerun-failed <pipeline-id>

# Full workflow rerun when all pipelines must run again.
sem-ai workflow rerun <workflow-id>

# Lower-level form of the partial retry.
sem-ai pipeline rebuild <pipeline-id>
```

Capture every returned workflow or pipeline ID. Do not assume that the old ID is the new run.

```bash
sem-ai watch <workflow-id>
sem-ai status
sem-ai pipeline show <new-pipeline-id>
sem-ai test summary --pipeline <new-pipeline-id>
```

Do not report success only because Semaphore accepted a retry. Report success only after the new run reaches a passed terminal state.

## Stop Commands

Stop commands are not normal recovery actions. Use them only when the user asks you to stop a run, or when the requested recovery requires cancellation.

```bash
sem-ai job stop <job-id>
sem-ai pipeline stop <pipeline-id>
sem-ai workflow stop <workflow-id>
```

Before you stop a run, inspect its current state and verify the exact ID. Read the state again after the stop request.

## Deployment Boundary

This skill can diagnose a failed deployment pipeline. It does not select a staging namespace or trigger a promotion. Use `spx-staging-deploy` for the SimplePractice `revNN` or `qaNN` promotion workflow.

## Old `sem` Fallback

Use `sem` only when the needed workflow is not available in `sem-ai`.

```bash
# Running jobs only.
sem attach <job-id>

# Finished jobs only. Then source the reproduced command environment.
sem debug <job-id>
source ~/commands.sh
```

Do not use `sem get` or `sem logs` by default. Use `sem-ai workflow show`, `sem-ai pipeline show`, and `sem-ai job log` for inspection.

## Guardrails

- Read before you mutate.
- A status, diagnosis, or review request is read-only. Do not stop, rerun, rebuild, push, or edit unless the user also asks for that action.
- Inspect with `sem-ai status`, `sem-ai diagnose`, `sem-ai workflow show`, `sem-ai pipeline show`, or `sem-ai job log` before stop, rerun, or rebuild.
- Verify the project, commit, workflow ID, pipeline ID, and job ID before a mutation.
- Capture new IDs from mutation output and verify the new run.
- `sem-ai` uses JSON by default.
- Use `--format table` when a person must scan output.
- Use JSON for scripts.
- If command shape is unclear, run `sem-ai <command> --help` or `sem-ai discover`.

Reference: `https://docs.semaphore.io/reference/sem-ai-cli`
