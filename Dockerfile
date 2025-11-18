FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY apps/app.jar /app/app.jar
ENV SPRING_PROFILES_ACTIVE=production
ENV JVM_OPTS="-Xmx512m -Xms256m"
EXPOSE 8085
ENTRYPOINT ["sh", "-c", "java $JVM_OPTS -jar /app/app.jar"]