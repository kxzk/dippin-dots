---
name: spx
description: >-
  Uses the spx JSON-first CLI as the agent control plane for SimplePractice
  docker-dev. Covers repository sync, application lifecycle, container tests,
  commits, ports, secrets, worktrees, database snapshots, Cursor Cloud agents,
  and staging access.
---

# spx agent workflow

Use `spx` for bounded docker-dev operations.
Use one bounded operation for each invocation.
Parse JSON from stdout.
Parse JSON Lines (JSONL) progress or stream records from stderr.

## Read the contract

```sh
spx version
spx describe
spx describe app.ensure
```

Use `spx describe <operation>` before an unfamiliar operation.

Set `SPX_ROOT` when root discovery fails.
Set `SPX_CONTAINER_HOST` when Docker publishes ports on another host.

## Choose an operation

| Need | Operation |
| --- | --- |
| Read the command contract | `spx describe [operation]` |
| Control Cursor Cloud agents | `spx agent ...` |
| Check the host | `spx env check` |
| Synchronize repositories | `spx repo sync` |
| Make an application ready | `spx app ready --app <app>` |
| Run a container command | `spx app exec` |
| Restart an application | `spx app restart` |
| Stop applications | `spx app stop` |
| Commit staged changes | `spx repo commit` |
| Read ports or logs | `spx app port` or `spx app logs` |
| Manage secrets | `spx secret ...` |
| Manage worktrees | `spx worktree ...` |
| Create a database snapshot | `spx db snapshot` |
| Deploy or access staging | `spx staging ...` |

Use the `spx-agent` skill for the Cursor Cloud Agent lifecycle. Use the
`spx-staging-connect` skill for staging access and runtime probes. Use the
`spx-staging-deploy` skill for guarded staging deployment.

## Synchronize repositories

```sh
spx repo sync --dry-run
spx repo sync
spx repo sync --app <app-a>,<app-b>
```

`repo sync` pulls existing repositories and clones missing repositories.
Use `repo run` for a host command across application repositories:

```sh
spx repo run --app <app-a>,<app-b> -- git status --short
```

## Delegate to Cursor Cloud

```sh
spx agent run "Investigate the issue and report the cause"
spx agent list --limit 20
spx agent get bc-<agent-id>
spx --progress agent watch bc-<agent-id> run-<run-id>
```

Use the `spx-agent` skill for authentication, model defaults, pagination,
stream resumption, follow-up runs, cancellation, and progress privacy rules.

## Make an application ready

```sh
spx app ready --app <app>
spx app get --app <app>
```

`app ready` checks the host, checks and synchronizes secrets, starts the
application, waits for container, TCP, and HTTP readiness, and returns one
final readiness verdict.
It uses the command contract's 900-second timeout when `--timeout-seconds` is
not present. Add `--no-build` only when the required image already exists.
Follow error remediation in the listed order.
Do not invent remediation.
The sync follows secret references transitively. A test sync also caches each
visited scope's development layer.
Without `--app`, `app ensure` uses `APPS` from `.env`. It starts missing
services and removes deselected or owned orphan containers. Use an explicit
comma-separated `--app` value to replace that selection for one operation.
Use bounded logs when startup output is required:

```sh
spx app logs --app <app> --follow --timeout-seconds 60
```

`app check` reports these distinct states and observations:

| Field | Meaning |
| --- | --- |
| `bootable` | The host, credentials, and secrets permit startup. |
| `running` | The container runs and does not restart. |
| `tcp` | The preferred host port accepts a connection. |
| `http` | The readiness path returns a 2xx response. |
| `ready` | Every required host, secret, container, TCP, and HTTP check passes. |

Application configuration can set `x-spx-readiness-path`. The default is
`/health`.

## Run tests and application commands

```sh
spx app exec --app <app> --stream -- rspec <spec-path>
spx app exec --app <app> --stream -- rspec <spec-path> --fail-fast
spx app exec --app <app> --stream -- rubocop <path>
spx app exec --app <app> --stream -- rubocop -A <path>
spx app exec --app <app> --stream -- yarn <arguments>...
spx app exec --app <app> --env NAME=value --stream -- <command> <arguments>...
```

Pass the command as an argument vector after `--`.
Do not build a shell command string.
Use `--tty` only for an interactive terminal.
Do not combine `--tty` with `--stream`.

## Restart, stop, and inspect applications

```sh
spx app restart --app <app> --dry-run
spx app restart --app <app>
spx app restart --app <app> --rebuild
spx app restart --app <app> --pull
spx app restart --app <app> --backend --rebuild
spx app wait --app <app> --timeout-seconds 120
spx app check --app <app>
spx app port --app <app> --output text
spx app logs --app <app> --tail 100 --stream
spx app logs --app <app> --follow --timeout-seconds 60
```

Use `--frontend` instead of `--backend` for the frontend counterpart.
`--follow` implies `--stream`.
A follow timeout returns `timed_out: true`.

Preview and stop the complete shared stack from docker-dev:

```sh
spx app stop --all --prune --dry-run
spx app stop --all --prune
```

The shared stack uses a root-specific Compose project. Its containers, build
outputs, volumes, and networks have spx ownership labels. `app stop --all`
uses the private spx state and the live labels. It does not need
`docker-compose.yml`. It retains named volumes. `--prune` affects only dangling
images with matching shared-stack labels.

Do not mix the legacy `sp` project with the spx project for one root. spx
refuses this state. It also refuses a resource with the expected name and the
wrong ownership labels. Verify the resource owner before you remove it.

## Commit staged changes

```sh
spx repo commit --dry-run
spx repo commit
spx repo commit --push
```

`repo commit` uses the Linear branch convention.
It commits staged changes only.
Use `--message <message>` to replace the branch-derived description.

## Manage secrets

```sh
spx secret get --app <app> <key>
spx secret check --app <app>
spx secret sync --app <app>
printf '%s' "$VALUE" | spx secret put --app <app> <key> --value-stdin
spx secret delete --app <app> <key> --dry-run
spx secret edit --app <app>
spx secret rotate --app <app> <key>
spx secret audit --app <app>
spx secret audit --app <app> --profile production=<aws-profile>
```

`secret get` omits plaintext unless `--reveal` is explicit.
Use `--expected-version` when a prior read controls a write.
Never pass a secret value in command arguments.
`secret audit` returns repository, deploy, duplicate, and leak metadata only.
It does not return plaintext, masked values, hashes, or value lengths.

## Manage worktrees

Use `shared`, `database`, or `full` isolation.
`database` provides private MySQL.
`full` provides private MySQL and Redis.

```sh
spx worktree list --include-unmanaged --repo <repo-path>
spx worktree create feature/name --app <app> --isolation shared --start --no-build
spx worktree create --pr 123 --name review-123 --app <app> --start --no-build
spx worktree migrate --path <worktree-path> --app <app>
spx worktree ensure --path <worktree-path> --isolation database --no-build
spx worktree create feature/name --app client-portal --backend simplepractice --start
spx worktree ensure --path <client-portal-worktree> --backend <simplepractice-worktree-id>
spx worktree get --path <worktree-path>
spx worktree stop --path <worktree-path>
```

Run `spx db snapshot` before private database use.
Managed instances do not change `APPS`, generated docker-dev YAML, or application `.env` files.
Client Portal supports shared isolation only. Its `--backend` selection is
resolved to a concrete SimplePractice service and stored in the instance.

For an application with `x-non-root: true`, spx applies the same typed runtime
policy to shared Compose, worktree Compose, and `app exec`. Shared secret-cache
writes run as `app`. Cursor AWS forwarding is conditional on both the daemon
directory and an existing `.aws` mount.

On Linux, shared Compose keeps `.local` hostnames, rewrites the SSH mount to
the host `SSH_AUTH_SOCK`, and maps matching 40xx Ember ports to container port
80. On macOS, shared Compose removes the `.local` suffix and uses the VM SSH
socket.

Removal preserves data and the checkout by default.
Preview explicit deletion:

```sh
spx worktree remove --id <id> --delete-data --delete-checkout --dry-run
spx worktree remove --id <id> --delete-data --delete-checkout
```

## Use staging

```sh
spx staging connect
spx staging connect --namespace rev01
spx staging deploy --repo <simplepractice-checkout> --namespace rev01
spx staging deploy --repo <simplepractice-checkout> --namespace rev01 --confirm <plan-id>
spx staging deploy --repo <simplepractice-checkout> --pr <number> --namespace rev01
spx staging logs --app <app> --namespace rev01 --follow
spx staging exec --app <app> --namespace rev01 --stream -- <command>
spx staging exec --app <app> --namespace rev01 --tty
spx staging run --app simplepractice --namespace rev01 --script script/probe.rb
spx staging run --app simplepractice --namespace rev01 --namespace qa02 --script script/probe.rb
spx staging run --app simplepractice --namespace rev01 --namespace qa02 --script script/probe.rb --confirm <plan-id>
spx staging run --app simplepractice --namespace rev01 --script script/repair.rb --mutating
spx staging db --app <app> --namespace rev01
spx staging db --app <app> --namespace rev01 --rw
```

`staging connect` reuses valid access when possible. Otherwise, it signs in to
`teleport.simplepractice.com` with Google Workspace authentication and runs
`tsh kube login staging-main`. It requires the exact `teleport-staging-main`
context and verifies permission to get pods. With `--namespace`, it also
requires a `revNN` or `qaNN` namespace, verifies that the namespace exists, and
checks access in that namespace. It does not select a namespace, call Linear,
change the context's default namespace, or mutate a Kubernetes workload.

`staging deploy` replaces the staging promotion skill. Its first invocation is
a read-only plan. It verifies the active Semaphore context, the exact source
commit, a passed source pipeline, the source commit's `.semaphore/ci.yml`, and
active Linear `.reserved` labels. It accepts only a namespace allowed by the
exact `Deploy to EKS staging` promotion. The namespace is required. SPX never
selects one from the advisory Linear snapshot. Pass the returned plan ID to
`--confirm` in a second invocation. The command recomputes the plan and rejects
any drift before it calls `sem-ai pipeline promote`.

The Linear label check is advisory. It rejects an explicit namespace with an
active reservation, but it does not atomically reserve that namespace. The
result reports `reservation_atomic: false` so callers do not mistake the check
for a lock.

The plan also lists terminal Linear issues that still have the selected
namespace's `.reserved` label. After Semaphore and Helm verification pass, the
confirmed command removes only those exact labels. It reads each issue again,
requires the issue to remain completed or canceled, and preserves every other
label. The result reports `reservation_cleanup_atomic: false` because Linear
does not combine the state check and label removal in one atomic operation.

The deploy command never uses Semaphore `--override`. It waits for the promoted
pipeline, requires a final `passed` result, and verifies the Helm success
markers in the deploy job log. The result status is `semaphore_passed`, and
`kubernetes_verified` remains `false`. This proves the Semaphore deploy
workflow. It does not prove live Kubernetes or application behavior.

Use `staging run` for a local script that must run in one or more exact staging
namespaces. A single non-mutating namespace runs without confirmation. Repeated
`--namespace` values and `--mutating` return a plan first. Pass the unchanged
plan ID to `--confirm` to execute it. The plan binds the application, exact
namespaces, container, command, mutation mode, script size, and script SHA-256.

The default command is `bin/rails runner`. Pass a command prefix after `--` to
replace it. SPX snapshots the validated local file, copies it to a unique remote
path, and pins every Kubernetes call to `teleport-staging-main`, the namespace,
one pod, and one resolved container. Non-client-portal execution uses
`aws-env exec --`. SPX removes the remote file after success, failure, timeout,
or cancellation with a separate recovery budget. The result reports the exact
pod, container, remote path, process output, and cleanup verification for each
namespace. Execution is sequential and fail-fast.

Staging access commands require the `teleport-staging-main` Kubernetes context.
Run `staging connect` when the context or Teleport session is missing. An
omitted `staging exec` command starts `bash`. SPX runs non-client-portal exec
commands through `aws-env exec`, so staging probes inherit decrypted runtime
environment values.

## Keep host tasks external

Use `make setup` for cold host bootstrap.
Use the exact `spx env check` remediation for interactive authentication.
Do not invent a fallback operation.

## Apply safety rules

- Review every destructive dry run.
- Use an exact worktree target before deletion.
- Treat local credentials as the access boundary.
- Let the first signal complete bounded recovery.
- Use a second signal only for immediate exit.

Destructive shared-stack and worktree operations verify Docker ownership
labels.
The process runner terminates child process groups after timeout or cancellation.
