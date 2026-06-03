resource "aws_backup_plan" "eks" {
  name = "${var.backup_plan_name}-${var.environment}"

  rule {
    rule_name         = "daily-backup-${var.environment}"
    target_vault_name = aws_backup_vault.eks.name

    schedule = var.backup_schedule

    lifecycle {
      delete_after = var.backup_retention_days
    }

    dynamic "copy_action" {
      for_each = var.enable_dr_replication ? [1] : []
      content {
        destination_vault_arn = aws_backup_vault.eks_dr[0].arn

        lifecycle {
          delete_after = var.backup_retention_days
        }
      }
    }
  }

  tags = {
    Environment = var.environment
    Name        = "${var.backup_plan_name}-${var.environment}"
  }
}