# modules/ebs-csi/variables.tf

variable "cluster_name" {
  description = "EKS cluster name — used to name the IRSA role"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider for the EKS cluster (from the eks module output)"
  type        = string
}

variable "tags" {
  description = "Map of tags applied to every resource in this module"
  type        = map(string)
  default     = {}
}
