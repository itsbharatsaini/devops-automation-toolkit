# Helm Cheat Sheet

## Repositories

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

## Install

```bash
helm install app chart/
```

## Upgrade

```bash
helm upgrade app chart/
```

## Rollback

```bash
helm rollback app 1
```

## Troubleshooting

```bash
helm list -A
helm history app
helm get values app
```
