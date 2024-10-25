# GKE Infrastructure with Terraform

## 🌟 Overview
This repository contains Infrastructure as Code (IaC) implementation for a production-grade Google Kubernetes Engine (GKE) cluster using Terraform. The infrastructure setup includes comprehensive networking, security configurations, monitoring, and observability solutions.

## 🏗️ Architecture

### Infrastructure Components
- **Private GKE Cluster**
- **VPC-native Networking**
- **Cloud NAT & Cloud Router**
- **Private Subnets with Secondary IP Ranges**
- **Dedicated Node Pools**
- **Workload Identity Integration**

### Helm Deployments
- **ArgoCD** for GitOps
- **Sealed Secrets** for secret management
- **Ingress-Nginx** for ingress control
- **Cert-Manager** for SSL/TLS management
- **EFK Stack** (Elasticsearch, Fluentd, Kibana) for logging
- **Prometheus Stack** for monitoring

## 🔌 Network Architecture

### VPC Configuration
- Custom VPC with regional routing
- Private subnets with Google Private Access
- MTU customization support
- Dedicated IP ranges for pods and services
- Cloud NAT for outbound internet access
- Premium tier networking

### Security Features
- Private cluster configuration
- Customizable SSH access controls
- Dedicated service accounts
- Workload identity setup
- Private endpoint options

## 🚀 GKE Cluster Specifications

### Cluster Configuration
- Multi-zonal capability
- Private cluster setup
- VPC-native networking mode
- Regular release channel
- Custom node pool configurations
- Automated node management

### Node Pool Features
- Dedicated service accounts
- Custom disk configurations
- Auto-repair and auto-upgrade enabled
- Full cloud platform OAuth scope
- Role-based node labeling

## 📊 Monitoring & Logging Stack

### Observability Components
1. **Logging Stack**
   - Elasticsearch for log storage
   - Kibana for log visualization
   - Fluentd for log collection

2. **Monitoring Stack**
   - Prometheus for metrics collection
   - Grafana for metrics visualization
   - Alert manager for notifications

## 🛠️ Module Structure

```
.
├── modules/
│   ├── network/           # VPC and networking components
│   ├── gke-cluster/      # GKE cluster configuration
│   ├── node-pools/       # Node pool management
│   └── helm-releases/    # Helm chart deployments
```

## ⚙️ Prerequisites

- Google Cloud Platform Account
- Terraform >= 1.0
- kubectl
- helm >= 3.0
- GCP Project with required APIs enabled:
  - Compute Engine API
  - Container API

## 🔐 Security Features

- Private GKE cluster configuration
- Dedicated service accounts
- Network policy support
- Firewall rules for SSH access
- Sealed Secrets for sensitive data
- TLS certification management

## 📦 Deployed Applications

### Core Infrastructure
- ArgoCD (v5.53.14)
- Sealed Secrets (v2.14.2)
- Ingress-Nginx (v4.9.1)
- Cert-Manager (v1.13.3)

### Observability Stack
- Elasticsearch (v19.17.5)
- Kibana (v10.9.0)
- Fluentd (v5.15.1)
- Kube-Prometheus-Stack (v56.6.2)

## 🚀 Getting Started

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Plan the Infrastructure**
   ```bash
   terraform plan
   ```

3. **Apply the Configuration**
   ```bash
   terraform apply
   ```

4. **Connect to Cluster**
   ```bash
   gcloud container clusters get-credentials [CLUSTER_NAME] --zone [ZONE] --project [PROJECT_ID]
   ```

## 🔍 Features and Best Practices

- **Infrastructure as Code**: Complete infrastructure defined in Terraform
- **Modularity**: Separated concerns for network, cluster, and applications
- **Scalability**: Configurable node pools and resource allocation
- **Security**: Private cluster setup with controlled access
- **Observability**: Comprehensive monitoring and logging setup
- **GitOps Ready**: ArgoCD integration for deployment management
- **Automated Certificate Management**: Cert-manager integration
- **Load Balancing**: Ingress-nginx for traffic management

## 🛡️ Security Considerations

- Private cluster configuration
- Workload identity integration
- Network policy enforcement
- Custom service accounts
- Sealed secrets for sensitive data
- Controlled SSH access

## 📈 Monitoring & Logging

- **Metrics**: Prometheus + Grafana stack
- **Logs**: EFK (Elasticsearch, Fluentd, Kibana) stack
- **Alerts**: AlertManager integration
- **Visualization**: Kibana and Grafana dashboards

---