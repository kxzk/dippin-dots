---
name: staging-server-promote
description: Find an unreserved staging namespace and promote a Semaphore pipeline into it. Use this skill when the user asks to pick a free `revNN` or `qaNN` server, to trigger `Deploy to EKS staging`, or to validate that the promotion and the deploy are complete.
---

# Staging Server Promote

## Purpose

Check the active `.reserved` labels in Linear to pick a free namespace. Then promote a Semaphore pipeline to that namespace. Use the correct promotion name and parameters.

## Required Inputs

- `LINEAR_API_KEY` to read the reservations from the Linear GraphQL API.
- `SEMAPHORE_API_TOKEN` to trigger the promotions.
- A CI pipeline id to promote. For example, get the id from `sem-ai workflow show <workflow-id>`.

## Workflow

1. Find a free namespace:
   - Run `scripts/find_free_namespace.py`.
   - The default scan is `rev01..rev99`. The script infers the active reservations from the issue labels that end with `.reserved`.
2. Promote the selected pipeline:
   - Run `scripts/promote_staging.py` with the pipeline id and the namespace.
3. Validate the result of the deploy:
   - Use `sem-ai workflow show <workflow-id>` to get the id of the deploy pipeline.
   - Use `sem-ai pipeline show <deploy-pipeline-id>` and `sem-ai job log <job-id>`. Confirm the final `passed` state and the Helm success markers.

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

- Treat every active `.reserved` label as unavailable. Use such a namespace only when the user gives an explicit override.
- Do not use the deprecated ReleaseBot or Sheet reservation sources.
- If no namespace in the range is free, stop and ask the user for an explicit override. Do not guess.
