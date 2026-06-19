# Step 1: Use a Maven image backed by Amazon Corretto JDK 23
FROM maven:3.9.6-amazoncorretto-23 AS build
COPY . .
RUN mvn clean package -DskipTests

# Step 2: Deploy directly into Tomcat 11 running Java 23
FROM tomcat:11.0-jdk23-corretto
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]