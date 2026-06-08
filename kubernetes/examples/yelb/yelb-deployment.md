# Yelb Microservices Application Deployment

This guide outlines the steps to quickly deploy **Yelb**, a multi-tier sample application, onto a Kubernetes cluster. Yelb is commonly used for test environments, benchmarking, demonstrating DevOps pipelines, or testing Service Meshes (like Istio/Linkerd).

## Architecture Overview
The manifest deploys a standard 4-tier microservices architecture:
- **yelb-ui:** Frontend UI component (Angular).
- **yelb-appserver:** Application logic layer (Ruby app server).
- **redis-server:** Key-value cache layer to track application state/votes.
- **yelb-db:** Backend persistent storage layer (PostgreSQL database).

---

## Prerequisites
Before execution, ensure you have:
- A running Kubernetes cluster.
- `kubectl` configured locally with administrative permissions to your cluster.
- Internet connectivity within the cluster to fetch the external YAML deployment file and pull container images.

---

## Deployment Steps

### 1. Create an Isolated Namespace
It is a best practice to organize and isolate your applications within Kubernetes using namespaces. Create a dedicated namespace named `yelb`:

```bash
kubectl create ns yelb
```

### 2. Apply the Manifest Configuration
Deploy the entire application stack using the remote Kubernetes manifest configuration provided by the repository. This manifest utilizes a LoadBalancer service type to expose the frontend:

```Bash
kubectl -n yelb apply -f https://raw.githubusercontent.com/lamw/yelb/master/deployments/platformdeployment/Kubernetes/yaml/yelb-k8s-loadbalancer.yaml
```

### 3. Verify the Deployment
Monitor the deployment to ensure that all application tiers scale up and transition into a Running status successfully:

```bash
kubectl -n yelb get pods
```

### 4. Accessing the Application
Once all pods are actively running, look up the external point of entry created by the LoadBalancer service:

```Bash
kubectl -n yelb get svc yelb-ui
```
Locate the EXTERNAL-IP address (or DNS endpoint) in the terminal output. Paste that address into your web browser to access the Yelb application UI.

### Cleanup
To tear down the application and remove all associated components from your cluster, simply delete the namespace:

```Bash
kubectl delete ns yelb
```
