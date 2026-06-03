variable "region" {
  type        = string
  default     = "us-west-1"
  description = "AWS region for the backup resources"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod"
  }
}

variable "eks_clusters" {
  type = map(object({
    cluster_arn = string
    region      = string
  }))
  description = "Map of EKS clusters by environment"
}

variable "backup_vault_name" {
  type        = string
  default     = "eks-backup-vault"
  description = "Base name for the backup vault (environment will be appended)"
}

variable "backup_plan_name" {
  type        = string
  default     = "eks-backup-plan"
  description = "Base name for the backup plan (environment will be appended)"
}

variable "backup_retention_days" {
  type        = number
  default     = 30
  description = "Number of days to retain backups"
}

variable "backup_schedule" {
  type        = string
  default     = "cron(0 * ? * * *)"
  description = "Backup schedule in cron format (daily at midnight UTC by default)"
}

variable "enable_dr_replication" {
  type        = bool
  default     = false
  description = "Enable replication (copy) of restore points to a DR region"
}

variable "dr_region" {
  type        = string
  default     = "us-east-1"
  description = "DR region to replicate restore points to"
}