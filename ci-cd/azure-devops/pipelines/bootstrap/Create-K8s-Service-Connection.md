# Create Kubernetes Service Connection

Pipeline: `Create-K8s-Service-Connection.yml`

## Purpose

Creates an Azure DevOps Kubernetes service connection to an EKS cluster by exporting a Kubernetes secret and posting it to Azure DevOps.

## Parameters

- `DESTINATION_AWS_REGION`: Region of the EKS cluster.
- `DESTINATION_EKS_CLUSTER_NAME`: Name of the EKS cluster.
- `DESTINATION_EKS_CLUSTER_NAMESPACES`: Namespaces used to locate the service account secret.
- `DESTINATION_EKS_SECRET_NAME`: Kubernetes secret name to export.
- `K8S_SERVICE_CONNECTION_NAME`: Name for the Azure DevOps service connection.

## How it works

1. Runs `aws eks update-kubeconfig` to configure `kubectl` for the target EKS cluster.
2. Retrieves the cluster endpoint and builds a `CLUSTER_URL` variable.
3. Installs `kubectl` via `KubectlInstaller@0`.
4. Retrieves the Kubernetes secret JSON for the specified secret.
5. Installs Python dependencies from `requirements.txt`.
6. Runs `create_k8s_service_connection.py` to create the Azure DevOps service connection.

## Requirements

- Azure DevOps AWS service connection named `AWS-ServiceConnection`.
- AWS credentials must be available for `aws eks update-kubeconfig` and other AWS CLI commands.
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_SESSION_TOKEN` (if using temporary credentials)
- Azure DevOps agent permission to use `System.AccessToken`.
- Python dependencies installed via `requirements.txt`.
- Kubernetes secret must exist in the specified namespace.

## Variable group

This pipeline includes a variable group called `DR-Automation-Variables`.
The variable group must contain at least:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- optionally `AWS_SESSION_TOKEN`

These values are used by the AWS CLI tasks when configuring `kubectl` and describing the EKS cluster.

## Important

- The pipeline expects `create_k8s_service_connection.py` to be reachable from the pipeline working directory.
- If the script is located at `ci-cd/azure-devops/script/`, update the pipeline command accordingly.
