---
name: pup
description: Use this skill only for Datadog usage and debugging via `datadog-labs/pup` CLI. Use when the user asks to query/inspect Datadog state, validate outputs, or troubleshoot `pup` command behavior. Do not use for repo maintenance, contribution, or build/development tasks.
---

# Pup CLI

Use this skill for Datadog operations only.

## Core usage patterns

- Run `pup` commands to inspect Datadog state.
- Troubleshoot failed `pup` operations and authorization issues.
- Check command output formatting for downstream parsing and diagnostics.
- Validate what commands are available before running destructive operations.

## Command execution

- Typical checks:
  - `pup auth status`
  - `pup monitors list --tags="team:api-platform"`
  - `pup logs search --query="status:error" --from="1h"`
  - `pup metrics query --query="avg:system.cpu.user{*}" --from="1h"`
  - `pup incidents list`
- Use explicit output formats for machine use:
  - `pup <cmd> --output json`
  - `pup <cmd> --output yaml`
- Confirm command signatures on demand:
  - `pup --help`
  - `pup help <domain>`

## Auth and access checks

- Preferred: OAuth2 via `pup auth login` and `pup auth status`.
- Fallback: `DD_ACCESS_TOKEN`, or `DD_API_KEY` + `DD_APP_KEY`.
- If `pup` returns auth errors:
  - validate credentials with `pup auth status`
  - re-run login flow
  - check `DD_SITE` for region mismatch

## Debugging flow

- Unknown command/flag:
  - use `pup --help`
  - use `pup help <domain>`
- 401/403 or auth failures:
  - verify env values and login state
  - confirm site and token/client mode
- 429 / timeout:
  - narrow time windows and queries
  - reduce request volume and retry
- Always cross-check expected fields with actual command JSON output before acting.

## Useful reference links

- README: https://github.com/datadog-labs/pup/blob/main/README.md
- Commands: https://github.com/datadog-labs/pup/blob/main/docs/COMMANDS.md
- Troubleshooting: https://github.com/datadog-labs/pup/blob/main/docs/TROUBLESHOOTING.md
