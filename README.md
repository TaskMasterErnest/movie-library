# Movie Library Platform

## 🌟 Overview
movie library is a cloud-native application platform demonstrating modern DevOps practices, infrastructure automation, and GitOps principles. Originally developed on GitLab to leverage its powerful CI/CD options that are useful in the project.

## Architecture Diagram
![Architecture Diagram](./images/portfolio.png)

## 🏗️ Repository Structure

The project is organized into three main components:

```
./
├── portfolio-application/
├── portfolio-gitops-config/
├── portfolio-infra/
└── README.md
```

## 🚀 Key Features

### Infrastructure Automation
- **Private GKE Cluster** with production-grade security
- **VPC-native networking** with custom subnet configurations
- **Terraform modules** for infrastructure management
- **Cloud NAT** and **Cloud Router** for secure external access
- **Workload Identity** integration

### CI/CD Pipeline (Jenkins + GitLab)
- Automated build and deployment processes
- Container image management
- Semantic versioning automation
- E2E testing integration
- GitLab integration for advanced SCM features
- Artifact management with Google Artifact Registry

### GitOps Deployment
- ArgoCD implementation using App of Apps pattern
- Helm chart management for all components
- Automated certificate management
- Comprehensive logging and monitoring stack
- Infrastructure-grade ingress control

## 📊 Platform Components

### Core Infrastructure
- Private GKE Cluster
- Custom VPC Configuration
- Cloud NAT Gateway
- Workload Identity Setup
- Node Pool Management

### Security & Access
- Private Cluster Configuration
- Sealed Secrets
- Cert-Manager
- Custom Firewall Rules
- RBAC Management

### Observability Stack
- **Logging**: Elasticsearch, Fluentd, Kibana
- **Monitoring**: Prometheus, Grafana
- **Alerting**: AlertManager
- **Ingress**: NGINX Ingress Controller

## 🔄 Development Workflow

1. **Infrastructure Updates**
   ```bash
   cd infrastructure/
   terraform plan
   terraform apply
   ```

2. **Application Deployment**
   - Push changes to GitLab repository
   - Jenkins pipeline automatically triggers
   - Container images built and pushed to Artifact Registry
   - ArgoCD syncs new configurations

3. **Configuration Management**
   - Update Helm charts in gitops-config
   - ArgoCD automatically detects and applies changes
   - Monitor deployment status through ArgoCD UI

## 🛠️ Technology Stack

### Cloud & Infrastructure
- Google Cloud Platform
- Terraform
- Google Kubernetes Engine
- Cloud NAT
- Artifact Registry

### CI/CD & Version Control
- Jenkins
- GitLab
- ArgoCD
- Docker
- Helm

### Monitoring & Logging
- Prometheus
- Grafana
- Elasticsearch
- Fluentd
- Kibana

## 🔐 Security Features

- Private GKE cluster
- Workload Identity
- Network Policies
- Sealed Secrets
- TLS Encryption
- RBAC Configurations

## 📈 Monitoring & Logging

- Centralized logging with EFK stack
- Metric collection with Prometheus
- Custom Grafana dashboards
- Automated alerting
- Performance monitoring

## 🚀 Getting Started

### Prerequisites
- GCP Account with required APIs enabled
- GitLab Account
- Jenkins Server
- kubectl and Helm installed
- Terraform >= 1.0

### Initial Setup
1. Clone the repository
2. Configure GCP credentials
3. Initialize Terraform
4. Deploy infrastructure
5. Configure GitLab integration
6. Deploy ArgoCD
7. Apply GitOps configurations

## 📚 Documentation

Detailed documentation for each component can be found in their respective directories:
- [Infrastructure Setup](./portfolio-infra/README.md)
- [Application CI/CD Pipeline](./portfolio-application/README.md)
- [GitOps Configuration](./portfolio-gitops-config/README.md)

---