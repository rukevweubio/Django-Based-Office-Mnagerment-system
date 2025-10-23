# Django Application Deployment on Azure Kubernetes Service (AKS) with Portainer

### Project Overview
This project outlines the deployment of a full-stack Django application on Azure Kubernetes Service (AKS) using Portainer as the Kubernetes management tool. The application consists of a frontend (likely a static or JavaScript-based UI), a Django backend for API and logic handling, and an Nginx server acting as a reverse proxy to route traffic between the frontend and backend, as well as handle external requests.

Key features:
- CI/CD Automation: Built and tested using GitHub Actions, with code quality analysis via SonarQube and vulnerability scanning via Trivy.
- Containerization: The application components are containerized into Docker images.
- Orchestration: Deployed on AKS for scalable, managed Kubernetes.
- Management: Portainer provides a user-friendly web interface for deploying and managing Kubernetes resources.
- Security and Best Practices: Integrates scanning tools to ensure secure images and code.
