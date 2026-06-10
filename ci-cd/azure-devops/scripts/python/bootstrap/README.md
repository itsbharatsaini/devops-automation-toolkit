# Azure DevOps Script

This folder contains a helper script used by Azure DevOps pipelines to create a Kubernetes service connection from an EKS cluster secret.

## Script included

- `create_k8s_service_connection.py`
  - Creates an Azure DevOps Kubernetes service connection using a Kubernetes `Secret` JSON file.

## Purpose

The script reads a Kubernetes Secret JSON file produced by `kubectl`, preserves base64-encoded token and certificate values, and posts a service connection payload to Azure DevOps REST API.

## Required files and placement

- Place `create_k8s_service_connection.py` in `ci-cd/azure-devops/script/`.
- The pipeline invoking the script must either change into the script folder or use the full path when calling Python.

## Dependencies

Create a `requirements.txt` in the repository root containing:

```text
python-dotenv
httpx
```

Then install dependencies before running the script.

## Usage

From a pipeline or local shell:

```bash
python3 ci-cd/azure-devops/script/create_k8s_service_connection.py \
  --secret secret.json \
  --cluster-url https://<EKS_ENDPOINT> \
  --name "My-K8s-Service-Connection" \
  --pat "<PAT_TOKEN>" \
  --project-id "<PROJECT_ID>" \
  --project-name "<PROJECT_NAME>" \
  --org-url "https://dev.azure.com/<ORG>"
```

When run inside Azure DevOps, the script can usually rely on pipeline environment variables:

- `SYSTEM_ACCESSTOKEN`
- `SYSTEM_TEAMPROJECTID`
- `SYSTEM_TEAMPROJECT`
- `SYSTEM_COLLECTIONURI`

## Kubernetes secret requirements

The input JSON must be a Kubernetes Secret of kind `Secret` and must include:

- `data.token`
- `data.ca.crt`

The script keeps these values base64-encoded for Azure DevOps.

## Important notes

- Do not decode `data.token` or `data.ca.crt` before passing them to the script.
- `System.AccessToken` should have permissions to create service connections.
