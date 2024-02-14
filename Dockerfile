# Use official Maven image as the base image
FROM maven:3.8.4-jdk-11 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml file to the working directory
COPY pom.xml .

# Copy the server folder with source code and pom.xml
COPY server /app/server
# Copy the webapp folder with source code and pom.xml
COPY webapp /app/webapp

# Build the server and webapp modules
RUN mvn clean install

# Stage 2: Create a minimal docker image with the compiled application
FROM adoptopenjdk/openjdk11:alpine-jre

# Set the working directory
WORKDIR /app

# Copy the built artifacts from the build stage
COPY --from=build /app/server/target/server.jar ./server.jar
COPY --from=build /app/webapp/target/webapp.war ./webapp.war

# Expose ports (adjust as needed)
EXPOSE 8080 

# Command to run the server
CMD ["java", "-jar", "server.jar"]
