# --- Stage 1: Build the WAR file ---
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Build the project (skip tests to save time)
RUN mvn clean package -DskipTests

# --- Stage 2: Run on Tomcat ---
FROM tomcat:10.1-jdk17-temurin

# Remove the default Tomcat "ROOT" app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy our WAR file to Tomcat as ROOT.war (so it loads at the main URL)
# NOTE: Ensure your pom.xml <artifactId> is "Foodapp" so the file is "Foodapp-1.0-SNAPSHOT.war"
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose the standard Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]