# Velero Installation & Operations Guide for AWS EKS

## Overview

This document provides the standard procedure for installing, configuring, validating, backing up, and restoring Kubernetes workloads using Velero on Amazon EKS.

# Prerequisites

Before installing Velero, ensure the following prerequisites are met:

* Amazon EKS cluster is operational.
* kubectl is configured and connected to the target EKS cluster.
* Helm v3.x is installed.
* Velero backup S3 bucket exists.
* IRSA role is configured:

  ```text
  arn:aws:iam::6XXXXXXXXXX9:role/velero-irsa
  ```
* AWS EBS CSI Driver is installed (if volume snapshots are required).

---

# 1. Install Velero CLI

The Velero CLI is required for backup and restore operations.

## Linux & macOS

### Using Homebrew

```bash
brew install velero
```

### Manual Installation

```bash
curl -L https://github.com/vmware-tanzu/velero/releases/download/v1.13.0/velero-v1.13.0-linux-amd64.tar.gz | tar -xz

sudo mv velero-v1.13.0-linux-amd64/velero /usr/local/bin/
```

### Verify Installation

```bash
velero version
```

---

## Windows

### Using Chocolatey

```powershell
choco install velero
```

### Using Winget

```powershell
winget install VMware.Velero
```

### Verify Installation

```powershell
velero version
```

---

# 2. Add Velero Helm Repository

```bash
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts

helm repo update
```

Verify repository:

```bash
helm search repo velero
```

---

# 3. Install Velero Using Helm

## Environment Variables

Define the following variables before executing any commands.

### Linux / macOS (Bash)

```bash
# IRSA Configuration
export VELERO_IRSA_ROLE_ARN="arn:aws:iam::6XXXXXXXXXX9:role/velero-irsa"

# Backup Storage Configuration
export VELERO_BACKUP_BUCKET="dev-eks-velero-backup"
export VELERO_BACKUP_BUCKET_REGION="us-east-1"
```

---

### Windows PowerShell

```powershell
# IRSA Configuration
$env:VELERO_IRSA_ROLE_ARN="arn:aws:iam::6XXXXXXXXXX9:role/velero-irsa"

# Backup Storage Configuration
$env:VELERO_BACKUP_BUCKET="dev-eks-velero-backup"
$env:VELERO_BACKUP_BUCKET_REGION="us-east-1"
```
## Linux & macOS (Bash / Zsh)

```bash
helm upgrade --install velero vmware-tanzu/velero \
  --namespace velero \
  --create-namespace \
  --set credentials.useSecret=false \
  --set serviceAccount.server.create=true \
  --set serviceAccount.server.name=velero-server \
  --set serviceAccount.server.annotations."eks\.amazonaws\.com/role-arn"="${VELERO_IRSA_ROLE_ARN}" \
  --set configuration.backupStorageLocation[0].name=default \
  --set configuration.backupStorageLocation[0].provider=aws \
  --set configuration.backupStorageLocation[0].bucket=${VELERO_BACKUP_BUCKET} \
  --set configuration.backupStorageLocation[0].config.region=${VELERO_BACKUP_BUCKET_REGION} \
  --set configuration.volumeSnapshotLocation[0].name=default \
  --set configuration.volumeSnapshotLocation[0].provider=aws \
  --set configuration.volumeSnapshotLocation[0].config.region=${VELERO_BACKUP_BUCKET_REGION} \
  --set initContainers[0].name=velero-plugin-for-aws \
  --set initContainers[0].image=velero/velero-plugin-for-aws:v1.13.0 \
  --set initContainers[0].volumeMounts[0].mountPath=/target \
  --set initContainers[0].volumeMounts[0].name=plugins
```

---

## Windows (PowerShell)

```powershell
helm upgrade --install velero vmware-tanzu/velero `
  --namespace velero `
  --create-namespace `
  --set credentials.useSecret=false `
  --set serviceAccount.server.create=true `
  --set serviceAccount.server.name=velero-server `
  --set serviceAccount.server.annotations."eks\.amazonaws\.com/role-arn"="$env:VELERO_IRSA_ROLE_ARN" `
  --set configuration.backupStorageLocation[0].name=default `
  --set configuration.backupStorageLocation[0].provider=aws `
  --set configuration.backupStorageLocation[0].bucket=$env:VELERO_BACKUP_BUCKET `
  --set configuration.backupStorageLocation[0].config.region=$env:VELERO_BACKUP_BUCKET_REGION `
  --set configuration.volumeSnapshotLocation[0].name=default `
  --set configuration.volumeSnapshotLocation[0].provider=aws `
  --set configuration.volumeSnapshotLocation[0].config.region=$env:VELERO_BACKUP_BUCKET_REGION `
  --set initContainers[0].name=velero-plugin-for-aws `
  --set initContainers[0].image=velero/velero-plugin-for-aws:v1.13.0 `
  --set initContainers[0].volumeMounts[0].mountPath=/target `
  --set initContainers[0].volumeMounts[0].name=plugins
```

---

# 4. Validate Installation

## Verify Helm Release

```bash
helm list -n velero
```

Expected Output:

```text
NAME    NAMESPACE   STATUS
velero  velero      deployed
```

---

## Verify Pods

```bash
kubectl get pods -n velero
```

Expected Output:

```text
NAME                      READY   STATUS
velero-xxxxxxxxxx-xxxxx   1/1     Running
```

---

## Verify Deployment

```bash
kubectl get deployment velero -n velero
```

---

## Verify Service Account Annotation

```bash
kubectl get sa velero-server -n velero -o yaml
```

Expected Annotation:

```yaml
annotations:
  eks.amazonaws.com/role-arn: arn:aws:iam::6XXXXXXXXXX9:role/velero-irsa
```

---

# 5. Backup Storage Validation

Verify Backup Storage Location (BSL):

```bash
kubectl get backupstoragelocations -n velero
```

or

```bash
kubectl get bsl -A
```

Verify through Velero CLI:

```bash
velero backup-location get
```

Expected Status:

```text
AVAILABLE
```

---

# 6. Operational Playbook

## Phase 1 – Health Checks

### Check Backup Storage Locations

```bash
kubectl get bsl -A
```

### Verify Backup Storage Location

```bash
velero backup-location get
```

### Verify Velero Deployment

```bash
kubectl get deployment/velero -n velero
```

### Verify Secret Usage

Since IRSA is used:

```bash
kubectl get secret/velero -n velero
```

Expected Result:

```text
No resources found
```

---

## Phase 2 – Backup Operations

### List Existing Backups

```bash
velero backup get
```

---

### Create Manual Backup

```bash
velero backup create velero-backup-03
```

---

### Check Backup Status

```bash
velero backup describe velero-backup-03
```

---

### View Detailed Backup Logs

```bash
velero backup logs velero-backup-03
```

---

### Monitor Backup Progress

```bash
watch velero backup get
```

---

## Phase 3 – Restore Operations

### List Existing Restores

```bash
velero restore get
```

---

### Create Restore

```bash
velero restore create yelb-restore-03 \
  --from-backup velero-backup-03
```

---

### Check Restore Status

```bash
velero restore describe yelb-restore-03
```

---

### View Restore Logs

```bash
velero restore logs yelb-restore-03
```

---

# 7. Common Troubleshooting Commands

## Check Velero Logs

```bash
kubectl logs deployment/velero -n velero
```

---

## Check Velero Pod

```bash
kubectl get pods -n velero
```

---

## Describe Velero Pod

```bash
kubectl describe pod -n velero <velero-pod-name>
```

---

## Verify IRSA Permissions

```bash
kubectl exec -it deployment/velero -n velero -- env | grep AWS
```

---

## Validate Backup Storage Access

```bash
velero backup-location get
```

---

# 8. Uninstall Velero

Remove Helm Release:

```bash
helm uninstall velero -n velero
```

Delete Namespace:

```bash
kubectl delete namespace velero
```

Note: Backups stored in the S3 bucket remain intact and are not deleted during Helm uninstallation.

---

# Useful Commands Summary

```bash
# Verify installation
velero version

# List backups
velero backup get

# Create backup
velero backup create velero-backup-03

# Describe backup
velero backup describe velero-backup-03

# View backup logs
velero backup logs velero-backup-03

# List restores
velero restore get

# Create restore
velero restore create restore-03 --from-backup velero-backup-03

# Check restore
velero restore describe restore-03

# View restore logs
velero restore logs restore-03
```
