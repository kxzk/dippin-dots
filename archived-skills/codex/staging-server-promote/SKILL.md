---
name: staging-server-promote
description: >-
  Plan and execute a guarded SimplePractice staging deployment through spx.
  Use when the user asks to choose a staging server, deploy a checkout or pull
  request to an explicit revNN or qaNN namespace, or verify the Semaphore
  deployment.
---

# Staging Server Promote through SPX

## Job

Use `spx staging deploy` as the only deployment control plane.
Do not call `sem-ai`, `gh`, Linear, or namespace helper scripts directly.

SPX verifies the source commit, passed CI pipeline, committed Semaphore
configuration, promotion target, allowed namespace, and Linear reservations.
SPX also owns plan confirmation, promotion, waiting, and Helm log verification.

## Required Inputs

- An explicit `revNN` or `qaNN` namespace.
- The intended SimplePractice checkout or pull request number.
- A valid local SPX, Semaphore, GitHub, and Linear credential environment.

SPX does not select a namespace. Active Linear labels are advisory and do not
provide an atomic lease. If the user does not name a namespace, ask for one.

## Read the Contract

```sh
spx describe staging.deploy
```

Parse the final `spx.response.v1` document from stdout. Use `--progress` to
parse long-running `spx.progress.v1` JSONL records from stderr.

## Plan the Deployment

Use the checkout's exact current commit:

```sh
spx staging deploy \
  --repo <simplepractice-checkout> \
  --namespace <revNN-or-qaNN>
```

Use the exact pull request head:

```sh
spx staging deploy \
  --repo <simplepractice-checkout> \
  --pr <pull-request-number> \
  --namespace <revNN-or-qaNN>
```

The first invocation is read-only. Require all of these result conditions:

- `dry_run` is `true`.
- `status` is `planned`.
- `plan.requires_confirmation` is `true`.
- `plan.source.commit_sha` is the intended commit.
- `plan.namespace` is the explicit namespace.
- `plan.namespace` appears in `plan.allowed_namespaces`.
- `plan.promotion.target` is `Deploy to EKS staging`.
- `plan.promotion.parameter` is `CD_EKS_NAMESPACE`.
- `plan.promotion.override_conditions` is `false`.
- `plan.active_reservations` does not contain the selected namespace.

Record `plan.id`. Do not confirm a plan whose source, target, namespace, or
reservation evidence differs from the user's request.

## Execute the Current Plan

```sh
spx --progress staging deploy \
  --repo <simplepractice-checkout> \
  --namespace <revNN-or-qaNN> \
  --confirm <plan-id>
```

Include `--pr <pull-request-number>` again when the plan used a pull request.
SPX recomputes the complete plan. It rejects confirmation when any bound input
or evidence changed.

## Interpret the Result

A successful confirmed result must report:

- `dry_run` as `false`.
- `status` as `semaphore_passed`.
- `deployment.result` as `passed`.
- `deployment.helm_succeeded` as `true`.
- `deployment.semaphore_verified` as `true`.
- `deployment.kubernetes_verified` as `false`.

`semaphore_passed` proves the Semaphore deployment and Helm log boundary. It
does not prove that the live Kubernetes workload or application is healthy.
Use `staging-kube-connect` for live cluster or application verification.

Report the source commit, source pipeline ID, namespace, deploy pipeline ID,
deploy workflow ID, deploy job ID, and the verification boundary.

## Guardrails

- Require an explicit namespace. Do not choose, infer, or reserve one.
- Do not use the removed `find_free_namespace.py` workflow.
- Do not call `sem-ai pipeline promote` directly.
- Do not use Semaphore override conditions.
- Do not deploy a failed, pending, ambiguous, or branch-only source.
- Do not reuse a plan ID after any source or reservation change.
- Do not report Kubernetes or application success from Semaphore evidence.
- If deployment passed but Linear cleanup failed, do not repeat deployment only
  to retry cleanup.

## Related

- Staging access and live verification: `staging-kube-connect`
- General docker-dev control plane: `spx`
