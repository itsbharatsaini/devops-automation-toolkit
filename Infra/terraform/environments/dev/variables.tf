# environments/dev/variables.tf

# ────────────────────────────────────────────────────────────────────────────────
# HYBRID APPROACH: Single source of truth for environment, derived values in locals
# ────────────────────────────────────────────────────────────────────────────────

# ── REQUIRED: Environment Selection ────────────────────────────────────────────

variable "environment" {
  description = "Environment name (dev/staging/prod) — single source of truth"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

# ── AWS Region & Cloud ─────────────────────────────────────────────────────────

variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

# ── Kubernetes Cluster Configuration ───────────────────────────────────────────

variable "kubernetes_version" {
  description = "EKS Kubernetes version (e.g. '1.35')"
  type        = string
  default     = "1.35"
}

variable "admin_principal_arn" {
  description = "ARN of the IAM user or role to grant EKS cluster-admin access"
  type        = string
  sensitive   = true
}

variable "allowed_public_cidrs" {
  description = "CIDR blocks allowed to reach the EKS public API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# ── Node Group Configuration ───────────────────────────────────────────────────

variable "node_instance_types" {
  description = "EC2 instance types for the EKS managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

# ── VPC & Network Configuration ────────────────────────────────────────────────

variable "vpc_cidr" {
  description = "CIDR block for the VPC (e.g. 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones to deploy subnets into (e.g. [us-east-1a, us-east-1b])"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks — one per AZ"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks — one per AZ"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

# ── Backup & Disaster Recovery Configuration ───────────────────────────────────

variable "backup_retention_days" {
  description = "Number of days to retain Velero backups in S3 (0 = infinite)"
  type        = number
  default     = 30
}
