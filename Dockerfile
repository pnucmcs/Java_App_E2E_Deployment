FROM openjdk:17-jdk-slim
Expose 8081
ADD target/docker-demo.jar docker-demo.jar
ENTRYPOINT [ "java","-jar","docker-demo.jar" ]
