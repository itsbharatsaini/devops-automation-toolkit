resource "aws_backup_selection" "eks" {
  name         = "eks-selection-${var.environment}"
  plan_id      = aws_backup_plan.eks.id
  iam_role_arn = aws_iam_role.backup_role.arn

  resources = [
    var.eks_clusters[var.environment].cluster_arn
  ]

  tags = {
    Environment = var.environment
  }
}