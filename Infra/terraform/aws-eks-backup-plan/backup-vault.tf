resource "aws_backup_vault" "backup_vault" {
  name = "${var.cluster_name}-backup-vault"

  tags = {
    Environment = var.environment
    Name        = "${var.cluster_name}-backup-vault"
  }
}

resource "aws_backup_vault" "backup_vault_dr" {
  count         = var.enable_dr_replication ? 1 : 0
  provider      = aws.dr
  name          = "${var.cluster_name}-backup-vault-dr"
  force_destroy = true

  tags = {
    Environment = "${var.environment}-dr"
    Name        = "${var.cluster_name}-backup-vault-dr"
  }
}
