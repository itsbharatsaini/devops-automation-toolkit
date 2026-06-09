# Terraform Modules

This directory contains reusable Terraform modules.

## Purpose

Modules are the foundational building blocks used across environments and solutions.
Each module should be:

* reusable
* isolated
* configurable
* cloud or platform specific

## Structure

```text
modules/
├── aws/
├── azure/
├── gcp/
```

## Guidelines

* Keep modules focused on a single responsibility.
* Avoid environment-specific values inside modules.
* Use variables for customization.
* Expose outputs required by consuming solutions or environments.
* Maintain backward compatibility whenever possible.

## Example Modules

```text
modules/aws/eks
modules/aws/s3
modules/kubernetes/velero
```

## Module Standards

Each module should contain:

```text
main.tf
variables.tf
outputs.tf
versions.tf
README.md
```

## Notes

Modules should NOT:

* contain backend configuration
* contain environment-specific state configuration
* directly manage deployment workflows
* contain hardcoded secrets or credentials
