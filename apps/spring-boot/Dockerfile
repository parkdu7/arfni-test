# Multi-stage build for Spring Boot application
# Build stage
FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /build

# Copy Gradle/Maven files first for better caching
COPY gradlew* build.gradle* settings.gradle* gradle.properties* ./
COPY gradle ./gradle 2>/dev/null || true
COPY pom.xml ./pom.xml 2>/dev/null || true

# Make gradlew executable if it exists
RUN if [ -f gradlew ]; then chmod +x gradlew; fi

# Download dependencies (this layer will be cached)
RUN if [ -f gradlew ]; then \
        ./gradlew dependencies --no-daemon || true; \
    elif [ -f pom.xml ]; then \
        ./mvnw dependency:go-offline || true; \
    fi

# Copy source code
COPY src ./src

# Build the application
RUN if [ -f gradlew ]; then \
        ./gradlew clean bootJar --no-daemon; \
    elif [ -f pom.xml ]; then \
        ./mvnw clean package -DskipTests; \
    fi

# Find the built JAR file
RUN find build/libs -name "*.jar" -not -name "*-plain.jar" -exec cp {} app.jar \; 2>/dev/null || \
    find target -name "*.jar" -exec cp {} app.jar \;

# Runtime stage
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Create a non-root user
RUN groupadd -r spring && useradd -r -g spring spring

# Copy the JAR from build stage
COPY --from=builder /build/app.jar ./app.jar

# Set ownership
RUN chown -R spring:spring /app

# Switch to non-root user
USER spring

# Expose port
EXPOSE 8080

# Set environment variables
ENV SPRING_PROFILES_ACTIVE=production
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
