---
name: staging-kube-connect
description: Connect to staging servers by authenticating with Teleport and connecting `kubectl` to `staging-main`. Use when the user asks to connect to staging servers.
---

# Staging Kube Connect

## Job

Connect local `kubectl` to `staging-main`. This skill does not choose or reserve namespaces.

## Inputs

- Required: `tsh`
- Required: `kubectl`
- Optional: `namespace` (`revNN` or `qaNN`) when the user explicitly asks to set one

## Outputs

- `kubectl config current-context` targets `staging-main`
- If `namespace` was provided, current context namespace is set to that value
- Access check passes: `kubectl auth can-i get pods` (namespace-scoped when provided)

## Workflow

1. Authenticate with Teleport.
```bash
tsh login --proxy=teleport.simplepractice.com --auth=gsuite
```
2. Connect `kubectl` to staging cluster.
```bash
tsh kube login staging-main
```
3. Verify active context is staging.
```bash
kubectl config current-context
```
4. If the user provided `namespace`, validate and set it.
```bash
kubectl get ns <namespace>
kubectl config set-context --current --namespace=<namespace>
kubectl auth can-i get pods -n <namespace>
```
5. If no `namespace` was provided, verify access without changing namespace.
```bash
kubectl auth can-i get pods
```

## Probe Gotchas

### SimplePractice staging Rails runner gotcha

In Kubernetes staging, do not validate Rails/AI SDK behavior with plain
`kubectl exec ... bundle exec rails runner`.

The pod env contains encrypted `kms://...` placeholders from ConfigMaps. The
actual SimplePractice server is launched through `aws-env exec`, which decrypts
those values before starting `/sbin/my_init` / Passenger. A fresh `kubectl exec`
process does not inherit that decrypted server env, so plain runner probes can
produce false failures like:

`AI::AuthenticationError: AMADEUS_API_KEY is invalid or missing`

Use this shape instead:

```bash
kubectl exec -n "$NAMESPACE" -c simplepractice "$POD" -- \
  aws-env exec -- bash -lc 'FCM_CREDENTIALS_JSON="{}" FCM_WEB_API_KEY=dummy FCM_IOS_BUNDLE_ID=dummy FCM_ANDROID_PROJECT_ID=dummy bundle exec rails runner "<ruby>"'
```

Before blaming config, compare sanitized env:

```bash
kubectl exec -n "$NAMESPACE" -c simplepractice "$POD" -- \
  aws-env exec -- ruby -e 'v=ENV["AMADEUS_API_KEY"].to_s; puts "aws_env_exec AMADEUS_API_KEY=#{v[0,6]} len=#{v.length}"'
```

If plain `kubectl exec` shows `kms://...` but `aws-env exec` shows a
decrypted-looking value, the config is present and the plain probe is invalid.

First-principles version: `aws-env exec` decrypts env for the process tree it
starts. `kubectl exec` starts a separate process with the original pod env. So
plain exec is testing the wrong runtime.

## Guardrails

- Run direct CLI commands; do not invoke local helper scripts for this skill.
- Do not auto-select, reserve, or infer a namespace.
- Do not call Linear or reservation tooling.
- Do not mutate workload resources; this skill is access/bootstrap only.
- Keep cluster fixed to `staging-main` unless the user explicitly requests a different cluster.

## Related

- Namespace reservation + deploy workflow: `staging-server-promote`
