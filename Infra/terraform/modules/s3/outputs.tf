# modules/velero-s3/outputs.tf

output "bucket_name" {
  description = "Name of the Velero backup S3 bucket"
  value       = aws_s3_bucket.velero_backup.bucket
}

output "bucket_arn" {
  description = "ARN of the Velero backup S3 bucket"
  value       = aws_s3_bucket.velero_backup.arn
}
