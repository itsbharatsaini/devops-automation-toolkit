# kubectl Cheat Sheet

## View Pods

```bash
kubectl get pods
kubectl get pods -A
kubectl get pods -o wide
```

Use to verify workloads.

## View Logs

```bash
kubectl logs pod-name
kubectl logs -f pod-name
```

## Access Container

```bash
kubectl exec -it pod-name -- sh
```

## Deployments

```bash
kubectl get deploy -A
kubectl rollout restart deploy/app -n dev
kubectl rollout status deploy/app -n dev
```

## Troubleshooting

```bash
kubectl describe pod pod-name
kubectl get events -A --sort-by=.metadata.creationTimestamp
kubectl top pod
kubectl top node
```
