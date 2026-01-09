# infrastructure-aws-mal

This repository contains Terraform-based Infrastructure-as-Code (IaC) for provisioning a modular, scalable AWS platform designed to support containerized applications using **Amazon ECS with Fargate**.

It is structured to support:
- **Multi-service environments**
- **Multi-environment deployments** (e.g., `dev`, `prod`)
- **CI/CD automation (GitHub Actions)**
- Observability via tools like **New Relic**
- Secure and least-privilege IAM

---

## 🧱 What This Repo Provides

The Terraform code in this repo defines the following infrastructure:

### 🕸 Networking
- VPC with public and private subnets across multiple Availability Zones
- Internet Gateway & NAT Gateways
- Route Tables and appropriate associations

### 🛠 Container Platform
- ECS Cluster configured for **Fargate launch type**
- Application Load Balancer (ALB) in public subnets
- ECS Services running application tasks
- Task Definitions that support:
    - Java application container
    - New Relic sidecar (infra monitoring)

### 📦 Container Registry
- Single **Amazon ECR repository** per service
- Supports promotion of digest-pinned images between environments

### 🪪 IAM & Security
- Least-privilege **IAM roles** for ECS task execution and application permissions
- Security Groups with proper ingress/egress boundaries

### 📈 Observability
- CloudWatch Log Groups for container logging
- Optional New Relic sidecar for ECS infrastructure metrics

### 🔁 Autoscaling
- ECS Service autoscaling (min: 1, max: 3)
- Target CPU utilization policy (e.g., 70%)

---

## 📁 Repo Structure

```text
terraform-aws-mal/
infrastructure-aws-mal/
├── .github/                  # GitHub Actions CI/CD workflows
├── app/                      # Application artifacts (Dockerfile, app code, etc.)
├── terraform/
│   ├── .terraform/           # Terraform working directory
│   ├── environments/         # Environment-specific variables
│   │   ├── dev.tfvars
│   │   └── prod.tfvars
│   ├── modules/              # Reusable Terraform modules
│   │   ├── vpc/
│   │   ├── security-groups/
│   │   ├── alb/
│   │   ├── ecr/
│   │   ├── iam/
│   │   ├── cloudwatch/
│   │   └── ecs/
│   │       ├── main.tf
│   │       ├── autoscaling.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   ├── main.tf               # Root Terraform orchestration
│   ├── variables.tf
│   ├── versions.tf
│   ├── outputs.tf
│   └── README.md             # Terraform-specific documentation
├── README.md                 # Repository entry documentation (this file)

```