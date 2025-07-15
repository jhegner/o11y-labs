# Step 1: Build the application using Maven
#FROM maven:3.9.10-amazoncorretto-21-alpine AS builder
#
#RUN mkdir /build
#WORKDIR /build
#COPY . .
#RUN mvn clean package -DskipTests

# Step 2: Create a minimal runtime image
# FROM amazoncorretto:21-alpine

# WORKDIR /build
# #COPY --from=builder /build/target/o11ylabs.app1.gateway-0.0.1.jar app.jar
# COPY ./target/o11ylabs.app1.gateway-0.0.1.jar app.jar

# EXPOSE 8080

# ENV SERVER_PORT=8080
# ENV SPRING_PROFILES_ACTIVE=dev,prettylog

# ENTRYPOINT ["sh", "-c", "java -jar app.jar --server.port=$SERVER_PORT --spring.profiles.active=$SPRING_PROFILES_ACTIVE"]

# ---- Stage 1: Build with Maven + Corretto 21 ----
FROM amazoncorretto:21 AS builder

# Set env vars
#ENV JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto \
#    MAVEN_VERSION=3.8.7 \
#    MAVEN_HOME=/opt/maven

# Install Maven 3.8.7
#RUN yum install -y curl tar && \
#curl -fsSL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz | tar -xz -C /opt && \
#ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven && \
#    ln -s /opt/maven/bin/mvn /usr/bin/mvn

WORKDIR /app

# Copy pom.xml and download dependencies first
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

RUN mvn --version

# Package the Spring Boot app
RUN mvn clean package -DskipTests

# ---- Stage 2: Runtime using Corretto 21 Alpine ----
FROM amazoncorretto:21-alpine

WORKDIR /app

# Copy the built jar
COPY --from=builder /app/target/*.jar app.jar

# Expose the application port (default: 8080)
EXPOSE 8080

# Allow dynamic profile via environment variable
ENV SPRING_PROFILES_ACTIVE=dev,prettylog
ENV SERVER_PORT=8080

# Run the Spring Boot app with profile support
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.profiles.active=${SPRING_PROFILES_ACTIVE}", "--server.port=${SERVER_PORT}"]
