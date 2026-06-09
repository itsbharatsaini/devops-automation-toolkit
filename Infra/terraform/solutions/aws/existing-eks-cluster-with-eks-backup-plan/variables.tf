variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "eks_cluster_arn" {
  description = "Existing EKS cluster ARN"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Existing EKS cluster name"
  type        = string
  default     = ""
}

variable "cluster_region" {
  description = "AWS region where EKS cluster exists"
  type        = string
  default     = ""
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
  default     = ""
}

variable "backup_role_arn" {
  description = "AWS Backup IAM role ARN"
  type        = string
  default = ""
}

variable "backup_schedule" {
  description = "AWS Backup schedule"
  type        = string
  default     = "cron(0 1 * * ? *)"
}

variable "delete_after_days" {
  description = "Backup retention in days"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}

variable "enable_dr_replication" {
  type = bool 
  default = false 
  }

variable "dr_region" { 
  type = string 
  default = "" 
  }