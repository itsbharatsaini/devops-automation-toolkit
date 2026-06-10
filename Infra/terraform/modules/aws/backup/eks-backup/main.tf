data "aws_caller_identity" "current" {}

locals {
  aws_account_id = var.account_id != "" ? var.account_id : data.aws_caller_identity.current.account_id

  generated_cluster_arn = (
    var.cluster_name != "" ?
    "arn:aws:eks:${var.cluster_region}:${local.aws_account_id}:cluster/${var.cluster_name}" :
    null
  )

  final_cluster_arn = (
    var.eks_cluster_arn != "" ?
    var.eks_cluster_arn :
    local.generated_cluster_arn
  )
}

resource "aws_backup_vault" "eks_backup_vault" {
  name = "${var.environment}-eks-backup-vault"

  tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

resource "aws_backup_vault" "eks_backup_vault_dr" {
  count = var.enable_dr_replication ? 1 : 0
  provider = aws.dr
  name = "${var.environment}-eks-backup-vault-dr"

  tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      DR          = "true"
    }
  )
}

resource "aws_backup_plan" "eks_backup_plan" {
  name = "${var.environment}-eks-backup-plan"

  rule {
    rule_name         = "${var.environment}-daily-eks-backup"
    target_vault_name = aws_backup_vault.eks_backup_vault.name
    schedule          = var.backup_schedule

    lifecycle {
      delete_after = var.delete_after_days
    }

    dynamic "copy_action" {
      for_each = var.enable_dr_replication ? [1] : []

      content {
        destination_vault_arn = aws_backup_vault.eks_backup_vault_dr[0].arn

        lifecycle {
          delete_after = var.delete_after_days
        }
      }
    }


    recovery_point_tags = merge(
      var.tags,
      {
        Project     = var.project_name
        Environment = var.environment
        ManagedBy   = "Terraform"
      }
    )
  }

  tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

resource "aws_backup_selection" "eks_backup_selection" {
  name         = "${var.environment}-eks-backup-selection"
  iam_role_arn = var.backup_role_arn
  plan_id      = aws_backup_plan.eks_backup_plan.id

  resources = [
    local.final_cluster_arn
  ]

  lifecycle {
    precondition {
      condition = (
        var.eks_cluster_arn != ""
        ||
        (
          var.cluster_name != ""
          &&
          var.cluster_region != ""
        )
      )

      error_message = "Either eks_cluster_arn must be provided OR both cluster_name and cluster_region must be provided."
    }
  }

}