# AWS EKS Backup Cross Region Restore

Pipeline: `AWS-EKS-Backup-Cross-Region-Restore.yml`

## Purpose

Restores the latest completed EKS backup recovery point from a destination AWS Backup vault into the specified destination EKS cluster.

## Parameters

- `DESTINATION_AWS_REGION`: AWS region where the backup vault and EKS cluster are located.
- `DESTINATION_BACKUP_VAULT_NAME`: AWS Backup vault name.
- `DESTINATION_EKS_CLUSTER_NAME`: Destination EKS cluster name.
- `DESTINATION_EKS_CLUSTER_NAMESPACES`: Namespaces to restore (array).

## How it works

1. Retrieves the latest completed recovery point from the destination backup vault.
2. Creates a restore job for the EKS resource.
3. Polls the restore job until it completes.

## Requirements

- Azure DevOps AWS service connection named `AWS-ServiceConnection`.
- AWS Backup permissions to list recovery points and start restore jobs.
- `AWSBackupDefaultServiceRole` available in the destination region.

## Notes

- This pipeline is useful when the backup copy is already present in the destination region.
- If you only need restore functionality, use this pipeline instead of the full copy-and-restore pipeline.
