---
name: semaphore-cli
description: Use this skill for Semaphore CI operations through the `sem` CLI. Trigger it when a user needs to authenticate or switch organizations, list or edit resources (projects, pipelines, workflows, jobs, secrets, deployment targets, notifications), debug or attach to jobs, stream logs, port-forward to running jobs, rebuild or stop execution, or gather `sem troubleshoot` diagnostics.
---

# Semaphore CLI

Use this skill to execute Semaphore operational workflows from a terminal-first interface.

## When To Use

- Use when the task is operational, not code-authoring:
  - inspect runtime state
  - mutate Semaphore resources
  - debug failing jobs/pipelines/workflows
- Use when the request mentions:
  - `sem` commands
  - pipeline/workflow/job IDs
  - secrets, deployment targets, notifications
  - attach/debug/log/stop/rebuild/troubleshoot actions
- Do not use this skill for:
  - writing `.semaphore/*.yml` from scratch without CLI execution needs
  - local app build/test work unrelated to Semaphore state

## How To Use

1. Set active org and verify context:

```bash
sem connect <org>.semaphoreci.com <API_TOKEN>
sem context
sem version
```

2. Discover exact command signature before mutation:

```bash
sem help
sem help <command>
```

3. Identify resource IDs before acting:
- `sem get jobs --all`
- `sem get pipelines -p <project-name>`
- `sem get workflows -p <project-name>`

4. Execute targeted operation (read first, then mutate):
- read: `sem get ...`, `sem logs ...`, `sem troubleshoot ...`
- mutate: `sem apply ...`, `sem edit ...`, `sem delete ...`, `sem stop ...`, `sem rebuild ...`

## Command Selection

- Inspect resources:
  - `sem get <resource-type>`
  - `sem get <resource-type> <resource-name-or-id>`
- Create/update config-backed resources:
  - `sem create -f <resource.yaml>`
  - `sem apply -f <resource.yaml>`
  - `sem edit <resource-type> <resource-name>`
  - `sem delete <resource-type> <resource-name>`
- Job and execution control:
  - `sem get jobs --all`
  - `sem logs <job-id>`
  - `sem attach <job-id>`
  - `sem debug <job-id> --duration <duration>`
  - `sem stop job <job-id>`
  - `sem stop pipeline <pipeline-id>`
  - `sem port-forward <job-id> <local-port> <remote-port>`
- Pipeline/workflow replay:
  - `sem rebuild pipeline <pipeline-id>`
  - `sem rebuild workflow <workflow-id>`
- Diagnostics:
  - `sem troubleshoot <resource-type> <resource-id>`
  - add `-v` for verbose API interactions

## Guardrails

- Resolve ambiguous nouns first:
  - `pipeline` and `workflow` rebuild behavior is different.
  - `sem rebuild pipeline` reruns failed jobs only.
  - `sem rebuild workflow` reruns all jobs.
- Fetch IDs before mutate/stop:
  - Use `sem get` output to source job/pipeline/workflow IDs.
- Treat secret edits as full replacement:
  - `sem edit secret` does not expose prior secret values and can overwrite content.
- Respect execution state requirements:
  - `sem attach` and `sem port-forward` require running jobs.
  - `sem debug` targets finished jobs and supports `--duration`.
- Adjust editor behavior only when needed:
  - `sem config set editor <editor>`
  - or set `$EDITOR`.

## References

- Use `references/command-map.md` for aliases and high-frequency command patterns.
- Official docs: `https://docs.semaphore.io/reference/semaphore-cli`
