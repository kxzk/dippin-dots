---
name: spx-agent
description: >-
  Control Cursor Cloud Agents through the spx CLI without opening Cursor. Use
  when the user asks to start, list, inspect, watch, continue, or cancel a
  Cursor Cloud Agent run.
---

# SPX Cursor Cloud Agents

## Job

Use `spx agent` as the JSON-first control plane for Cursor Cloud Agents.
Do not open Cursor to inspect or control a run.

Read the command contract before an unfamiliar operation:

```sh
spx describe agent.run
spx describe agent.watch
```

Parse the final `spx.response.v1` document from stdout.
Parse `spx.progress.v1` JSON Lines (JSONL) from stderr when `--progress` is set.

## Authentication

SPX requires `kade.killary@simplepractice.com` by default. Pass
`--expected-account` or set `SPX_CURSOR_ACCOUNT_EMAIL` to require a different
company account.

SPX reads `SPX_CURSOR_API_KEY` when set. On macOS, SPX otherwise reads the
`com.cursor.spx-cloud-agent` Keychain service. SPX deliberately ignores
`CURSOR_API_KEY` because that variable can belong to another Cursor account.

## Start a Run

```sh
spx agent run "Implement the requested change"
spx agent run --mode plan --no-create-pr "Inspect the repository and report the cause"
printf '%s' "$TASK" | spx agent run --prompt-stdin
```

`agent run` uses the `Builder` environment by default. The default model is
`gpt-5.6-luna` with `context=272k`, `reasoning=high`, and `fast=true`.
SPX requests a pull request by default. Use `--no-create-pr` when the user wants
investigation, planning, or another run that must not create a pull request.

Use `--wait` when only the final result is required. Use `agent watch` when
progress or resumable monitoring is required.

## List and Inspect

```sh
spx agent list --limit 20
spx agent list --limit 20 --cursor <next-cursor>
spx agent list --active-only
spx agent list --pr-url <pull-request-url>
spx agent get bc-<agent-id>
```

`agent list` returns one bounded page. Use `next_cursor` from the response for
the next page. `agent get` returns current metadata and `latest_run_id`.

## Watch a Run

```sh
spx --progress agent watch bc-<agent-id> run-<run-id>
spx --progress agent watch bc-<agent-id>
spx --progress agent watch bc-<agent-id> run-<run-id> \
  --last-event-id <event-id>
```

Omit the run ID only when the latest run is the intended target. Pass an exact
run ID when run identity matters.

`agent watch` follows Server-Sent Events (SSE). It emits status, assistant,
tool-call metadata, and result events. It does not emit model thinking, tool
arguments, or tool results. It reads the authoritative run after the stream
closes or expires. Use `last_event_id` from the result to resume a disconnected
stream.

## Continue a Run

```sh
spx agent continue bc-<agent-id> "Apply the review feedback"
printf '%s' "$FOLLOW_UP" | \
  spx agent continue bc-<agent-id> --prompt-stdin --wait
```

`agent continue` creates a new run in the existing agent context. It inherits
the current mode unless `--mode` is present. The command is an external,
non-idempotent mutation. Do not retry it after an ambiguous response until
`agent get` confirms whether Cursor created the run.

## Cancel a Run

```sh
spx --progress agent cancel bc-<agent-id> run-<run-id>
```

Cancellation requires exact agent and run IDs. SPX requests cancellation,
reads the run again, and waits until Cursor reports a terminal state.

## Guardrails

- Treat `agent run`, `agent continue`, and `agent cancel` as external mutations.
- Treat `agent list`, `agent get`, and `agent watch` as read-only operations.
- Keep automatic pull request creation unless the user requests read-only,
  investigation-only, or no-pull-request work.
- Use `--mode plan --no-create-pr` for a non-editing validation run.
- Do not infer a run ID when the user identifies an exact run.
- Do not expose API keys, model thinking, tool arguments, or tool results.
- Report agent ID, run ID, status, and pull request URL when present.

## Related

- General docker-dev control plane: `spx`
