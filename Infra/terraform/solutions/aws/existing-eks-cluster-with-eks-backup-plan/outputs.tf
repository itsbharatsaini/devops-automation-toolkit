output "backup_plan_id" {
  description = "AWS Backup plan ID"

  value = module.existing_eks_cluster_with_eks_backup_plan.backup_plan_id
}

output "backup_plan_arn" {
  description = "AWS Backup plan ARN"

  value = module.existing_eks_cluster_with_eks_backup_plan.backup_plan_arn
}

output "backup_vault_name" {
  description = "AWS Backup vault name"

  value = module.existing_eks_cluster_with_eks_backup_plan.backup_vault_name
}

output "backup_selection_id" {
  description = "AWS Backup selection ID"

  value = module.existing_eks_cluster_with_eks_backup_plan.backup_selection_id
}