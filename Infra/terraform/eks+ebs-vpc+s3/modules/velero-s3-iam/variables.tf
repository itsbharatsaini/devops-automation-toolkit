# modules/velero-iam/variables.tf

variable "name_prefix" {
  description = "Prefix applied to IAM policy and role names (e.g. 'prod-primary')"
  type        = string
}

variable "backup_bucket_arn" {
  description = "ARN of the S3 bucket used for Velero backups"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider (for IRSA trust policy)"
  type        = string
}

variable "velero_namespace" {
  description = "Kubernetes namespace where Velero is installed"
  type        = string
  default     = "velero"
}

variable "velero_service_account_name" {
  description = "Kubernetes service account name used by Velero"
  type        = string
  default     = "velero-server"
}

variable "tags" {
  description = "Map of tags applied to every resource in this module"
  type        = map(string)
  default     = {}
}
