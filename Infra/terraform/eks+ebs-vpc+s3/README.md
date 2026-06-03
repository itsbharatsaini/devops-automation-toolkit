# Deployment Guide

This guide explains the refactored infrastructure

---

## 🚀 Deployment Steps

### Prerequisites
```bash
# 1. AWS CLI configured
aws sts get-caller-identity

# 2. Terraform installed
terraform --version  # ≥ 1.6.0

# 3. Get your IAM ARN
aws iam get-user
# Copy the Arn (e.g., arn:aws:iam::123456789:user/alice)
```

### Step 1: Bootstrap Remote State (One-Time)

```bash
cd Infra/global

# Initialize with local state
terraform init

# Create S3 backend + DynamoDB lock
terraform apply

# ✅ Output:
# state_bucket_name = "my-company-terraform-state-xxxxx"
# state_lock_table_name = "terraform-state-lock"
```

**Save these values** - you'll need them for step 2.

---

### Step 2: Configure Dev Environment

```bash
cd ../environments/dev

# Edit terraform.tfvars
# Set your IAM user/role ARN
nano terraform.tfvars  # or use your editor
```

**Update:**
```hcl
environment         = "dev"
admin_principal_arn = "arn:aws:iam::123456789:user/alice"  # ← Your ARN
```

**Initialize Terraform:**
```bash
terraform init
```

**Review the plan:**
```bash
terraform plan -var-file="terraform.tfvars"
```

**Deploy:**
```bash
terraform apply -var-file="terraform.tfvars"
```




## ✅ Verification After Deployment

### Get Cluster Credentials
```bash
aws eks update-kubeconfig \
  --name dev-eks \
  --region us-east-1 \
  --alias dev-eks
```

### Verify Cluster
```bash
kubectl get nodes
# Output should show 1 node for dev

kubectl get svc -A
# Verify core services
```

### Check Terraform Outputs
```bash
cd environments/dev

terraform output cluster_name
# Output: dev-eks

terraform output cluster_endpoint
# Output: https://xxxxx.eks.us-east-1.amazonaws.com

terraform output velero_backup_bucket_name
# Output: velero-eks-backup-dev-xxxxx

terraform output velero_irsa_role_arn
# Output: arn:aws:iam::123456789:role/dev-velero-irsa
```

---

## 🛠️ Common Tasks

### List All Outputs
```bash
cd environments/dev
terraform output
```

### Check Resources
```bash
# Count resources
terraform state list | wc -l

# List specific resource
terraform state list | grep vpc
```

### Update Configuration
```bash
# Change node count (dev)
cd environments/dev
nano terraform.tfvars
# Edit node_instance_types or backup_retention_days

terraform plan
terraform apply
```

### Destroy Environment
```bash
cd environments/dev

terraform destroy -var-file="terraform.tfvars"
```

---

## Adding a New Environment

1. Copy `environments/dev/` → `environments/<new-env>/`
2. Change `environment = "<new-env>"` in `terraform.tfvars`
3. Update `backend.key` in `providers.tf` to a unique path
4. Set sizing and CIDRs in `terraform.tfvars`
5. Run `terraform init && terraform apply`