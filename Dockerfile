# Step 1: Use an official, guaranteed JDK 23 image to build the project
FROM eclipse-temurin:23-jdk AS build

# Install Maven inside the JDK 23 environment
RUN apt-get update && apt-get install -y maven

# Copy your project files
COPY . .

# Compile your code using Java 23
RUN mvn clean package -DskipTests

# Step 2: Deploy the compiled .war file into Tomcat 11
FROM tomcat:11.0
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]