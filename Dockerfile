# Runtime Dockerfile for GitHub Actions deployment
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Copy the pre-built JAR file (uploaded by GitHub Actions)
# Path is relative to build context (DEPLOY_ROOT)
COPY apps/app.jar /app/app.jar

ENV SPRING_PROFILES_ACTIVE=production
ENV JVM_OPTS="-Xmx512m -Xms256m"

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JVM_OPTS -jar /app/app.jar"]
