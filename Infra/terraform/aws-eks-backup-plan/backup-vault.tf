resource "aws_backup_vault" "eks" {
  name = "${var.backup_vault_name}-${var.environment}"

  tags = {
    Environment = var.environment
    Name        = "${var.backup_vault_name}-${var.environment}"
  }
}

resource "aws_backup_vault" "eks_dr" {
  count         = var.enable_dr_replication ? 1 : 0
  provider      = aws.dr
  name          = "${var.backup_vault_name}-${var.environment}-dr"
  force_destroy = true

  tags = {
    Environment = "${var.environment}-dr"
    Name        = "${var.backup_vault_name}-${var.environment}-dr"
  }
}
