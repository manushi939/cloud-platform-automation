# Cloud Platform Automation

## Overview
**cloud-platform-automation** is a collection of **production-ready DevOps automation scripts** designed to simplify and standardize **cloud infrastructure operations** across AWS and Kubernetes environments.

This repository focuses on **real-world operational tasks** such as EKS upgrades, node provisioning, security hardening, storage management, and lifecycle automation—commonly handled by DevOps and Platform Engineers.

---

## Key Capabilities

- ⚙️ Automates **AWS & Kubernetes operational workflows**
- ☸️ Supports **Amazon EKS cluster management**
- 🔐 Improves **security and access control**
- 💾 Handles **infrastructure maintenance and scaling**
- 🚀 Reduces manual effort and operational risk
- 🧩 Modular scripts usable independently or as part of pipelines

---

## Repository Structure

```text
.
├── Code-deploy-agent/        # Automation for deploying AWS CodeDeploy agent
├── EKS Cluster Upgrade/      # Scripts to safely upgrade EKS clusters
├── IP-whitelisting-script/   # Network-level IP whitelisting automation
├── Node Setup script/        # Node bootstrap and configuration automation
├── eks-tf/                   # Terraform-based EKS infrastructure setup
├── import_export/            # Data import/export utility scripts
├── server-volume-expansion/  # Disk and volume expansion automation
├── ecr-lifecycle.sh          # ECR lifecycle policy automation
└── README.md
