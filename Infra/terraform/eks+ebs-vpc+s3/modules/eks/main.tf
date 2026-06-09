# modules/eks/main.tf
# ------------------------------------------------------------
# EKS cluster with managed node groups.
# IRSA is enabled so child modules can attach IAM roles
# to service accounts without node-level IAM permissions.
# ------------------------------------------------------------

module "eks" {
  
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.cluster_name}"
  cluster_version = var.kubernetes_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  enable_irsa = true

  # Allow both public kubectl access and in-cluster private API calls
  cluster_endpoint_public_access       = var.enable_public_endpoint
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = var.allowed_public_cidrs

  eks_managed_node_groups = {
    default = {
      instance_types = var.node_instance_types
      ami_type       = var.node_ami_type
      desired_size   = var.node_desired_size
      min_size       = var.node_min_size
      max_size       = var.node_max_size

      labels = {
        role        = "default"
        environment = var.environment
      }
    }
  }

  tags = var.tags
}
