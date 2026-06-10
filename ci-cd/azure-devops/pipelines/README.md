# Azure DevOps Pipelines

This folder contains Azure DevOps pipeline definitions for AWS EKS backup and restore automation, Azure DevOps Kubernetes service connection creation, and post-restore image patching.

## Pipeline categories

### Backup and restore workflows

- [`AWS-EKS-Backup-Cross-Region-Copy-and-Restore.yml`](AWS-EKS-Backup-Cross-Region-Copy-and-Restore.yml)
  - Full cross-region copy and restore workflow.
- [`AWS-EKS-Backup-Cross-Region-Restore.yml`](AWS-EKS-Backup-Cross-Region-Restore.yml)
  - Restore-only workflow from the destination backup vault.

### Service connection workflow

- [`Create-K8s-Service-Connection.yml`](Create-K8s-Service-Connection.yml)
  - Creates an Azure DevOps Kubernetes service connection from an EKS cluster secret.

### Post-restore workflow

- [`Post-EKS-Restore-ECR-Image-Region-Patch.yml`](Post-EKS-Restore-ECR-Image-Region-Patch.yml)
  - Updates deployment image URIs by patching source region references to the destination region.

## Pipeline documentation links

- [`AWS-EKS-Backup-Cross-Region-Copy-and-Restore.md`](AWS-EKS-Backup-Cross-Region-Copy-and-Restore.md)
- [`AWS-EKS-Backup-Cross-Region-Restore.md`](AWS-EKS-Backup-Cross-Region-Restore.md)
- [`Create-K8s-Service-Connection.md`](Create-K8s-Service-Connection.md)
- [`Post-EKS-Restore-ECR-Image-Region-Patch.md`](Post-EKS-Restore-ECR-Image-Region-Patch.md)

## How to use

1. Open Azure DevOps and create a new pipeline.
2. Select the YAML file from this folder.
3. Provide the required parameters when running the pipeline:
   - `SOURCE_AWS_REGION`
   - `SOURCE_BACKUP_VAULT_NAME`
   - `DESTINATION_AWS_REGION`
   - `DESTINATION_BACKUP_VAULT_NAME`
   - `DESTINATION_EKS_CLUSTER_NAME`
   - `DESTINATION_EKS_CLUSTER_NAMESPACES`
   - `DESTINATION_EKS_SECRET_NAME`
   - `K8S_SERVICE_CONNECTION_NAME`

## Parameter guidance

### Common pipeline parameters

- `SOURCE_AWS_REGION`: Region where the original EKS backup exists.
- `DESTINATION_AWS_REGION`: Target region for backup copy or restore.
- `DESTINATION_EKS_CLUSTER_NAME`: Destination EKS cluster name.
- `DESTINATION_EKS_CLUSTER_NAMESPACES`: A list of namespaces to process.

### Service connection pipeline parameters

- `DESTINATION_EKS_SECRET_NAME`: Name of the Kubernetes secret containing service account credentials.
- `K8S_SERVICE_CONNECTION_NAME`: Name for the Azure DevOps Kubernetes service connection.

## Prerequisites

- Azure DevOps organization and project.
- `AWS-ServiceConnection` configured in Azure DevOps.
- Permissions for AWS Backup, EKS, IAM, and Kubernetes operations.
- `kubectl` installer is available via `KubectlInstaller@0`.
- `jq` is available on the Linux agent image.

## Notes

- `Create-K8s-Service-Connection.yml` executes `python3 create_k8s_service_connection.py` from the pipeline working directory.
- If you keep the script in `ci-cd/azure-devops/script/`, update the pipeline command accordingly:

```yaml
python3 ci-cd/azure-devops/script/create_k8s_service_connection.py \
  --pat $(System.AccessToken) \
  --secret secret.json \
  --cluster-url $(CLUSTER_URL) \
  --name $(K8S_SERVICE_CONNECTION_NAME)
```
