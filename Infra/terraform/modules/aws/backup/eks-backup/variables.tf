variable "environment" {
  type = string
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
  type    = string
  default = "cron(0 1 * * ? *)"
}

variable "delete_after_days" {
  type    = number
  default = 30
}

variable "project_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "enable_dr_replication" {
  description = "Enable cross-region DR backup replication"
  type        = bool
  default     = false
}

variable "dr_region" {
  description = "Disaster recovery AWS region"
  type        = string
  default     = ""
}


