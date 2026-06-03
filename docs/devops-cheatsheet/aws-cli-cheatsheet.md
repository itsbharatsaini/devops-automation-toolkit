# AWS CLI Cheat Sheet

## Verify Current Identity
Purpose: Confirm which AWS account/profile is active.

```bash
aws sts get-caller-identity
```
Use before Terraform Apply/Destroy or kubectl operations.

## Profiles

```bash
aws configure list-profiles
aws sts get-caller-identity --profile dev
```

## EKS

```bash
aws eks list-clusters --region us-east-2
aws eks update-kubeconfig --name my-cluster --region us-east-2 --profile dev
```

Use when connecting kubectl to EKS.

## ECR

```bash
aws ecr get-login-password --region us-east-2
```

Use for Docker authentication.

## S3

```bash
aws s3 ls
aws s3 cp file.txt s3://bucket/
aws s3 sync ./local s3://bucket/
```

## Troubleshooting

```bash
aws configure list
aws sts get-caller-identity
```
