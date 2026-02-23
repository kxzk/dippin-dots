# Semaphore CLI Command Map

Use this file as a fast lookup for command forms and aliases.

## Global Shape

```bash
sem <command> <resource-type> <resource-name-or-id> [flags]
```

Global flags:

- `-h`, `--help`: show help
- `-v`, `--verbose`: include verbose API-level details

## Organization and Context

- Connect:
  - `sem connect <org>.semaphoreci.com <API_TOKEN>`
- List contexts:
  - `sem context`
- Switch active context:
  - `sem context <organization>`

## Resource CRUD

- Create:
  - `sem create -f <resource.yaml>`
  - `sem create secret <secret-name>`
  - `sem create dashboard <dashboard-name>`
- Read:
  - `sem get <resource-type>`
  - `sem get <resource-type> <name-or-id>`
- Edit:
  - `sem edit <resource-type> <resource-name>`
- Update:
  - `sem apply -f <resource.yaml>`
- Delete:
  - `sem delete <resource-type> <resource-name>`

## Execution and Debugging

- List jobs:
  - `sem get jobs`
  - `sem get jobs --all`
- Show logs:
  - `sem logs <job-id>`
- Attach to running job:
  - `sem attach <job-id>`
- Debug finished job:
  - `sem debug <job-id> --duration <duration>`
- Forward a remote port:
  - `sem port-forward <job-id> <local-port> <remote-port>`
- Stop execution:
  - `sem stop job <job-id>`
  - `sem stop pipeline <pipeline-id>`
- Rebuild:
  - `sem rebuild pipeline <pipeline-id>`
  - `sem rebuild workflow <workflow-id>`

## Troubleshooting

- `sem troubleshoot workflow <workflow-id>`
- `sem troubleshoot pipeline <pipeline-id>`
- `sem troubleshoot job <job-id>`

## Resource Aliases

| Resource | Aliases |
| --- | --- |
| `project` | `projects`, `prj` |
| `dashboard` | `dashboards`, `dash` |
| `secret` | `secrets` |
| `job` | `jobs` |
| `notification` | `notifications`, `notifs`, `notif` |
| `pipeline` | `pipelines`, `ppl` |
| `workflow` | `workflows`, `wf` |
| `deployment-target` | `deployment-targets`, `dt`, `dts`, `deployments`, `deployment` |

## Known Footguns

- `sem edit secret` overwrites secret content; partial edits are not supported.
- `sem attach` and `sem port-forward` only work for running jobs.
- `sem debug` and `sem attach` behavior differs on self-hosted agents.
- `sem rebuild pipeline` and `sem rebuild workflow` do different things; choose intentionally.
