# Step 1: Use a clean base system to download Oracle JDK 23 and compile with Maven
FROM ubuntu:22.04 AS build

# Install system utilities, curl, Maven, and download Oracle OpenJDK 23 manually
RUN apt-get update && apt-get install -y curl maven wget && \
    wget https://download.java.net/java/GA/jdk23/external/binaries/openjdk-23_linux-x64_bin.tar.gz && \
    tar -xvf openjdk-23_linux-x64_bin.tar.gz && \
    mv jdk-23 /usr/local/jdk-23

# Configure system environment flags to enforce Java 23 compiler parameters
ENV JAVA_HOME=/usr/local/jdk-23
ENV PATH=$JAVA_HOME/bin:$PATH

# Copy project source files over
COPY . .

# Force compilation with explicit target and source constraints
RUN mvn clean package -DskipTests

# Step 2: Set up the application layer inside a standard Tomcat 11 production block
FROM tomcat:11.0

# Take the compiled war archive from the builder layer and inject it as the core web application root
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]