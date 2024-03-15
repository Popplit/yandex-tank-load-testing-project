FROM eclipse-temurin:11.0.22_7-jdk

RUN apt-get update && apt-get install -y maven

COPY . /api-service
WORKDIR /api-service

CMD ["./mvnw", "spring-boot:run"]
