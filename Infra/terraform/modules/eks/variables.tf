# modules/eks/variables.tf

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster (e.g. '1.30')"
  type        = string
  default     = "1.30"
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS node groups"
  type        = list(string)
}

variable "enable_public_endpoint" {
  description = "Whether to enable public access to the EKS API server endpoint"
  type        = bool
  default     = true
}

variable "allowed_public_cidrs" {
  description = "List of CIDRs allowed to reach the public API endpoint. Empty = 0.0.0.0/0"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_instance_types" {
  description = "EC2 instance types for the default managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_ami_type" {
  description = "AMI type for managed nodes (AL2023_x86_64_STANDARD, AL2_x86_64, etc.)"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "node_desired_size" {
  description = "Desired number of nodes in the default node group"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of nodes in the default node group"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of nodes in the default node group"
  type        = number
  default     = 4
}

variable "environment" {
  description = "Environment label applied to node group labels and tags (dev/staging/prod)"
  type        = string
}

variable "tags" {
  description = "Map of tags applied to every resource in this module"
  type        = map(string)
  default     = {}
}
