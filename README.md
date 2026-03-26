# DevOps Technical Assessment

## Overview

This project demonstrates an end-to-end DevOps workflow, including containerization, CI/CD, Helm-based deployment, and local Kubernetes validation.

The goal was to build, package, deploy, and validate a Go-based application using modern DevOps practices.

---

## Tech Stack

* Go (application)
* Docker (multi-stage build)
* Kubernetes (Docker Desktop)
* Helm (application deployment)
* GitHub Actions (CI/CD pipeline)

---
## Project Structure

├── .github/
│   └── workflows/
│       └── ci.yml              # GitHub Actions CI/CD pipeline
│
├── app/                        # Go application source code
│   ├── go.mod
│   └── main.go
│
├── helm/
│   ├── hello-world/            # Application Helm chart
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/
│   │       ├── deployment.yaml # Uses lib-common deployment template
│   │       └── service.yaml    # Uses lib-common service template
│   │
│   └── lib-common/             # Reusable Helm library chart
│       ├── Chart.yaml
│       └── templates/
│           ├── _deployment.tpl # Shared deployment template
│           ├── _service.tpl    # Shared service template
│           └── _helpers.tpl    # Helper functions (labels, naming)
│
├── Dockerfile                 # Multi-stage Docker build
├── .dockerignore              # Excludes unnecessary files from build
├── README.md                  # Project documentation



## Application

### Build Docker Image

```bash
docker build -t hello-app:latest .
```

### Run Locally (optional)

```bash
docker run -p 8080:8080 hello-app:latest
```

### Endpoints

* `/` → Returns application response
* `/healthz` → Health check endpoint

---

## CI/CD Pipeline

Implemented using GitHub Actions with the following stages:

* Helm chart linting
* Dockerfile linting (Hadolint)
* Docker image build

### Key Improvements

* Multi-stage Docker build for smaller image size
* Non-root container user for improved security
* Automated validation of Helm charts

---

## Helm Chart Implementation

A Helm chart was created in:

```
helm/hello-world
```

### Features

* Uses reusable library chart (`lib-common`)
* Deployment and Service defined via shared templates
* Configurable through `values.yaml`
* Includes:

  * Resource requests and limits
  * Liveness and readiness probes (`/healthz`)
  * Service exposure configuration

---

## Fixes Applied to Library Chart (lib-common)

The provided library chart contained multiple issues that prevented successful deployment. These were identified and resolved:

* Fixed incorrect YAML indentation in deployment template
* Corrected container structure (ports incorrectly placed outside container block)
* Ensured proper list formatting using `-` where required
* Aligned probe configuration with application health endpoint
* Verified all templates render valid Kubernetes manifests

These fixes were necessary to ensure Helm linting and deployment success.

---

## Kubernetes Deployment (Bonus)

The application was deployed to a local Kubernetes cluster using Docker Desktop.

### Steps Performed

* Built Docker image locally
* Installed Helm chart
* Exposed service using port-forwarding

### Deploy Command

```bash
helm install hello hello-world
```

### Verify Resources

```bash
kubectl get pods
kubectl get svc
```

### Port Forward

```bash
kubectl port-forward svc/hello-hello-world 8081:80
```

---

## Access Application

* App: http://localhost:8081/
* Health Check: http://localhost:8081/healthz

---

## Verification

### Pods

```bash
kubectl get pods
```

### Services

```bash
kubectl get svc
```
- Pods are running successfully
- Service is exposed and reachable

All resources were verified to be running and healthy.

---

## Screenshots

 following screenshots are of Local deployment

1. Application running at `/`
2. Health check endpoint `/healthz`
3. Output of `kubectl get pods`
4. Output of `kubectl get svc`

---

## Key Learnings

* Debugging Helm templates and resolving YAML structure issues
* Working with reusable Helm library charts
* Building secure and optimized Docker images
* Implementing CI/CD pipelines for validation and automation
* Deploying and validating applications in Kubernetes environments

---

## Conclusion

This project demonstrates the ability to design, build, debug, and deploy a complete DevOps workflow, including handling real-world issues such as broken templates and deployment failures.

---
