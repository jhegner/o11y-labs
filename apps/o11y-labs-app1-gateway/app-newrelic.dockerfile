# Step 1: Build the application using Maven
FROM maven:3.9.7-eclipse-temurin-24 AS builder

WORKDIR /build
COPY . .
RUN mvn clean package -DskipTests

# Step 2: Create a minimal runtime image
FROM eclipse-temurin:24-jre

WORKDIR /app
COPY --from=builder /build/target/o11ylabs.app1.gateway-0.0.1.jar app.jar

EXPOSE 8080

ENV SERVER_PORT=8080
ENV SPRING_PROFILES_ACTIVE=dev,prettylog

# New Relic does not provide a single agent container for all services like Datadog
ADD https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip /newrelic/
RUN unzip /newrelic/newrelic-java.zip -d /newrelic

ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=${SERVER_PORT}", "--spring.profiles.active=dev,prettylog"]