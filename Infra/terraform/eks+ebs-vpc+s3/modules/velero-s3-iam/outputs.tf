# modules/velero-iam/outputs.tf

output "irsa_role_arn" {
  description = "ARN of the IRSA role for Velero to assume"
  value       = module.velero_irsa_role.iam_role_arn
}

output "iam_policy_arn" {
  description = "ARN of the Velero IAM policy"
  value       = aws_iam_policy.velero.arn
}
