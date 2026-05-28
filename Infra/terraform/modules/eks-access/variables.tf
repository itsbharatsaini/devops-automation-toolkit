# modules/eks-access/variables.tf

variable "cluster_name" {
  description = "Name of the EKS cluster to grant access to"
  type        = string
}

variable "admin_principal_arn" {
  description = "ARN of the IAM user or role to grant cluster-admin access"
  type        = string
}
