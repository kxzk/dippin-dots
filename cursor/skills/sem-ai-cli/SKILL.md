---
name: sem-ai-cli
description: Reference the Semaphore `sem-ai` CLI commands, command groups, output formats, safety defaults, and replacements for old `sem` commands.
---

# sem-ai CLI

Use this skill when you need the exact `sem-ai` command surface before you change Semaphore state.

This is a reference skill. It is not the incident workflow. For active CI triage, use it with `semaphore-debugging`.

## Core Model

`sem-ai` is the Semaphore CLI for agents. It uses structured output by default. It supports JSON, table, and YAML output. It uses the same `~/.sem.yaml` context file as the old `sem` CLI.

## Setup

```bash
sem-ai connect simplepractice.semaphoreci.com "$SEMAPHORE_API_TOKEN"
sem-ai context show
sem-ai version --check
```

Use `sem-ai discover` when you need a machine-readable command map.

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

## Output

```bash
sem-ai pipeline show <pipeline-id> --format json
sem-ai pipeline show <pipeline-id> --format table
sem-ai pipeline show <pipeline-id> --format yaml
sem-ai --verbose pipeline show <pipeline-id>
```

Use JSON for automation by default. Use table output only when a person must scan the result.

## Replace Old `sem`

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

Keep old `sem` for interactive shell workflows that `sem-ai` does not replace yet:

```bash
sem attach <job-id>
sem debug <job-id>
```

## Safety

- Inspect first. Mutate second.
- Promotion commands require `--confirm`.
- Verify `--target`, `--param`, and the pipeline ID before execution.
- Use `sem-ai <command> --help` instead of guessing flags.
- Use `sem-ai yaml validate` before you push pipeline config changes.

Reference: `https://docs.semaphore.io/reference/sem-ai-cli`
