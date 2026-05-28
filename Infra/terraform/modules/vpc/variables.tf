# modules/vpc/variables.tf

variable "vpc_name" {
  description = "Name tag applied to the VPC and all related resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (e.g. '10.0.0.0/16')"
  type        = string
}

variable "availability_zones" {
  description = "List of AZs to deploy subnets into (e.g. ['us-east-1a', 'us-east-1b'])"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets — one per AZ"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets — one per AZ"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS cluster name used for subnet tagging (required by the AWS load balancer controller)"
  type        = string
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway (true = cheaper for dev; false = HA for prod)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags applied to every resource in this module"
  type        = map(string)
  default     = {}
}
