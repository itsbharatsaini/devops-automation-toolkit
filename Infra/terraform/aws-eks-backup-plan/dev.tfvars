environment = "dev"
region      = "us-west-1"

eks_clusters = {
  dev = {
    cluster_arn = "arn:aws:eks:us-west-1:6XXXXXXXXXX9:cluster/dev-eks"
    region      = "us-west-1"
  }
}

backup_retention_days = 30
backup_schedule       = "cron(0 * ? * * *)"

enable_dr_replication  = true
dr_region              = "us-east-1"
