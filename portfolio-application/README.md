# movie-library CI/CD Pipeline

## Overview
This repository contains a robust CI/CD pipeline implementation for the movie-library application using Jenkins, Docker, and Kubernetes. The pipeline automates the build, test, and deployment processes while incorporating industry best practices for container management and artifact versioning.

## 🏗️ Architecture

The project implements a modern microservices architecture with:
- Frontend application container (`ernestklu`)
- Nginx reverse proxy container (`ernestklu:nginx`)
- Automated deployment to Google Cloud Platform (GCP)
- Container registry management in GCP Artifact Registry
- Helm chart packaging and versioning

## 🔄 CI/CD Pipeline

## 🚀 Features

- **gitlab Integration**
  - Triggers on push and merge requests
  - Updates commit status
  - Branch-specific pipeline behavior

- **Security**
  - Secure credential management using Jenkins credentials
  - SSH key authentication for Git operations
  - Environment file protection

- **Automation**
  - Automatic version incrementing
  - Container cleanup
  - Workspace management

- **Quality Assurance**
  - End-to-end testing
  - Environment isolation
  - Automated cleanup

## 🛠️ Prerequisites

- Jenkins server with following plugins:
  - gitlab plugin
  - SSH Agent plugin
  - Credentials plugin
- Docker and Docker Compose
- Helm
- Access to Google Cloud Platform
- gitlab repository access

## ⚙️ Configuration

### Required Credentials

1. `FLASK_ENV`: Environment file for Flask application
2. `GOOGLE_ARTIFACT_REGISTRY_KEY`: GCP service account key
3. `JENKINS_gitlab_SSH_KEY`: SSH key for gitlab authentication

### Environment Variables

```
APP_IMAGE = "ernestklu"
NGINX_IMAGE = "ernestklu:nginx"
APP_URL = "http://taskmaster.chickenkiller.com:3000/signup"
```

## 🧪 Testing

To set up and run this application locally, ensure you have Docker and Docker Compose installed. Then, simply run:
```bash
compose up -d
```

The E2E testing script (`e2e.sh`) validates the application's user registration endpoint:

- Tests POST request to signup endpoint
- Validates request parameters:
  - username
  - password
  - password confirmation
- Expects HTTP 200 response for success

## 📝 Contributing

1. Include "#test" in commit messages to trigger E2E tests
2. Ensure version.txt is updated appropriately
3. Follow semantic versioning guidelines

## 🔍 Notes

- Pipeline automatically manages versioning
- Main branch deployments push to production
- Failed E2E tests prevent deployment
- Images are automatically pruned after pipeline completion

## 📦 Artifacts

The pipeline produces:
- Container images in Google Artifact Registry
- Helm charts in Google Artifact Registry
- Git tags for version tracking

---