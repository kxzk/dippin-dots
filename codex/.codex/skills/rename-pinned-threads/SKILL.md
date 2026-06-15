---
name: rename-pinned-threads
description: Rename Codex pinned threads to short intent or feature titles. Use when the user asks to rename, clean up, summarize, or organize pinned Codex threads by purpose.
---

# Rename Pinned Threads

Use this skill to rename Codex pinned threads to concise descriptions of the actual intent, feature, or workstream behind each thread.

## Core Rule

Pinned status is stored in Codex app state, not in `list_threads` results. Do not infer pinned threads from title search.

Bad shortcut:

```text
list_threads query="is:pinned"
```

That is text search, not a pinned filter.

## Workflow

### 1. Load thread tools

If the thread tools are not already available, search for them:

```text
list_threads read_thread set_thread_title pinned thread title
```

Use the Codex thread tools for reads and writes:

- `read_thread`
- `set_thread_title`

Use shell only for local state inspection.

### 2. Resolve pinned thread IDs

Read pinned IDs from Codex global state:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
jq -r '."pinned-thread-ids"[]' "$CODEX_HOME/.codex-global-state.json"
```

If the file is missing or malformed, try the backup:

```bash
jq -r '."pinned-thread-ids"[]' "$CODEX_HOME/.codex-global-state.json.bak"
```

If both fail, stop and say pinned state could not be discovered. Do not guess from recent threads.

### 3. Gather context

For each pinned ID:

- Use `read_thread` with recent turns first.
- Read older pages only when the thread's intent is unclear.
- Prefer the durable workstream over the latest tactical action.
- Use `cwd`, preview, first user request, plans, PR/issue identifiers, and final summaries as evidence.

Optional shell read for quick metadata:

```bash
sqlite3 -header -column "$CODEX_HOME/state_5.sqlite" \
  "SELECT id, title, cwd, substr(replace(preview, char(10), ' '), 1, 220) AS preview
   FROM threads
   WHERE id IN ('<id1>', '<id2>');"
```

This is read-only context. Never update Codex SQLite or global state directly.

### 4. Choose titles

Title rules:

- 2-5 words when possible.
- Name the intent or feature, not the command that created the thread.
- Keep repo/product prefixes when they disambiguate similar work.
- Preserve native code/package casing, for example `ai-sdk`, `sp-video`, `add_messages`.
- Avoid `Ship`, `Review`, `Fix`, `PR`, or issue IDs unless they are the clearest durable label.
- Avoid over-specific validation details unless validation is the actual workstream.

Good examples:

- `Amadeus PDF Input`
- `Amadeus HTTP Metrics`
- `Trace Scoring Bridge`
- `sp-video CallChat Messages`
- `ai-sdk add_messages`
- `GFE Download Flake`
- `Langfuse Multi-Client`

If two threads would receive the same title, add the repo or feature qualifier.

### 5. Rename through the app API

If the user asked to rename the threads, apply the titles with `set_thread_title`.

Do not ask for confirmation unless a title would be speculative or the user explicitly requested a dry run.

If the user asked for a proposal, return the mapping without mutating anything.

### 6. Verify

After renaming, verify each changed thread with `read_thread` using `turnLimit: 1`.

Final response should include only the rename result, usually a compact list of new titles. Mention any threads skipped and why.

## Safety

- Never mutate `.codex-global-state.json`, `state_*.sqlite`, or `session_index.jsonl` for this task.
- Never rely on `list_threads` search syntax as proof of pinned status.
- Do not rename archived or unpinned threads unless the user explicitly asks.
- Do not expose secrets from previews, logs, or environment state while summarizing intent.
