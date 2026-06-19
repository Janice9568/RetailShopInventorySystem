# Step 1: Use Maven with OpenJDK 23 to compile your source files
FROM maven:3.9.6-openjdk-23 AS build
COPY . .
RUN mvn clean package -DskipTests

# Step 2: Deploy your compiled .war file into Apache Tomcat 11 (running Java 23)
FROM tomcat:11.0-jdk23
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]