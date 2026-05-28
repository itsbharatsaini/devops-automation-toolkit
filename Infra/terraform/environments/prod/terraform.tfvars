# environments/prod/terraform.tfvars

# ── Environment Selection (REQUIRED) ───────────────────────────────────────────
environment = "prod"

# ── AWS Region Configuration ───────────────────────────────────────────────────
region = "us-east-1"

# ── Kubernetes Cluster Configuration ───────────────────────────────────────────
kubernetes_version  = "1.35"
admin_principal_arn = ""  # ⚠️ REQUIRED: Set to your IAM user/role ARN
# Prod: restrict to specific IPs (VPN, bastion, etc.)
allowed_public_cidrs = ["0.0.0.0/0"]  # TODO: Restrict to your network

# ── Node Group Configuration ───────────────────────────────────────────────────
# Prod uses production-grade instances
node_instance_types = ["m5.large"]

# ── VPC & Network Configuration ────────────────────────────────────────────────
# Prod uses different CIDR to avoid conflicts
vpc_cidr             = "10.10.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
private_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]
public_subnet_cidrs  = ["10.10.101.0/24", "10.10.102.0/24"]

# ── Backup Configuration ───────────────────────────────────────────────────────
# Prod retains backups longest
backup_retention_days = 90
