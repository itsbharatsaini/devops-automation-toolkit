# modules/velero-s3/variables.tf

variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name — a random hex suffix is appended (e.g. 'prod-velero-backup')"
  type        = string
}

variable "backup_retention_days" {
  description = "Number of days to retain backup objects. Set to 0 to disable lifecycle expiry."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Map of tags applied to every resource in this module"
  type        = map(string)
  default     = {}
}
