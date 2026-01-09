# Terraform – AWS ECS Fargate Platform (Single Account, Multi-Environment)

This repository contains a **production-grade Terraform setup** for deploying a **Java application on AWS ECS (Fargate)** behind an **Application Load Balancer**, with **auto-scaling**, **ECR**, **CloudWatch logging**, **least-privilege IAM**, and a **New Relic infra sidecar**.

The design intentionally mirrors how mature platform / DevOps teams run ECS workloads in the real world.

---

## 🏗️ Architecture Overview

**High-level components**

- **VPC**
    - Public subnets (ALB)
    - Private subnets (ECS tasks)
    - NAT Gateways
- **ECS (Fargate)**
    - Java application container
    - New Relic Infrastructure sidecar
- **Application Load Balancer**
    - Internet-facing
    - Routes traffic to ECS service
- **ECR**
    - One repository per service
- **CloudWatch Logs**
- **Application Auto Scaling**
    - CPU-based scaling
- **IAM**
    - ECS task execution role
    - ECS task role (least privilege)

---

## 📁 Repository Structure

```text
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

## 🌍 Environment Model
### AWS Account Strategy

- **Single AWS account**

- Multiple environments (e.g. dev, staging, prod) are logically separated using:

- Terraform variable files

- Environment-specific ECS services

- Docker image tags or immutable digests

### ✅ Recommended Practices

- One Terraform state per environment

- Separate CI/CD pipelines per environment

- Isolation is enforced at the state, deployment, and release levels

### 📦 ECR Strategy (Single Account – Best Practice)
- Repository Structure
- One ECR repository per service
- Environments are not separated by repositories

### Environment Separation

- Environment isolation is achieved using:
- Mutable environment tags (dev, staging, prod)
- Immutable image digests (sha256:...)

### 🚀 Image Promotion Flow

- Build the Docker image

- Push the image with an immutable tag:

`sha-<gitsha>`


- Retag the same image digest as:
```
dev

staging

prod
```
 - Deploy ECS services using the image digest, not mutable tags

#### 📈 Auto Scaling

ECS services automatically scale based on CPU utilization.

- **Scaling Configuration**
  - Minimum tasks: 1 
  - Maximum tasks: 3 
  - Target CPU utilization: 70%

- **Terraform Resources**
  - aws_appautoscaling_target 
  - aws_appautoscaling_policy


This setup provides:
- Cost efficiency at low traffic 
- Automatic scaling during load spikes 
- Predictable and controlled scaling behavior

### ✅ Summary

- Single AWS account with strong environment isolation 
- Immutable, digest-based ECS deployments 
- Secure IAM model following least-privilege principles 
- Predictable ECS auto-scaling 
- Clean separation of concerns across Terraform, CI/CD, and runtime