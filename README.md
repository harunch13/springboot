# CI/CD Pipeline

This project implements a practical CI/CD pipeline using **GitHub Actions, Maven, SonarQube, Nexus Repository, Docker, Docker Tomcat, and Docker Hub**.

The pipeline was built incrementally and each stage was tested before moving to the next stage.

## Architecture

```text
Developer
    │
    │ git push
    ▼
GitHub
    │
    ▼
GitHub Actions
(Self-hosted Runner)
    │
    ▼
Maven Build
    │
    ├── Compile
    ├── Automated Tests
    └── Production WAR
    │
    ▼
SonarQube
(Code Quality Analysis)
    │
    ▼
Nexus Repository
(Artifact Storage)
    │
    ▼
Docker Tomcat
    │
    ▼
Automated UAT
(HTTP 200)
    │
    ▼
Docker Build
    │
    ▼
Docker Hub
(Container Backup / Registry)
```

---

## Pipeline Stages

### 1. Maven Build

The application is built using the Maven Wrapper:

```bash
./mvnw
```

The pipeline:

* Compiles the application.
* Runs automated tests.
* Packages the application as a WAR.
* Performs a production frontend build.

Current application version:

```text
0.0.1
```

Generated artifact:

```text
great-big-example-application-0.0.1.war
```

---

### 2. SonarQube

SonarQube performs static code analysis on the application.

The pipeline uses:

```text
Java 8 → Application Build
Java 11 → SonarQube Analysis
```

SonarQube helps identify:

* Bugs
* Vulnerabilities
* Code smells
* Duplicated code
* Maintainability issues
* Reliability issues

---

### 3. Nexus Repository

Nexus is used as the Maven artifact repository.

Repositories configured:

```text
maven-releases
maven-snapshots
```

Release artifacts are stored in the release repository while snapshot artifacts are intended for the snapshot repository.

The current release artifact is:

```text
great-big-example-application-0.0.1.war
```

---

### 4. Docker Tomcat UAT

After the WAR is stored in Nexus, the pipeline retrieves the validated artifact and deploys it to a Dockerized Tomcat environment.

Tomcat runs through Docker and exposes the application through:

```text
http://localhost:8090/
```

The pipeline performs an automated HTTP health check.

The UAT succeeds when the application returns:

```text
HTTP 200
```

---

### 5. Docker Image

A Dockerfile packages the application WAR into a Tomcat-based container image.

Base image:

```text
tomcat:9-jdk8
```

The container is configured to run as a non-root user.

Current image:

```text
great-big-example-application:0.0.1
```

---

### 6. Docker Hub

After successful Tomcat UAT, GitHub Actions automatically:

1. Retrieves the validated WAR from Nexus.
2. Builds the Docker image.
3. Authenticates securely with Docker Hub.
4. Pushes the image to Docker Hub.

Docker Hub image:

```text
lukmanabdallah/great-big-example-application:0.0.1
```

Docker Hub therefore provides a remote container registry and disaster-recovery copy of the application image.

---

## CI/CD Workflow

The GitHub Actions workflow is:

```text
Push to main
     ↓
Build, Test and Package
     ↓
SonarQube Analysis
     ↓
Deploy WAR to Nexus
     ↓
Docker Tomcat UAT
     ↓
Build and Push Docker Image
     ↓
Docker Hub
```

The Docker Hub stage depends on successful UAT:

```yaml
needs: tomcat-uat
```

Therefore, an unsuccessful UAT prevents the Docker image from being published.

---

## Security

Sensitive credentials are stored using **GitHub Actions Secrets**.

The pipeline uses secrets for:

```text
SONAR_TOKEN
SONAR_HOST_URL
NEXUS_USERNAME
NEXUS_PASSWORD
DOCKERHUB_USERNAME
DOCKERHUB_TOKEN
```

Docker Hub authentication is performed using:

```bash
docker login --password-stdin
```

Credentials are not hard-coded into the workflow.

---

## Current Pipeline Status

| Stage                             | Status |
| --------------------------------- | ------ |
| GitHub Source Control             | ✅      |
| Self-hosted GitHub Actions Runner | ✅      |
| Maven Build                       | ✅      |
| Automated Tests                   | ✅      |
| Production WAR Packaging          | ✅      |
| SonarQube Analysis                | ✅      |
| Nexus Deployment                  | ✅      |
| Docker Tomcat Deployment          | ✅      |
| Automated UAT                     | ✅      |
| Docker Image Build                | ✅      |
| Docker Hub Push                   | ✅      |

### Current Status

**CI/CD through Docker Hub: OPERATIONAL ✅**

---

## Technical Challenge Solved

The application uses a legacy frontend toolchain involving older Node.js, Yarn, npm and node-sass versions.

The modern system Node.js environment was incompatible with the legacy dependencies.

A compatibility solution was implemented using the project's bundled Node.js and Yarn together with a compatible npm version and required certificate configuration.

This allowed the production frontend assets to be successfully generated and included in the WAR.

---

## Artifact Flow

The project follows this artifact flow:

```text
Source Code
     ↓
Maven Build
     ↓
WAR
     ↓
Nexus
     ↓
Tomcat UAT
     ↓
Docker Image
     ↓
Docker Hub
```

This provides traceability between the application artifact stored in Nexus and the container image published to Docker Hub.

---

## Future Roadmap

The current pipeline will be extended with infrastructure automation.

Planned stages:

```text
GitHub Actions
      ↓
Maven
      ↓
SonarQube
      ↓
Nexus
      ↓
Tomcat UAT
      ↓
Docker Hub
      ↓
Terraform
      ↓
Ansible
      ↓
Minikube
      ↓
Kubernetes
```

### Planned Technologies

* Terraform — Infrastructure as Code
* Ansible — Configuration Management
* Minikube — Local Kubernetes Cluster
* Kubernetes — Container Orchestration

---

## Project Goal

The goal of this project is to build and understand a complete DevOps workflow from source code to automated application delivery.

Rather than simply configuring tools, the project focuses on understanding how each stage connects to the next:

```text
Code
 → Build
 → Test
 → Analyze
 → Store
 → Deploy
 → Validate
 → Containerize
 → Publish
 → Automate Infrastructure
 → Orchestrate
```

This project is being developed incrementally, with each stage tested and verified before introducing the next stage.
