# environments/dev/terraform.tfvars

# ── Environment Selection (REQUIRED) ───────────────────────────────────────────
environment = "dev"

# ── AWS Region Configuration ───────────────────────────────────────────────────
region = "us-east-1"

# ── Kubernetes Cluster Configuration ───────────────────────────────────────────
kubernetes_version  = "1.35"
admin_principal_arn = ""  # ⚠️ REQUIRED: Set to your IAM user/role ARN
allowed_public_cidrs = ["0.0.0.0/0"]

# ── Node Group Configuration ───────────────────────────────────────────────────
node_instance_types = ["t3.medium"]

# ── VPC & Network Configuration ────────────────────────────────────────────────
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]

# ── Backup Configuration ───────────────────────────────────────────────────────
backup_retention_days = 30
