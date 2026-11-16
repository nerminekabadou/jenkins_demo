# Jenkins CI/CD Pipeline for a Spring Boot App

[![build](https://github.com/nerminekabadou/jenkins_demo/actions/workflows/build.yml/badge.svg)](https://github.com/nerminekabadou/jenkins_demo/actions/workflows/build.yml)

A DevOps lab: a minimal Spring Boot REST service built, tested, containerised and published to Docker Hub by a declarative **Jenkins pipeline**.

## Pipeline ([`Jenkinsfile`](Jenkinsfile))

| Stage | What it does |
|-------|--------------|
| Checkout | `checkout scm` |
| Build | `mvn clean install -DskipTests` |
| Test | `mvn test` and publishes the JUnit reports in Jenkins |
| Docker build | builds the image, tagged `<version>-<yyyymmdd>-<git short sha>` |
| Tag | also tags the image as `latest` |
| Publish | pushes both tags to Docker Hub with the `dockerhub-creds` Jenkins credentials |

The same build and test also run on GitHub Actions ([`.github/workflows/build.yml`](.github/workflows/build.yml)) on every push.

## The application

Spring Boot 3.5, Java 17, one endpoint: `GET /` returns `Hello from Spring Boot!`. A MockMvc test covers it.

```bash
mvn verify                                   # build + tests
docker build -t springboot-jenkins .
docker run -p 8080:8080 springboot-jenkins   # http://localhost:8080
```

## Running the pipeline in Jenkins
1. Install Jenkins with the *Pipeline*, *Docker Pipeline* and *JUnit* plugins. The agent needs Maven, JDK 17 and Docker.
2. Add a *Username with password* credential with the ID `dockerhub-creds` (Docker Hub user and access token).
3. Set `DOCKER_IMAGE` in the `Jenkinsfile` to your Docker Hub repository.
4. Create a *Pipeline from SCM* job pointing at this repository.
