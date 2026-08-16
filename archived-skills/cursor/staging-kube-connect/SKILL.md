---
name: staging-kube-connect
description: Connect to staging servers by signing in with Teleport and connecting `kubectl` to `staging-main`. Use when the user asks to connect to staging servers.
---

# Staging Kube Connect

## Job

Connect local `kubectl` to `staging-main`.

This skill does not choose or reserve namespaces.

## Inputs

- Required: `tsh`
- Required: `kubectl`
- Optional: `namespace` (`revNN` or `qaNN`) when the user explicitly asks to set one

## Outputs

- `kubectl config current-context` targets `staging-main`.
- If the user provided `namespace`, the current context namespace is set to that value.
- The access check passes: `kubectl auth can-i get pods`.
- When a namespace is provided, the access check is namespace-scoped.

## Workflow

1. Sign in with Teleport.

```bash
tsh login --proxy=teleport.simplepractice.com --auth=gsuite
```

2. Connect `kubectl` to the staging cluster.

```bash
tsh kube login staging-main
```

3. Verify that the active context is staging.

```bash
kubectl config current-context
```

4. If the user provided `namespace`, validate it and set it.

```bash
kubectl get ns <namespace>
kubectl config set-context --current --namespace=<namespace>
kubectl auth can-i get pods -n <namespace>
```

5. If the user did not provide `namespace`, verify access without changing the namespace.

```bash
kubectl auth can-i get pods
```

## Probe Gotchas

### SimplePractice Staging Rails Runner Gotcha

In Kubernetes staging, do not validate Rails or AI SDK behavior with plain `kubectl exec ... bundle exec rails runner`.

The pod environment contains encrypted `kms://...` placeholders from ConfigMaps. The SimplePractice server starts through `aws-env exec`. That command decrypts the values before it starts `/sbin/my_init` and Passenger.

A new `kubectl exec` process does not inherit that decrypted server environment. Plain runner probes can therefore show false failures such as:

```text
AI::AuthenticationError: AMADEUS_API_KEY is invalid or missing
```

Use this shape instead:

```bash
kubectl exec -n "$NAMESPACE" -c simplepractice "$POD" -- \
  aws-env exec -- bash -lc 'FCM_CREDENTIALS_JSON="{}" FCM_WEB_API_KEY=dummy FCM_IOS_BUNDLE_ID=dummy FCM_ANDROID_PROJECT_ID=dummy bundle exec rails runner "<ruby>"'
```

Before you blame configuration, compare sanitized environment values:

```bash
kubectl exec -n "$NAMESPACE" -c simplepractice "$POD" -- \
  aws-env exec -- ruby -e 'v=ENV["AMADEUS_API_KEY"].to_s; puts "aws_env_exec AMADEUS_API_KEY=#{v[0,6]} len=#{v.length}"'
```

If plain `kubectl exec` shows `kms://...` and `aws-env exec` shows a decrypted-looking value, configuration is present. The plain probe is invalid.

First-principles rule: `aws-env exec` decrypts environment values for the process tree it starts. `kubectl exec` starts a separate process with the original pod environment. Plain exec tests the wrong runtime.

## Guardrails

- Run direct CLI commands. Do not use local helper scripts for this skill.
- Do not auto-select, reserve, or infer a namespace.
- Do not call Linear or reservation tooling.
- Do not mutate workload resources. This skill is only for access and bootstrap.
- Keep the cluster fixed to `staging-main` unless the user explicitly asks for a different cluster.

## Related

- Namespace reservation and deploy workflow: `staging-server-promote`
