# environments/staging/terraform.tfvars

# ── Environment Selection (REQUIRED) ───────────────────────────────────────────
environment = "staging"

# ── AWS Region Configuration ───────────────────────────────────────────────────
region = "us-east-1"

# ── Kubernetes Cluster Configuration ───────────────────────────────────────────
kubernetes_version  = "1.35"
admin_principal_arn = ""  # ⚠️ REQUIRED: Set to your IAM user/role ARN
allowed_public_cidrs = ["0.0.0.0/0"]

# ── Node Group Configuration ───────────────────────────────────────────────────
# Staging uses larger instances than dev
node_instance_types = ["t3.large"]

# ── VPC & Network Configuration ────────────────────────────────────────────────
# Staging uses different CIDR to avoid conflicts
vpc_cidr             = "10.20.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
private_subnet_cidrs = ["10.20.1.0/24", "10.20.2.0/24"]
public_subnet_cidrs  = ["10.20.101.0/24", "10.20.102.0/24"]

# ── Backup Configuration ───────────────────────────────────────────────────────
# Staging retains backups longer than dev
backup_retention_days = 60
