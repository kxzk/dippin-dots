---
name: sem-ai-cli
description: References Semaphore's sem-ai CLI command set, output formats, safety defaults, and legacy sem replacement patterns. Use when exact sem-ai commands or flags are needed before inspecting or mutating Semaphore state.
---

# sem-ai CLI

Reference for Semaphore's agent-oriented `sem-ai` CLI. For active CI triage,
use `semaphore-debugging`; this skill is the command map.

## Quick Start

```bash
sem-ai connect simplepractice.semaphoreci.com "$SEMAPHORE_API_TOKEN"
sem-ai context show
sem-ai discover
```

`sem-ai` defaults to JSON output and supports `--format table` and
`--format yaml`. It shares `~/.sem.yaml` with the legacy `sem` CLI.

## Command Families

```bash
# Context and auth
sem-ai connect <host> <token>
sem-ai context list
sem-ai context show
sem-ai context switch <name>

# Project and CI state
sem-ai project list
sem-ai status --project <project> --branch <branch>
sem-ai health --project <project>
sem-ai workflow list --project <project>
sem-ai workflow show <workflow-id>
sem-ai pipeline list --project <project>
sem-ai pipeline show <pipeline-id>
sem-ai job list
sem-ai job show <job-id>

# Logs and failure analysis
sem-ai diagnose <workflow-id>
sem-ai troubleshoot workflow <workflow-id>
sem-ai job log <job-id>
sem-ai test summary --pipeline <pipeline-id>
sem-ai test report --pipeline <pipeline-id>
sem-ai blast-radius <pipeline-id>
sem-ai critical-path <pipeline-id>
sem-ai pipeline topology <pipeline-id>

# Recovery and mutation
sem-ai job stop <job-id>
sem-ai pipeline stop <pipeline-id>
sem-ai pipeline rebuild <pipeline-id>
sem-ai workflow rerun <workflow-id>
sem-ai rerun-failed <pipeline-id>
sem-ai watch <workflow-id>

# Deploys and operations
sem-ai pipeline promote <pipeline-id> --target <promotion-name> --confirm
sem-ai promote-and-wait <pipeline-id> --target <promotion-name> --confirm
sem-ai deploy targets --project <project>
sem-ai secret list
sem-ai notification list
sem-ai task list --project <project>
sem-ai artifact list --scope jobs --id <job-id>
sem-ai artifact get --scope jobs --id <job-id> --path <path>
sem-ai testbox warmup --project <project>
sem-ai testbox run --id <testbox-id> "<command>"
sem-ai testbox ssh --id <testbox-id>
sem-ai testbox stop --id <testbox-id>
sem-ai yaml validate --file .semaphore/semaphore.yml
```

## Legacy sem Replacement

```text
sem get workflows -p <project>     -> sem-ai workflow list --project <project>
sem get workflow <workflow-id>     -> sem-ai workflow show <workflow-id>
sem get pipelines -p <project>     -> sem-ai pipeline list --project <project>
sem get pipeline <pipeline-id>     -> sem-ai pipeline show <pipeline-id>
sem get jobs                       -> sem-ai job list
sem logs <job-id>                  -> sem-ai job log <job-id>
sem stop job <job-id>              -> sem-ai job stop <job-id>
sem stop pipeline <pipeline-id>    -> sem-ai pipeline stop <pipeline-id>
sem rebuild pipeline <pipeline-id> -> sem-ai pipeline rebuild <pipeline-id>
sem rebuild workflow <workflow-id> -> sem-ai workflow rerun <workflow-id>
```

Keep legacy `sem` only for interactive shells that `sem-ai` does not replace:

```bash
sem attach <job-id>
sem debug <job-id>
```

## Safety

- Inspect before mutating.
- Promotion commands require `--confirm`; verify target, parameters, and
  pipeline id first.
- Prefer `sem-ai <command> --help` or `sem-ai discover` over guessing flags.
- Use `sem-ai yaml validate` before pushing pipeline config changes.

Reference: `https://docs.semaphore.io/reference/sem-ai-cli`
