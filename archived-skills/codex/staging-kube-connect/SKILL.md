---
name: staging-kube-connect
description: >-
  Connect and verify SimplePractice staging access through spx. Use when the
  user asks to connect to staging-main, verify access to a revNN or qaNN
  namespace, inspect staging, or run a staging application probe.
---

# Staging Kubernetes Access through SPX

## Job

Use `spx staging connect` as the only Teleport and Kubernetes bootstrap path.
Use `spx staging logs`, `spx staging exec`, and `spx staging db` for subsequent
staging access.

Do not call `tsh` or `kubectl` directly unless SPX reports a missing capability
that the user explicitly asks you to investigate.

This skill does not choose, infer, or reserve namespaces. It does not deploy or
mutate Kubernetes workloads.

## Read the Contract

```sh
spx describe staging.connect
spx describe staging.exec
```

Parse the final `spx.response.v1` document from stdout. Parse
`spx.progress.v1` JSONL from stderr when `--progress` is set.

## Connect

Connect or reuse valid staging access:

```sh
spx --progress staging connect
```

Verify one explicit namespace:

```sh
spx --progress staging connect --namespace <revNN-or-qaNN>
```

Require the result to report:

- `cluster` as `staging-main`.
- `context` as `teleport-staging-main`.
- `connection` as `reused` or `authenticated`.
- `verified` containing `context` and `get_pods`.
- `verified` containing `namespace_exists` when a namespace was provided.
- `namespace_default` as `unchanged`.

SPX never changes the current context's default namespace. Every later staging
command must continue to use an explicit `--namespace`.

## Inspect Staging

```sh
spx staging logs --app <app> --namespace <namespace> --tail 200
spx staging logs --app <app> --namespace <namespace> --follow
spx staging exec --app <app> --namespace <namespace> --stream -- <command>
spx staging exec --app <app> --namespace <namespace> --tty
spx staging db --app <app> --namespace <namespace>
```

Use `--rw` for a database connection only when the user explicitly requires
write access.

## SimplePractice Runtime Probes

Do not run a SimplePractice Rails or AI SDK probe through plain `kubectl exec`.
The pod configuration can contain encrypted `kms://...` placeholders. A new
plain exec process sees those placeholders and can produce false missing-key
or invalid-key failures.

Use SPX instead:

```sh
spx staging exec \
  --app simplepractice \
  --namespace <namespace> \
  --stream -- \
  bash -lc 'FCM_CREDENTIALS_JSON="{}" FCM_WEB_API_KEY=dummy FCM_IOS_BUNDLE_ID=dummy FCM_ANDROID_PROJECT_ID=dummy bundle exec rails runner "<ruby>"'
```

For non-client-portal applications, SPX runs the command through
`aws-env exec --`. The probe therefore receives the decrypted runtime
environment. Do not add a second `aws-env exec` wrapper.

Before you blame configuration, compare only sanitized metadata. Never print a
credential or complete environment value.

## Guardrails

- Keep the cluster fixed to `staging-main`.
- Require an explicit namespace for every namespace-scoped command.
- Do not change the kubectl context's default namespace.
- Do not call Linear or reservation tooling.
- Do not mutate workload resources.
- Do not use `staging db --rw` without explicit write intent.
- Do not expose decrypted environment values.
- Use `staging-server-promote` for deployment.

## Related

- Guarded staging deployment: `staging-server-promote`
- General docker-dev control plane: `spx`
