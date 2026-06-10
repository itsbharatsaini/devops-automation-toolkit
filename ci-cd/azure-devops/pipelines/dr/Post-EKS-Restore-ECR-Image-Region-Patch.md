# Post EKS Restore ECR Image Region Patch

Pipeline: `Post-EKS-Restore-ECR-Image-Region-Patch.yml`

## Purpose

Updates EKS deployment container image URIs after restore by replacing the source AWS region with the destination AWS region.

## Parameters

- `SOURCE_AWS_REGION`: Region in the current image URIs.
- `DESTINATION_AWS_REGION`: Region to replace in the image URIs.
- `DESTINATION_EKS_CLUSTER_NAME`: Target EKS cluster name.
- `DESTINATION_EKS_CLUSTER_NAMESPACES`: Namespaces to patch.

## How it works

1. Configures `kubectl` for the destination EKS cluster.
2. Installs `kubectl` via `KubectlInstaller@0`.
3. For each namespace, reads deployments and updates container images by replacing the source region string with the destination region string.

## Requirements

- Azure DevOps AWS service connection named `AWS-ServiceConnection`.
- Permissions to describe EKS clusters and patch Kubernetes deployments.

## Variable group

This pipeline includes a variable group called `DR-Automation-Variables`.
The variable group must contain at least:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- optionally `AWS_SESSION_TOKEN`

These values are used by the AWS CLI tasks when configuring `kubectl` and describing the EKS cluster.

## Notes

- This pipeline is useful after a restore that requires image references to move from one AWS region to another.
- It uses `jq` inside shell scripting to parse deployment JSON.
