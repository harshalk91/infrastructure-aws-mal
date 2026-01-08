# Java Spring Boot – Dockerized Health Check Service

A minimal **Spring Boot REST API** exposing a `/health` endpoint and packaged using a **multi-stage Docker build** with a **distroless runtime** for security and minimal image size.

---

## Features

- Java 21 (Amazon Corretto)
- Spring Boot 3.x
- Single health endpoint: `GET /health`
- Multi-stage Docker build
- Distroless runtime (non-root by default)
- Production-ready container JVM settings
- Suitable for **ECS Fargate + ALB**

---

## Health Endpoint

```http
GET /health
```

## Response
```
{
  "status": "ok"
}
```

## Project Structure

```
.
├── Dockerfile
├── pom.xml
└── src/
    ├── main/
    │   ├── java/com/example/demo/
    │   │   └── DemoApplication.java
    │   └── resources/
    │       └── application.properties

```
## Docker Image
### Runtime Characteristics

```
Base image: gcr.io/distroless/java21-debian12:nonroot

User: non-root (default)

Port: 8080

Shell: none (reduced attack surface)

Health checking: via ALB / orchestrator

```

### Build the Image
```
docker build -f Dockerfile -t spring-health-app .
```

### Run Locally
```
docker run -p 8080:8080 spring-health-app
```

### Verify
```
curl http://localhost:8080/health
```

### Expected output
```
{"status":"ok"}
```

