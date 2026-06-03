# Terraform Cheat Sheet

## Initialize

```bash
terraform init
```

Downloads providers and modules.

## Validate

```bash
terraform validate
terraform fmt -recursive
```

## Plan

```bash
terraform plan
```

Review changes before apply.

## Apply

```bash
terraform apply
```

## Destroy

```bash
terraform destroy
```

## State

```bash
terraform state list
terraform state show RESOURCE
terraform import RESOURCE ID
```

## Troubleshooting

```bash
terraform refresh
terraform providers
terraform version
```
