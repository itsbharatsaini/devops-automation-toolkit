# AWS EKS Backup Cross Region Copy and Restore

Pipeline: `AWS-EKS-Backup-Cross-Region-Copy-and-Restore.yml`

## Purpose

Copies the latest completed EKS backup recovery point from a source AWS Backup vault to a destination region, then restores it into the target EKS cluster.

## Parameters

- `SOURCE_AWS_REGION`: Source AWS region holding the original backup.
- `SOURCE_BACKUP_VAULT_NAME`: Backup vault name in the source region.
- `DESTINATION_AWS_REGION`: Destination AWS region for the copied backup.
- `DESTINATION_BACKUP_VAULT_NAME`: Backup vault name in the destination region.
- `DESTINATION_EKS_CLUSTER_NAME`: Target EKS cluster name for restore.
- `DESTINATION_EKS_CLUSTER_NAMESPACES`: Namespaces to restore (array).

## How it works

1. Finds the latest completed EKS recovery point in the source vault.
2. Creates the destination backup vault if it does not exist.
3. Starts an AWS Backup copy job to the destination vault.
4. Polls until the copy is complete.
5. Starts a restore job in the destination region using the copied recovery point.
6. Waits until restore completes successfully.

## Requirements

- Azure DevOps AWS service connection named `AWS-ServiceConnection`.
- AWS permissions to list backups, copy recovery points, and start restore jobs.
- `AWSBackupDefaultServiceRole` available in the source account.

## Notes

- This pipeline is intended for disaster recovery workflows across AWS regions.
- Use the pipeline UI or variable groups to set parameter values.
