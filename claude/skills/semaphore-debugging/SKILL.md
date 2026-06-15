---
name: semaphore-debugging
description: Debugs and triages Semaphore CI pipelines and jobs with sem-ai first, falling back to legacy sem only for interactive attach/debug shells. Use when CI is failing, flaky, stuck, queued, or needs logs, reruns, stops, or deployment-state inspection.
---

# Semaphore Debugging

Workflow for Semaphore CI incidents. Prefer `sem-ai` for structured inspection
and mutation. Use legacy `sem` only when `sem-ai` has no equivalent, mainly
interactive job shells.

## Quick Start

```bash
sem-ai connect simplepractice.semaphoreci.com "$SEMAPHORE_API_TOKEN"
sem-ai context show
sem-ai diagnose <workflow-id>
```

If the workflow id is unknown:

```bash
sem-ai status --project simplepractice --branch <branch>
sem-ai workflow list --project simplepractice --branch <branch>
```

## When to Use

- Semaphore CI is failing, flaky, stuck, queued, or slow.
- The task needs pipeline, workflow, job, log, or test-result inspection.
- The task may require safe recovery: stop, rerun, rebuild, or watch.
- Deployment state needs to be verified from Semaphore before runtime checks.

## Workflow

1. Inspect first:

```bash
sem-ai diagnose <workflow-id>
sem-ai workflow show <workflow-id>
sem-ai pipeline show <pipeline-id>
sem-ai job log <job-id>
sem-ai test summary --pipeline <pipeline-id>
```

2. Drill down when needed:

```bash
sem-ai pipeline topology <pipeline-id>
sem-ai test report --pipeline <pipeline-id>
sem-ai blast-radius <pipeline-id>
sem-ai critical-path <pipeline-id>
```

3. Recover only after evidence is clear:

```bash
sem-ai job stop <job-id>
sem-ai pipeline stop <pipeline-id>
sem-ai pipeline rebuild <pipeline-id>
sem-ai workflow rerun <workflow-id>
sem-ai rerun-failed <pipeline-id>
sem-ai watch <workflow-id>
```

## Legacy sem Fallback

Do not use `sem get` or `sem logs` by default. Use `sem-ai workflow show`,
`sem-ai pipeline show`, and `sem-ai job log`.

Use legacy `sem` only for interactive shells:

```bash
# Running jobs only.
sem attach <job-id>

# Finished jobs only; then source the reproduced command environment.
sem debug <job-id>
source ~/commands.sh
```

## Guardrails

- `sem-ai` defaults to JSON. Use `--format table` only for human scanning.
- Promotion commands require `--confirm`; verify target and parameters first.
- Use `sem-ai <command> --help` or `sem-ai discover` before guessing flags.
- Check repo CI definitions before blaming Semaphore:
  - `.semaphore/ci.yml`
  - `.semaphore/*.sh`
  - `scripts/*ci*`

Reference: `https://docs.semaphore.io/reference/sem-ai-cli`
