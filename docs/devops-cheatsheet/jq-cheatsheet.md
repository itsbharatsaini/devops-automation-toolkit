# jq Cheat Sheet

```bash
jq . file.json
jq '.items[]' file.json
jq -r '.items[].metadata.name' file.json
```

Kubernetes Example:

```bash
kubectl get pods -o json | jq '.items[].metadata.name'
```
