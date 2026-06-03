# AWS CLI Multi-Profile Management for Windows, WSL, Terraform, and Amazon EKS

This guide explains how to manage multiple AWS accounts using AWS CLI profiles on Windows, PowerShell, Command Prompt (CMD), WSL2, Terraform, and Amazon EKS.

This approach eliminates the need to continuously run `aws configure` or overwrite the default profile when switching between environments.

---

# Overview

Example AWS Accounts:

| Environment | AWS Profile    |
| ----------- | -------------- |
| Development | `dev-user`     |
| Test        | `test-user`    |
| Staging     | `staging-user` |
| Production  | `prod-user`    |

Instead of replacing credentials repeatedly:

```text
❌ aws configure
❌ overwrite default profile
❌ update credentials manually
```

Use named profiles:

```text
✓ dev-user
✓ test-user
✓ staging-user
✓ prod-user
```

---

# AWS Configuration Files

Windows:

```text
C:\Users\<username>\.aws\config
C:\Users\<username>\.aws\credentials
```

WSL:

```text
~/.aws/config
~/.aws/credentials
```

---

# Configure Multiple Profiles

## Create Credentials

File:

```text
C:\Users\bharat\.aws\credentials
```

Example:

```ini
[dev-user]
aws_access_key_id=XXXXXXXXXXXX
aws_secret_access_key=XXXXXXXXXXXX

[test-user]
aws_access_key_id=XXXXXXXXXXXX
aws_secret_access_key=XXXXXXXXXXXX

[prod-user]
aws_access_key_id=XXXXXXXXXXXX
aws_secret_access_key=XXXXXXXXXXXX
```

---

## Create Config File

File:

```text
C:\Users\bharat\.aws\config
```

Example:

```ini
[profile dev-user]
region=us-east-2
output=json

[profile test-user]
region=us-west-2
output=json

[profile prod-user]
region=ap-southeast-2
output=json
```

---

# Verify Profiles

List profiles:

```bash
aws configure list-profiles
```

Example:

```text
dev-user
test-user
prod-user
```

---

# Using Profiles with AWS CLI

## Single Command

```bash
aws sts get-caller-identity --profile dev-user
```

Example:

```bash
aws s3 ls --profile prod-user
```

---

# PowerShell Usage

Temporary profile:

```powershell
$env:AWS_PROFILE="dev-user"
```

Verify:

```powershell
aws sts get-caller-identity
```

Clear:

```powershell
Remove-Item Env:AWS_PROFILE
```

---

# Command Prompt (CMD) Usage

Temporary profile:

```cmd
set AWS_PROFILE=dev-user
```

Verify:

```cmd
aws sts get-caller-identity
```

Clear:

```cmd
set AWS_PROFILE=
```

---

# WSL/Linux Usage

Temporary profile:

```bash
export AWS_PROFILE=dev-user
```

Verify:

```bash
aws sts get-caller-identity
```

Clear:

```bash
unset AWS_PROFILE
```

---

# Terraform Usage

## Option 1 - Environment Variable

PowerShell:

```powershell
$env:AWS_PROFILE="dev-user"
terraform plan
```

WSL:

```bash
export AWS_PROFILE=dev-user

terraform plan
```

Terraform automatically uses the selected profile.

---

## Option 2 - Provider Profile

```hcl
provider "aws" {
  profile = "dev-user"
  region  = "us-east-2"
}
```

Example:

```bash
terraform plan
terraform apply
terraform destroy
```

No additional profile flags required.

---

# Amazon EKS Multi-Profile Management

---

## Generate kubeconfig

Development Cluster:

```bash
aws eks update-kubeconfig \
  --region us-east-2 \
  --name dev-eks \
  --profile dev-user
```

Production Cluster:

```bash
aws eks update-kubeconfig \
  --region ap-southeast-2 \
  --name prod-eks \
  --profile prod-user
```

This creates separate EKS contexts inside kubeconfig.

---

# Verify Contexts

```bash
kubectl config get-contexts
```

Example:

```text
CURRENT   NAME
*         dev-eks
          prod-eks
```

---

# Switch Kubernetes Contexts

Development:

```bash
kubectl config use-context dev-eks
```

Production:

```bash
kubectl config use-context prod-eks
```

---

# Important: kubectl Does NOT Support --profile

Incorrect:

```bash
kubectl get pods --profile dev-user
```

Result:

```text
error: unknown flag: --profile
```

Reason:

`kubectl` does not understand AWS credentials.

AWS authentication is handled through:

```text
AWS CLI
↓
aws eks get-token
↓
kubectl
```

---

# Run kubectl Using a Specific AWS Profile

PowerShell:

```powershell
$env:AWS_PROFILE="dev-user"

kubectl get nodes
```

CMD:

```cmd
set AWS_PROFILE=dev-user

kubectl get nodes
```

WSL:

```bash
export AWS_PROFILE=dev-user

kubectl get nodes
```

---

# Verify Active AWS Identity

Always verify before performing changes:

```bash
aws sts get-caller-identity
```

Example:

```json
{
  "Account": "123456789012",
  "Arn": "arn:aws:iam::123456789012:user/dev-user"
}
```

---

# Recommended Workflow

## Development

```bash
export AWS_PROFILE=dev-user

aws sts get-caller-identity

kubectl config use-context dev-eks

kubectl get nodes
```

---

## Production

```bash
export AWS_PROFILE=prod-user

aws sts get-caller-identity

kubectl config use-context prod-eks

kubectl get nodes
```

---

# Troubleshooting

## Profile Not Found

```text
The config profile (dev-user) could not be found
```

Verify:

```bash
aws configure list-profiles
```

---

## Access Denied

```text
AccessDenied
```

Verify:

```bash
aws sts get-caller-identity
```

Confirm the correct profile is selected.

---

## kubectl Authentication Failure

Verify:

```bash
aws sts get-caller-identity

kubectl config current-context
```

Ensure:

* Correct AWS profile is active.
* Correct EKS context is selected.
* Cluster exists in the target AWS account.

---

# Best Practices

* Never use the default profile for production.
* Create dedicated profiles per account.
* Use explicit profile names.
* Verify identity before Terraform Apply or Destroy.
* Verify identity before kubectl operations.
* Store credentials in AWS SSO or IAM roles when possible.

---

# Summary

AWS CLI profiles allow you to manage multiple AWS accounts without repeatedly running `aws configure`. The same profiles can be reused across AWS CLI, Terraform, Amazon EKS, kubectl, Helm, Velero, and other cloud-native tooling. By combining AWS profiles with Kubernetes contexts, you can safely manage multiple clusters and AWS accounts from a single workstation.
