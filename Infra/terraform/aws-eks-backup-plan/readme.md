# AWS EKS Backup Plan

**Overview**

This Terraform configuration creates AWS Backup resources for EKS clusters per environment. It supports optional cross-region replication of restore points for disaster recovery (DR), and now derives the EKS cluster ARN from `cluster_name` and `cluster_region` variables.

**Prerequisites**

- Terraform >= 1.5
- AWS credentials configured (env, profile, or instance role)
- Ensure the IAM role used by the backup selection has permissions to copy restore points across regions when DR is enabled

**Files**

- [variables.tf](variables.tf) — variables and DR flags
- [backup-plan.tf](backup-plan.tf) — backup plan with optional copy_action
- [backup-vault.tf](backup-vault.tf) — primary and optional DR vault
- [backup-selection.tf](backup-selection.tf) — resources to include in backups
- dev.tfvars, staging.tfvars, prod.tfvars — environment values

**Deploy (per environment)**

Initialize and apply using the environment `.tfvars` file:

```bash
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

Replace `dev.tfvars` with `staging.tfvars` or `prod.tfvars` as needed.

**Enable/Disable DR Replication**

Control DR with the `enable_dr_replication` and `dr_region` variables in each `.tfvars`:

```hcl
enable_dr_replication = true
dr_region = "us-east-1"
```

When enabled, Terraform creates a DR backup vault in the DR region and the backup plan adds a `copy_action` to replicate restore points.

**Destroy (delete everything including recovery points)**

To remove a whole environment and its recovery points in one go, run:

```bash
terraform destroy -var-file=dev.tfvars
```

Notes:
- `aws_backup_vault` is created with `force_destroy = true` so recovery points are removed when the vault is destroyed.
- Ensure IAM permissions allow deletion and cross-region copy if DR is used.

**Restore Steps (manual)**

1. Identify the recovery point in the backup vault (or DR vault).
2. Use the AWS Backup console or API to restore the recovery point to the target cluster.

**Tips & Caveats**

- Verify the IAM role used in `backup-selection.tf` includes `backup:StartCopyJob` and `backup:DeleteRecoveryPoint` for cross-region operations.
- Test DR replication in a non-production environment before enabling in prod.

