# environments/dev/main.tf

locals {
  env = var.environment

  # Automatically derive cluster name
  cluster_name = "${local.env}-eks"

  # Automatically derive VPC name
  vpc_name = "${local.env}-vpc"

  # Common tags applied to all resources
  common_tags = {
    Environment = local.env
    Project     = "Project_Name"
    ManagedBy   = "terraform"
  }
}

# ── VPC ────────────────────────────────────────────────────────────────────────

module "vpc" {
  source = "../../modules/vpc"

  vpc_name             = local.vpc_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  cluster_name         = local.cluster_name
  single_nat_gateway   = true   # single NAT saves cost in dev
  tags                 = local.common_tags
}

# ── EKS Cluster ────────────────────────────────────────────────────────────────

module "eks" {
  source = "../../modules/eks"

  cluster_name        = local.cluster_name
  kubernetes_version  = var.kubernetes_version
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  environment         = local.env
  node_instance_types = var.node_instance_types
  node_desired_size   = 1
  node_min_size       = 1
  node_max_size       = 2
  tags                = local.common_tags
}

# ── EBS CSI Driver ─────────────────────────────────────────────────────────────

module "ebs_csi" {
  source = "../../modules/ebs-csi"

  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  tags              = local.common_tags
}

# ── EKS Admin Access ───────────────────────────────────────────────────────────

module "eks_access" {
  source = "../../modules/eks-access"

  cluster_name        = module.eks.cluster_name
  admin_principal_arn = var.admin_principal_arn
}

# ── Velero S3 Backup Bucket ────────────────────────────────────────────────────

module "s3" {
  source = "../../modules/s3"

  bucket_name_prefix    = "velero-eks-backup-${local.env}"
  backup_retention_days = var.backup_retention_days
  tags                  = local.common_tags
}

# ── Velero IAM + IRSA ──────────────────────────────────────────────────────────

module "velero_iam" {
  source = "../../modules/velero-s3-iam"

  name_prefix       = local.env
  backup_bucket_arn = module.s3.bucket_arn
  oidc_provider_arn = module.eks.oidc_provider_arn
  tags              = local.common_tags
}
