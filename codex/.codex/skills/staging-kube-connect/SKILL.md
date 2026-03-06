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

## Guardrails

- Run direct CLI commands; do not invoke local helper scripts for this skill.
- Do not auto-select, reserve, or infer a namespace.
- Do not call Linear or reservation tooling.
- Do not mutate workload resources; this skill is access/bootstrap only.
- Keep cluster fixed to `staging-main` unless the user explicitly requests a different cluster.

## Related

- Namespace reservation + deploy workflow: `staging-server-promote`
