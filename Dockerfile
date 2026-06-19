# Step 1: Use a widely available Maven image with Java 21 to build the project
FROM maven:3.9.6-eclipse-temurin-21 AS build
COPY . .
RUN mvn clean package -DskipTests

# Step 2: Drop it into an official Tomcat 11 container
FROM tomcat:11.0
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]