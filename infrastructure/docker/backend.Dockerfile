FROM eclipse-temurin:21-jdk-jammy AS build
WORKDIR /workspace
COPY backend/mvnw backend/mvnw
COPY backend/.mvn backend/.mvn
COPY backend/pom.xml backend/pom.xml
RUN chmod +x backend/mvnw
COPY backend/src backend/src
COPY database/migrations database/migrations
COPY infrastructure/docker/Healthcheck.java Healthcheck.java
RUN cd backend && ./mvnw --batch-mode --no-transfer-progress -DskipTests package
RUN javac -d /workspace/healthcheck Healthcheck.java

FROM eclipse-temurin:21-jre-jammy
RUN groupadd --gid 10001 iam && useradd --uid 10001 --gid iam --no-create-home iam
WORKDIR /app
COPY --from=build --chown=10001:10001 /workspace/backend/target/iam-backend.jar app.jar
COPY --from=build --chown=10001:10001 /workspace/healthcheck/Healthcheck.class Healthcheck.class
USER 10001:10001
EXPOSE 8080
HEALTHCHECK --interval=15s --timeout=10s --start-period=60s --retries=10 CMD ["java", "-cp", "/app", "Healthcheck"]
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75", "-jar", "/app/app.jar"]
