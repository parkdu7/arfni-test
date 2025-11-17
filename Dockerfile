# Runtime-only Dockerfile for GitHub Actions deployment
# This Dockerfile assumes JAR is already built by GitHub Actions
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Copy the pre-built JAR file (uploaded by GitHub Actions)
# Path is relative to build context (DEPLOY_ROOT)
COPY apps/app.jar /app/app.jar

# Set environment variables
ENV SPRING_PROFILES_ACTIVE=production
ENV JVM_OPTS="-Xmx512m -Xms256m"

# Expose the application port
EXPOSE 8080

# Run the JAR file
ENTRYPOINT ["sh", "-c", "java $JVM_OPTS -jar /app/app.jar"]