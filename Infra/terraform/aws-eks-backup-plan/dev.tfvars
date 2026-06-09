environment = "dev"

cluster_name  = "dev-eks"
cluster_region = "us-west-1"

backup_retention_days = 30
backup_schedule       = "cron(0 * ? * * *)"

enable_dr_replication  = true
dr_region              = "us-east-1"
