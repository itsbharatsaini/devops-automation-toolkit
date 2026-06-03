# global/main.tf
# ------------------------------------------------------------
# Bootstrap: creates the S3 bucket + DynamoDB table used as
# the remote backend for ALL environments.
# Apply this ONCE before running any environment:
#
#   cd global
#   terraform init   # uses local state initially
#   terraform apply
#
# Then update providers.tf in each environment with the
# bucket name output below.
# ------------------------------------------------------------

resource "random_id" "state_bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-company-terraform-state-${random_id.state_bucket_suffix.hex}"

  tags = {
    Purpose   = "terraform-remote-state"
    ManagedBy = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Purpose   = "terraform-state-locking"
    ManagedBy = "terraform"
  }
}

output "state_bucket_name" {
  description = "Copy this bucket name into each environment's backend 's3.bucket' value"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_lock_table_name" {
  description = "DynamoDB table name for state locking"
  value       = aws_dynamodb_table.terraform_state_lock.name
}
