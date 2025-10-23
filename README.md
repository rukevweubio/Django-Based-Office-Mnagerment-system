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
- Build   dockerapp locally  by testing teh app on local
- backend/Dockerfile: Installs Python dependencies, collects static files for Django.
- nginx/Dockerfile: Configures Nginx with custom conf to proxy to backend/frontend.
  
### Step 1
Build the Docker image for your application.
- Test the application locally to ensure it runs as expected.
- Expose the desired port to allow external access to the application.
- Run the Docker container using the following command:
  ```
   docker compose --build
   docker tag dockerimage:latest rukevweubio/djangoapp:latest
   docker push rukevweubio/djangoapp:latest
   docker run -d -p rukevweubio/djangoapp:latest
   docker pull rukevweubio/djangoapp:latest
  
  ```
  ![docker build locally](https://github.com/rukevweubio/Django-Based-Office-Mnagerment-system/blob/main/photo/Screenshot%20(2632).png)

  ![django app](https://github.com/rukevweubio/Django-Based-Office-Mnagerment-system/blob/main/photo/Screenshot%20(2631).png)

### GitHub Actions and Workflow
GitHub Actions is a CI/CD platform that automates building, testing, and deploying code directly in your GitHub repository.
A workflow is an automated process defined in a YAML file (.github/workflows/) consisting of jobs (groups of tasks) and steps (individual tasks).

### Project Workflow Steps:
- Trigger: Runs on events like push or pull_request.
- Checkout Code: Pull repository code using actions/checkout.
- Set Up Environment: Install required tools and dependencies.
- Run Tests: Execute automated tests to verify code quality.
- Build Project: Compile or package the project.
- Deploy (Optional): Deploy to staging or production if tests pass.
- Notify / Report: Send status updates or alerts about the workflow.
- Example snippet from workflow:

```
name: Secure Build, Scan, and Push Django App

on:
  push:
    branches:
      - main

env:
  WEB_IMAGE: rukevweubio/ems-web2:latest
  NGINX_IMAGE: rukevweubio/ems-nginx2:latest

jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      web_image: ${{ env.WEB_IMAGE }}
      nginx_image: ${{ env.NGINX_IMAGE }}
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.10'

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build Django app image (no push)
        uses: docker/build-push-action@v5
        with:
          context: .
          file: ./Dockerfile
          push: false
          load: true
          tags: ${{ env.WEB_IMAGE }}

      - name: Build Nginx image (no push)
        uses: docker/build-push-action@v5
        with:
          context: ./nginx
          file: ./nginx/Dockerfile
          push: false
          load: true
          tags: ${{ env.NGINX_IMAGE }}

      - name: Save built images as artifacts
        run: |
          mkdir -p artifacts
          docker save ${{ env.WEB_IMAGE }} -o artifacts/ems-web.tar
          docker save ${{ env.NGINX_IMAGE }} -o artifacts/ems-nginx.tar

      - name: Upload built images
        uses: actions/upload-artifact@v4
        with:
          name: django-app-images
          path: artifacts/

  sonar-analysis:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0 

      - name: SonarQube Scan
        uses: SonarSource/sonarqube-scan-action@v6
        env:
          SONAR_TOKEN: ${{secrets.SONAR_TOKEN}}
          # SONAR_HOST_URL: ${{secrets.SONAR_HOST_URL}}
          SONAR_HOST_URL: https://sonarcloud.io
        with:
          projectBaseDir: .
        

  trivy-scan:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Download built images
        uses: actions/download-artifact@v4
        with:
          name: django-app-images
          path: ./artifacts

      - name: Load Docker images
        run: |
          docker load -i ./artifacts/ems-web.tar
          docker load -i ./artifacts/ems-nginx.tar

      - name: Scan Django app image
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: rukevweubio/ems-web:latest
          format: 'table'
          exit-code: '1'
          severity: 'CRITICAL'

      - name: Scan Nginx image
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: rukevweubio/ems-nginx:latest
          format: 'table'
          exit-code: '1'
          severity: 'CRITICAL'

  push-images:
    runs-on: ubuntu-latest
    needs: [trivy-scan, sonar-analysis]
    if: ${{ success() }}
    steps:
      - name: Download images
        uses: actions/download-artifact@v4
        with:
          name: django-app-images
          path: ./artifacts

      - name: Load Docker images
        run: |
          docker load -i ./artifacts/ems-web.tar
          docker load -i ./artifacts/ems-nginx.tar

      - name: Log in to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Push final Django app image
        run: docker push ${{ env.WEB_IMAGE }}

      - name: Push final Nginx image
        run: docker push ${{ env.NGINX_IMAGE }}
```
![Gitaction  workflow](https://github.com/rukevweubio/Django-Based-Office-Mnagerment-system/blob/main/photo/Screenshot%20(2636).png)

### Step 2: Code Quality and Security Analysis with SonarQube
- Build the application
- use sonarcube cloud
-  connect the  repo  to sonarcube  cloud
- Ensure the code compiles and all dependencies are installed.
- Run SonarQube Scanner
- Use SonarQube to analyze the code for bugs, code smells, vulnerabilities, and code coverage.
- 
![sonar cube](https://github.com/rukevweubio/Django-Based-Office-Mnagerment-system/blob/main/photo/Screenshot%20(2612).png)


![sonar cube](https://github.com/rukevweubio/Django-Based-Office-Mnagerment-system/blob/main/photo/Screenshot%20(2624).png)

### Introduction to Trivy
Trivy is an open-source vulnerability scanner for containers, code, and infrastructure. It helps identify security issues in Docker images, including outdated packages and known vulnerabilities, so you can fix them before deployment. Trivy is easy to use and integrates seamlessly into your CI/CD workflow for continuous security checks.

![trivy scan](https://github.com/rukevweubio/Django-Based-Office-Mnagerment-system/blob/main/photo/Screenshot%20(2637).png)

