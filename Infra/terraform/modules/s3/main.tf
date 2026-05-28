# modules/velero-s3/main.tf
# ------------------------------------------------------------
# Creates the S3 bucket used by Velero for cluster backups.
# The bucket name is randomised to avoid global collisions.
# Versioning is enabled so accidental deletes can be recovered.
# ------------------------------------------------------------

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "velero_backup" {
  bucket = "${var.bucket_name_prefix}-${random_id.bucket_suffix.hex}"

  tags = merge(var.tags, {
    Purpose = "velero-backup"
  })
}

resource "aws_s3_bucket_versioning" "velero_backup" {
  bucket = aws_s3_bucket.velero_backup.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "velero_backup" {
  bucket = aws_s3_bucket.velero_backup.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "velero_backup" {
  bucket = aws_s3_bucket.velero_backup.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "velero_backup" {
  count  = var.backup_retention_days > 0 ? 1 : 0
  bucket = aws_s3_bucket.velero_backup.id

  rule {
    id     = "expire-old-backups"
    status = "Enabled"

    expiration {
      days = var.backup_retention_days
    }
  }
}
