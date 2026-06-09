terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "dev/aws/existing-eks-cluster-with-eks-backup-plan/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
