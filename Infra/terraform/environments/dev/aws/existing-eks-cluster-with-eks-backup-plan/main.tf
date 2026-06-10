
module "existing_eks_cluster_with_eks_backup_plan" {
  source = "../../../../solutions/aws/existing-eks-cluster-with-eks-backup-plan"

  providers = { 
    aws = aws 
    aws.dr = aws.dr 
    }

  environment  = var.environment
  project_name = var.project_name

  eks_cluster_arn = var.eks_cluster_arn

  cluster_name   = var.cluster_name
  cluster_region = var.cluster_region
  account_id     = var.account_id

#  backup_role_arn = var.backup_role_arn

  backup_schedule   = var.backup_schedule
  delete_after_days = var.delete_after_days

  tags = var.tags

  enable_dr_replication = var.enable_dr_replication
  dr_region             = var.dr_region

}