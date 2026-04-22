---
name: staging-server-promote
description: Find an unreserved staging namespace and promote a Semaphore pipeline into it. Use when a user asks to pick a free `revNN`/`qaNN` server, trigger `Deploy to EKS staging`, or validate that promotion/deploy completed.
---

# Staging Server Promote

## Purpose

Pick a free namespace by checking active `.reserved` labels in Linear, then promote a Semaphore pipeline to that namespace with the right promotion name and parameters.

## Required Inputs

- `LINEAR_API_KEY` to read reservations from Linear GraphQL.
- `SEMAPHORE_API_TOKEN` to trigger promotions.
- A CI pipeline id to promote (for example from `sem get workflow <workflow-id>`).

## Workflow

1. Resolve a free namespace:
   - Run `scripts/find_free_namespace.py`.
   - Default scan is `rev01..rev99` and active reservations are inferred from issue labels ending in `.reserved`.
2. Promote the selected pipeline:
   - Run `scripts/promote_staging.py` with pipeline id + namespace.
3. Validate deployment result:
   - Use `sem get workflow <workflow-id>` to get the deploy pipeline id.
   - Use `sem get pipeline <deploy-pipeline-id>` and `sem logs <job-id>` to confirm final `passed` and Helm success markers.

## Commands

```bash
# Find first free rev namespace.
uv run --script scripts/find_free_namespace.py --prefix rev --start 1 --end 99

# Pick namespace and promote.
namespace="$(uv run --script scripts/find_free_namespace.py --prefix rev --start 1 --end 99 --format raw)"
uv run --script scripts/promote_staging.py \
  --pipeline-id <ci-pipeline-id> \
  --namespace "$namespace"
```

## Guardrails

- Treat all active `.reserved` labels as unavailable unless the user explicitly overrides.
- Do not use deprecated ReleaseBot/Sheet reservation sources.
- If no namespace is free in the range, stop and ask for an explicit override instead of guessing.
