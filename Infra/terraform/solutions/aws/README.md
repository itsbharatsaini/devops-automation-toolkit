# Terraform Solutions

This directory contains deployable infrastructure solutions composed of multiple Terraform modules.

## Purpose

Solutions represent opinionated infrastructure implementations designed to solve a complete use case or platform requirement.

Examples:

* EKS cluster deployment
* Velero backup setup
* AWS Backup configuration
* Cross-region disaster recovery

## Structure

```text
solutions/
├── aws/
├── azure/
├── multi-cloud/
└── shared/
```

## Example Solutions

```text
solutions/aws/eks-cluster
solutions/aws/eks-with-velero
solutions/aws/aws-backup-plan
solutions/aws/cross-region-restore
```

## Guidelines

* Solutions may combine multiple modules.
* Keep solutions deployment-oriented.
* Avoid hardcoding environment-specific values.
* Solutions should remain reusable across environments.

## Recommended Files

```text
main.tf
variables.tf
outputs.tf
README.md
```

## Notes

Solutions are consumed by environment deployments and should not directly contain:

* backend state configuration
* environment credentials
* pipeline-specific logic
