# WSL2 Installation Guide for Windows 11

This guide covers the installation and configuration of Windows Subsystem for Linux 2 (WSL2) on Windows 11. WSL2 provides a full Linux environment running alongside Windows and supports multiple Linux distributions, including Ubuntu, Kali Linux, Debian, openSUSE, Oracle Linux, and Fedora.

This guide is intended for DevOps, Cloud, Kubernetes, Terraform, AWS, Azure, and general Linux administration workloads.

---

# Prerequisites

Before installing WSL2, ensure:

* Windows 11 is installed and fully updated.
* You have local administrator privileges.
* Hardware virtualization is enabled in BIOS/UEFI.
* Internet connectivity is available.
* At least 10 GB of free disk space is available.

---



# Step 1: Verify Virtualization Support

Open Task Manager:

```text
Ctrl + Shift + Esc
```

Navigate to:

```text
Performance → CPU
```

Verify:

```text
Virtualization: Enabled
```

If disabled:

1. Reboot your computer.
2. Enter BIOS/UEFI.
3. Enable:

   * Intel VT-x
   * Intel VT-d
   * AMD-V
   * SVM Mode

Save and reboot.

---

# Step 2: Install WSL2

Open PowerShell as Administrator.

Install WSL2:

```powershell
wsl --install
```

This command automatically:

* Enables Windows Subsystem for Linux.
* Enables Virtual Machine Platform.
* Installs WSL2.
* Downloads Ubuntu.
* Configures Ubuntu as the default distribution.

---

# Step 3: Restart Windows

After installation completes:

```text
Start → Power → Restart
```

---

# Step 4: Verify Installation

Open PowerShell:

```powershell
wsl --status
```

Expected output:

```text
Default Distribution: Ubuntu
Default Version: 2
```

List installed distributions:

```powershell
wsl -l -v
```

Example:

```text
NAME      STATE           VERSION
Ubuntu    Stopped         2
```

---

# Step 5: Install a Specific Linux Distribution

WSL2 supports multiple Linux distributions.

View available distributions:

```powershell
wsl --list --online
```

Example:

```text
NAME
Ubuntu
Ubuntu-24.04
Debian
kali-linux
openSUSE-Leap-15.6
OracleLinux_9_3
```

Common distributions:

| Distribution | Recommended Use Case                     |
| ------------ | ---------------------------------------- |
| Ubuntu       | DevOps, Kubernetes, Cloud Engineering    |
| Kali Linux   | Security Testing and Penetration Testing |
| Debian       | Stable Server Administration             |
| openSUSE     | Enterprise Linux                         |
| Oracle Linux | Oracle Workloads                         |
| Fedora       | Development and Cloud Native Workloads   |

---
## Ubuntu

```powershell
wsl --install Ubuntu
```

## Kali Linux

```powershell
wsl --install kali-linux
```

## Debian

```powershell
wsl --install Debian
```

## openSUSE

```powershell
wsl --install openSUSE-Leap-15.6
```

---

# Step 6: Launch Linux

Launch a specific distribution:

```powershell
wsl -d Ubuntu
```

or

```powershell
wsl -d kali-linux
```

or

```powershell
wsl -d Debian
```

---

# Step 7: Create Linux User

During first launch, Linux prompts for a user account.

Example:

```text
Enter new UNIX username:
```

Enter:

```text
bharat
```

Set a password:

```text
New password:
Retype new password:
```

Notes:

* Password input is hidden.
* Linux password is separate from your Windows password.

---

# Step 8: Update Linux Packages

## Ubuntu / Debian / Kali

```bash
sudo apt update
sudo apt upgrade -y
```

## Fedora

```bash
sudo dnf update -y
```

## openSUSE

```bash
sudo zypper refresh
sudo zypper update -y
```

Verify Linux version:

```bash
cat /etc/os-release
```

---

# Step 9: Set WSL2 as Default Version

Verify WSL2 is the default:

```powershell
wsl --set-default-version 2
```

---

# Step 10: Configure Default Distribution

If multiple Linux distributions are installed:

View installed distributions:

```powershell
wsl -l -v
```

Set default:

```powershell
wsl --set-default Ubuntu
```

Example:

```powershell
wsl --set-default kali-linux
```

---

# Step 11: Verify Windows Drive Access

Inside Linux:

```bash
ls /mnt
```

Expected:

```text
c
d
```

Access Windows files:

```bash
cd /mnt/c/Users
```

List user profiles:

```bash
ls
```

Example:

```text
Public
Default
bharat
```

---

# Step 12: Configure Windows Terminal (Recommended)

Open:

```text
Windows Terminal
```

Navigate:

```text
Settings
→ Default Profile
→ Ubuntu
```

Benefits:

* Multiple tabs
* Split panes
* Better copy/paste support
* Improved terminal experience

---

# Step 13: Update WSL Components

Update WSL:

```powershell
wsl --update
```

Verify version:

```powershell
wsl --version
```

Example:

```text
WSL version: 2.x.x
Kernel version: x.x.x
```

---

# Common WSL Commands

## Start Default Distribution

```powershell
wsl
```

## Start Specific Distribution

```powershell
wsl -d Ubuntu
```

```powershell
wsl -d kali-linux
```

## List Installed Distributions

```powershell
wsl -l -v
```

## Stop All WSL Instances

```powershell
wsl --shutdown
```

## Restart WSL

```powershell
wsl --shutdown
wsl
```

## Set Default Distribution

```powershell
wsl --set-default Ubuntu
```

## Remove a Distribution

```powershell
wsl --unregister Ubuntu
```

---

# Export and Import WSL Distributions

## Export a Distribution

Create a backup:

```powershell
wsl --export Ubuntu C:\Backups\ubuntu.tar
```

## Import a Distribution

```powershell
wsl --import Ubuntu-Backup D:\WSL\Ubuntu C:\Backups\ubuntu.tar --version 2
```

Useful when migrating machines.

---

# Configure Resource Limits (Optional)

Create:

```text
C:\Users\bharat\.wslconfig
```

Example:

```ini
[wsl2]
memory=8GB
processors=4
swap=4GB
```

Apply changes:

```powershell
wsl --shutdown
```

Restart WSL.

---

# Troubleshooting

## Error: Virtual Machine Platform Not Enabled

Enable manually:

```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

Restart Windows.

---

## Error: WSL Requires an Update

Update WSL:

```powershell
wsl --update
```

Restart:

```powershell
wsl --shutdown
```

---

## Error: Virtualization Disabled

Open:

```text
Task Manager → Performance → CPU
```

Verify:

```text
Virtualization: Enabled
```

If disabled, enable virtualization in BIOS/UEFI.

---

## Error: Distribution Not Found

List available distributions:

```powershell
wsl --list --online
```

Install the desired distribution:

```powershell
wsl --install <distribution-name>
```

---

# Recommended DevOps Tooling

After WSL installation, install:

* Git
* AWS CLI
* Azure CLI
* kubectl
* Helm
* Terraform
* Docker Desktop Integration
* Velero CLI
* jq
* yq

---

# Related Documentation

```text
docs/wsl/install-wsl2-on-windows-11.md
docs/wsl/wsl2-aws-credentials-synchronization.md
docs/wsl/wsl2-kubernetes-context-synchronization.md
```

---

# Summary

WSL2 provides a lightweight, high-performance Linux environment integrated directly into Windows 11. It supports multiple Linux distributions and is suitable for modern DevOps, Kubernetes, Cloud Engineering, Infrastructure as Code, and Software Development workflows. By using WSL2, engineers can leverage native Linux tooling while maintaining seamless access to Windows applications and files.
