FROM openjdk:17-jdk-slim
Expose 8080
ADD target/docker-demo.jar docker-demo.jar
ENTRYPOINT [ "java","-jar","docker-demo.jar" ]
