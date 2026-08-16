---
name: staging-kube-connect
description: Connect to staging servers. This skill authenticates with Teleport and connects `kubectl` to `staging-main`. Use this skill when the user asks to connect to staging servers.
---

# Staging Kube Connect

## Job

Connect the local `kubectl` to `staging-main`. This skill does not choose a namespace. This skill does not reserve a namespace.

## Inputs

- Required: `tsh`
- Required: `kubectl`
- Optional: `namespace` (`revNN` or `qaNN`). Use it only when the user asks for a namespace.

## Outputs

- `kubectl config current-context` points to `staging-main`.
- If the user gives a `namespace`, the current context uses that namespace.
- The access check `kubectl auth can-i get pods` passes. The check is namespace-scoped when the user gives a namespace.

## Workflow

1. Authenticate with Teleport.
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
4. If the user gives a `namespace`, validate it and set it.
```bash
kubectl get ns <namespace>
kubectl config set-context --current --namespace=<namespace>
kubectl auth can-i get pods -n <namespace>
```
5. If the user does not give a `namespace`, verify the access. Do not change the namespace.
```bash
kubectl auth can-i get pods
```

## Guardrails

- Run the direct CLI commands. Do not use local helper scripts for this skill.
- Do not select, reserve, or infer a namespace automatically.
- Do not call Linear or the reservation tools.
- Do not change workload resources. This skill is only for access and bootstrap.
- Keep the cluster set to `staging-main`. Change the cluster only when the user asks for a different cluster.

## Rails runner gotcha in SimplePractice staging

In Kubernetes staging, do not validate Rails or AI SDK behavior with a plain
`kubectl exec ... bundle exec rails runner`.

The pod env contains encrypted `kms://...` placeholders from ConfigMaps.
`aws-env exec` starts the actual SimplePractice server, and it decrypts those
values before it starts `/sbin/my_init` and Passenger. A fresh `kubectl exec`
process does not inherit that decrypted server env. Therefore a plain runner
probe can give a false failure such as:

`AI::AuthenticationError: AMADEUS_API_KEY is invalid or missing`

Use this command shape instead:

```bash
kubectl exec -n "$NAMESPACE" -c simplepractice "$POD" -- \
  aws-env exec -- bash -lc 'FCM_CREDENTIALS_JSON="{}" FCM_WEB_API_KEY=dummy FCM_IOS_BUNDLE_ID=dummy FCM_ANDROID_PROJECT_ID=dummy bundle exec rails runner "<ruby>"'
```

Before you blame the config, compare the sanitized env:

```bash
kubectl exec -n "$NAMESPACE" -c simplepractice "$POD" -- \
  aws-env exec -- ruby -e 'v=ENV["AMADEUS_API_KEY"].to_s; puts "aws_env_exec AMADEUS_API_KEY=#{v[0,6]} len=#{v.length}"'
```

The plain `kubectl exec` can show `kms://...` while `aws-env exec` shows a decrypted value. In that case the config is present and the plain probe is invalid.

First principles: `aws-env exec` decrypts the env for the process tree that it starts. `kubectl exec` starts a separate process with the original pod env. The plain exec tests the wrong runtime.

## Related

- Namespace reservation and deploy workflow: `staging-server-promote`
