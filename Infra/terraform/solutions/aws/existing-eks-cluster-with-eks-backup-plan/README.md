# Existing EKS Cluster With EKS Backup Plan Solution

This Terraform solution configures AWS Backup for an existing Amazon EKS cluster.

## Purpose

This solution acts as a reusable deployment layer that combines:

* EKS backup module
* backup configuration
* tagging standards
* retention configuration

This solution does NOT:

* create an EKS cluster
* manage Terraform backend
* manage provider configuration

## Solution Structure

```text
existing-eks-cluster-with-eks-backup-plan/
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

## Features

* Existing EKS cluster backup setup
* AWS Backup Vault creation
* AWS Backup Plan creation
* AWS Backup Selection configuration
* Cross-account support
* Environment-based deployment support

## Usage Example

```hcl
module "existing_eks_cluster_with_eks_backup_plan" {
  source = "../../../../solutions/aws/existing-eks-cluster-with-eks-backup-plan"

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
| cluster_region    | AWS region                |
| account_id        | AWS account ID            |
| backup_schedule   | Backup schedule           |
| delete_after_days | Backup retention days     |
| tags              | Additional tags           |

## Outputs

| Output              | Description             |
| ------------------- | ----------------------- |
| backup_plan_id      | AWS Backup plan ID      |
| backup_plan_arn     | AWS Backup plan ARN     |
| backup_vault_name   | AWS Backup vault name   |
| backup_selection_id | AWS Backup selection ID |

## Notes

* This solution should be consumed from environment deployments.
* Terraform apply should NOT run directly from the solution directory.
