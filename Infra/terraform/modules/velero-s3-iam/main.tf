# modules/velero-s3-iam/main.tf
# ------------------------------------------------------------
# Creates the Velero IAM policy and an IRSA role so the
# Velero pod can access S3 and EC2 without node-level IAM.
# ------------------------------------------------------------

resource "aws_iam_policy" "velero" {
  name        = "${var.name_prefix}-velero-policy"
  description = "Grants Velero permissions to snapshot EBS volumes and read/write the backup S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "VeleroEC2Snapshots"
        Effect = "Allow"
        Action = [
          "ec2:DescribeVolumes",
          "ec2:DescribeSnapshots",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
        ]
        Resource = "*"
      },
      {
        Sid    = "VeleroS3Objects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts",
        ]
        Resource = "${var.backup_bucket_arn}/*"
      },
      {
        Sid      = "VeleroS3ListBucket"
        Effect   = "Allow"
        Action   = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
          ]
        Resource = var.backup_bucket_arn
      },
    ]
  })

  tags = var.tags
}

# IRSA role — lets the Velero service account assume this role
# without needing node-level IAM permissions.
module "velero_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.name_prefix}-velero-irsa"

  role_policy_arns = {
    velero = aws_iam_policy.velero.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.velero_namespace}:${var.velero_service_account_name}"]
    }
  }

  tags = var.tags
}
