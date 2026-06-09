output "backup_plan_id" {
  description = "AWS Backup plan ID"
  value       = aws_backup_plan.eks_backup_plan.id
}

output "backup_plan_arn" {
  description = "AWS Backup plan ARN"
  value       = aws_backup_plan.eks_backup_plan.arn
}

output "backup_vault_name" {
  description = "AWS Backup vault name"
  value       = aws_backup_vault.eks_backup_vault.name
}

output "backup_selection_id" {
  description = "AWS Backup selection ID"
  value       = aws_backup_selection.eks_backup_selection.id
}