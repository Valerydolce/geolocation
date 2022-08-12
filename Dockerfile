FROM openjdk:8
ADD eks_ecr_geolocation/target/spring-boot-maven-plugin.jar spring-boot-maven-plugin.jar
EXPOSE 8081
ENTRYPOINT ["-java","-jar","spring-boot-maven-plugin.jar"]