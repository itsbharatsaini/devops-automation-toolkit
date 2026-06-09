variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod, etc.)"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name to back up"
}

variable "cluster_region" {
  type        = string
  description = "AWS region where the EKS cluster is running"
}


variable "account_id" {
  type        = string
  default     = ""
  description = "AWS account ID for the EKS cluster ARN. If empty, Terraform uses the current caller identity."
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


############
data "aws_caller_identity" "current" {}

locals {
  aws_account_id = var.account_id != "" ? var.account_id : data.aws_caller_identity.current.account_id
  cluster_arn    = "arn:aws:eks:${var.cluster_region}:${local.aws_account_id}:cluster/${var.cluster_name}"

}