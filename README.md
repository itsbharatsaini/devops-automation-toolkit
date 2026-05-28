# DevOps Automation Toolkit

A centralized repository of production-ready automation scripts, Infrastructure as Code (IaC), Kubernetes configurations, and reusable Azure DevOps CI/CD pipelines. This toolkit is engineered to streamline multi-environment deployments, enforce best practices, and accelerate cloud operations.

---

## 📂 Repository Structure

The repository is organized modularly to separate infrastructure, application orchestration, utility scripts, and pipeline logic:

```text
devops-automation-toolkit/
├── .github/
│   └── workflows/              # GitHub Actions (for repo linting and testing)
├── CI_CD/
│   └── azure-devops/
│       ├── pipelines/          # End-to-end Azure Pipeline YAML definitions
│       └── templates/          # Reusable ADO step, job, and stage templates
├── Infra/
│   └── terraform/              # Infrastructure as Code (IaC)
│       ├── modules/            # Reusable infrastructure blocks (VPC, EKS/AKS, RDS, etc.)
│       └── environments/       # Root modules for Dev, Staging, and Prod
├── kubernetes/                 # Container orchestration assets
│   ├── manifests/              # Raw Kubernetes YAML manifests
│   └── helm-charts/            # Custom application Helm charts
├── scripts/                    # Operational and utility scripts
│   ├── bash/                   # Shell scripts for routine automation
│   └── python/                 # Python scripts for complex cloud workflows
├── .gitignore                  # Git ignore rules for tfstate, secrets, and local caches
├── LICENSE                     # Project license details
└── README.md                   # Repository entry point documentation