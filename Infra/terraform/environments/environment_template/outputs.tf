# environments/dev/outputs.tf

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS API server endpoint"
  value       = module.eks.cluster_endpoint
}

output "velero_backup_bucket_name" {
  description = "S3 bucket used for Velero backups"
  value       = module.s3.bucket_name
}

output "velero_irsa_role_arn" {
  description = "IRSA role ARN for the Velero service account"
  value       = module.velero_iam.irsa_role_arn
}
