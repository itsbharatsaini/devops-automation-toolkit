aws_region = "us-west-2"

environment  = "dev"
project_name = "Testing_backuplan"

# Option 1 - Full EKS Cluster ARN
eks_cluster_arn = ""

# Option 2 - Cluster Name + Region
cluster_name   = "dev-eks"
cluster_region = "us-west-2"

# Optional - Required only for cross-account setup
account_id = ""

backup_role_arn = "arn:aws:iam::123456789012:role/AWSBackupDefaultServiceRole"

backup_schedule   = "cron(0 1 * * ? *)"
delete_after_days = 30

tags = {
  Owner       = "DevOps"
  Team        = "Platform"
  ManagedBy   = "Terraform"
}

enable_dr_replication = true 
dr_region             = "us-east-2"