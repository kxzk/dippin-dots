---
name: amadeus-promote-and-verify
description: Promote an Amadeus PR to the shared `data` staging namespace using Semaphore `Deploy to Staging`, then verify the SLSA-backed artifact flow, deployed image, and live log contract through Kubernetes.
---

# Amadeus Promote and Verify

## Purpose

Promote an Amadeus PR into the real Amadeus staging target.

This is not the generic staging namespace flow. Amadeus does not use a free
`revNN` namespace for this path. It promotes to the shared Kubernetes namespace:

`data`

using Semaphore promotion:

`Deploy to Staging`

After INF-1644, Semaphore is the orchestrator, not the direct artifact builder.
CI dispatches GitHub Actions through `ci-tools` to build SLSA-backed Docker OCI
artifacts. The staging promotion deploy job dispatches `staging-oci-artifacts.yml`
again with `target_namespace=data` to package the Helm OCI artifact, then runs
`ci-tools /app/entrypoint.sh` to deploy it.

Use these operator-facing phase names when reporting progress:

- Resolve CI pipeline: find the PR's Semaphore CI pipeline and head SHA.
- Build PR image: CI dispatches GitHub Actions to build the backend Docker OCI
  artifact for the PR SHA.
- Promote staging release: trigger `Deploy to Staging` for namespace
  `data`.
- Package staging release: the deploy job dispatches GitHub Actions with
  `target_namespace=data` to package the Helm OCI artifact.
- Deploy staging release: the deploy job runs `ci-tools /app/entrypoint.sh` to
  apply the packaged release to EKS.
- Verify staging runtime: Kubernetes rollout, endpoints, feature probe, and logs.

Raw system names are lookup handles only. Do not use them as the main mental
model unless the user needs exact Semaphore or GitHub Actions identifiers.

## Required Inputs

- PR number or CI pipeline id
- `SEMAPHORE_API_TOKEN`
- `gh`
- `sem-ai`
- `tsh`
- `kubectl`
- `uv`

## Workflow

### 1. Resolve CI Pipeline

Use GitHub to find the current PR head and Semaphore CI URL:

```bash
gh pr view <pr-number> --json headRefOid,statusCheckRollup,url
```

Extract the Semaphore CI pipeline id from the `ci/semaphoreci/push: CI` target
URL.

Confirm the pipeline passed:

```bash
sem-ai pipeline show <ci-pipeline-id>
```

If the user gave a CI pipeline id directly, still confirm that pipeline passed
before promotion.

### 2. Verify PR Image Build

For PR pipelines, confirm the CI pipeline included the PR image build path:

- block: `Build (staging)`
- job: `Staging OCI artifacts`
- dispatch: `staging-oci-artifacts.yml`
- input: `git_ref=<PR head SHA>`

If the staging artifact job is missing or failed, do not promote. A green deploy
promotion cannot prove the PR artifact was built when the pre-promotion OCI
artifact step did not run.

### 3. Promote Staging Release

Do not run `find_free_namespace.py`.

Promote the CI pipeline to `data` with the Amadeus-specific promotion name.
Run the command from this skill directory, or resolve the script path to this
skill's `scripts/promote_staging.py`:

```bash
uv run --script scripts/promote_staging.py \
  --pipeline-id <ci-pipeline-id> \
  --namespace data \
  --promotion-name "Deploy to Staging" \
  --format json
```

Capture the returned workflow id from the promotion response.

### 4. Verify Release Package And Deploy

Find the deploy pipeline:

```bash
sem-ai workflow show <workflow-id>
```

Then follow the deploy pipeline:

```bash
sem-ai pipeline show <deploy-pipeline-id>
sem-ai watch <workflow-id>
```

Confirm:

- pipeline result is `passed`
- deploy job exists
- package staging release happened: `staging-oci-artifacts.yml` was dispatched with `target_namespace=data`
- package staging release completed: the Helm OCI artifact was packaged
- deploy staging release happened: `ci-tools /app/entrypoint.sh` ran
- deploy logs include Helm success

```bash
sem-ai job log <deploy-job-id>
```

Look for:

```text
staging-oci-artifacts.yml
target_namespace=data
Helm upgrade succeeded for release data/amadeus...
```

Also capture the deployed artifact tag. New SLSA-backed deployments use a
namespace-plus-short-SHA shape, for example:

```text
backend-data.<epoch>-<shortsha>
```

### 5. Connect Kubectl To Staging

```bash
tsh login --proxy=teleport.simplepractice.com --auth=gsuite
tsh kube login staging-main
kubectl config current-context
kubectl get ns data
kubectl config set-context --current --namespace=data
kubectl auth can-i get pods -n data
```

Expected:

- context targets `staging-main`
- namespace is `data`
- auth check returns `yes`

### 6. Verify Rollout And Image

```bash
kubectl rollout status deploy/amadeus -n data --timeout=120s
kubectl get deploy amadeus -n data -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
kubectl get pods -n data -l app.kubernetes.io/name=amadeus -o wide
```

Confirm the backend image tag contains the promoted PR SHA using the new short
SHA artifact format, for example:

```text
backend-data.<epoch>-<shortsha>
```

Do not require the old `backend-data.<timestamp>.<sha>` dotted format.

### 7. Run Live Endpoint Probes

Port-forward locally:

```bash
kubectl port-forward -n data svc/amadeus 18000:8000
```

Probe public endpoints:

```bash
curl -fsS http://127.0.0.1:18000/health
curl -fsS http://127.0.0.1:18000/health/ready
curl -fsS http://127.0.0.1:18000/models
```

For authenticated `/v1/chat/completions`, run from inside the pod so the
staging secret is loaded without printing it:

```bash
POD=$(kubectl get pod -n data -l app.kubernetes.io/name=amadeus -o jsonpath='{.items[0].metadata.name}')

kubectl exec -i -n data "$POD" -- python - <<'PY'
from __future__ import annotations

import json
import urllib.request
from typing import Any

from src.config import get_settings

api_key: str | None = get_settings().amadeus_api_key
assert api_key, "missing amadeus_api_key"

payload: dict[str, object] = {
    "model": "bedrock/claude-haiku-4-5",
    "messages": [{"role": "user", "content": "Reply with ok."}],
    "max_tokens": 4,
    "temperature": 0,
}

request = urllib.request.Request(
    "http://127.0.0.1:8000/v1/chat/completions",
    data=json.dumps(payload).encode("utf-8"),
    headers={
        "content-type": "application/json",
        "x-amadeus-api-key": api_key,
        "baggage": "langfuse_metadata_feature=codex_staging_verify",
    },
    method="POST",
)

with urllib.request.urlopen(request, timeout=60) as response:
    decoded: dict[str, Any] = json.loads(response.read().decode("utf-8"))
    choices = decoded.get("choices", [])
    choice_count = len(choices) if isinstance(choices, list) else 0
    print(
        json.dumps(
            {
                "status": response.status,
                "model": decoded.get("model"),
                "choice_count": choice_count,
                "has_usage": decoded.get("usage") is not None,
            },
            sort_keys=True,
        )
    )
PY
```

### 8. Verify Logs

Check pod logs:

```bash
kubectl logs -n data deploy/amadeus --since=5m
```

For log-contract changes, verify:

- `request_completed` exists
- `service="amadeus"` exists
- `feature` propagates from baggage
- `trace_id` exists on traced completion routes
- `request_size_bytes` exists
- `large_request` remains separate when applicable
- `request_started` is absent when intentionally removed

Example:

```bash
kubectl logs -n data deploy/amadeus --since=5m | rg \
  'codex_staging_verify|"event": "large_request"|"event": "request_started"'
```

### 9. Cleanup

Stop any local port-forward:

```bash
lsof -tiTCP:18000 -sTCP:LISTEN | while read -r pid; do kill "$pid"; done
```

## Guardrails

- Do not select or reserve a `revNN` namespace.
- Do not run `find_free_namespace.py`.
- Always use namespace `data` unless Amadeus deployment config changes.
- Always use promotion name `Deploy to Staging`.
- Do not assume Semaphore directly built the Docker image; artifact build and
  Helm artifact packaging are delegated through `ci-tools` to GitHub Actions.
- Prefer the clean phase names in progress updates: build PR image, package
  staging release, deploy staging release, verify staging runtime.
- Do not print staging secrets.
- For authenticated probes, prefer running inside the pod and reading settings through `get_settings()`.
- Do not call staging validation complete until both Semaphore deploy and Kubernetes rollout are verified.

## Success Criteria

A promotion is verified only when all are true:

- Semaphore CI pipeline passed.
- CI `Build (staging)` / `Staging OCI artifacts` passed for the promoted PR SHA.
- Semaphore deploy pipeline passed.
- Deploy logs show `staging-oci-artifacts.yml` packaged the Helm OCI artifact for `data`.
- Deploy logs include Helm success for `data/amadeus`.
- Kubernetes rollout for `deploy/amadeus` succeeded.
- Deployed backend image tag contains the promoted PR short SHA in the `backend-data.<epoch>-<shortsha>` shape.
- Health/readiness/model endpoints respond.
- Any feature-specific live probe succeeds.
- Relevant pod logs prove the expected runtime contract.
