# AWS Backup Cross-Region EKS Restore Guide

## Overview

This document provides a step-by-step procedure to:

1. Retrieve the latest Amazon EKS backup from a source AWS region.
2. Copy the backup to a Disaster Recovery (DR) region.
3. Restore Kubernetes manifests into an existing EKS cluster in the DR region.
4. Validate the restored resources.

---

## Prerequisites

Before executing the commands, ensure the following requirements are met:

* AWS CLI v2 installed and configured with appropriate permissions.
* `kubectl` installed and configured.
* Valid EKS backups available in the source AWS Backup Vault.
* Destination EKS cluster already provisioned (for manifest-only restores).
* Network connectivity configured between environments if required.
* Matching StorageClasses available if persistent volumes are being restored.

---

# Step 1: Set Environment Variables

Define the source region, destination region, backup vault, and EKS cluster names.

```bash
SOURCE_AWS_REGION="us-west-1"
DESTINATION_AWS_REGION="us-east-2"

BACKUP_VAULT_NAME="eks-backup-vault"

SOURCE_EKS_CLUSTER_NAME="dev-eks"
DESTINATION_EKS_CLUSTER_NAME="new-dev-eks"
```

---

# Step 2: Ensure Destination Backup Vault Exists

Verify that the backup vault exists in the DR region. If it does not exist, create it automatically.

```bash
aws backup describe-backup-vault \
  --backup-vault-name "$BACKUP_VAULT_NAME" \
  --region "$DESTINATION_AWS_REGION" >/dev/null 2>&1 || \
aws backup create-backup-vault \
  --backup-vault-name "$BACKUP_VAULT_NAME" \
  --region "$DESTINATION_AWS_REGION"
```

---

# Step 3: Fetch Latest Recovery Point

Retrieve the most recent successful recovery point from the source vault.

```bash
SOURCE_RECOVERY_POINT_ARN=$(aws backup list-recovery-points-by-backup-vault \
  --backup-vault-name "$BACKUP_VAULT_NAME" \
  --region "$SOURCE_AWS_REGION" \
  --query "sort_by(RecoveryPoints[?Status=='COMPLETED'], &CreationDate)[-1].RecoveryPointArn" \
  --output text)

echo "Source Recovery Point ARN: $SOURCE_RECOVERY_POINT_ARN"
```

---

# Step 4: Fetch Destination Vault ARN

Retrieve the ARN of the backup vault in the DR region.

```bash
DESTINATION_BACKUP_VAULT_ARN=$(aws backup describe-backup-vault \
  --backup-vault-name "$BACKUP_VAULT_NAME" \
  --region "$DESTINATION_AWS_REGION" \
  --query 'BackupVaultArn' \
  --output text)

echo "Destination Vault ARN: $DESTINATION_BACKUP_VAULT_ARN"
```

---

# Step 5: Retrieve AWS Backup Service Role ARN

AWS Backup requires an IAM service role to perform copy and restore operations.

```bash
AWS_BACKUP_SERVICE_ROLE_ARN=$(aws iam get-role \
  --role-name AWSBackupDefaultServiceRole \
  --query 'Role.Arn' \
  --output text)

echo "Service Role ARN: $AWS_BACKUP_SERVICE_ROLE_ARN"
```

---

# Step 6: Start Cross-Region Copy Job

Copy the backup from the source region to the destination vault.

```bash
BACKUP_COPY_JOB_ID=$(aws backup start-copy-job \
  --region "$SOURCE_AWS_REGION" \
  --recovery-point-arn "$SOURCE_RECOVERY_POINT_ARN" \
  --source-backup-vault-name "$BACKUP_VAULT_NAME" \
  --destination-backup-vault-arn "$DESTINATION_BACKUP_VAULT_ARN" \
  --iam-role-arn "$AWS_BACKUP_SERVICE_ROLE_ARN" \
  --query 'CopyJobId' \
  --output text)

echo "Initiated Copy Job ID: $BACKUP_COPY_JOB_ID"
```

---

# Step 7: Monitor Copy Job Status

Check the status of the copy job.

```bash
aws backup describe-copy-job \
  --copy-job-id "$BACKUP_COPY_JOB_ID" \
  --region "$SOURCE_AWS_REGION"
```

Wait until the status becomes:

```text
COMPLETED
```

#### Monitor Copy Job Until Completion
```bash
while true; do

  COPY_JOB_STATUS=$(aws backup describe-copy-job \
    --copy-job-id "$BACKUP_COPY_JOB_ID" \
    --region "$SOURCE_AWS_REGION" \
    --query 'CopyJob.State' \
    --output text)

  echo "Copy Job Status: $COPY_JOB_STATUS"

  if [ "$COPY_JOB_STATUS" = "COMPLETED" ]; then
      echo "Backup copy completed successfully."
      break
  fi

  if [ "$COPY_JOB_STATUS" = "FAILED" ]; then
      echo "Backup copy failed."
      exit 1
  fi

  sleep 30

done
```

### Retrieve Copied Recovery Point ARN

```bash
DESTINATION_RECOVERY_POINT_ARN=$(aws backup list-recovery-points-by-backup-vault \
  --backup-vault-name "$BACKUP_VAULT_NAME" \
  --region "$DESTINATION_AWS_REGION" \
  --query "sort_by(RecoveryPoints[?Status=='COMPLETED'], &CreationDate)[-1].RecoveryPointArn" \
  --output text)

echo "Destination Recovery Point ARN: $DESTINATION_RECOVERY_POINT_ARN"
```

---

# Step 8: Configure Restore Metadata

Create a metadata file describing how the restore should be executed.

## Restore Configuration Parameters

| Parameter                      | Value        | Description                                   |
| ------------------------------ | ------------ | --------------------------------------------- |
| clusterName                    | String       | Name of the target EKS cluster                |
| newCluster                     | true / false | Whether to create a new EKS cluster           |
| restoreKubernetesManifestsOnly | true / false | Restore manifests only or include EBS volumes |

### Example Metadata

```bash
cat > metadata.json <<EOF
{
  "clusterName": "$DESTINATION_EKS_CLUSTER_NAME",
  "newCluster": "false",
  "restoreKubernetesManifestsOnly": "true"
}
EOF
```

---

# Step 9: Start Restore Job

Initiate the restore operation.

```bash
BACKUP_RESTORE_JOB_ID=$(aws backup start-restore-job \
  --region "$DESTINATION_AWS_REGION" \
  --recovery-point-arn "$DESTINATION_RECOVERY_POINT_ARN" \
  --resource-type EKS \
  --iam-role-arn "$AWS_BACKUP_SERVICE_ROLE_ARN" \
  --metadata file://metadata.json \
  --query 'RestoreJobId' \
  --output text)

echo "Initiated Restore Job ID: $BACKUP_RESTORE_JOB_ID"
```

---

# Step 10: Monitor Restore Progress

Check restore job status.

```bash
aws backup describe-restore-job \
  --restore-job-id "$BACKUP_RESTORE_JOB_ID" \
  --region "$DESTINATION_AWS_REGION"
```

Wait until:

```text
COMPLETED
```

#### Monitor Restore Job Until Completion
```bash
while true; do

  RESTORE_JOB_STATUS=$(aws backup describe-restore-job \
    --restore-job-id "$BACKUP_RESTORE_JOB_ID" \
    --region "$DESTINATION_AWS_REGION" \
    --query 'Status' \
    --output text)

  echo "Restore Job Status: $RESTORE_JOB_STATUS"

  if [ "$RESTORE_JOB_STATUS" = "COMPLETED" ]; then
      echo "Restore completed successfully."
      break
  fi

  if [ "$RESTORE_JOB_STATUS" = "FAILED" ]; then
      echo "Restore failed."
      exit 1
  fi

  sleep 30

done
```
---


# Step 11: Validate Restored Resources

Update kubeconfig for the destination cluster.

```bash
aws eks update-kubeconfig \
  --name "$SOURCE_EKS_CLUSTER_NAME" \
  --region "$DESTINATION_AWS_REGION"
```


## Validate Namespaces

```bash
kubectl get ns
```

## Validate Deployments

```bash
kubectl get deployments -A
```

## Validate Services

```bash
kubectl get svc -A
```

## Validate Persistent Volume Claims

```bash
kubectl get pvc -A
```