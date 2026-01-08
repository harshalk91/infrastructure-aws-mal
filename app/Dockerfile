# syntax=docker/dockerfile:1

############################
# Build stage
############################
FROM amazoncorretto:21-alpine AS build
WORKDIR /workspace

COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
RUN chmod +x mvnw && ./mvnw -q -DskipTests dependency:go-offline

COPY src ./src
RUN ./mvnw -q -DskipTests package

############################
# Runtime stage (distroless)
############################
FROM gcr.io/distroless/java21-debian12:nonroot AS runtime
WORKDIR /app

COPY --from=build /workspace/target/*.jar /app/app.jar

EXPOSE 8080

# Non-root is default in :nonroot
ENTRYPOINT ["java","-jar","/app/app.jar"]
