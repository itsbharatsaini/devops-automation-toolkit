# Dev Environment - Existing EKS Cluster With EKS Backup Plan

This directory contains the Terraform deployment configuration for enabling AWS Backup on an existing Amazon EKS cluster in the development environment.

## Purpose

This environment deployment manages:

* Terraform backend configuration
* AWS provider configuration
* Environment-specific variables
* State management
* Solution deployment execution

## Directory Structure

```text
existing-eks-cluster-with-eks-backup-plan/
├── backend.tf
├── provider.tf
├── versions.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
└── README.md
```

## Terraform Execution Location

Terraform commands should be executed from this directory.

## Usage

### Initialize Terraform

```bash
terraform init
```

### Validate Terraform

```bash
terraform validate
```

### Generate Execution Plan

```bash
terraform plan
```

### Apply Terraform Changes

```bash
terraform apply
```

## Example Deployment Path

```text
environments/dev/aws/existing-eks-cluster-with-eks-backup-plan
```

## Backend Configuration

This deployment uses:

* S3 backend
* DynamoDB state locking
* Remote Terraform state management

## Supported EKS Inputs

### Option 1 — Full EKS Cluster ARN

```hcl
eks_cluster_arn = "arn:aws:eks:ap-south-1:123456789012:cluster/dev-eks"
```

### Option 2 — Cluster Name + Region

```hcl
cluster_name   = "dev-eks"
cluster_region = "ap-south-1"
```

## Notes

* Either `eks_cluster_arn` OR both `cluster_name` and `cluster_region` must be provided.
* This deployment targets existing EKS clusters only.
* Environment deployments are responsible for Terraform state management.
* Separate state files should be maintained for each environment.
