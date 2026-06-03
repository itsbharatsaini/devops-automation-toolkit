environment = "prod"
region      = "us-west-1"

eks_clusters = {
  prod = {
    cluster_arn = "arn:aws:eks:us-west-1:6XXXXXXXXXX9:cluster/prod-eks"
    region      = "us-west-1"
  }
}

backup_retention_days = 90
backup_schedule       = "cron(0 2 ? * * *)"
enable_dr_replication  = true
dr_region              = "us-east-1"
