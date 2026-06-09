resource "aws_backup_selection" "backup_selection" {
  name         = "${var.cluster_name}-backup-selection"
  plan_id      = aws_backup_plan.backup_plan.id
  iam_role_arn = aws_iam_role.backup_role.arn

  resources = [
    local.cluster_arn
  ]
}