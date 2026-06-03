Markdown
# WSL2 Ubuntu Kubernetes Context Synchronization Guide

This guide establishes a seamless, production-ready link between your Windows 11 host and your WSL2 Ubuntu (`bharat`) environment to share a single `kubeconfig` architecture. This prevents configuration drift when managing remote Kubernetes clusters (such as AWS EKS) across both environments.

---

## 1. Shared Architecture Model

Instead of copying configuration manifests, the Linux guest environment symlinks directly to the Windows NTFS host storage layer. 

* **Windows Host Path:** `C:\Users\bharat\.kube\config`
* **WSL Mount Point:** `/mnt/c/Users/bharat/.kube/config`
* **WSL Target Path:** `/home/bharat/.kube/config`
```
+--------------------------------------------+
|               WINDOWS 11 HOST              |
|  Path: C:\Users\bharat.kube\config        |
+---------------------+----------------------+
                    |
                    | (WSL /mnt/c/ Mount)
                    | Symbolic Link
                    v
+---------------------+----------------------+
|             WSL2 UBUNTU ENVIRONMENT        |
|  Path: /home/bharat/.kube/config         |
+--------------------------------------------+
```

---

## 2. Configuration & Symlink Deployment

Execute the following commands within your WSL Ubuntu terminal as your standard user (`bharat`) to establish the shared mapping.

### Step 2.1: Verify Host Config Visibility
Before generating links, confirm that the WSL storage subsystem can view your active Windows config payload:
```bash
ls -la /mnt/c/Users/bharat/.kube/config
```
### Step 2.2: Provision and Link Directories
Create the local configuration runtime directory and map the symbolic link:

```Bash
# Provision local run-dir
mkdir -p ~/.kube

# Establish the file system symbolic link
ln -s /mnt/c/Users/bharat/.kube/config ~/.kube/config
```
### Step 2.3: Restrict File System Permissions
POSIX security specifications require strict masking on configuration clusters. Modify permissions so only your active user context can read the descriptor:

```Bash
chmod 600 ~/.kube/config
```

## 3. Environment Diagnostics & Verification
Run these verification steps to ensure the API controller and cluster state mappings are functioning flawlessly.

### 1. Verify Symbolic Link Integrity
```Bash
ls -la ~/.kube
```
Expected Output:
```Plaintext
total 8
drwxr-xr-x 2 bharat bharat 4096 May 21 08:52 .
drwxr-x--- 4 bharat bharat 4096 May 21 08:47 ..
lrwxrwxrwx 1 bharat bharat   32 May 21 08:52 config -> /mnt/c/Users/bharat/.kube/config
```
Note: If a cat ~/.kube/config execution returns a "No such file or directory" error, check your exact Windows user folder path name using ls /mnt/c/Users/.

### 2. Check Loaded Cluster Contexts
Query kubectl to confirm it successfully parses the Windows configuration file data:

```Bash
# List all imported contexts
kubectl config get-contexts

# Output current active targeting context
kubectl config current-context
```
### 3. Test Cluster Control Plane Connectivity
Verify live cluster access (Note: Ensure your AWS credential profiles are also configured/accessible in WSL if your clusters rely on EKS token authentication):

```Bash
kubectl get nodes
```
### 4. Troubleshooting
Symptom: The connection to the server localhost:8080 was refused
Root Cause: kubectl is unable to locate or read a valid config payload at ~/.kube/config and is reverting to its hardcoded loopback fallback address.

Remediation: Re-verify your symbolic link path. Ensure the destination file inside your home folder is named exactly config without any trailing file extensions like .txt or .yaml.