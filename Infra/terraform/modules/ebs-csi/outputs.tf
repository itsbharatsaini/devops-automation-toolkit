# modules/ebs-csi/outputs.tf

output "irsa_role_arn" {
  description = "ARN of the IRSA IAM role for the EBS CSI controller"
  value       = module.ebs_csi_irsa_role.iam_role_arn
}
