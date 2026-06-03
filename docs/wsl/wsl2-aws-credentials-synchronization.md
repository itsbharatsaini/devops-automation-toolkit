# WSL2 AWS Credentials and Configuration Synchronization Guide

This guide establishes a seamless, production-ready link between your Windows 11 host and your WSL2 Ubuntu (`bharat`) environment to share a single AWS CLI configuration and credential architecture. This prevents configuration drift when working with multiple AWS accounts, IAM users, and AWS CLI profiles across both environments.

---

## 1. Shared Architecture Model

Instead of maintaining duplicate AWS configuration files, the WSL environment uses symbolic links that point directly to the Windows-hosted AWS configuration files.

### AWS Configuration Files

| Component                | Path                               |
| ------------------------ | ---------------------------------- |
| Windows Config File      | `C:\Users\bharat\.aws\config`      |
| Windows Credentials File | `C:\Users\bharat\.aws\credentials` |
| WSL Mount Path           | `/mnt/c/Users/bharat/.aws/`        |
| WSL Target Directory     | `/home/bharat/.aws/`               |

```text
+------------------------------------------------+
|                WINDOWS 11 HOST                 |
|                                                |
|  C:\Users\bharat\.aws\config                   |
|  C:\Users\bharat\.aws\credentials              |
+----------------------+-------------------------+
                       |
                       | WSL Mount (/mnt/c)
                       | Symbolic Links
                       v
+------------------------------------------------+
|              WSL2 UBUNTU ENVIRONMENT           |
|                                                |
|  /home/bharat/.aws/config                      |
|  /home/bharat/.aws/credentials                 |
+------------------------------------------------+
```

---

## 2. Configuration & Symlink Deployment

Execute the following commands within your WSL Ubuntu terminal as your standard user (`bharat`).

### Step 2.1: Verify Windows AWS Files

Confirm that WSL can access the AWS configuration files stored on Windows.

```bash
ls -la /mnt/c/Users/bharat/.aws/config
ls -la /mnt/c/Users/bharat/.aws/credentials
```

---

### Step 2.2: Create the AWS Directory

Create the AWS configuration directory if it does not already exist.

```bash
mkdir -p ~/.aws
```

---

### Step 2.3: Create Symbolic Links

Create symbolic links for both AWS configuration files.

```bash
ln -sf /mnt/c/Users/bharat/.aws/config ~/.aws/config

ln -sf /mnt/c/Users/bharat/.aws/credentials ~/.aws/credentials
```

---

### Step 2.4: Apply Secure Permissions

Restrict access to AWS credentials.

```bash
chmod 600 ~/.aws/config
chmod 600 ~/.aws/credentials
```

---

## 3. Environment Diagnostics & Verification

Run the following checks to validate that AWS CLI can access the shared configuration.

### 1. Verify Symbolic Link Integrity

```bash
ls -la ~/.aws
```

Expected Output:

```text
total 8
drwxr-xr-x 2 bharat bharat 4096 May 21 08:52 .
drwxr-x--- 4 bharat bharat 4096 May 21 08:47 ..
lrwxrwxrwx 1 bharat bharat   29 May 21 08:52 config -> /mnt/c/Users/bharat/.aws/config
lrwxrwxrwx 1 bharat bharat   34 May 21 08:52 credentials -> /mnt/c/Users/bharat/.aws/credentials
```

---

### 2. Verify AWS CLI Configuration

Display configured profiles:

```bash
aws configure list-profiles
```

Example:

```text
default
dev
staging
production
sandbox
```

---

### 3. Verify Active Identity

Check which AWS identity is currently being used.

```bash
aws sts get-caller-identity
```

Example:

```json
{
  "UserId": "AIDXXXXXXXXXXXX",
  "Account": "123456789012",
  "Arn": "arn:aws:iam::123456789012:user/bharat"
}
```

---

### 4. Verify Specific AWS Profile

If multiple AWS accounts are configured:

```bash
AWS_PROFILE=dev aws sts get-caller-identity

AWS_PROFILE=production aws sts get-caller-identity
```

---

### 5. Verify EKS Authentication

Confirm that AWS CLI can generate Kubernetes authentication tokens.

```bash
aws eks get-token \
  --cluster-name <cluster-name> \
  --region <aws-region>
```

---

## 4. Troubleshooting

### Symptom: Unable to Locate Credentials

Example:

```text
Unable to locate credentials
```

#### Root Cause

AWS CLI cannot locate a valid credentials file.

#### Resolution

Verify the symbolic links:

```bash
ls -la ~/.aws
```

Verify the source files exist:

```bash
ls -la /mnt/c/Users/bharat/.aws/
```

---

### Symptom: Profile Not Found

Example:

```text
The config profile (dev) could not be found
```

#### Root Cause

The requested AWS profile does not exist in the shared configuration.

#### Resolution

List available profiles:

```bash
aws configure list-profiles
```

Review the configuration:

```bash
cat ~/.aws/config
cat ~/.aws/credentials
```

---

### Symptom: Access Denied

Example:

```text
An error occurred (AccessDenied)
```

#### Root Cause

The IAM identity lacks permissions for the requested operation.

#### Resolution

Verify the active identity:

```bash
aws sts get-caller-identity
```

Verify the selected profile:

```bash
echo $AWS_PROFILE
```

---

## Summary

This setup provides:

* A single source of truth for AWS CLI configuration.
* Shared AWS profiles between Windows and WSL.
* Simplified multi-account AWS administration.
* Consistent authentication behavior for AWS CLI, Terraform, Helm, Velero, and kubectl.
* Reduced configuration drift across development environments.

By sharing the same AWS configuration and credential files through symbolic links, both Windows and WSL operate with identical AWS authentication and profile settings.
