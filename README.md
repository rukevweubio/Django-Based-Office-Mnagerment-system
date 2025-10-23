# Django Application Deployment on Azure Kubernetes Service (AKS) with Portainer

### Project Overview
This project outlines the deployment of a full-stack Django application on Azure Kubernetes Service (AKS) using Portainer as the Kubernetes management tool. The application consists of a frontend (likely a static or JavaScript-based UI), a Django backend for API and logic handling, and an Nginx server acting as a reverse proxy to route traffic between the frontend and backend, as well as handle external requests.

Key features:
- CI/CD Automation: Built and tested using GitHub Actions, with code quality analysis via SonarQube and vulnerability scanning via Trivy.
- Containerization: The application components are containerized into Docker images.
- Orchestration: Deployed on AKS for scalable, managed Kubernetes.
- Management: Portainer provides a user-friendly web interface for deploying and managing Kubernetes resources.
- Security and Best Practices: Integrates scanning tools to ensure secure images and code.

  ArchitecturE

Components:
- Backend : Handles user interface (e.g., HTML/CSS/JS or a framework like React/Vue integrated with Django)
- Frontend  (Django): Python-based web framework for business logic, database interactions (e.g., PostgreSQL or SQLite), and API endpoints.
- Nginx Reverse Proxy: Routes traffic to frontend static files and proxies API requests to the Django backend. Also handles SSL termination if configured.


CI/CD:
- GitHub Actions: Builds Docker images, runs tests, scans for vulnerabilities, and pushes images to a container registry (e.g.docker).

Kubernetes (AKS):
- Deployments for each component (frontend, backend, Nginx).
- Services to expose ports internally/externally.
- Ingress or LoadBalancer for external access (managed via Portainer).
Tools:
- SonarQube: Static code analysis for quality gates.
- Trivy: Container image vulnerability scanner.
- Portainer: Web-based Kubernetes dashboard for deployment and monitoring.


### CI/CD Pipeline with GitHub Actions
The pipeline automates building, testing, and image pushing. Workflows are in .github/workflows/ (e.g., build-test-deploy.yaml).

Dockerfiles:
- frontend/Dockerfile: Builds frontend (e.g., npm build for static files).
- backend/Dockerfile: Installs Python dependencies, collects static files for Django.
- nginx/Dockerfile: Configures Nginx with custom conf to proxy to backend/frontend.


GitHub Actions Workflow:
- Trigger: On push to main or pull requests.
- Checkout code.
- Build Docker images: docker build -t <acr-repo>/frontend:latest ./frontend.
- Similar for backend and nginx.

Example snippet from workflow:
```
