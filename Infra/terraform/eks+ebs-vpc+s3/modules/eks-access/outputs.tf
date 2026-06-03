# modules/eks-access/outputs.tf

output "access_entry_id" {
  description = "ID of the EKS access entry"
  value       = aws_eks_access_entry.admin.id
}
