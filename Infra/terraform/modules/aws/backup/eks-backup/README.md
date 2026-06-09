# EKS Backup Terraform Module

This Terraform module creates and manages an AWS Backup configuration for an Amazon EKS cluster.

## Features

* Creates AWS Backup Vault
* Creates AWS Backup Plan
* Creates AWS Backup Selection for EKS cluster
* Supports:

  * Existing EKS cluster ARN
  * EKS cluster name + region
  * Cross-account EKS backup configuration
* Standardized tagging support

## Supported Input Methods

### Option 1 — Full EKS Cluster ARN

```hcl
eks_cluster_arn = "arn:aws:eks:ap-south-1:123456789012:cluster/dev-eks"
```

### Option 2 — Cluster Name + Region

```hcl
cluster_name   = "dev-eks"
cluster_region = "ap-south-1"
```

### Option 3 — Cross Account

```hcl
cluster_name   = "prod-eks"
cluster_region = "us-east-1"
account_id     = "123456789012"
```

## Module Structure

```text
eks-backup/
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
└── README.md
```

## Usage Example

```hcl
module "eks_backup" {
  source = "../../../../modules/aws/backup/eks-backup"

  environment  = "dev"
  project_name = "platform"

  cluster_name   = "dev-eks"
  cluster_region = "ap-south-1"

  backup_role_arn = "arn:aws:iam::123456789012:role/AWSBackupDefaultServiceRole"

  backup_schedule   = "cron(0 1 * * ? *)"
  delete_after_days = 30

  tags = {
    Team = "Platform"
  }
}
```

## Required Variables

| Variable        | Description             |
| --------------- | ----------------------- |
| environment     | Environment name        |
| project_name    | Project name            |
| backup_role_arn | AWS Backup IAM role ARN |

## Optional Variables

| Variable          | Description               |
| ----------------- | ------------------------- |
| eks_cluster_arn   | Existing EKS cluster ARN  |
| cluster_name      | Existing EKS cluster name |
| cluster_region    | AWS region of EKS cluster |
| account_id        | AWS account ID            |
| backup_schedule   | AWS Backup cron schedule  |
| delete_after_days | Backup retention days     |
| tags              | Additional resource tags  |

## Outputs

| Output              | Description             |
| ------------------- | ----------------------- |
| backup_plan_id      | AWS Backup plan ID      |
| backup_plan_arn     | AWS Backup plan ARN     |
| backup_vault_name   | AWS Backup vault name   |
| backup_selection_id | AWS Backup selection ID |

## Notes

* Either `eks_cluster_arn` OR both `cluster_name` and `cluster_region` must be provided.
* Backend configuration should NOT be added inside modules.
* Provider configuration should be managed from environment deployments.
