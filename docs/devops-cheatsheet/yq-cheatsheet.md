# yq Cheat Sheet

```bash
yq '.metadata.name' deploy.yaml
yq '.spec.replicas=3' deploy.yaml
yq '.image.tag="1.2.3"' values.yaml
```

Useful for Helm values updates.
