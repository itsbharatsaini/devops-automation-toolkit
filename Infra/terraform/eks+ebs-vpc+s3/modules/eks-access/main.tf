# modules/eks-access/main.tf
# ------------------------------------------------------------
# Grants an IAM principal cluster-admin access via the EKS
# Access Entries API (replaces aws-auth ConfigMap in EKS 1.29+)
# ------------------------------------------------------------

resource "aws_eks_access_entry" "admin" {
  cluster_name  = var.cluster_name
  principal_arn = var.admin_principal_arn
}

resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = var.cluster_name
  principal_arn = var.admin_principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.admin]
}
