resource "aws_backup_plan" "backup_plan" {
  name = "${var.cluster_name}-backup-plan"

  rule {
    rule_name         = "${var.cluster_name}-daily-backup"
    target_vault_name = aws_backup_vault.backup_vault.name

    schedule = var.backup_schedule

    lifecycle {
      delete_after = var.backup_retention_days
    }

    dynamic "copy_action" {
      for_each = var.enable_dr_replication ? [1] : []
      content {
        destination_vault_arn = aws_backup_vault.backup_vault_dr[0].arn

        lifecycle {
          delete_after = var.backup_retention_days
        }
      }
    }
  }

  tags = {
    Environment = var.environment
    Name        = "${var.cluster_name}-backup-plan"
  }
}