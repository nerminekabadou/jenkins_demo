# build-time image not needed if on CI we build jar then docker image
FROM eclipse-temurin:25-jdk-jammy
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]