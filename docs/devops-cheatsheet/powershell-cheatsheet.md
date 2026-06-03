# PowerShell Cheat Sheet

## Files

```powershell
Get-ChildItem
Get-Content file.txt
```

## Processes

```powershell
Get-Process
Get-Service
```

## Networking

```powershell
Test-NetConnection google.com -Port 443
```

## AWS

```powershell
$env:AWS_PROFILE="dev"
aws sts get-caller-identity
```

## Kubernetes

```powershell
kubectl get pods -A
```
